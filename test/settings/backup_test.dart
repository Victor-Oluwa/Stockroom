import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:stockroom/core/database/app_database.dart';
import 'package:stockroom/core/errors/failures.dart';
import 'package:stockroom/features/expenses/data/expense_repository.dart';
import 'package:stockroom/features/inventory/data/product_repository.dart';
import 'package:stockroom/features/inventory/domain/product.dart';
import 'package:stockroom/features/onboarding/data/business_profile_repository.dart';
import 'package:stockroom/features/reports/domain/calculations.dart';
import 'package:stockroom/features/sales/data/sale_repository.dart';
import 'package:stockroom/features/sales/domain/sale.dart';
import 'package:stockroom/features/settings/data/backup_repository.dart';
import 'package:stockroom/features/stock_receiving/data/receipt_repository.dart';
import 'package:stockroom/features/stock_receiving/domain/receipt.dart';

class _Env {
  _Env(this.db, this.docs, this.temp);
  final AppDatabase db;
  final Directory docs;
  final Directory temp;

  BackupRepository backups() => BackupRepository(
    db: db,
    documentsDir: () async => docs,
    tempDir: () async => temp,
    appVersion: 'test',
  );
}

Future<_Env> _makeEnv() async {
  final root = await Directory.systemTemp.createTemp('stockroom-bak-');
  final docs = Directory(p.join(root.path, 'docs'))..createSync();
  final temp = Directory(p.join(root.path, 'tmp'))..createSync();
  final db = AppDatabase.forTesting(NativeDatabase.memory());
  await db.ensureDefaultSettings();
  addTearDown(() async {
    try {
      await db.close();
    } catch (_) {}
    try {
      await root.delete(recursive: true);
    } catch (_) {}
  });
  return _Env(db, docs, temp);
}

/// Representative business data: profile, product + image, receipt,
/// completed + voided sales, movements, expense.
Future<void> _seed(_Env env) async {
  final profiles = DriftBusinessProfileRepository(env.db);
  final products = DriftProductRepository(env.db);
  final receipts = DriftReceiptRepository(env.db);
  final sales = DriftSaleRepository(env.db);
  final expenses = DriftExpenseRepository(env.db);

  await profiles.save(businessName: 'Test Shop');
  final images = Directory(
    p.join(env.docs.path, AppDatabase.productImagesDirName),
  )..createSync(recursive: true);
  await File(p.join(images.path, 'chair.jpg')).writeAsBytes([1, 2, 3, 4, 5]);

  final chair = (await products.createProduct(
    name: 'Chair',
    unitLabel: 'piece',
    sellingPriceKobo: 1500000,
    openingQtyMilli: 50000,
    openingUnitCostKobo: 1000000,
    imagePath: 'product_images/chair.jpg',
  )).getOrElse((_) => throw StateError('p'));
  await receipts.receiveStock(
    lines: [
      ReceiptLineInput(
        productId: chair.id,
        quantityMilli: 10000,
        unitCostKobo: 1100000,
      ),
    ],
  );
  final done = (await sales.completeSale(
    lines: [
      SaleLineInput(
        productId: chair.id,
        quantityMilli: 3000,
        unitPriceKobo: 1500000,
      ),
    ],
    paymentMethod: 'Cash',
  )).getOrElse((_) => throw StateError('s'));
  final voided = (await sales.completeSale(
    lines: [
      SaleLineInput(
        productId: chair.id,
        quantityMilli: 1000,
        unitPriceKobo: 1500000,
      ),
    ],
    paymentMethod: 'Card',
  )).getOrElse((_) => throw StateError('v'));
  await sales.voidSale(saleId: voided.saleId, reason: 'Test');
  await expenses.record(
    amountKobo: 500000,
    category: 'Transport',
    day: DateTime.now(),
    paymentMethod: 'Cash',
  );
  // Touch the completed id so linters see it used.
  expect(done.saleNumber, 'S-0001');
}

Future<AppDatabase> _openFileDb(File file) async {
  final db = AppDatabase.forTesting(NativeDatabase.createInBackground(file));
  addTearDown(() async {
    try {
      await db.close();
    } catch (_) {}
  });
  return db;
}

void main() {
  group('Scenario G — backup and restore', () {
    test('roundtrip preserves records, images and report totals', () async {
      final src = await _makeEnv();
      await _seed(src);

      final exported = await src.backups().exportBackup();
      final zipPath = exported
          .getOrElse((_) => throw StateError('export'))
          .filePath;
      expect(File(zipPath).existsSync(), isTrue);

      // Restore into a clean environment.
      final dst = await _makeEnv();
      final staged = await dst.backups().stageForRestore(zipPath);
      final staging = staged.getOrElse((_) => throw StateError('stage'));
      expect(staging.preview.productCount, 1);
      expect(staging.preview.saleCount, 2);
      expect(staging.preview.receiptCount, 1);
      expect(staging.preview.expenseCount, 1);
      expect(staging.preview.movementCount, 5);

      final safety = await dst.backups().safetyBackup();
      expect(safety.isRight(), isTrue);
      await dst.db.close();
      final replaced = await dst.backups().replaceFromStaging(staging);
      expect(replaced.isRight(), isTrue);

      final reopened = await _openFileDb(
        File(p.join(dst.docs.path, AppDatabase.databaseFileName)),
      );
      final products = DriftProductRepository(reopened);
      final all = (await products.listProducts(
        const ProductListFilter(showArchived: true),
      )).getOrElse((_) => throw StateError('x'));
      expect(all.length, 1);
      expect(all.single.name, 'Chair');
      expect(all.single.quantityOnHandMilli, 57000);
      expect(
        File(
          p.join(dst.docs.path, AppDatabase.productImagesDirName, 'chair.jpg'),
        ).existsSync(),
        isTrue,
      );
      // Same totals as the source database.
      final srcProducts = DriftProductRepository(src.db);
      final srcAll = (await srcProducts.listProducts(
        const ProductListFilter(showArchived: true),
      )).getOrElse((_) => throw StateError('y'));
      expect(valuateStock(all).totalKobo, valuateStock(srcAll).totalKobo);
      final integrity = await products.checkIntegrity();
      expect(integrity.getOrElse((_) => throw StateError('z')), isEmpty);
    });

    test('missing image is listed, backup still restores', () async {
      final src = await _makeEnv();
      await _seed(src);
      // Simulate a lost photo file.
      await File(
        p.join(src.docs.path, AppDatabase.productImagesDirName, 'chair.jpg'),
      ).delete();
      final exported = await src.backups().exportBackup();
      final backup = exported.getOrElse((_) => throw StateError('e'));
      expect(backup.missingImages, ['product_images/chair.jpg']);

      final dst = await _makeEnv();
      final staged = await dst.backups().stageForRestore(backup.filePath);
      expect(staged.isRight(), isTrue);
      await dst.backups().disposeStaging(
        staged.getOrElse((_) => throw StateError('s')),
      );
    });
  });

  group('failed restore leaves active data intact', () {
    test('garbage file rejected; live rows untouched', () async {
      final env = await _makeEnv();
      await _seed(env);
      final garbage = File(p.join(env.temp.path, 'junk.zip'))
        ..writeAsBytesSync([0, 1, 2, 3, 4]);
      final result = await env.backups().stageForRestore(garbage.path);
      expect(result.isLeft(), isTrue);
      expect(
        result.fold((f) => f, (_) => throw StateError('x')),
        isA<BackupInvalidFailure>(),
      );
      final products = DriftProductRepository(env.db);
      final all = (await products.listProducts(
        const ProductListFilter(showArchived: true),
      )).getOrElse((_) => throw StateError('y'));
      expect(all.length, 1);
      expect(all.single.quantityOnHandMilli, 57000);
    });

    test('tampered manifest and path traversal rejected', () async {
      final env = await _makeEnv();
      await _seed(env);
      final exported = await env.backups().exportBackup();
      final zipPath = exported.getOrElse((_) => throw StateError('e')).filePath;
      final original = ZipDecoder().decodeBytes(
        await File(zipPath).readAsBytes(),
      );

      Future<String> rewrite(
        String name,
        Archive Function(List<ArchiveFile>) mutate,
      ) async {
        final files = [
          for (final f in original.files)
            ArchiveFile(f.name, f.size, List<int>.from(f.content as List<int>)),
        ];
        final out = File(p.join(env.temp.path, name));
        await out.writeAsBytes(ZipEncoder().encode(mutate(files)), flush: true);
        return out.path;
      }

      // 1. Manifest claims a newer schema.
      final newerManifest = Map<String, Object?>.from(
        jsonDecode(
              utf8.decode(
                original.files
                        .firstWhere((f) => f.name == 'manifest.json')
                        .content
                    as List<int>,
              ),
            )
            as Map,
      )..['schemaVersion'] = 999;
      final newerPath = await rewrite('newer.zip', (files) {
        final copy = Archive();
        for (final f in files.where((f) => f.name != 'manifest.json')) {
          copy.addFile(f);
        }
        copy.addFile(
          ArchiveFile.string('manifest.json', jsonEncode(newerManifest)),
        );
        return copy;
      });
      final newer = await env.backups().stageForRestore(newerPath);
      expect(newer.isLeft(), isTrue);

      // 2. Absolute + parent-escape entries.
      final evilPath = await rewrite('evil.zip', (files) {
        final copy = Archive();
        for (final f in files) {
          copy.addFile(f);
        }
        copy.addFile(ArchiveFile.string('/abs.txt', 'x'));
        copy.addFile(ArchiveFile.string('../escape.txt', 'x'));
        return copy;
      });
      final evil = await env.backups().stageForRestore(evilPath);
      expect(evil.isLeft(), isTrue);

      // 3. Database entry removed.
      final nodbPath = await rewrite('nodb.zip', (files) {
        final copy = Archive();
        for (final f in files.where((f) => f.name != BackupManifest.dbEntry)) {
          copy.addFile(f);
        }
        return copy;
      });
      final nodb = await env.backups().stageForRestore(nodbPath);
      expect(nodb.isLeft(), isTrue);
    });
  });

  group('persistence harness (migration baseline)', () {
    test('file database survives close and reopen intact', () async {
      final root = await Directory.systemTemp.createTemp('stockroom-reopen-');
      addTearDown(() async {
        try {
          await root.delete(recursive: true);
        } catch (_) {}
      });
      final file = File(p.join(root.path, 'stockroom.sqlite'));
      final db1 = AppDatabase.forTesting(
        NativeDatabase.createInBackground(file),
      );
      await db1.ensureDefaultSettings();
      await DriftBusinessProfileRepository(
        db1,
      ).save(businessName: 'Reopen Shop');
      await DriftProductRepository(db1).createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1500000,
        openingQtyMilli: 50000,
        openingUnitCostKobo: 1000000,
      );
      await db1.close();

      // v1 has no older schema to migrate from; this harness reopens the
      // file and proves records survive — extend it when v2 lands.
      final db2 = AppDatabase.forTesting(
        NativeDatabase.createInBackground(file),
      );
      addTearDown(() async {
        try {
          await db2.close();
        } catch (_) {}
      });
      expect(db2.schemaVersion, 1);
      expect(await db2.checkIntegrity(), isTrue);
      final profile = await db2.readProfile();
      expect(profile?.businessName, 'Reopen Shop');
      final chair = (await DriftProductRepository(db2).listProducts(
        const ProductListFilter(),
      )).getOrElse((_) => throw StateError('x')).single;
      expect(chair.quantityOnHandMilli, 50000);
    });
  });
}
