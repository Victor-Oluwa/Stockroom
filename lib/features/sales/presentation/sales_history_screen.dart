import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_skeleton.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';

class SalesHistoryScreen extends ConsumerStatefulWidget {
  const SalesHistoryScreen({super.key});
  @override
  ConsumerState<SalesHistoryScreen> createState() => _SalesHistoryScreenState();
}

class _SalesHistoryScreenState extends ConsumerState<SalesHistoryScreen> {
  final _search = TextEditingController();
  bool _hideVoided = false;
  int _preset = 0; // 0 all, 1 today, 2 7d, 3 month
  List<db.Sale> _items = const [];
  bool _loading = true;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _run();
  }

  (DateTime?, DateTime?) _bounds() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day).toUtc();
    return switch (_preset) {
      1 => (startOfToday, startOfToday.add(const Duration(days: 1))),
      2 => (now.toUtc().subtract(const Duration(days: 7)), null),
      3 => (DateTime(now.year, now.month, 1).toUtc(), null),
      _ => (null, null),
    };
  }

  Future<void> _run() async {
    setState(() => _loading = true);
    final repo = ref.read(saleRepositoryProvider);
    final (from, to) = _bounds();
    final r = await repo.searchSales(
      _search.text,
      includeVoided: !_hideVoided,
      from: from,
      to: to,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _items = r.fold((_) => const <db.Sale>[], (v) => v);
    });
  }

  void _onSearch(String v) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _run);
    setState(() {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = _items.where((s) => s.status != 'VOIDED').toList();
    final voidedCount = _items.length - completed.length;
    final total = completed.fold<int>(0, (s, e) => s + e.totalKobo);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          if (!_loading && _items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTokens.mossSoft,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppTokens.moss.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    '${completed.length} sold',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppTokens.moss,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SearchField(
              controller: _search,
              hint: 'Search number or customer',
              onChanged: _onSearch,
              onClear: () {
                _search.clear();
                _run();
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                for (final e in [
                  (0, 'All time'),
                  (1, 'Today'),
                  (2, '7 days'),
                  (3, 'This month'),
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(e.$2),
                      selected: _preset == e.$1,
                      showCheckmark: false,
                      onSelected: (_) {
                        setState(() => _preset = e.$1);
                        _run();
                      },
                    ),
                  ),
                FilterChip(
                  label: const Text('Hide voided'),
                  selected: _hideVoided,
                  showCheckmark: false,
                  avatar: _hideVoided
                      ? const Icon(Icons.check, size: 16)
                      : null,
                  onSelected: (v) {
                    setState(() => _hideVoided = v);
                    _run();
                  },
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTokens.line)),
            ),
          ),
          if (!_loading && _items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: StaggerIn(
                index: 0,
                child: _SummaryHero(
                  total: total,
                  completedCount: completed.length,
                  voidedCount: voidedCount,
                ),
              ),
            ),
          Expanded(
            child: _loading
                ? ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                    itemCount: 6,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (_, _) =>
                        const AppSkeleton(height: 72, radius: 16),
                  )
                : _items.isEmpty
                ? AppEmpty(
                    icon: Icons.receipt_long_outlined,
                    title: 'No sales found',
                    message: _search.text.trim().isEmpty
                        ? 'Completed sales appear here.'
                        : 'Try a different number, customer or period.',
                    actionLabel: 'Start a sale',
                    onAction: () => context.push('/sales/new'),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
                    itemCount: _items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) {
                      final s = _items[i];
                      return StaggerIn(
                        index: i.clamp(0, 6),
                        child: _SaleCard(sale: s),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/sales/new'),
        icon: const Icon(Icons.add),
        label: const Text('New sale'),
      ),
    );
  }
}

class _SummaryHero extends StatelessWidget {
  const _SummaryHero({
    required this.total,
    required this.completedCount,
    required this.voidedCount,
  });
  final int total;
  final int completedCount;
  final int voidedCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTokens.mossSoft,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(
                color: AppTokens.moss.withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.payments_outlined,
              size: 21,
              color: AppTokens.moss,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NET SALES · THIS VIEW',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTokens.taupe,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  formatNaira(total),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFeatures: AppTokens.tabular,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$completedCount completed'
                  '${voidedCount > 0 ? ' · $voidedCount voided excluded' : ''}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTokens.taupe,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.receipt_long_outlined,
            size: 18,
            color: AppTokens.taupeDim,
          ),
        ],
      ),
    );
  }
}

class _SaleCard extends StatelessWidget {
  const _SaleCard({required this.sale});
  final db.Sale sale;

  IconData _payIcon(String method) {
    final m = method.toLowerCase();
    if (m.contains('cash')) return Icons.payments_outlined;
    if (m.contains('transfer') || m.contains('bank')) {
      return Icons.account_balance_outlined;
    }
    if (m.contains('card')) return Icons.credit_card_outlined;
    return Icons.receipt_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final voided = sale.status == 'VOIDED';
    final customer = (sale.customerName ?? '').trim();
    final subtitle =
        '${formatDateTimeLocal(sale.soldAt)} · ${sale.paymentMethod}'
        '${customer.isNotEmpty ? ' · $customer' : ''}';
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/sales/${sale.id}'),
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: voided
                      ? AppTokens.coalRaised
                      : AppTokens.mossSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: voided
                        ? AppTokens.line
                        : AppTokens.moss.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  voided ? Icons.cancel_outlined : _payIcon(sale.paymentMethod),
                  size: 19,
                  color: voided ? AppTokens.taupeDim : AppTokens.moss,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            sale.saleNumber,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              decoration: voided
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: voided ? AppTokens.taupeDim : null,
                            ),
                          ),
                        ),
                        if (voided) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTokens.coalRaised,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppTokens.lineStrong),
                            ),
                            child: Text(
                              'VOIDED',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppTokens.taupe,
                                letterSpacing: 0.8,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTokens.taupe,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatNaira(sale.totalKobo),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontFeatures: AppTokens.tabular,
                      color: voided ? AppTokens.taupeDim : AppTokens.bone,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Icon(
                    Icons.chevron_right_outlined,
                    size: 16,
                    color: AppTokens.taupeDim,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
