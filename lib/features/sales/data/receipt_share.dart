import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';

/// Shares/saves/prints generated receipt PDFs through platform flows.
/// If printing is unavailable, sharing the file still works (PRD §6.8).
class ReceiptShareService {
  Future<Result<String>> sharePdf({
    required Uint8List bytes,
    required String saleNumber,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File(p.join(dir.path, 'receipt-$saleNumber.pdf'));
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [
            XFile(
              file.path,
              mimeType: 'application/pdf',
              name: 'receipt-$saleNumber.pdf',
            ),
          ],
          text: 'Receipt $saleNumber',
        ),
      );
      return ok(file.path);
    } catch (e) {
      return fail(ExportFailure('Could not share receipt.', e));
    }
  }

  Future<Result<void>> printPdf({required Uint8List bytes}) async {
    try {
      await Printing.layoutPdf(onLayout: (_) async => bytes);
      return ok(null);
    } catch (e) {
      return fail(ExportFailure('Printing is unavailable.', e));
    }
  }
}
