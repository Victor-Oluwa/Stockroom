import 'package:flutter/material.dart';

import '../../../../app/theme/tokens.dart';
import '../../domain/product.dart';

/// Status badge: colour + icon + text (never colour alone, PRD §5.3).
/// Dark-tuned: matte washes with contrasting text.
class StockBadge extends StatelessWidget {
  const StockBadge({super.key, required this.status});
  final StockStatus status;

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final Color border;
    late final IconData icon;
    late final String label;
    switch (status) {
      case StockStatus.outOfStock:
        bg = AppTokens.redSoft;
        fg = AppTokens.red;
        border = AppTokens.red.withValues(alpha: 0.45);
        icon = Icons.remove_circle_outline;
        label = 'Out of stock';
      case StockStatus.lowStock:
        bg = AppTokens.amberSoft;
        fg = AppTokens.amber;
        border = AppTokens.amber.withValues(alpha: 0.45);
        icon = Icons.warning_amber_outlined;
        label = 'Low stock';
      case StockStatus.inStock:
        bg = AppTokens.greenSoft;
        fg = AppTokens.green;
        border = AppTokens.green.withValues(alpha: 0.35);
        icon = Icons.check_circle_outline;
        label = 'In stock';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTokens.pillRadius),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: fg),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: fg,
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
