import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../domain/supplier.dart';

abstract class SupplierRepository {
  Stream<List<Supplier>> watchSuppliers({bool showArchived = false});
  Future<Result<List<Supplier>>> search(
    String query, {
    bool showArchived = false,
  });
  Future<Result<Supplier?>> get(String id);
  Stream<Supplier?> watch(String id);
  Future<Result<Supplier>> create({
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? notes,
  });
  Future<Result<Supplier>> update({
    required String id,
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? notes,
  });
  Future<Result<void>> archive(String id);
  Future<Result<void>> unarchive(String id);
  Stream<List<db.StockReceipt>> watchReceiptsFor(
    String supplierId, {
    int limit = 50,
  });
  Future<Result<int>> totalSpendKobo(String supplierId);
}

class DriftSupplierRepository implements SupplierRepository {
  DriftSupplierRepository(this._db, [Uuid? ids]) : _ids = ids ?? const Uuid();
  final db.AppDatabase _db;
  final Uuid _ids;

  Supplier _map(db.Supplier r) => Supplier(
    id: r.id,
    name: r.name,
    contactName: r.contactName,
    phone: r.phone,
    email: r.email,
    address: r.address,
    notes: r.notes,
    isArchived: r.isArchived,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );

  @override
  Stream<List<Supplier>> watchSuppliers({bool showArchived = false}) {
    final q = _db.select(_db.suppliers)
      ..orderBy([(s) => OrderingTerm.asc(s.name)]);
    if (!showArchived) q.where((s) => s.isArchived.equals(false));
    return q.watch().map((rows) => rows.map(_map).toList());
  }

  @override
  Future<Result<List<Supplier>>> search(
    String query, {
    bool showArchived = false,
  }) async {
    try {
      final q = _db.select(_db.suppliers)
        ..orderBy([(s) => OrderingTerm.asc(s.name)]);
      if (!showArchived) q.where((s) => s.isArchived.equals(false));
      final rows = await q.get();
      final needle = query.trim().toLowerCase();
      if (needle.isEmpty) return ok(rows.map(_map).toList());
      return ok(
        rows
            .where(
              (r) =>
                  r.name.toLowerCase().contains(needle) ||
                  (r.phone?.contains(query.trim()) ?? false) ||
                  (r.contactName?.toLowerCase().contains(needle) ?? false),
            )
            .map(_map)
            .toList(),
      );
    } catch (e) {
      return fail(DatabaseFailure('Could not load suppliers.', e));
    }
  }

  @override
  Future<Result<Supplier?>> get(String id) async {
    try {
      final row = await (_db.select(
        _db.suppliers,
      )..where((s) => s.id.equals(id))).getSingleOrNull();
      return ok(row == null ? null : _map(row));
    } catch (e) {
      return fail(DatabaseFailure('Could not load supplier.', e));
    }
  }

  @override
  Stream<Supplier?> watch(String id) {
    final q = _db.select(_db.suppliers)..where((s) => s.id.equals(id));
    return q.watchSingleOrNull().map((r) => r == null ? null : _map(r));
  }

  String? _clean(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  @override
  Future<Result<Supplier>> create({
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? notes,
  }) async {
    if (name.trim().isEmpty) {
      return fail(const ValidationFailure('Supplier name is required.'));
    }
    try {
      final now = DateTime.now().toUtc();
      final id = _ids.v4();
      await _db
          .into(_db.suppliers)
          .insert(
            db.SuppliersCompanion.insert(
              id: id,
              name: name.trim(),
              contactName: Value(_clean(contactName)),
              phone: Value(_clean(phone)),
              email: Value(_clean(email)),
              address: Value(_clean(address)),
              notes: Value(_clean(notes)),
              createdAt: now,
              updatedAt: now,
            ),
          );
      final row = await (_db.select(
        _db.suppliers,
      )..where((s) => s.id.equals(id))).getSingle();
      return ok(_map(row));
    } catch (e) {
      return fail(DatabaseFailure('Could not create supplier.', e));
    }
  }

  @override
  Future<Result<Supplier>> update({
    required String id,
    required String name,
    String? contactName,
    String? phone,
    String? email,
    String? address,
    String? notes,
  }) async {
    if (name.trim().isEmpty) {
      return fail(const ValidationFailure('Supplier name is required.'));
    }
    try {
      final existing = await (_db.select(
        _db.suppliers,
      )..where((s) => s.id.equals(id))).getSingleOrNull();
      if (existing == null) {
        return fail(const ValidationFailure('Supplier no longer exists.'));
      }
      await (_db.update(_db.suppliers)..where((s) => s.id.equals(id))).write(
        db.SuppliersCompanion(
          name: Value(name.trim()),
          contactName: Value(_clean(contactName)),
          phone: Value(_clean(phone)),
          email: Value(_clean(email)),
          address: Value(_clean(address)),
          notes: Value(_clean(notes)),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      final row = await (_db.select(
        _db.suppliers,
      )..where((s) => s.id.equals(id))).getSingle();
      return ok(_map(row));
    } catch (e) {
      return fail(DatabaseFailure('Could not update supplier.', e));
    }
  }

  @override
  Future<Result<void>> archive(String id) async {
    try {
      await (_db.update(_db.suppliers)..where((s) => s.id.equals(id))).write(
        db.SuppliersCompanion(
          isArchived: const Value(true),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return ok(null);
    } catch (e) {
      return fail(DatabaseFailure('Could not archive supplier.', e));
    }
  }

  @override
  Future<Result<void>> unarchive(String id) async {
    try {
      await (_db.update(_db.suppliers)..where((s) => s.id.equals(id))).write(
        db.SuppliersCompanion(
          isArchived: const Value(false),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return ok(null);
    } catch (e) {
      return fail(DatabaseFailure('Could not restore supplier.', e));
    }
  }

  @override
  Stream<List<db.StockReceipt>> watchReceiptsFor(
    String supplierId, {
    int limit = 50,
  }) {
    final q = _db.select(_db.stockReceipts)
      ..where((r) => r.supplierId.equals(supplierId))
      ..orderBy([(r) => OrderingTerm.desc(r.receivedAt)])
      ..limit(limit);
    return q.watch();
  }

  @override
  Future<Result<int>> totalSpendKobo(String supplierId) async {
    try {
      final rows = await (_db.select(
        _db.stockReceipts,
      )..where((r) => r.supplierId.equals(supplierId))).get();
      return ok(rows.fold<int>(0, (sum, r) => sum + r.totalCostKobo));
    } catch (e) {
      return fail(DatabaseFailure('Could not compute spend.', e));
    }
  }
}
