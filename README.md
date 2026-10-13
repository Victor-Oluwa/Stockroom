# Stockroom

Offline inventory and sales management for small retailers. One business, one device, one local database. No account, no network, no backend.

Built with Flutter for Android. All records stay on the phone unless the owner explicitly exports a report or backup.

## What it does

**Inventory**

- Product catalogue with SKU, barcode, category, unit (piece, pack, kg, litre, metre), selling price, low-stock threshold, photo and notes.
- Barcode scanning with manual entry fallback. Scanning an unknown code offers to create the product with the code prefilled.
- Archive instead of delete, so history and reports stay valid.

**Stock ledger (the core of the app)**

- Every quantity change is an append-only movement: opening stock, purchase receipt, sale, sale void reversal, manual adjustment in/out.
- The cached quantity always equals the sum of movement deltas. A built-in integrity check verifies this.
- Receiving stock updates the moving weighted-average cost. Corrections are new movements, never edits.

**Sales and receipts**

- Cart with price override per sale, line-item discount, payment method (cash, transfer, card, other) and optional customer name.
- Checkout is one atomic database transaction with idempotency protection, so double taps and retries can never create a duplicate sale or leave partial rows.
- Full void with a reason restores stock once and keeps the original sale visible as VOIDED.
- On-device PDF receipts (compact 80 mm and A4) from immutable sale snapshots. Share or print via the system sheet.

**Reports and expenses**

- Date presets (today, yesterday, 7 days, this month, last month, custom) across summary, products, profit, expenses and stock valuation tabs.
- Estimated gross and operating profit from sale-time cost snapshots, minus recorded operating expenses. Voided sales are excluded.
- CSV and PDF export generated locally and shared through the system picker.

**Alerts and data safety**

- Low-stock and out-of-stock states on the dashboard and inventory list, plus optional on-device notifications (no push, no server).
- Full backup archive (database snapshot plus product images plus manifest) and safe restore with validation, confirmation and an automatic safety copy.

## How money and quantity work

- Money is stored as integer kobo (1 naira = 100 kobo). Quantities use fixed scale integers (3 decimal places). No floating point math on financial paths.
- Line total: gross = round_half_up(qty x unit price), net = gross - discount, COGS = round_half_up(qty x unit cost snapshot).
- Moving average on receipt: new_avg = round_half_up((old_qty x old_avg + received_qty x received_cost) / (old_qty + received_qty)). Zero stock resets the average to the receipt cost.
- Currency is Nigerian naira (NGN, ₦). Timestamps are stored consistently and shown in device local time.

## Tech stack

| Layer        | Choice                                                        |
| ------------ | ------------------------------------------------------------- |
| UI           | Flutter (Material 3, dark theme), flutter_bloc for screens    |
| DI           | flutter_riverpod for repositories and services                |
| Database     | SQLite via Drift (typed queries, streams, migrations)         |
| Scanning     | mobile_scanner, plus manual barcode entry                     |
| Images       | image_picker, compressed copies in app storage                |
| Receipts     | pdf plus printing for preview and print                       |
| Sharing      | share_plus, file_picker, path_provider                        |
| Notifications| flutter_local_notifications (local only, optional)            |
| Errors       | typed failures with fpdart result types                       |

## Project structure

```text
lib/
  app/            theme, router, tabs, dependency injection
  core/           database, money, quantity, dates, formatting,
                  files, errors, notifications, shared widgets
  features/
    onboarding/   first-launch business setup
    dashboard/    overview metrics, trend, alerts, quick actions
    inventory/    products, categories, detail, history
    stock_receiving/ receive flow, receipt history
    stock_movements/ ledger history, manual adjustments
    sales/        cart, checkout, history, receipts
    suppliers/    supplier records
    expenses/     operating expenses
    reports/      summary, products, profit, expenses, stock
    settings/     profile, backup/restore, integrity check
test/
  core/           money, quantity, database rules
  inventory/      product repository and ledger tests
  stock/          receiving tests
  sales/          checkout atomicity and idempotency tests
  reports/        report calculation tests
  settings/       backup and restore tests
docs/
  decisions/      per-phase build decisions (0001-0009)
  release-checklist.md
```

Key invariants live below the UI layer: widgets collect input and render state, domain and data layers own calculations and transaction boundaries. UI code never writes stock quantities directly.

## Getting started

Prerequisites: Flutter stable (developed with 3.44.4), Android SDK, a connected device or emulator.

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

Drift code generation is required after changing tables or queries. Regenerate with the `build_runner` command above before running.

## Verify

```sh
dart format lib test
flutter analyze
flutter test
flutter build apk --debug    # integration check including native plugins
flutter build apk --release  # release check before publishing
```

Manual release pass: follow `docs/release-checklist.md` on a physical Android device in airplane mode before any release. It covers offline setup, barcode scan, receive, sell, void, reports export, backup restore and narrow-screen layout.

## Documentation

- `AGENTS.md`: full product contract (requirements, business rules, data model, acceptance scenarios).
- `docs/decisions/`: why each phase was built the way it was.
- `docs/release-checklist.md`: manual device checks that automation cannot cover.

## Scope

Version 1 is intentionally offline and single-user: no cloud sync, accounts, multi-branch stock, online payments, credit tracking, payroll or tax filing. No placeholder buttons for those exist in the app. If a feature needs a server, it is out of scope.
