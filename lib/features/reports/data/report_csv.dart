import '../../../core/csv/csv.dart';
import '../../../core/database/app_database.dart' as db;
import '../domain/calculations.dart';

/// CSV builders. Same rows the screen shows; stable column names, UTF-8,
/// ISO timestamps (PRD §6.12).
String salesDetailCsv(List<db.Sale> sales) {
  return encodeCsv(
    const [
      'sale_number',
      'sold_at',
      'payment_method',
      'status',
      'customer_name',
      'subtotal_kobo',
      'discount_kobo',
      'total_kobo',
    ],
    [
      for (final s in sales)
        [
          s.saleNumber,
          s.soldAt.toIso8601String(),
          s.paymentMethod,
          s.status,
          s.customerName ?? '',
          s.subtotalKobo,
          s.discountTotalKobo,
          s.totalKobo,
        ],
    ],
  );
}

String productSalesCsv(List<ProductSalesRow> rows) {
  return encodeCsv(
    const [
      'product_name',
      'quantity_milli',
      'net_sales_kobo',
      'cogs_kobo',
      'gross_profit_kobo',
    ],
    [
      for (final r in rows)
        [
          r.productName,
          r.quantityMilli,
          r.netSalesKobo,
          r.cogsKobo,
          r.grossProfitKobo,
        ],
    ],
  );
}
