import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/formatting/format.dart';
import '../../../core/money/calculations.dart';
import '../../../core/widgets/app_ui.dart';
import '../../inventory/domain/product.dart';
import '../../inventory/presentation/widgets/product_image_view.dart';
import '../../suppliers/domain/supplier.dart';
import '../domain/receipt.dart';
import 'receive_cubit.dart';

/// Receive-stock flow (PRD §6.5): supplier → lines → review → confirm.
class ReceiveStockScreen extends ConsumerStatefulWidget {
  const ReceiveStockScreen({super.key, this.prefillProductId});
  final String? prefillProductId;

  @override
  ConsumerState<ReceiveStockScreen> createState() => _ReceiveStockScreenState();
}

class _ReceiveStockScreenState extends ConsumerState<ReceiveStockScreen> {
  final _form = GlobalKey<FormState>();
  final _ref = TextEditingController();
  final _notes = TextEditingController();
  String? _supplierId;
  final List<_LineState> _lines = [];
  bool _zeroConfirmed = false;

  @override
  void initState() {
    super.initState();
    if (widget.prefillProductId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _addPrefill());
    }
  }

  Future<void> _addPrefill() async {
    final repo = ref.read(productRepositoryProvider);
    final r = await repo.getProduct(widget.prefillProductId!);
    r.fold((_) => null, (p) {
      if (p != null && mounted) setState(() => _lines.add(_LineState(p)));
    });
  }

  @override
  void dispose() {
    _ref.dispose();
    _notes.dispose();
    for (final l in _lines) {
      l.qty.dispose();
      l.cost.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receive stock')),
      body: BlocConsumer<ReceiveStockCubit, ReceiveState>(
        listener: (context, state) {
          if (state is ReceiveError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ReceiveSuccess) return _Success(result: state.result);
          final submitting = state is ReceiveSubmitting;
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  child: Form(
                    key: _form,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SupplierField(
                          value: _supplierId,
                          onChanged: submitting
                              ? null
                              : (v) => setState(() => _supplierId = v),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Text(
                              'Products',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            TextButton.icon(
                              onPressed: submitting ? null : _pickProduct,
                              icon: const Icon(Icons.add),
                              label: const Text('Add'),
                            ),
                          ],
                        ),
                        if (_lines.isEmpty)
                          const AppCard(
                            child: ListTile(
                              leading: Icon(Icons.inventory_2_outlined),
                              title: Text('No products yet'),
                              subtitle: Text(
                                'Add at least one product to receive.',
                              ),
                            ),
                          ),
                        for (var i = 0; i < _lines.length; i++)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _LineCard(
                              line: _lines[i],
                              enabled: !submitting,
                              onRemove: () =>
                                  setState(() => _lines.removeAt(i)),
                              onChanged: () => setState(() {}),
                            ),
                          ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _ref,
                          decoration: const InputDecoration(
                            labelText: 'Supplier invoice no. (optional)',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notes,
                          decoration: const InputDecoration(
                            labelText: 'Notes (optional)',
                          ),
                          maxLines: 2,
                        ),
                        if (_hasZeroCost())
                          CheckboxListTile(
                            value: _zeroConfirmed,
                            onChanged: submitting
                                ? null
                                : (v) => setState(
                                    () => _zeroConfirmed = v ?? false,
                                  ),
                            title: const Text('Zero-cost items confirmed'),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Sticky review bar: the running total and the one action
              // that commits stay in view, like checkout.
              SafeArea(
                top: false,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppTokens.coal,
                    border: Border(top: BorderSide(color: AppTokens.line)),
                  ),
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'TOTAL PURCHASE COST',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: AppTokens.taupe,
                                    letterSpacing: 1.1,
                                  ),
                            ),
                            Text(
                              formatNaira(_previewTotal()),
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    fontFeatures: AppTokens.tabular,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: submitting ? null : _submit,
                          child: submitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Confirm receipt'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  int _previewTotal() {
    var total = 0;
    for (final l in _lines) {
      try {
        final q = parseQuantityToMilli(l.qty.text);
        final c = parseNairaToKobo(l.cost.text);
        total += roundHalfUpDiv(q * c, 1000);
      } catch (_) {}
    }
    return total;
  }

  bool _hasZeroCost() {
    for (final l in _lines) {
      try {
        if (parseNairaToKobo(l.cost.text) == 0) return true;
      } catch (_) {}
    }
    return false;
  }

  Future<void> _pickProduct() async {
    final picked = await showDialog<Product>(
      context: context,
      builder: (context) => const _ProductPickerDialog(),
    );
    if (picked == null || !mounted) return;
    if (_lines.any((l) => l.product.id == picked.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('“${picked.name}” is already added.')),
      );
      return;
    }
    setState(() => _lines.add(_LineState(picked)));
  }

  Future<void> _submit() async {
    if (_lines.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one product.')),
      );
      return;
    }
    if (!_form.currentState!.validate()) return;
    final inputs = <ReceiptLineInput>[];
    try {
      for (final l in _lines) {
        inputs.add(
          ReceiptLineInput(
            productId: l.product.id,
            quantityMilli: parseQuantityToMilli(l.qty.text),
            unitCostKobo: parseNairaToKobo(l.cost.text),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e is FormatException ? e.message : 'Invalid line.'),
        ),
      );
      return;
    }
    await context.read<ReceiveStockCubit>().submit(
      supplierId: _supplierId,
      supplierReference: _ref.text,
      notes: _notes.text,
      lines: inputs,
      zeroCostConfirmed: _zeroConfirmed,
    );
  }
}

class _LineState {
  _LineState(this.product);
  final Product product;
  final qty = TextEditingController();
  final cost = TextEditingController();
}

class _LineCard extends StatelessWidget {
  const _LineCard({
    required this.line,
    required this.enabled,
    required this.onRemove,
    required this.onChanged,
  });
  final _LineState line;
  final bool enabled;
  final VoidCallback onRemove;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ProductImageView(relativePath: line.product.imagePath, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      line.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'On hand ${formatQty(line.product.quantityOnHandMilli, line.product.unitLabel)} · avg ${formatNaira(line.product.averageCostKobo)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTokens.taupe,
                        fontFeatures: AppTokens.tabular,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline),
                tooltip: 'Remove',
                onPressed: enabled ? onRemove : null,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: line.qty,
                  enabled: enabled,
                  decoration: const InputDecoration(labelText: 'Qty *'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) {
                    try {
                      final q = parseQuantityToMilli(v ?? '');
                      if (q <= 0) return 'Qty must be > 0';
                    } catch (e) {
                      return e is FormatException ? e.message : 'Invalid';
                    }
                    return null;
                  },
                  onChanged: (_) => onChanged(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: line.cost,
                  enabled: enabled,
                  decoration: const InputDecoration(labelText: 'Unit cost ₦ *'),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  validator: (v) {
                    try {
                      final c = parseNairaToKobo(v ?? '');
                      if (c < 0) return 'Cost cannot be negative';
                    } catch (e) {
                      return e is FormatException ? e.message : 'Invalid';
                    }
                    return null;
                  },
                  onChanged: (_) => onChanged(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SupplierField extends ConsumerWidget {
  const _SupplierField({this.value, this.onChanged});
  final String? value;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliers = ref.watch(activeSuppliersProvider);
    return suppliers.when(
      loading: () => const TextField(
        enabled: false,
        decoration: InputDecoration(labelText: 'Supplier (optional)'),
      ),
      error: (_, _) => const TextField(
        enabled: false,
        decoration: InputDecoration(labelText: 'Supplier (optional)'),
      ),
      data: (items) => Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<String?>(
              initialValue: value,
              decoration: const InputDecoration(
                labelText: 'Supplier (optional)',
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('No supplier')),
                for (final Supplier s in items)
                  DropdownMenuItem(value: s.id, child: Text(s.name)),
              ],
              onChanged: onChanged,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.add_business_outlined),
            tooltip: 'Add supplier',
            onPressed: () => context.push('/suppliers/new'),
          ),
        ],
      ),
    );
  }
}

class _ProductPickerDialog extends ConsumerStatefulWidget {
  const _ProductPickerDialog();
  @override
  ConsumerState<_ProductPickerDialog> createState() =>
      _ProductPickerDialogState();
}

class _ProductPickerDialogState extends ConsumerState<_ProductPickerDialog> {
  final _search = TextEditingController();
  List<Product> _results = const [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _run('');
  }

  Future<void> _run(String q) async {
    setState(() => _loading = true);
    final repo = ref.read(productRepositoryProvider);
    final r = await repo.listProducts(
      ProductListFilter(query: q, showArchived: false),
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
      _results = r.fold((_) => const <Product>[], (v) => v);
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add product'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Search name, SKU, barcode',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _run,
            ),
            const SizedBox(height: 8),
            Flexible(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _results.isEmpty
                  ? const Text('No matching products.')
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: _results.length,
                      itemBuilder: (context, i) {
                        final p = _results[i];
                        return ListTile(
                          title: Text(p.name),
                          subtitle: Text(
                            '${formatQty(p.quantityOnHandMilli, p.unitLabel)} on hand',
                          ),
                          onTap: () => Navigator.pop(context, p),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class _Success extends StatelessWidget {
  const _Success({required this.result});
  final ReceiptResult result;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          Center(
            child: _ScaleIn(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTokens.greenSoft,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(
                    color: AppTokens.green.withValues(alpha: 0.5),
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 40,
                  color: AppTokens.green,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Receipt ${result.receiptNumber} saved',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            formatNaira(result.totalCostKobo),
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: AppTokens.tabular,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Column(
              children: [
                for (final l in result.lines)
                  ListTile(
                    title: Text(l.productName),
                    subtitle: Text(
                      '+${formatQty(l.quantityMilli, l.unitLabel)} → ${formatQty(l.newQuantityMilli, l.unitLabel)}',
                      style: const TextStyle(fontFeatures: AppTokens.tabular),
                    ),
                    trailing: Text(
                      formatNaira(l.lineCostKobo),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontFeatures: AppTokens.tabular,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => context.go('/receipts/${result.receiptId}'),
            child: const Text('View receipt'),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => context.go('/inventory'),
            child: const Text('Back to inventory'),
          ),
        ],
      ),
    );
  }
}

/// One-shot scale + fade for the success mark.
class _ScaleIn extends StatelessWidget {
  const _ScaleIn({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) return child;
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.6, end: 1.0),
      duration: AppTokens.durSlow,
      curve: Curves.elasticOut,
      builder: (context, v, c) => Transform.scale(
        scale: v,
        child: Opacity(opacity: v.clamp(0, 1), child: c),
      ),
      child: child,
    );
  }
}
