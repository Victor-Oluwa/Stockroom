import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';
import '../domain/supplier.dart';

class SupplierDetailScreen extends ConsumerWidget {
  const SupplierDetailScreen({super.key, required this.supplierId});
  final String supplierId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(supplierRepositoryProvider);
    return StreamBuilder<Supplier?>(
      stream: repo.watch(supplierId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppLoading(message: 'Loading…'),
          );
        }
        final s = snap.data;
        if (s == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppError(message: 'Supplier not found.'),
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Supplier'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Edit',
                onPressed: () => context.push('/suppliers/${s.id}/edit'),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: s.isArchived
                        ? AppTokens.coalRaised
                        : AppTokens.mossSoft,
                    foregroundColor: s.isArchived
                        ? AppTokens.taupe
                        : AppTokens.moss,
                    child: Text(
                      s.name.isEmpty ? '?' : s.name.trim()[0].toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.name,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (s.isArchived)
                          Text(
                            'Archived',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTokens.taupe),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (s.contactName != null ||
                  s.phone != null ||
                  s.email != null ||
                  s.address != null ||
                  s.notes != null) ...[
                const SizedBox(height: 16),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (s.contactName != null)
                        ReportRow(label: 'Contact', value: s.contactName!),
                      if (s.phone != null)
                        ReportRow(label: 'Phone', value: s.phone!),
                      if (s.email != null)
                        ReportRow(label: 'Email', value: s.email!),
                      if (s.address != null)
                        ReportRow(label: 'Address', value: s.address!),
                      if (s.notes != null) ...[
                        const Divider(height: 18),
                        Text(
                          s.notes!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTokens.taupe),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              FutureBuilder(
                future: repo.totalSpendKobo(s.id),
                builder: (context, spend) {
                  final total = spend.data?.fold((_) => 0, (v) => v) ?? 0;
                  return AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'RECORDED PURCHASE SPEND',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: AppTokens.taupe,
                                      letterSpacing: 1.1,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                formatNaira(total),
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      fontFeatures: AppTokens.tabular,
                                    ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'All-time, from stock receipts',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(color: AppTokens.taupe),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.payments_outlined,
                          color: AppTokens.moss,
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _ReceiptsSection(supplierId: s.id),
              const SizedBox(height: 16),
              if (s.isArchived)
                FilledButton(
                  onPressed: () async {
                    await ref.read(supplierRepositoryProvider).unarchive(s.id);
                  },
                  child: const Text('Restore supplier'),
                )
              else
                OutlinedButton.icon(
                  onPressed: () => _confirmArchive(context, ref, s.id, s.name),
                  icon: const Icon(Icons.archive_outlined),
                  label: const Text('Archive supplier'),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _confirmArchive(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Archive supplier?'),
        content: Text(
          '“$name” stays linked to past receipts. You can restore it later.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Archive'),
          ),
        ],
      ),
    );
    if (ok == true) {
      final r = await ref.read(supplierRepositoryProvider).archive(id);
      if (context.mounted) {
        r.fold(
          (f) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.message))),
          (_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Supplier archived.')));
            context.pop();
          },
        );
      }
    }
  }
}

class _ReceiptsSection extends ConsumerWidget {
  const _ReceiptsSection({required this.supplierId});
  final String supplierId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(supplierRepositoryProvider);
    final theme = Theme.of(context);
    return StreamBuilder<List<db.StockReceipt>>(
      stream: repo.watchReceiptsFor(supplierId),
      builder: (context, snap) {
        final items = snap.data ?? const <db.StockReceipt>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(eyebrow: 'Receipts'),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const AppCard(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.receipt_outlined, color: AppTokens.taupe),
                  title: Text('No receipts from this supplier yet'),
                ),
              )
            else
              AppRowCard(
                children: [
                  for (final r in items)
                    ListTile(
                      dense: true,
                      title: Text(
                        r.receiptNumber,
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: Text(
                        formatDateTimeLocal(r.receivedAt),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppTokens.taupe,
                        ),
                      ),
                      trailing: Text(
                        formatNaira(r.totalCostKobo),
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFeatures: AppTokens.tabular,
                        ),
                      ),
                      onTap: () => context.push('/receipts/${r.id}'),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }
}
