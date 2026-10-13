import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;

import '../../../app/di/providers.dart';
import '../../../app/theme/tokens.dart';
import '../../../core/files/share_file.dart';
import '../../../core/formatting/format.dart';
import '../../../core/widgets/app_states.dart';
import '../../../core/widgets/app_ui.dart';
import '../../onboarding/domain/business_profile.dart';
import '../data/backup_repository.dart';

/// Local data management (PRD §6.14): profile, thresholds, storage,
/// integrity, backup and restore. Everything works offline.
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _busy = false;
  String? _busyLabel;

  Future<void> _guard(String label, Future<void> Function() work) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _busyLabel = label;
    });
    try {
      await work();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final profileRepo = ref.watch(businessProfileRepositoryProvider);
    final settingsRepo = ref.watch(settingsRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              const SectionHeader(eyebrow: 'Business'),
              const SizedBox(height: 8),
              StreamBuilder<BusinessProfile?>(
                stream: profileRepo.watch(),
                builder: (context, snap) {
                  final profile = snap.data;
                  return AppCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: ListTile(
                      leading: _icon(Icons.store_outlined),
                      title: Text(
                        profile?.businessName ?? '—',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: profile?.phone != null
                          ? Text(profile!.phone!)
                          : const Text('On this device · offline'),
                      trailing: TextButton(
                        onPressed: () => context.push('/setup'),
                        child: const Text('Edit'),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const SectionHeader(eyebrow: 'Defaults'),
              const SizedBox(height: 8),
              AppCard(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: FutureBuilder(
                  future: settingsRepo.defaultThresholdMilli(),
                  builder: (context, snap) {
                    final milli = snap.data?.fold((_) => 5000, (v) => v);
                    return ListTile(
                      leading: _icon(Icons.notifications_outlined),
                      title: const Text('Default low-stock alert'),
                      subtitle: Text(
                        'New products warn at ${formatQty(milli ?? 5000)}',
                      ),
                      trailing: TextButton(
                        onPressed: () => _editThreshold(milli ?? 5000),
                        child: const Text('Change'),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const SectionHeader(eyebrow: 'Storage on this device'),
              const SizedBox(height: 8),
              AppCard(
                child: FutureBuilder(
                  future: Future.wait([
                    settingsRepo.storageInfo(),
                    settingsRepo.appVersion(),
                  ]),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: AppLoading(message: 'Measuring storage…'),
                      );
                    }
                    final info = snap.data![0] as dynamic;
                    final version = snap.data![1] as String;
                    return Column(
                      children: [
                        ReportRow(
                          label: 'Database',
                          value: _mb(info.dbBytes),
                          strong: true,
                        ),
                        ReportRow(
                          label: 'Product images (${info.imageCount})',
                          value: _mb(info.imageBytes),
                          strong: true,
                        ),
                        ReportRow(label: 'App version', value: version),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const SectionHeader(eyebrow: 'Data safety'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppTokens.mossSoft,
                  borderRadius: BorderRadius.circular(AppTokens.cardRadius),
                  border: Border.all(
                    color: AppTokens.moss.withValues(alpha: 0.45),
                  ),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTokens.moss,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.backup_outlined,
                      color: AppTokens.onMoss,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Back up your records regularly',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  subtitle: const Text(
                    'Records live only on this device. Export weekly and keep it somewhere safe.',
                  ),
                  trailing: FilledButton(
                    onPressed: _busy ? null : () => _export(),
                    child: const Text('Back up'),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AppRowCard(
                children: [
                  ListTile(
                    leading: _icon(Icons.verified_outlined),
                    title: const Text('Check stock integrity'),
                    subtitle: const Text('Compare quantities to the ledger'),
                    trailing: const Icon(
                      Icons.chevron_right_outlined,
                      color: AppTokens.taupeDim,
                    ),
                    onTap: _busy ? null : () => _runIntegrity(),
                  ),
                  ListTile(
                    leading: _icon(Icons.backup_outlined),
                    title: const Text('Export backup'),
                    subtitle: const Text('Database + images in one file'),
                    trailing: const Icon(
                      Icons.chevron_right_outlined,
                      color: AppTokens.taupeDim,
                    ),
                    onTap: _busy ? null : () => _export(),
                  ),
                  ListTile(
                    leading: _icon(Icons.restore_outlined),
                    title: const Text('Restore backup'),
                    subtitle: const Text('Replaces current data after checks'),
                    trailing: const Icon(
                      Icons.chevron_right_outlined,
                      color: AppTokens.taupeDim,
                    ),
                    onTap: _busy ? null : () => _restore(),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const _HelpCard(),
              const SizedBox(height: 10),
              Text(
                'Backups never leave this device unless you share them. '
                'Restore always keeps an automatic safety copy first.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTokens.taupeDim,
                ),
              ),
            ],
          ),
          if (_busy)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(strokeWidth: 2.5),
                        const SizedBox(height: 12),
                        Text(_busyLabel ?? 'Working…'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _icon(IconData icon) => Container(
    width: 38,
    height: 38,
    decoration: BoxDecoration(
      color: AppTokens.coalRaised,
      borderRadius: BorderRadius.circular(11),
      border: Border.all(color: AppTokens.line),
    ),
    child: Icon(icon, size: 19, color: AppTokens.moss),
  );

  String _mb(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Future<void> _editThreshold(int currentMilli) async {
    final controller = TextEditingController(text: formatQty(currentMilli));
    final result = await showDialog<int>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default low-stock alert'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Units (0 disables)'),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              try {
                Navigator.pop(context, parseQuantityToMilli(controller.text));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      e is FormatException ? e.message : 'Invalid quantity',
                    ),
                  ),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (result == null || !mounted) return;
    final repo = ref.read(settingsRepositoryProvider);
    final r = await repo.setDefaultThresholdMilli(result);
    if (!mounted) return;
    r.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (_) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Default saved.')));
        setState(() {});
      },
    );
  }

  Future<void> _runIntegrity() => _guard('Checking ledger…', () async {
    final repo = ref.read(productRepositoryProvider);
    final result = await repo.checkIntegrity();
    if (!mounted) return;
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
                              '• ${m.productName}: cached ${formatQty(m.cachedMilli)}, ledger ${formatQty(m.ledgerMilli)}',
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
    return;
  });

  Future<void> _export() => _guard('Creating backup…', () async {
    final repo = await ref.read(backupRepositoryProvider.future);
    final result = await repo.exportBackup();
    if (!mounted) return;
    await result.fold(
      (f) async => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (backup) async {
        if (backup.missingImages.isNotEmpty && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Backup created without ${backup.missingImages.length} missing photo(s).',
              ),
            ),
          );
        }
        final bytes = await File(backup.filePath).readAsBytes();
        if (!mounted) return;
        final shared = await FileShareService().shareBytes(
          bytes: bytes,
          filename: p.basename(backup.filePath),
          mimeType: 'application/zip',
          text: 'Stockroom backup',
        );
        if (!mounted) return;
        shared.fold(
          (f) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.message))),
          (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Backup ready to share.')),
            );
          },
        );
      },
    );
    return;
  });

  Future<void> _restore() async {
    // v13: static call, empty list means the user cancelled.
    final files = await FilePicker.pickFiles(type: FileType.any);
    final path = files.isEmpty ? null : files.first.path;
    if (path == null || !mounted) return; // cancelled — nothing happens

    StagedBackup? staged;
    await _guard('Checking backup…', () async {
      final repo = await ref.read(backupRepositoryProvider.future);
      final result = await repo.stageForRestore(path);
      if (!mounted) return;
      result.fold(
        (f) => ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(f.message))),
        (s) => staged = s,
      );
    });
    if (staged == null || !mounted) return;
    final stagedBackup = staged!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) =>
          _RestoreConfirmDialog(preview: stagedBackup.preview),
    );
    final repo = await ref.read(backupRepositoryProvider.future);
    if (confirmed != true) {
      await repo.disposeStaging(stagedBackup);
      return;
    }

    await _guard('Restoring…', () async {
      // Safety copy first, while the database is still open.
      final safety = await repo.safetyBackup();
      if (!mounted) return;
      final safetyPath = safety.fold((_) => null, (v) => v);
      if (safetyPath == null) {
        safety.fold(
          (f) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.message))),
          (_) {},
        );
        return; // never replace without a safety copy
      }
      try {
        await ref.read(appDatabaseProvider).close();
      } catch (_) {}
      final replaced = await repo.replaceFromStaging(stagedBackup);
      if (!mounted) return;
      final ok = replaced.fold((_) => false, (_) => true);
      if (!ok) {
        replaced.fold(
          (f) => ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(f.message))),
          (_) {},
        );
      }
      ref.invalidate(appDatabaseProvider);
      if (mounted) context.go('/splash');
    });
  }
}

/// How Stockroom keeps records safe (Phase 7 gate: backup reminder/help).
class _HelpCard extends StatelessWidget {
  const _HelpCard();

  @override
  Widget build(BuildContext context) {
    const points = [
      (
        'Stays on this phone',
        'Products, sales, photos and expenses are stored in a database on this device. The app works fully offline — airplane mode included.',
      ),
      (
        'Every change is recorded',
        'Stock levels come from a movement ledger: opening stock, receipts, sales, voids and adjustments. The integrity check above verifies the balance matches the ledger.',
      ),
      (
        'Sales are all-or-nothing',
        'A sale either completes fully or leaves nothing behind. A voided sale stays in history and restores the stock once.',
      ),
      (
        'If you lose this phone',
        'Only a backup file can bring your records back. Export one from this screen, share it to your email, drive or another phone, and restore it on the new device.',
      ),
    ];
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        leading: const Icon(Icons.help_outline, color: AppTokens.moss),
        title: const Text('How your records are kept'),
        children: [
          for (final (title, body) in points)
            ListTile(
              title: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              subtitle: Text(body),
            ),
        ],
      ),
    );
  }
}

class _RestoreConfirmDialog extends StatefulWidget {
  const _RestoreConfirmDialog({required this.preview});
  final BackupPreview preview;

  @override
  State<_RestoreConfirmDialog> createState() => _RestoreConfirmDialogState();
}

class _RestoreConfirmDialogState extends State<_RestoreConfirmDialog> {
  bool _understood = false;

  @override
  Widget build(BuildContext context) {
    final manifest = widget.preview.manifest;
    return AlertDialog(
      title: const Text('Replace current data?'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Backup from ${formatDateTimeLocal(manifest.createdAt)} '
              '(app ${manifest.appVersion}):',
            ),
            const SizedBox(height: 8),
            Text('• ${widget.preview.productCount} products'),
            Text('• ${widget.preview.saleCount} sales'),
            Text('• ${widget.preview.receiptCount} receipts'),
            Text('• ${widget.preview.expenseCount} expenses'),
            Text('• ${widget.preview.movementCount} ledger movements'),
            const SizedBox(height: 12),
            const Text(
              'This replaces everything on this device. An automatic safety copy is kept first.',
            ),
            CheckboxListTile(
              value: _understood,
              onChanged: (v) => setState(() => _understood = v ?? false),
              title: const Text('I understand, replace my data'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _understood ? () => Navigator.pop(context, true) : null,
          child: const Text('Restore'),
        ),
      ],
    );
  }
}
