import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import 'app_motion.dart';

/// Shared dark UI primitives: one card language, one section language,
/// one search language. Screens compose these instead of raw Cards.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding, this.onTap});
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: padding ?? const EdgeInsets.all(AppTokens.s16),
      child: child,
    );
    if (onTap == null) return Card(child: body);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        onTap: onTap,
        child: body,
      ),
    );
  }
}

/// Card that owns a separated row list (single border, hairline dividers).
class AppRowCard extends StatelessWidget {
  const AppRowCard({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    assert(children.isNotEmpty);
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            children[i],
            if (i != children.length - 1) const Divider(height: 1, indent: 56),
          ],
        ],
      ),
    );
  }
}

/// Eyebrow + optional action. Encodes hierarchy, not decoration.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.eyebrow,
    this.actionLabel,
    this.onAction,
  });
  final String eyebrow;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          eyebrow.toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: AppTokens.taupe,
            letterSpacing: 1.2,
          ),
        ),
        const Spacer(),
        if (actionLabel != null && onAction != null)
          TextButton(onPressed: onAction, child: Text(actionLabel!)),
      ],
    );
  }
}

/// Consistent search field with clear affordance.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.onClear,
  });
  final TextEditingController controller;
  final String hint;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: const Icon(Icons.search, size: 20),
        suffixIcon: controller.text.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.clear, size: 18),
                tooltip: 'Clear search',
                onPressed: onClear,
              ),
      ),
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
    );
  }
}

/// Label/value ledger row with tabular figures. Used by detail + reports.
class ReportRow extends StatelessWidget {
  const ReportRow({
    super.key,
    required this.label,
    required this.value,
    this.strong = false,
    this.valueColor,
  });
  final String label;
  final String value;
  final bool strong;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTokens.taupe,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: strong ? FontWeight.w800 : FontWeight.w600,
              fontFeatures: AppTokens.tabular,
              color: valueColor ?? AppTokens.bone,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ],
      ),
    );
  }
}

/// Metric tile for the dashboard grid. When [rawKobo] is provided the
/// figure counts up from zero on first appearance (reduced-motion safe).
class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.onTap,
    this.alert = false,
    this.rawKobo,
  });
  final String label;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;
  final bool alert;

  /// Amount in kobo; replaces [value] with the animated figure.
  final int? rawKobo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = alert ? AppTokens.amber : AppTokens.moss;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTokens.cardRadius),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.s12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, size: 14, color: accent),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      label.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppTokens.taupe,
                        letterSpacing: 0.9,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (rawKobo != null)
                CountUpKobo(
                  kobo: rawKobo!,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                )
              else
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontFeatures: AppTokens.tabular,
                    color: accent,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
