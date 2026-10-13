import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../core/database/app_database.dart' hide Supplier;
import '../../core/notifications/stock_alerts.dart';
import '../../features/expenses/data/expense_repository.dart';
import '../../features/inventory/data/category_repository.dart';
import '../../features/inventory/data/product_image_store.dart';
import '../../features/inventory/data/product_repository.dart';
import '../../features/onboarding/data/business_profile_repository.dart';
import '../../features/reports/data/reports_repository.dart';
import '../../features/settings/data/backup_repository.dart';
import '../../features/settings/data/settings_repository.dart';
import '../../features/stock_movements/data/adjustment_repository.dart';
import '../../features/stock_movements/data/ledger_repository.dart';
import '../../features/sales/data/sale_repository.dart';
import '../../features/stock_receiving/data/receipt_repository.dart';
import '../../features/suppliers/data/supplier_repository.dart';
import '../../features/suppliers/domain/supplier.dart';

/// Dependency injection via Riverpod (PRD §9.3). No global singletons;
/// widgets read providers, never construct DB/repositories directly.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final businessProfileRepositoryProvider = Provider<BusinessProfileRepository>((
  ref,
) {
  return DriftBusinessProfileRepository(ref.watch(appDatabaseProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return DriftCategoryRepository(ref.watch(appDatabaseProvider));
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return DriftProductRepository(ref.watch(appDatabaseProvider));
});

final productImageStoreProvider = Provider<ProductImageStore>((ref) {
  return ProductImageStore();
});

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  return DriftSupplierRepository(ref.watch(appDatabaseProvider));
});

final receiptRepositoryProvider = Provider<ReceiptRepository>((ref) {
  return DriftReceiptRepository(ref.watch(appDatabaseProvider));
});

final adjustmentRepositoryProvider = Provider<AdjustmentRepository>((ref) {
  return DriftAdjustmentRepository(ref.watch(appDatabaseProvider));
});

final ledgerRepositoryProvider = Provider<LedgerRepository>((ref) {
  return LedgerRepository(ref.watch(appDatabaseProvider));
});

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  return DriftSaleRepository(ref.watch(appDatabaseProvider));
});

final expenseRepositoryProvider = Provider<ExpenseRepository>((ref) {
  return DriftExpenseRepository(ref.watch(appDatabaseProvider));
});

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  return ReportsRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(expenseRepositoryProvider),
  );
});

Future<Directory> _docsDir() => getApplicationDocumentsDirectory();
Future<Directory> _tempDir() => getTemporaryDirectory();

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository(
    db: ref.watch(appDatabaseProvider),
    documentsDir: _docsDir,
  );
});

/// Backup repo stamped with the real app version.
final backupRepositoryProvider = FutureProvider<BackupRepository>((ref) async {
  String version = 'unknown';
  try {
    final info = await PackageInfo.fromPlatform();
    version = '${info.version}+${info.buildNumber}';
  } catch (_) {}
  return BackupRepository(
    db: ref.watch(appDatabaseProvider),
    documentsDir: _docsDir,
    tempDir: _tempDir,
    appVersion: version,
  );
});

/// Local stock-transition notifications (PRD §6.9). Device alerts only;
/// in-app lists remain available when denied.
final stockAlertServiceProvider = Provider<StockAlertService>((ref) {
  return StockAlertService(ref.watch(appDatabaseProvider));
});

/// Active suppliers for pickers.
final activeSuppliersProvider = StreamProvider<List<Supplier>>((ref) {
  return ref.watch(supplierRepositoryProvider).watchSuppliers();
});

/// Ensures default settings row exists on first launch.
final appInitProvider = FutureProvider<void>((ref) async {
  await ref.watch(appDatabaseProvider).ensureDefaultSettings();
});
