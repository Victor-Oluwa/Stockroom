# 0005 — Phase 5 dashboard, expenses & reports decisions

- **One calculation module:** `reports/domain/calculations.dart` (pure, integer
  only) is the sole money logic for dashboard, report tabs, PDF and CSV.
  Repositories only fetch rows. Tested once with shared fixtures; screen, PDF
  and CSV assert the same numbers.
- **Dates:** UI ranges are local start-inclusive → exclusive-end-midnight.
  Expense days are stored as local-midnight→UTC instants; sale/receipt
  instants are filtered by local-day bounds converted the same way. Stable
  while the device offset is stable (Nigeria has no DST). Documented in code.
- **Receipt spend ≠ expense:** receiving only reprices averages; profit
  subtracts COGS snapshots + recorded expenses. Expense UI copy says so.
- **costsComplete:** plumbing exists and the UI renders the incomplete
  warning, but v1 always has costs (opening/receipt/adjustment-IN all
  require them), so it stays true. Profit is still labelled "Estimated".
- **Alerts without state:** transitions are detected from old→new qty inside
  each write txn and returned in results; notify-on-crossing gives no-repeat
  + re-arm-after-replenish with no extra table. Receipts only increase stock
  so they emit nothing (no dead field added).
- **Notifications:** `flutter_local_notifications` v22 (all-named API),
  channel `stock_alerts`, rationale dialog before OS request, setting persisted
  in `app_settings`; denied/unavailable → silent no-op, in-app list rules.
- **CSV:** hand-rolled 20-line encoder (tested escaping) instead of a new
  dependency, per PRD allowance.
- **No chart dep:** 7-day trend is a ~60-line CustomPaint-free bar row.
