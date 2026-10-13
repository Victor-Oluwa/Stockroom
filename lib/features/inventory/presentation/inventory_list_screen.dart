import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_skeleton.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';
import '../domain/category.dart';
import '../domain/product.dart';
import 'inventory_list_cubit.dart';
import 'widgets/product_image_view.dart';
import 'widgets/stock_badge.dart';

class InventoryListScreen extends StatefulWidget {
  const InventoryListScreen({super.key, this.initialFilter});
  final ProductListFilter? initialFilter;
  @override
  State<InventoryListScreen> createState() => _InventoryListScreenState();
}

class _InventoryListScreenState extends State<InventoryListScreen> {
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final q = widget.initialFilter?.query ?? '';
    if (q.isNotEmpty) _search.text = q;
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () {
      if (mounted) context.read<InventoryListCubit>().setQuery(v);
    });
    setState(() {});
  }

  void _clearSearch() {
    _debounce?.cancel();
    _search.clear();
    context.read<InventoryListCubit>().setQuery('');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Manage categories',
            onPressed: () => context.push('/categories'),
          ),
          _SortMenu(),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: SearchField(
                    controller: _search,
                    hint: 'Search name, SKU or barcode',
                    onChanged: _onSearchChanged,
                    onClear: _clearSearch,
                  ),
                ),
                const SizedBox(width: 10),
                _ScanButton(
                  onCode: (code) {
                    _search.text = code;
                    context.read<InventoryListCubit>().setQuery(code);
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          _FilterRow(),
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTokens.line)),
            ),
          ),
          Expanded(child: _ListBody(searchText: _search.text)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/inventory/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add product'),
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onCode});
  final ValueChanged<String> onCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppTokens.moss,
        borderRadius: BorderRadius.circular(AppTokens.controlRadius),
      ),
      child: IconButton(
        icon: const Icon(Icons.qr_code_scanner, color: AppTokens.onMoss),
        tooltip: 'Scan barcode',
        onPressed: () async {
          final code = await context.push<String>('/scan');
          if (code != null && code.isNotEmpty) onCode(code);
        },
      ),
    );
  }
}

class _FilterRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryListCubit, InventoryListState>(
      builder: (context, state) {
        final cubit = context.read<InventoryListCubit>();
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              for (final entry in [
                (StockFilter.all, 'All'),
                (StockFilter.lowStock, 'Low'),
                (StockFilter.outOfStock, 'Out'),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(entry.$2),
                    selected: state.filter.stockFilter == entry.$1,
                    showCheckmark: false,
                    onSelected: (_) => cubit.setStockFilter(entry.$1),
                  ),
                ),
              const SizedBox(width: 4),
              _CategoryButton(
                selectedId: state.filter.categoryId,
                onPick: cubit.setCategory,
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Archived'),
                selected: state.filter.showArchived,
                showCheckmark: false,
                avatar: state.filter.showArchived
                    ? const Icon(Icons.check, size: 16)
                    : null,
                onSelected: (v) => cubit.toggleArchived(v),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CategoryButton extends ConsumerWidget {
  const _CategoryButton({required this.selectedId, required this.onPick});
  final String? selectedId;
  final ValueChanged<String?> onPick;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(categoryRepositoryProvider);
    return StreamBuilder<List<ProductCategory>>(
      stream: repo.watchActive(),
      builder: (context, snap) {
        final cats = snap.data ?? const <ProductCategory>[];
        final current = cats
            .where((c) => c.id == selectedId)
            .map((c) => c.name)
            .firstOrNull;
        return ActionChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  current ?? 'Category',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.expand_more, size: 16),
            ],
          ),
          backgroundColor: selectedId == null
              ? AppTokens.coalRaised
              : AppTokens.mossSoft,
          side: BorderSide(
            color: selectedId == null
                ? AppTokens.lineStrong
                : AppTokens.moss.withValues(alpha: 0.5),
          ),
          onPressed: () => _openPicker(context, cats),
        );
      },
    );
  }

  Future<void> _openPicker(
    BuildContext context,
    List<ProductCategory> cats,
  ) async {
    const allSentinel = '__all__';
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              title: const Text('All categories'),
              trailing: selectedId == null ? const Icon(Icons.check) : null,
              onTap: () => Navigator.pop(context, allSentinel),
            ),
            for (final c in cats)
              ListTile(
                title: Text(c.name),
                trailing: selectedId == c.id ? const Icon(Icons.check) : null,
                onTap: () => Navigator.pop(context, c.id),
              ),
          ],
        ),
      ),
    );
    if (picked == null) return; // dismissed — no change
    onPick(picked == allSentinel ? null : picked);
  }
}

class _SortMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryListCubit, InventoryListState>(
      builder: (context, state) {
        const labels = {
          ProductSort.nameAsc: 'Name',
          ProductSort.recentlyUpdated: 'Recently updated',
          ProductSort.quantityLowToHigh: 'Qty: low first',
          ProductSort.quantityHighToLow: 'Qty: high first',
          ProductSort.priceLowToHigh: 'Price: low first',
          ProductSort.priceHighToLow: 'Price: high first',
        };
        return PopupMenuButton<ProductSort>(
          icon: Badge(
            isLabelVisible: state.filter.sort != ProductSort.nameAsc,
            child: const Icon(Icons.sort),
          ),
          tooltip: 'Sort',
          onSelected: (s) => context.read<InventoryListCubit>().setSort(s),
          itemBuilder: (context) => [
            for (final e in labels.entries)
              CheckedPopupMenuItem(
                value: e.key,
                checked: state.filter.sort == e.key,
                child: Text(e.value),
              ),
          ],
        );
      },
    );
  }
}

class _ListBody extends StatelessWidget {
  const _ListBody({required this.searchText});
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryListCubit, InventoryListState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const SkeletonList(count: 5);
        }
        if (state.error != null) {
          return AppError(
            message: state.error!,
            onRetry: () => context.read<InventoryListCubit>().refresh(),
          );
        }
        if (state.products.isEmpty) {
          final q = searchText.trim();
          return AppEmpty(
            icon: Icons.inventory_2_outlined,
            title: q.isEmpty ? 'No products yet' : 'No matches for “$q”',
            message: q.isEmpty
                ? 'Add products to track stock levels.'
                : 'Check the spelling or create a product with this barcode.',
            actionLabel: q.isEmpty ? 'Add product' : 'Create with “$q”',
            onAction: () => context.push(
              '/inventory/new',
              extra: q.isEmpty ? null : {'barcode': q},
            ),
          );
        }
        // Out-of-stock first, then lowest relative to threshold (PRD §6.2).
        final items = List<Product>.of(state.products)
          ..sort((a, b) {
            int rank(Product p) => p.status == StockStatus.outOfStock
                ? 0
                : p.status == StockStatus.lowStock
                ? 1
                : 2;
            final r = rank(a).compareTo(rank(b));
            if (r != 0) return r;
            return a.name.toLowerCase().compareTo(b.name.toLowerCase());
          });
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final p = items[i];
            return _ProductCard(product: p);
          },
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = product;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        onTap: () => context.push('/inventory/${p.id}'),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ProductImageView(relativePath: p.imagePath, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      [
                        if (p.sku != null) p.sku!,
                        if (p.barcode != null) p.barcode!,
                        formatNaira(p.sellingPriceKobo),
                      ].join(' · '),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTokens.taupe,
                        fontFeatures: AppTokens.tabular,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StockBadge(status: p.status),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatQty(p.quantityOnHandMilli, p.unitLabel),
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFeatures: AppTokens.tabular,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'on hand',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTokens.taupeDim,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 2),
              const Icon(
                Icons.chevron_right_outlined,
                color: AppTokens.taupeDim,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
