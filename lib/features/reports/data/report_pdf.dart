import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/formatting/format.dart';
import '../../onboarding/domain/business_profile.dart';
import '../domain/calculations.dart';

/// On-device sales + profit report PDF (PRD §6.12). Same calculation
/// outputs the screen shows; business name, period, generated timestamp.
Future<Uint8List> buildSalesReportPdf({
  required BusinessProfile business,
  required String periodLabel,
  required DateTime generatedAt,
  required SalesSummary summary,
  required List<ProductSalesRow> products,
  required ProfitEstimate profit,
  required List<ExpenseSlice> expenses,
  pw.Font? regularFont,
  pw.Font? boldFont,
}) async {
  final doc = pw.Document();
  final base = 10.0;

  pw.Widget kv(String k, String v, {bool strong = false}) => pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text(k, style: pw.TextStyle(fontSize: base)),
      pw.Text(
        v,
        style: pw.TextStyle(
          fontSize: base,
          fontWeight: strong ? pw.FontWeight.bold : null,
        ),
      ),
    ],
  );

  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      theme: regularFont == null
          ? null
          : pw.ThemeData.withFont(
              base: regularFont,
              bold: boldFont ?? regularFont,
            ),
      build: (context) => [
        pw.Text(
          business.businessName,
          style: pw.TextStyle(
            fontSize: base + 6,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          'Sales report · $periodLabel',
          style: pw.TextStyle(fontSize: base + 1),
        ),
        pw.Text(
          'Generated ${formatDateTimeLocal(generatedAt.toUtc())}',
          style: pw.TextStyle(fontSize: base - 1),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'Summary',
          style: pw.TextStyle(
            fontSize: base + 2,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        kv('Net sales', formatNaira(summary.netSalesKobo), strong: true),
        kv('Transactions', '${summary.transactionCount}'),
        kv('Average sale', formatNaira(summary.averageSaleKobo)),
        if (summary.voidedCount > 0)
          kv('Voided (excluded)', '${summary.voidedCount}'),
        pw.SizedBox(height: 12),
        pw.Text(
          'Estimated profit',
          style: pw.TextStyle(
            fontSize: base + 2,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        kv('Net sales', formatNaira(profit.netSalesKobo)),
        kv('Cost of goods sold', formatNaira(profit.cogsKobo)),
        kv(
          'Estimated gross profit',
          formatNaira(profit.grossProfitKobo),
          strong: true,
        ),
        kv('Operating expenses', formatNaira(profit.operatingExpensesKobo)),
        kv(
          'Estimated operating profit',
          formatNaira(profit.operatingProfitKobo),
          strong: true,
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'Products',
          style: pw.TextStyle(
            fontSize: base + 2,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.TableHelper.fromTextArray(
          headers: const ['Product', 'Qty', 'Net', 'COGS', 'Profit'],
          data: [
            for (final r in products)
              [
                r.productName,
                formatQty(r.quantityMilli),
                formatNaira(r.netSalesKobo),
                formatNaira(r.cogsKobo),
                formatNaira(r.grossProfitKobo),
              ],
          ],
          headerStyle: pw.TextStyle(
            fontSize: base - 1,
            fontWeight: pw.FontWeight.bold,
          ),
          cellStyle: pw.TextStyle(fontSize: base - 1),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          'Expenses by category',
          style: pw.TextStyle(
            fontSize: base + 2,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        for (final e in expenses) kv(e.category, formatNaira(e.totalKobo)),
        if (expenses.isEmpty)
          pw.Text(
            'No expenses in this period.',
            style: pw.TextStyle(fontSize: base),
          ),
      ],
    ),
  );

  return doc.save();
}
