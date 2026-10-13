import '../../../core/database/app_database.dart' as db;
import '../../expenses/data/expense_repository.dart';
import '../../sales/domain/sale.dart';
import '../domain/calculations.dart' as calc;

/// Range-scoped projections. Pure math lives in `calculations.dart`;
/// this class only fetches the rows (PRD §9.4, §6.12).
class ReportsRepository {
  ReportsRepository(this._db, this._expenses);
  final db.AppDatabase _db;
  final ExpenseRepository _expenses;

  /// Completed sales whose instant falls in [fromUtc, toUtc).
  Future<List<db.Sale>> completedSalesInRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) async {
    final rows = await (_db.select(
      _db.sales,
    )..where((s) => s.status.equals('COMPLETED'))).get();
    return rows
        .where((s) => !s.soldAt.isBefore(fromUtc) && s.soldAt.isBefore(toUtc))
        .toList();
  }

  /// All sales (completed + voided) in range for the voided-count row.
  Future<List<db.Sale>> allSalesInRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) async {
    final rows = await _db.select(_db.sales).get();
    return rows
        .where((s) => !s.soldAt.isBefore(fromUtc) && s.soldAt.isBefore(toUtc))
        .toList();
  }

  /// Immutable lines for completed sales in range (COGS snapshots).
  Future<List<SaleLineView>> completedLinesInRange(
    DateTime fromUtc,
    DateTime toUtc,
  ) async {
    final sales = await completedSalesInRange(fromUtc, toUtc);
    final ids = sales.map((s) => s.id).toSet();
    if (ids.isEmpty) return const [];
    final rows = await (_db.select(
      _db.saleLines,
    )..where((l) => l.saleId.isIn(ids.toList()))).get();
    return rows
        .map(
          (r) => SaleLineView(
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
          ),
        )
        .toList();
  }

  Future<calc.SalesSummary> salesSummary(
    DateTime fromUtc,
    DateTime toUtc,
  ) async {
    final all = await allSalesInRange(fromUtc, toUtc);
    return calc.summarizeSales(all);
  }

  Future<List<calc.ProductSalesRow>> productSales(
    DateTime fromUtc,
    DateTime toUtc,
  ) async {
    final lines = await completedLinesInRange(fromUtc, toUtc);
    return calc.productSales(lines);
  }

  Future<calc.ProfitEstimate> profit(DateTime fromUtc, DateTime toUtc) async {
    final completed = await completedSalesInRange(fromUtc, toUtc);
    final lines = await completedLinesInRange(fromUtc, toUtc);
    final expenses = await _expenses.list(fromUtc: fromUtc, toUtc: toUtc);
    return calc.estimateProfit(
      completedSales: completed,
      completedLines: lines,
      expenses: expenses.fold((_) => const [], (v) => v),
    );
  }
}
