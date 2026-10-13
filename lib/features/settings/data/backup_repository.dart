import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:collection/collection.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';

/// Backup format contract (PRD §6.14).
class BackupManifest {
  const BackupManifest({
    required this.appVersion,
    required this.schemaVersion,
    required this.createdAt,
    required this.images,
    required this.missingImages,
  });

  static const format = 'stockroom-backup';
  static const formatVersion = 1;
  static const dbEntry = 'database/stockroom.sqlite';
  static const imagesPrefix = 'images/';

  final String appVersion;
  final int schemaVersion;
  final DateTime createdAt;
  final List<String> images;
  final List<String> missingImages;

  Map<String, Object?> toJson() => {
    'format': format,
    'formatVersion': formatVersion,
    'appVersion': appVersion,
    'schemaVersion': schemaVersion,
    'createdAt': createdAt.toIso8601String(),
    'dbFile': dbEntry,
    'images': images,
    'missingImages': missingImages,
  };

  static BackupManifest? tryParse(Object? json) {
    if (json is! Map) return null;
    if (json['format'] != format) return null;
    if (json['formatVersion'] != formatVersion) return null;
    final schema = json['schemaVersion'];
    if (schema is! int) return null;
    final created = DateTime.tryParse('${json['createdAt']}');
    if (created == null) return null;
    List<String> strings(Object? v) => [
      for (final e in (v as List? ?? const [])) '$e',
    ];
    return BackupManifest(
      appVersion: '${json['appVersion'] ?? 'unknown'}',
      schemaVersion: schema,
      createdAt: created,
      images: strings(json['images']),
      missingImages: strings(json['missingImages']),
    );
  }
}

class ExportedBackup {
  const ExportedBackup({required this.filePath, required this.missingImages});
  final String filePath;
  final List<String> missingImages;
}

class BackupPreview {
  const BackupPreview({
    required this.manifest,
    required this.productCount,
    required this.saleCount,
    required this.receiptCount,
    required this.expenseCount,
    required this.movementCount,
  });
  final BackupManifest manifest;
  final int productCount;
  final int saleCount;
  final int receiptCount;
  final int expenseCount;
  final int movementCount;
}

/// Validated staging area mirroring the documents layout:
/// `dir/stockroom.sqlite` + `dir/<relative image path>`.
/// Only [replaceFromStaging] touches live data, and only after the caller
/// closes the database.
class StagedBackup {
  StagedBackup({
    required this.dir,
    required this.dbFile,
    required this.preview,
  });
  final Directory dir;
  final File dbFile;
  final BackupPreview preview;
}

/// Full backup + safe restore (PRD §6.14). File work only; UI orchestration
/// (close DB, invalidate providers, navigate) lives in the settings screen.
///
/// Directories are injected so tests run without platform channels.
class BackupRepository {
  BackupRepository({
    required this.db,
    required this.documentsDir,
    required this.tempDir,
    required this.appVersion,
    Uuid? ids,
  }) : _ids = ids ?? const Uuid();

  static const maxEntries = 20000;
  static const maxTotalUncompressed = 1 << 30; // 1 GiB
  static const maxSingleFile = 500 << 20; // 500 MiB

  final AppDatabase db;
  final Future<Directory> Function() documentsDir;
  final Future<Directory> Function() tempDir;
  final String appVersion;
  final Uuid _ids;

  // ---------- Export ----------

  Future<Result<ExportedBackup>> exportBackup() async {
    try {
      final docs = await documentsDir();
      final temp = await tempDir();
      final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(
        RegExp(r'[:.]'),
        '-',
      );
      final snapshot = File(
        p.join(temp.path, 'stockroom-snapshot-$stamp.sqlite'),
      );
      if (await snapshot.exists()) await snapshot.delete();
      await db.vacuumInto(snapshot);

      final refs = await _referencedImages(db);
      final present = <String>[];
      final missing = <String>[];
      final archive = Archive();
      for (final rel in refs) {
        final file = _safeJoin(docs, rel);
        if (file != null && await file.exists()) {
          present.add(rel);
        } else {
          missing.add(rel);
        }
      }
      final manifest = BackupManifest(
        appVersion: appVersion,
        schemaVersion: db.schemaVersion,
        createdAt: DateTime.now().toUtc(),
        images: present,
        missingImages: missing,
      );
      archive.addFile(
        ArchiveFile.string('manifest.json', jsonEncode(manifest.toJson())),
      );
      archive.addFile(
        ArchiveFile(
          BackupManifest.dbEntry,
          await snapshot.length(),
          await snapshot.readAsBytes(),
        ),
      );
      for (final rel in present) {
        final file = _safeJoin(docs, rel)!;
        final bytes = await file.readAsBytes();
        archive.addFile(
          ArchiveFile(
            '${BackupManifest.imagesPrefix}$rel',
            bytes.length,
            bytes,
          ),
        );
      }
      final zipPath = p.join(
        temp.path,
        'stockroom-backup-$stamp.stockroom.zip',
      );
      await File(
        zipPath,
      ).writeAsBytes(ZipEncoder().encode(archive), flush: true);
      await snapshot.delete();
      return ok(ExportedBackup(filePath: zipPath, missingImages: missing));
    } catch (e) {
      return fail(
        ExportFailure('Could not create backup. Please try again.', e),
      );
    }
  }

  /// All image paths referenced by live rows (products + business logo).
  Future<List<String>> _referencedImages(AppDatabase db) async {
    final refs = <String>{};
    final products = await db.select(db.products).get();
    for (final prod in products) {
      final img = prod.imagePath?.trim();
      if (img != null && img.isNotEmpty) refs.add(img);
    }
    final profile = await db.readProfile();
    final logo = profile?.logoPath?.trim();
    if (logo != null && logo.isNotEmpty) refs.add(logo);
    return refs.toList()..sort();
  }

  /// Joins a stored relative path under [base], rejecting absolute paths
  /// and `..` escapes. Returns null when unsafe.
  File? _safeJoin(Directory base, String relative) {
    final normalized = p.normalize(relative);
    if (p.isAbsolute(normalized)) return null;
    if (normalized.split(p.separator).contains('..')) return null;
    if (normalized.startsWith('..')) return null;
    return File(p.join(base.path, normalized));
  }

  // ---------- Validate (never touches live data) ----------

  Future<Result<StagedBackup>> stageForRestore(String sourcePath) async {
    Directory? staging;
    try {
      final temp = await tempDir();
      staging = Directory(p.join(temp.path, 'stockroom-staging-${_ids.v4()}'));
      await staging.create(recursive: true);
      final copy = File(p.join(staging.path, 'source.zip'));
      await File(sourcePath).copy(copy.path);

      final bytes = await copy.readAsBytes();
      if (bytes.length > maxTotalUncompressed) {
        return _invalid(staging, 'Backup file is too large.');
      }
      Archive archive;
      try {
        archive = ZipDecoder().decodeBytes(bytes);
      } catch (_) {
        return _invalid(staging, 'Not a valid Stockroom backup file.');
      }
      if (archive.files.length > maxEntries) {
        return _invalid(staging, 'Backup contains too many files.');
      }
      var total = 0;
      for (final f in archive.files) {
        if (f.size > maxSingleFile) {
          return _invalid(staging, 'Backup contains an oversized file.');
        }
        total += f.size;
        if (total > maxTotalUncompressed) {
          return _invalid(staging, 'Backup is too large.');
        }
        final name = p.normalize(f.name.replaceAll('\\', '/'));
        if (p.isAbsolute(name) ||
            name.split('/').contains('..') ||
            name.startsWith('/') ||
            name.startsWith('..')) {
          return _invalid(staging, 'Backup contains unsafe file paths.');
        }
      }

      final manifestFile = archive.files
          .where((f) => f.name == 'manifest.json')
          .firstOrNull;
      if (manifestFile == null) {
        return _invalid(staging, 'Backup manifest is missing.');
      }
      final manifest = BackupManifest.tryParse(
        jsonDecode(utf8.decode(manifestFile.content as List<int>)),
      );
      if (manifest == null) {
        return _invalid(staging, 'Backup manifest is invalid or unsupported.');
      }
      if (manifest.schemaVersion > db.schemaVersion) {
        return _invalid(
          staging,
          'Backup was created by a newer Stockroom version (schema '
          '${manifest.schemaVersion}). Update the app first — your current data is untouched.',
        );
      }
      if (manifest.schemaVersion < 1) {
        return _invalid(staging, 'Backup schema version is unsupported.');
      }

      final dbEntry = archive.files
          .where((f) => f.name == BackupManifest.dbEntry)
          .firstOrNull;
      if (dbEntry == null) {
        return _invalid(staging, 'Backup database is missing.');
      }
      final stagedDb = File(p.join(staging.path, 'stockroom.sqlite'));
      await stagedDb.writeAsBytes(dbEntry.content as List<int>, flush: true);

      // Verify the staged copy before trusting anything in it.
      final probe = AppDatabase.forTesting(
        NativeDatabase.createInBackground(stagedDb),
      );
      // Checkpoint WAL content back into the staged file before it is
      // copied over the live database (only the main file is copied).
      Future<void> closeProbe() async {
        try {
          await probe.customStatement('PRAGMA wal_checkpoint(TRUNCATE)');
        } catch (_) {}
        try {
          await probe.close();
        } catch (_) {}
      }

      BackupPreview preview;
      try {
        if (!await probe.checkIntegrity()) {
          await closeProbe();
          return _invalid(staging, 'Backup database failed integrity check.');
        }
        preview = BackupPreview(
          manifest: manifest,
          productCount: (await probe.select(probe.products).get()).length,
          saleCount: (await probe.select(probe.sales).get()).length,
          receiptCount: (await probe.select(probe.stockReceipts).get()).length,
          expenseCount: (await probe.select(probe.expenses).get()).length,
          movementCount:
              (await probe.select(probe.stockMovements).get()).length,
        );
        // Every image the staged DB references must be accounted for.
        final stagedRefs = await _referencedImages(probe);
        final accounted = {...manifest.images, ...manifest.missingImages};
        final unaccounted = stagedRefs
            .where((r) => !accounted.contains(r))
            .toList();
        if (unaccounted.isNotEmpty) {
          await closeProbe();
          return _invalid(
            staging,
            'Backup is missing ${unaccounted.length} referenced image(s).',
          );
        }
        await closeProbe();
      } catch (_) {
        await closeProbe();
        return _invalid(
          staging,
          'Backup database could not be read (unsupported schema?).',
        );
      }

      // Extract manifest-listed images into the mirrored layout.
      final byName = {for (final f in archive.files) f.name: f};
      for (final rel in manifest.images) {
        final entry = byName['${BackupManifest.imagesPrefix}$rel'];
        if (entry == null) {
          return _invalid(staging, 'Backup is missing a listed image file.');
        }
        if (_isUnsafeRelative(rel)) {
          return _invalid(staging, 'Backup contains unsafe file paths.');
        }
        final target = File(p.join(staging.path, rel));
        await target.parent.create(recursive: true);
        await target.writeAsBytes(entry.content as List<int>, flush: true);
      }
      await copy.delete();
      return ok(StagedBackup(dir: staging, dbFile: stagedDb, preview: preview));
    } catch (e) {
      if (staging != null) {
        try {
          await staging.delete(recursive: true);
        } catch (_) {}
      }
      return fail(BackupInvalidFailure('Could not read backup file.', e));
    }
  }

  Result<StagedBackup> _invalid(Directory staging, String message) {
    try {
      staging.deleteSync(recursive: true);
    } catch (_) {}
    return fail(BackupInvalidFailure(message));
  }

  Future<void> disposeStaging(StagedBackup staged) async {
    try {
      await staged.dir.delete(recursive: true);
    } catch (_) {}
  }

  // ---------- Safety + replace (caller closes the DB first) ----------

  /// Snapshot of current data kept beside it before any replace.
  /// Older safety copies are pruned only after the new one succeeds.
  Future<Result<String>> safetyBackup() async {
    try {
      final docs = await documentsDir();
      final stamp = DateTime.now().toUtc().millisecondsSinceEpoch;
      final target = File(p.join(docs.path, 'stockroom-safety-$stamp.sqlite'));
      await db.vacuumInto(target);
      for (final old in docs.listSync().whereType<File>()) {
        final name = p.basename(old.path);
        if (name.startsWith('stockroom-safety-') &&
            name.endsWith('.sqlite') &&
            old.path != target.path) {
          try {
            await old.delete();
          } catch (_) {}
        }
      }
      return ok(target.path);
    } catch (e) {
      return fail(DatabaseFailure('Could not create a safety backup.', e));
    }
  }

  /// Replaces the live database + images with staged content.
  /// The database MUST be closed before calling; reopen afterwards by
  /// invalidating providers. Never call with unvalidated input.
  Future<Result<void>> replaceFromStaging(StagedBackup staged) async {
    try {
      final docs = await documentsDir();
      final liveDb = File(p.join(docs.path, AppDatabase.databaseFileName));
      for (final suffix in ['', '-wal', '-shm', '-journal']) {
        final f = File('${liveDb.path}$suffix');
        if (await f.exists()) await f.delete();
      }
      await staged.dbFile.copy(liveDb.path);

      // Restore every manifest-listed image to its stored relative path.
      final liveImages = Directory(
        p.join(docs.path, AppDatabase.productImagesDirName),
      );
      if (await liveImages.exists()) {
        await liveImages.delete(recursive: true);
      }
      await liveImages.create(recursive: true);
      for (final rel in staged.preview.manifest.images) {
        if (_isUnsafeRelative(rel)) continue;
        final source = File(p.join(staged.dir.path, rel));
        if (!await source.exists()) continue;
        final target = File(p.join(docs.path, rel));
        await target.parent.create(recursive: true);
        await source.copy(target.path);
      }
      await disposeStaging(staged);
      return ok(null);
    } catch (e) {
      return fail(
        DatabaseFailure(
          'Restore failed. Your previous data may still be available from the automatic safety backup.',
          e,
        ),
      );
    }
  }

  bool _isUnsafeRelative(String rel) {
    final normalized = p.normalize(rel.replaceAll('\\', '/'));
    if (p.isAbsolute(normalized)) return true;
    if (normalized.split('/').contains('..')) return true;
    if (normalized.startsWith('..')) return true;
    return false;
  }
}
