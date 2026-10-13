# 0004 — Phase 4 checkout & receipts decisions

- **Duplicate cart rows:** the cart merges repeats only implicitly — the repo
  keeps separate sale lines (each with its own price/discount snapshot, which
  is the auditable choice) but writes ONE aggregated `SALE` movement per
  product. Pre-submit validation rejects nothing; in-txn live-stock recheck is
  authoritative (stale UI can never drive stock negative).
- **Idempotency:** one op key per cart session (`SaleCartCubit.newSale()`
  rotates it). Double-tap is stopped by the disabled button AND collapses
  server-side to the same sale row.
- **Void repricing** uses the PRD weighted formula with the original
  `unitCostSnapshotKobo` (not today's average); zero on-hand falls back to
  the snapshot. Double void is blocked by the status check inside the txn.
- **Receipt fonts:** built-in Helvetica lacks ₦ (U+20A6), so DejaVu Sans
  Regular/Bold are bundled under `assets/fonts/` (license copied alongside)
  and applied via `pw.ThemeData.withFont`. No runtime font download — offline
  safe. `printing`'s `PdfGoogleFonts` was deliberately NOT used (network).
- **Scanner:** `mobile_scanner` with retail formats only, `noDuplicates`
  speed, single-result guard (`_handled` + `controller.stop()`), torch/flip
  controls, permission-denied explanation, and an always-visible manual field.
  Camera permission is optional (`required=false`); `AndroidManifest` declares
  it for Play.
- **Share/print:** `share_plus` v13 API (`SharePlus.instance.share`);
  print failures degrade to a message while the PDF file share still works.
- **Gate math:** void test initially failed on a wrong hand-computed
  expectation (1080746); the code's 1107143 was verified term-by-term and the
  test corrected. One transient full-suite flake (Phase 3 gate, unreproduced
  across 3 reruns) was observed — likely worker-load stream timing.
