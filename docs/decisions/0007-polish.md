# 0007 — Phase 7 polish & release verification decisions

- **Audit gaps closed:** global audit sale rows now deep-link to sale detail
  (stale "later phase" snackbar removed); product history rows link to sale /
  receipt detail, with non-navigating rows for entries the row fully
  describes (adjustments/opening) instead of dead links.
- **Tablet rail:** shell switches to `NavigationRail` at ≥700dp width;
  phone layout unchanged. No forced phone UI on tablets (PRD §5.1).
- **Narrow-screen fix:** receipt layout toggle moved out of the app bar
  (title + toggle + 2 actions overflowed ≤360dp) into the body.
- **Backup gate:** reminder card + "How your records are kept" help in
  Settings; manual device pass captured in `docs/release-checklist.md`
  (cannot run here — no device attached).
- **Release verified:** `app-release.apk` (83.7MB) builds with R8; debug APK
  also rebuilt green after all Phase 7 changes... (debug was Phase 6; this
  phase: analyze + full tests + release build).
- **Not done here:** physical-device airplane-mode pass, camera/scan field
  test, notification tap behavior on device — all listed in the checklist.
