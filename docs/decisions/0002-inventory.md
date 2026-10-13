# 0002 — Phase 2 product catalogue decisions

- **Drift row vs domain names:** generated rows are `Product`/`ProductCategory`;
  domain entities keep those names, repositories import the database as `db`
  prefix (`db.Product`) to avoid ambiguity.
- **List filtering in Dart:** category/archived in SQL, search/stock/sort in one
  shared `_applyFilter` used by both `watchProducts` and `listProducts`, so the
  dashboard, list and future exports cannot drift apart. Fine for small catalogs;
  revisit with SQL-side filtering if catalogs grow large.
- **Create idempotency:** caller-supplied `productId` acts as operation key —
  retry with the same id returns the existing row; opening movement key is
  `opening:<productId>` (unique), so no duplicate `+qty`.
- **Archive with stock:** blocked without `confirmedWithStock`; UI shows an
  explicit warning dialog and stock stays recorded. Full sell-or-adjust choice
  arrives with Phase 3/4 sales + adjustments.
- **Images:** `image_picker` pick → `image` downscale (≤1200px, JPEG q85) →
  `product_images/<uuid>.jpg` under app docs; DB keeps relative path only.
  Cleanup is best-effort and never fails the save.
- **Categories:** unique on normalised name overall (stricter than active-only);
  creating a duplicate archived name revives it instead.
