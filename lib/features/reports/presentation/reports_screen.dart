import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/dates/date_range.dart';
import '../../../core/files/share_file.dart';
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';
import '../../expenses/domain/expense.dart';
import '../../inventory/domain/product.dart';
import '../data/report_csv.dart';
import '../data/report_pdf.dart';
import '../domain/calculations.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});
  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen>
    with SingleTickerProviderStateMixin {
  ReportPreset _preset = ReportPreset.last7Days;
  LocalDateRange _range = presetRange(ReportPreset.last7Days);
  late final TabController _tabs;
  bool _exporting = false;
  pw.Font? _regular;
  pw.Font? _bold;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  String get _rangeLabel {
    String d(DateTime dt) =>
        '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    final endInclusive = _range.endExclusive.subtract(
      const Duration(seconds: 1),
    );
    return '${d(_range.start)} → ${d(endInclusive)}';
  }

  (DateTime, DateTime) get _bounds => _range.utcBounds;

  Future<void> _pickCustom() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      initialDateRange: DateTimeRange(
        start: _range.start,
        end: _range.endExclusive.subtract(const Duration(days: 1)),
      ),
    );
    if (picked != null && mounted) {
      setState(() {
        _preset = ReportPreset.custom;
        _range = LocalDateRange.custom(picked.start, picked.end);
      });
    }
  }

  void _setPreset(ReportPreset p) {
    if (p == ReportPreset.custom) {
      _pickCustom();
      return;
    }
    setState(() {
      _preset = p;
      _range = presetRange(p);
    });
  }

  Future<void> _ensureFonts() async {
    if (_regular != null) return;
    try {
      final reg = await rootBundle.load('assets/fonts/DejaVuSans.ttf');
      final bld = await rootBundle.load('assets/fonts/DejaVuSans-Bold.ttf');
      _regular = pw.Font.ttf(reg);
      _bold = pw.Font.ttf(bld);
    } catch (_) {}
  }

  Future<void> _exportCsvSales() => _guardExport(() async {
    final (from, to) = _bounds;
    final sales = await ref
        .read(reportsRepositoryProvider)
        .allSalesInRange(from, to);
    final csv = salesDetailCsv(sales);
    return (
      utf8.encode(csv),
      'sales-${_rangeLabel.replaceAll(RegExp(r'[^\w\-]+'), '_')}.csv',
      'text/csv',
    );
  });

  Future<void> _exportCsvProducts() => _guardExport(() async {
    final (from, to) = _bounds;
    final rows = await ref
        .read(reportsRepositoryProvider)
        .productSales(from, to);
    final csv = productSalesCsv(rows);
    return (
      utf8.encode(csv),
      'products-${_rangeLabel.replaceAll(RegExp(r'[^\w\-]+'), '_')}.csv',
      'text/csv',
    );
  });

  Future<void> _exportPdf() => _guardExport(() async {
    final (from, to) = _bounds;
    final repo = ref.read(reportsRepositoryProvider);
    final profileRes = await ref.read(businessProfileRepositoryProvider).read();
    final profile = profileRes.fold((_) => null, (v) => v);
    if (profile == null) throw StateError('Set up the business first.');
    final summary = await repo.salesSummary(from, to);
    final products = await repo.productSales(from, to);
    final profit = await repo.profit(from, to);
    final expenses = await ref
        .read(expenseRepositoryProvider)
        .list(fromUtc: from, toUtc: to);
    final slices = expensesByCategory(expenses.fold((_) => const [], (v) => v));
    await _ensureFonts();
    final bytes = await buildSalesReportPdf(
      business: profile,
      periodLabel: _rangeLabel,
      generatedAt: DateTime.now(),
      summary: summary,
      products: products,
      profit: profit,
      expenses: slices,
      regularFont: _regular,
      boldFont: _bold,
    );
    return (
      bytes,
      'report-${_rangeLabel.replaceAll(RegExp(r'[^\w\-]+'), '_')}.pdf',
      'application/pdf',
    );
  });

  Future<void> _guardExport(
    Future<(List<int>, String, String)> Function() build,
  ) async {
    if (_exporting) return;
    setState(() => _exporting = true);
    try {
      final (bytes, name, mime) = await build();
      if (!mounted) return;
      final r = await FileShareService().shareBytes(
        bytes: bytes,
        filename: name,
        mimeType: mime,
      );
      if (!mounted) return;
      r.fold(
        (f) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(f.message))),
        (_) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Exported $name')));
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Export failed. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const presets = [
      (ReportPreset.today, 'Today'),
      (ReportPreset.yesterday, 'Yesterday'),
      (ReportPreset.last7Days, '7 days'),
      (ReportPreset.thisMonth, 'This month'),
      (ReportPreset.lastMonth, 'Last month'),
      (ReportPreset.custom, 'Custom'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        actions: [
          if (_exporting)
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            PopupMenuButton<String>(
              icon: const Icon(Icons.ios_share_outlined),
              tooltip: 'Export',
              onSelected: (v) {
                if (v == 'sales') _exportCsvSales();
                if (v == 'products') _exportCsvProducts();
                if (v == 'pdf') _exportPdf();
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'sales', child: Text('Sales CSV')),
                PopupMenuItem(value: 'products', child: Text('Products CSV')),
                PopupMenuItem(value: 'pdf', child: Text('Report PDF')),
              ],
            ),
        ],
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicatorWeight: 2.5,
          indicatorSize: TabBarIndicatorSize.label,
          labelPadding: const EdgeInsets.symmetric(horizontal: 14),
          tabs: const [
            Tab(text: 'Summary'),
            Tab(text: 'Products'),
            Tab(text: 'Profit'),
            Tab(text: 'Expenses'),
            Tab(text: 'Stock'),
          ],
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(
              children: [
                for (final (value, label) in presets)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(label),
                      selected: _preset == value,
                      showCheckmark: false,
                      onSelected: (_) => _setPreset(value),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: AppTokens.moss,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _rangeLabel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppTokens.taupe,
                      letterSpacing: 0.4,
                      fontFeatures: AppTokens.tabular,
                    ),
                  ),
                ),
                Text(
                  _preset == ReportPreset.custom ? 'CUSTOM' : 'PRESET',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTokens.taupeDim,
                    letterSpacing: 1.0,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTokens.line)),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _SummaryTab(range: _range),
                _ProductsTab(range: _range),
                _ProfitTab(range: _range),
                _ExpensesTab(range: _range),
                const _StockTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryTab extends ConsumerWidget {
  const _SummaryTab({required this.range});
  final LocalDateRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final (from, to) = range.utcBounds;
    return FutureBuilder<SalesSummary>(
      future: ref.read(reportsRepositoryProvider).salesSummary(from, to),
      builder: (context, snap) {
        if (snap.hasError) {
          return const AppError(
            message: 'Could not load the summary for this period.',
          );
        }
        if (!snap.hasData) {
          return const AppLoading(message: 'Loading summary…');
        }
        final s = snap.data!;
        if (s.transactionCount == 0) {
          return const AppEmpty(
            icon: Icons.bar_chart_outlined,
            title: 'No sales in this period',
            message: 'Try a wider date range.',
          );
        }
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _HeroCard(
              eyebrow: 'NET SALES',
              value: formatNaira(s.netSalesKobo),
              caption:
                  '${s.transactionCount} transactions · avg ${formatNaira(s.averageSaleKobo)}'
                  '${s.voidedCount > 0 ? ' · ${s.voidedCount} voided excluded' : ''}',
              icon: Icons.payments_outlined,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _MiniMetric(
                    label: 'TRANSACTIONS',
                    value: '${s.transactionCount}',
                    icon: Icons.receipt_long_outlined,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MiniMetric(
                    label: 'AVERAGE SALE',
                    value: formatNaira(s.averageSaleKobo),
                    icon: Icons.calculate_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SectionHeader(eyebrow: 'Sales by day'),
            const SizedBox(height: 8),
            _DayBars(byDay: s.byDay),
            const SizedBox(height: 8),
            Text(
              'Voided sales are excluded from totals.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTokens.taupeDim,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ProductsTab extends ConsumerWidget {
  const _ProductsTab({required this.range});
  final LocalDateRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (from, to) = range.utcBounds;
    return FutureBuilder<List<ProductSalesRow>>(
      future: ref.read(reportsRepositoryProvider).productSales(from, to),
      builder: (context, snap) {
        if (snap.hasError) {
          return const AppError(message: 'Could not load product sales.');
        }
        if (!snap.hasData) {
          return const AppLoading(message: 'Loading products…');
        }
        final rows = snap.data!;
        if (rows.isEmpty) {
          return const AppEmpty(
            icon: Icons.inventory_2_outlined,
            title: 'Nothing sold in this period',
            message: 'Product sales appear here after checkout.',
          );
        }
        final max = rows.fold<int>(
          0,
          (m, r) => r.netSalesKobo > m ? r.netSalesKobo : m,
        );
        final totalQty = rows.fold<int>(0, (m, r) => m + r.quantityMilli);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _HeroCard(
              eyebrow: 'PRODUCT SALES',
              value: formatNaira(
                rows.fold<int>(0, (m, r) => m + r.netSalesKobo),
              ),
              caption:
                  '${rows.length} products · ${formatQty(totalQty)} units sold',
              icon: Icons.inventory_2_outlined,
            ),
            const SizedBox(height: 10),
            AppRowCard(
              children: [
                for (var i = 0; i < rows.length; i++)
                  _ProductSalesRow(
                    rank: i + 1,
                    name: rows[i].productName,
                    meta:
                        '${formatQty(rows[i].quantityMilli)} sold · COGS ${formatNaira(rows[i].cogsKobo)}',
                    amount: formatNaira(rows[i].netSalesKobo),
                    share: max <= 0 ? 0 : rows[i].netSalesKobo / max,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _ProfitTab extends ConsumerWidget {
  const _ProfitTab({required this.range});
  final LocalDateRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final (from, to) = range.utcBounds;
    return FutureBuilder<ProfitEstimate>(
      future: ref.read(reportsRepositoryProvider).profit(from, to),
      builder: (context, snap) {
        if (snap.hasError) {
          return const AppError(message: 'Could not load the profit estimate.');
        }
        if (!snap.hasData) {
          return const AppLoading(message: 'Loading profit…');
        }
        final p = snap.data!;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            if (!p.costsComplete)
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppTokens.amberSoft,
                  borderRadius: BorderRadius.circular(AppTokens.cardRadius),
                  border: Border.all(
                    color: AppTokens.amber.withValues(alpha: 0.45),
                  ),
                ),
                child: const ListTile(
                  leading: Icon(
                    Icons.warning_amber_outlined,
                    color: AppTokens.amber,
                  ),
                  title: Text('Costs incomplete'),
                  subtitle: Text(
                    'Some lines lack cost data; profit is understated.',
                  ),
                ),
              ),
            _HeroCard(
              eyebrow: 'EST. OPERATING PROFIT',
              value: formatNaira(p.operatingProfitKobo),
              caption:
                  'Net ${formatNaira(p.netSalesKobo)} − COGS ${formatNaira(p.cogsKobo)} − exp ${formatNaira(p.operatingExpensesKobo)}',
              icon: Icons.trending_up_outlined,
            ),
            const SizedBox(height: 10),
            AppCard(
              child: Column(
                children: [
                  ReportRow(
                    label: 'Net sales',
                    value: formatNaira(p.netSalesKobo),
                  ),
                  ReportRow(
                    label: 'Cost of goods sold',
                    value: formatNaira(p.cogsKobo),
                  ),
                  const Divider(height: 20),
                  ReportRow(
                    label: 'Estimated gross profit',
                    value: formatNaira(p.grossProfitKobo),
                    strong: true,
                    valueColor: AppTokens.moss,
                  ),
                  ReportRow(
                    label: 'Operating expenses',
                    value: formatNaira(p.operatingExpensesKobo),
                  ),
                  const Divider(height: 20),
                  ReportRow(
                    label: 'Estimated operating profit',
                    value: formatNaira(p.operatingProfitKobo),
                    strong: true,
                    valueColor: AppTokens.moss,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Stock purchases are not operating expenses; cost is recognised when sold.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppTokens.taupeDim,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ExpensesTab extends ConsumerWidget {
  const _ExpensesTab({required this.range});
  final LocalDateRange range;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (from, to) = range.utcBounds;
    return FutureBuilder(
      future: ref
          .read(expenseRepositoryProvider)
          .list(fromUtc: from, toUtc: to),
      builder: (context, snap) {
        if (snap.hasError) {
          return const AppError(message: 'Could not load expenses.');
        }
        if (!snap.hasData) {
          return const AppLoading(message: 'Loading expenses…');
        }
        final items = snap.data!.fold((_) => const <Expense>[], (v) => v);
        if (items.isEmpty) {
          return const AppEmpty(
            icon: Icons.wallet_outlined,
            title: 'No expenses in this period',
            message: 'Recorded operating expenses appear here.',
          );
        }
        final slices = expensesByCategory(items);
        final total = items.fold<int>(0, (s, e) => s + e.amountKobo);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _HeroCard(
              eyebrow: 'OPERATING EXPENSES',
              value: formatNaira(total),
              caption:
                  '${items.length} entries · ${slices.length} categories',
              icon: Icons.wallet_outlined,
            ),
            const SizedBox(height: 10),
            AppRowCard(
              children: [
                for (final s in slices)
                  _ShareRow(
                    label: s.category,
                    value: formatNaira(s.totalKobo),
                    share: total <= 0 ? 0 : s.totalKobo / total,
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _StockTab extends ConsumerWidget {
  const _StockTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final products = ref.watch(productRepositoryProvider);
    return StreamBuilder(
      stream: products.watchProducts(const ProductListFilter()),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const AppLoading(message: 'Valuing stock…');
        }
        // Include archived in the stream? Valuation excludes them by rule.
        final valuation = valuateStock(snap.data!);
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _HeroCard(
              eyebrow: 'INVENTORY VALUE',
              value: formatNaira(valuation.totalKobo),
              caption:
                  '${valuation.rows.length} products on hand · at avg cost',
              icon: Icons.inventory_2_outlined,
            ),
            const SizedBox(height: 16),
            const SectionHeader(eyebrow: 'Valuation by product'),
            const SizedBox(height: 8),
            if (valuation.rows.isEmpty)
              const AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('No stock on hand'),
                  subtitle: Text('Receive stock to build valuation.'),
                ),
              )
            else
              AppRowCard(
                children: [
                  for (final r in valuation.rows)
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 2,
                      ),
                      title: Text(
                        r.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        '${formatQty(r.quantityMilli, r.unitLabel)} @ ${formatNaira(r.averageCostKobo)}',
                        style: const TextStyle(fontFeatures: AppTokens.tabular),
                      ),
                      trailing: Text(
                        formatNaira(r.valueKobo),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontFeatures: AppTokens.tabular,
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}

/// Shared polished primitives for Reports (matte, no gradients).
class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.eyebrow,
    required this.value,
    required this.caption,
    required this.icon,
  });
  final String eyebrow;
  final String value;
  final String caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
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
            child: Icon(icon, size: 21, color: AppTokens.moss),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTokens.taupe,
                    letterSpacing: 0.9,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFeatures: AppTokens.tabular,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTokens.taupe,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    required this.icon,
  });
  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: AppTokens.moss),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTokens.taupe,
                    letterSpacing: 0.8,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: AppTokens.tabular,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayBars extends StatelessWidget {
  const _DayBars({required this.byDay});
  final Map<String, int> byDay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = byDay.entries.toList();
    final max = entries.fold<int>(0, (m, e) => e.value > m ? e.value : m);
    return AppCard(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        children: [
          for (final e in entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  SizedBox(
                    width: 64,
                    child: Text(
                      _shortDay(e.key),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTokens.taupeDim,
                        fontFeatures: AppTokens.tabular,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: max <= 0 ? 0 : e.value / max,
                        minHeight: 8,
                        backgroundColor: AppTokens.coalRaised,
                        valueColor: const AlwaysStoppedAnimation(
                          AppTokens.moss,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: 86,
                    child: Text(
                      formatNaira(e.value),
                      textAlign: TextAlign.end,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        fontFeatures: AppTokens.tabular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  String _shortDay(String yyyyMmDd) {
    // byDay keys are yyyy-MM-dd; show MM/dd for compactness.
    final parts = yyyyMmDd.split('-');
    if (parts.length == 3) return '${parts[2]}/${parts[1]}';
    return yyyyMmDd;
  }
}

class _ProductSalesRow extends StatelessWidget {
  const _ProductSalesRow({
    required this.rank,
    required this.name,
    required this.meta,
    required this.amount,
    required this.share,
  });
  final int rank;
  final String name;
  final String meta;
  final String amount;
  final double share;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: rank == 1
                  ? AppTokens.mossSoft
                  : AppTokens.coalRaised,
              borderRadius: BorderRadius.circular(9),
              border: Border.all(
                color: rank == 1 ? AppTokens.moss.withValues(alpha: 0.35) : AppTokens.line,
              ),
            ),
            child: Text(
              '$rank',
              style: theme.textTheme.labelMedium?.copyWith(
                color: rank == 1 ? AppTokens.moss : AppTokens.taupe,
                fontWeight: FontWeight.w800,
                fontFeatures: AppTokens.tabular,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: share.clamp(0.0, 1.0),
                    minHeight: 5,
                    backgroundColor: AppTokens.coalRaised,
                    valueColor: const AlwaysStoppedAnimation(AppTokens.moss),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  meta,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTokens.taupe,
                    fontFeatures: AppTokens.tabular,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            amount,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: AppTokens.tabular,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareRow extends StatelessWidget {
  const _ShareRow({
    required this.label,
    required this.value,
    required this.share,
  });
  final String label;
  final String value;
  final double share;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontFeatures: AppTokens.tabular,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: share.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: AppTokens.coalRaised,
              valueColor: const AlwaysStoppedAnimation(AppTokens.moss),
            ),
          ),
        ],
      ),
    );
  }
}
