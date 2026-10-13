import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';
import '../domain/expense.dart';

class ExpenseListScreen extends ConsumerStatefulWidget {
  const ExpenseListScreen({super.key});
  @override
  ConsumerState<ExpenseListScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends ConsumerState<ExpenseListScreen> {
  final _search = TextEditingController();
  String? _category;
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(expenseRepositoryProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Expenses')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SearchField(
              controller: _search,
              hint: 'Search category or note',
              onChanged: (v) => setState(() => _query = v),
              onClear: () {
                _search.clear();
                setState(() => _query = '');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Category'.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppTokens.taupe,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 12),
                DropdownButton<String?>(
                  value: _category,
                  hint: const Text('All'),
                  underline: const SizedBox(),
                  items: [
                    const DropdownMenuItem(
                      value: null,
                      child: Text('All categories'),
                    ),
                    for (final c in expenseCategories)
                      DropdownMenuItem(value: c, child: Text(c)),
                  ],
                  onChanged: (v) => setState(() => _category = v),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Expense>>(
              stream: repo.watch(category: _category, query: _query),
              builder: (context, snap) {
                if (!snap.hasData) {
                  return const AppLoading(message: 'Loading expenses…');
                }
                final items = snap.data!;
                if (items.isEmpty) {
                  return AppEmpty(
                    icon: Icons.wallet_outlined,
                    title: 'No expenses yet',
                    message:
                        'Record rent, transport and other running costs here. Stock purchases are not expenses.',
                    actionLabel: 'Record expense',
                    onAction: () => context.push('/expenses/new'),
                  );
                }
                final total = items.fold<int>(0, (s, e) => s + e.amountKobo);
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: items.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    if (i == 0) {
                      return AppCard(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Shown total',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formatNaira(total),
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontFeatures: AppTokens.tabular,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    final e = items[i - 1];
                    return Dismissible(
                      key: ValueKey(e.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        decoration: BoxDecoration(
                          color: AppTokens.redSoft,
                          borderRadius: BorderRadius.circular(
                            AppTokens.cardRadius,
                          ),
                        ),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete_outline,
                          color: AppTokens.red,
                        ),
                      ),
                      confirmDismiss: (_) => _confirmDelete(context, ref),
                      onDismissed: (_) async {
                        await ref.read(expenseRepositoryProvider).remove(e.id);
                      },
                      child: AppCard(
                        onTap: () => context.push('/expenses/${e.id}/edit'),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTokens.coalRaised,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.receipt_long_outlined,
                                size: 18,
                                color: AppTokens.taupe,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.category,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${formatDateLocal(e.expenseDate)} · ${e.paymentMethod}'
                                    '${e.note != null ? ' · ${e.note}' : ''}',
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
                              formatNaira(e.amountKobo),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontFeatures: AppTokens.tabular,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/expenses/new'),
        icon: const Icon(Icons.add),
        label: const Text('Record expense'),
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, WidgetRef ref) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Delete expense?'),
            content: const Text(
              'This removes it from profit reports. Stock records are unaffected.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }
}
