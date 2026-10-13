import 'package:flutter/material.dart';

/// Stockroom dark design tokens (black / grey / taupe, matte, no gradients).
///
/// Single source of truth for colour, spacing, shape and motion. Screens
/// must read from here (via Theme) instead of hardcoding hex values.
abstract final class AppTokens {
  // ── Motion (restrained: quick enter, quicker exit) ────────
  static const durFast = Duration(milliseconds: 150);
  static const durBase = Duration(milliseconds: 250);
  static const durSlow = Duration(milliseconds: 400);
  static const easeOut = Curves.easeOutCubic;
  static const easeEmph = Curves.easeOutQuint;

  // ── Surfaces ──────────────────────────────────────────────
  static const ink = Color(0xFF101012); // scaffold
  static const coal = Color(0xFF17171A); // cards, sheets, nav
  static const coalRaised = Color(0xFF1F1F24); // pressed / nested
  static const line = Color(0x26FFFFFF); // white @ 15% hairlines
  static const lineStrong = Color(0x40FFFFFF); // white @ 25%

  // ── Text ──────────────────────────────────────────────────
  static const bone = Color(0xFFEDE8DF); // primary text / numbers
  static const taupe = Color(0xFFA89F91); // secondary text, hints
  static const taupeDim = Color(0xFF7E766B); // disabled / captions

  // ── Accent (taupe-gold, matte) ────────────────────────────
  static const moss = Color(0xFFC2B280); // primary actions, selected
  static const onMoss = Color(0xFF16130C); // text on moss
  static const mossSoft = Color(0x26C2B280); // moss @ 15% wash

  // ── Status (always paired with icon + label) ──────────────
  static const amber = Color(0xFFE0A63C);
  static const onAmber = Color(0xFF221704);
  static const amberSoft = Color(0x26E0A63C);
  static const red = Color(0xFFE5484D);
  static const onRed = Color(0xFF2A0B0C);
  static const redSoft = Color(0x2BE5484D);
  static const green = Color(0xFF7FB685);
  static const onGreen = Color(0xFF0C1A0E);
  static const greenSoft = Color(0x247FB685);

  // ── Spacing ───────────────────────────────────────────────
  static const s4 = 4.0;
  static const s8 = 8.0;
  static const s12 = 12.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;

  // ── Shape ─────────────────────────────────────────────────
  static const cardRadius = 16.0;
  static const controlRadius = 12.0;
  static const pillRadius = 999.0;

  /// Tabular figures for every money / quantity string.
  static const tabular = <FontFeature>[FontFeature.tabularFigures()];

  static const displayFamily = 'Sora';
  static const bodyFamily = 'Inter';
  static const fallbackFamilies = <String>['Inter', 'Sora'];
}
