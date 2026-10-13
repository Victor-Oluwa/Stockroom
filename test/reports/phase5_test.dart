import 'dart:io';
import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:stockroom/core/csv/csv.dart';
import 'package:stockroom/core/database/app_database.dart';
import 'package:stockroom/core/dates/date_range.dart';
import 'package:stockroom/core/notifications/transitions.dart';
import 'package:stockroom/features/expenses/data/expense_repository.dart';
import 'package:stockroom/features/inventory/data/product_repository.dart';
import 'package:stockroom/features/inventory/domain/product.dart';
import 'package:stockroom/features/onboarding/domain/business_profile.dart';
import 'package:stockroom/features/reports/data/report_csv.dart';
import 'package:stockroom/features/reports/data/report_pdf.dart';
import 'package:stockroom/features/reports/data/reports_repository.dart';
import 'package:stockroom/features/reports/domain/calculations.dart';
import 'package:stockroom/features/sales/data/sale_repository.dart';
import 'package:stockroom/features/sales/domain/sale.dart';
import 'package:stockroom/features/stock_movements/data/adjustment_repository.dart';
import 'package:stockroom/features/stock_movements/domain/adjustment.dart';
import 'package:stockroom/features/stock_receiving/data/receipt_repository.dart';
import 'package:stockroom/features/stock_receiving/domain/receipt.dart';

AppDatabase _memoryDb() => AppDatabase.forTesting(NativeDatabase.memory());

ReportsRepository _reports(AppDatabase db) =>
    ReportsRepository(db, DriftExpenseRepository(db));

void main() {
  group('date ranges (PRD 11.1)', () {
    test('day bounds: start inclusive, next midnight exclusive', () {
      final r = LocalDateRange.day(DateTime(2024, 3, 1, 15));
      expect(r.containsLocal(DateTime(2024, 3, 1)), isTrue);
      expect(r.containsLocal(DateTime(2024, 3, 1, 23, 59, 59)), isTrue);
      expect(r.containsLocal(DateTime(2024, 3, 2)), isFalse);
      expect(r.containsLocal(DateTime(2024, 2, 29, 23, 59)), isFalse);
    });

    test('month ends, leap day and year ends', () {
      final feb = LocalDateRange.month(DateTime(2024, 2, 15));
      expect(feb.containsLocal(DateTime(2024, 2, 29, 12)), isTrue);
      expect(feb.containsLocal(DateTime(2024, 3, 1)), isFalse);

      final dec = LocalDateRange.month(DateTime(2023, 12, 10));
      expect(dec.containsLocal(DateTime(2023, 12, 31, 23, 59)), isTrue);
      expect(dec.containsLocal(DateTime(2024, 1, 1)), isFalse);

      final lastMo = presetRange(
        ReportPreset.lastMonth,
        now: DateTime(2024, 1, 15),
      );
      expect(lastMo.containsLocal(DateTime(2023, 12, 25)), isTrue);
      expect(lastMo.containsLocal(DateTime(2024, 1, 5)), isFalse);

      final week = LocalDateRange.lastDays(7, now: DateTime(2024, 3, 8));
      expect(week.containsLocal(DateTime(2024, 3, 2)), isTrue);
      expect(week.containsLocal(DateTime(2024, 3, 1)), isFalse);
    });
  });

  group('CSV encoder', () {
    test('escapes commas, quotes and line breaks', () {
      final csv = encodeCsv(
        const ['name', 'note'],
        [
          ['Plain', 'ok'],
          ['With, comma', 'say "hi"'],
          ['Multi\nline', 'a\rb'],
        ],
      );
      final lines = csv.trim().split('\n');
      expect(lines.first, 'name,note');
      expect(lines[1], 'Plain,ok');
      expect(lines[2], '"With, comma","say ""hi"""');
      expect(csv, contains('"Multi\nline"'));
    });
  });

  group('alert transitions (PRD §6.9)', () {
    StockTransition t(int oldQ, int newQ, [int th = 5000]) => StockTransition(
      productId: 'p',
      productName: 'Chair',
      oldQtyMilli: oldQ,
      newQtyMilli: newQ,
      thresholdMilli: th,
    );

    test('crossings notify exactly once per transition', () {
      expect(t(6000, 4000).shouldNotify, isTrue); // into low
      expect(t(6000, 0).crossedOut, isTrue); // into out
      expect(t(4000, 3000).shouldNotify, isFalse); // stays low
      expect(t(0, 0).shouldNotify, isFalse); // stays out
      expect(t(6000, 7000).shouldNotify, isFalse); // replenish
      expect(t(4000, 6000).shouldNotify, isFalse); // back above
      expect(
        t(6000, 4000, 0).shouldNotify,
        isFalse,
      ); // threshold 0 disables low
    });

    test('replenish arms the next dip again', () {
      // Dip → notify, replenish → quiet, dip again → notify.
      expect(t(6000, 4000).shouldNotify, isTrue);
      expect(t(4000, 9000).shouldNotify, isFalse);
      expect(t(9000, 4000).shouldNotify, isTrue);
    });

    test('sale emits transitions; threshold-zero never lows', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      await products.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1500000,
        openingQtyMilli: 6000,
        openingUnitCostKobo: 1000000,
      );
      final chair = (await products.listProducts(
        const ProductListFilter(),
      )).getOrElse((_) => throw StateError('x')).single;
      final done = await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair.id,
            quantityMilli: 2000,
            unitPriceKobo: 1500000,
          ),
        ],
        paymentMethod: 'Cash',
      );
      final transitions = done
          .getOrElse((_) => throw StateError('x'))
          .transitions;
      expect(transitions.length, 1);
      expect(transitions.single.crossedLow, isTrue);
    });

    test('adjustment decrease to zero emits crossedOut', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final adjustments = DriftAdjustmentRepository(db);
      await products.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1500000,
        openingQtyMilli: 2000,
        openingUnitCostKobo: 1000000,
      );
      final chair = (await products.listProducts(
        const ProductListFilter(),
      )).getOrElse((_) => throw StateError('x')).single;
      final r = await adjustments.adjust(
        productId: chair.id,
        direction: AdjustmentDirection.decrease,
        quantityMilli: 2000,
        reason: 'Damaged',
      );
      expect(
        r.getOrElse((_) => throw StateError('x')).transition?.crossedOut,
        isTrue,
      );
    });
  });

  group('Phase 5 gate: one logic for screen, PDF and CSV', () {
    Future<(String, String)> fixtures(AppDatabase db) async {
      final products = DriftProductRepository(db);
      final sales = DriftSaleRepository(db);
      final receipts = DriftReceiptRepository(db);
      final expenses = DriftExpenseRepository(db);

      final chair = (await products.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1500000,
        openingQtyMilli: 50000,
        openingUnitCostKobo: 1000000,
      )).getOrElse((_) => throw StateError('c'));
      final table = (await products.createProduct(
        name: 'Table',
        unitLabel: 'piece',
        sellingPriceKobo: 2000000,
        openingQtyMilli: 2000,
        openingUnitCostKobo: 1200000,
      )).getOrElse((_) => throw StateError('t'));

      // Completed sale: 3 chairs @15000, no discount.
      await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: chair.id,
            quantityMilli: 3000,
            unitPriceKobo: 1500000,
          ),
        ],
        paymentMethod: 'Cash',
      );
      // Voided sale: excluded from revenue and COGS.
      final voided = (await sales.completeSale(
        lines: [
          SaleLineInput(
            productId: table.id,
            quantityMilli: 1000,
            unitPriceKobo: 2000000,
          ),
        ],
        paymentMethod: 'Card',
      )).getOrElse((_) => throw StateError('v'));
      await sales.voidSale(saleId: voided.saleId, reason: 'Test');

      // Receipt spend must NOT appear as an operating expense.
      await receipts.receiveStock(
        lines: [
          ReceiptLineInput(
            productId: chair.id,
            quantityMilli: 10000,
            unitCostKobo: 1100000,
          ),
        ],
      );
      await expenses.record(
        amountKobo: 500000,
        category: 'Transport',
        day: DateTime.now(),
        paymentMethod: 'Cash',
        note: 'Delivery van',
      );
      return (chair.id, table.id);
    }

    test('summary, products, profit and valuation agree', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      await fixtures(db);
      final repo = _reports(db);
      final now = DateTime.now().toUtc();
      final from = now.subtract(const Duration(days: 1));
      final to = now.add(const Duration(days: 1));

      final summary = await repo.salesSummary(from, to);
      expect(summary.netSalesKobo, 4500000);
      expect(summary.transactionCount, 1);
      expect(summary.averageSaleKobo, 4500000);
      expect(summary.voidedCount, 1);

      final rows = await repo.productSales(from, to);
      expect(rows.length, 1);
      expect(rows.single.productName, 'Chair');
      expect(rows.single.quantityMilli, 3000);
      expect(rows.single.netSalesKobo, 4500000);
      expect(rows.single.cogsKobo, 3000000);
      expect(rows.single.grossProfitKobo, 1500000);

      final profit = await repo.profit(from, to);
      expect(profit.netSalesKobo, 4500000);
      expect(profit.cogsKobo, 3000000);
      expect(profit.grossProfitKobo, 1500000);
      expect(profit.operatingExpensesKobo, 500000);
      expect(profit.operatingProfitKobo, 1000000);
      expect(profit.costsComplete, isTrue);

      final products = DriftProductRepository(db);
      final all = (await products.listProducts(
        const ProductListFilter(showArchived: true),
      )).getOrElse((_) => throw StateError('x'));
      final valuation = valuateStock(all);
      // Chair 57 @1017544 → 58,000,008; Table 2 @1200000 → 2,400,000.
      expect(valuation.totalKobo, 58000008 + 2400000);
    });

    test('CSV carries the same totals; PDF builds offline', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      await fixtures(db);
      final repo = _reports(db);
      final now = DateTime.now().toUtc();
      final from = now.subtract(const Duration(days: 1));
      final to = now.add(const Duration(days: 1));

      final sales = await repo.allSalesInRange(from, to);
      final salesCsv = salesDetailCsv(sales);
      expect(salesCsv, contains('sale_number,sold_at'));
      expect(salesCsv, contains('4500000'));
      expect(salesCsv, contains('VOIDED'));

      final rows = await repo.productSales(from, to);
      final prodCsv = productSalesCsv(rows);
      expect(prodCsv, contains('Chair'));
      expect(prodCsv, contains('3000'));
      expect(prodCsv, contains('1500000'));

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
      final summary = await repo.salesSummary(from, to);
      final profit = await repo.profit(from, to);
      final bytes = await buildSalesReportPdf(
        business: const BusinessProfile(id: 'b', businessName: 'Test Shop'),
        periodLabel: 'test period',
        generatedAt: DateTime.now(),
        summary: summary,
        products: rows,
        profit: profit,
        expenses: const [],
        regularFont: regular,
        boldFont: bold,
      );
      expect(bytes.lengthInBytes, greaterThan(500));
      expect(String.fromCharCodes(bytes.take(5)), '%PDF-');
    });
  });

  group('expenses', () {
    test('amount must be positive; edit keeps ledger intact', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final products = DriftProductRepository(db);
      final expenses = DriftExpenseRepository(db);

      expect(
        (await expenses.record(
          amountKobo: 0,
          category: 'Rent',
          day: DateTime.now(),
          paymentMethod: 'Cash',
        )).isLeft(),
        isTrue,
      );
      final created = (await expenses.record(
        amountKobo: 250000,
        category: 'Rent',
        day: DateTime.now(),
        paymentMethod: 'Bank Transfer',
        note: 'Shop rent',
      )).getOrElse((_) => throw StateError('x'));

      await products.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1500000,
        openingQtyMilli: 10000,
        openingUnitCostKobo: 1000000,
      );
      // Editing the expense changes reports, never movements.
      await expenses.update(
        id: created.id,
        amountKobo: 300000,
        category: 'Rent',
        day: DateTime.now(),
        paymentMethod: 'Bank Transfer',
      );
      final chair = (await products.listProducts(
        const ProductListFilter(),
      )).getOrElse((_) => throw StateError('x')).single;
      final moves = await products.watchMovements(chair.id).first;
      expect(moves.length, 1);
      expect(moves.single.movementType, 'OPENING_STOCK');

      await expenses.remove(created.id);
      final remaining = await expenses.list();
      expect(remaining.getOrElse((_) => throw StateError('x')), isEmpty);
    });
  });
}
