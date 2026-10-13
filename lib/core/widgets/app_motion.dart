import 'package:flutter/material.dart';

import '../../app/theme/tokens.dart';
import '../formatting/format.dart';

/// Restrained entrance: fade + small rise, delayed per [index] so sibling
/// sections cascade. Finite and skip-honouring: no animation when the
/// system asks for reduced motion, so `pumpAndSettle` always settles.
class StaggerIn extends StatefulWidget {
  const StaggerIn({super.key, required this.child, this.index = 0});
  final Widget child;
  final int index;

  @override
  State<StaggerIn> createState() => _StaggerInState();
}

class _StaggerInState extends State<StaggerIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a;
  late final Animation<double> _y;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: AppTokens.durSlow);
    final t = CurvedAnimation(parent: _c, curve: AppTokens.easeEmph);
    // Late children start already partway through: total stagger <= 300ms.
    final start = (widget.index.clamp(0, 8) * 0.06).clamp(0.0, 0.72);
    _a = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _c, curve: Interval(start, 1.0)));
    _y = Tween(begin: 14.0, end: 0.0).animate(t);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      _c.value = 1;
      return widget.child;
    }
    if (!_c.isCompleted && !_c.isAnimating) {
      _c.forward();
    }
    return AnimatedBuilder(
      animation: _c,
      builder: (context, child) => Opacity(
        opacity: _a.value,
        child: Transform.translate(offset: Offset(0, _y.value), child: child),
      ),
      child: widget.child,
    );
  }
}

/// Money figure that counts up from zero on first appearance. Uses the
/// shared kobo formatter so the final value is identical everywhere.
/// Skipped entirely under reduced motion.
class CountUpKobo extends StatefulWidget {
  const CountUpKobo({super.key, required this.kobo, this.style});
  final int kobo;
  final TextStyle? style;

  @override
  State<CountUpKobo> createState() => _CountUpKoboState();
}

class _CountUpKoboState extends State<CountUpKobo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: AppTokens.durSlow);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).disableAnimations) {
      return _plain(context);
    }
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: widget.kobo.toDouble()),
      duration: AppTokens.durSlow,
      curve: AppTokens.easeEmph,
      builder: (context, v, _) {
        final style = (widget.style ?? DefaultTextStyle.of(context).style)
            .copyWith(fontFeatures: AppTokens.tabular);
        return Text(formatNaira(v.round()), style: style);
      },
    );
  }

  Widget _plain(BuildContext context) {
    final style = (widget.style ?? DefaultTextStyle.of(context).style).copyWith(
      fontFeatures: AppTokens.tabular,
    );
    return Text(formatNaira(widget.kobo), style: style);
  }
}
