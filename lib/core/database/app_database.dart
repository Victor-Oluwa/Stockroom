import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/business_tables.dart';
import 'tables/inventory_tables.dart';
import 'tables/sales_tables.dart';

part 'app_database.g.dart';

/// Local SQLite database (PRD §8). Single-business, offline-first.
///
/// - UUID TEXT primary keys.
/// - FK enforcement ON (see [beforeOpen]).
/// - `schemaVersion = 1` covers the full v1 contract so later phases add
///   rows, not tables. All schema changes need explicit migrations —
///   never wipe the database on startup.
/// - Money = int kobo, quantity = int milli. No REAL columns for amounts.
@DriftDatabase(
  tables: [
    BusinessProfile,
    AppSettings,
    ProductCategories,
    Suppliers,
    Products,
    StockReceipts,
    StockReceiptLines,
    Sales,
    SaleLines,
    StockMovements,
    StockAdjustments,
    Expenses,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async => m.createAll(),
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  // --- Reactive reads used by dashboard/lists (foundation subset) ---

  Stream<BusinessProfileData?> watchProfile() {
    return (select(businessProfile)..limit(1)).watchSingleOrNull();
  }

  Future<BusinessProfileData?> readProfile() {
    return (select(businessProfile)..limit(1)).getSingleOrNull();
  }

  /// Upsert single active profile. Keeps historical sale snapshots untouched —
  /// receipts query the live profile only for future prints.
  Future<void> saveProfile(BusinessProfileCompanion entry) {
    return into(businessProfile).insertOnConflictUpdate(entry);
  }

  Stream<AppSetting?> watchSettings() {
    return (select(appSettings)..limit(1)).watchSingleOrNull();
  }

  Future<AppSetting?> readSettings() {
    return (select(appSettings)..limit(1)).getSingleOrNull();
  }

  Future<void> ensureDefaultSettings() async {
    final existing = await readSettings();
    if (existing == null) {
      await into(
        appSettings,
      ).insert(const AppSettingsCompanion(id: Value('settings')));
    }
  }

  // --- Backup support (PRD §6.14) ---

  static const databaseFileName = 'stockroom.sqlite';
  static const productImagesDirName = 'product_images';

  static Future<Directory> documentsDir() => getApplicationDocumentsDirectory();

  static Future<File> databaseFile() async {
    final dir = await documentsDir();
    return File(p.join(dir.path, databaseFileName));
  }

  static Future<Directory> imagesDir() async {
    final dir = await documentsDir();
    final images = Directory(p.join(dir.path, productImagesDirName));
    if (!await images.exists()) {
      await images.create(recursive: true);
    }
    return images;
  }

  /// Consistent offline snapshot even with a WAL and open connections.
  /// Never copy the live file directly (PRD §6.14).
  Future<void> vacuumInto(File target) async {
    final escaped = target.path.replaceAll("'", "''");
    await customStatement("VACUUM INTO '$escaped'");
  }

  /// `true` when `PRAGMA integrity_check` reports ok.
  Future<bool> checkIntegrity() async {
    final rows = await customSelect('PRAGMA integrity_check').get();
    return rows.length == 1 && rows.first.data.values.firstOrNull == 'ok';
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final file = await AppDatabase.databaseFile();
    return NativeDatabase.createInBackground(file);
  });
}
