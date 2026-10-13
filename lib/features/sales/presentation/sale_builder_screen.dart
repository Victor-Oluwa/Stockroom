import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_ui.dart';
import '../../inventory/domain/product.dart';
import '../domain/sale.dart';
import 'cart_cubit.dart';

/// New-sale / checkout screen (PRD §6.7).
///
/// Layout: pick products at the top, cart lines in the middle, and a
/// sticky bottom bar that appears the moment the cart has anything —
/// total and Complete Sale are never more than a glance away.
class SaleBuilderScreen extends ConsumerStatefulWidget {
  const SaleBuilderScreen({super.key});
  @override
  ConsumerState<SaleBuilderScreen> createState() => _SaleBuilderScreenState();
}

class _SaleBuilderScreenState extends ConsumerState<SaleBuilderScreen> {
  final _search = TextEditingController();
  List<Product> _results = const [];
  bool _searching = false;
  bool _browsing = true;

  @override
  void initState() {
    super.initState();
    // Browse mode first: show what's on the shelf so there's always
    // something to tap, even before typing.
    Future.microtask(() => _runSearch(''));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _runSearch(String q) async {
    if (q.trim().isEmpty) {
      setState(() => _searching = true);
      final repo = ref.read(productRepositoryProvider);
      final r = await repo.listProducts(
        const ProductListFilter(showArchived: false),
      );
      if (!mounted) return;
      setState(() {
        _searching = false;
        _browsing = true;
        _results = r.fold((_) => const <Product>[], (v) => v);
      });
      return;
    }
    setState(() {
      _searching = true;
      _browsing = false;
    });
    final repo = ref.read(productRepositoryProvider);
    final r = await repo.listProducts(
      ProductListFilter(query: q, showArchived: false),
    );
    if (!mounted) return;
    setState(() {
      _searching = false;
      _results = r.fold((_) => const <Product>[], (v) => v);
    });
  }

  Future<void> _scan() async {
    final code = await context.push<String>('/scan');
    if (code == null || code.isEmpty || !mounted) return;
    final repo = ref.read(productRepositoryProvider);
    final found = await repo.findByBarcodeExact(code);
    if (!mounted) return;
    found.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (p) {
        if (p == null) {
          _noMatch(code);
        } else {
          context.read<SaleCartCubit>().addProduct(p);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Added “${p.name}”.')));
        }
      },
    );
  }

  Future<void> _noMatch(String code) async {
    final go = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No product found'),
        content: Text('No product has barcode “$code”.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create product'),
          ),
        ],
      ),
    );
    if (go == true && mounted) {
      context.push('/inventory/new', extra: {'barcode': code});
    }
  }

  Future<void> _editPaymentDetails() async {
    final cubit = context.read<SaleCartCubit>();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) =>
          BlocProvider.value(value: cubit, child: const _PaymentDetailsSheet()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New sale')),
      body: BlocConsumer<SaleCartCubit, CartState>(
        listenWhen: (a, b) => a.error != b.error || a.result != b.result,
        listener: (context, state) {
          if (state.error != null) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error!)));
          }
          // Device alert on stock transitions (in-app list always updates).
          if (state.result != null && state.result!.transitions.isNotEmpty) {
            ref
                .read(stockAlertServiceProvider)
                .notifyTransitions(state.result!.transitions);
          }
        },
        builder: (context, cart) {
          if (cart.result != null) {
            return _SuccessView(
              result: cart.result!,
              payment: cart.paymentMethod,
              onAnother: () => context.read<SaleCartCubit>().newSale(),
            );
          }
          final submitting = cart.submitting;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SearchField(
                            controller: _search,
                            hint: 'Search name, SKU, barcode',
                            onChanged: _runSearch,
                            onClear: () {
                              _search.clear();
                              _runSearch('');
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        _ScanButton(onScan: _scan),
                      ],
                    ),
                    if (_searching)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: LinearProgressIndicator(),
                      ),
                    if (_results.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      AppRowCard(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 10, 16, 2),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                _browsing
                                    ? 'Available — tap to add'
                                    : 'Results — tap to add',
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                          ),
                          for (final p in _results.take(15))
                            ListTile(
                              dense: true,
                              title: Text(
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${formatQty(p.quantityOnHandMilli, p.unitLabel)} · ${formatNaira(p.sellingPriceKobo)}',
                                style: const TextStyle(
                                  fontFeatures: AppTokens.tabular,
                                ),
                              ),
                              trailing: _AddIcon(
                                disabled: p.quantityOnHandMilli <= 0,
                                onAdd: () {
                                  context.read<SaleCartCubit>().addProduct(p);
                                  _search.clear();
                                  _runSearch('');
                                },
                              ),
                            ),
                          if (_results.length > 15)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Showing 15 of ${_results.length} — keep typing to narrow it down.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ] else if (!_searching &&
                        _search.text.trim().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      AppRowCard(
                        children: [
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.search_off_outlined),
                            title: Text(
                              'No matches for “${_search.text.trim()}”',
                            ),
                            subtitle: const Text(
                              'Check the spelling, scan again, or create it as a new product.',
                            ),
                            trailing: TextButton(
                              onPressed: () => context.push('/inventory/new'),
                              child: const Text('New product'),
                            ),
                          ),
                        ],
                      ),
                    ] else if (!_searching && _browsing) ...[
                      const SizedBox(height: 10),
                      AppRowCard(
                        children: [
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.inventory_2_outlined),
                            title: const Text('No products yet'),
                            subtitle: const Text(
                              'Add your first product, then come back to sell it.',
                            ),
                            trailing: TextButton(
                              onPressed: () => context.push('/inventory/new'),
                              child: const Text('Add product'),
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 14),
                    SectionHeader(
                      eyebrow: cart.lines.isEmpty
                          ? 'Cart'
                          : 'Cart · ${cart.lines.length}',
                    ),
                    const SizedBox(height: 8),
                    if (cart.lines.isEmpty)
                      const AppCard(
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.shopping_cart_outlined,
                            color: AppTokens.taupe,
                          ),
                          title: Text('Cart is empty'),
                          subtitle: Text(
                            'Pick from the list above, or search.',
                          ),
                        ),
                      ),
                    for (final l in cart.lines)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _CartLineCard(
                          line: l,
                          submitting: cart.submitting,
                        ),
                      ),
                  ],
                ),
              ),
              _CheckoutBar(
                cart: cart,
                submitting: submitting,
                onEditPayment: _editPaymentDetails,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _AddIcon extends StatelessWidget {
  const _AddIcon({required this.disabled, required this.onAdd});
  final bool disabled;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: disabled ? AppTokens.coalRaised : AppTokens.moss,
        borderRadius: BorderRadius.circular(11),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        icon: Icon(
          Icons.add_rounded,
          size: 20,
          color: disabled ? AppTokens.taupeDim : AppTokens.onMoss,
        ),
        tooltip: disabled ? 'Out of stock' : 'Add to sale',
        onPressed: disabled ? null : onAdd,
      ),
    );
  }
}

class _ScanButton extends StatelessWidget {
  const _ScanButton({required this.onScan});
  final VoidCallback onScan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppTokens.moss,
        borderRadius: BorderRadius.circular(AppTokens.controlRadius),
      ),
      child: IconButton(
        icon: const Icon(Icons.qr_code_scanner, color: AppTokens.onMoss),
        tooltip: 'Scan barcode',
        onPressed: onScan,
      ),
    );
  }
}

/// Sticky checkout: line count, total, and the primary action stay
/// visible. Appears only when the cart has lines.
class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({
    required this.cart,
    required this.submitting,
    required this.onEditPayment,
  });
  final CartState cart;
  final bool submitting;
  final VoidCallback onEditPayment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasLines = cart.lines.isNotEmpty;
    return AnimatedSize(
      duration: AppTokens.durBase,
      curve: AppTokens.easeEmph,
      alignment: Alignment.bottomCenter,
      child: hasLines
          ? SafeArea(
              top: false,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppTokens.coal,
                  border: Border(top: BorderSide(color: AppTokens.line)),
                ),
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTokens.mossSoft,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${cart.lines.length} ITEM${cart.lines.length == 1 ? '' : 'S'}',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: AppTokens.moss,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Payment: ${cart.paymentMethod}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppTokens.taupe,
                            ),
                          ),
                        ),
                        const Spacer(),
                        TextButton.icon(
                          onPressed: submitting ? null : onEditPayment,
                          icon: const Icon(Icons.tune_outlined, size: 16),
                          label: const Text('Details'),
                          style: TextButton.styleFrom(
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TOTAL',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: AppTokens.taupe,
                                  letterSpacing: 1.1,
                                ),
                              ),
                              Text(
                                formatNaira(cart.totalKobo),
                                style: theme.textTheme.titleLarge?.copyWith(
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
                            onPressed: submitting
                                ? null
                                : () =>
                                      context.read<SaleCartCubit>().checkout(),
                            child: submitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Complete sale · ${formatNaira(cart.totalKobo)}',
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}

/// Payment method, customer and note — kept out of the way in a sheet
/// so the main screen stays about picking products.
class _PaymentDetailsSheet extends StatelessWidget {
  const _PaymentDetailsSheet();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<SaleCartCubit>();
    return BlocBuilder<SaleCartCubit, CartState>(
      builder: (context, cart) {
        final submitting = cart.submitting;
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payment details',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final m in paymentMethods)
                    ChoiceChip(
                      label: Text(m),
                      selected: cart.paymentMethod == m,
                      showCheckmark: false,
                      onSelected: submitting
                          ? null
                          : (_) => cubit.setPayment(m),
                    ),
                ],
              ),
              const SizedBox(height: 14),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Customer (optional)',
                ),
                onChanged: cubit.setCustomer,
                enabled: !submitting,
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(labelText: 'Note (optional)'),
                onChanged: cubit.setNote,
                enabled: !submitting,
              ),
              const SizedBox(height: 6),
            ],
          ),
        );
      },
    );
  }
}

class _CartLineCard extends StatelessWidget {
  const _CartLineCard({required this.line, required this.submitting});
  final CartLine line;
  final bool submitting;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<SaleCartCubit>();
    return AppCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  line.product.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: AppTokens.taupe,
                tooltip: 'Remove',
                onPressed: submitting
                    ? null
                    : () => cubit.removeLine(line.product.id),
              ),
            ],
          ),
          Text(
            'Available ${formatQty(line.product.quantityOnHandMilli, line.product.unitLabel)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppTokens.taupe,
              fontFeatures: AppTokens.tabular,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _SmallField(
                  label: 'Qty',
                  initial: _milli(line.quantityMilli),
                  enabled: !submitting,
                  keyboard: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onSubmit: (v) {
                    try {
                      final q = parseQuantityToMilli(v);
                      if (q <= 0) {
                        throw const FormatException('Qty must be > 0');
                      }
                      cubit.setQuantity(line.product.id, q);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e is FormatException
                                ? e.message
                                : 'Invalid quantity',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallField(
                  label: 'Price ₦',
                  initial: _kobo(line.unitPriceKobo),
                  enabled: !submitting,
                  keyboard: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onSubmit: (v) {
                    try {
                      cubit.setPrice(line.product.id, parseNairaToKobo(v));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e is FormatException ? e.message : 'Invalid price',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SmallField(
                  label: 'Discount ₦',
                  initial: line.discountKobo == 0
                      ? ''
                      : _kobo(line.discountKobo),
                  enabled: !submitting,
                  keyboard: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  onSubmit: (v) {
                    try {
                      final d = v.trim().isEmpty ? 0 : parseNairaToKobo(v);
                      if (d > line.grossKobo) {
                        throw const FormatException(
                          'Discount exceeds line total',
                        );
                      }
                      cubit.setDiscount(line.product.id, d);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e is FormatException
                                ? e.message
                                : 'Invalid discount',
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              formatNaira(line.netKobo),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                fontFeatures: AppTokens.tabular,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _milli(int m) {
    final whole = m ~/ 1000;
    final frac = (m % 1000)
        .toString()
        .padLeft(3, '0')
        .replaceAll(RegExp(r'0+$'), '');
    return frac.isEmpty ? '$whole' : '$whole.$frac';
  }

  String _kobo(int k) =>
      '${k ~/ 100}${k % 100 == 0 ? '' : '.${(k % 100).toString().padLeft(2, '0')}'}';
}

class _SmallField extends StatefulWidget {
  const _SmallField({
    required this.label,
    required this.initial,
    required this.enabled,
    required this.keyboard,
    required this.onSubmit,
  });
  final String label;
  final String initial;
  final bool enabled;
  final TextInputType keyboard;
  final ValueChanged<String> onSubmit;

  @override
  State<_SmallField> createState() => _SmallFieldState();
}

class _SmallFieldState extends State<_SmallField> {
  late final TextEditingController _c;

  @override
  void initState() {
    super.initState();
    _c = TextEditingController(text: widget.initial);
  }

  @override
  void didUpdateWidget(covariant _SmallField old) {
    super.didUpdateWidget(old);
    if (old.initial != widget.initial &&
        _c.text != widget.initial &&
        FocusScope.of(context).hasFocus == false) {
      _c.text = widget.initial;
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _c,
      enabled: widget.enabled,
      decoration: InputDecoration(labelText: widget.label, isDense: true),
      keyboardType: widget.keyboard,
      textInputAction: TextInputAction.done,
      onSubmitted: widget.onSubmit,
      onEditingComplete: () => widget.onSubmit(_c.text),
    );
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({
    required this.result,
    required this.payment,
    required this.onAnother,
  });
  final SaleResult result;
  final String payment;
  final VoidCallback onAnother;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Center(
            child: _ScaleIn(
              child: Container(
                width: 88,
                height: 88,
                decoration: BoxDecoration(
                  color: AppTokens.mossSoft,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: AppTokens.moss.withValues(alpha: 0.5),
                  ),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 44,
                  color: AppTokens.moss,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Sale ${result.saleNumber} completed',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            formatNaira(result.totalKobo),
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w800,
              fontFeatures: AppTokens.tabular,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            payment,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(color: AppTokens.taupe),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go('/sales/${result.saleId}'),
            child: const Text('View receipt'),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: onAnother,
            child: const Text('Start another sale'),
          ),
          OutlinedButton(
            onPressed: () => context.go('/sales'),
            child: const Text('Back to sales'),
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
