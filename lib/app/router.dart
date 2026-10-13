import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/app_nav_bar.dart';
import 'di/providers.dart';
import 'router_tabs.dart';
import 'theme/tokens.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/expenses/presentation/expense_form_screen.dart';
import '../features/expenses/presentation/expense_list_screen.dart';
import '../features/inventory/domain/product.dart';
import '../features/inventory/presentation/category_cubit.dart';
import '../features/inventory/presentation/category_screen.dart';
import '../features/inventory/presentation/inventory_list_cubit.dart';
import '../features/inventory/presentation/inventory_list_screen.dart';
import '../features/inventory/presentation/product_detail_cubit.dart';
import '../features/inventory/presentation/product_detail_screen.dart';
import '../features/inventory/presentation/product_form_cubit.dart';
import '../features/inventory/presentation/product_form_screen.dart';
import '../features/inventory/presentation/product_history_screen.dart';
import '../features/onboarding/presentation/setup_cubit.dart';
import '../features/onboarding/presentation/setup_screen.dart';
import '../features/reports/presentation/reports_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/sales/presentation/cart_cubit.dart';
import '../features/sales/presentation/sale_builder_screen.dart';
import '../features/sales/presentation/sale_detail_screen.dart';
import '../features/sales/presentation/sale_receipt_screen.dart';
import '../features/sales/presentation/sales_history_screen.dart';
import '../features/sales/presentation/scan_screen.dart';
import '../features/stock_movements/presentation/adjust_cubit.dart';
import '../features/stock_movements/presentation/adjust_screen.dart';
import '../features/stock_movements/presentation/movements_screen.dart';
import '../features/stock_receiving/presentation/receipt_detail_screen.dart';
import '../features/stock_receiving/presentation/receipt_history_screen.dart';
import '../features/stock_receiving/presentation/receive_cubit.dart';
import '../features/stock_receiving/presentation/receive_screen.dart';
import '../features/suppliers/presentation/supplier_detail_screen.dart';
import '../features/suppliers/presentation/supplier_form_screen.dart';
import '../features/suppliers/presentation/supplier_list_cubit.dart';
import '../features/suppliers/presentation/supplier_list_screen.dart';

/// App routes. Phone: bottom nav; wide screens: navigation rail (PRD §5.1).
final _rootKey = GlobalKey<NavigatorState>();

GoRouter createRouter(WidgetRef ref) {
  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const _SplashScreen(),
      ),
      GoRoute(
        path: '/setup',
        builder: (context, state) {
          final repo = ref.watch(businessProfileRepositoryProvider);
          return BlocProvider(
            create: (_) => BusinessSetupCubit(repo),
            child: const SetupScreen(),
          );
        },
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => BlocProvider(
          create: (_) => CategoryCubit(ref.watch(categoryRepositoryProvider)),
          child: const CategoryScreen(),
        ),
      ),
      GoRoute(
        path: '/suppliers',
        builder: (context, state) => BlocProvider(
          create: (_) =>
              SupplierListCubit(ref.watch(supplierRepositoryProvider)),
          child: const SupplierListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'new',
            parentNavigatorKey: _rootKey,
            builder: (context, state) => const SupplierFormScreen.create(),
          ),
          GoRoute(
            path: ':id',
            parentNavigatorKey: _rootKey,
            builder: (context, state) =>
                SupplierDetailScreen(supplierId: state.pathParameters['id']!),
            routes: [
              GoRoute(
                path: 'edit',
                parentNavigatorKey: _rootKey,
                builder: (context, state) => SupplierFormScreen.edit(
                  supplierId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/receive',
        parentNavigatorKey: _rootKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          return BlocProvider(
            create: (_) =>
                ReceiveStockCubit(ref.watch(receiptRepositoryProvider)),
            child: ReceiveStockScreen(prefillProductId: extra?['productId']),
          );
        },
      ),
      GoRoute(
        path: '/receipts',
        builder: (context, state) => const ReceiptHistoryScreen(),
        routes: [
          GoRoute(
            path: ':id',
            parentNavigatorKey: _rootKey,
            builder: (context, state) =>
                ReceiptDetailScreen(receiptId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/movements',
        builder: (context, state) => const MovementsScreen(),
      ),
      GoRoute(
        path: '/expenses',
        builder: (context, state) => const ExpenseListScreen(),
        routes: [
          GoRoute(
            path: 'new',
            parentNavigatorKey: _rootKey,
            builder: (context, state) => const ExpenseFormScreen.create(),
          ),
          GoRoute(
            path: ':id/edit',
            parentNavigatorKey: _rootKey,
            builder: (context, state) =>
                ExpenseFormScreen.edit(expenseId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: '/scan',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const ScanScreen(),
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) {
          const items = [
            (Icons.dashboard_outlined, Icons.dashboard_rounded, 'Overview'),
            (
              Icons.inventory_2_outlined,
              Icons.inventory_2_rounded,
              'Inventory',
            ),
            (Icons.receipt_long_outlined, Icons.receipt_long_rounded, 'Sales'),
            (Icons.bar_chart_outlined, Icons.bar_chart_rounded, 'Reports'),
            (Icons.grid_view_outlined, Icons.grid_view_rounded, 'More'),
          ];
          // Wide screens (tablets) get a navigation rail instead of
          // the phone dock (PRD §5.1).
          return LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth >= 700) {
                return Scaffold(
                  body: Row(
                    children: [
                      NavigationRail(
                        selectedIndex: shell.currentIndex,
                        onDestinationSelected: shell.goBranch,
                        labelType: NavigationRailLabelType.all,
                        minWidth: 84,
                        destinations: [
                          for (final (icon, selected, label) in items)
                            NavigationRailDestination(
                              icon: Icon(icon),
                              selectedIcon: Icon(selected),
                              label: Text(label),
                            ),
                        ],
                      ),
                      const VerticalDivider(width: 1),
                      Expanded(child: shell),
                    ],
                  ),
                );
              }
              return Scaffold(
                body: shell,
                bottomNavigationBar: AppNavBar(
                  selectedIndex: shell.currentIndex,
                  onSelected: shell.goBranch,
                  destinations: [
                    for (final (icon, selected, label) in items)
                      AppNavBarDestination(
                        icon: icon,
                        selectedIcon: selected,
                        label: label,
                      ),
                  ],
                ),
              );
            },
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/overview',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                builder: (context, state) {
                  final params = state.uri.queryParameters;
                  final stock = switch (params['stock']) {
                    'low' => StockFilter.lowStock,
                    'out' => StockFilter.outOfStock,
                    _ => StockFilter.all,
                  };
                  final initial = ProductListFilter(
                    query: params['q'] ?? '',
                    stockFilter: stock,
                  );
                  return BlocProvider(
                    create: (_) => InventoryListCubit(
                      ref.watch(productRepositoryProvider),
                      initial,
                    ),
                    child: InventoryListScreen(initialFilter: initial),
                  );
                },
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) {
                      final extra = state.extra as Map<String, String>?;
                      return BlocProvider(
                        create: (_) => ProductFormCubit(
                          ref.watch(productRepositoryProvider),
                        ),
                        child: ProductFormScreen.create(
                          barcodePrefill: extra?['barcode'],
                        ),
                      );
                    },
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) {
                      final id = state.pathParameters['id']!;
                      return BlocProvider(
                        create: (_) => ProductDetailCubit(
                          ref.watch(productRepositoryProvider),
                        ),
                        child: ProductDetailScreen(productId: id),
                      );
                    },
                    routes: [
                      GoRoute(
                        path: 'edit',
                        parentNavigatorKey: _rootKey,
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return BlocProvider(
                            create: (_) => ProductFormCubit(
                              ref.watch(productRepositoryProvider),
                            ),
                            child: ProductFormScreen.edit(productId: id),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'history',
                        parentNavigatorKey: _rootKey,
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return ProductHistoryScreen(productId: id);
                        },
                      ),
                      GoRoute(
                        path: 'adjust',
                        parentNavigatorKey: _rootKey,
                        builder: (context, state) {
                          final id = state.pathParameters['id']!;
                          return BlocProvider(
                            create: (_) => AdjustStockCubit(
                              ref.watch(adjustmentRepositoryProvider),
                            ),
                            child: AdjustStockScreen(productId: id),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/sales',
                builder: (context, state) => const SalesHistoryScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) => BlocProvider(
                      create: (_) =>
                          SaleCartCubit(ref.watch(saleRepositoryProvider)),
                      child: const SaleBuilderScreen(),
                    ),
                  ),
                  GoRoute(
                    path: ':id',
                    parentNavigatorKey: _rootKey,
                    builder: (context, state) =>
                        SaleDetailScreen(saleId: state.pathParameters['id']!),
                    routes: [
                      GoRoute(
                        path: 'receipt',
                        parentNavigatorKey: _rootKey,
                        builder: (context, state) => SaleReceiptScreen(
                          saleId: state.pathParameters['id']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/reports',
                builder: (context, state) => const ReportsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/more',
                builder: (context, state) => const MoreScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class _SplashScreen extends ConsumerWidget {
  const _SplashScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final init = ref.watch(appInitProvider);
    final repo = ref.watch(businessProfileRepositoryProvider);
    Widget frame(Widget child) {
      final theme = Theme.of(context);
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: AppTokens.durSlow,
                  curve: AppTokens.easeEmph,
                  builder: (context, v, child) => Opacity(
                    opacity: v,
                    child: Transform.scale(scale: 0.8 + 0.2 * v, child: child),
                  ),
                  child: Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      color: AppTokens.moss,
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      size: 42,
                      color: AppTokens.onMoss,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Stockroom',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontFamily: AppTokens.displayFamily,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Offline stock, sales & profit',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppTokens.taupe,
                  ),
                ),
                const SizedBox(height: 28),
                child,
              ],
            ),
          ),
        ),
      );
    }

    return init.when(
      loading: () => frame(
        const SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(strokeWidth: 2.5),
        ),
      ),
      error: (_, _) => frame(
        const Text(
          'Something went wrong starting up. Please reopen the app.',
          textAlign: TextAlign.center,
        ),
      ),
      data: (_) => FutureBuilder(
        future: repo.read(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return frame(
              const SizedBox(
                width: 26,
                height: 26,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            );
          }
          final profile = snap.data!.fold((_) => null, (p) => p);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              context.go(profile == null ? '/setup' : '/overview');
            }
          });
          return frame(
            const SizedBox(
              width: 26,
              height: 26,
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
          );
        },
      ),
    );
  }
}
