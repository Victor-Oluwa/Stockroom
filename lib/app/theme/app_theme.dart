import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'tokens.dart';

/// Stockroom visual identity — dark-only, matte black / grey / taupe.
///
/// No gradients anywhere. Status is always icon + text, never colour alone.
/// Custom offline fonts: Sora (display / numbers) + Inter (body), both
/// bundled in `assets/fonts/` so the app works fully offline.
abstract final class AppTheme {
  /// Restrained page transition: quick fade with a small rise. Applied to
  /// every route (Material pages pick this up from the theme).
  static const _fadeThrough = _FadeThroughBuilder();

  static const _scheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppTokens.moss,
    onPrimary: AppTokens.onMoss,
    primaryContainer: AppTokens.mossSoft,
    onPrimaryContainer: AppTokens.bone,
    secondary: AppTokens.taupe,
    onSecondary: AppTokens.ink,
    secondaryContainer: AppTokens.coalRaised,
    onSecondaryContainer: AppTokens.bone,
    tertiary: AppTokens.taupe,
    onTertiary: AppTokens.ink,
    surface: AppTokens.ink,
    onSurface: AppTokens.bone,
    surfaceContainer: AppTokens.coal,
    surfaceContainerHigh: AppTokens.coalRaised,
    surfaceContainerHighest: Color(0xFF26262C),
    onSurfaceVariant: AppTokens.taupe,
    outline: AppTokens.lineStrong,
    outlineVariant: AppTokens.line,
    error: AppTokens.red,
    onError: AppTokens.bone,
    errorContainer: AppTokens.redSoft,
    onErrorContainer: AppTokens.red,
    shadow: Colors.black,
    scrim: Colors.black,
    inverseSurface: AppTokens.bone,
    onInverseSurface: AppTokens.ink,
    inversePrimary: Color(0xFF5C543F),
    surfaceTint: Colors.transparent,
  );

  static TextTheme _text() {
    const display = AppTokens.displayFamily;
    const body = AppTokens.bodyFamily;
    const fallback = AppTokens.fallbackFamilies;
    TextStyle t(
      String family,
      double size,
      FontWeight weight,
      double height,
      double spacing, {
      bool tabular = false,
    }) => TextStyle(
      fontFamily: family,
      fontFamilyFallback: fallback,
      fontSize: size,
      fontWeight: weight,
      height: height,
      letterSpacing: spacing,
      color: AppTokens.bone,
      fontFeatures: tabular ? AppTokens.tabular : null,
    );
    return TextTheme(
      displaySmall: t(display, 30, FontWeight.w700, 1.2, -0.5, tabular: true),
      headlineSmall: t(
        display,
        24,
        FontWeight.w700,
        1.25,
        -0.25,
        tabular: true,
      ),
      titleLarge: t(display, 20, FontWeight.w700, 1.3, -0.25, tabular: true),
      titleMedium: t(display, 16, FontWeight.w600, 1.35, -0.1),
      titleSmall: t(body, 14, FontWeight.w600, 1.4, 0.1),
      bodyLarge: t(body, 16, FontWeight.w400, 1.5, 0),
      bodyMedium: t(body, 14, FontWeight.w400, 1.5, 0),
      bodySmall: t(body, 12.5, FontWeight.w400, 1.5, 0.1),
      labelLarge: t(body, 14, FontWeight.w600, 1.4, 0.25),
      labelMedium: t(body, 12, FontWeight.w600, 1.4, 0.4),
      labelSmall: t(body, 11, FontWeight.w600, 1.4, 0.5),
    );
  }

  /// The single app theme (dark-only by product decision).
  static ThemeData dark() {
    final text = _text();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _scheme,
      scaffoldBackgroundColor: AppTokens.ink,
      canvasColor: AppTokens.ink,
      dividerColor: AppTokens.line,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: _fadeThrough,
          TargetPlatform.iOS: _fadeThrough,
        },
      ),
      textTheme: text,
      primaryTextTheme: text,
      appBarTheme: AppBarTheme(
        backgroundColor: AppTokens.ink,
        foregroundColor: AppTokens.bone,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        titleTextStyle: text.titleLarge?.copyWith(
          fontFamily: AppTokens.displayFamily,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.25,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppTokens.coal,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.cardRadius),
          side: const BorderSide(color: AppTokens.line, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppTokens.line,
        thickness: 1,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: text.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
        subtitleTextStyle: text.bodySmall?.copyWith(color: AppTokens.taupe),
        leadingAndTrailingTextStyle: text.bodyMedium?.copyWith(
          fontFeatures: AppTokens.tabular,
        ),
        iconColor: AppTokens.taupe,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppTokens.coalRaised,
        selectedColor: AppTokens.mossSoft,
        checkmarkColor: AppTokens.moss,
        labelStyle: text.labelLarge?.copyWith(color: AppTokens.bone),
        secondaryLabelStyle: text.labelLarge?.copyWith(color: AppTokens.moss),
        side: const BorderSide(color: AppTokens.lineStrong),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.pillRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppTokens.coal,
        hintStyle: text.bodyMedium?.copyWith(color: AppTokens.taupeDim),
        labelStyle: text.bodySmall?.copyWith(color: AppTokens.taupe),
        floatingLabelStyle: text.bodySmall?.copyWith(color: AppTokens.moss),
        prefixIconColor: AppTokens.taupe,
        suffixIconColor: AppTokens.taupe,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          borderSide: const BorderSide(color: AppTokens.lineStrong),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          borderSide: const BorderSide(color: AppTokens.lineStrong),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          borderSide: const BorderSide(color: AppTokens.moss, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          borderSide: const BorderSide(color: AppTokens.red),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppTokens.moss,
          foregroundColor: AppTokens.onMoss,
          minimumSize: const Size(48, 52),
          textStyle: const TextStyle(
            fontFamily: AppTokens.bodyFamily,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppTokens.bone,
          minimumSize: const Size(48, 52),
          side: const BorderSide(color: AppTokens.lineStrong),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppTokens.moss,
          textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppTokens.moss,
        foregroundColor: AppTokens.onMoss,
        elevation: 0,
        shape: StadiumBorder(),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppTokens.coal,
        indicatorColor: AppTokens.mossSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontFamily: AppTokens.bodyFamily,
            fontSize: 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppTokens.moss : AppTokens.taupe,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppTokens.moss : AppTokens.taupe,
          );
        }),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: AppTokens.coal,
        selectedIconTheme: const IconThemeData(color: AppTokens.moss),
        unselectedIconTheme: const IconThemeData(color: AppTokens.taupe),
        selectedLabelTextStyle: text.labelMedium?.copyWith(
          color: AppTokens.moss,
        ),
        unselectedLabelTextStyle: text.labelMedium?.copyWith(
          color: AppTokens.taupe,
        ),
        indicatorColor: AppTokens.mossSoft,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: AppTokens.moss,
        unselectedLabelColor: AppTokens.taupe,
        indicatorColor: AppTokens.moss,
        dividerColor: AppTokens.line,
        labelStyle: text.labelLarge,
        unselectedLabelStyle: text.labelLarge,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppTokens.coal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppTokens.line),
        ),
        titleTextStyle: text.titleLarge,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppTokens.bone),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppTokens.coal,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          side: BorderSide(color: AppTokens.line),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppTokens.coalRaised,
        contentTextStyle: text.bodyMedium?.copyWith(color: AppTokens.bone),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          side: const BorderSide(color: AppTokens.lineStrong),
        ),
        behavior: SnackBarBehavior.floating,
        insetPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppTokens.mossSoft
                : AppTokens.coalRaised,
          ),
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected)
                ? AppTokens.moss
                : AppTokens.taupe,
          ),
          side: const WidgetStatePropertyAll(
            BorderSide(color: AppTokens.lineStrong),
          ),
          shape: const WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(AppTokens.controlRadius),
              ),
            ),
          ),
          visualDensity: VisualDensity.compact,
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppTokens.coalRaised,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTokens.lineStrong),
        ),
        textStyle: text.labelSmall?.copyWith(color: AppTokens.bone),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: AppTokens.coalRaised,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.controlRadius),
          side: const BorderSide(color: AppTokens.line),
        ),
        textStyle: text.bodyMedium,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppTokens.moss
              : AppTokens.taupe,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppTokens.mossSoft
              : AppTokens.coalRaised,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppTokens.moss,
        linearTrackColor: AppTokens.coalRaised,
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: text.labelLarge,
        dataTextStyle: text.bodyMedium?.copyWith(
          fontFeatures: AppTokens.tabular,
        ),
      ),
    );
  }

  /// Backwards-compat alias (all builds are dark-only now).
  static ThemeData light() => dark();
}

/// Fade + slight-rise transition. Finite, quiet, no bounce — the exit
/// runs on the same animation curve so interrupted gestures stay smooth.
class _FadeThroughBuilder extends PageTransitionsBuilder {
  const _FadeThroughBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    if (MediaQuery.of(context).disableAnimations) return child;
    final curved = CurvedAnimation(
      parent: animation,
      curve: AppTokens.easeEmph,
      reverseCurve: AppTokens.easeOut,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.015),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}
