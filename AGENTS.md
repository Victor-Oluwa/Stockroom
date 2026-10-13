# Stockroom — Product Requirements Document

**Document version:** 1.0  
**Product type:** Offline inventory and sales management app  
**Primary platform:** Android mobile app built with Flutter  
**Audience:** Small retailers, furniture shops, electronics dealers, general stores, and other product-based businesses  
**Primary currency:** Nigerian naira (NGN), displayed as ₦  
**Operating model:** One business, one device, one local database; no account required and no network dependency

---

## 1. Product vision

Stockroom helps a shop owner answer five important questions reliably:

1. What products do I have, and how many are left?
2. What came into the shop, what was sold, and why did the quantity change?
3. How much did the shop sell during a selected period?
4. What did the sold stock cost, what other expenses were recorded, and what is the estimated profit?
5. Can I recover my records if my phone is lost, damaged, or replaced?

The defining feature is an **auditable stock movement ledger**. Stockroom must never treat a product's current quantity as the only record of inventory. The current quantity is a convenient balance; the movement ledger explains how that balance was reached.

For example, starting stock of 50 chairs, a sale of 3 chairs, and a receipt of 10 more chairs must produce a current balance of 57 chairs and preserve three separate movement records: `+50`, `-3`, and `+10`.

The application must be dependable before it is decorative. Every financial calculation must be consistent, every stock-changing action must be auditable, and every sale must either complete fully or leave the database unchanged.

## 2. Product goals

### 2.1 Required goals

- Work fully offline after installation. Core screens and actions must not need an internet connection, cloud account, API, remote database, or remote image service.
- Create and manage products, categories, suppliers, stock receipts, sales, expenses, and reports.
- Maintain an append-only stock movement ledger for every stock-changing event.
- Apply a completed sale and all its stock deductions atomically in a database transaction.
- Prevent sales from making stock negative.
- Capture purchase cost and estimate cost of goods sold and profit using a clearly defined costing method.
- Generate shareable PDF receipts and exportable sales reports.
- Support barcode scanning and manual barcode entry.
- Alert the user when a product becomes low-stock or out-of-stock.
- Provide usable local data backup and restore.
- Have a professional, coherent UI with complete loading, empty, success, and error states.
- Include automated tests for the rules that could cause financial or inventory inconsistencies.

### 2.2 Non-goals for version 1

Do **not** build these features in v1:

- Cloud sync, online accounts, sign-in, multi-device access, or multi-branch inventory.
- Multi-user roles or staff permissions.
- Online payments, payment gateways, a wallet, or payment settlement.
- Full customer relationship management, customer credit balances, debt collection, or split payments.
- Purchase-order approval workflows or supplier-account balances.
- Tax filing, VAT compliance, payroll, bookkeeping integrations, or formal accounting statements.
- Multi-currency accounting.
- E-commerce, online storefronts, product listings, or marketplace functionality.
- Predictive analytics, AI recommendations, or demand forecasting.
- Partial refunds or partial returns in v1. A completed sale may be voided in full with a reason.
- Backend services, REST APIs, Firebase, or any feature that needs a server to operate.

Do not create dummy cloud-sync buttons or non-functional placeholder screens for future features.

## 3. Target users and operating assumptions

### 3.1 Target users

- A furniture shop recording items such as chairs, tables, beds, sofas, and accessories.
- An electronics retailer managing TVs, phones, laptops, accessories, and barcode-labelled products.
- A general shop selling products in pieces, packs, cartons, kilograms, litres, or metres.
- A small business owner who needs a simple daily view of sales, remaining stock, operating expenses, and estimated profit.

### 3.2 Assumptions for v1

- One installation represents one business.
- One person uses the device at a time. There is no user login or permission system.
- Android is the required launch platform. Keep Flutter code organised so iOS support can be added later, but do not delay Android delivery for unsupported desktop or web features.
- Currency is NGN. Store monetary amounts as integer kobo, never as binary floating-point currency values.
- Quantities support up to three decimal places so the app can support units like kg, litres, and metres as well as whole items.
- The device's local date and time are used for records and reporting. Store timestamps consistently and display them in local time.
- All business records stay on the device unless the user explicitly exports a report or backup.
- Users must be able to continue using the app in airplane mode.

## 4. Success criteria

The product is successful when all of the following are true:

- A user can set up the business profile, add products, record received stock, complete a sale, and create a receipt without internet access.
- The stock movement history can explain the current stock quantity.
- A failed or interrupted sale cannot leave partial sale records, partial ledger entries, or incorrect stock balances.
- A user can inspect sales and estimated profit for a selected date range and export the report.
- Low-stock and out-of-stock products are obvious from the dashboard and inventory screen.
- A user can export a backup, reinstall or reset the app in a test environment, restore the backup, and recover their products, supplier records, sales, stock movement history, expenses, and product images.
- Business logic tests run deterministically and do not require network access.
- There are no dead-end primary actions, fake data presented as real data, or unimplemented core screens.

## 5. Core experience and navigation

Use Material 3 as the underlying Flutter design system, but customise the components to give Stockroom a distinctive and polished identity.

### 5.1 Main navigation

On standard phones, use a bottom navigation bar with five destinations:

1. **Overview** — dashboard, sales snapshot, stock alerts, quick actions.
2. **Inventory** — product list, search, filters, product details, stock history.
3. **Sales** — sales history and new sale / checkout.
4. **Reports** — sales, cost of goods sold, expenses, estimated profit, and exports.
5. **More** — suppliers, expenses, categories, backup and restore, business settings, and data integrity tools.

Use a navigation rail or a wider navigation layout on larger screens where it improves usability. Do not force a phone layout onto tablets.

### 5.2 Primary global actions

Make the most frequent tasks easy to reach:

- New sale
- Add product
- Receive stock
- Record expense
- Search / scan barcode

Show only actions relevant to the current screen. The primary action must be visually obvious without making every button equally prominent.

### 5.3 Visual direction

The UI should feel like a calm, modern business tool, not an admin template or a toy POS demo.

- Use a restrained neutral foundation: warm off-white or light-grey surfaces, dark charcoal text, and one confident accent colour such as deep green or muted teal.
- Avoid unnecessary gradients, glassmorphism, oversized decorative graphics, and excessive cards.
- Use clear typography, strong number hierarchy for money and quantities, consistent spacing, and simple line icons.
- Use colour as a status signal: neutral for ordinary state, amber for low stock or caution, and red for out-of-stock, destructive actions, or serious errors. Never communicate status by colour alone; pair it with text or an icon.
- Use product images where they help recognition, but keep rows compact and performant.
- Design for small Android screens first. Important actions, forms, and tables must not overflow at common phone sizes.
- Prefer short labels, helpful empty states, visible form validation, and explicit confirmation for destructive or irreversible actions.
- Format numbers consistently, for example `₦125,000.00`, `1,250`, and `1.5 kg`.

### 5.4 UI completeness rule

Every screen must implement all of these applicable states: initial/loading, populated, empty, validation error, operation failure, and successful operation feedback. Do not leave screens as static mock-ups once the data layer is implemented.

## 6. Functional requirements

Priority labels:

- **P0:** Required for a usable v1 release.
- **P1:** Important, but can follow the core workflows if time is constrained.

### 6.1 First launch and business setup (P0)

On first launch, show a short local setup flow:

1. Business name (required).
2. Optional business phone number.
3. Optional address or location line.
4. Optional logo image.
5. Optional receipt footer text.
6. Confirm that records are stored on this device and are not automatically synced to the cloud.

After setup, open Overview. Do not require a user account, OTP, email, phone verification, or internet access.

Business details must be editable under Settings. The business name and details printed on future receipts should use the latest saved profile; historical sale line items and sale totals must remain unchanged.

### 6.2 Overview dashboard (P0)

Show a useful, data-backed summary for **Today** by default, with a date selector for other views where practical.

Required metrics:

- Sales total today.
- Number of completed sales today.
- Estimated gross profit today, subject to cost-data completeness.
- Total current stock value at moving-average cost.
- Number of low-stock products.
- Number of out-of-stock products.

Required sections:

- A sales trend chart for a recent period such as the last 7 days.
- A short list of low-stock and out-of-stock products, ordered with out-of-stock first and then the lowest stock relative to threshold.
- Recent sales.
- Quick actions for New Sale, Add Product, and Receive Stock.

Requirements:

- All values must be computed from local database records. Never use hardcoded sample numbers after onboarding.
- Tapping a metric or alert opens the relevant filtered screen.
- If there is no data yet, show a useful empty state with a direct action, e.g. “Add your first product” or “Record your first sale”.
- Dashboard figures must update after relevant database changes without requiring the user to restart the app.

### 6.3 Product catalogue and inventory (P0)

#### Product fields

Each product must support:

- Product name (required).
- Optional SKU / internal product code, unique when supplied.
- Optional barcode, unique when supplied.
- Category (optional; users can create categories).
- Unit label (required; examples: piece, pair, set, pack, box, carton, kg, g, litre, ml, metre, roll, other).
- Selling price per unit (required; may be ₦0 only if the user explicitly confirms a zero-price product).
- Opening stock quantity when creating a product (may be zero).
- Opening unit cost when opening stock is greater than zero (required so cost estimates start with a known value).
- Low-stock threshold (defaults to 5 units; editable per product and may be zero to disable low-stock alerts for that product).
- Optional product image.
- Optional description or notes.
- Created date, updated date, and archived status.

Do not store arbitrary image bytes in the products table. Store images as compressed files in the app's local documents/support directory and save a stable relative path in the database.

#### Product list

Users must be able to:

- View product image or placeholder, name, SKU or barcode when available, selling price, current quantity, and stock status.
- Search by product name, SKU, or barcode.
- Filter by category, low-stock status, out-of-stock status, and archived status.
- Sort by name, recently updated, highest/lowest quantity, and highest/lowest selling price.
- Add, edit, archive, and open a product.
- Scan a barcode to find an existing product. If no product matches, offer to create a product with that barcode prefilled.

Barcode and SKU uniqueness must be enforced by the database, not only by form validation. Trim whitespace and normalise barcode strings consistently before comparing.

#### Product detail

Show:

- Product image, name, SKU/barcode, category, unit, price, average cost, current quantity, and stock status.
- Estimated current stock value.
- Recent sales and stock movements.
- Actions to edit product details, receive stock, adjust stock, and view all movement history.

Product editing must not directly change quantity on hand. All quantity changes must happen through a stock movement workflow.

#### Archive rules

- Products with historical sales or stock movements cannot be hard-deleted through the UI.
- Archive instead of delete, so historical reports and receipts remain valid.
- Archived products do not appear in ordinary product search or new sale item selection, but remain visible in historical sales and reports.
- An archived product with stock remaining must show a warning and require the user to choose whether to sell or adjust the stock before archiving; do not silently make the stock disappear.

### 6.4 Categories (P1)

Users can create, rename, and archive categories. Product category is optional. Archiving a category must not delete its historical association; archived categories remain available when rendering historical records. Do not allow a duplicate active category name after trimming and case-normalising.

### 6.5 Stock receiving / purchase record (P0)

Stock receiving records inventory arriving at the shop and the purchase cost of that inventory.

#### Workflow

1. Start Receive Stock.
2. Select an existing supplier or continue without one.
3. Add one or more products.
4. Enter quantity and purchase cost per unit for each line.
5. Optionally enter supplier invoice/reference number and notes.
6. Review the total purchase cost.
7. Confirm Receive Stock.
8. Show a success screen with the receipt reference and updated quantities.

#### Rules

- Quantity must be greater than zero.
- Unit cost must be zero or greater; a zero cost requires explicit confirmation.
- Repeated entries for the same product in one receipt should be merged into one line or otherwise handled consistently without duplicate stock movements.
- The user may receive the same product from a supplier at a different cost from previous purchases.
- Receiving stock creates a receipt header, receipt lines, and positive stock movement rows, and updates current quantities and moving-average costs in one database transaction.
- If any insert or update fails, nothing from that receipt may be committed.
- A posted stock receipt cannot be silently edited or deleted. Corrections should be recorded as explicit stock adjustments with a reason. A future version may add receipt reversal workflows.
- Receipt history must show date, reference, supplier, products, quantities, unit costs, and total purchase cost.

#### Moving weighted-average cost

Use the moving weighted-average costing method.

Before a receipt, let:

- `oldQty` be current quantity in normal displayed units.
- `oldAvgCost` be current average cost in kobo per unit.
- `receivedQty` be received quantity in normal displayed units.
- `receivedUnitCost` be the new purchase cost in kobo per unit.

After receiving stock:

`newAverageCost = roundHalfUp((oldQty × oldAvgCost + receivedQty × receivedUnitCost) / (oldQty + receivedQty))`

Use integer fixed-scale quantities internally. Do not use floating-point math for currency, quantity balances, or cost calculations. If current quantity is zero, the new average cost becomes the receipt unit cost. Quantities and costs must be calculated using the same fixed-scale integer rules everywhere.

### 6.6 Stock movement ledger and manual adjustments (P0)

The ledger is a core domain feature, not an optional audit screen.

#### Required movement types

- `OPENING_STOCK` — initial quantity set when a product is created.
- `PURCHASE_RECEIPT` — stock received from a supplier or other source.
- `SALE` — stock removed by a completed sale.
- `SALE_VOID_REVERSAL` — stock restored when a sale is voided in full.
- `ADJUSTMENT_IN` — stock added through an explicit adjustment.
- `ADJUSTMENT_OUT` — stock removed through an explicit adjustment.

Every movement must store:

- Unique movement ID.
- Product ID.
- Movement type.
- Signed quantity delta in the fixed internal quantity scale: positive adds stock; negative removes stock.
- Unit cost snapshot in kobo when applicable.
- Timestamp.
- Source/reference type and source/reference ID (sale, stock receipt, or adjustment).
- Reason/note for manual adjustments and voids.
- Unique operation/idempotency key where a repeated command could otherwise duplicate a movement.

#### Ledger rules

- Posted movement records are immutable. Do not offer an edit or delete button for a movement.
- Corrections must be represented by new, traceable movements, never by changing an old movement's quantity.
- Every movement that changes stock must be created in the same database transaction as the associated business record and cached quantity update.
- Every movement must point to a valid product and an identifiable source record or explicit adjustment record.
- The current quantity cache must equal the sum of all signed movement deltas for that product.
- The app must never allow ordinary operations to create negative stock.
- No stock movement is created for a product-name edit, selling-price edit, category edit, or image edit.

#### Manual stock adjustment workflow

1. Open a product and choose Adjust Stock.
2. Choose Increase or Decrease.
3. Enter the quantity change.
4. Choose a reason: Count correction, Damaged, Lost, Found stock, Internal use, Opening correction, or Other.
5. Add a note where the reason needs explanation. For Other, a note is required.
6. For an increase, enter the unit cost for the added quantity; default it to the current average cost but allow the user to confirm/edit it.
7. Review before-and-after quantities.
8. Confirm the adjustment.

For a decrease, block the operation if it would make stock negative. Save the prior and resulting balances for diagnostic display if useful, but the signed movement ledger remains the source used to reconstruct the balance.

#### Inventory audit screen

Provide a stock movement history screen with filters by product, movement type, date range, and reference. Each row must make clear whether stock went up or down, by how much, when, and why. Tapping a row opens the linked sale, receipt, or adjustment.

Provide a diagnostic integrity action in Settings that compares each product's cached quantity against the sum of its ledger deltas. The default action is read-only: show any mismatches and their details. Do not silently rewrite history. If a repair option is later added, it must create an explicit adjustment movement and explain what it is doing.

### 6.7 Sales and checkout (P0)

#### Start a sale

Users can start a sale from the Sales screen or a prominent New Sale action.

The sale-building screen must support:

- Search by product name, SKU, or barcode.
- Scan a barcode and add the matched item.
- Add multiple items to one cart.
- Change quantity.
- Change the sale unit price for this sale without modifying the product's default selling price.
- Apply an optional line-item discount in a fixed amount, bounded between zero and the line's gross total.
- Remove a line before completing the sale.
- See current available stock and a running total.
- Select a payment method: Cash, Bank Transfer, Card, or Other. This only records how the customer says they paid; it does not process payments.
- Optionally enter a customer name or note. Do not build customer accounts in v1.

#### Checkout validation

Before committing:

- The cart must contain at least one item.
- Every quantity must be greater than zero.
- The quantity on hand must be sufficient for every line.
- No archived product may be sold.
- The actual current stock must be rechecked inside the transaction. A stale cart view is not sufficient validation.
- The discount cannot exceed the line's gross total.
- All prices, quantities, totals, and costs must be valid and non-negative.

#### Atomic sale transaction

Completing a sale is one all-or-nothing database transaction. In the same transaction, the app must:

1. Validate the product records and latest available quantities.
2. Allocate the unique sale/receipt number and save the sale header.
3. Save all sale lines with immutable snapshots of product name, SKU where available, unit label, quantity, actual sale unit price, discount, line total, unit cost at sale time, and cost of goods sold.
4. Insert one negative `SALE` movement for each sold product line (or one aggregated movement per product if the implementation deliberately merges duplicate cart rows).
5. Update cached product quantities.
6. Store the idempotency key / operation identifier.
7. Commit.

If any step fails, roll back all of them. There must be no sale with missing lines, no sale line without its movement, and no stock change without a completed sale record.

Disable the Complete Sale button while the command is being submitted, but do not rely on UI button disabling as the only duplicate-prevention mechanism. Use a unique idempotency key enforced at the persistence layer.

After a successful sale:

- Show a confirmation with sale reference, total, payment method, and actions to View Receipt, Share/Print Receipt, or Start Another Sale.
- Clear the cart only after the transaction succeeds.
- Refresh the sales list, dashboard totals, product balances, and low-stock state.
- The receipt must remain accessible from the sale history.

#### Sales history and detail

The sales list must support date filtering and search by sale reference or customer name. Each row shows reference, date/time, total, payment method, and status.

Sale detail displays the original product/price/quantity snapshots, discounts, total, payment method, and generated receipt. Product edits after a sale must not rewrite the historical sale description, price, line total, or cost snapshot.

#### Voiding a sale

- A completed sale can be voided only in full in v1.
- Require the user to confirm and enter a reason.
- Mark the sale as `VOIDED`; do not delete the sale, sale lines, or original movements.
- In one transaction, create positive `SALE_VOID_REVERSAL` movements using each sale line’s original `unitCostSnapshotKobo`, restore quantities, update cached balances and moving-average costs, and store the void timestamp and reason. For each product restored, calculate the new average cost as the weighted average of the inventory currently on hand at its current average cost and the returned quantity at the original sale cost snapshot. If current quantity is zero, set the resulting average cost to the returned sale cost snapshot. Use the same integer rounding rule as stock receipt costing.
- Prevent a sale from being voided twice.
- Void actions must be visible in history.
- Voided sales are excluded from completed sales revenue and completed-sale counts. Reports may show voided-sale counts separately for transparency.

### 6.8 Receipts (P0)

Generate receipts entirely on-device. Receipt generation must not need an online service.

Each receipt must contain:

- Business name and optional business contact/address/logo/footer.
- Sale reference.
- Date and time.
- Item description and unit.
- Quantity, sale unit price, line discount (if any), and line total.
- Subtotal, total discounts, and amount due/paid total.
- Payment method.
- Optional customer name.
- A brief thank-you/footer line.

Support a compact 80 mm receipt layout and a standard A4 layout. The compact receipt is the default for preview and PDF export. Avoid rendering cut-off text or clipped item descriptions; long receipts may span multiple pages where appropriate.

Requirements:

- A receipt is based on the immutable sale snapshot, not live product details.
- Receipt preview must work offline.
- User can export/share the receipt PDF using the system share sheet and print through the device's supported print flow where available.
- If printing is unavailable, sharing/saving the PDF must still work.
- Do not claim that a sale was completed until the sale database transaction has committed.

### 6.9 Low-stock and out-of-stock alerts (P0)

A product is:

- **Out of stock** when current quantity equals zero.
- **Low stock** when current quantity is greater than zero and less than or equal to its configured threshold.
- **In stock** when quantity is greater than the threshold.

The dashboard and inventory list must surface these states. Add a persistent in-app alert list grouped by out-of-stock and low-stock products.

Provide optional local device notifications:

- Notify when a product transitions from in-stock to low-stock or out-of-stock because of a sale or adjustment.
- Do not send repeated notifications for every later sale while the same low-stock condition remains active.
- Reset the alert condition after stock is replenished above the threshold, so a later transition can alert again.
- Ask for notification permission only when needed and explain why it helps. If permission is denied, keep all alerts available inside the app.
- Never use push notifications or a server.

### 6.10 Suppliers (P0)

Supplier fields:

- Supplier/business name (required).
- Contact person's name (optional).
- Phone number (optional).
- Email (optional).
- Address (optional).
- Notes (optional).
- Archived status and timestamps.

Users can create, edit, view, search, and archive suppliers. Supplier detail shows stock receipts linked to that supplier and total recorded purchase spend across the selected period.

Supplier information is optional on stock receipt creation. Do not fabricate accounts payable or claim that supplier purchases have been paid unless the user explicitly records that concept; payment tracking is outside v1.

Suppliers referenced by receipts cannot be hard-deleted. Archive them instead.

### 6.11 Operating expenses (P0)

Allow manual recording of non-inventory business expenses such as rent, transport, utilities, repairs, packaging, wages, marketing, and other expenses.

Each expense contains:

- Amount (required and greater than zero).
- Category (required; built-in categories plus Other).
- Date (defaults to today, editable).
- Payment method (Cash, Bank Transfer, Card, Other).
- Optional note/description.
- Created timestamp.

Users can add, view, search/filter by date/category, and edit/delete an expense with confirmation. Because editing expenses affects reports, retain an `updatedAt` timestamp. Expense editing must not affect the stock movement ledger.

**Important accounting distinction:** Receiving inventory records stock asset cost and influences the moving-average cost. It is not also recorded as an operating expense. Cost of goods sold is recognised in the profit estimate when a product is sold. This avoids double-counting inventory purchases as both COGS and operating expenses.

### 6.12 Reports and exports (P0)

Provide a date-range filter with presets: Today, Yesterday, Last 7 Days, This Month, Last Month, and Custom Range.

Required reports:

1. **Sales summary:** net sales after line discounts, transaction count, average sale value, and sales by day.
2. **Sales details:** each completed sale, reference, date/time, payment method, and total.
3. **Product sales:** quantity sold and net sales value by product.
4. **Profit estimate:** net sales minus cost of goods sold minus operating expenses.
5. **Expense report:** expenses by category and date.
6. **Stock valuation:** current quantity multiplied by current moving-average cost, with total inventory value.
7. **Stock movement report:** movement type, product, quantity delta, date, reason/reference.

Reporting rules:

- Include only completed sales in sales and profit totals; exclude voided sales, while optionally showing void counts separately.
- Sale revenue is the line total after line-item discounts.
- COGS is the saved cost snapshot on the sale line and must not be recalculated from today's average cost.
- Estimated gross profit = net sales − COGS.
- Estimated operating profit = net sales − COGS − recorded operating expenses within the same date range.
- Do not subtract stock receipt spend a second time in profit calculations.
- Expenses are included according to the expense date.
- For a selected date range, use local calendar dates: start date inclusive; end date inclusive in the UI, implemented as an exclusive boundary at midnight after the end date.
- If some relevant product costs are unknown or missing due to imported/legacy data, explicitly mark profit as incomplete rather than presenting a false precise number. For newly created v1 records, require an opening unit cost for non-zero opening stock and a cost for all stock increases so COGS can be calculated.
- Dashboard, report screen, PDF report, and CSV export must use the same calculation logic.

Export formats:

- **CSV:** sales detail and product sales at minimum. Use UTF-8 and stable column names. Escape commas, quotes, and line breaks correctly. Use ISO-style timestamps or clear local datetime columns. Ensure values are useful in spreadsheet software.
- **PDF:** sales summary and profit estimate, with business name, report period, generated timestamp, and totals. Include detail tables where useful and avoid clipped columns.

Export must create a local file and present the platform share/save flow. Do not require storage permission unnecessarily or assume a hardcoded public Downloads directory. Handle cancellation and export failure gracefully.

### 6.13 Search and barcode scanning (P0)

- All catalogue searches must work offline.
- Search product name, SKU, and barcode. Use case-insensitive matching for names/SKU and consistent normalisation for barcode values.
- Support manual barcode input even when the camera is unavailable or permission is denied.
- Use a maintained Flutter barcode scanning plugin such as [`mobile_scanner`](https://pub.dev/packages/mobile_scanner), after confirming its current SDK compatibility.
- Support common retail barcode formats available on the target platform, including EAN-13, EAN-8, UPC-A/UPC-E, and Code 128 where supported by the selected plugin.
- Prevent duplicate scan callbacks from adding the same item multiple times immediately. Once a product is identified, return a single scan result and pause or close the scanner until the user chooses the next action.
- If a scan matches an existing product, offer a context-appropriate action: view product, or add it to the current sale/receipt workflow.
- If no product matches, offer “Create product with this barcode” with the barcode prefilled.
- If camera permission is denied, show a clear explanation and an alternate manual-entry action rather than a dead end.

### 6.14 Settings and local data management (P0)

Settings must include:

- Edit business profile and receipt details.
- Manage notification preference.
- Choose default low-stock threshold for new products.
- View app/database version and local storage status.
- Run stock ledger integrity check.
- Export a full backup.
- Restore from backup.
- About / version information.

#### Backup requirements

A full backup must include:

- The local database in a consistent snapshot.
- All product images referenced by the database.
- A manifest containing backup format version, app/database schema version, creation timestamp, and required file list.

The backup should be a single portable archive with a Stockroom-specific extension or a clearly named ZIP file. The user must be able to save it locally or share it through the system picker/share sheet. Backups must work without internet access.

Do not copy only the main SQLite database file while a write-ahead log may contain committed data. Use a database-consistent backup/checkpoint process and coordinate it with open connections. Validate that all referenced image files are present in the backup.

#### Restore requirements

- Let the user select a Stockroom backup file.
- Validate archive structure, manifest version, database integrity, and referenced image files before replacing current data.
- Show a clear warning that restore replaces the current on-device business data.
- Require explicit confirmation.
- Preserve a safety backup of the current data before replacement where technically possible.
- Restore into a staging location, verify it, and only then replace the active files. A failed restore must not leave the app with a partially restored database.
- Reopen the database and refresh all reactive queries after a successful restore.
- If the backup schema is unsupported, explain the issue without deleting current data.
- Never upload backups automatically.

### 6.15 Empty states, errors, and validation (P0)

- Errors must be understandable to a shop owner, not raw SQL or stack traces.
- Log technical details in debug logs without showing sensitive implementation information to the user.
- Form validation must be near the relevant field.
- Confirm sale void, archive, expense delete, and restore operations.
- Failed actions must preserve the user's current form/cart where appropriate and must never pretend success.
- Use transaction-safe repository methods for all write operations.
- Handle app lifecycle interruption gracefully. A sale may be committed even if the UI closes immediately after commit; reopening the app must show the correct result.

## 7. Business rules and calculations

This section is the source of truth for domain calculations. Implement these rules in domain/services, not independently inside UI widgets.

### 7.1 Numeric representation

- Store all monetary values as integer kobo (`₦1.00 = 100 kobo`).
- Store quantities as integers scaled by 1,000 (`1.000 displayed units = 1,000 stored quantity units`).
- Convert to formatted decimal strings only for display and input parsing.
- Parse user-entered decimal values into scaled integers using decimal-safe parsing and explicit rounding rules. Reject invalid precision beyond three decimal places instead of silently truncating it.
- Avoid Dart `double` for financial calculations. Use integer arithmetic with documented half-up rounding where division is unavoidable.

### 7.2 Line totals

For each sale line:

- `grossLineTotalKobo = roundHalfUp(quantityMilli × unitPriceKobo / 1000)`.
- `discountKobo` must satisfy `0 ≤ discountKobo ≤ grossLineTotalKobo`.
- `netLineTotalKobo = grossLineTotalKobo − discountKobo`.
- `cogsTotalKobo = roundHalfUp(quantityMilli × unitCostSnapshotKobo / 1000)`.
- `lineProfitKobo = netLineTotalKobo − cogsTotalKobo`.

The overall sale total is the sum of its line net totals. Do not separately round a floating-point subtotal and then round it again. Use the same pure calculation functions for the checkout preview, committed sale, receipt, and reports.

### 7.3 Current stock

For a product:

`quantityOnHandMilli = sum(stockMovement.quantityDeltaMilli)`

The cached quantity in the product row must be updated within the same transaction as new movements. Use it for responsive lists, but provide tests and an integrity checker that compare it to the movement-ledger sum.

### 7.4 Inventory valuation

`stockValueKobo = roundHalfUp(quantityOnHandMilli × averageCostKobo / 1000)`

Only non-negative quantities are permitted. When quantity is zero, stock value is zero. Moving-average cost remains the last known cost when stock reaches zero, but the next receipt resets the average to that receipt's unit cost.

### 7.5 Profit terminology

Display the word **Estimated** near profit metrics to avoid implying audited accounting results.

- Net sales = sum of net line totals from completed sales in the period.
- Cost of goods sold = sum of stored sale-line COGS snapshots for completed sales in the period.
- Estimated gross profit = net sales − COGS.
- Operating expenses = sum of non-inventory expense entries dated in the period.
- Estimated operating profit = estimated gross profit − operating expenses.

Stock receipt purchase spend is not subtracted as an operating expense. Sales from a past period must retain their original cost snapshots if current purchase cost later changes.

### 7.6 Date and time

- Persist timestamps consistently, preferably UTC timestamps, and render them in local device time.
- The reporting date range is based on local dates selected by the user.
- Store date-only business expense dates without introducing timezone shifts that move an entry to the previous or next day.
- Tests must cover date-range boundaries, including midnight and month/year transitions.

## 8. Data model and persistence design

Use SQLite through Drift or an equally robust typed relational SQLite layer. Drift is the preferred choice because it supports typed queries, reactive streams, schema migrations, and transactions: [Drift documentation](https://pub.dev/documentation/drift/latest/index.html).

Use UUIDs (or another collision-safe local ID strategy) for primary keys. Define foreign keys, unique indexes, and lookup indexes deliberately. Use database migrations for every schema change.

### 8.1 Required entities/tables

The exact naming can follow Dart conventions, but the fields and relationships below must be represented.

#### `business_profile`

- `id` (single active profile for this installation).
- `businessName` (required).
- `phone`, `address`, `logoPath`, `receiptFooter` (optional).
- `createdAt`, `updatedAt`.

#### `product_categories`

- `id`, `name`, `isArchived`, `createdAt`, `updatedAt`.
- Unique index on normalised active category name.

#### `products`

- `id`, `name`, `normalisedName`.
- `sku` (nullable; unique when non-null/non-empty).
- `barcode` (nullable; unique when non-null/non-empty).
- `categoryId` (nullable foreign key).
- `unitLabel`.
- `sellingPriceKobo` (integer).
- `averageCostKobo` (integer).
- `quantityOnHandMilli` (integer cached value, constrained to be non-negative).
- `lowStockThresholdMilli` (integer, non-negative).
- `imagePath`, `description` (optional).
- `isArchived`, `createdAt`, `updatedAt`.

#### `suppliers`

- `id`, `name`, optional `contactName`, `phone`, `email`, `address`, `notes`.
- `isArchived`, `createdAt`, `updatedAt`.

#### `stock_receipts`

- `id`, unique human-readable `receiptNumber`.
- `supplierId` (nullable).
- `supplierReference` (optional).
- `receivedAt`, `notes` (optional).
- `totalCostKobo` (computed by the domain layer; never trusted from UI input).
- Unique `idempotencyKey` for preventing duplicate receipt commits.
- `createdAt`.

#### `stock_receipt_lines`

- `id`, `receiptId`, `productId`.
- `quantityMilli`, `unitCostKobo`, `lineCostKobo`.
- Snapshot product name and unit label where needed for historical readability.

#### `sales`

- `id`, unique human-readable `saleNumber`.
- `status` (`COMPLETED` or `VOIDED`).
- `soldAt`, `paymentMethod`.
- Optional `customerName`, `note`.
- `subtotalKobo`, `discountTotalKobo`, `totalKobo`.
- Optional void fields: `voidedAt`, `voidReason`.
- Unique `idempotencyKey` for preventing duplicate commits.
- `createdAt`.

#### `sale_lines`

- `id`, `saleId`, `productId`.
- Immutable snapshots: `productNameSnapshot`, `skuSnapshot`, `unitLabelSnapshot`.
- `quantityMilli`, `unitPriceKobo`, `grossLineTotalKobo`, `discountKobo`, `netLineTotalKobo`.
- `unitCostSnapshotKobo`, `cogsTotalKobo`.

#### `stock_movements`

- `id`, `productId`, `movementType`.
- `quantityDeltaMilli` (signed integer).
- `unitCostKobo` where applicable.
- `occurredAt`.
- `referenceType`, `referenceId`.
- Optional `reason`, `note`.
- Unique operation/idempotency key when applicable. For ledger rows created by a multi-line business operation, ensure the key is unique per movement while retaining a unique operation key on the parent sale/receipt/adjustment.
- `createdAt`.

Add indexes for `(productId, occurredAt)`, `(referenceType, referenceId)`, and any columns frequently used in history filters.

#### `stock_adjustments`

- `id`, unique adjustment reference number.
- `productId`, `adjustmentType`, `quantityMilli`, `unitCostKobo` where relevant.
- `reason`, optional `note`, `occurredAt`.
- Unique `idempotencyKey` for preventing duplicate adjustment commits.
- `createdAt`.

#### `expenses`

- `id`, `amountKobo`, `category`, `expenseDate`, `paymentMethod`, optional `note`.
- `createdAt`, `updatedAt`.

#### `app_settings`

- Default low-stock threshold for new products.
- Local notification preference.
- Receipt layout preference.
- Receipt/sale/stock-receipt/adjustment number sequences where required.
- Schema-compatible settings version if needed.

### 8.2 Referential integrity and historical records

- Enable SQLite foreign-key enforcement.
- Do not hard-delete products, suppliers, or categories that are referenced by historical business records; archive them.
- A product's name, unit, and selling price may change, but sale lines must keep snapshots.
- A supplier's name may change, but historical receipts must remain readable. Snapshot the supplier name on the receipt if required to preserve the historical display.
- Database writes that span multiple tables must be handled by repository/domain operations with explicit transactions.

### 8.3 Schema migration policy

- Maintain a schema version and explicit migrations.
- Never fix schema changes by deleting the local database on startup.
- Migration tests must open a database at an older schema version, apply migrations, and verify records remain intact.
- Provide meaningful recovery errors when a local database cannot be opened; do not silently start a blank business database over existing files.

## 9. Recommended Flutter implementation architecture

### 9.1 Stack

- Flutter and Dart using the stable SDK available in the development environment.
- SQLite with Drift as the preferred persistence layer.
- `flutter_bloc` for feature-level BLoC/Cubit state management.
- `flutter_riverpod` for dependency injection and lifecycle management, not as a second competing presentation-state system.
- `equatable` for value/state equality if not using another established immutable-model generator.
- `fpdart` or a similarly consistent result type for typed domain/repository errors.
- `mobile_scanner` for camera barcode scanning, subject to current target-SDK compatibility: [package page](https://pub.dev/packages/mobile_scanner).
- `image_picker` for product and business logo images, then copy/compress picked files into the app's controlled local directory: [package page](https://pub.dev/packages/image_picker).
- `pdf` for on-device PDF generation: [package page](https://pub.dev/packages/pdf).
- `printing` for PDF preview/print integration where supported: [package page](https://pub.dev/packages/printing).
- `share_plus` for platform share sheets: [package page](https://pub.dev/packages/share_plus).
- `path_provider` for application support/documents directories: [package page](https://pub.dev/packages/path_provider).
- A maintained CSV utility or a small tested CSV encoder for export.
- A maintained local-notification package if notification permission and delivery are implemented.

Before adding dependencies, confirm current maintenance status, licensing, minimum Flutter/Dart requirements, Android requirements, and offline behavior. Do not use an abandoned package or blindly pin an outdated version. Do not add packages merely for convenience if core Dart or Flutter APIs are sufficient.

### 9.2 Architecture rules

Use a feature-first structure with clean separation of UI, domain rules, and data persistence. The Flutter team's architecture guidance also recommends clear UI/data layers, repositories, dependency injection, and immutable data: [Flutter architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations).

Suggested layout:

```text
lib/
  app/
    app.dart
    router.dart
    theme/
    di/
  core/
    database/
      app_database.dart
      migrations/
    errors/
    money/
    quantity/
    formatting/
    files/
    pdf/
    widgets/
  features/
    onboarding/
      data/
      domain/
      presentation/
    dashboard/
      data/
      domain/
      presentation/
    inventory/
      data/
      domain/
      presentation/
    stock_receiving/
      data/
      domain/
      presentation/
    stock_movements/
      data/
      domain/
      presentation/
    sales/
      data/
      domain/
      presentation/
    suppliers/
      data/
      domain/
      presentation/
    expenses/
      data/
      domain/
      presentation/
    reports/
      data/
      domain/
      presentation/
    settings/
      data/
      domain/
      presentation/
```

Feature folders can be adjusted if the actual repository uses another clear structure, but do not mix all database code, business logic, and widgets in one file.

### 9.3 Layer responsibilities

**Presentation**

- Flutter screens/widgets, BLoCs/Cubits, form state, route navigation, and view formatting.
- No direct database access.
- No financial or inventory calculations duplicated in widgets.

**Domain**

- Entities/value objects, repository contracts, use cases for complex operations, quantity/money calculations, stock validation, weighted-average calculations, profit rules, and typed business failures.
- Keep domain logic deterministic and testable without Flutter widgets or a real device.

**Data**

- Drift tables, DAOs, database queries, row-to-domain mapping, repository implementations, file persistence, and schema migrations.
- Transaction boundaries live in the data operation that owns all records affected by a command, guided by domain invariants.

**Dependency injection**

- Register database, DAOs, repositories, services, use cases, and BLoCs through Riverpod providers.
- Avoid global mutable singletons and direct service construction inside widgets.

### 9.4 Repository and transaction boundaries

At minimum, provide repository/domain operations resembling:

- `createProduct(...)`
- `updateProductDetails(...)`
- `receiveStock(...)`
- `adjustStock(...)`
- `completeSale(...)`
- `voidSale(...)`
- `recordExpense(...)`
- `getSalesReport(...)`
- `getProfitReport(...)`
- `exportBackup(...)`
- `restoreBackup(...)`
- `checkStockLedgerIntegrity(...)`

Names can change, but transactional operations must remain explicit and cohesive. Do not expose a public API that lets arbitrary UI code update `quantityOnHandMilli` without creating a movement.

### 9.5 Reactive reads

Use Drift streams or another reliable reactive query mechanism so that product lists, dashboard metrics, sales history, and alerts update after successful changes. Do not build manual global caches that can drift out of sync with SQLite.

### 9.6 Error handling

Use typed domain failures such as:

- Product not found.
- Duplicate SKU/barcode.
- Insufficient stock.
- Invalid quantity or price.
- Sale already voided.
- Operation already processed.
- Database transaction failed.
- Backup invalid or unsupported.
- Export failed.

Present user-friendly messages. Preserve the original exception/cause in debug logs. Avoid swallowing failures or returning fabricated success values.

## 10. Performance, privacy, and reliability requirements

- All primary screens must work in airplane mode.
- App startup should not wait for network checks or remote configuration.
- Use database indexes for searchable and date-filtered fields.
- Paginate or incrementally load long histories rather than loading unlimited rows into memory.
- Compress product images before permanent storage. Use a reasonable max dimension (for example, 1,200 px on the longest edge) and a configurable quality that keeps images legible without excessive disk usage.
- Generate PDFs and CSVs locally. Large report generation must show progress and remain cancellable where practical.
- Do not log customer names, expense notes, or full receipt data unnecessarily.
- Do not request contacts, location, microphone, or other permissions that the product does not need.
- Camera permission is required only for barcode scanning and image capture if camera capture is supported.
- Notification permission is optional and must not prevent core app usage.
- Use safe file paths and validate imported archive entry names to prevent path traversal during restore. Enforce reasonable archive/file-size limits and reject duplicate or unexpected paths.
- A corrupt or unsupported backup must not overwrite good local data.
- Prevent destructive double submissions, particularly for sale, stock receipt, stock adjustment, sale void, and restore.
- No uncaught exception should close the app during an ordinary validation error or failed database write.

## 11. Testing strategy

Automated tests are a release requirement, not optional cleanup.

### 11.1 Pure unit tests

Test:

- Currency parsing and formatting.
- Quantity parsing and formatting, including three decimal places and invalid precision.
- Half-up rounding edge cases for line totals and average cost.
- Discount bounds and line-total calculations.
- Weighted-average cost after multiple receipts.
- Sale COGS snapshots remaining unchanged after later cost updates.
- Profit calculation with and without expenses.
- Correct exclusion of voided sales.
- Low-stock/out-of-stock boundary behaviour.
- Reporting date ranges around midnight, month-end, leap day, and year-end.

### 11.2 Database/repository integration tests

Use a temporary test database. Do not use a developer's real app database.

Test:

1. Creating a product with 50 chairs creates an opening movement of `+50` and current quantity 50.
2. Selling 3 chairs creates a movement of `-3` and current quantity 47.
3. Receiving 10 chairs creates a movement of `+10` and current quantity 57.
4. The movement ledger sums to the cached quantity.
5. A sale with two products where the second product has insufficient stock rolls back the sale header, every sale line, all movements, and all quantity updates.
6. A simulated database failure midway through a sale leaves no partial records.
7. Repeating a sale command with the same idempotency key does not create a duplicate sale or movement.
8. A repeated stock receipt command cannot duplicate received stock.
9. Negative inventory is blocked even if the UI submits stale stock values.
10. Voiding a completed sale exactly once restores all quantities and creates reversal movements.
11. Historical sale snapshots survive product name, price, and average-cost changes.
12. Archived products remain in historical reports while being excluded from new sales.
13. Foreign keys and uniqueness constraints are enforced.
14. Backup/restore preserves database records, ledger history, and image references.
15. A failed restore leaves the active database intact.
16. Migrations preserve data from older database versions.

### 11.3 Widget tests

At minimum test:

- Product creation validation and successful save.
- Barcode not found flow.
- Cart quantity and price editing.
- Checkout validation and insufficient-stock error.
- Sale success feedback only after repository success.
- Sale void confirmation and required reason.
- Empty and populated dashboard states.
- Low-stock alert display.
- Report date-range control and export-error feedback.
- Restore warning and confirmation.

### 11.4 Manual release tests

On a physical Android device:

- Install, launch, and complete core flows while offline/airplane mode is enabled.
- Create products, add product images, scan a real barcode, receive stock, sell stock, view receipt, and export CSV/PDF.
- Deny camera and notification permissions and verify usable fallback behaviour.
- Kill/reopen the app during and after write operations; verify data integrity.
- Export a backup, restore it, and inspect products, images, sales, expenses, reports, and ledger.
- Test on a narrow phone screen and a larger phone/tablet-sized viewport if supported.

## 12. Acceptance scenarios

The agent must use these as executable requirements.

### Scenario A — Ledger integrity

Given a new product named “Chair” with opening quantity 50 and opening unit cost ₦10,000, when the user sells 3 chairs and then records receipt of 10 chairs at a purchase unit cost of ₦11,000, then:

- Current quantity equals 57.
- Ledger contains opening `+50`, sale `-3`, and receipt `+10` movements linked to their source records.
- The cached quantity equals the sum of all movement deltas.
- The receipt updates moving-average cost according to the defined formula.
- Historical COGS on the completed sale retains the cost snapshot used at sale time.

### Scenario B — Sale is all-or-nothing

Given a cart with two product lines and insufficient stock for the second line, when checkout is submitted, then:

- Checkout fails with a clear message.
- No completed sale exists.
- No sale lines exist for the failed operation.
- No stock movements were written.
- No product quantities changed.
- The cart remains available for correction.

### Scenario C — Double tap or retry

Given a checkout command, when it is submitted twice because of a double tap, retry, or interrupted UI, then only one sale and one corresponding set of stock movements are committed for that operation key.

### Scenario D — Sale void

Given a completed sale, when the user confirms a full void with a reason, then the original sale remains in history marked voided, reversal movements are added, stock is restored once, and reports exclude the voided sale from net sales and COGS.

### Scenario E — Price changes do not rewrite history

Given a product has been sold at ₦15,000, when its current selling price changes to ₦17,000, then the old receipt and sale history still display ₦15,000 for that sale.

### Scenario F — Cost changes do not rewrite history

Given an item is sold while its average cost is ₦9,000, when the next receipt changes the moving average, then the previous sale's COGS and profit report for that prior sale remain unchanged.

### Scenario G — Backup and restore

Given a database containing products, images, suppliers, receipts, completed and voided sales, movement history, and expenses, when the user exports a backup and restores it on a clean test installation, then all records and referenced product images are restored and reports produce the same totals.

### Scenario H — Offline operation

Given the device is in airplane mode from first launch, when the user sets up Stockroom and completes a product creation, stock receipt, sale, receipt export, and report export, then all operations succeed without network access.

## 13. Implementation plan and build gates

Build incrementally in vertical slices. Do not build every screen with mock data first and postpone the database/business logic until the end.

### Phase 1 — Project foundation

- Inspect the existing repository before changing it.
- Confirm Flutter/Dart versions, target Android SDK, current conventions, and available design assets.
- Create app theme, navigation, dependency injection, error/result conventions, local SQLite/Drift setup, migration support, and test infrastructure.
- Add the business setup flow and persistence.

**Gate:** App launches offline, persists business profile through restart, and database migrations/tests run.

### Phase 2 — Product catalogue

- Implement product/category schemas, repositories, validation, image storage, product creation/editing/archive, search, filters, and detail page.
- Opening quantity above zero must create an opening stock movement and require an opening unit cost.

**Gate:** Product quantity is derived/audited against the ledger; product image and data survive restart.

### Phase 3 — Stock movements and receiving

- Implement supplier records, stock receipt flow, moving-average costing, manual adjustments, movement history, and integrity checker.

**Gate:** The `50 → sell 3 → receive 10 → 57` test passes; transaction failures roll back all receipt and adjustment writes.

### Phase 4 — Checkout and receipts

- Implement cart, barcode search/scan, price overrides, line discount, payment-method capture, atomic sale transaction, idempotency, sale history, full void, and PDF receipt generation/sharing.

**Gate:** Sale rollback, duplicate submission, insufficient stock, void, and immutable receipt snapshot tests pass.

### Phase 5 — Dashboard, expenses, and reports

- Implement expenses, dashboard metrics, stock alerts, local notification behaviour, date-range filters, sales/product/profit/expense/valuation/movement reports, CSV and PDF export.

**Gate:** Dashboard, report screen, PDF and CSV use one set of calculation functions and produce matching totals for test fixtures.

### Phase 6 — Backup, restore, and hardening

- Implement full backup archive, manifest validation, image inclusion, safe restore, safety backup, schema migrations, integrity diagnostics, lifecycle/error handling, and performance work.

**Gate:** Restore a representative backup into a clean test installation; intentionally corrupt a backup and confirm existing data remains intact.

### Phase 7 — Visual polish and release verification

- Refine spacing, typography, form affordances, empty/error/loading states, accessibility labels, keyboard behaviour, narrow-screen layout, and UI consistency.
- Run all unit, repository, widget, and manual tests.
- Test release build on a physical Android device in airplane mode.

**Gate:** No P0 feature remains a mock-up or TODO, no known data-loss issue remains, no primary action is broken, and the app has a clear backup reminder/help text.

## 14. Agent working rules

The coding agent must follow these rules throughout implementation:

1. **Inspect before editing.** Read the existing repository, project instructions, dependency versions, and current patterns before introducing a new structure.
2. **Treat this PRD as the product contract.** If an implementation detail is not specified, choose the simplest robust option consistent with offline operation, auditability, and a polished business UI. Document material decisions in the repository.
3. **No fake completion.** Do not mark a feature complete if it has placeholder data, non-functional buttons, TODO paths, or untested transaction behaviour.
4. **No direct quantity mutation from the UI.** Quantity changes must run through a domain/repository operation that creates a ledger movement in the same transaction.
5. **No floating-point money math.** Money is integer kobo and quantity is fixed-scale integer. All rounding rules must be centralised and tested.
6. **No business logic in widgets.** Widgets collect input and display state; domain calculations and transaction operations belong below the presentation layer.
7. **One source of truth for calculations.** Dashboard, receipt, and exports must reuse the same calculation functions/repository projections.
8. **Do not swallow exceptions.** Convert failures into typed errors, preserve diagnostic context in logs, and show a useful user message.
9. **Keep tests close to each vertical slice.** Implement tests as the feature is added, not after all screens are finished.
10. **Keep local data safe.** Never reset or delete an existing business database to solve a migration or startup problem.
11. **Avoid unnecessary abstractions.** Use clear feature boundaries and explicit domain operations, but do not build a generic enterprise framework or speculative plugin architecture.
12. **After each phase, run formatting, static analysis, and the relevant tests.** Fix new warnings and failures before moving to the next phase.
13. **Report honestly.** At completion, provide a concise summary of what was implemented, important files, commands run, test results, known limitations, and any unresolved issues.
14. **Do not ask the user to re-decide settled requirements.** Use the assumptions and acceptance scenarios in this document. Ask only if an unavoidable conflict with the existing repository prevents a safe implementation.

## 15. Definition of done

Stockroom v1 is done only when:

- All P0 features in this PRD are implemented and connected to persistent local data.
- The app can complete the critical business workflows entirely offline.
- Stock movements explain every inventory balance and the integrity checker detects mismatches.
- Sale and stock receipt transactions are atomic and protected against duplicate submission.
- Cost of goods sold and estimated profit use immutable sale-time cost snapshots.
- PDF receipts and PDF/CSV reports work without a server.
- Barcode scanning has a manual fallback.
- Backup/restore preserves the database and product images and fails safely on invalid input.
- Unit, database integration, and core widget tests pass.
- The app has polished success, empty, loading, validation, and error states.
- No P0 screen is a placeholder and no critical action silently fails.
- The agent has documented test commands, limitations, and any remaining P1 work.

---

## Reference documentation

Use these as starting points, not as substitutes for checking current version compatibility:

- [Flutter architecture recommendations](https://docs.flutter.dev/app-architecture/recommendations)
- [Drift — reactive SQLite persistence](https://pub.dev/documentation/drift/latest/index.html)
- [mobile_scanner](https://pub.dev/packages/mobile_scanner)
- [image_picker](https://pub.dev/packages/image_picker)
- [pdf](https://pub.dev/packages/pdf)
- [printing](https://pub.dev/packages/printing)
- [share_plus](https://pub.dev/packages/share_plus)
- [path_provider](https://pub.dev/packages/path_provider)
