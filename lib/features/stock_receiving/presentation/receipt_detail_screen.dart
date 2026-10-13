import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';

/// Posted receipt detail. Receipts are immutable — corrections go through
/// adjustments (PRD §6.5), so there is intentionally no edit button.
class ReceiptDetailScreen extends ConsumerWidget {
  const ReceiptDetailScreen({super.key, required this.receiptId});
  final String receiptId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(receiptRepositoryProvider);
    return FutureBuilder(
      future: repo.getReceipt(receiptId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppLoading(message: 'Loading…'),
          );
        }
        final receipt = snap.data!.fold((_) => null, (v) => v);
        if (receipt == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppError(message: 'Receipt not found.'),
          );
        }
        return Scaffold(
          appBar: AppBar(title: Text(receipt.receiptNumber)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SectionHeader(eyebrow: 'Details'),
              const SizedBox(height: 8),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ReportRow(
                      label: 'Received',
                      value: formatDateTimeLocal(receipt.receivedAt),
                    ),
                    if (receipt.supplierNameSnapshot != null)
                      ReportRow(
                        label: 'Supplier',
                        value: receipt.supplierNameSnapshot!,
                      ),
                    if (receipt.supplierReference != null)
                      ReportRow(
                        label: 'Invoice no.',
                        value: receipt.supplierReference!,
                      ),
                    if (receipt.notes != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Text(
                          receipt.notes!,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTokens.taupe),
                        ),
                      ),
                    const Divider(height: 20),
                    Row(
                      children: [
                        Text(
                          'Total purchase cost',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const Spacer(),
                        Text(
                          formatNaira(receipt.totalCostKobo),
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w800,
                                fontFeatures: AppTokens.tabular,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SectionHeader(eyebrow: 'Products'),
              const SizedBox(height: 8),
              StreamBuilder<List<db.StockReceiptLine>>(
                stream: repo.watchLines(receiptId),
                builder: (context, lines) {
                  final rows = lines.data ?? const <db.StockReceiptLine>[];
                  if (rows.isEmpty) {
                    return const AppCard(child: Text('No lines.'));
                  }
                  final theme = Theme.of(context);
                  return AppRowCard(
                    children: [
                      for (final l in rows)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l.productNameSnapshot,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '+${formatQty(l.quantityMilli, l.unitLabelSnapshot)} @ ${formatNaira(l.unitCostKobo)}',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: AppTokens.taupe,
                                            fontFeatures: AppTokens.tabular,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                formatNaira(l.lineCostKobo),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFeatures: AppTokens.tabular,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
