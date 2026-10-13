import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../core/database/app_database.dart' as db;
import '../../../../core/formatting/format.dart';
import '../../onboarding/domain/business_profile.dart';
import '../domain/sale.dart';

enum ReceiptLayout { compact80, a4 }

/// Builds the sale receipt PDF entirely on-device (PRD §6.8).
/// Uses built-in PDF fonts only — no network. Content comes from the
/// immutable sale snapshot, never live product rows.
///
/// [regularFont]/[boldFont] should be TTF fonts covering ₦ (U+20A6) —
/// the app bundles DejaVu Sans for this (built-in Helvetica lacks ₦).
/// When omitted, Helvetica is used (some glyphs may be missing).
Future<Uint8List> buildReceiptPdf({
  required BusinessProfile business,
  required db.Sale sale,
  required List<SaleLineView> lines,
  ReceiptLayout layout = ReceiptLayout.compact80,
  Uint8List? logoBytes,
  pw.Font? regularFont,
  pw.Font? boldFont,
}) async {
  final doc = pw.Document();
  final pageFormat = layout == ReceiptLayout.compact80
      ? const PdfPageFormat(
          80 * PdfPageFormat.mm,
          297 * PdfPageFormat.mm,
          marginAll: 8 * PdfPageFormat.mm,
        )
      : PdfPageFormat.a4;
  final base = layout == ReceiptLayout.compact80 ? 9.0 : 11.0;

  pw.Widget header() {
    return pw.Column(
      children: [
        if (logoBytes != null)
          pw.Image(pw.MemoryImage(logoBytes), width: 60, height: 60),
        pw.Text(
          business.businessName,
          style: pw.TextStyle(
            fontSize: base + 4,
            fontWeight: pw.FontWeight.bold,
          ),
          textAlign: pw.TextAlign.center,
        ),
        if (business.phone != null)
          pw.Text(business.phone!, style: pw.TextStyle(fontSize: base)),
        if (business.address != null)
          pw.Text(
            business.address!,
            style: pw.TextStyle(fontSize: base),
            textAlign: pw.TextAlign.center,
          ),
        pw.SizedBox(height: 6),
        pw.Text(
          'Sale ${sale.saleNumber}',
          style: pw.TextStyle(
            fontSize: base + 1,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.Text(
          formatDateTimeLocal(sale.soldAt),
          style: pw.TextStyle(fontSize: base),
        ),
        if (sale.customerName != null)
          pw.Text(
            'Customer: ${sale.customerName}',
            style: pw.TextStyle(fontSize: base),
          ),
        pw.Divider(),
      ],
    );
  }

  pw.Widget lineRow(SaleLineView l) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          l.productName,
          style: pw.TextStyle(fontSize: base, fontWeight: pw.FontWeight.bold),
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              '${formatQty(l.quantityMilli, l.unitLabel)} × ${formatNaira(l.unitPriceKobo)}',
              style: pw.TextStyle(fontSize: base),
            ),
            pw.Text(
              formatNaira(l.grossLineTotalKobo),
              style: pw.TextStyle(fontSize: base),
            ),
          ],
        ),
        if (l.discountKobo > 0)
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text('Discount', style: pw.TextStyle(fontSize: base)),
              pw.Text(
                '-${formatNaira(l.discountKobo)}',
                style: pw.TextStyle(fontSize: base),
              ),
            ],
          ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Line total', style: pw.TextStyle(fontSize: base)),
            pw.Text(
              formatNaira(l.netLineTotalKobo),
              style: pw.TextStyle(
                fontSize: base,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
      ],
    );
  }

  pw.Widget totals() {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Subtotal', style: pw.TextStyle(fontSize: base)),
            pw.Text(
              formatNaira(sale.subtotalKobo),
              style: pw.TextStyle(fontSize: base),
            ),
          ],
        ),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Discounts', style: pw.TextStyle(fontSize: base)),
            pw.Text(
              '-${formatNaira(sale.discountTotalKobo)}',
              style: pw.TextStyle(fontSize: base),
            ),
          ],
        ),
        pw.SizedBox(height: 4),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'TOTAL',
              style: pw.TextStyle(
                fontSize: base + 3,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Text(
              formatNaira(sale.totalKobo),
              style: pw.TextStyle(
                fontSize: base + 3,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          'Paid: ${sale.paymentMethod}',
          style: pw.TextStyle(fontSize: base),
        ),
        if (sale.note != null)
          pw.Text('Note: ${sale.note}', style: pw.TextStyle(fontSize: base)),
        pw.SizedBox(height: 8),
        pw.Text(
          'Thank you for your patronage!',
          style: pw.TextStyle(fontSize: base),
        ),
        if (business.receiptFooter != null)
          pw.Text(
            business.receiptFooter!,
            style: pw.TextStyle(fontSize: base - 1),
            textAlign: pw.TextAlign.center,
          ),
      ],
    );
  }

  doc.addPage(
    pw.MultiPage(
      pageFormat: pageFormat,
      theme: regularFont == null
          ? null
          : pw.ThemeData.withFont(
              base: regularFont,
              bold: boldFont ?? regularFont,
            ),
      build: (context) => [
        header(),
        for (final l in lines) lineRow(l),
        totals(),
      ],
    ),
  );
  return doc.save();
}
