import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/tokens.dart';
import '../../../core/widgets/app_ui.dart';
import 'setup_cubit.dart';

/// First-launch setup flow (PRD §6.1). Offline, no account/OTP.
class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _footer = TextEditingController();
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    context.read<BusinessSetupCubit>().load();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _footer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set up Stockroom')),
      body: BlocConsumer<BusinessSetupCubit, SetupState>(
        listener: (context, state) {
          if (state is SetupLoaded && !_loaded && state.existing != null) {
            _loaded = true;
            _name.text = state.existing!.businessName;
            _phone.text = state.existing!.phone ?? '';
            _address.text = state.existing!.address ?? '';
            _footer.text = state.existing!.receiptFooter ?? '';
          }
          if (state is SetupSuccess) {
            context.go('/overview');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Business saved.')));
          }
          if (state is SetupError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is SetupLoading || state is SetupInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          final saving = state is SetupSaving;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTokens.mossSoft,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTokens.moss.withValues(alpha: 0.4),
                          ),
                        ),
                        child: const Icon(
                          Icons.store_outlined,
                          color: AppTokens.moss,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your shop, on this device',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Works offline · no account needed',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: AppTokens.taupe),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  AppCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            labelText: 'Business name *',
                          ),
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Business name is required'
                              : null,
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
                          controller: _address,
                          decoration: const InputDecoration(
                            labelText: 'Address (optional)',
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _footer,
                          decoration: const InputDecoration(
                            labelText: 'Receipt footer (optional)',
                          ),
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: saving
                        ? null
                        : () {
                            if (_form.currentState!.validate()) {
                              context.read<BusinessSetupCubit>().save(
                                businessName: _name.text,
                                phone: _phone.text,
                                address: _address.text,
                                receiptFooter: _footer.text,
                              );
                            }
                          },
                    child: saving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Save and continue'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
