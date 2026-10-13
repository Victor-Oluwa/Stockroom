import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';

class ReceiptHistoryScreen extends ConsumerStatefulWidget {
  const ReceiptHistoryScreen({super.key});
  @override
  ConsumerState<ReceiptHistoryScreen> createState() =>
      _ReceiptHistoryScreenState();
}

class _ReceiptHistoryScreenState extends ConsumerState<ReceiptHistoryScreen> {
  final _search = TextEditingController();
  List<db.StockReceipt> _items = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _run('');
  }

  Future<void> _run(String q) async {
    if (q.isEmpty) {
      // Live stream covers the unfiltered list; just clear search results.
      if (mounted) setState(() => _items = const []);
      return;
    }
    setState(() => _loading = true);
    final repo = ref.read(receiptRepositoryProvider);
    final r = await repo.searchReceipts(q);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _items = r.fold((_) => const <db.StockReceipt>[], (v) => v);
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(receiptRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Stock receipts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SearchField(
              controller: _search,
              hint: 'Search number, invoice, supplier',
              onChanged: _run,
              onClear: () {
                _search.clear();
                _run('');
              },
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _search.text.isEmpty
                ? StreamBuilder<List<db.StockReceipt>>(
                    stream: repo.watchReceipts(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const AppLoading(message: 'Loading receipts…');
                      }
                      return _List(items: snap.data!);
                    },
                  )
                : _loading
                ? const AppLoading(message: 'Searching…')
                : _List(items: _items),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/receive'),
        icon: const Icon(Icons.add),
        label: const Text('Receive stock'),
      ),
    );
  }
}

class _List extends StatelessWidget {
  const _List({required this.items});
  final List<db.StockReceipt> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const AppEmpty(
        icon: Icons.receipt_outlined,
        title: 'No receipts yet',
        message: 'Received stock will appear here with costs and supplier.',
      );
    }
    final theme = Theme.of(context);
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final r = items[i];
        return AppCard(
          onTap: () => context.push('/receipts/${r.id}'),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppTokens.mossSoft,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.call_received_rounded,
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
                      r.receiptNumber,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${formatDateTimeLocal(r.receivedAt)}'
                      '${r.supplierNameSnapshot != null ? ' · ${r.supplierNameSnapshot}' : ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppTokens.taupe,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                formatNaira(r.totalCostKobo),
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontFeatures: AppTokens.tabular,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppTokens.taupe,
              ),
            ],
          ),
        );
      },
    );
  }
}
