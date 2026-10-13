import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockroom/core/database/app_database.dart';
import 'package:stockroom/features/inventory/data/product_repository.dart';
import 'package:stockroom/features/stock_movements/data/adjustment_repository.dart';
import 'package:stockroom/features/stock_movements/domain/adjustment.dart';
import 'package:stockroom/features/stock_receiving/data/receipt_repository.dart';
import 'package:stockroom/features/stock_receiving/domain/receipt.dart';
import 'package:stockroom/features/stock_receiving/presentation/receive_cubit.dart';
import 'package:stockroom/features/suppliers/data/supplier_repository.dart';

AppDatabase _memoryDb() => AppDatabase.forTesting(NativeDatabase.memory());

Future<String> _chair(AppDatabase db, DriftProductRepository products) async {
  final created = await products.createProduct(
    name: 'Chair',
    unitLabel: 'piece',
    sellingPriceKobo: 1500000,
    openingQtyMilli: 50000,
    openingUnitCostKobo: 1000000,
  );
  return created.getOrElse((_) => throw StateError('setup failed')).id;
}

void main() {
  group('Phase 3 gate: 50 → out 3 → receive 10 → 57', () {
    test('ledger explains the balance and avg cost follows formula', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final adjustments = DriftAdjustmentRepository(db);
      final receipts = DriftReceiptRepository(db);

      final id = await _chair(db, products);

      // -3 via explicit adjustment (sale path lands in Phase 4).
      final adj = await adjustments.adjust(
        productId: id,
        direction: AdjustmentDirection.decrease,
        quantityMilli: 3000,
        reason: 'Internal use',
      );
      expect(adj.isRight(), isTrue);

      // +10 @ ₦11,000.
      final rec = await receipts.receiveStock(
        lines: [
          ReceiptLineInput(
            productId: id,
            quantityMilli: 10000,
            unitCostKobo: 1100000,
          ),
        ],
      );
      expect(rec.isRight(), isTrue);

      final got = await products.getProduct(id);
      final p = got.getOrElse((_) => throw StateError('left'))!;
      expect(p.quantityOnHandMilli, 57000);

      // Avg: (47000×1000000 + 10000×1100000)/57000 = 1017543.86 → 1017544.
      expect(p.averageCostKobo, 1017544);

      final deltas = await products.watchMovements(id, limit: 10).first;
      // Order-independent: same-millisecond timestamps have no defined
      // order, so compare the multiset, not the sequence.
      expect(deltas.map((m) => m.quantityDeltaMilli).toList()..sort(), [
        -3000,
        10000,
        50000,
      ]);
      expect(deltas.map((m) => m.movementType).toSet(), {
        'OPENING_STOCK',
        'ADJUSTMENT_OUT',
        'PURCHASE_RECEIPT',
      });

      final integrity = await products.checkIntegrity();
      expect(integrity.getOrElse((_) => throw StateError('left')), isEmpty);
    });
  });

  group('receipt atomicity', () {
    test('bad second line rolls back header, lines, movements, qtys', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final receipts = DriftReceiptRepository(db);
      final id = await _chair(db, products);

      final r = await receipts.receiveStock(
        lines: [
          ReceiptLineInput(
            productId: id,
            quantityMilli: 5000,
            unitCostKobo: 1000000,
          ),
          const ReceiptLineInput(
            productId: 'missing',
            quantityMilli: 5000,
            unitCostKobo: 1000,
          ),
        ],
      );
      expect(r.isLeft(), isTrue);

      final allReceipts = await receipts.searchReceipts('');
      expect(allReceipts.getOrElse((_) => throw StateError('left')), isEmpty);
      final got = await products.getProduct(id);
      expect(
        got.getOrElse((_) => throw StateError('left'))!.quantityOnHandMilli,
        50000,
      );
      final movements = await products.watchMovements(id, limit: 10).first;
      expect(movements.length, 1); // opening only
    });

    test('duplicate lines merge into one movement per product', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final receipts = DriftReceiptRepository(db);
      final id = await _chair(db, products);

      final r = await receipts.receiveStock(
        lines: [
          ReceiptLineInput(
            productId: id,
            quantityMilli: 4000,
            unitCostKobo: 1000000,
          ),
          ReceiptLineInput(
            productId: id,
            quantityMilli: 6000,
            unitCostKobo: 1100000,
          ),
        ],
      );
      expect(r.isRight(), isTrue);
      final movements = await products.watchMovements(id, limit: 10).first;
      final receiptMoves = movements.where(
        (m) => m.movementType == 'PURCHASE_RECEIPT',
      );
      expect(receiptMoves.length, 1);
      expect(receiptMoves.single.quantityDeltaMilli, 10000);
      // Weighted: (4000×1000000+6000×1100000)/10000 = 1060000.
      expect(receiptMoves.single.unitCostKobo, 1060000);
    });

    test('same operation key cannot duplicate a receipt', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final receipts = DriftReceiptRepository(db);
      final id = await _chair(db, products);

      final lines = [
        ReceiptLineInput(
          productId: id,
          quantityMilli: 5000,
          unitCostKobo: 1000000,
        ),
      ];
      final a = await receipts.receiveStock(operationKey: 'op-1', lines: lines);
      final b = await receipts.receiveStock(operationKey: 'op-1', lines: lines);
      expect(a.isRight() && b.isRight(), isTrue);
      expect(
        a.getOrElse((_) => throw StateError('x')).receiptId,
        b.getOrElse((_) => throw StateError('x')).receiptId,
      );
      final got = await products.getProduct(id);
      expect(
        got.getOrElse((_) => throw StateError('left'))!.quantityOnHandMilli,
        55000,
      );
    });

    test('zero cost needs confirmation; numbers sequence SR-0001…', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final receipts = DriftReceiptRepository(db);
      final id = await _chair(db, products);

      final denied = await receipts.receiveStock(
        lines: [
          ReceiptLineInput(productId: id, quantityMilli: 1000, unitCostKobo: 0),
        ],
      );
      expect(denied.isLeft(), isTrue);
      final okRes = await receipts.receiveStock(
        lines: [
          ReceiptLineInput(productId: id, quantityMilli: 1000, unitCostKobo: 0),
        ],
        zeroCostConfirmed: true,
      );
      expect(okRes.isRight(), isTrue);
      expect(
        okRes.getOrElse((_) => throw StateError('x')).receiptNumber,
        'SR-0001',
      );
    });
  });

  group('adjustments', () {
    test('decrease beyond stock is blocked with no writes', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final adjustments = DriftAdjustmentRepository(db);
      final id = await _chair(db, products);

      final r = await adjustments.adjust(
        productId: id,
        direction: AdjustmentDirection.decrease,
        quantityMilli: 999000,
        reason: 'Lost',
      );
      expect(r.isLeft(), isTrue);
      final got = await products.getProduct(id);
      expect(
        got.getOrElse((_) => throw StateError('left'))!.quantityOnHandMilli,
        50000,
      );
      final moves = await products.watchMovements(id, limit: 10).first;
      expect(moves.length, 1);
    });

    test('Other without note rejected; increase reprices avg', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final adjustments = DriftAdjustmentRepository(db);
      final id = await _chair(db, products);

      final noNote = await adjustments.adjust(
        productId: id,
        direction: AdjustmentDirection.increase,
        quantityMilli: 1000,
        unitCostKobo: 1000000,
        reason: 'Other',
      );
      expect(noNote.isLeft(), isTrue);

      final okAdj = await adjustments.adjust(
        productId: id,
        direction: AdjustmentDirection.increase,
        quantityMilli: 50000,
        unitCostKobo: 1200000,
        reason: 'Found stock',
        note: 'Back room',
      );
      expect(okAdj.isRight(), isTrue);
      final got = await products.getProduct(id);
      // (50000×1000000 + 50000×1200000)/100000 = 1100000.
      expect(
        got.getOrElse((_) => throw StateError('left'))!.averageCostKobo,
        1100000,
      );
      final adjRow = await adjustments.getAdjustment(
        okAdj.getOrElse((_) => throw StateError('x')).adjustmentId,
      );
      expect(
        adjRow.getOrElse((_) => throw StateError('left'))?.adjustmentNumber,
        'ADJ-0001',
      );
    });
  });

  group('suppliers', () {
    test('receipt keeps supplier snapshot after archive', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final receipts = DriftReceiptRepository(db);
      final suppliers = DriftSupplierRepository(db);
      final id = await _chair(db, products);

      final sup = await suppliers.create(name: 'Lagos Woods');
      final supId = sup.getOrElse((_) => throw StateError('x')).id;
      final rec = await receipts.receiveStock(
        supplierId: supId,
        lines: [
          ReceiptLineInput(
            productId: id,
            quantityMilli: 1000,
            unitCostKobo: 1000000,
          ),
        ],
      );
      expect(rec.isRight(), isTrue);
      await suppliers.archive(supId);

      final receiptId = rec.getOrElse((_) => throw StateError('x')).receiptId;
      final stored = await receipts.getReceipt(receiptId);
      expect(
        stored.getOrElse((_) => throw StateError('left'))?.supplierNameSnapshot,
        'Lagos Woods',
      );
      final spend = await suppliers.totalSpendKobo(supId);
      expect(spend.getOrElse((_) => -1), 1000000);
    });
  });

  group('receive cubit', () {
    test(
      'empty cart surfaces a clear error, success after correction',
      () async {
        final db = _memoryDb();
        addTearDown(db.close);
        final products = DriftProductRepository(db);
        final cubit = ReceiveStockCubit(DriftReceiptRepository(db));
        addTearDown(cubit.close);

        await cubit.submit(lines: [], zeroCostConfirmed: false);
        expect(cubit.state, isA<ReceiveError>());

        final id = await _chair(db, products);
        await cubit.submit(
          lines: [
            ReceiptLineInput(
              productId: id,
              quantityMilli: 2000,
              unitCostKobo: 1000000,
            ),
          ],
          zeroCostConfirmed: false,
        );
        expect(cubit.state, isA<ReceiveSuccess>());
      },
    );
  });
}
