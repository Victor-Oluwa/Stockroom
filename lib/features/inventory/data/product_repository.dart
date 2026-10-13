import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart' as db;
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/quantity/quantity.dart'
    show normalizeBarcode, normalizeName, normalizeSku;
import '../domain/product.dart';

/// Ledger mismatch for integrity checker (PRD §6.6).
class StockMismatch {
  const StockMismatch({
    required this.productId,
    required this.productName,
    required this.cachedMilli,
    required this.ledgerMilli,
  });
  final String productId;
  final String productName;
  final int cachedMilli;
  final int ledgerMilli;
}

abstract class ProductRepository {
  Stream<List<Product>> watchProducts(ProductListFilter filter);
  Future<Result<List<Product>>> listProducts(ProductListFilter filter);
  Stream<Product?> watchProduct(String id);
  Future<Result<Product?>> getProduct(String id);
  Future<Result<Product>> createProduct({
    String? productId,
    required String name,
    String? sku,
    String? barcode,
    String? categoryId,
    required String unitLabel,
    required int sellingPriceKobo,
    bool zeroPriceConfirmed = false,
    int openingQtyMilli = 0,
    int? openingUnitCostKobo,
    int lowStockThresholdMilli = 5000,
    String? imagePath,
    String? description,
  });
  Future<Result<Product>> updateDetails({
    required String id,
    required String name,
    String? sku,
    String? barcode,
    String? categoryId,
    required String unitLabel,
    required int sellingPriceKobo,
    bool zeroPriceConfirmed = false,
    required int lowStockThresholdMilli,
    String? imagePath,
    String? description,
  });
  Future<Result<void>> archive(String id, {bool confirmedWithStock = false});
  Future<Result<void>> unarchive(String id);
  Future<Result<List<StockMismatch>>> checkIntegrity();
  Stream<List<db.StockMovement>> watchMovements(
    String productId, {
    int limit = 20,
  });
  Future<Result<Product?>> findByBarcodeExact(String barcode);
}

class DriftProductRepository implements ProductRepository {
  DriftProductRepository(this._db, [Uuid? ids]) : _ids = ids ?? const Uuid();
  final db.AppDatabase _db;
  final Uuid _ids;

  Product _map(db.Product p, String? categoryName) => Product(
    id: p.id,
    name: p.name,
    sku: p.sku,
    barcode: p.barcode,
    categoryId: p.categoryId,
    categoryName: categoryName,
    unitLabel: p.unitLabel,
    sellingPriceKobo: p.sellingPriceKobo,
    averageCostKobo: p.averageCostKobo,
    quantityOnHandMilli: p.quantityOnHandMilli,
    lowStockThresholdMilli: p.lowStockThresholdMilli,
    imagePath: p.imagePath,
    description: p.description,
    isArchived: p.isArchived,
    createdAt: p.createdAt,
    updatedAt: p.updatedAt,
  );

  Future<Map<String, String>> _categoryNames() async {
    final rows = await _db.select(_db.productCategories).get();
    return {for (final r in rows) r.id: r.name};
  }

  @override
  Stream<List<Product>> watchProducts(ProductListFilter filter) {
    // Base reactive query: category + archived flag. Search/stock/sort in Dart
    // to keep one source of truth with listProducts and avoid SQL dialect drift.
    final base = _db.select(_db.products);
    if (!filter.showArchived) {
      base.where((p) => p.isArchived.equals(false));
    }
    if (filter.categoryId != null) {
      base.where((p) => p.categoryId.equals(filter.categoryId!));
    }
    return base.watch().asyncMap((rows) async {
      final names = await _categoryNames();
      var items = rows.map((p) => _map(p, names[p.categoryId])).toList();
      items = _applyFilter(items, filter);
      return items;
    });
  }

  @override
  Future<Result<List<Product>>> listProducts(ProductListFilter filter) async {
    try {
      final q = _db.select(_db.products);
      if (!filter.showArchived) {
        q.where((p) => p.isArchived.equals(false));
      }
      if (filter.categoryId != null) {
        q.where((p) => p.categoryId.equals(filter.categoryId!));
      }
      final rows = await q.get();
      final names = await _categoryNames();
      var items = rows.map((p) => _map(p, names[p.categoryId])).toList();
      items = _applyFilter(items, filter);
      return ok(items);
    } catch (e) {
      return fail(DatabaseFailure('Could not load products.', e));
    }
  }

  List<Product> _applyFilter(List<Product> items, ProductListFilter filter) {
    final q = filter.query.trim().toLowerCase();
    var out = items;
    if (q.isNotEmpty) {
      out = out.where((p) {
        return p.name.toLowerCase().contains(q) ||
            (p.sku?.toLowerCase().contains(q) ?? false) ||
            (p.barcode?.contains(q.trim()) ?? false);
      }).toList();
    }
    switch (filter.stockFilter) {
      case StockFilter.all:
        break;
      case StockFilter.lowStock:
        out = out.where((p) => p.status == StockStatus.lowStock).toList();
      case StockFilter.outOfStock:
        out = out.where((p) => p.status == StockStatus.outOfStock).toList();
    }
    switch (filter.sort) {
      case ProductSort.nameAsc:
        out.sort(
          (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
        );
      case ProductSort.recentlyUpdated:
        out.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case ProductSort.quantityHighToLow:
        out.sort(
          (a, b) => b.quantityOnHandMilli.compareTo(a.quantityOnHandMilli),
        );
      case ProductSort.quantityLowToHigh:
        out.sort(
          (a, b) => a.quantityOnHandMilli.compareTo(b.quantityOnHandMilli),
        );
      case ProductSort.priceHighToLow:
        out.sort((a, b) => b.sellingPriceKobo.compareTo(a.sellingPriceKobo));
      case ProductSort.priceLowToHigh:
        out.sort((a, b) => a.sellingPriceKobo.compareTo(b.sellingPriceKobo));
    }
    return out;
  }

  @override
  Stream<Product?> watchProduct(String id) {
    final q = _db.select(_db.products)..where((p) => p.id.equals(id));
    return q.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;
      String? catName;
      if (row.categoryId != null) {
        final cat = await (_db.select(
          _db.productCategories,
        )..where((c) => c.id.equals(row.categoryId!))).getSingleOrNull();
        catName = cat?.name;
      }
      return _map(row, catName);
    });
  }

  @override
  Future<Result<Product?>> getProduct(String id) async {
    try {
      final row = await (_db.select(
        _db.products,
      )..where((p) => p.id.equals(id))).getSingleOrNull();
      if (row == null) return ok(null);
      String? catName;
      if (row.categoryId != null) {
        final cat = await (_db.select(
          _db.productCategories,
        )..where((c) => c.id.equals(row.categoryId!))).getSingleOrNull();
        catName = cat?.name;
      }
      return ok(_map(row, catName));
    } catch (e) {
      return fail(DatabaseFailure('Could not load product.', e));
    }
  }

  @override
  Future<Result<Product>> createProduct({
    String? productId,
    required String name,
    String? sku,
    String? barcode,
    String? categoryId,
    required String unitLabel,
    required int sellingPriceKobo,
    bool zeroPriceConfirmed = false,
    int openingQtyMilli = 0,
    int? openingUnitCostKobo,
    int lowStockThresholdMilli = 5000,
    String? imagePath,
    String? description,
  }) async {
    final validation = _validateDetails(
      name: name,
      unitLabel: unitLabel,
      sellingPriceKobo: sellingPriceKobo,
      zeroPriceConfirmed: zeroPriceConfirmed,
      lowStockThresholdMilli: lowStockThresholdMilli,
    );
    if (validation != null) return fail(validation);
    if (openingQtyMilli < 0) {
      return fail(
        const ValidationFailure('Opening quantity cannot be negative.'),
      );
    }
    if (openingQtyMilli > 0) {
      if (openingUnitCostKobo == null) {
        return fail(
          const ValidationFailure(
            'Opening unit cost is required when opening stock is above zero.',
          ),
        );
      }
      if (openingUnitCostKobo < 0) {
        return fail(
          const ValidationFailure('Opening cost cannot be negative.'),
        );
      }
    }
    final cleanName = name.trim();
    final normSku = normalizeSku(sku);
    final normBarcode = normalizeBarcode(barcode);
    if (categoryId != null) {
      final cat = await (_db.select(
        _db.productCategories,
      )..where((c) => c.id.equals(categoryId))).getSingleOrNull();
      if (cat == null) {
        return fail(
          const ValidationFailure('Selected category no longer exists.'),
        );
      }
    }
    final id = productId ?? _ids.v4();
    try {
      // Idempotent retry: same productId returns existing row.
      final existing = await (_db.select(
        _db.products,
      )..where((p) => p.id.equals(id))).getSingleOrNull();
      if (existing != null) {
        final got = await getProduct(id);
        return got.fold(
          (f) => fail(f),
          (p) => p == null
              ? fail(const DatabaseFailure('Could not create product.'))
              : ok(p),
        );
      }
      final now = DateTime.now().toUtc();
      final avgCost = openingQtyMilli > 0 ? openingUnitCostKobo! : 0;
      await _db.transaction(() async {
        await _db
            .into(_db.products)
            .insert(
              db.ProductsCompanion.insert(
                id: id,
                name: cleanName,
                normalizedName: normalizeName(cleanName),
                unitLabel: unitLabel,
                sellingPriceKobo: sellingPriceKobo,
                averageCostKobo: Value(avgCost),
                quantityOnHandMilli: Value(openingQtyMilli),
                lowStockThresholdMilli: Value(lowStockThresholdMilli),
                createdAt: now,
                updatedAt: now,
                sku: Value(normSku),
                barcode: Value(normBarcode),
                categoryId: Value(categoryId),
                imagePath: Value(_nullIfBlank(imagePath)),
                description: Value(_nullIfBlank(description)),
              ),
            );
        if (openingQtyMilli > 0) {
          await _db
              .into(_db.stockMovements)
              .insert(
                db.StockMovementsCompanion.insert(
                  id: _ids.v4(),
                  productId: id,
                  movementType: 'OPENING_STOCK',
                  quantityDeltaMilli: openingQtyMilli,
                  occurredAt: now,
                  referenceType: 'opening',
                  referenceId: id,
                  idempotencyKey: 'opening:$id',
                  createdAt: now,
                  unitCostKobo: Value(avgCost),
                ),
              );
        }
      });
      final got = await getProduct(id);
      return got.fold(
        (f) => fail(f),
        (p) => p == null
            ? fail(const DatabaseFailure('Could not create product.'))
            : ok(p),
      );
    } catch (e) {
      if (_isUniqueViolation(e)) {
        return fail(const DuplicateSkuBarcode());
      }
      return fail(DatabaseFailure('Could not create product.', e));
    }
  }

  @override
  Future<Result<Product>> updateDetails({
    required String id,
    required String name,
    String? sku,
    String? barcode,
    String? categoryId,
    required String unitLabel,
    required int sellingPriceKobo,
    bool zeroPriceConfirmed = false,
    required int lowStockThresholdMilli,
    String? imagePath,
    String? description,
  }) async {
    final validation = _validateDetails(
      name: name,
      unitLabel: unitLabel,
      sellingPriceKobo: sellingPriceKobo,
      zeroPriceConfirmed: zeroPriceConfirmed,
      lowStockThresholdMilli: lowStockThresholdMilli,
    );
    if (validation != null) return fail(validation);
    try {
      final existing = await (_db.select(
        _db.products,
      )..where((p) => p.id.equals(id))).getSingleOrNull();
      if (existing == null) return fail(const ProductNotFound());
      if (categoryId != null) {
        final cat = await (_db.select(
          _db.productCategories,
        )..where((c) => c.id.equals(categoryId))).getSingleOrNull();
        if (cat == null) {
          return fail(
            const ValidationFailure('Selected category no longer exists.'),
          );
        }
      }
      final cleanName = name.trim();
      await (_db.update(_db.products)..where((p) => p.id.equals(id))).write(
        db.ProductsCompanion(
          name: Value(cleanName),
          normalizedName: Value(normalizeName(cleanName)),
          sku: Value(normalizeSku(sku)),
          barcode: Value(normalizeBarcode(barcode)),
          categoryId: Value(categoryId),
          unitLabel: Value(unitLabel),
          sellingPriceKobo: Value(sellingPriceKobo),
          lowStockThresholdMilli: Value(lowStockThresholdMilli),
          imagePath: Value(_nullIfBlank(imagePath)),
          description: Value(_nullIfBlank(description)),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      final got = await getProduct(id);
      return got.fold(
        (f) => fail(f),
        (p) => p == null ? fail(const ProductNotFound()) : ok(p),
      );
    } catch (e) {
      if (_isUniqueViolation(e)) {
        return fail(const DuplicateSkuBarcode());
      }
      return fail(DatabaseFailure('Could not update product.', e));
    }
  }

  ValidationFailure? _validateDetails({
    required String name,
    required String unitLabel,
    required int sellingPriceKobo,
    required bool zeroPriceConfirmed,
    required int lowStockThresholdMilli,
  }) {
    if (name.trim().isEmpty) {
      return const ValidationFailure('Product name is required.');
    }
    if (!unitLabels.contains(unitLabel)) {
      return const ValidationFailure('Select a valid unit.');
    }
    if (sellingPriceKobo < 0) {
      return const ValidationFailure('Selling price cannot be negative.');
    }
    if (sellingPriceKobo == 0 && !zeroPriceConfirmed) {
      return const ValidationFailure(
        'Confirm that this product is really free (₦0).',
      );
    }
    if (lowStockThresholdMilli < 0) {
      return const ValidationFailure('Low-stock threshold cannot be negative.');
    }
    return null;
  }

  @override
  Future<Result<void>> archive(
    String id, {
    bool confirmedWithStock = false,
  }) async {
    try {
      final row = await (_db.select(
        _db.products,
      )..where((p) => p.id.equals(id))).getSingleOrNull();
      if (row == null) return fail(const ProductNotFound());
      if (row.quantityOnHandMilli > 0 && !confirmedWithStock) {
        return fail(
          ValidationFailure(
            '“${row.name}” still has stock. Confirm archiving with stock on hand.',
          ),
        );
      }
      await (_db.update(_db.products)..where((p) => p.id.equals(id))).write(
        db.ProductsCompanion(
          isArchived: const Value(true),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return ok(null);
    } catch (e) {
      return fail(DatabaseFailure('Could not archive product.', e));
    }
  }

  @override
  Future<Result<void>> unarchive(String id) async {
    try {
      await (_db.update(_db.products)..where((p) => p.id.equals(id))).write(
        db.ProductsCompanion(
          isArchived: const Value(false),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      );
      return ok(null);
    } catch (e) {
      return fail(DatabaseFailure('Could not restore product.', e));
    }
  }

  @override
  Future<Result<List<StockMismatch>>> checkIntegrity() async {
    try {
      final products = await _db.select(_db.products).get();
      final out = <StockMismatch>[];
      for (final p in products) {
        final sum = await _ledgerSum(p.id);
        if (sum != p.quantityOnHandMilli) {
          out.add(
            StockMismatch(
              productId: p.id,
              productName: p.name,
              cachedMilli: p.quantityOnHandMilli,
              ledgerMilli: sum,
            ),
          );
        }
      }
      return ok(out);
    } catch (e) {
      return fail(DatabaseFailure('Integrity check failed.', e));
    }
  }

  Future<int> _ledgerSum(String productId) async {
    final rows = await (_db.select(
      _db.stockMovements,
    )..where((m) => m.productId.equals(productId))).get();
    return rows.fold<int>(0, (sum, m) => sum + m.quantityDeltaMilli);
  }

  @override
  Stream<List<db.StockMovement>> watchMovements(
    String productId, {
    int limit = 20,
  }) {
    final q = _db.select(_db.stockMovements)
      ..where((m) => m.productId.equals(productId))
      ..orderBy([(m) => OrderingTerm.desc(m.occurredAt)])
      ..limit(limit);
    return q.watch();
  }

  @override
  Future<Result<Product?>> findByBarcodeExact(String barcode) async {
    final code = normalizeBarcode(barcode);
    if (code == null) return ok(null);
    try {
      final row = await (_db.select(
        _db.products,
      )..where((p) => p.barcode.equals(code))).getSingleOrNull();
      if (row == null) return ok(null);
      String? catName;
      if (row.categoryId != null) {
        final cat = await (_db.select(
          _db.productCategories,
        )..where((c) => c.id.equals(row.categoryId!))).getSingleOrNull();
        catName = cat?.name;
      }
      return ok(_map(row, catName));
    } catch (e) {
      return fail(DatabaseFailure('Barcode lookup failed.', e));
    }
  }

  String? _nullIfBlank(String? v) {
    final t = v?.trim();
    return (t == null || t.isEmpty) ? null : t;
  }

  bool _isUniqueViolation(Object e) =>
      e.toString().contains('UNIQUE constraint');
}
