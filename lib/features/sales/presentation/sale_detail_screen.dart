import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/database/app_database.dart' as db;
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';
import '../domain/sale.dart';

/// Sale detail from immutable snapshots (PRD §6.7). Product edits after
/// the sale never rewrite this screen.
class SaleDetailScreen extends ConsumerStatefulWidget {
  const SaleDetailScreen({super.key, required this.saleId});
  final String saleId;

  @override
  ConsumerState<SaleDetailScreen> createState() => _SaleDetailScreenState();
}

class _SaleDetailScreenState extends ConsumerState<SaleDetailScreen> {
  bool _voiding = false;

  Future<void> _void(db.Sale sale) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (context) => const _VoidDialog(),
    );
    if (reason == null || reason.trim().isEmpty || !mounted) return;
    setState(() => _voiding = true);
    final repo = ref.read(saleRepositoryProvider);
    final r = await repo.voidSale(saleId: sale.id, reason: reason.trim());
    if (!mounted) return;
    setState(() => _voiding = false);
    r.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (_) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sale ${sale.saleNumber} voided.')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(saleRepositoryProvider);
    return StreamBuilder<db.Sale?>(
      stream: repo.watchSale(widget.saleId),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppLoading(message: 'Loading sale…'),
          );
        }
        final sale = snap.data;
        if (sale == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const AppError(message: 'Sale not found.'),
          );
        }
        final voided = sale.status == 'VOIDED';
        return Scaffold(
          appBar: AppBar(title: Text(sale.saleNumber)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              if (voided)
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: AppTokens.redSoft,
                    borderRadius: BorderRadius.circular(
                      AppTokens.controlRadius,
                    ),
                    border: Border.all(
                      color: AppTokens.red.withValues(alpha: 0.45),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.cancel_outlined,
                        color: AppTokens.red,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Voided${sale.voidReason != null ? ': ${sale.voidReason}' : ''}',
                        ),
                      ),
                    ],
                  ),
                ),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    ReportRow(
                      label: 'Date',
                      value: formatDateTimeLocal(sale.soldAt),
                    ),
                    ReportRow(label: 'Payment', value: sale.paymentMethod),
                    if (sale.customerName != null)
                      ReportRow(label: 'Customer', value: sale.customerName!),
                    if (sale.note != null)
                      ReportRow(label: 'Note', value: sale.note!),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              StreamBuilder<List<SaleLineView>>(
                stream: repo.watchLines(sale.id),
                builder: (context, lines) {
                  final rows = lines.data ?? const <SaleLineView>[];
                  return AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Column(
                      children: [
                        for (final l in rows)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l.productName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${formatQty(l.quantityMilli, l.unitLabel)} × ${formatNaira(l.unitPriceKobo)}'
                                        '${l.discountKobo > 0 ? ' − ${formatNaira(l.discountKobo)}' : ''}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppTokens.taupe,
                                              fontFeatures: AppTokens.tabular,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  formatNaira(l.netLineTotalKobo),
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontFeatures: AppTokens.tabular,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        const Divider(height: 20),
                        ReportRow(
                          label: 'Subtotal',
                          value: formatNaira(sale.subtotalKobo),
                        ),
                        ReportRow(
                          label: 'Discounts',
                          value: '−${formatNaira(sale.discountTotalKobo)}',
                        ),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Text(
                              'TOTAL',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppTokens.taupe,
                                    letterSpacing: 1.1,
                                  ),
                            ),
                            const Spacer(),
                            Text(
                              formatNaira(sale.totalKobo),
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontFeatures: AppTokens.tabular,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => context.push('/sales/${sale.id}/receipt'),
                icon: const Icon(Icons.receipt_outlined),
                label: const Text('Receipt'),
              ),
              const SizedBox(height: 8),
              if (!voided)
                OutlinedButton.icon(
                  onPressed: _voiding ? null : () => _void(sale),
                  icon: const Icon(Icons.cancel_outlined),
                  label: Text(_voiding ? 'Voiding…' : 'Void this sale'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    side: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: 0.5),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _VoidDialog extends StatefulWidget {
  const _VoidDialog();
  @override
  State<_VoidDialog> createState() => _VoidDialogState();
}

class _VoidDialogState extends State<_VoidDialog> {
  final _reason = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Void this sale?'),
      content: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'The sale stays in history as voided and stock is restored once.',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _reason,
              decoration: const InputDecoration(labelText: 'Reason *'),
              autofocus: true,
              validator: (v) => (v == null || v.trim().isEmpty)
                  ? 'A reason is required'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_form.currentState!.validate()) {
              Navigator.pop(context, _reason.text.trim());
            }
          },
          child: const Text('Void sale'),
        ),
      ],
    );
  }
}
