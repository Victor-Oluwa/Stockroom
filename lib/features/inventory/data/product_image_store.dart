import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Product image files live under the app documents directory;
/// the database stores only the relative path (PRD §6.3).
///
/// Images are downscaled so the longest edge is at most 1200px and
/// re-encoded as JPEG quality 85 to keep rows compact.
class ProductImageStore {
  ProductImageStore([Uuid? ids]) : _ids = ids ?? const Uuid();
  final Uuid _ids;

  static const imagesDirName = 'product_images';
  static const maxEdge = 1200;

  Future<Directory> _imagesDir() async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, imagesDirName));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Copies/compresses [sourcePath] (from image_picker) into managed storage.
  /// Returns the relative path to persist in `products.imagePath`.
  /// Always forward slashes: the path is stored in the database and must
  /// survive backup/restore across platforms (Windows uses backslashes).
  Future<String> saveProductImage(String sourcePath) async {
    final bytes = await File(sourcePath).readAsBytes();
    final dir = await _imagesDir();
    final fileName = '${_ids.v4()}.jpg';
    final target = File(p.join(dir.path, fileName));
    final compressed = _compress(bytes);
    await target.writeAsBytes(compressed, flush: true);
    return '$imagesDirName/$fileName';
  }

  List<int> _compress(List<int> bytes) {
    img.Image? decoded;
    try {
      decoded = img.decodeImage(Uint8List.fromList(bytes));
    } catch (_) {
      decoded = null;
    }
    if (decoded == null) return bytes; // unknown format: keep original
    final longest = decoded.width > decoded.height
        ? decoded.width
        : decoded.height;
    img.Image out = decoded;
    if (longest > maxEdge) {
      final scale = maxEdge / longest;
      out = img.copyResize(
        decoded,
        width: (decoded.width * scale).round(),
        height: (decoded.height * scale).round(),
      );
    }
    return img.encodeJpg(out, quality: 85);
  }

  /// Resolves a stored relative path to an absolute [File].
  /// Absolute paths and `..` escapes are rejected (falls back to a
  /// non-existent path inside the images dir, which callers treat as
  /// missing and render the placeholder).
  Future<File> fileFor(String relativePath) async {
    final docs = await getApplicationDocumentsDirectory();
    final normalized = p.normalize(relativePath.replaceAll('\\', '/'));
    final unsafe =
        p.isAbsolute(normalized) ||
        normalized.split('/').contains('..') ||
        normalized.startsWith('..');
    final safe = unsafe ? 'missing' : normalized;
    return File(p.join(docs.path, safe));
  }

  /// Best-effort delete (e.g. when replacing a product photo).
  Future<void> deleteImage(String? relativePath) async {
    if (relativePath == null || relativePath.trim().isEmpty) return;
    try {
      final f = await fileFor(relativePath);
      if (await f.exists()) await f.delete();
    } catch (_) {
      // ignore: image cleanup must never fail the product save
    }
  }
}
