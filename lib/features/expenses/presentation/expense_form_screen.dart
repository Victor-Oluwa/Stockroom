import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_ui.dart';
import '../../sales/domain/sale.dart' show paymentMethods;
import '../domain/expense.dart';

class ExpenseFormScreen extends ConsumerStatefulWidget {
  const ExpenseFormScreen.create({super.key}) : expenseId = null;
  const ExpenseFormScreen.edit({super.key, required this.expenseId});
  final String? expenseId;
  bool get isEdit => expenseId != null;

  @override
  ConsumerState<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends ConsumerState<ExpenseFormScreen> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _note = TextEditingController();
  String _category = expenseCategories.first;
  String _payment = paymentMethods.first;
  DateTime _day = DateTime.now();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) _load();
  }

  Future<void> _load() async {
    final r = await ref.read(expenseRepositoryProvider).get(widget.expenseId!);
    r.fold((_) => null, (Expense? e) {
      if (e == null || !mounted) return;
      setState(() {
        _amount.text =
            '${e.amountKobo ~/ 100}${e.amountKobo % 100 == 0 ? '' : '.${(e.amountKobo % 100).toString().padLeft(2, '0')}'}';
        _note.text = e.note ?? '';
        _category = expenseCategories.contains(e.category)
            ? e.category
            : 'Other';
        _payment = paymentMethods.contains(e.paymentMethod)
            ? e.paymentMethod
            : paymentMethods.first;
        _day = e.expenseDate.toLocal();
      });
    });
  }

  @override
  void dispose() {
    _amount.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDay() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _day,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null && mounted) setState(() => _day = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit expense' : 'Record expense'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(eyebrow: 'Details'),
              const SizedBox(height: 8),
              AppCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _amount,
                      decoration: const InputDecoration(
                        labelText: 'Amount ₦ *',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (v) {
                        try {
                          if (parseNairaToKobo(v ?? '') <= 0) {
                            return 'Amount must be greater than zero';
                          }
                        } catch (e) {
                          return e is FormatException
                              ? e.message
                              : 'Invalid amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: const InputDecoration(
                        labelText: 'Category *',
                      ),
                      items: [
                        for (final c in expenseCategories)
                          DropdownMenuItem(value: c, child: Text(c)),
                      ],
                      onChanged: _saving
                          ? null
                          : (v) => setState(() => _category = v ?? _category),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _payment,
                      decoration: const InputDecoration(
                        labelText: 'Payment method',
                      ),
                      items: [
                        for (final m in paymentMethods)
                          DropdownMenuItem(value: m, child: Text(m)),
                      ],
                      onChanged: _saving
                          ? null
                          : (v) => setState(() => _payment = v ?? _payment),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _note,
                      decoration: const InputDecoration(
                        labelText: 'Note (optional)',
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SectionHeader(eyebrow: 'Date'),
              const SizedBox(height: 8),
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.calendar_today_outlined,
                    color: AppTokens.moss,
                  ),
                  title: Text(
                    formatDateLocal(_day.toUtc()),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text('Expense date'),
                  trailing: TextButton(
                    onPressed: _saving ? null : _pickDay,
                    child: const Text('Change'),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.isEdit ? 'Save changes' : 'Record expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(expenseRepositoryProvider);
    final result = widget.isEdit
        ? await repo.update(
            id: widget.expenseId!,
            amountKobo: parseNairaToKobo(_amount.text),
            category: _category,
            day: _day,
            paymentMethod: _payment,
            note: _note.text,
          )
        : await repo.record(
            amountKobo: parseNairaToKobo(_amount.text),
            category: _category,
            day: _day,
            paymentMethod: _payment,
            note: _note.text,
          );
    if (!mounted) return;
    setState(() => _saving = false);
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEdit ? 'Expense updated.' : 'Expense recorded.',
            ),
          ),
        );
        context.pop(true);
      },
    );
  }
}
