import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockroom/core/database/app_database.dart';
import 'package:stockroom/features/onboarding/data/business_profile_repository.dart';

AppDatabase _memoryDb() => AppDatabase.forTesting(NativeDatabase.memory());

void main() {
  group('foundation database', () {
    test('migrates to v1 and enforces FKs', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      expect(db.schemaVersion, 1);
      // FK enforcement on: inserting movement for missing product fails.
      expect(
        () => db
            .into(db.stockMovements)
            .insert(
              StockMovementsCompanion.insert(
                id: 'm1',
                productId: 'missing',
                movementType: 'SALE',
                quantityDeltaMilli: -1000,
                occurredAt: DateTime.now().toUtc(),
                referenceType: 'sale',
                referenceId: 's1',
                idempotencyKey: 'k1',
                createdAt: DateTime.now().toUtc(),
              ),
            ),
        throwsA(anything),
      );
    });

    test('profile persists and SKU uniqueness enforced', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      final repo = DriftBusinessProfileRepository(db);

      final saved = await repo.save(businessName: 'Test Shop');
      expect(saved.isRight(), isTrue);
      final read = await repo.read();
      expect(read.getOrElse((_) => null)?.businessName, 'Test Shop');

      final now = DateTime.now().toUtc();
      await db
          .into(db.products)
          .insert(
            ProductsCompanion.insert(
              id: 'p1',
              name: 'Chair',
              normalizedName: 'chair',
              unitLabel: 'piece',
              sellingPriceKobo: 1500000,
              createdAt: now,
              updatedAt: now,
              sku: const Value('CH-1'),
            ),
          );
      // Duplicate normalised SKU rejected at DB layer, not just forms.
      expect(
        () => db
            .into(db.products)
            .insert(
              ProductsCompanion.insert(
                id: 'p2',
                name: 'Chair 2',
                normalizedName: 'chair 2',
                unitLabel: 'piece',
                sellingPriceKobo: 1500000,
                createdAt: now,
                updatedAt: now,
                sku: const Value('CH-1'),
              ),
            ),
        throwsA(anything),
      );
    });

    test('default settings row is created', () async {
      final db = _memoryDb();
      addTearDown(db.close);
      await db.ensureDefaultSettings();
      final s = await db.readSettings();
      expect(s, isNotNull);
      expect(s!.defaultLowStockThresholdMilli, 5000);
    });
  });
}
