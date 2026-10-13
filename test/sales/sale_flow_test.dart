import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stockroom/app/di/providers.dart';
import 'package:stockroom/core/database/app_database.dart';
import 'package:stockroom/features/inventory/data/product_repository.dart';
import 'package:stockroom/features/inventory/domain/product.dart';
import 'package:stockroom/features/sales/data/sale_repository.dart';
import 'package:stockroom/features/sales/presentation/cart_cubit.dart';
import 'package:stockroom/features/sales/presentation/sale_builder_screen.dart';

void main() {
  testWidgets('search, add, and complete a sale end to end', (tester) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.ensureDefaultSettings();
    final products = DriftProductRepository(db);
    await products.createProduct(
      name: 'Chair',
      unitLabel: 'piece',
      sellingPriceKobo: 1500000,
      openingQtyMilli: 50000,
      openingUnitCostKobo: 1000000,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: BlocProvider(
            create: (_) => SaleCartCubit(DriftSaleRepository(db)),
            child: const SaleBuilderScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Lands on an empty cart, but products are browsable right away.
    expect(find.text('Cart is empty'), findsOneWidget);
    expect(find.text('Available — tap to add'), findsOneWidget);

    // Search finds the product.
    await tester.enterText(
      find.widgetWithText(TextField, 'Search name, SKU, barcode'),
      'chai',
    );
    await tester.pumpAndSettle();
    expect(find.text('Chair'), findsWidgets);

    // Add it to the cart.
    await tester.tap(find.byTooltip('Add to sale').first);
    await tester.pumpAndSettle();
    expect(find.text('Cart is empty'), findsNothing);

    // Complete the sale.
    final complete = find.textContaining('Complete sale');
    await tester.ensureVisible(complete);
    await tester.pumpAndSettle();
    await tester.tap(complete);
    await tester.pumpAndSettle();
    expect(find.textContaining('completed'), findsOneWidget);

    // Stock actually moved: 50 -> 49.
    final after = await products.listProducts(const ProductListFilter());
    expect(
      after.getOrElse((_) => throw StateError('x')).single.quantityOnHandMilli,
      49000,
    );
  });

  testWidgets('no-match search guides toward creating the product', (
    tester,
  ) async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    await db.ensureDefaultSettings();
    DriftProductRepository(db);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          home: BlocProvider(
            create: (_) => SaleCartCubit(DriftSaleRepository(db)),
            child: const SaleBuilderScreen(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Empty inventory: guided toward adding the first product.
    expect(find.text('No products yet'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Search name, SKU, barcode'),
      'zzz-no-such-thing',
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No matches for'), findsOneWidget);
    expect(find.text('New product'), findsOneWidget);
  });
}
