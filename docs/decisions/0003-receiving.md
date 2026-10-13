# 0003 — Phase 3 stock movements & receiving decisions

- **Receipt merge:** duplicate product entries merge defensively in the repo
  (summed qty, qty-weighted unit cost via half-up) AND are prevented in the UI
  picker. One receipt line + one `PURCHASE_RECEIPT` movement per product.
  Merged unit cost uses `roundHalfUp(Σqty×cost / Σqty)`; merged line cost is
  recomputed from the merged cost (may differ by 1 kobo from summing unmerged
  lines — the merged row is canonical).
- **Sequences in-transaction:** `SR-NNNN` / `ADJ-NNNN` allocated from
  `app_settings` inside the same transaction as the inserts, so concurrent
  commits cannot reuse a number. Missing settings row is recreated defensively.
- **Idempotency:** receipts and adjustments carry caller `operationKey`
  (per-form UUID); retries return the posted record. Per-movement keys are
  `<opKey>:<productId>`.
- **Archived products** cannot receive stock or adjustments (validated in-txn);
  archived suppliers remain selectable in history via `supplierNameSnapshot`.
- **Adjustment OUT** snapshots the current average cost as its unit cost;
  IN reprices the average with the same weighted formula as receipts.
- **Audit tap-through:** receipt/adjustment/opening rows navigate to their
  source; sale-linked rows show an info message until Phase 4 sale detail.
- **Gate note:** `50 → sell 3 → receive 10 → 57` is exercised with an
  `ADJUSTMENT_OUT -3` standing in for the sale movement (sale checkout is
  Phase 4); ledger sum, avg-cost math and rollback semantics are identical.
