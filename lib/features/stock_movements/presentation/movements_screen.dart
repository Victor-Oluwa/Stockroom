import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_timeline.dart';
import '../../../core/widgets/app_ui.dart';
import '../../inventory/domain/product.dart';
import '../data/ledger_repository.dart';

/// Global stock movement audit (PRD §6.6): filter by product, type,
/// date range and reference. Every row opens its source record.
class MovementsScreen extends ConsumerStatefulWidget {
  const MovementsScreen({super.key});
  @override
  ConsumerState<MovementsScreen> createState() => _MovementsScreenState();
}

class _MovementsScreenState extends ConsumerState<MovementsScreen> {
  LedgerFilter _filter = const LedgerFilter();
  final _search = TextEditingController();
  int _range = 0; // 0 all, 1 last 7d, 2 last 30d

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  LedgerFilter get _effective {
    final now = DateTime.now().toUtc();
    return switch (_range) {
      1 => _filter.copyWith(
        from: now.subtract(const Duration(days: 7)),
        clearDates: false,
      ),
      2 => _filter.copyWith(
        from: now.subtract(const Duration(days: 30)),
        clearDates: false,
      ),
      _ => _filter,
    };
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(ledgerRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Stock movements')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SearchField(
              controller: _search,
              hint: 'Search product, reference, reason',
              onChanged: (v) =>
                  setState(() => _filter = _filter.copyWith(query: v)),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                _productChip(),
                const SizedBox(width: 8),
                _typeChip(),
                const SizedBox(width: 8),
                for (final entry in [
                  (0, 'All time'),
                  (1, '7 days'),
                  (2, '30 days'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(entry.$2),
                      selected: _range == entry.$1,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => _range = entry.$1),
                    ),
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: StreamBuilder<List<LedgerEntry>>(
              stream: repo.watch(_effective),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const AppLoading(message: 'Loading movements…');
                }
                final items = snap.data!;
                if (items.isEmpty) {
                  return const AppEmpty(
                    icon: Icons.history,
                    title: 'No movements match',
                    message: 'Try widening the filters.',
                  );
                }
                return MovementTimeline(
                  padding: const EdgeInsets.only(bottom: 24),
                  linkProduct: true,
                  entries: [for (final e in items) (e.productName, e.movement)],
                  emptyIcon: Icons.history,
                  emptyTitle: 'No movements match',
                  emptyMessage: 'Try widening the filters.',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _typeChip() {
    return ActionChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_filter.type ?? 'All types'),
          const SizedBox(width: 4),
          const Icon(Icons.expand_more, size: 16),
        ],
      ),
      backgroundColor: _filter.type == null
          ? AppTokens.coalRaised
          : AppTokens.mossSoft,
      side: BorderSide(
        color: _filter.type == null
            ? AppTokens.lineStrong
            : AppTokens.moss.withValues(alpha: 0.5),
      ),
      onPressed: () async {
        final picked = await showModalBottomSheet<String?>(
          context: context,
          builder: (context) => SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  title: const Text('All types'),
                  trailing: _filter.type == null
                      ? const Icon(Icons.check, color: AppTokens.moss)
                      : null,
                  onTap: () => Navigator.pop(context, '__all__'),
                ),
                for (final t in movementTypes)
                  ListTile(
                    title: Text(MovementTimelineTile.friendlyType(t)),
                    trailing: _filter.type == t
                        ? const Icon(Icons.check, color: AppTokens.moss)
                        : null,
                    onTap: () => Navigator.pop(context, t),
                  ),
              ],
            ),
          ),
        );
        if (picked == null || !mounted) return;
        setState(
          () => _filter = _filter.copyWith(
            type: picked == '__all__' ? null : picked,
            clearType: picked == '__all__',
          ),
        );
      },
    );
  }

  Widget _productChip() {
    final name = _filter.productName;
    return InputChip(
      label: Text(name ?? 'Product'),
      avatar: const Icon(Icons.inventory_2_outlined, size: 16),
      onPressed: () async {
        final picked = await showDialog<Product>(
          context: context,
          builder: (context) => const _ProductSearchDialog(),
        );
        if (!mounted) return;
        if (picked == null) {
          setState(() => _filter = _filter.copyWith(clearProduct: true));
        } else {
          setState(
            () => _filter = _filter.copyWith(
              productId: picked.id,
              productName: picked.name,
            ),
          );
        }
      },
      onDeleted: name == null
          ? null
          : () =>
                setState(() => _filter = _filter.copyWith(clearProduct: true)),
    );
  }
}

class _ProductSearchDialog extends ConsumerStatefulWidget {
  const _ProductSearchDialog();
  @override
  ConsumerState<_ProductSearchDialog> createState() =>
      _ProductSearchDialogState();
}

class _ProductSearchDialogState extends ConsumerState<_ProductSearchDialog> {
  final _search = TextEditingController();
  List<Product> _results = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _run('');
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _run(String q) async {
    final repo = ref.read(productRepositoryProvider);
    final r = await repo.listProducts(
      ProductListFilter(query: q, showArchived: true),
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _results = r.fold((_) => const <Product>[], (v) => v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filter by product'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SearchField(
              controller: _search,
              hint: 'Search products',
              onChanged: _run,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _results.length,
                      itemBuilder: (context, i) => ListTile(
                        title: Text(_results[i].name),
                        onTap: () => Navigator.pop(context, _results[i]),
                      ),
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Clear'),
        ),
      ],
    );
  }
}
