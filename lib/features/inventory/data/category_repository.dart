import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/quantity/quantity.dart' show normalizeName;
import '../domain/category.dart';

abstract class CategoryRepository {
  Stream<List<ProductCategory>> watchActive();
  Stream<List<ProductCategory>> watchAll();
  Future<Result<List<ProductCategory>>> listActive();
  Future<Result<ProductCategory>> create(String name);
  Future<Result<ProductCategory>> rename(String id, String name);
  Future<Result<void>> archive(String id);
  Future<Result<void>> unarchive(String id);
}

class DriftCategoryRepository implements CategoryRepository {
  DriftCategoryRepository(this._db, [Uuid? ids]) : _ids = ids ?? const Uuid();
  final db.AppDatabase _db;
  final Uuid _ids;

  ProductCategory _map(db.ProductCategory r) => ProductCategory(
    id: r.id,
    name: r.name,
    isArchived: r.isArchived,
    createdAt: r.createdAt,
    updatedAt: r.updatedAt,
  );

  @override
  Stream<List<ProductCategory>> watchActive() {
    final q = _db.select(_db.productCategories)
      ..where((c) => c.isArchived.equals(false))
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);
    return q.watch().map((rows) => rows.map(_map).toList());
  }

  @override
  Stream<List<ProductCategory>> watchAll() {
    final q = _db.select(_db.productCategories)
      ..orderBy([(c) => OrderingTerm.asc(c.name)]);
    return q.watch().map((rows) => rows.map(_map).toList());
  }

  @override
  Future<Result<List<ProductCategory>>> listActive() async {
    try {
      final rows =
          await (_db.select(_db.productCategories)
                ..where((c) => c.isArchived.equals(false))
                ..orderBy([(c) => OrderingTerm.asc(c.name)]))
              .get();
      return ok(rows.map(_map).toList());
    } catch (e) {
      return fail(DatabaseFailure('Could not load categories.', e));
    }
  }

  @override
  Future<Result<ProductCategory>> create(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return fail(const ValidationFailure('Category name is required.'));
    }
    try {
      final normalized = normalizeName(trimmed);
      final existing = await (_db.select(
        _db.productCategories,
      )..where((c) => c.normalizedName.equals(normalized))).getSingleOrNull();
      if (existing != null && !existing.isArchived) {
        return fail(const ValidationFailure('Category already exists.'));
      }
      if (existing != null && existing.isArchived) {
        // Revive archived with same name: keep history readable.
        final now = DateTime.now().toUtc();
        await (_db.update(
          _db.productCategories,
        )..where((c) => c.id.equals(existing.id))).write(
          db.ProductCategoriesCompanion(
            name: Value(trimmed),
            isArchived: const Value(false),
            updatedAt: Value(now),
          ),
        );
        final row = await (_db.select(
          _db.productCategories,
        )..where((c) => c.id.equals(existing.id))).getSingle();
        return ok(_map(row));
      }
      final now = DateTime.now().toUtc();
      final id = _ids.v4();
      await _db
          .into(_db.productCategories)
          .insert(
            db.ProductCategoriesCompanion.insert(
              id: id,
              name: trimmed,
              normalizedName: normalized,
              createdAt: now,
              updatedAt: now,
            ),
          );
      final row = await (_db.select(
        _db.productCategories,
      )..where((c) => c.id.equals(id))).getSingle();
      return ok(_map(row));
    } catch (e) {
      if (_isUniqueViolation(e)) {
        return fail(const ValidationFailure('Category already exists.'));
      }
      return fail(DatabaseFailure('Could not create category.', e));
    }
  }

  @override
  Future<Result<ProductCategory>> rename(String id, String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return fail(const ValidationFailure('Category name is required.'));
    }
    try {
      final normalized = normalizeName(trimmed);
      final clash =
          await (_db.select(_db.productCategories)..where(
                (c) =>
                    c.normalizedName.equals(normalized) & c.id.isNotValue(id),
              ))
              .getSingleOrNull();
      if (clash != null && !clash.isArchived) {
        return fail(const ValidationFailure('Category already exists.'));
      }
      await (_db.update(
        _db.productCategories,
      )..where((c) => c.id.equals(id))).write(
        db.ProductCategoriesCompanion(
          name: Value(trimmed),
          normalizedName: Value(normalized),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      final row = await (_db.select(
        _db.productCategories,
      )..where((c) => c.id.equals(id))).getSingle();
      return ok(_map(row));
    } catch (e) {
      if (_isUniqueViolation(e)) {
        return fail(const ValidationFailure('Category already exists.'));
      }
      return fail(DatabaseFailure('Could not rename category.', e));
    }
  }

  @override
  Future<Result<void>> archive(String id) async {
    try {
      await (_db.update(
        _db.productCategories,
      )..where((c) => c.id.equals(id))).write(
        db.ProductCategoriesCompanion(
          isArchived: const Value(true),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return ok(null);
    } catch (e) {
      return fail(DatabaseFailure('Could not archive category.', e));
    }
  }

  @override
  Future<Result<void>> unarchive(String id) async {
    try {
      await (_db.update(
        _db.productCategories,
      )..where((c) => c.id.equals(id))).write(
        db.ProductCategoriesCompanion(
          isArchived: const Value(false),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return ok(null);
    } catch (e) {
      return fail(DatabaseFailure('Could not restore category.', e));
    }
  }

  bool _isUniqueViolation(Object e) =>
      e.toString().contains('UNIQUE constraint');
}
