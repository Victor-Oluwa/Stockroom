import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_timeline.dart';
import '../../../core/widgets/app_ui.dart';
import '../domain/product.dart';
import 'product_detail_cubit.dart';
import 'widgets/product_image_view.dart';
import 'widgets/stock_badge.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(productRepositoryProvider);
    return BlocListener<ProductDetailCubit, ProductActionState>(
      listener: (context, state) {
        if (state is ProductActionDone) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.read<ProductDetailCubit>().reset();
        }
        if (state is ProductActionError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
          context.read<ProductDetailCubit>().reset();
        }
        if (state is ProductActionNeedsConfirm) {
          _confirmArchive(context, state.warning);
        }
      },
      child: StreamBuilder<Product?>(
        stream: repo.watchProduct(productId),
        builder: (context, snap) {
          if (!snap.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: const AppLoading(message: 'Loading product…'),
            );
          }
          final p = snap.data;
          if (p == null) {
            return Scaffold(
              appBar: AppBar(),
              body: const AppError(message: 'Product not found.'),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Product'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Edit',
                  onPressed: p.isArchived
                      ? null
                      : () => context.push('/inventory/${p.id}/edit'),
                ),
              ],
            ),
            body: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                if (p.isArchived) _archivedBanner(),
                _HeroCard(product: p),
                const SizedBox(height: 12),
                _facts(context, p),
                const SizedBox(height: 16),
                SectionHeader(
                  eyebrow: 'Recent movements',
                  actionLabel: 'All history',
                  onAction: () => context.push('/inventory/$productId/history'),
                ),
                const SizedBox(height: 8),
                _MovementsPreview(productId: productId, productName: p.name),
                const SizedBox(height: 16),
                if (!p.isArchived) ...[
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => context.push(
                            '/receive',
                            extra: {'productId': p.id},
                          ),
                          icon: const Icon(
                            Icons.call_received_outlined,
                            size: 18,
                          ),
                          label: const Text('Receive'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                              context.push('/inventory/${p.id}/adjust'),
                          icon: const Icon(Icons.tune_outlined, size: 18),
                          label: const Text('Adjust'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () =>
                            context.push('/inventory/$productId/history'),
                        icon: const Icon(Icons.history, size: 18),
                        label: const Text('Movements'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child:
                          BlocBuilder<ProductDetailCubit, ProductActionState>(
                            builder: (context, action) {
                              final working = action is ProductActionWorking;
                              if (p.isArchived) {
                                return FilledButton(
                                  onPressed: working
                                      ? null
                                      : () => context
                                            .read<ProductDetailCubit>()
                                            .unarchive(p.id),
                                  child: const Text('Restore'),
                                );
                              }
                              return OutlinedButton(
                                onPressed: working
                                    ? null
                                    : () => context
                                          .read<ProductDetailCubit>()
                                          .archive(p.id),
                                child: const Text('Archive'),
                              );
                            },
                          ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _archivedBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTokens.coal,
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        border: Border.all(color: AppTokens.lineStrong),
      ),
      child: const Row(
        children: [
          Icon(Icons.archive_outlined, color: AppTokens.taupe, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text('Archived. Hidden from new sales, kept in history.'),
          ),
        ],
      ),
    );
  }

  Widget _facts(BuildContext context, Product p) {
    final theme = Theme.of(context);
    final rows = [
      ('Selling price', formatNaira(p.sellingPriceKobo)),
      ('Average cost', formatNaira(p.averageCostKobo)),
      (
        'Stock value',
        formatNaira((p.quantityOnHandMilli * p.averageCostKobo + 500) ~/ 1000),
      ),
      ('Unit', p.unitLabel),
      if (p.sku != null) ('SKU', p.sku!),
      if (p.barcode != null) ('Barcode', p.barcode!),
      if (p.categoryName != null) ('Category', p.categoryName!),
      ('Low-stock at', formatQty(p.lowStockThresholdMilli, p.unitLabel)),
      if (p.description != null && p.description!.isNotEmpty)
        ('Notes', p.description!),
    ];
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: Text(
              'DETAILS',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTokens.taupe,
                letterSpacing: 1.1,
              ),
            ),
          ),
          for (final r in rows) ReportRow(label: r.$1, value: r.$2),
        ],
      ),
    );
  }

  Future<void> _confirmArchive(BuildContext context, String warning) async {
    final cubit = context.read<ProductDetailCubit>();
    cubit.reset();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive with stock on hand?'),
        content: Text(
          '$warning\n\nThe stock stays recorded and visible in history.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Archive anyway'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      cubit.archive(productId, confirmed: true);
    }
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = product;
    return AppCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProductImageView(relativePath: p.imagePath, size: 84),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  p.name,
                  style: theme.textTheme.titleLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                StockBadge(status: p.status),
                const SizedBox(height: 8),
                Text(
                  formatQty(p.quantityOnHandMilli, p.unitLabel),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFeatures: AppTokens.tabular,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${formatNaira(p.sellingPriceKobo)} per ${p.unitLabel}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTokens.taupe,
                    fontFeatures: AppTokens.tabular,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MovementsPreview extends ConsumerWidget {
  const _MovementsPreview({required this.productId, required this.productName});
  final String productId;
  final String productName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(productRepositoryProvider);
    return StreamBuilder<List<db.StockMovement>>(
      stream: repo.watchMovements(productId, limit: 6),
      builder: (context, snap) {
        final items = snap.data ?? const <db.StockMovement>[];
        if (items.isEmpty) {
          return const AppCard(
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.history, color: AppTokens.taupe),
              title: Text('No stock movements yet'),
              subtitle: Text('Receipts, sales and adjustments appear here.'),
            ),
          );
        }
        return AppCard(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              for (final m in items)
                MovementTimelineTile(entry: (productName, m)),
            ],
          ),
        );
      },
    );
  }
}
