import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_ui.dart';
import '../../inventory/domain/product.dart';
import '../domain/adjustment.dart';
import 'adjust_cubit.dart';

/// Manual stock adjustment (PRD §6.6): direction → qty → reason → cost → review.
class AdjustStockScreen extends ConsumerStatefulWidget {
  const AdjustStockScreen({super.key, required this.productId});
  final String productId;

  @override
  ConsumerState<AdjustStockScreen> createState() => _AdjustStockScreenState();
}

class _AdjustStockScreenState extends ConsumerState<AdjustStockScreen> {
  final _form = GlobalKey<FormState>();
  final _qty = TextEditingController();
  final _cost = TextEditingController();
  final _note = TextEditingController();
  AdjustmentDirection _direction = AdjustmentDirection.increase;
  String _reason = adjustmentReasons.first;
  Product? _product;
  bool _costTouched = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(productRepositoryProvider);
    final r = await repo.getProduct(widget.productId);
    r.fold((_) => null, (p) {
      if (p != null && mounted) {
        setState(() {
          _product = p;
          if (!_costTouched) {
            _cost.text = _koboToInput(p.averageCostKobo);
          }
        });
      }
    });
  }

  String _koboToInput(int kobo) =>
      '${kobo ~/ 100}${kobo % 100 == 0 ? '' : '.${(kobo % 100).toString().padLeft(2, '0')}'}';

  @override
  void dispose() {
    _qty.dispose();
    _cost.dispose();
    _note.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _product;
    if (p == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Adjust stock')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Adjust stock')),
      body: BlocConsumer<AdjustStockCubit, AdjustState>(
        listener: (context, state) {
          if (state is AdjustError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
          if (state is AdjustSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Saved. New balance ${formatQty(state.result.newQuantityMilli, p.unitLabel)}',
                ),
              ),
            );
            final t = state.result.transition;
            if (t != null) {
              ref.read(stockAlertServiceProvider).notifyTransitions([t]);
            }
            context.pop(true);
          }
        },
        builder: (context, state) {
          final submitting = state is AdjustSubmitting;
          final qty = _tryQty(_qty.text);
          final after = qty == null
              ? null
              : (_direction == AdjustmentDirection.increase
                    ? p.quantityOnHandMilli + qty
                    : p.quantityOnHandMilli - qty);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'On hand ${formatQty(p.quantityOnHandMilli, p.unitLabel)} · avg ${formatNaira(p.averageCostKobo)}',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppTokens.taupe,
                                      fontFeatures: AppTokens.tabular,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SectionHeader(eyebrow: 'Direction'),
                  const SizedBox(height: 8),
                  SegmentedButton<AdjustmentDirection>(
                    segments: const [
                      ButtonSegment(
                        value: AdjustmentDirection.increase,
                        icon: Icon(Icons.add_circle_outline),
                        label: Text('Increase'),
                      ),
                      ButtonSegment(
                        value: AdjustmentDirection.decrease,
                        icon: Icon(Icons.remove_circle_outline),
                        label: Text('Decrease'),
                      ),
                    ],
                    selected: {_direction},
                    onSelectionChanged: submitting
                        ? null
                        : (s) => setState(() => _direction = s.first),
                  ),
                  const SizedBox(height: 18),
                  SectionHeader(eyebrow: 'Details'),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _qty,
                          decoration: InputDecoration(
                            labelText: 'Quantity (${p.unitLabel}) *',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (v) {
                            try {
                              final q = parseQuantityToMilli(v ?? '');
                              if (q <= 0) return 'Quantity must be > 0';
                              if (_direction == AdjustmentDirection.decrease &&
                                  q > p.quantityOnHandMilli) {
                                return 'Cannot exceed on-hand stock';
                              }
                            } catch (e) {
                              return e is FormatException
                                  ? e.message
                                  : 'Invalid';
                            }
                            return null;
                          },
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: _reason,
                          decoration: const InputDecoration(
                            labelText: 'Reason *',
                          ),
                          items: [
                            for (final r in adjustmentReasons)
                              DropdownMenuItem(value: r, child: Text(r)),
                          ],
                          onChanged: submitting
                              ? null
                              : (v) => setState(() => _reason = v ?? _reason),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _note,
                          decoration: InputDecoration(
                            labelText: _reason == 'Other'
                                ? 'Note *'
                                : 'Note (optional)',
                          ),
                          maxLines: 2,
                          validator: (v) {
                            if (_reason == 'Other' &&
                                (v == null || v.trim().isEmpty)) {
                              return 'Add a note explaining this adjustment';
                            }
                            return null;
                          },
                        ),
                        if (_direction == AdjustmentDirection.increase) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _cost,
                            decoration: const InputDecoration(
                              labelText: 'Unit cost ₦ *',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (v) {
                              try {
                                parseNairaToKobo(v ?? '');
                              } catch (e) {
                                return e is FormatException
                                    ? e.message
                                    : 'Invalid';
                              }
                              return null;
                            },
                            onChanged: (_) =>
                                setState(() => _costTouched = true),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  SectionHeader(eyebrow: 'Review'),
                  const SizedBox(height: 8),
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        _BalanceChip(
                          label: 'Now',
                          value: formatQty(p.quantityOnHandMilli, p.unitLabel),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20,
                            color: AppTokens.taupe,
                          ),
                        ),
                        _BalanceChip(
                          label: 'After',
                          value: after == null
                              ? '—'
                              : formatQty(after, p.unitLabel),
                          highlight: true,
                          negative: (after ?? 0) < 0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: submitting ? null : _submit,
                    child: submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Confirm adjustment'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  int? _tryQty(String v) {
    try {
      return parseQuantityToMilli(v);
    } catch (_) {
      return null;
    }
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final qty = parseQuantityToMilli(_qty.text);
    await context.read<AdjustStockCubit>().submit(
      productId: widget.productId,
      direction: _direction,
      quantityMilli: qty,
      unitCostKobo: _direction == AdjustmentDirection.increase
          ? parseNairaToKobo(_cost.text)
          : null,
      reason: _reason,
      note: _note.text,
    );
  }
}

/// A compact before/after quantity chip for the review row.
class _BalanceChip extends StatelessWidget {
  const _BalanceChip({
    required this.label,
    required this.value,
    this.highlight = false,
    this.negative = false,
  });
  final String label;
  final String value;
  final bool highlight;
  final bool negative;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: highlight ? AppTokens.mossSoft : AppTokens.coalRaised,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: negative ? AppTokens.red : AppTokens.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTokens.taupe,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                fontFeatures: AppTokens.tabular,
                color: negative ? AppTokens.red : AppTokens.bone,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
