# 0001 — Phase 1 foundation decisions

- **App id:** `com.stockroom.app` (Android namespace + applicationId, iOS bundle).
  Changed now to avoid late migration. `MainActivity` moved to
  `com/stockroom/app`.
- **State stack:** PRD §9.1 as specified — `flutter_bloc` for presentation,
  `flutter_riverpod` for DI, `fpdart` Either for errors, `equatable` for state.
- **Dropped `bloc_test`:** `drift_dev ^2.35.1` requires `analyzer >=13`,
  incompatible with current `bloc_test` + pinned `flutter_test/matcher 0.12.19`.
  Use `flutter_test` + `mocktail` directly until upstream aligns.
- **DB scope:** full v1 schema at `schemaVersion 1` (all PRD §8.1 tables),
  avoiding per-phase migrations. UUID TEXT PKs, FK enforcement, unique
  normalised SKU/barcode, ledger indexes.
- **Money/qty:** int kobo + int milli(×1000), half-up integer division only,
  no `double`. One `calculations.dart` + `format.dart` shared by UI/exports.
- **Router:** `go_router` StatefulShell for 5 tabs.
