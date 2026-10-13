import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stockroom/core/database/app_database.dart';
import 'package:stockroom/features/inventory/data/product_repository.dart';
import 'package:stockroom/features/onboarding/domain/business_profile.dart';
import 'package:stockroom/features/sales/data/receipt_pdf.dart';
import 'package:stockroom/features/sales/data/sale_repository.dart';
import 'package:stockroom/features/sales/domain/sale.dart';
import 'package:stockroom/features/stock_receiving/data/receipt_repository.dart';
import 'package:stockroom/features/stock_receiving/domain/receipt.dart';

AppDatabase _memoryDb() => AppDatabase.forTesting(NativeDatabase.memory());

Future<(String, String)> _twoProducts(DriftProductRepository products) async {
  final a = await products.createProduct(
    name: 'Chair',
    unitLabel: 'piece',
    sellingPriceKobo: 1500000,
    openingQtyMilli: 50000,
    openingUnitCostKobo: 1000000,
  );
  final b = await products.createProduct(
    name: 'Table',
    unitLabel: 'piece',
    sellingPriceKobo: 2000000,
    openingQtyMilli: 2000,
    openingUnitCostKobo: 1200000,
  );
  return (
    a.getOrElse((_) => throw StateError('a')).id,
    b.getOrElse((_) => throw StateError('b')).id,
  );
}

void main() {
  group('Scenario B — sale is all-or-nothing', () {
    test('insufficient second line leaves no trace', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final (chair, table) = await _twoProducts(products);

      final r = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair,
            quantityMilli: 1000,
            unitPriceKobo: 1500000,
          ),
          SaleLineInput(
            productId: table,
            quantityMilli: 999000,
            unitPriceKobo: 2000000,
          ),
        ],
        paymentMethod: 'Cash',
      );
      expect(r.isLeft(), isTrue);

      final all = await sales.searchSales('');
      expect(all.getOrElse((_) => throw StateError('x')), isEmpty);
      final chairAfter = (await products.getProduct(
        chair,
      )).getOrElse((_) => throw StateError('x'))!;
      final tableAfter = (await products.getProduct(
        table,
      )).getOrElse((_) => throw StateError('x'))!;
      expect(chairAfter.quantityOnHandMilli, 50000);
      expect(tableAfter.quantityOnHandMilli, 2000);
      expect((await products.watchMovements(chair, limit: 10).first).length, 1);
      expect((await products.watchMovements(table, limit: 10).first).length, 1);
    });

    test('discount above line total fails cleanly', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final (chair, _) = await _twoProducts(products);
      final r = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair,
            quantityMilli: 1000,
            unitPriceKobo: 1500000,
            discountKobo: 2000000,
          ),
        ],
        paymentMethod: 'Cash',
      );
      expect(r.isLeft(), isTrue);
      expect(
        (await sales.searchSales('')).getOrElse((_) => throw StateError('x')),
        isEmpty,
      );
    });
  });

  group('Scenario C — double submit', () {
    test('same operation key commits once', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final (chair, _) = await _twoProducts(products);
      final lines = [
        SaleLineInput(
          productId: chair,
          quantityMilli: 3000,
          unitPriceKobo: 1500000,
        ),
      ];
      final a = await sales.completeSale(
        operationKey: 'op-1',
        lines: lines,
        paymentMethod: 'Cash',
      );
      final b = await sales.completeSale(
        operationKey: 'op-1',
        lines: lines,
        paymentMethod: 'Cash',
      );
      expect(a.isRight() && b.isRight(), isTrue);
      expect(
        a.getOrElse((_) => throw StateError('x')).saleId,
        b.getOrElse((_) => throw StateError('x')).saleId,
      );
      final after = (await products.getProduct(
        chair,
      )).getOrElse((_) => throw StateError('x'))!;
      expect(after.quantityOnHandMilli, 47000);
      final moves = await products.watchMovements(chair, limit: 10).first;
      expect(moves.where((m) => m.movementType == 'SALE').length, 1);
    });
  });

  group('Scenario D — full void', () {
    test('void restores stock once, blocks second void', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final receipts = DriftReceiptRepository(db);
      final (chair, _) = await _twoProducts(products);

      final done = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair,
            quantityMilli: 4000,
            unitPriceKobo: 1500000,
          ),
        ],
        paymentMethod: 'Cash',
      );
      final saleId = done.getOrElse((_) => throw StateError('x')).saleId;

      // Change average cost after the sale: receive 6 @ 2000.
      // Stock 46 @1000000 + 6 @2000000 → 58000000/52 = 1115384.6 → 1115385.
      await receipts.receiveStock(
        lines: [
          ReceiptLineInput(
            productId: chair,
            quantityMilli: 6000,
            unitCostKobo: 2000000,
          ),
        ],
      );

      final voided = await sales.voidSale(
        saleId: saleId,
        reason: 'Customer return',
      );
      expect(voided.isRight(), isTrue);
      final again = await sales.voidSale(saleId: saleId, reason: 'Again');
      expect(again.isLeft(), isTrue);

      // 52 @1115385 + 4 @1000000 → 62000020/56 = 1107143.2 → 1107143.
      final after = (await products.getProduct(
        chair,
      )).getOrElse((_) => throw StateError('x'))!;
      expect(after.quantityOnHandMilli, 56000);
      expect(after.averageCostKobo, 1107143);

      final moves = await products.watchMovements(chair, limit: 10).first;
      final reversals = moves
          .where((m) => m.movementType == 'SALE_VOID_REVERSAL')
          .toList();
      expect(reversals.length, 1);
      expect(reversals.single.reason, 'Sale voided');
      expect(reversals.single.note, 'Customer return');

      // Voided excluded from completed-only search.
      final completed = await sales.searchSales('', includeVoided: false);
      expect(completed.getOrElse((_) => throw StateError('x')), isEmpty);
      final withVoided = await sales.searchSales('');
      expect(withVoided.getOrElse((_) => throw StateError('x')).length, 1);
    });

    test('void requires a reason', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final (chair, _) = await _twoProducts(products);
      final done = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair,
            quantityMilli: 1000,
            unitPriceKobo: 1500000,
          ),
        ],
        paymentMethod: 'Cash',
      );
      final saleId = done.getOrElse((_) => throw StateError('x')).saleId;
      expect(
        (await sales.voidSale(saleId: saleId, reason: '  ')).isLeft(),
        isTrue,
      );
    });
  });

  group('Scenarios E/F — history is immutable', () {
    test('price and cost changes do not rewrite sale snapshots', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final receipts = DriftReceiptRepository(db);
      final (chair, _) = await _twoProducts(products);

      final done = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair,
            quantityMilli: 2000,
            unitPriceKobo: 1500000,
            discountKobo: 50000,
          ),
        ],
        paymentMethod: 'Cash',
      );
      final saleId = done.getOrElse((_) => throw StateError('x')).saleId;

      // Later: price → ₦17,000 and new receipt reprices average.
      await products.updateDetails(
        id: chair,
        name: 'Armchair',
        unitLabel: 'piece',
        sellingPriceKobo: 1700000,
        lowStockThresholdMilli: 5000,
      );
      await receipts.receiveStock(
        lines: [
          ReceiptLineInput(
            productId: chair,
            quantityMilli: 10000,
            unitCostKobo: 1300000,
          ),
        ],
      );

      final lines = await sales.getLines(saleId);
      final l = lines.getOrElse((_) => throw StateError('x')).single;
      expect(l.productName, 'Chair');
      expect(l.unitPriceKobo, 1500000);
      expect(l.discountKobo, 50000);
      expect(l.netLineTotalKobo, 2950000);
      expect(l.unitCostSnapshotKobo, 1000000);
      expect(l.cogsTotalKobo, 2000000);
    });
  });

  group('sale guards', () {
    test('duplicate lines cannot oversell in aggregate', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final stool = (await products.createProduct(
        name: 'Stool',
        unitLabel: 'piece',
        sellingPriceKobo: 500000,
        openingQtyMilli: 5000,
        openingUnitCostKobo: 300000,
      )).getOrElse((_) => throw StateError('x'));

      // Each line alone fits stock 5; together they need 8.
      final r = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: stool.id,
            quantityMilli: 4000,
            unitPriceKobo: 500000,
          ),
          SaleLineInput(
            productId: stool.id,
            quantityMilli: 4000,
            unitPriceKobo: 500000,
          ),
        ],
        paymentMethod: 'Cash',
      );
      expect(r.isLeft(), isTrue);
      final after = (await products.getProduct(
        stool.id,
      )).getOrElse((_) => throw StateError('x'))!;
      expect(after.quantityOnHandMilli, 5000);
      expect(
        (await sales.searchSales('')).getOrElse((_) => throw StateError('x')),
        isEmpty,
      );
    });

    test('archived product cannot be sold; stale qty rechecked', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final (chair, _) = await _twoProducts(products);
      await products.archive(chair, confirmedWithStock: true);

      final r = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair,
            quantityMilli: 1000,
            unitPriceKobo: 1500000,
          ),
        ],
        paymentMethod: 'Cash',
      );
      expect(r.isLeft(), isTrue);
    });

    test('line discount bounded 0..gross, totals are pure sums', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final (chair, table) = await _twoProducts(products);
      final done = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair,
            quantityMilli: 1500,
            unitPriceKobo: 1500000,
            discountKobo: 50000,
          ),
          SaleLineInput(
            productId: table,
            quantityMilli: 1000,
            unitPriceKobo: 2000000,
          ),
        ],
        paymentMethod: 'Bank Transfer',
        customerName: 'Ada',
      );
      final res = done.getOrElse((_) => throw StateError('x'));
      // Chair gross 2250000, Table gross 2000000 → subtotal 4250000,
      // discount 50000 → total 4200000.
      expect(res.subtotalKobo, 4250000);
      expect(res.discountTotalKobo, 50000);
      expect(res.totalKobo, 4200000);
      expect(res.saleNumber, 'S-0001');
    });
  });

  group('receipt PDF', () {
    test('builds offline from snapshots with business header', () async {
      // Bundled fonts (same files the app loads via rootBundle).
      final regular = pw.Font.ttf(
        ByteData.sublistView(
          await File('assets/fonts/DejaVuSans.ttf').readAsBytes(),
        ),
      );
      final bold = pw.Font.ttf(
        ByteData.sublistView(
          await File('assets/fonts/DejaVuSans-Bold.ttf').readAsBytes(),
        ),
      );
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final (chair, _) = await _twoProducts(products);
      final done = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair,
            quantityMilli: 2000,
            unitPriceKobo: 1500000,
            discountKobo: 50000,
          ),
        ],
        paymentMethod: 'Cash',
        customerName: 'Ada',
      );
      final saleId = done.getOrElse((_) => throw StateError('x')).saleId;
      final sale = (await sales.getSale(
        saleId,
      )).getOrElse((_) => throw StateError('x'))!;
      final lines = (await sales.getLines(
        saleId,
      )).getOrElse((_) => throw StateError('x'));
      for (final layout in ReceiptLayout.values) {
        final bytes = await buildReceiptPdf(
          business: const BusinessProfile(
            id: 'b1',
            businessName: 'Test Shop',
            receiptFooter: 'Thanks!',
          ),
          sale: sale,
          lines: lines,
          layout: layout,
          regularFont: regular,
          boldFont: bold,
        );
        expect(bytes.lengthInBytes, greaterThan(500));
        expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
      }
    });
  });
}
