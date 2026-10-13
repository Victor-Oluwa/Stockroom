// ignore_for_file: recursive_getters
import 'package:drift/drift.dart';

import 'inventory_tables.dart';

/// Sales headers. Void = full void only in v1; row kept, status flipped.
class Sales extends Table {
  TextColumn get id => text()();
  TextColumn get saleNumber => text().unique()();
  // COMPLETED | VOIDED
  TextColumn get status => text().withDefault(const Constant('COMPLETED'))();
  DateTimeColumn get soldAt => dateTime()();
  // Cash | Bank Transfer | Card | Other
  TextColumn get paymentMethod => text()();
  TextColumn get customerName => text().nullable()();
  TextColumn get note => text().nullable()();
  IntColumn get subtotalKobo => integer()();
  IntColumn get discountTotalKobo => integer()();
  IntColumn get totalKobo => integer()();
  DateTimeColumn get voidedAt => dateTime().nullable()();
  TextColumn get voidReason => text().nullable()();
  TextColumn get idempotencyKey => text().unique()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Immutable snapshots: product edits must never rewrite these.
class SaleLines extends Table {
  TextColumn get id => text()();
  TextColumn get saleId =>
      text().references(Sales, #id, onDelete: KeyAction.cascade)();
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get productNameSnapshot => text()();
  TextColumn get skuSnapshot => text().nullable()();
  TextColumn get unitLabelSnapshot => text()();
  IntColumn get quantityMilli =>
      integer().check(quantityMilli.isBiggerThanValue(0))();
  IntColumn get unitPriceKobo =>
      integer().check(unitPriceKobo.isBiggerOrEqualValue(0))();
  IntColumn get grossLineTotalKobo => integer()();
  IntColumn get discountKobo => integer()();
  IntColumn get netLineTotalKobo => integer()();
  IntColumn get unitCostSnapshotKobo => integer()();
  IntColumn get cogsTotalKobo => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Non-inventory operating expenses. Never touches the ledger.
class Expenses extends Table {
  TextColumn get id => text()();
  IntColumn get amountKobo =>
      integer().check(amountKobo.isBiggerThanValue(0))();
  TextColumn get category => text()();
  DateTimeColumn get expenseDate => dateTime()();
  TextColumn get paymentMethod => text()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
