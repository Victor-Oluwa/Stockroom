# 0009 — Dark-only UI redesign decisions (black / grey / taupe)

- **Direction override:** user-directed departure from PRD §5.3
  (warm off-white + deep green). New identity is dark-only, matte
  black/grey/taupe with a taupe-gold accent (`#C2B280`). No gradients
  anywhere. Status stays icon + text, never colour alone.
- **Dark-only:** `StockroomApp` forces `ThemeMode.dark`; `AppTheme.light()`
  is kept only as an alias to `dark()` so call sites don't fork.
  Single `ColorScheme` in `lib/app/theme/app_theme.dart`, tokens in
  `lib/app/theme/tokens.dart` (`ink #101012`, `coal #17171A`,
  `bone #EDE8DF`, `taupe #A89F91`, `moss #C2B280`).
- **Offline fonts:** `Sora-Variable.ttf` (display/numbers) +
  `Inter-Variable.ttf` (body) bundled in `assets/fonts/` and declared in
  `pubspec.yaml`. DejaVu TTFs remain PDF-only. UI sets
  `fontFamilyFallback: [Inter, Sora]` so `₦ U+20A6` falls back cleanly
  if a display cut lacks the glyph. Tabular figures forced for all
  money/quantity strings.
- **Component language:** new `lib/core/widgets/app_ui.dart`
  (`AppCard`, `AppRowCard`, `SectionHeader` eyebrows, `SearchField`,
  `ReportRow`, `MetricTile`). One card border (`white/15%`, 16dp),
  one search shape (12dp), one badge language (wash + border + icon).
  `AppLoading/Empty/Error` restyled to dark cards; error paths never
  show SQL.
- **Scope:** core 5 first — Overview, Inventory list/detail, Sales
  builder/history, Reports, Settings/More + splash + nav. Secondary
  screens (receive, adjust, expenses, suppliers, movements, onboarding)
  inherit tokens automatically; full layout pass is follow-up work.
- **Notable fixes inside the redesign:** dashboard fake
  `RefreshIndicator(onRefresh: async {})` removed; profit tile handles
  errors; inventory category picker moved to a bottom sheet with a
  working All/clear sentinel + debounced search + sort selection state;
  sale cart 3-across Qty/Price/Disc cramped row split into 2-col +
  full-width discount; sales history gets totals header + debounced
  search + empty-state CTA; reports `_kv` debug rows replaced by
  `ReportRow` cards with error branches; settings busy state is now an
  overlay instead of replacing the whole list.
- **Verify:** `dart format lib`, `flutter analyze` (clean),
  `flutter test` (61 passed), `flutter build apk --debug` (green).
