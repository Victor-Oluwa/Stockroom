import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/money/calculations.dart';
import '../../../core/notifications/transitions.dart';
import '../domain/sale.dart';

abstract class SaleRepository {
  Future<Result<SaleResult>> completeSale({
    String? operationKey,
    required List<SaleLineInput> lines,
    required String paymentMethod,
    String? customerName,
    String? note,
    DateTime? soldAt,
  });
  Future<Result<void>> voidSale({
    required String saleId,
    required String reason,
  });
  Stream<List<db.Sale>> watchSales({bool includeVoided = true});
  Future<Result<List<db.Sale>>> searchSales(
    String query, {
    bool includeVoided = true,
    DateTime? from,
    DateTime? to,
  });
  Future<Result<db.Sale?>> getSale(String id);
  Stream<db.Sale?> watchSale(String id);
  Future<Result<List<SaleLineView>>> getLines(String saleId);
  Stream<List<SaleLineView>> watchLines(String saleId);
}

class DriftSaleRepository implements SaleRepository {
  DriftSaleRepository(this._db, [Uuid? ids]) : _ids = ids ?? const Uuid();
  final db.AppDatabase _db;
  final Uuid _ids;

  @override
  Future<Result<SaleResult>> completeSale({
    String? operationKey,
    required List<SaleLineInput> lines,
    required String paymentMethod,
    String? customerName,
    String? note,
    DateTime? soldAt,
  }) async {
    if (lines.isEmpty) {
      return fail(const ValidationFailure('Add at least one item.'));
    }
    if (!paymentMethods.contains(paymentMethod)) {
      return fail(const ValidationFailure('Select a payment method.'));
    }
    for (final l in lines) {
      if (l.quantityMilli <= 0) {
        return fail(
          const ValidationFailure('Quantity must be greater than zero.'),
        );
      }
      if (l.unitPriceKobo < 0 || l.discountKobo < 0) {
        return fail(
          const ValidationFailure('Price and discount cannot be negative.'),
        );
      }
      final gross = roundHalfUpDiv(l.quantityMilli * l.unitPriceKobo, 1000);
      if (l.discountKobo > gross) {
        return fail(
          const ValidationFailure('Discount cannot exceed the line total.'),
        );
      }
    }
    final opKey = operationKey ?? _ids.v4();
    try {
      final prior = await (_db.select(
        _db.sales,
      )..where((s) => s.idempotencyKey.equals(opKey))).getSingleOrNull();
      if (prior != null) {
        return ok(
          SaleResult(
            saleId: prior.id,
            saleNumber: prior.saleNumber,
            subtotalKobo: prior.subtotalKobo,
            discountTotalKobo: prior.discountTotalKobo,
            totalKobo: prior.totalKobo,
          ),
        );
      }

      final now = (soldAt ?? DateTime.now()).toUtc();
      final createdAt = DateTime.now().toUtc();
      late String saleId;
      late String saleNumber;
      late int subtotal;
      late int discountTotal;
      late int total;
      List<StockTransition> transitions = const [];

      await _db.transaction(() async {
        // Aggregate duplicate rows per product BEFORE checking: per-line
        // checks would let two lines each pass against the same balance
        // and drive stock negative (e.g. stock 5, lines of 4 + 4).
        final qtyByProduct = <String, int>{};
        for (final l in lines) {
          qtyByProduct[l.productId] =
              (qtyByProduct[l.productId] ?? 0) + l.quantityMilli;
        }
        final products = <String, db.Product>{};
        for (final entry in qtyByProduct.entries) {
          final p = await (_db.select(
            _db.products,
          )..where((t) => t.id.equals(entry.key))).getSingleOrNull();
          if (p == null) {
            throw _Abort(const ProductNotFound());
          }
          if (p.isArchived) {
            throw _Abort(
              ValidationFailure('“${p.name}” is archived and cannot be sold.'),
            );
          }
          // Re-check live stock inside the transaction (PRD §6.7).
          if (p.quantityOnHandMilli < entry.value) {
            throw _Abort(
              ValidationFailure(
                'Not enough stock for “${p.name}” (have ${_milli(p.quantityOnHandMilli)}, need ${_milli(entry.value)}).',
              ),
            );
          }
          products[entry.key] = p;
        }

        subtotal = 0;
        discountTotal = 0;
        total = 0;
        final settingsRow = await (_db.select(
          _db.appSettings,
        )..where((s) => s.id.equals('settings'))).getSingleOrNull();
        final nextSeq = (settingsRow?.lastSaleSeq ?? 0) + 1;
        saleNumber = 'S-${nextSeq.toString().padLeft(4, '0')}';
        saleId = _ids.v4();
        if (settingsRow == null) {
          await _db
              .into(_db.appSettings)
              .insert(
                db.AppSettingsCompanion.insert(
                  id: 'settings',
                  lastSaleSeq: Value(nextSeq),
                ),
              );
        } else {
          await (_db.update(_db.appSettings)
                ..where((s) => s.id.equals('settings')))
              .write(db.AppSettingsCompanion(lastSaleSeq: Value(nextSeq)));
        }

        // Per-line computed values (same pure functions as the preview).
        final computed = <_ComputedLine>[];
        for (final l in lines) {
          final p = products[l.productId]!;
          final gross = roundHalfUpDiv(l.quantityMilli * l.unitPriceKobo, 1000);
          final net = gross - l.discountKobo;
          final cogs = roundHalfUpDiv(
            l.quantityMilli * p.averageCostKobo,
            1000,
          );
          subtotal += gross;
          discountTotal += l.discountKobo;
          total += net;
          computed.add(
            _ComputedLine(
              input: l,
              product: p,
              gross: gross,
              net: net,
              cogs: cogs,
            ),
          );
        }

        await _db
            .into(_db.sales)
            .insert(
              db.SalesCompanion.insert(
                id: saleId,
                saleNumber: saleNumber,
                soldAt: now,
                paymentMethod: paymentMethod,
                subtotalKobo: subtotal,
                discountTotalKobo: discountTotal,
                totalKobo: total,
                idempotencyKey: opKey,
                createdAt: createdAt,
                customerName: Value(_clean(customerName)),
                note: Value(_clean(note)),
              ),
            );
        for (final c in computed) {
          await _db
              .into(_db.saleLines)
              .insert(
                db.SaleLinesCompanion.insert(
                  id: _ids.v4(),
                  saleId: saleId,
                  productId: c.input.productId,
                  productNameSnapshot: c.product.name,
                  unitLabelSnapshot: c.product.unitLabel,
                  quantityMilli: c.input.quantityMilli,
                  unitPriceKobo: c.input.unitPriceKobo,
                  grossLineTotalKobo: c.gross,
                  discountKobo: c.input.discountKobo,
                  netLineTotalKobo: c.net,
                  unitCostSnapshotKobo: c.product.averageCostKobo,
                  cogsTotalKobo: c.cogs,
                  skuSnapshot: Value(c.product.sku),
                ),
              );
        }
        // One aggregated SALE movement per product (quantities already
        // summed in qtyByProduct above).
        final crossed = <StockTransition>[];
        for (final entry in qtyByProduct.entries) {
          final p = products[entry.key]!;
          final t = detectTransition(
            productId: entry.key,
            productName: p.name,
            oldQtyMilli: p.quantityOnHandMilli,
            newQtyMilli: p.quantityOnHandMilli - entry.value,
            thresholdMilli: p.lowStockThresholdMilli,
          );
          if (t != null) crossed.add(t);
          await _db
              .into(_db.stockMovements)
              .insert(
                db.StockMovementsCompanion.insert(
                  id: _ids.v4(),
                  productId: entry.key,
                  movementType: 'SALE',
                  quantityDeltaMilli: -entry.value,
                  occurredAt: now,
                  referenceType: 'sale',
                  referenceId: saleId,
                  idempotencyKey: '$opKey:${entry.key}',
                  createdAt: createdAt,
                  unitCostKobo: Value(p.averageCostKobo),
                ),
              );
          await (_db.update(
            _db.products,
          )..where((t) => t.id.equals(entry.key))).write(
            db.ProductsCompanion(
              quantityOnHandMilli: Value(p.quantityOnHandMilli - entry.value),
              updatedAt: Value(createdAt),
            ),
          );
        }
        transitions = crossed;
      });

      return ok(
        SaleResult(
          saleId: saleId,
          saleNumber: saleNumber,
          subtotalKobo: subtotal,
          discountTotalKobo: discountTotal,
          totalKobo: total,
          transitions: transitions,
        ),
      );
    } on _Abort catch (a) {
      return fail(a.failure);
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint')) {
        final prior = await (_db.select(
          _db.sales,
        )..where((s) => s.idempotencyKey.equals(opKey))).getSingleOrNull();
        if (prior != null) {
          return ok(
            SaleResult(
              saleId: prior.id,
              saleNumber: prior.saleNumber,
              subtotalKobo: prior.subtotalKobo,
              discountTotalKobo: prior.discountTotalKobo,
              totalKobo: prior.totalKobo,
            ),
          );
        }
      }
      return fail(DatabaseFailure('Could not complete sale.', e));
    }
  }

  @override
  Future<Result<void>> voidSale({
    required String saleId,
    required String reason,
  }) async {
    if (reason.trim().isEmpty) {
      return fail(const ValidationFailure('A reason is required to void.'));
    }
    try {
      await _db.transaction(() async {
        final sale = await (_db.select(
          _db.sales,
        )..where((s) => s.id.equals(saleId))).getSingleOrNull();
        if (sale == null) {
          throw _Abort(const ValidationFailure('Sale not found.'));
        }
        if (sale.status == 'VOIDED') {
          throw _Abort(const SaleAlreadyVoided());
        }
        final lineRows = await (_db.select(
          _db.saleLines,
        )..where((l) => l.saleId.equals(saleId))).get();
        final now = DateTime.now().toUtc();
        for (final l in lineRows) {
          final p = await (_db.select(
            _db.products,
          )..where((t) => t.id.equals(l.productId))).getSingleOrNull();
          if (p == null) {
            throw _Abort(const ProductNotFound());
          }
          final newQty = p.quantityOnHandMilli + l.quantityMilli;
          final newAvg = voidRestoredAverageCostKobo(
            currentQtyMilli: p.quantityOnHandMilli,
            currentAvgCostKobo: p.averageCostKobo,
            returnedQtyMilli: l.quantityMilli,
            returnedUnitCostKobo: l.unitCostSnapshotKobo,
          );
          await _db
              .into(_db.stockMovements)
              .insert(
                db.StockMovementsCompanion.insert(
                  id: _ids.v4(),
                  productId: l.productId,
                  movementType: 'SALE_VOID_REVERSAL',
                  quantityDeltaMilli: l.quantityMilli,
                  occurredAt: now,
                  referenceType: 'sale',
                  referenceId: saleId,
                  idempotencyKey: 'void:$saleId:${l.productId}',
                  createdAt: now,
                  unitCostKobo: Value(l.unitCostSnapshotKobo),
                  // Ledger rows carry the void reason (PRD §6.6).
                  reason: const Value('Sale voided'),
                  note: Value(reason.trim()),
                ),
              );
          await (_db.update(
            _db.products,
          )..where((t) => t.id.equals(l.productId))).write(
            db.ProductsCompanion(
              quantityOnHandMilli: Value(newQty),
              averageCostKobo: Value(newAvg),
              updatedAt: Value(now),
            ),
          );
        }
        await (_db.update(_db.sales)..where((s) => s.id.equals(saleId))).write(
          db.SalesCompanion(
            status: const Value('VOIDED'),
            voidedAt: Value(now),
            voidReason: Value(reason.trim()),
          ),
        );
      });
      return ok(null);
    } on _Abort catch (a) {
      return fail(a.failure);
    } catch (e) {
      return fail(DatabaseFailure('Could not void sale.', e));
    }
  }

  @override
  Stream<List<db.Sale>> watchSales({bool includeVoided = true}) {
    final q = _db.select(_db.sales)
      ..orderBy([(s) => OrderingTerm.desc(s.soldAt)]);
    if (!includeVoided) q.where((s) => s.status.equals('COMPLETED'));
    return q.watch();
  }

  @override
  Future<Result<List<db.Sale>>> searchSales(
    String query, {
    bool includeVoided = true,
    DateTime? from,
    DateTime? to,
  }) async {
    try {
      final q = _db.select(_db.sales)
        ..orderBy([(s) => OrderingTerm.desc(s.soldAt)]);
      if (!includeVoided) q.where((s) => s.status.equals('COMPLETED'));
      if (from != null) q.where((s) => s.soldAt.isBiggerOrEqualValue(from));
      // Exclusive end, matching reports/expenses: a sale exactly at the
      // next midnight belongs to the next day, not this range.
      if (to != null) q.where((s) => s.soldAt.isSmallerThanValue(to));
      final rows = await q.get();
      final needle = query.trim().toLowerCase();
      if (needle.isEmpty) return ok(rows);
      return ok(
        rows
            .where(
              (s) =>
                  s.saleNumber.toLowerCase().contains(needle) ||
                  (s.customerName?.toLowerCase().contains(needle) ?? false),
            )
            .toList(),
      );
    } catch (e) {
      return fail(DatabaseFailure('Could not load sales.', e));
    }
  }

  @override
  Future<Result<db.Sale?>> getSale(String id) async {
    try {
      final row = await (_db.select(
        _db.sales,
      )..where((s) => s.id.equals(id))).getSingleOrNull();
      return ok(row);
    } catch (e) {
      return fail(DatabaseFailure('Could not load sale.', e));
    }
  }

  @override
  Stream<db.Sale?> watchSale(String id) {
    final q = _db.select(_db.sales)..where((s) => s.id.equals(id));
    return q.watchSingleOrNull();
  }

  SaleLineView _lineView(db.SaleLine r) => SaleLineView(
    id: r.id,
    productId: r.productId,
    productName: r.productNameSnapshot,
    sku: r.skuSnapshot,
    unitLabel: r.unitLabelSnapshot,
    quantityMilli: r.quantityMilli,
    unitPriceKobo: r.unitPriceKobo,
    grossLineTotalKobo: r.grossLineTotalKobo,
    discountKobo: r.discountKobo,
    netLineTotalKobo: r.netLineTotalKobo,
    unitCostSnapshotKobo: r.unitCostSnapshotKobo,
    cogsTotalKobo: r.cogsTotalKobo,
  );

  @override
  Future<Result<List<SaleLineView>>> getLines(String saleId) async {
    try {
      final rows = await (_db.select(
        _db.saleLines,
      )..where((l) => l.saleId.equals(saleId))).get();
      return ok(rows.map(_lineView).toList());
    } catch (e) {
      return fail(DatabaseFailure('Could not load sale lines.', e));
    }
  }

  @override
  Stream<List<SaleLineView>> watchLines(String saleId) {
    final q = _db.select(_db.saleLines)..where((l) => l.saleId.equals(saleId));
    return q.watch().map((rows) => rows.map(_lineView).toList());
  }

  String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  String _milli(int milli) {
    final whole = milli ~/ 1000;
    var frac = (milli % 1000)
        .toString()
        .padLeft(3, '0')
        .replaceAll(RegExp(r'0+$'), '');
    return frac.isEmpty ? '$whole' : '$whole.$frac';
  }
}

class _ComputedLine {
  _ComputedLine({
    required this.input,
    required this.product,
    required this.gross,
    required this.net,
    required this.cogs,
  });
  final SaleLineInput input;
  final db.Product product;
  final int gross;
  final int net;
  final int cogs;
}

class _Abort implements Exception {
  _Abort(this.failure);
  final AppFailure failure;
}
