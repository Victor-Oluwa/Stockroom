import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/dates/date_range.dart';
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_motion.dart';
import '../../../core/widgets/app_skeleton.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';
import '../../inventory/domain/product.dart';
import '../../onboarding/domain/business_profile.dart';
import '../../reports/domain/calculations.dart';
import '../../inventory/presentation/widgets/product_image_view.dart';
import '../../inventory/presentation/widgets/stock_badge.dart';

/// Overview dashboard (PRD §6.2). Today by default; every figure comes
/// from local streams and refreshes after writes.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productRepositoryProvider);
    final sales = ref.watch(saleRepositoryProvider);
    final profileRepo = ref.watch(businessProfileRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Overview'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart_outlined),
            tooltip: 'Reports',
            onPressed: () => context.go('/reports'),
          ),
        ],
      ),
      body: StreamBuilder<BusinessProfile?>(
        stream: profileRepo.watch(),
        builder: (context, profileSnap) {
          return StreamBuilder<List<Product>>(
            stream: products.watchProducts(const ProductListFilter()),
            builder: (context, prodSnap) {
              return StreamBuilder<List<db.Sale>>(
                stream: sales.watchSales(),
                builder: (context, saleSnap) {
                  if (!prodSnap.hasData || !saleSnap.hasData) {
                    return _LoadingGrid(
                      hasProfile: profileSnap.hasData,
                      profile: profileSnap.data,
                    );
                  }
                  final items = prodSnap.data!;
                  final allSales = saleSnap.data!;
                  final today = LocalDateRange.day(DateTime.now());
                  final todaySales = allSales
                      .where(
                        (s) =>
                            s.status == 'COMPLETED' &&
                            today.containsLocal(s.soldAt),
                      )
                      .toList();
                  final summary = summarizeSales([
                    ...todaySales,
                    ...allSales.where(
                      (s) =>
                          s.status == 'VOIDED' && today.containsLocal(s.soldAt),
                    ),
                  ]);
                  final out = items
                      .where((p) => p.status == StockStatus.outOfStock)
                      .toList();
                  final low = items
                      .where((p) => p.status == StockStatus.lowStock)
                      .toList();
                  final valuation = valuateStock(items);
                  final week = LocalDateRange.lastDays(7);
                  final (wFrom, wTo) = week.utcBounds;
                  final weekSales = allSales
                      .where(
                        (s) =>
                            s.status == 'COMPLETED' &&
                            !s.soldAt.isBefore(wFrom) &&
                            s.soldAt.isBefore(wTo),
                      )
                      .toList();
                  final weekSummary = summarizeSales(weekSales);

                  if (items.isEmpty && allSales.isEmpty) {
                    return AppEmpty(
                      icon: Icons.store_outlined,
                      title: 'Welcome to Stockroom',
                      message:
                          'Add your first product, then record your first sale — all offline.',
                      actionLabel: 'Add your first product',
                      onAction: () => context.push('/inventory/new'),
                    );
                  }

                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    children: [
                      StaggerIn(
                        index: 0,
                        child: _GreetingHeader(
                          businessName: profileSnap.data?.businessName,
                        ),
                      ),
                      const SizedBox(height: 14),
                      StaggerIn(
                        index: 1,
                        child: _Metrics(
                          salesToday: summary.netSalesKobo,
                          countToday: summary.transactionCount,
                          valuation: valuation.totalKobo,
                          alertCount: low.length + out.length,
                        ),
                      ),
                      const SizedBox(height: 12),
                      FutureBuilder<ProfitEstimate>(
                        future: ref
                            .read(reportsRepositoryProvider)
                            .profit(today.utcBounds.$1, today.utcBounds.$2),
                        builder: (context, profitSnap) {
                          final gross = profitSnap.data?.grossProfitKobo;
                          final failed =
                              profitSnap.hasError && profitSnap.data == null;
                          return StaggerIn(
                            index: 2,
                            child: _ProfitTile(
                              grossKobo: gross,
                              failed: failed,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      StaggerIn(
                        index: 3,
                        child: SectionHeader(
                          eyebrow: 'Last 7 days',
                          actionLabel: 'Reports',
                          onAction: () => context.go('/reports'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      StaggerIn(
                        index: 3,
                        child: _TrendChart(byDay: weekSummary.byDay),
                      ),
                      const SizedBox(height: 20),
                      StaggerIn(
                        index: 4,
                        child: SectionHeader(
                          eyebrow:
                              'Stock alerts${out.isEmpty && low.isEmpty ? '' : ' · ${out.length + low.length}'}',
                          actionLabel: 'View all',
                          onAction: () => context.push('/inventory?stock=low'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      StaggerIn(
                        index: 4,
                        child: _AlertsList(out: out, low: low),
                      ),
                      const SizedBox(height: 20),
                      StaggerIn(
                        index: 5,
                        child: SectionHeader(
                          eyebrow: 'Recent sales',
                          actionLabel: 'View all',
                          onAction: () => context.go('/sales'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      StaggerIn(index: 5, child: _RecentSales(sales: allSales)),
                      const SizedBox(height: 20),
                      const StaggerIn(index: 6, child: _QuickActions()),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

/// Skeleton stand-in while streams settle, so the greeting and metric
/// grid keep their layout instead of jumping to a spinner.
class _LoadingGrid extends StatelessWidget {
  const _LoadingGrid({required this.hasProfile, required this.profile});
  final bool hasProfile;
  final BusinessProfile? profile;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _GreetingHeader(
          businessName: hasProfile ? profile?.businessName : null,
        ),
        const SizedBox(height: 14),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          mainAxisExtent: 104,
          children: List.generate(4, (_) => const AppSkeleton(height: 104)),
        ),
      ],
    );
  }
}

class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader({required this.businessName});
  final String? businessName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    final greeting = hour < 12
        ? 'Good morning'
        : hour < 17
        ? 'Good afternoon'
        : 'Good evening';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, ${businessName ?? 'Stockroom'}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge,
        ),
        const SizedBox(height: 2),
        Text(
          DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppTokens.taupe,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class _Metrics extends StatelessWidget {
  const _Metrics({
    required this.salesToday,
    required this.countToday,
    required this.valuation,
    required this.alertCount,
  });
  final int salesToday;
  final int countToday;
  final int valuation;
  final int alertCount;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      mainAxisExtent: 104,
      children: [
        MetricTile(
          label: 'Sales today',
          value: formatNaira(salesToday),
          rawKobo: salesToday,
          icon: Icons.payments_outlined,
          onTap: () => context.push('/sales'),
        ),
        MetricTile(
          label: 'Transactions',
          value: '$countToday',
          icon: Icons.receipt_long_outlined,
          onTap: () => context.push('/sales'),
        ),
        MetricTile(
          label: 'Stock value',
          value: formatNaira(valuation),
          rawKobo: valuation,
          icon: Icons.inventory_2_outlined,
          onTap: () => context.go('/reports'),
        ),
        MetricTile(
          label: 'Needs restock',
          value: '$alertCount',
          icon: Icons.warning_amber_outlined,
          alert: alertCount > 0,
          onTap: () => context.push('/inventory?stock=low'),
        ),
      ],
    );
  }
}

class _ProfitTile extends StatelessWidget {
  const _ProfitTile({required this.grossKobo, required this.failed});
  final int? grossKobo;
  final bool failed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        onTap: () => context.go('/reports'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTokens.mossSoft,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.trending_up_outlined,
                  color: AppTokens.moss,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EST. GROSS PROFIT · TODAY',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTokens.taupe,
                        letterSpacing: 0.9,
                      ),
                    ),
                    const SizedBox(height: 2),
                    if (failed || grossKobo == null)
                      Text(
                        failed ? 'Unavailable' : '…',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontFeatures: AppTokens.tabular,
                        ),
                      )
                    else
                      CountUpKobo(
                        kobo: grossKobo!,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_outlined,
                color: AppTokens.taupeDim,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendChart extends StatelessWidget {
  const _TrendChart({required this.byDay});
  final Map<String, int> byDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final days = [
      for (var i = 6; i >= 0; i--)
        DateTime(now.year, now.month, now.day).subtract(Duration(days: i)),
    ];
    String key(DateTime d) =>
        '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    final values = [for (final d in days) (byDay[key(d)] ?? 0).toDouble()];
    final max = values.fold<double>(0, (m, v) => v > m ? v : m);
    final total = values.fold<double>(0, (m, v) => m + v);
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                formatNaira(total.toInt()),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFeatures: AppTokens.tabular,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'sold this week',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTokens.taupe,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 132,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < 7; i++)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 18,
                          child: values[i] <= 0
                              ? null
                              : Text(
                                  _compact(values[i].toInt()),
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppTokens.taupe,
                                    fontFeatures: AppTokens.tabular,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.clip,
                                ),
                        ),
                        const SizedBox(height: 4),
                        // Bars grow in once, quietly, on first appearance.
                        _GrowBar(
                          height: max <= 0 ? 4.0 : 8 + 72 * (values[i] / max),
                          filled: values[i] > 0,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${days[i].day}/${days[i].month}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: AppTokens.taupeDim,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _compact(int kobo) {
    final naira = kobo / 100;
    if (naira >= 1000000) {
      final v = naira / 1000000;
      return '₦${v >= 100 ? v.toStringAsFixed(0) : v.toStringAsFixed(1)}M';
    }
    if (naira >= 1000) {
      final v = naira / 1000;
      return '₦${v >= 100 ? v.toStringAsFixed(0) : v.toStringAsFixed(1)}k';
    }
    return formatNaira(kobo);
  }
}

/// One bar in the 7-day trend. Growth is a single finite tween.
class _GrowBar extends StatelessWidget {
  const _GrowBar({required this.height, required this.filled});
  final double height;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final settled = MediaQuery.of(context).disableAnimations;
    return LayoutBuilder(
      builder: (context, constraints) {
        final full = height;
        Widget bar(double h) => Container(
          height: h,
          margin: const EdgeInsets.symmetric(horizontal: 7),
          decoration: BoxDecoration(
            color: filled ? AppTokens.moss : AppTokens.coalRaised,
            borderRadius: BorderRadius.circular(6),
            border: filled ? null : Border.all(color: AppTokens.line),
          ),
        );
        if (settled) return bar(full);
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: full),
          duration: AppTokens.durSlow,
          curve: AppTokens.easeEmph,
          builder: (context, h, _) => bar(h),
        );
      },
    );
  }
}

class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.out, required this.low});
  final List<Product> out;
  final List<Product> low;

  @override
  Widget build(BuildContext context) {
    final ordered = [...out, ...low].take(5).toList();
    if (ordered.isEmpty) {
      return const AppCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.check_circle_outline, color: AppTokens.green),
          title: Text('Stock levels look healthy'),
          subtitle: Text('Nothing is low or out of stock.'),
        ),
      );
    }
    return AppRowCard(
      children: [
        for (final p in ordered)
          ListTile(
            dense: true,
            leading: ProductImageView(relativePath: p.imagePath, size: 40),
            title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(
              formatQty(p.quantityOnHandMilli, p.unitLabel),
              style: const TextStyle(fontFeatures: AppTokens.tabular),
            ),
            trailing: StockBadge(status: p.status),
            onTap: () => context.push('/inventory/${p.id}'),
          ),
      ],
    );
  }
}

class _RecentSales extends StatelessWidget {
  const _RecentSales({required this.sales});
  final List<db.Sale> sales;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = sales.take(5).toList();
    if (recent.isEmpty) {
      return const AppCard(
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(Icons.receipt_long_outlined, color: AppTokens.taupe),
          title: Text('No sales yet'),
          subtitle: Text('Completed sales appear here.'),
        ),
      );
    }
    return AppRowCard(
      children: [
        for (final s in recent)
          ListTile(
            dense: true,
            title: Row(
              children: [
                Flexible(
                  child: Text(
                    s.saleNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                if (s.status == 'VOIDED') ...[
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
                      ),
                    ),
                  ),
                ],
              ],
            ),
            subtitle: Text(formatDateTimeLocal(s.soldAt)),
            trailing: Text(
              formatNaira(s.totalKobo),
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontFeatures: AppTokens.tabular,
              ),
            ),
            onTap: () => context.push('/sales/${s.id}'),
          ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => context.push('/sales/new'),
            icon: const Icon(Icons.add, size: 19),
            label: const Text('New sale'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/inventory/new'),
            icon: const Icon(Icons.inventory_2_outlined, size: 18),
            label: const Text('Product'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/receive'),
            icon: const Icon(Icons.call_received_outlined, size: 18),
            label: const Text('Receive'),
          ),
        ),
      ],
    );
  }
}
