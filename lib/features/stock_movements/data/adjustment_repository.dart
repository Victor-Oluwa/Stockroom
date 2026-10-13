import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/money/calculations.dart';
import '../../../core/notifications/transitions.dart';
import '../domain/adjustment.dart';

abstract class AdjustmentRepository {
  Future<Result<AdjustmentResult>> adjust({
    String? operationKey,
    required String productId,
    required AdjustmentDirection direction,
    required int quantityMilli,
    int? unitCostKobo,
    required String reason,
    String? note,
    DateTime? occurredAt,
  });
  Future<Result<db.StockAdjustment?>> getAdjustment(String id);
  Stream<List<db.StockAdjustment>> watchAdjustmentsFor(
    String productId, {
    int limit = 50,
  });
}

class DriftAdjustmentRepository implements AdjustmentRepository {
  DriftAdjustmentRepository(this._db, [Uuid? ids]) : _ids = ids ?? const Uuid();
  final db.AppDatabase _db;
  final Uuid _ids;

  @override
  Future<Result<AdjustmentResult>> adjust({
    String? operationKey,
    required String productId,
    required AdjustmentDirection direction,
    required int quantityMilli,
    int? unitCostKobo,
    required String reason,
    String? note,
    DateTime? occurredAt,
  }) async {
    if (quantityMilli <= 0) {
      return fail(
        const ValidationFailure('Quantity must be greater than zero.'),
      );
    }
    if (!adjustmentReasons.contains(reason)) {
      return fail(const ValidationFailure('Select a valid reason.'));
    }
    final cleanNote = note?.trim();
    if (reason == 'Other' && (cleanNote == null || cleanNote.isEmpty)) {
      return fail(
        const ValidationFailure('Add a note explaining this adjustment.'),
      );
    }
    if (direction == AdjustmentDirection.increase) {
      if (unitCostKobo == null) {
        return fail(
          const ValidationFailure('Unit cost is required for stock increases.'),
        );
      }
      if (unitCostKobo < 0) {
        return fail(const ValidationFailure('Unit cost cannot be negative.'));
      }
    }
    final opKey = operationKey ?? _ids.v4();
    try {
      final prior = await (_db.select(
        _db.stockAdjustments,
      )..where((a) => a.idempotencyKey.equals(opKey))).getSingleOrNull();
      if (prior != null) {
        return _resultFor(prior);
      }

      final now = (occurredAt ?? DateTime.now()).toUtc();
      final createdAt = DateTime.now().toUtc();
      late String adjId;
      late String adjNumber;
      late int newQty;
      late int newAvg;
      StockTransition? transition;

      await _db.transaction(() async {
        final p = await (_db.select(
          _db.products,
        )..where((t) => t.id.equals(productId))).getSingleOrNull();
        if (p == null) {
          throw _Abort(const ProductNotFound());
        }
        if (p.isArchived) {
          throw _Abort(
            ValidationFailure(
              '“${p.name}” is archived and cannot be adjusted.',
            ),
          );
        }
        if (direction == AdjustmentDirection.decrease &&
            p.quantityOnHandMilli < quantityMilli) {
          throw _Abort(
            const ValidationFailure('Adjustment would make stock negative.'),
          );
        }

        final isIncrease = direction == AdjustmentDirection.increase;
        newQty = isIncrease
            ? p.quantityOnHandMilli + quantityMilli
            : p.quantityOnHandMilli - quantityMilli;
        newAvg = isIncrease
            ? weightedAverageCostKobo(
                oldQtyMilli: p.quantityOnHandMilli,
                oldAvgCostKobo: p.averageCostKobo,
                receivedQtyMilli: quantityMilli,
                receivedUnitCostKobo: unitCostKobo!,
              )
            : p.averageCostKobo;

        final settingsRow = await (_db.select(
          _db.appSettings,
        )..where((s) => s.id.equals('settings'))).getSingleOrNull();
        final nextSeq = (settingsRow?.lastAdjustmentSeq ?? 0) + 1;
        adjNumber = 'ADJ-${nextSeq.toString().padLeft(4, '0')}';
        adjId = _ids.v4();
        if (settingsRow == null) {
          await _db
              .into(_db.appSettings)
              .insert(
                db.AppSettingsCompanion.insert(
                  id: 'settings',
                  lastAdjustmentSeq: Value(nextSeq),
                ),
              );
        } else {
          await (_db.update(
            _db.appSettings,
          )..where((s) => s.id.equals('settings'))).write(
            db.AppSettingsCompanion(lastAdjustmentSeq: Value(nextSeq)),
          );
        }

        await _db
            .into(_db.stockAdjustments)
            .insert(
              db.StockAdjustmentsCompanion.insert(
                id: adjId,
                adjustmentNumber: adjNumber,
                productId: productId,
                adjustmentType: isIncrease ? 'ADJUSTMENT_IN' : 'ADJUSTMENT_OUT',
                quantityMilli: quantityMilli,
                occurredAt: now,
                reason: reason,
                idempotencyKey: opKey,
                createdAt: createdAt,
                unitCostKobo: Value(
                  isIncrease ? unitCostKobo : p.averageCostKobo,
                ),
                note: Value(cleanNote?.isEmpty == true ? null : cleanNote),
              ),
            );
        await _db
            .into(_db.stockMovements)
            .insert(
              db.StockMovementsCompanion.insert(
                id: _ids.v4(),
                productId: productId,
                movementType: isIncrease ? 'ADJUSTMENT_IN' : 'ADJUSTMENT_OUT',
                quantityDeltaMilli: isIncrease ? quantityMilli : -quantityMilli,
                occurredAt: now,
                referenceType: 'adjustment',
                referenceId: adjId,
                idempotencyKey: '$opKey:$productId',
                createdAt: createdAt,
                unitCostKobo: Value(
                  isIncrease ? unitCostKobo! : p.averageCostKobo,
                ),
              ),
            );
        await (_db.update(
          _db.products,
        )..where((t) => t.id.equals(productId))).write(
          db.ProductsCompanion(
            quantityOnHandMilli: Value(newQty),
            averageCostKobo: Value(newAvg),
            updatedAt: Value(createdAt),
          ),
        );
        transition = detectTransition(
          productId: productId,
          productName: p.name,
          oldQtyMilli: p.quantityOnHandMilli,
          newQtyMilli: newQty,
          thresholdMilli: p.lowStockThresholdMilli,
        );
      });

      return ok(
        AdjustmentResult(
          adjustmentId: adjId,
          adjustmentNumber: adjNumber,
          productId: productId,
          newQuantityMilli: newQty,
          newAverageCostKobo: newAvg,
          transition: transition,
        ),
      );
    } on _Abort catch (a) {
      return fail(a.failure);
    } catch (e) {
      if (e.toString().contains('UNIQUE constraint')) {
        final prior = await (_db.select(
          _db.stockAdjustments,
        )..where((a) => a.idempotencyKey.equals(opKey))).getSingleOrNull();
        if (prior != null) return _resultFor(prior);
      }
      return fail(DatabaseFailure('Could not save adjustment.', e));
    }
  }

  Future<Result<AdjustmentResult>> _resultFor(db.StockAdjustment row) async {
    try {
      final p = await (_db.select(
        _db.products,
      )..where((t) => t.id.equals(row.productId))).getSingleOrNull();
      return ok(
        AdjustmentResult(
          adjustmentId: row.id,
          adjustmentNumber: row.adjustmentNumber,
          productId: row.productId,
          newQuantityMilli: p?.quantityOnHandMilli ?? 0,
          newAverageCostKobo: p?.averageCostKobo ?? row.unitCostKobo ?? 0,
        ),
      );
    } catch (e) {
      return fail(DatabaseFailure('Could not save adjustment.', e));
    }
  }

  @override
  Future<Result<db.StockAdjustment?>> getAdjustment(String id) async {
    try {
      final row = await (_db.select(
        _db.stockAdjustments,
      )..where((a) => a.id.equals(id))).getSingleOrNull();
      return ok(row);
    } catch (e) {
      return fail(DatabaseFailure('Could not load adjustment.', e));
    }
  }

  @override
  Stream<List<db.StockAdjustment>> watchAdjustmentsFor(
    String productId, {
    int limit = 50,
  }) {
    final q = _db.select(_db.stockAdjustments)
      ..where((a) => a.productId.equals(productId))
      ..orderBy([(a) => OrderingTerm.desc(a.occurredAt)])
      ..limit(limit);
    return q.watch();
  }
}

class _Abort implements Exception {
  _Abort(this.failure);
  final AppFailure failure;
}
