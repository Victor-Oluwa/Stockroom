import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

/// Standard loading state.
class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message});
  final String? message;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTokens.coal,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTokens.line),
            ),
            child: const CircularProgressIndicator(strokeWidth: 2.5),
          ),
          if (message != null) ...[
            const SizedBox(height: 12),
            Text(
              message!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTokens.taupe,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Standard empty state with direct action (PRD §5.4, §6.2).
class AppEmpty extends StatelessWidget {
  const AppEmpty({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTokens.coal,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTokens.line),
              ),
              child: Icon(icon, size: 32, color: AppTokens.moss),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTokens.taupe,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Standard inline error with retry. Never shows raw SQL/stack traces.
class AppError extends StatelessWidget {
  const AppError({super.key, required this.message, this.onRetry});
  final String message;
  final VoidCallback? onRetry;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppTokens.redSoft,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTokens.red.withValues(alpha: 0.4)),
              ),
              child: const Icon(
                Icons.error_outline,
                size: 32,
                color: AppTokens.red,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppTokens.bone,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: onRetry,
                child: const Text('Try again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
