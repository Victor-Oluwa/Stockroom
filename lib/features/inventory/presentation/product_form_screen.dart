import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/widgets/app_ui.dart';
import '../domain/category.dart';
import '../domain/product.dart';
import '../data/product_image_store.dart';
import 'product_form_cubit.dart';
import 'widgets/product_image_view.dart';

/// Create/edit product (PRD §6.3). Quantity is never edited here —
/// all stock changes go through ledger workflows (Phase 3+).
class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen.create({super.key, this.barcodePrefill})
    : productId = null;
  const ProductFormScreen.edit({super.key, required this.productId})
    : barcodePrefill = null;

  final String? productId;
  final String? barcodePrefill;
  bool get isEdit => productId != null;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _sku = TextEditingController();
  final _barcode = TextEditingController();
  final _price = TextEditingController();
  final _openingQty = TextEditingController(text: '0');
  final _openingCost = TextEditingController();
  final _threshold = TextEditingController(text: '5');
  final _description = TextEditingController();
  String _unit = 'piece';
  String? _categoryId;
  bool _zeroConfirmed = false;
  bool _savingImage = false;

  XFile? _picked;
  String? _existingImage;
  bool _removeImage = false;

  @override
  void initState() {
    super.initState();
    if (widget.barcodePrefill != null) _barcode.text = widget.barcodePrefill!;
    final cubit = context.read<ProductFormCubit>();
    cubit.operationKey ??= const Uuid().v4();
    if (widget.isEdit) {
      _loadExisting();
    } else {
      _loadDefaultThreshold();
    }
  }

  /// New products start at the Settings default, not a hardcoded 5.
  Future<void> _loadDefaultThreshold() async {
    final result = await ref
        .read(settingsRepositoryProvider)
        .defaultThresholdMilli();
    if (!mounted) return;
    result.fold((_) => null, (milli) {
      if (mounted) setState(() => _threshold.text = _milliToInput(milli));
    });
  }

  Future<void> _loadExisting() async {
    final repo = ref.read(productRepositoryProvider);
    final result = await repo.getProduct(widget.productId!);
    result.fold((_) => null, (p) {
      if (p == null || !mounted) return;
      setState(() {
        _name.text = p.name;
        _sku.text = p.sku ?? '';
        _barcode.text = p.barcode ?? '';
        _price.text = _koboToInput(p.sellingPriceKobo);
        _unit = unitLabels.contains(p.unitLabel) ? p.unitLabel : 'piece';
        _categoryId = p.categoryId;
        _threshold.text = _milliToInput(p.lowStockThresholdMilli);
        _description.text = p.description ?? '';
        _existingImage = p.imagePath;
        if (p.sellingPriceKobo == 0) _zeroConfirmed = true;
      });
    });
  }

  String _koboToInput(int kobo) =>
      '${kobo ~/ 100}${kobo % 100 == 0 ? '' : '.${(kobo % 100).toString().padLeft(2, '0')}'}';
  String _milliToInput(int milli) {
    final whole = milli ~/ 1000;
    var frac = (milli % 1000)
        .toString()
        .padLeft(3, '0')
        .replaceAll(RegExp(r'0+$'), '');
    return frac.isEmpty ? '$whole' : '$whole.$frac';
  }

  @override
  void dispose() {
    _name.dispose();
    _sku.dispose();
    _barcode.dispose();
    _price.dispose();
    _openingQty.dispose();
    _openingCost.dispose();
    _threshold.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit product' : 'Add product'),
      ),
      body: BlocConsumer<ProductFormCubit, ProductFormState>(
        listener: (context, state) {
          if (state is ProductFormSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  widget.isEdit ? 'Product updated.' : 'Product added.',
                ),
              ),
            );
            context.pop(true);
          }
          if (state is ProductFormError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final saving = state is ProductFormSaving || _savingImage;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ImageSection(
                    picked: _picked,
                    existing: _removeImage ? null : _existingImage,
                    onPick: saving
                        ? null
                        : () async {
                            final file = await ImagePicker().pickImage(
                              source: ImageSource.gallery,
                            );
                            if (file != null) {
                              setState(() {
                                _picked = file;
                                _removeImage = false;
                              });
                            }
                          },
                    onRemove: saving
                        ? null
                        : () => setState(() {
                            _picked = null;
                            _removeImage = true;
                          }),
                  ),
                  const SizedBox(height: 20),
                  const SectionHeader(eyebrow: 'Basics'),
                  const SizedBox(height: 8),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            labelText: 'Product name *',
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Product name is required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _sku,
                                decoration: const InputDecoration(
                                  labelText: 'SKU (optional)',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _barcode,
                                decoration: const InputDecoration(
                                  labelText: 'Barcode (optional)',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _CategoryField(
                          value: _categoryId,
                          onChanged: saving
                              ? null
                              : (v) => setState(() => _categoryId = v),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                initialValue: _unit,
                                decoration: const InputDecoration(
                                  labelText: 'Unit *',
                                ),
                                items: [
                                  for (final u in unitLabels)
                                    DropdownMenuItem(value: u, child: Text(u)),
                                ],
                                onChanged: saving
                                    ? null
                                    : (v) =>
                                          setState(() => _unit = v ?? 'piece'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextFormField(
                                controller: _price,
                                decoration: const InputDecoration(
                                  labelText: 'Selling price ₦ *',
                                ),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                validator: (v) {
                                  try {
                                    _parsePrice(v ?? '');
                                  } catch (e) {
                                    return e is FormatException
                                        ? e.message
                                        : 'Invalid price';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        if (_isZeroPrice())
                          CheckboxListTile(
                            value: _zeroConfirmed,
                            onChanged: saving
                                ? null
                                : (v) => setState(
                                    () => _zeroConfirmed = v ?? false,
                                  ),
                            title: const Text(
                              'This product is really free (₦0)',
                            ),
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                          ),
                      ],
                    ),
                  ),
                  if (!widget.isEdit) ...[
                    const SizedBox(height: 20),
                    const SectionHeader(eyebrow: 'Opening stock'),
                    const SizedBox(height: 8),
                    AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _openingQty,
                                  decoration: const InputDecoration(
                                    labelText: 'Opening stock qty',
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator: (v) {
                                    try {
                                      _parseQty(v ?? '');
                                    } catch (e) {
                                      return e is FormatException
                                          ? e.message
                                          : 'Invalid qty';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextFormField(
                                  controller: _openingCost,
                                  decoration: const InputDecoration(
                                    labelText: 'Opening unit cost ₦',
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                  validator: (v) {
                                    final qty = _tryQty(_openingQty.text);
                                    if (qty != null && qty > 0) {
                                      if ((v ?? '').trim().isEmpty) {
                                        return 'Cost required for opening stock';
                                      }
                                      try {
                                        _parsePrice(v!);
                                      } catch (e) {
                                        return e is FormatException
                                            ? e.message
                                            : 'Invalid cost';
                                      }
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Opening stock is recorded as a movement in the ledger. Leave zero to add stock by receiving later.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTokens.taupeDim),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  const SectionHeader(eyebrow: 'Alerts & notes'),
                  const SizedBox(height: 8),
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _threshold,
                          decoration: const InputDecoration(
                            labelText:
                                'Low-stock threshold (units, 0 disables)',
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (v) {
                            try {
                              _parseQty(v ?? '');
                            } catch (e) {
                              return e is FormatException
                                  ? e.message
                                  : 'Invalid value';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _description,
                          decoration: const InputDecoration(
                            labelText: 'Notes (optional)',
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: saving ? null : _submit,
                    child: saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(widget.isEdit ? 'Save changes' : 'Add product'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  bool _isZeroPrice() {
    final q = _tryPrice(_price.text);
    return q != null && q == 0;
  }

  int _parsePrice(String input) {
    final cleaned = input
        .trim()
        .replaceAll('₦', '')
        .replaceAll(',', '')
        .replaceAll(' ', '');
    final match = RegExp(r'^(\d+)(?:\.(\d{1,2}))?$').firstMatch(cleaned);
    if (match == null || cleaned.isEmpty) {
      throw const FormatException('Enter a valid amount (max 2dp)');
    }
    return int.parse(match.group(1)!) * 100 +
        int.parse(
          (match.group(2) ?? '').padRight(2, '0').isEmpty
              ? '00'
              : (match.group(2) ?? '').padRight(2, '0'),
        );
  }

  int? _tryPrice(String v) {
    try {
      return _parsePrice(v);
    } catch (_) {
      return null;
    }
  }

  int _parseQty(String input) {
    final cleaned = input.trim().replaceAll(',', '').replaceAll(' ', '');
    final match = RegExp(r'^(\d+)(?:\.(\d{1,3}))?$').firstMatch(cleaned);
    if (match == null || cleaned.isEmpty) {
      throw const FormatException('Enter a valid qty (max 3dp)');
    }
    return int.parse(match.group(1)!) * 1000 +
        int.parse(
          ((match.group(2) ?? '').padRight(3, '0')).isEmpty
              ? '000'
              : (match.group(2) ?? '').padRight(3, '0'),
        );
  }

  int? _tryQty(String v) {
    try {
      return _parseQty(v);
    } catch (_) {
      return null;
    }
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    final price = _parsePrice(_price.text);
    if (price == 0 && !_zeroConfirmed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Confirm that this product is really free.'),
        ),
      );
      setState(() {});
      return;
    }
    final threshold = _parseQty(_threshold.text);
    final cubit = context.read<ProductFormCubit>();
    setState(() => _savingImage = true);
    String? imagePath = _removeImage ? null : _existingImage;
    String? oldToDelete;
    try {
      if (_picked != null) {
        final ProductImageStore store = ref.read(productImageStoreProvider);
        imagePath = await store.saveProductImage(_picked!.path);
        oldToDelete = _existingImage;
      }
      if (_removeImage && _existingImage != null) {
        oldToDelete = _existingImage;
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _savingImage = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save photo. Try again.')),
      );
      return;
    }
    if (!mounted) return;
    setState(() => _savingImage = false);

    if (widget.isEdit) {
      await cubit.update(
        id: widget.productId!,
        name: _name.text,
        sku: _sku.text,
        barcode: _barcode.text,
        categoryId: _categoryId,
        unitLabel: _unit,
        sellingPriceKobo: price,
        zeroPriceConfirmed: _zeroConfirmed,
        lowStockThresholdMilli: threshold,
        imagePath: imagePath,
        description: _description.text,
      );
    } else {
      final qty = _parseQty(_openingQty.text);
      final costText = _openingCost.text.trim();
      await cubit.create(
        name: _name.text,
        sku: _sku.text,
        barcode: _barcode.text,
        categoryId: _categoryId,
        unitLabel: _unit,
        sellingPriceKobo: price,
        zeroPriceConfirmed: _zeroConfirmed,
        openingQtyMilli: qty,
        openingUnitCostKobo: qty > 0 && costText.isNotEmpty
            ? _parsePrice(costText)
            : null,
        lowStockThresholdMilli: threshold,
        imagePath: imagePath,
        description: _description.text,
      );
    }
    if (oldToDelete != null && cubit.state is ProductFormSuccess) {
      try {
        await ref.read(productImageStoreProvider).deleteImage(oldToDelete);
      } catch (_) {}
    }
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({this.picked, this.existing, this.onPick, this.onRemove});
  final XFile? picked;
  final String? existing;
  final VoidCallback? onPick;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = picked != null || existing != null;
    return AppCard(
      child: Row(
        children: [
          _Preview(picked: picked, existing: existing, size: 64),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hasImage ? 'Photo saved' : 'No photo yet',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  picked != null
                      ? 'New photo ready to save'
                      : 'A photo helps recognise the product at a glance.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTokens.taupe,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.photo_outlined, size: 18),
            label: Text(hasImage ? 'Change' : 'Add'),
          ),
          if (hasImage)
            IconButton(
              onPressed: onRemove,
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Remove photo',
            ),
        ],
      ),
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    required this.picked,
    required this.existing,
    this.size = 64,
  });
  final XFile? picked;
  final String? existing;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (picked != null) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: AppTokens.coalRaised,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTokens.line),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Image.file(
            File(picked!.path),
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const Icon(Icons.image_outlined, color: AppTokens.taupeDim),
          ),
        ),
      );
    }
    return ProductImageView(relativePath: existing, size: size);
  }
}

class _CategoryField extends ConsumerWidget {
  const _CategoryField({this.value, this.onChanged});
  final String? value;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(categoryRepositoryProvider);
    return StreamBuilder<List<ProductCategory>>(
      stream: repo.watchActive(),
      builder: (context, snap) {
        final cats = snap.data ?? const <ProductCategory>[];
        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String?>(
                initialValue: value,
                decoration: const InputDecoration(
                  labelText: 'Category (optional)',
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('None')),
                  for (final c in cats)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: onChanged,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Manage categories',
              onPressed: () => context.push('/categories'),
            ),
          ],
        );
      },
    );
  }
}
