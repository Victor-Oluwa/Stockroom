import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/money/calculations.dart';
import '../domain/receipt.dart';

abstract class ReceiptRepository {
  Future<Result<ReceiptResult>> receiveStock({
    String? operationKey,
    String? supplierId,
    String? supplierReference,
    String? notes,
    required List<ReceiptLineInput> lines,
    bool zeroCostConfirmed = false,
    DateTime? receivedAt,
  });
  Stream<List<db.StockReceipt>> watchReceipts();
  Future<Result<List<db.StockReceipt>>> searchReceipts(String query);
  Future<Result<db.StockReceipt?>> getReceipt(String id);
  Stream<List<db.StockReceiptLine>> watchLines(String receiptId);
  Future<Result<List<db.StockReceiptLine>>> getLines(String receiptId);
}

class DriftReceiptRepository implements ReceiptRepository {
  DriftReceiptRepository(this._db, [Uuid? ids]) : _ids = ids ?? const Uuid();
  final db.AppDatabase _db;
  final Uuid _ids;

  @override
  Future<Result<ReceiptResult>> receiveStock({
    String? operationKey,
    String? supplierId,
    String? supplierReference,
    String? notes,
    required List<ReceiptLineInput> lines,
    bool zeroCostConfirmed = false,
    DateTime? receivedAt,
  }) async {
    if (lines.isEmpty) {
      return fail(const ValidationFailure('Add at least one product.'));
    }
    for (final l in lines) {
      if (l.quantityMilli <= 0) {
        return fail(
          const ValidationFailure('Quantity must be greater than zero.'),
        );
      }
      if (l.unitCostKobo < 0) {
        return fail(const ValidationFailure('Unit cost cannot be negative.'));
      }
      if (l.unitCostKobo == 0 && !zeroCostConfirmed) {
        return fail(
          const ValidationFailure('Confirm zero-cost items before receiving.'),
        );
      }
    }
    final opKey = operationKey ?? _ids.v4();
    try {
      // Idempotent retry: same operation key returns the posted receipt.
      final prior = await (_db.select(
        _db.stockReceipts,
      )..where((r) => r.idempotencyKey.equals(opKey))).getSingleOrNull();
      if (prior != null) {
        return _resultFor(prior.id);
      }

      String? supplierName;
      if (supplierId != null) {
        final sup = await (_db.select(
          _db.suppliers,
        )..where((s) => s.id.equals(supplierId))).getSingleOrNull();
        if (sup == null) {
          return fail(const ValidationFailure('Supplier no longer exists.'));
        }
        supplierName = sup.name;
      }

      // Merge duplicate product entries: summed qty, qty-weighted unit cost.
      final mergedInputs = _merge(lines);
      final now = (receivedAt ?? DateTime.now()).toUtc();
      final createdAt = DateTime.now().toUtc();

      late String receiptId;
      late String receiptNumber;
      late List<MergedReceiptLine> stored;
      late int total;

      await _db.transaction(() async {
        // Re-validate inside the transaction against live rows.
        final products = <String, db.Product>{};
        for (final m in mergedInputs) {
          final p = await (_db.select(
            _db.products,
          )..where((t) => t.id.equals(m.productId))).getSingleOrNull();
          if (p == null) {
            throw _Abort(
              const ValidationFailure('A product no longer exists.'),
            );
          }
          if (p.isArchived) {
            throw _Abort(
              ValidationFailure(
                '“${p.name}” is archived and cannot receive stock.',
              ),
            );
          }
          products[m.productId] = p;
        }

        // Allocate the human-readable reference from the settings sequence.
        final settingsRow = await (_db.select(
          _db.appSettings,
        )..where((s) => s.id.equals('settings'))).getSingleOrNull();
        final nextSeq = (settingsRow?.lastReceiptSeq ?? 0) + 1;
        receiptNumber = 'SR-${nextSeq.toString().padLeft(4, '0')}';
        receiptId = _ids.v4();
        if (settingsRow == null) {
          await _db
              .into(_db.appSettings)
              .insert(
                db.AppSettingsCompanion.insert(
                  id: 'settings',
                  lastReceiptSeq: Value(nextSeq),
                ),
              );
        } else {
          await (_db.update(_db.appSettings)
                ..where((s) => s.id.equals('settings')))
              .write(db.AppSettingsCompanion(lastReceiptSeq: Value(nextSeq)));
        }

        stored = [];
        total = 0;
        for (final m in mergedInputs) {
          final p = products[m.productId]!;
          final lineCost = roundHalfUpDiv(
            m.quantityMilli * m.unitCostKobo,
            1000,
          );
          final newQty = p.quantityOnHandMilli + m.quantityMilli;
          final newAvg = weightedAverageCostKobo(
            oldQtyMilli: p.quantityOnHandMilli,
            oldAvgCostKobo: p.averageCostKobo,
            receivedQtyMilli: m.quantityMilli,
            receivedUnitCostKobo: m.unitCostKobo,
          );
          total += lineCost;
          stored.add(
            MergedReceiptLine(
              productId: m.productId,
              productName: p.name,
              unitLabel: p.unitLabel,
              quantityMilli: m.quantityMilli,
              unitCostKobo: m.unitCostKobo,
              lineCostKobo: lineCost,
              newQuantityMilli: newQty,
              newAverageCostKobo: newAvg,
            ),
          );
        }

        await _db
            .into(_db.stockReceipts)
            .insert(
              db.StockReceiptsCompanion.insert(
                id: receiptId,
                receiptNumber: receiptNumber,
                receivedAt: now,
                totalCostKobo: total,
                idempotencyKey: opKey,
                createdAt: createdAt,
                supplierId: Value(supplierId),
                supplierNameSnapshot: Value(supplierName),
                supplierReference: Value(_clean(supplierReference)),
                notes: Value(_clean(notes)),
              ),
            );
        for (final s in stored) {
          await _db
              .into(_db.stockReceiptLines)
              .insert(
                db.StockReceiptLinesCompanion.insert(
                  id: _ids.v4(),
                  receiptId: receiptId,
                  productId: s.productId,
                  quantityMilli: s.quantityMilli,
                  unitCostKobo: s.unitCostKobo,
                  lineCostKobo: s.lineCostKobo,
                  productNameSnapshot: s.productName,
                  unitLabelSnapshot: s.unitLabel,
                ),
              );
          await _db
              .into(_db.stockMovements)
              .insert(
                db.StockMovementsCompanion.insert(
                  id: _ids.v4(),
                  productId: s.productId,
                  movementType: 'PURCHASE_RECEIPT',
                  quantityDeltaMilli: s.quantityMilli,
                  occurredAt: now,
                  referenceType: 'stock_receipt',
                  referenceId: receiptId,
                  idempotencyKey: '$opKey:${s.productId}',
                  createdAt: createdAt,
                  unitCostKobo: Value(s.unitCostKobo),
                ),
              );
          await (_db.update(
            _db.products,
          )..where((t) => t.id.equals(s.productId))).write(
            db.ProductsCompanion(
              quantityOnHandMilli: Value(s.newQuantityMilli),
              averageCostKobo: Value(s.newAverageCostKobo),
              updatedAt: Value(createdAt),
            ),
          );
        }
      });

      return ok(
        ReceiptResult(
          receiptId: receiptId,
          receiptNumber: receiptNumber,
          totalCostKobo: total,
          lines: stored,
        ),
      );
    } on _Abort catch (a) {
      return fail(a.failure);
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint')) {
        // Lost race with a concurrent identical commit: return the winner.
        return _resultForOperation(opKey);
      }
      return fail(DatabaseFailure('Could not receive stock.', e));
    }
  }

  /// Merge repeated product entries: sum qty, qty-weighted unit cost.
  List<ReceiptLineInput> _merge(List<ReceiptLineInput> lines) {
    final qtyBy = <String, int>{};
    final costNumerBy = <String, int>{};
    for (final l in lines) {
      qtyBy[l.productId] = (qtyBy[l.productId] ?? 0) + l.quantityMilli;
      costNumerBy[l.productId] =
          (costNumerBy[l.productId] ?? 0) + l.quantityMilli * l.unitCostKobo;
    }
    return [
      for (final id in qtyBy.keys)
        ReceiptLineInput(
          productId: id,
          quantityMilli: qtyBy[id]!,
          unitCostKobo: roundHalfUpDiv(costNumerBy[id]!, qtyBy[id]!),
        ),
    ];
  }

  Future<Result<ReceiptResult>> _resultFor(String receiptId) async {
    try {
      final receipt = await (_db.select(
        _db.stockReceipts,
      )..where((r) => r.id.equals(receiptId))).getSingleOrNull();
      if (receipt == null) {
        return fail(const DatabaseFailure('Could not receive stock.'));
      }
      final lineRows = await (_db.select(
        _db.stockReceiptLines,
      )..where((l) => l.receiptId.equals(receiptId))).get();
      // New quantities are informational; recompute cheaply is unnecessary —
      // fetch current product rows for display instead.
      final lines = <MergedReceiptLine>[];
      for (final l in lineRows) {
        final p = await (_db.select(
          _db.products,
        )..where((t) => t.id.equals(l.productId))).getSingleOrNull();
        lines.add(
          MergedReceiptLine(
            productId: l.productId,
            productName: l.productNameSnapshot,
            unitLabel: l.unitLabelSnapshot,
            quantityMilli: l.quantityMilli,
            unitCostKobo: l.unitCostKobo,
            lineCostKobo: l.lineCostKobo,
            newQuantityMilli: p?.quantityOnHandMilli ?? 0,
            newAverageCostKobo: p?.averageCostKobo ?? 0,
          ),
        );
      }
      return ok(
        ReceiptResult(
          receiptId: receipt.id,
          receiptNumber: receipt.receiptNumber,
          totalCostKobo: receipt.totalCostKobo,
          lines: lines,
        ),
      );
    } catch (e) {
      return fail(DatabaseFailure('Could not receive stock.', e));
    }
  }

  Future<Result<ReceiptResult>> _resultForOperation(String opKey) async {
    final prior = await (_db.select(
      _db.stockReceipts,
    )..where((r) => r.idempotencyKey.equals(opKey))).getSingleOrNull();
    if (prior == null) {
      return fail(const DatabaseFailure('Could not receive stock.'));
    }
    return _resultFor(prior.id);
  }

  @override
  Stream<List<db.StockReceipt>> watchReceipts() {
    final q = _db.select(_db.stockReceipts)
      ..orderBy([(r) => OrderingTerm.desc(r.receivedAt)]);
    return q.watch();
  }

  @override
  Future<Result<List<db.StockReceipt>>> searchReceipts(String query) async {
    try {
      final rows = await (_db.select(
        _db.stockReceipts,
      )..orderBy([(r) => OrderingTerm.desc(r.receivedAt)])).get();
      final needle = query.trim().toLowerCase();
      if (needle.isEmpty) return ok(rows);
      return ok(
        rows
            .where(
              (r) =>
                  r.receiptNumber.toLowerCase().contains(needle) ||
                  (r.supplierReference?.toLowerCase().contains(needle) ??
                      false) ||
                  (r.supplierNameSnapshot?.toLowerCase().contains(needle) ??
                      false),
            )
            .toList(),
      );
    } catch (e) {
      return fail(DatabaseFailure('Could not load receipts.', e));
    }
  }

  @override
  Future<Result<db.StockReceipt?>> getReceipt(String id) async {
    try {
      final row = await (_db.select(
        _db.stockReceipts,
      )..where((r) => r.id.equals(id))).getSingleOrNull();
      return ok(row);
    } catch (e) {
      return fail(DatabaseFailure('Could not load receipt.', e));
    }
  }

  @override
  Stream<List<db.StockReceiptLine>> watchLines(String receiptId) {
    final q = _db.select(_db.stockReceiptLines)
      ..where((l) => l.receiptId.equals(receiptId));
    return q.watch();
  }

  @override
  Future<Result<List<db.StockReceiptLine>>> getLines(String receiptId) async {
    try {
      final rows = await (_db.select(
        _db.stockReceiptLines,
      )..where((l) => l.receiptId.equals(receiptId))).get();
      return ok(rows);
    } catch (e) {
      return fail(DatabaseFailure('Could not load receipt lines.', e));
    }
  }

  String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }
}

/// Transaction abort with a typed user-facing failure.
class _Abort implements Exception {
  _Abort(this.failure);
  final AppFailure failure;
}
