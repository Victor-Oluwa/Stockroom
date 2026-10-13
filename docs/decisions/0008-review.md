# 0008 — Independent review fixes (post-Phase 7)

Full re-verification (`flutter analyze` clean, 61/61 tests green) plus a
line-by-line risk audit found and fixed:

1. **Oversell via duplicate sale lines (correctness bug):** stock was
   rechecked per line, so lines of 4+4 against stock 5 each passed and drove
   stock to −3. Quantities are now aggregated per product before the live
   check; regression test added. The cart UI already merges repeats, so only
   crafted input could trigger it — the repo is the last line of defense.
2. **Void reversals lacked reason/note** (PRD §6.6 requires it): now
   `reason='Sale voided'`, `note=<void reason>`; asserted in tests.
3. **Splash leaked raw errors** (`Startup failed: $e`): now a friendly
   message (PRD §6.15).
4. **Sales history end-bound was inclusive** while reports/expenses are
   exclusive: unified to exclusive midnight.
5. **Stale dashboard void count:** all-time voided rows were fed into the
   today summary; now filtered to today.
6. **Windows image paths:** `saveProductImage` stored `p.join` (backslash)
   paths in the DB, breaking cross-platform restore; now forward slashes,
   and `fileFor` rejects absolute/`..` paths instead of string-stripping.
7. **Safety prune order:** old safety copies were deleted before the new
   vacuum succeeded; now pruned after.

Deliberately left as documented limitations: dashboard is today-only (ranges
live in Reports), supplier spend is all-time, large-list pagination, release
signing with debug keys, and the physical-device pass in
`docs/release-checklist.md`.

Also noted: the repo has no commits yet — make an initial commit before
release work so these fixes are traceable.
