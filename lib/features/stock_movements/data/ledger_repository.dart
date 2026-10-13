import 'package:drift/drift.dart';
import 'package:equatable/equatable.dart';

import '../../../core/database/app_database.dart' as db;

const List<String> movementTypes = [
  'OPENING_STOCK',
  'PURCHASE_RECEIPT',
  'SALE',
  'SALE_VOID_REVERSAL',
  'ADJUSTMENT_IN',
  'ADJUSTMENT_OUT',
];

/// One audit row with the product name resolved for display.
class LedgerEntry extends Equatable {
  const LedgerEntry({required this.movement, required this.productName});
  final db.StockMovement movement;
  final String productName;

  @override
  List<Object?> get props => [movement, productName];
}

class LedgerFilter extends Equatable {
  const LedgerFilter({
    this.productId,
    this.productName,
    this.type,
    this.from,
    this.to,
    this.query = '',
  });
  final String? productId;
  final String? productName;
  final String? type;
  final DateTime? from;
  final DateTime? to;
  final String query;

  LedgerFilter copyWith({
    String? productId,
    String? productName,
    String? type,
    DateTime? from,
    DateTime? to,
    String? query,
    bool clearProduct = false,
    bool clearType = false,
    bool clearDates = false,
  }) => LedgerFilter(
    productId: clearProduct ? null : (productId ?? this.productId),
    productName: clearProduct ? null : (productName ?? this.productName),
    type: clearType ? null : (type ?? this.type),
    from: clearDates ? null : (from ?? this.from),
    to: clearDates ? null : (to ?? this.to),
    query: query ?? this.query,
  );

  @override
  List<Object?> get props => [productId, productName, type, from, to, query];
}

/// Read-only audit queries over the immutable ledger (PRD §6.6).
class LedgerRepository {
  LedgerRepository(this._db);
  final db.AppDatabase _db;

  Stream<List<LedgerEntry>> watch(LedgerFilter filter, {int limit = 200}) {
    final q = _db.select(_db.stockMovements)
      ..orderBy([(m) => OrderingTerm.desc(m.occurredAt)])
      ..limit(limit);
    if (filter.productId != null) {
      q.where((m) => m.productId.equals(filter.productId!));
    }
    if (filter.type != null) {
      q.where((m) => m.movementType.equals(filter.type!));
    }
    if (filter.from != null) {
      q.where((m) => m.occurredAt.isBiggerOrEqualValue(filter.from!));
    }
    if (filter.to != null) {
      q.where((m) => m.occurredAt.isSmallerOrEqualValue(filter.to!));
    }
    return q.watch().asyncMap((rows) async {
      final products = await _db.select(_db.products).get();
      final names = {for (final p in products) p.id: p.name};
      var entries = rows
          .map(
            (m) => LedgerEntry(
              movement: m,
              productName: names[m.productId] ?? 'Unknown',
            ),
          )
          .toList();
      final needle = filter.query.trim().toLowerCase();
      if (needle.isNotEmpty) {
        entries = entries
            .where(
              (e) =>
                  e.productName.toLowerCase().contains(needle) ||
                  e.movement.referenceId.toLowerCase().contains(needle) ||
                  (e.movement.reason?.toLowerCase().contains(needle) ?? false),
            )
            .toList();
      }
      return entries;
    });
  }
}
