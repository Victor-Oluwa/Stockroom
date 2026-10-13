# Release checklist (manual, physical Android device)

Automated gates (`flutter analyze`, `flutter test`, APK builds) run on the
dev machine. The steps below need a real phone and cannot be automated here.

## Setup

- [ ] Install the release APK fresh (uninstall first to test first-launch).
- [ ] Enable airplane mode and keep it on for the whole pass.

## Core flows (all offline)

- [ ] Setup: enter business name → Overview opens, no account/OTP asked.
- [ ] Add product with photo; reopen app → photo and data persist.
- [ ] Real barcode: scan adds/finds the product; wrong barcode offers
      creation; deny camera permission → manual entry still works.
- [ ] Receive stock from a supplier; average cost updates.
- [ ] Sell stock (cash + transfer), override a price, add a line discount.
- [ ] Receipt: preview 80mm + A4, share PDF (saves/shares a file), print or
      graceful "unavailable" message.
- [ ] Void the sale with a reason → stock restored once, history shows VOIDED.
- [ ] Reports: Today / 7 days / This month totals match the sales just made;
      export CSV + PDF and open them.
- [ ] Record/edit/delete an expense → profit updates, ledger untouched.
- [ ] Deny notification permission → in-app alerts still list low/out items;
      allow → sell into low stock → device notification appears once.

## Interruption & data safety

- [ ] Kill the app mid-checkout (background it during Complete) → reopen
      shows either the completed sale or an untouched cart, never partial rows.
- [ ] Export backup → reinstall/clear data → restore → products, images,
      suppliers, receipts, sales (completed + voided), movements, expenses
      and report totals all match.
- [ ] Restore a corrupted file → clear error, current data untouched.
- [ ] Settings → integrity check → "All quantities match the ledger."

## Layout

- [ ] Narrow phone (≤360dp): no overflow on dashboard, forms, sale builder.
- [ ] Tablet/large screen (if supported): navigation rail appears, same flows.
- [ ] Dark mode: key screens readable (receipt PDFs stay light by design).

## Sign-off

- [ ] No P0 screen is a placeholder; no primary button is dead.
- [ ] `flutter test` green on the release commit.
