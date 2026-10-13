# 0006 — Phase 6 backup, restore & hardening decisions

- **Snapshot via `VACUUM INTO`:** never copy the live SQLite file (WAL risk);
  `AppDatabase.vacuumInto()` produces a consistent snapshot with open
  connections. Added `databaseFile()`, `checkIntegrity()` helpers.
- **Archive:** `.stockroom.zip` (ZIP) with `manifest.json`
  (format/formatVersion/appVersion/schemaVersion/createdAt/dbFile/images/
  missingImages), `database/stockroom.sqlite`, `images/<rel>`. Missing photos
  don't abort export — they're listed and warned about.
- **Restore safety order:** stage-copy → validate everything → preview dialog
  with explicit checkbox → safety `VACUUM INTO` (abort if it fails) → close DB
  → delete live db + `-wal/-shm/-journal` siblings → copy staged db → restore
  images → invalidate providers → `/splash`. Failures never touch live data
  until the replace step, and the safety copy is kept.
- **Staging mirrors docs layout** (`staging/<rel>`) after fixing a double
  `product_images/` nesting bug caught by the roundtrip test.
- **Traversal/size guards:** absolute/`..` entries, >20k files, >1GiB total,
  >500MiB single file all rejected before extraction completes.
- **Schema:** stays v1; newer-schema backups are refused with an update-the-app
  message; the reopen-harness test documents the v2 migration path.
- **Flake fix:** the Phase 3 gate asserted exact DESC movement order, but
  same-millisecond timestamps have no defined order — now asserts the
  multiset + type set. (Explains the two earlier full-suite-only flakes.)
- **Build fix:** `flutter_local_notifications` needs core-library desugaring
  (`desugar_jdk_libs:2.1.5`); debug APK verified after.
- **New products** default their low-stock threshold from Settings
  (`app_settings`), not a hardcoded 5.
