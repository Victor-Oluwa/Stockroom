import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';

/// Matte skeleton block. The pulse is a finite TweenAnimationBuilder
/// (opacity 0.45→1) so `pumpAndSettle` can never hang on it.
class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.width = double.infinity,
    this.height = 14,
    this.radius = 8,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return _block(1);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.45, end: 1),
      duration: AppTokens.durSlow,
      curve: AppTokens.easeEmph,
      builder: (context, v, _) => _block(v),
    );
  }

  Widget _block(double opacity) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTokens.coalRaised.withValues(alpha: 0.4 + 0.6 * opacity),
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppTokens.line),
      ),
    );
  }
}

/// Skeleton for a product-style list row: image square + two text bars.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.count = 6, this.height = 76});
  final int count;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (_, _) => Container(
        height: height,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTokens.coal,
          borderRadius: BorderRadius.circular(AppTokens.cardRadius),
          border: Border.all(color: AppTokens.line),
        ),
        child: Row(
          children: [
            AppSkeleton(
              width: 52,
              height: 52,
              radius: AppTokens.cardRadius * 0.75,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppSkeleton(width: 160, height: 14),
                  const SizedBox(height: 8),
                  AppSkeleton(width: 90, height: 11),
                ],
              ),
            ),
            const SizedBox(width: 12),
            AppSkeleton(width: 56, height: 16),
          ],
        ),
      ),
    );
  }
}
