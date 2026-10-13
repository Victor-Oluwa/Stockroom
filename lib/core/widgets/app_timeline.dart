import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../app/theme/tokens.dart';
import '../database/app_database.dart' as db;
import '../formatting/format.dart';
import 'app_states.dart';

/// One movement entry for timeline layouts: day spine, signed delta dot,
/// friendly type, reason and reference. Dark-tuned, no gradients.
class MovementTimelineTile extends StatelessWidget {
  const MovementTimelineTile({
    super.key,
    required this.entry,
    this.onTap,
    this.linkProduct = false,
  });

  /// [entry] is (productName, movement). Keeping a record keeps call sites
  /// identical to the existing ledger rows.
  final (String, db.StockMovement) entry;
  final VoidCallback? onTap;

  /// When true, adjustment/opening rows also navigate to their product.
  /// Product-scoped lists leave this off — they are already there.
  final bool linkProduct;

  static String friendlyType(String raw) {
    return switch (raw) {
      'OPENING_STOCK' => 'Opening stock',
      'PURCHASE_RECEIPT' => 'Received',
      'SALE' => 'Sale',
      'SALE_VOID_REVERSAL' => 'Void reversal',
      'ADJUSTMENT_IN' => 'Adjustment in',
      'ADJUSTMENT_OUT' => 'Adjustment out',
      _ => raw.toLowerCase().replaceAll('_', ' '),
    };
  }

  static String? routeFor(db.StockMovement m, {bool linkProduct = false}) {
    return switch (m.referenceType) {
      'stock_receipt' => '/receipts/${m.referenceId}',
      'sale' => '/sales/${m.referenceId}',
      // Adjustments and opening entries are fully described by this row
      // (type, delta, date, reason) — they only navigate when the caller
      // explicitly links to the product.
      'adjustment' || 'opening' when linkProduct => '/inventory/${m.productId}',
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (productName, m) = entry;
    final up = m.quantityDeltaMilli >= 0;
    final accent = up ? AppTokens.green : AppTokens.red;
    final accentSoft = up ? AppTokens.greenSoft : AppTokens.redSoft;
    final route = routeFor(m, linkProduct: linkProduct);
    final target = onTap ?? (route == null ? null : () => context.push(route));

    final reason =
        m.reason ??
        switch (m.referenceType) {
          'stock_receipt' => 'Stock receipt',
          'sale' => 'Sale',
          'opening' => 'Opening stock',
          _ => null,
        };

    return InkWell(
      onTap: target,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Delta chip: icon + signed qty, colour never alone (sign).
            Container(
              width: 46,
              height: 40,
              decoration: BoxDecoration(
                color: accentSoft,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: accent.withValues(alpha: 0.35)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(up ? Icons.add : Icons.remove, size: 13, color: accent),
                  const SizedBox(height: 1),
                  Text(
                    '${up ? '+' : '−'}${formatQty(m.quantityDeltaMilli.abs())}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 9.5,
                      height: 1.0,
                      fontWeight: FontWeight.w700,
                      color: accent,
                      fontFeatures: AppTokens.tabular,
                      fontFamily: AppTokens.bodyFamily,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friendlyType(m.movementType),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    [
                      if (productName.isNotEmpty) productName,
                      formatDateTimeLocal(m.occurredAt, pattern: 'HH:mm'),
                      ?reason,
                      if (m.note != null && m.note!.isNotEmpty) m.note!,
                    ].join(' · '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTokens.taupe,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (target != null)
              Icon(
                Icons.chevron_right_outlined,
                size: 18,
                color: AppTokens.taupeDim,
              ),
          ],
        ),
      ),
    );
  }
}

/// Day-grouped timeline list. Each header pins the local day so the
/// ledger reads like a logbook (PRD §6.6: up/down, how much, when, why).
class MovementTimeline extends StatelessWidget {
  const MovementTimeline({
    super.key,
    required this.entries,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.emptyMessage,
    this.linkProduct = false,
    this.padding = const EdgeInsets.only(bottom: 24),
  });

  final List<(String, db.StockMovement)> entries;
  final IconData emptyIcon;
  final String emptyTitle;
  final String emptyMessage;

  /// Adjustment/opening rows navigate to their product when true.
  final bool linkProduct;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) {
      return AppEmpty(
        icon: emptyIcon,
        title: emptyTitle,
        message: emptyMessage,
      );
    }
    return ListView.builder(
      padding: padding,
      itemCount: entries.length,
      itemBuilder: (context, i) {
        final entry = entries[i];
        final showHeader = i == 0 || !_sameDay(entries[i - 1].$2, entry.$2);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showHeader) _DayHeader(utc: entry.$2.occurredAt),
            MovementTimelineTile(entry: entry, linkProduct: linkProduct),
          ],
        );
      },
    );
  }

  bool _sameDay(db.StockMovement a, db.StockMovement b) {
    final x = a.occurredAt.toLocal();
    final y = b.occurredAt.toLocal();
    return x.year == y.year && x.month == y.month && x.day == y.day;
  }
}

class _DayHeader extends StatelessWidget {
  const _DayHeader({required this.utc});
  final DateTime utc;

  @override
  Widget build(BuildContext context) {
    final local = utc.toLocal();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final label = day == today
        ? 'Today'
        : day == today.subtract(const Duration(days: 1))
        ? 'Yesterday'
        : DateFormat('EEEE, dd MMM yyyy').format(local);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 2),
      child: Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppTokens.taupe,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}
