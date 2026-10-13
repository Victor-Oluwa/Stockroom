import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';
import 'supplier_list_cubit.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});
  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Suppliers')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SearchField(
              controller: _search,
              hint: 'Search suppliers',
              onChanged: (v) => context.read<SupplierListCubit>().setQuery(v),
              onClear: () {
                _search.clear();
                context.read<SupplierListCubit>().setQuery('');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: BlocBuilder<SupplierListCubit, SupplierListState>(
              builder: (context, state) => SwitchListTile(
                value: state.showArchived,
                onChanged: (v) =>
                    context.read<SupplierListCubit>().toggleArchived(v),
                title: const Text('Show archived'),
                dense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<SupplierListCubit, SupplierListState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const AppLoading(message: 'Loading suppliers…');
                }
                if (state.items.isEmpty) {
                  return AppEmpty(
                    icon: Icons.people_outline,
                    title: state.query.isEmpty
                        ? 'No suppliers yet'
                        : 'No matches',
                    message: state.query.isEmpty
                        ? 'Add suppliers to link them to stock receipts.'
                        : 'Try a different search.',
                    actionLabel: state.query.isEmpty ? 'Add supplier' : null,
                    onAction: state.query.isEmpty
                        ? () => context.push('/suppliers/new')
                        : null,
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, i) {
                    final s = state.items[i];
                    return AppCard(
                      onTap: () => context.push('/suppliers/${s.id}'),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: s.isArchived
                                ? AppTokens.coalRaised
                                : AppTokens.mossSoft,
                            foregroundColor: s.isArchived
                                ? AppTokens.taupe
                                : AppTokens.moss,
                            child: Text(
                              s.name.isEmpty
                                  ? '?'
                                  : s.name.trim()[0].toUpperCase(),
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    decoration: s.isArchived
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                                if (s.phone != null) ...[
                                  const SizedBox(height: 2),
                                  Text(
                                    s.phone!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: AppTokens.taupe,
                                      fontFeatures: AppTokens.tabular,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
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
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/suppliers/new'),
        icon: const Icon(Icons.add),
        label: const Text('Add supplier'),
      ),
    );
  }
}
