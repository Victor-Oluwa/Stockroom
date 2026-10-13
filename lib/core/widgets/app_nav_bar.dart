import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/tokens.dart';

/// Stockroom's floating dock navigation (phone layout).
///
/// A rounded coal bar inset from the screen edges with a matte moss pill
/// that slides between destinations. Icons switch outlined→filled when
/// active; labels stay visible so destinations are never a mystery.
/// Taps give light haptic feedback. No gradients anywhere.
class AppNavBar extends StatelessWidget {
  const AppNavBar({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.destinations,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<AppNavBarDestination> destinations;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: AppTokens.coal,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTokens.line),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final slot = constraints.maxWidth / destinations.length;
              return Stack(
                children: [
                  // Sliding moss pill behind the active icon.
                  AnimatedPositioned(
                    duration: AppTokens.durBase,
                    curve: AppTokens.easeEmph,
                    left: slot * selectedIndex + (slot - 56) / 2,
                    top: 9,
                    child: Container(
                      width: 56,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppTokens.mossSoft,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppTokens.moss.withValues(alpha: 0.35),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < destinations.length; i++)
                        Expanded(
                          child: _DockItem(
                            destination: destinations[i],
                            selected: i == selectedIndex,
                            onTap: () {
                              HapticFeedback.selectionClick();
                              onSelected(i);
                            },
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final AppNavBarDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final icon = AnimatedSwitcher(
      duration: AppTokens.durFast,
      child: Icon(
        selected ? destination.selectedIcon : destination.icon,
        key: ValueKey(selected),
        size: 22,
        color: selected ? AppTokens.moss : AppTokens.taupe,
      ),
    );
    return Semantics(
      button: true,
      selected: selected,
      label: destination.label,
      child: InkWell(
        onTap: onTap,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 9),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 32, child: Center(child: icon)),
              const SizedBox(height: 4),
              Text(
                destination.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: AppTokens.bodyFamily,
                  fontFamilyFallback: AppTokens.fallbackFamilies,
                  fontSize: 10.5,
                  height: 1.0,
                  letterSpacing: 0.2,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? AppTokens.bone : AppTokens.taupeDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppNavBarDestination {
  const AppNavBarDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}
