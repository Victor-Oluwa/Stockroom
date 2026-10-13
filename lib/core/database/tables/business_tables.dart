import 'package:drift/drift.dart';

/// Single active business profile (PRD §8.1).
class BusinessProfile extends Table {
  TextColumn get id => text()();
  TextColumn get businessName => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get logoPath => text().nullable()();
  TextColumn get receiptFooter => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// App-level settings + number sequences (single row, id = 'settings').
class AppSettings extends Table {
  TextColumn get id => text()();
  IntColumn get defaultLowStockThresholdMilli =>
      integer().withDefault(const Constant(5000))();
  BoolColumn get notificationsEnabled =>
      boolean().withDefault(const Constant(true))();
  // 'compact80' | 'a4'
  TextColumn get receiptLayout =>
      text().withDefault(const Constant('compact80'))();
  IntColumn get lastSaleSeq => integer().withDefault(const Constant(0))();
  IntColumn get lastReceiptSeq => integer().withDefault(const Constant(0))();
  IntColumn get lastAdjustmentSeq => integer().withDefault(const Constant(0))();
  IntColumn get settingsVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column> get primaryKey => {id};
}

/// Product categories. [normalizedName] is trimmed+lowercase, unique.
class ProductCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get normalizedName => text().unique()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Suppliers. Archive instead of delete when referenced (PRD §8.2).
class Suppliers extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get contactName => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
