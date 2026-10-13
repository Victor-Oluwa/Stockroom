// ignore_for_file: recursive_getters
import 'package:drift/drift.dart';

import 'business_tables.dart';

/// Products. SKU/barcode stored NORMALISED (trimmed; SKU uppercased),
/// unique when non-null. Quantity cache must equal ledger sum (PRD §7.3).
class Products extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get normalizedName => text()();
  TextColumn get sku => text().nullable().unique()();
  TextColumn get barcode => text().nullable().unique()();
  TextColumn get categoryId => text().nullable().references(
    ProductCategories,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get unitLabel => text()();
  IntColumn get sellingPriceKobo => integer()();
  IntColumn get averageCostKobo => integer().withDefault(const Constant(0))();
  IntColumn get quantityOnHandMilli => integer()
      .withDefault(const Constant(0))
      .check(quantityOnHandMilli.isBiggerOrEqualValue(0))();
  IntColumn get lowStockThresholdMilli => integer()
      .withDefault(const Constant(5000))
      .check(lowStockThresholdMilli.isBiggerOrEqualValue(0))();
  TextColumn get imagePath => text().nullable()();
  TextColumn get description => text().nullable()();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Stock receipt headers. Totals computed by domain, never trusted from UI.
class StockReceipts extends Table {
  TextColumn get id => text()();
  TextColumn get receiptNumber => text().unique()();
  TextColumn get supplierId => text().nullable().references(
    Suppliers,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get supplierNameSnapshot => text().nullable()();
  TextColumn get supplierReference => text().nullable()();
  DateTimeColumn get receivedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  IntColumn get totalCostKobo => integer()();
  TextColumn get idempotencyKey => text().unique()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

class StockReceiptLines extends Table {
  TextColumn get id => text()();
  TextColumn get receiptId =>
      text().references(StockReceipts, #id, onDelete: KeyAction.cascade)();
  TextColumn get productId => text().references(Products, #id)();
  IntColumn get quantityMilli =>
      integer().check(quantityMilli.isBiggerThanValue(0))();
  IntColumn get unitCostKobo =>
      integer().check(unitCostKobo.isBiggerOrEqualValue(0))();
  IntColumn get lineCostKobo => integer()();
  TextColumn get productNameSnapshot => text()();
  TextColumn get unitLabelSnapshot => text()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Append-only ledger. Rows immutable; corrections are new movements.
class StockMovements extends Table {
  TextColumn get id => text()();
  TextColumn get productId => text().references(Products, #id)();
  // OPENING_STOCK | PURCHASE_RECEIPT | SALE | SALE_VOID_REVERSAL |
  // ADJUSTMENT_IN | ADJUSTMENT_OUT
  TextColumn get movementType => text()();
  IntColumn get quantityDeltaMilli => integer()();
  IntColumn get unitCostKobo => integer().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get referenceType => text()();
  TextColumn get referenceId => text()();
  TextColumn get reason => text().nullable()();
  TextColumn get note => text().nullable()();
  // Unique per movement; parent operation key lives on the parent record.
  // Pattern: '<parentKey>:<productId>' for multi-line ops.
  TextColumn get idempotencyKey => text().unique()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Manual adjustment headers (one product per adjustment in v1).
class StockAdjustments extends Table {
  TextColumn get id => text()();
  TextColumn get adjustmentNumber => text().unique()();
  TextColumn get productId => text().references(Products, #id)();
  // ADJUSTMENT_IN | ADJUSTMENT_OUT
  TextColumn get adjustmentType => text()();
  IntColumn get quantityMilli =>
      integer().check(quantityMilli.isBiggerThanValue(0))();
  IntColumn get unitCostKobo => integer().nullable()();
  TextColumn get reason => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get occurredAt => dateTime()();
  TextColumn get idempotencyKey => text().unique()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
