import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockroom/core/database/app_database.dart';
import 'package:stockroom/features/inventory/data/category_repository.dart';
import 'package:stockroom/features/inventory/data/product_repository.dart';
import 'package:stockroom/features/inventory/domain/product.dart';

AppDatabase _memoryDb() => AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  group('product catalogue (PRD Phase 2 gate)', () {
    test('create with opening 50 writes +50 movement and qty 50', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftProductRepository(db);

      final created = await repo.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1500000,
        openingQtyMilli: 50000,
        openingUnitCostKobo: 1000000,
      );
      expect(created.isRight(), isTrue);
      final product = created.getOrElse((_) => throw StateError('left'));
      expect(product.quantityOnHandMilli, 50000);
      expect(product.averageCostKobo, 1000000);

      final movements = await repo.watchMovements(product.id).first;
      expect(movements.length, 1);
      expect(movements.single.movementType, 'OPENING_STOCK');
      expect(movements.single.quantityDeltaMilli, 50000);

      final integrity = await repo.checkIntegrity();
      expect(integrity.getOrElse((_) => throw StateError('left')), isEmpty);
    });

    test('opening qty above zero requires unit cost', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftProductRepository(db);
      final r = await repo.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1500000,
        openingQtyMilli: 5000,
      );
      expect(r.isLeft(), isTrue);
    });

    test('zero price needs explicit confirmation', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftProductRepository(db);
      final denied = await repo.createProduct(
        name: 'Freebie',
        unitLabel: 'piece',
        sellingPriceKobo: 0,
      );
      expect(denied.isLeft(), isTrue);
      final allowed = await repo.createProduct(
        name: 'Freebie',
        unitLabel: 'piece',
        sellingPriceKobo: 0,
        zeroPriceConfirmed: true,
      );
      expect(allowed.isRight(), isTrue);
    });

    test('duplicate SKU/barcode rejected at repository layer', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftProductRepository(db);
      final first = await repo.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1000,
        sku: 'CH-1',
        barcode: '123456',
      );
      expect(first.isRight(), isTrue);
      final dupSku = await repo.createProduct(
        name: 'Table',
        unitLabel: 'piece',
        sellingPriceKobo: 1000,
        sku: 'ch-1', // case-insensitive duplicate
      );
      expect(dupSku.isLeft(), isTrue);
      final dupBarcode = await repo.createProduct(
        name: 'Table',
        unitLabel: 'piece',
        sellingPriceKobo: 1000,
        barcode: ' 123456 ',
      );
      expect(dupBarcode.isLeft(), isTrue);
    });

    test('updateDetails never changes quantity or writes movements', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftProductRepository(db);
      final created = await repo.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1500000,
        openingQtyMilli: 10000,
        openingUnitCostKobo: 900000,
      );
      final p = created.getOrElse((_) => throw StateError('left'));
      final updated = await repo.updateDetails(
        id: p.id,
        name: 'Armchair',
        unitLabel: 'piece',
        sellingPriceKobo: 1700000,
        lowStockThresholdMilli: 2000,
      );
      expect(updated.isRight(), isTrue);
      final after = updated.getOrElse((_) => throw StateError('left'));
      expect(after.name, 'Armchair');
      expect(after.quantityOnHandMilli, 10000);
      expect(after.averageCostKobo, 900000);
      final movements = await repo.watchMovements(p.id).first;
      expect(movements.length, 1); // still only opening
    });

    test('archived products hidden from default list but loadable', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftProductRepository(db);
      final created = await repo.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1000,
      );
      final p = created.getOrElse((_) => throw StateError('left'));
      // No stock: archives without confirmation.
      expect((await repo.archive(p.id)).isRight(), isTrue);
      final hidden = await repo.listProducts(const ProductListFilter());
      expect(hidden.getOrElse((_) => throw StateError('left')), isEmpty);
      final shown = await repo.listProducts(
        const ProductListFilter(showArchived: true),
      );
      expect(shown.getOrElse((_) => throw StateError('left')).length, 1);
      final direct = await repo.getProduct(p.id);
      expect(direct.getOrElse((_) => throw StateError('left')), isNotNull);
    });

    test('archiving with stock requires confirmation', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftProductRepository(db);
      final created = await repo.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1000,
        openingQtyMilli: 5000,
        openingUnitCostKobo: 500,
      );
      final p = created.getOrElse((_) => throw StateError('left'));
      final denied = await repo.archive(p.id);
      expect(denied.isLeft(), isTrue);
      final allowed = await repo.archive(p.id, confirmedWithStock: true);
      expect(allowed.isRight(), isTrue);
    });

    test('idempotent retry with same productId returns one product', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftProductRepository(db);
      const opKey = 'op-123';
      final a = await repo.createProduct(
        productId: opKey,
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1000,
        openingQtyMilli: 5000,
        openingUnitCostKobo: 500,
      );
      final b = await repo.createProduct(
        productId: opKey,
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 1000,
        openingQtyMilli: 5000,
        openingUnitCostKobo: 500,
      );
      expect(a.isRight() && b.isRight(), isTrue);
      final list = await repo.listProducts(
        const ProductListFilter(showArchived: true),
      );
      expect(list.getOrElse((_) => throw StateError('left')).length, 1);
      final movements = await repo.watchMovements(opKey).first;
      expect(movements.length, 1);
    });

    test('search/filter/sort share one implementation', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftProductRepository(db);
      await repo.createProduct(
        name: 'Chair',
        unitLabel: 'piece',
        sellingPriceKobo: 5000,
      );
      await repo.createProduct(
        name: 'Table',
        unitLabel: 'piece',
        sellingPriceKobo: 2000,
        openingQtyMilli: 2000,
        openingUnitCostKobo: 1000,
        lowStockThresholdMilli: 5000,
      );
      final search = await repo.listProducts(
        const ProductListFilter(query: 'chai'),
      );
      expect(search.getOrElse((_) => throw StateError('left')).length, 1);
      final low = await repo.listProducts(
        const ProductListFilter(stockFilter: StockFilter.lowStock),
      );
      expect(
        low.getOrElse((_) => throw StateError('left')).single.name,
        'Table',
      );
      final sorted = await repo.listProducts(
        const ProductListFilter(sort: ProductSort.priceHighToLow),
      );
      final items = sorted.getOrElse((_) => throw StateError('left'));
      expect(items.first.name, 'Chair');
    });

    test('duplicate category names rejected', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final cats = DriftCategoryRepository(db);
      expect((await cats.create('Furniture')).isRight(), isTrue);
      expect((await cats.create('  furniture ')).isLeft(), isTrue);
    });
  });
}
