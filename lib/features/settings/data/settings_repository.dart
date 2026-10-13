import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;

import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';

class StorageInfo {
  const StorageInfo({
    required this.dbBytes,
    required this.imageBytes,
    required this.imageCount,
    required this.dbPath,
  });
  final int dbBytes;
  final int imageBytes;
  final int imageCount;
  final String dbPath;
}

/// Local settings, storage status and version info (PRD §6.14).
class SettingsRepository {
  SettingsRepository({required this.db, required this.documentsDir});
  final AppDatabase db;
  final Future<Directory> Function() documentsDir;

  Future<Result<int>> defaultThresholdMilli() async {
    try {
      final s = await db.readSettings();
      return ok(s?.defaultLowStockThresholdMilli ?? 5000);
    } catch (e) {
      return fail(DatabaseFailure('Could not load settings.', e));
    }
  }

  Future<Result<void>> setDefaultThresholdMilli(int milli) async {
    if (milli < 0) {
      return fail(const ValidationFailure('Threshold cannot be negative.'));
    }
    try {
      await db.ensureDefaultSettings();
      await (db.update(
        db.appSettings,
      )..where((s) => s.id.equals('settings'))).write(
        AppSettingsCompanion(defaultLowStockThresholdMilli: Value(milli)),
      );
      return ok(null);
    } catch (e) {
      return fail(DatabaseFailure('Could not save settings.', e));
    }
  }

  Future<StorageInfo> storageInfo() async {
    final docs = await documentsDir();
    final dbFile = File(p.join(docs.path, AppDatabase.databaseFileName));
    var dbBytes = 0;
    try {
      if (await dbFile.exists()) dbBytes = await dbFile.length();
    } catch (_) {}
    var imageBytes = 0;
    var imageCount = 0;
    try {
      final images = Directory(
        p.join(docs.path, AppDatabase.productImagesDirName),
      );
      if (await images.exists()) {
        await for (final entity in images.list(recursive: true)) {
          if (entity is File) {
            imageCount++;
            try {
              imageBytes += await entity.length();
            } catch (_) {}
          }
        }
      }
    } catch (_) {}
    return StorageInfo(
      dbBytes: dbBytes,
      imageBytes: imageBytes,
      imageCount: imageCount,
      dbPath: dbFile.path,
    );
  }

  Future<String> appVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return '${info.version}+${info.buildNumber}';
    } catch (_) {
      return 'unknown';
    }
  }
}
