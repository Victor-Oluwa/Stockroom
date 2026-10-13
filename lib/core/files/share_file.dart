import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';

/// Local file export + platform share sheet. No storage permission
/// assumptions, no hardcoded Downloads path (PRD §6.12).
class FileShareService {
  Future<Result<String>> shareBytes({
    required List<int> bytes,
    required String filename,
    required String mimeType,
    String? text,
  }) async {
    try {
      final safe = filename.replaceAll(RegExp(r'[^\w\-.]+'), '_');
      final dir = await getTemporaryDirectory();
      final file = File(p.join(dir.path, safe));
      await file.writeAsBytes(bytes, flush: true);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: mimeType, name: safe)],
          text: text,
        ),
      );
      return ok(file.path);
    } catch (e) {
      return fail(ExportFailure('Export failed. Please try again.', e));
    }
  }
}
