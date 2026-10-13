import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'di/providers.dart';
import '../app/theme/tokens.dart' show AppTokens;
import '../core/widgets/app_motion.dart';
import '../core/widgets/app_ui.dart';
import '../features/onboarding/domain/business_profile.dart';

/// "More" hub: everything that is not a primary tab. Tile grid for the
/// record-keeping destinations, grouped cards for device/data concerns.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileRepo = ref.watch(businessProfileRepositoryProvider);
    final entries = [
      (
        Icons.category_outlined,
        'Categories',
        'Organise products',
        () => context.push('/categories'),
      ),
      (
        Icons.people_outline,
        'Suppliers',
        'Who you buy stock from',
        () => context.push('/suppliers'),
      ),
      (
        Icons.call_received_outlined,
        'Receive stock',
        'Record inventory arriving',
        () => context.push('/receive'),
      ),
      (
        Icons.receipt_outlined,
        'Stock receipts',
        'Purchase history',
        () => context.push('/receipts'),
      ),
      (
        Icons.manage_history_outlined,
        'Stock movements',
        'Full ledger audit trail',
        () => context.push('/movements'),
      ),
      (
        Icons.account_balance_wallet_outlined,
        'Expenses',
        'Rent, transport, wages',
        () => context.push('/expenses'),
      ),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('More')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          StreamBuilder<BusinessProfile?>(
            stream: profileRepo.watch(),
            builder: (context, snap) {
              final profile = snap.data;
              return AppCard(
                onTap: () => context.push('/settings'),
                child: Row(
                  children: [
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: AppTokens.mossSoft,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppTokens.moss.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.storefront_outlined,
                        size: 22,
                        color: AppTokens.moss,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.businessName ?? 'Stockroom',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Business settings, backup and storage',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppTokens.taupe),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_outlined,
                      color: AppTokens.taupeDim,
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          const SectionHeader(eyebrow: 'Manage'),
          const SizedBox(height: 10),
          StaggerIn(
            index: 1,
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              mainAxisExtent: 116,
              children: [
                for (final e in entries)
                  _ActionTile(
                    icon: e.$1,
                    label: e.$2,
                    subtitle: e.$3,
                    onTap: e.$4,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          const SectionHeader(eyebrow: 'Device & data'),
          const SizedBox(height: 10),
          StaggerIn(
            index: 2,
            child: Column(
              children: [
                const _NotificationCard(),
                const SizedBox(height: 10),
                _IntegrityCard(ref: ref),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 13, 14, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTokens.coalRaised,
                      borderRadius: BorderRadius.circular(11),
                      border: Border.all(color: AppTokens.line),
                    ),
                    child: Icon(icon, size: 18, color: AppTokens.moss),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right_outlined,
                    size: 16,
                    color: AppTokens.taupeDim,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: theme.textTheme.titleSmall?.copyWith(height: 1.25),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTokens.taupe,
                  fontSize: 11,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationCard extends ConsumerStatefulWidget {
  const _NotificationCard();

  @override
  ConsumerState<_NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends ConsumerState<_NotificationCard> {
  bool? _on;

  @override
  void initState() {
    super.initState();
    ref.read(stockAlertServiceProvider).notificationsOn.then((v) {
      if (mounted) setState(() => _on = v);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: SwitchListTile(
        secondary: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTokens.coalRaised,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppTokens.line),
          ),
          child: const Icon(
            Icons.notifications_outlined,
            size: 19,
            color: AppTokens.moss,
          ),
        ),
        title: const Text('Stock alerts on this device'),
        subtitle: const Text('Low-stock and out-of-stock'),
        value: _on ?? true,
        activeThumbColor: AppTokens.moss,
        onChanged: (v) async {
          if (v) {
            final granted = await _explainAndRequest();
            if (!granted) return;
          }
          await ref.read(stockAlertServiceProvider).setNotificationsOn(v);
          if (mounted) setState(() => _on = v);
        },
      ),
    );
  }

  Future<bool> _explainAndRequest() async {
    final proceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Allow stock alerts?'),
        content: const Text(
          'Stockroom notifies you on this device when an item runs low or out — no account, no internet. You can turn this off anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Not now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Allow'),
          ),
        ],
      ),
    );
    if (proceed != true) return false;
    final granted = await ref
        .read(stockAlertServiceProvider)
        .requestPermission();
    if (!granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Permission denied. Alerts stay available inside the app.',
          ),
        ),
      );
    }
    return granted;
  }
}

class _IntegrityCard extends StatelessWidget {
  const _IntegrityCard({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppTokens.coalRaised,
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: AppTokens.line),
          ),
          child: const Icon(
            Icons.verified_outlined,
            size: 19,
            color: AppTokens.moss,
          ),
        ),
        title: const Text('Check stock integrity'),
        subtitle: const Text('Compare quantities to ledger'),
        trailing: const Icon(
          Icons.chevron_right_outlined,
          color: AppTokens.taupeDim,
        ),
        onTap: () => _runIntegrity(context, ref),
      ),
    );
  }

  Future<void> _runIntegrity(BuildContext context, WidgetRef ref) async {
    final repo = ref.read(productRepositoryProvider);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    final result = await repo.checkIntegrity();
    if (context.mounted) Navigator.pop(context);
    if (!context.mounted) return;
    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (bad) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Stock integrity'),
          content: SingleChildScrollView(
            child: Text(
              bad.isEmpty
                  ? 'All quantities match the ledger.'
                  : bad
                        .map(
                          (m) =>
                              '• ${m.productName}: cached ${m.cachedMilli}, ledger ${m.ledgerMilli}',
                        )
                        .join('\n'),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        ),
      ),
    );
  }
}
