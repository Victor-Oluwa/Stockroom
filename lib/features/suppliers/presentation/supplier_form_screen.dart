import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/di/providers.dart';
import '../../../core/widgets/app_ui.dart';
import '../domain/supplier.dart';

class SupplierFormScreen extends ConsumerStatefulWidget {
  const SupplierFormScreen.create({super.key}) : supplierId = null;
  const SupplierFormScreen.edit({super.key, required this.supplierId});
  final String? supplierId;
  bool get isEdit => supplierId != null;

  @override
  ConsumerState<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends ConsumerState<SupplierFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _contact = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _address = TextEditingController();
  final _notes = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) _load();
  }

  Future<void> _load() async {
    final repo = ref.read(supplierRepositoryProvider);
    final r = await repo.get(widget.supplierId!);
    r.fold((_) => null, (Supplier? s) {
      if (s == null || !mounted) return;
      setState(() {
        _name.text = s.name;
        _contact.text = s.contactName ?? '';
        _phone.text = s.phone ?? '';
        _email.text = s.email ?? '';
        _address.text = s.address ?? '';
        _notes.text = s.notes ?? '';
      });
    });
  }

  @override
  void dispose() {
    _name.dispose();
    _contact.dispose();
    _phone.dispose();
    _email.dispose();
    _address.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit supplier' : 'Add supplier'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SectionHeader(eyebrow: 'Supplier'),
              const SizedBox(height: 8),
              AppCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: 'Supplier name *',
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty)
                          ? 'Supplier name is required'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _contact,
                      decoration: const InputDecoration(
                        labelText: 'Contact person (optional)',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone (optional)',
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        labelText: 'Email (optional)',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SectionHeader(eyebrow: 'More (optional)'),
              const SizedBox(height: 8),
              AppCard(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _address,
                      decoration: const InputDecoration(
                        labelText: 'Address (optional)',
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
                  ],
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
                    : Text(widget.isEdit ? 'Save changes' : 'Add supplier'),
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
    final repo = ref.read(supplierRepositoryProvider);
    final result = widget.isEdit
        ? await repo.update(
            id: widget.supplierId!,
            name: _name.text,
            contactName: _contact.text,
            phone: _phone.text,
            email: _email.text,
            address: _address.text,
            notes: _notes.text,
          )
        : await repo.create(
            name: _name.text,
            contactName: _contact.text,
            phone: _phone.text,
            email: _email.text,
            address: _address.text,
            notes: _notes.text,
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
              widget.isEdit ? 'Supplier updated.' : 'Supplier added.',
            ),
          ),
        );
        context.pop(true);
      },
    );
  }
}
