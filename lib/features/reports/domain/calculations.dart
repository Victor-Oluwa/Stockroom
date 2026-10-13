import 'package:equatable/equatable.dart';

import '../../../core/database/app_database.dart' as db;
import '../../expenses/domain/expense.dart';
import '../../inventory/domain/product.dart';
import '../../sales/domain/sale.dart';

/// Single source of truth for every money figure in the app (PRD §7.5,
/// §6.12). Dashboard, report screen, PDF and CSV all call these pure
/// functions over the same fetched rows — never separate widget math.
///
/// Conventions:
/// - Only `COMPLETED` sales count; voided sales are tallied separately.
/// - Net sales = Σ net line totals (after discounts). COGS = Σ stored
///   sale-time snapshots (never today's average). Receipt spend is NOT an
///   operating expense and is never subtracted here.
/// - All amounts integer kobo; quantities integer milli.
class SalesSummary extends Equatable {
  const SalesSummary({
    required this.netSalesKobo,
    required this.transactionCount,
    required this.averageSaleKobo,
    required this.byDay,
    required this.voidedCount,
  });

  final int netSalesKobo;
  final int transactionCount;
  final int averageSaleKobo;

  /// Day key `yyyy-MM-dd` (local) → net sales, ascending.
  final Map<String, int> byDay;
  final int voidedCount;

  @override
  List<Object?> get props => [
    netSalesKobo,
    transactionCount,
    averageSaleKobo,
    byDay,
    voidedCount,
  ];
}

String _dayKey(DateTime local) =>
    '${local.year.toString().padLeft(4, '0')}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')}';

SalesSummary summarizeSales(List<db.Sale> sales) {
  final completed = sales.where((s) => s.status == 'COMPLETED').toList();
  final net = completed.fold<int>(0, (s, r) => s + r.totalKobo);
  final byDay = <String, int>{};
  for (final s in completed) {
    final key = _dayKey(s.soldAt.toLocal());
    byDay[key] = (byDay[key] ?? 0) + s.totalKobo;
  }
  final sortedDays = Map.fromEntries(
    byDay.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
  );
  return SalesSummary(
    netSalesKobo: net,
    transactionCount: completed.length,
    averageSaleKobo: completed.isEmpty ? 0 : net ~/ completed.length,
    byDay: sortedDays,
    voidedCount: sales.where((s) => s.status == 'VOIDED').length,
  );
}

class ProductSalesRow extends Equatable {
  const ProductSalesRow({
    required this.productId,
    required this.productName,
    required this.quantityMilli,
    required this.netSalesKobo,
    required this.cogsKobo,
  });

  final String productId;
  final String productName;
  final int quantityMilli;
  final int netSalesKobo;
  final int cogsKobo;

  int get grossProfitKobo => netSalesKobo - cogsKobo;

  @override
  List<Object?> get props => [
    productId,
    productName,
    quantityMilli,
    netSalesKobo,
    cogsKobo,
  ];
}

/// Quantity sold + net value by product, from immutable line snapshots.
List<ProductSalesRow> productSales(List<SaleLineView> lines) {
  final qty = <String, int>{};
  final net = <String, int>{};
  final cogs = <String, int>{};
  final names = <String, String>{};
  for (final l in lines) {
    qty[l.productId] = (qty[l.productId] ?? 0) + l.quantityMilli;
    net[l.productId] = (net[l.productId] ?? 0) + l.netLineTotalKobo;
    cogs[l.productId] = (cogs[l.productId] ?? 0) + l.cogsTotalKobo;
    names[l.productId] = l.productName;
  }
  final rows = [
    for (final id in qty.keys)
      ProductSalesRow(
        productId: id,
        productName: names[id] ?? 'Unknown',
        quantityMilli: qty[id]!,
        netSalesKobo: net[id]!,
        cogsKobo: cogs[id]!,
      ),
  ];
  rows.sort((a, b) => b.netSalesKobo.compareTo(a.netSalesKobo));
  return rows;
}

class ProfitEstimate extends Equatable {
  const ProfitEstimate({
    required this.netSalesKobo,
    required this.cogsKobo,
    required this.grossProfitKobo,
    required this.operatingExpensesKobo,
    required this.operatingProfitKobo,
    required this.costsComplete,
  });

  final int netSalesKobo;
  final int cogsKobo;
  final int grossProfitKobo;
  final int operatingExpensesKobo;
  final int operatingProfitKobo;

  /// False when legacy/imported lines lack cost snapshots — v1 records
  /// always carry costs, so this stays true; the UI still labels profit
  /// "Estimated" (PRD §7.5).
  final bool costsComplete;

  @override
  List<Object?> get props => [
    netSalesKobo,
    cogsKobo,
    grossProfitKobo,
    operatingExpensesKobo,
    operatingProfitKobo,
    costsComplete,
  ];
}

ProfitEstimate estimateProfit({
  required List<db.Sale> completedSales,
  required List<SaleLineView> completedLines,
  required List<Expense> expenses,
}) {
  final net = completedSales.fold<int>(0, (s, r) => s + r.totalKobo);
  final cogs = completedLines.fold<int>(0, (s, l) => s + l.cogsTotalKobo);
  final gross = net - cogs;
  final exp = expenses.fold<int>(0, (s, e) => s + e.amountKobo);
  return ProfitEstimate(
    netSalesKobo: net,
    cogsKobo: cogs,
    grossProfitKobo: gross,
    operatingExpensesKobo: exp,
    operatingProfitKobo: gross - exp,
    costsComplete: true,
  );
}

class ExpenseSlice extends Equatable {
  const ExpenseSlice({required this.category, required this.totalKobo});
  final String category;
  final int totalKobo;

  @override
  List<Object?> get props => [category, totalKobo];
}

List<ExpenseSlice> expensesByCategory(List<Expense> expenses) {
  final totals = <String, int>{};
  for (final e in expenses) {
    totals[e.category] = (totals[e.category] ?? 0) + e.amountKobo;
  }
  final rows = [
    for (final entry in totals.entries)
      ExpenseSlice(category: entry.key, totalKobo: entry.value),
  ];
  rows.sort((a, b) => b.totalKobo.compareTo(a.totalKobo));
  return rows;
}

class ValuationRow extends Equatable {
  const ValuationRow({
    required this.productId,
    required this.productName,
    required this.quantityMilli,
    required this.unitLabel,
    required this.averageCostKobo,
    required this.valueKobo,
  });

  final String productId;
  final String productName;
  final int quantityMilli;
  final String unitLabel;
  final int averageCostKobo;
  final int valueKobo;

  @override
  List<Object?> get props => [
    productId,
    productName,
    quantityMilli,
    unitLabel,
    averageCostKobo,
    valueKobo,
  ];
}

class StockValuation extends Equatable {
  const StockValuation({required this.rows, required this.totalKobo});
  final List<ValuationRow> rows;
  final int totalKobo;

  @override
  List<Object?> get props => [rows, totalKobo];
}

/// Current quantity × current moving-average cost (PRD §7.4).
StockValuation valuateStock(List<Product> products) {
  final rows = <ValuationRow>[];
  var total = 0;
  for (final p in products.where((p) => !p.isArchived)) {
    final value = p.quantityOnHandMilli == 0
        ? 0
        : (p.quantityOnHandMilli * p.averageCostKobo + 500) ~/ 1000;
    total += value;
    rows.add(
      ValuationRow(
        productId: p.id,
        productName: p.name,
        quantityMilli: p.quantityOnHandMilli,
        unitLabel: p.unitLabel,
        averageCostKobo: p.averageCostKobo,
        valueKobo: value,
      ),
    );
  }
  rows.sort((a, b) => b.valueKobo.compareTo(a.valueKobo));
  return StockValuation(rows: rows, totalKobo: total);
}
