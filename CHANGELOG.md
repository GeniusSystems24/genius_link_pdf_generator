# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [3.6.0] - 2026-05-08

### Added — Financial Calculation Validation Layer

New package `lib/src/core/financial/` with full financial validation support:

- **`GeniusRoundingPolicy`** — configurable rounding (halfUp, halfEven, truncate, floor, ceiling), per-currency decimal places (KWD 3dp, JPY 0dp, SAR 2dp), dual absolute+relative tolerance
- **`GeniusMoney`** — immutable minor-unit value type; exact integer arithmetic; `isWithinTolerance` uses integer comparison (IEEE 754 safe)
- **`GeniusFinancialValidator`** — stateless validator: subtotal, VAT (post-discount ZATCA), grand total, transfer net, currency conversion (two-stage), accounting balance (strict), grid column sums, averages, budget variance; all errors bilingual (EN/AR)
- **`GeniusFinancialValidationResult`** / **`GeniusFinancialValidationError`** — sealed result with `combine()` for multi-field validation
- **`GeniusFinancialValidationContext`** — rounding policy + optional source-currency policy for multi-currency flows
- **`GeniusPdfFailure.fromValidation()`** factory and **`validationResult`** getter on `GeniusPdfFailure`
- **`generateResult({validateFinancials, validationContext})`** on `TaxInvoiceTemplate`, `CreditNoteTemplate`, `PurchaseOrderTemplate`, `QuotationTemplate`, `PayslipTemplate`, `CustomerStatementTemplate`, and `GeniusPdfVoucherTemplate`; `validateFinancials: false` preserves backward compatibility
- 98 unit tests: rounding modes, zero/negative/large amounts, ZATCA VAT, accumulation, multi-currency

**Zero breaking changes** — existing `generate()` calls are untouched; `generateResult()` is additive.

---

## [3.5.0] - 2026-02-06

### Added

#### Complete Voucher Demo — Comprehensive Example
- **`complete_voucher_demo_builder.dart`** — showcases all 16 voucher template classes in a single batch PDF
  - One representative voucher from each template class
  - Demonstrates the full breadth of the voucher system
  - 16 vouchers covering 64 service ID subtypes

#### Example Showcase Enhancement
- **Complete Demo tab** — new tab in the example app showcasing all voucher types
  - Icon: `library_books_rounded`
  - Generates a comprehensive 16-page PDF with one voucher from each template class

### Summary
- **16 template classes**: AccountingEntry, Receipt, Payment, Tax, BankDeposit, BankWithdrawal, Transfer, BillPayment, RemittanceOutgoing, RemittanceIncoming, Purchase, Sales, PurchaseReturn, SalesReturn, Gift, Inventory
- **64 service ID subtypes**: Each template class supports 2-6 payment/operation variants
- **Full bilingual support**: Arabic/English throughout all templates and examples

---

## [3.4.0] - 2026-02-05

### Added

#### Auxiliary Voucher Templates (Gift & Inventory)
- **`GiftVoucher`** — 2 service IDs (20500–20501): Received Gift/Grant, Given Gift
  - Direction-based layout (received vs given)
  - Donor/recipient info sections
  - Gift details (occasion, reason)
  - Items table with fair market value
  - Tax treatment notes
  - Authorization reference
- **`InventoryVoucher`** — 5 service IDs (20600–20604): Addition, Issue, Adjustment, Transfer, Damage/Write-off
  - Operation type-specific layouts
  - Source/destination warehouse info
  - Requesting department and project code
  - Items table with dynamic column headers per operation
  - Value impact summary
  - Adjustment reason (for adjustments)
  - Damage details (type, description, inspection, disposal, insurance claim)

#### New Models & Enums
- **`VoucherGiftData`** — gift data model with direction, donor/recipient, occasion, reason, fair market value, tax treatment, authorization
- **`VoucherInventoryData`** — inventory data model with operation type, warehouses, department, adjustment reason, damage type/description, inspection, disposal, insurance claim
- **`GiftDirection`** enum — received, given
- **`InventoryOperationType`** enum — addition, issue, adjustment, transfer, damage
- **`InventoryAdjustmentReason`** enum — physicalCount, dataEntryError, revaluation, reconciliation, systemCorrection, other
- **`InventoryDamageType`** enum — expired, broken, lost, obsolete, waterDamage, fireDamage, other
- **`GiftSignatories`** extension — donor, recipient, marketing
- **`InventorySignatories`** extension — warehouseManager, storekeeper, requestor, insuranceOfficer
- 2 new `VoucherCategory` values: `gift`, `inventory`
- 7 new `VoucherServiceId` entries (20500–20604)

#### Example
- `auxiliary_voucher_demo_builder.dart` — 5-voucher batch demo (received gift, given gift, inventory transfer, inventory damage with insurance claim, inventory adjustment)

---

## [3.3.0] - 2026-02-05

### Added

#### Trade Voucher Templates
- **`PurchaseVoucher`** — 4 service IDs (20000–20003): Cash Purchase, Credit Purchase, Advance Purchase, Installment Purchase
  - Supplier info, PO reference, items table with discount/tax columns
  - Invoice summary (subtotal, discount, taxable, VAT, grand total)
  - Payment terms per subtype (credit period, advance amount, installment schedule)
  - Warehouse receiving information
- **`SalesVoucher`** — 4 service IDs (20200–20203): Cash Sale, Credit Sale, Advance Sale, Installment Sale
  - Customer info, SO reference, salesperson
  - Items table, invoice summary, payment terms
  - Delivery information (method, shipping address, delivery date)
- **`PurchaseReturnVoucher`** — 4 service IDs (20400–20403): Cash/Credit/Advance/Installment Purchase Return
  - Original purchase reference, return reason badge
  - Returned items table, return summary
  - Refund/settlement block per subtype (cash refund, liability reduction, advance refund, installment adjustment)
  - Quality inspection and warehouse info
- **`SalesReturnVoucher`** — 4 service IDs (20450–20453): Cash/Credit/Advance/Installment Sales Return
  - Original sale reference, return reason badge
  - Returned items table, return summary
  - Refund/settlement block per subtype (cash refund, receivable reduction, customer refund, installment adjustment)

#### New Models & Enums
- **`VoucherTradeData`** — comprehensive trade data model with order reference, summary calculations, payment terms, warehouse, delivery, and return-specific fields
- **`VoucherReturnReason`** enum — defective, wrongItem, qualityIssue, orderCancellation, overDelivery, other
- **`TradeSignatories`** extension — purchasing, salesDept, warehouseKeeper, qualityInspector, customer, supplier
- 4 new `VoucherCategory` values: `purchase`, `sales`, `purchaseReturn`, `salesReturn`
- 16 new `VoucherServiceId` entries (20000–20453)

#### Example
- `trade_voucher_demo_builder.dart` — 4-voucher batch demo (credit purchase with 4 items, cash sale with delivery, cash purchase return with defective reason, credit sales return with cancellation)

---

## [3.2.0] - 2026-02-05

### Added

#### Remittance Voucher Templates (v3.2.0)

Extends the voucher system with 2 new remittance template classes covering 8 service IDs for domestic and international, personal and commercial money transfers. Includes sender/beneficiary info blocks, currency exchange details, fee breakdowns, compliance/AML fields, and tracking references.

**New Service IDs:**
- `VoucherServiceId.domesticPersonalOutgoing` (10400) — Personal remittance within the country
- `VoucherServiceId.domesticCommercialOutgoing` (10401) — Commercial remittance within the country
- `VoucherServiceId.internationalPersonalOutgoing` (10500) — Personal remittance abroad
- `VoucherServiceId.internationalCommercialOutgoing` (10501) — Commercial remittance abroad
- `VoucherServiceId.domesticPersonalIncoming` (10450) — Personal remittance received locally
- `VoucherServiceId.domesticCommercialIncoming` (10451) — Commercial remittance received locally
- `VoucherServiceId.internationalPersonalIncoming` (10550) — Personal remittance from abroad
- `VoucherServiceId.internationalCommercialIncoming` (10551) — Commercial remittance from abroad

**New Template Classes:**
- `RemittanceOutgoingVoucher` — Outgoing remittance vouchers with sender info, beneficiary info (bank/SWIFT/correspondent bank for international), currency exchange details, fees breakdown, compliance/AML section, and tracking number with expected delivery
- `RemittanceIncomingVoucher` — Incoming remittance vouchers with sender info, beneficiary info, exchange details for international transfers, receiving fees, and disbursement method display

**New Data Model:**
- `VoucherRemittanceData` — Comprehensive remittance data with sender/beneficiary details (name, ID, phone, address, country), bank routing (account, IBAN, SWIFT, correspondent bank), currency exchange (source/target currency, rate, amounts), fees (transfer fee, exchange margin, total cost), compliance (purpose code, AML reference), and tracking (tracking number, expected delivery, disbursement method)

**New Voucher Categories:**
- `VoucherCategory.remittanceOutgoing` — Outgoing Remittances / حوالات صادرة
- `VoucherCategory.remittanceIncoming` — Incoming Remittances / حوالات واردة

**New Signatories:**
- `RemittanceSignatories.sender()` — Sender / المرسل
- `RemittanceSignatories.beneficiary()` — Beneficiary / المستفيد
- `RemittanceSignatories.complianceOfficer()` — Compliance Officer / مسؤول الامتثال

**Example:**
- `buildRemittanceVoucherDemoReport()` — Demo generating 4 remittance vouchers (domestic outgoing, international outgoing, domestic incoming, international incoming) in one batch PDF
- Remittance Vouchers card added to Examples Showcase screen

---

## [3.1.0] - 2026-02-05

### Added

#### Banking Voucher Templates (v3.1.0)

Extends the voucher system with 4 new banking template classes covering 15 service IDs. All templates support bilingual RTL/LTR layouts, batch PDF generation, and the full voucher styling system.

**New Service IDs:**
- `VoucherServiceId.cashDeposit` (10000) — Cash deposit into bank account
- `VoucherServiceId.checkDeposit` (10001) — Check deposit into bank account
- `VoucherServiceId.electronicDeposit` (10002) — Electronic transfer deposit
- `VoucherServiceId.cashWithdrawal` (10100) — Cash withdrawal from bank account
- `VoucherServiceId.checkWithdrawal` (10101) — Withdrawal via issued check
- `VoucherServiceId.atmWithdrawal` (10102) — ATM withdrawal
- `VoucherServiceId.bankTransfer` (10200) — Bank-to-bank transfer
- `VoucherServiceId.interAccountTransfer` (10201) — Transfer between own accounts
- `VoucherServiceId.electronicTransfer` (10202) — Electronic platform transfer
- `VoucherServiceId.currencyExchange` (10203) — Foreign exchange transaction
- `VoucherServiceId.utilityBillPayment` (10300) — Electricity, water, gas, phone
- `VoucherServiceId.generalBillPayment` (10301) — Miscellaneous bills and dues
- `VoucherServiceId.internetBillPayment` (10302) — Internet service bills
- `VoucherServiceId.telecomRecharge` (10303) — Mobile operator packages
- `VoucherServiceId.gameRecharge` (10304) — Gaming platform credit
- `VoucherServiceId.entertainmentRecharge` (10305) — Streaming subscriptions

**New Template Classes:**
- `BankDepositVoucher` — Bank deposit vouchers with denomination breakdown table for cash deposits, check details for check deposits, and electronic transfer references
- `BankWithdrawalVoucher` — Bank withdrawal vouchers with authorized person info, ATM location/card details, and check withdrawal support
- `TransferVoucher` — Transfer vouchers with source/destination account blocks, beneficiary info, fees/commission, net amount calculation, and currency exchange support
- `BillPaymentVoucher` — Bill payment vouchers with service provider info, subtype-specific bill details (meter readings, consumption, plans, mobile numbers), and confirmation references

**New Data Models:**
- `VoucherBankInfo` — Bank account information (name, branch, account number, IBAN, SWIFT, currency, balance)
- `VoucherTransferData` — Transfer details (source/destination accounts, beneficiary, fees, net amount, platform)
- `VoucherBillData` — Bill payment details (provider, subscriber, billing period, meter, consumption, plan, mobile, confirmation)
- `BankingSignatories` — Extension with factory methods: `depositor`, `bankTeller`, `requester`, `treasury`, `authorizedSignatory`, `operator`

**New Voucher Categories:**
- `VoucherCategory.bankDeposit` — Bank Deposits / إيداعات بنكية
- `VoucherCategory.bankWithdrawal` — Bank Withdrawals / سحوبات بنكية
- `VoucherCategory.transfer` — Transfers / التحويلات
- `VoucherCategory.billPayment` — Bill Payments / دفع الفواتير

**New Payment Method:**
- `VoucherPaymentMethod.currencyExchange` — Currency exchange with source/target currency, exchange rate, and fee

**Example:**
- `buildBankingVoucherDemoReport()` — Demo generating 4 banking vouchers in one batch PDF (cash deposit, check withdrawal, bank transfer, utility bill)
- Banking Vouchers card added to Examples Showcase screen

---

## [3.0.0] - 2026-02-04

### Added

#### Service Voucher Template System (v3.0.0)

A comprehensive, bilingual (Arabic/English) service voucher system for generating professional financial documents. All vouchers support RTL/LTR layouts, multi-voucher batch PDFs, and customizable styling.

**Core Models:**
- `VoucherServiceId` — Enum of 17 service IDs across 4 categories: Accounting Entries (00001–00004), Receipt Vouchers (00100–00103), Payment Vouchers (00200–00203), Tax Vouchers (00300–00304)
- `VoucherCategory` — Categorizes vouchers: `accountingEntry`, `receipt`, `payment`, `tax`
- `VoucherData` — Core data model with voucher number, date, amount, currency, party, payment details, line items, account entries, signatories, and custom fields
- `VoucherParty` — Party information with bilingual name, code, VAT number, address, phone, bank details
- `VoucherLineItem` — Line item with quantity, unit price, discount, tax, and total
- `VoucherAccountEntry` — Accounting allocation with account code, cost center, debit/credit amounts
- `VoucherPaymentDetails` — Payment method details (cash, bank transfer, check, electronic) with method-specific fields
- `VoucherSignatory` — Signatory block with factory constructors: `preparedBy`, `reviewedBy`, `approvedBy`, `receivedBy`, `cashier`, `accountant`, `manager`
- `VoucherTaxData` — Tax-specific data for income tax, VAT, government fees, customs duty, tax settlement
- `VoucherPaymentMethod` — Payment method enum: `cash`, `bankTransfer`, `check`, `electronic`, `installment`
- `VoucherCopyType` — Copy type enum: `original`, `copy`, `duplicate`
- `VoucherTaxType` — Tax type enum: `incomeTax`, `vat`, `governmentFee`, `customsDuty`, `taxSettlement`

**Styling:**
- `GeniusPdfVoucherStyle` — Full style configuration with colors, typography, layout, and options
- Factory styles: `.standard()`, `.formal()`, `.minimal()`, `.financial()`, `.government()`
- `copyWith()` method for easy customization

**Utilities:**
- `AmountToWords` — Converts numeric amounts to Arabic and English words
- `CurrencyInfo` — Currency data for 11 currencies: SAR, USD, EUR, GBP, AED, KWD, QAR, BHD, OMR, EGP, JOD
- Proper Arabic grammar for thousands/millions/billions

**Template Classes:**
- `GeniusPdfVoucherTemplate` — Abstract base class with shared drawing methods: header, title, voucher info, party info, payment details, account entries table, items table, amount block, amount in words, notes, signatures, footer
- `AccountingEntryVoucher` — For service IDs 00001–00004 (Simple Entry, Compound Entry, Opening Entry, Adjusting Entry)
- `ReceiptVoucher` — For service IDs 00100–00103 (Cash Receipt, Bank Transfer Receipt, Check Receipt, Electronic Receipt)
- `PaymentVoucher` — For service IDs 00200–00203 (Cash Payment, Bank Transfer Payment, Check Payment, Electronic Payment) with deduction support via `PaymentDeduction`
- `TaxVoucher` — For service IDs 00300–00304 (Income Tax, VAT, Government Fees, Customs Duty, Tax Settlement) with type-specific calculation tables

**Batch Generation:**
- `GeniusPdfVoucherBatch` — Combine multiple vouchers into a single PDF document
- `GeniusPdfVoucherBatchOptions` — Configure page breaks, batch summary page, batch title
- Summary page with voucher list table and grand total

**Example:**
- `buildVoucherDemoReport()` — Demo function generating 5 different vouchers in one batch PDF
- Service Vouchers card added to Examples Showcase screen

---

## [2.12.8] - 2026-02-04

### Removed

#### Chart Components Removed

All chart components have been removed from the library. The charts functionality was causing system freezes and instability issues. Users who need chart functionality should use external charting libraries and render them to images before embedding in PDFs.

**Removed Components:**
- `GeniusPdfBarChart` — Bar chart component
- `GeniusPdfLineChart` — Line chart component
- `GeniusPdfPieChart` — Pie chart component
- `GeniusPdfAreaChart` — Area chart component
- `chart_models.dart` — All chart data models (`GeniusChartDataPoint`, `GeniusChartSeries`, `GeniusChartAxis`, `GeniusChartLegend`, `GeniusChartStyle`, `GeniusChartColors`, `GeniusChartDataGroup`, `GeniusChartLayoutConfig`, `GeniusChartDimensionCalculator`)
- Chart settings classes (`GeniusBarChartSettings`, `GeniusLineChartSettings`, `GeniusPieChartSettings`, `GeniusAreaChartSettings`)
- Chart type enums (`GeniusBarChartType`, `GeniusLineChartType`, `GeniusChartLegendPosition`, `GeniusChartLegendOrientation`)

**Removed Builder Methods:**
- `addBarChart()` — Removed from `GeniusPdfDocumentBuilder`
- `addLineChart()` — Removed from `GeniusPdfDocumentBuilder`
- `addPieChart()` — Removed from `GeniusPdfDocumentBuilder`
- `addAreaChart()` — Removed from `GeniusPdfDocumentBuilder`

**Removed Composer Methods:**
- `barChart()` — Removed from `GeniusPdfReportComposer`
- `lineChart()` — Removed from `GeniusPdfReportComposer`
- `pieChart()` — Removed from `GeniusPdfReportComposer`
- `areaChart()` — Removed from `GeniusPdfReportComposer`

**Removed from Smart Layout Engine:**
- `chart` element type removed from `GeniusLayoutElementType` enum

**Migration Guide:**

If you need charts in your PDFs, consider these alternatives:
1. Use Flutter's `fl_chart` or `syncfusion_flutter_charts` to render charts as widgets
2. Convert the chart widget to an image using `RepaintBoundary`
3. Embed the image in your PDF using `addImage()` or `addImageFromBytes()`

Example migration:
```dart
// Before (removed)
// builder.addBarChart(myChart, height: 200);

// After (use image instead)
final chartImage = await chartWidgetToImage(myChartWidget);
builder.addImageFromBytes(chartImage, height: 200);
```

---

## [2.12.7] - 2026-02-03

### Fixed

#### Report Header RTL Bilingual Layout Bug

- **Bilingual split layout RTL fix** — Fixed critical bug where bilingual split headers displayed merged/overlapping text when `isRTL = true`. The issue was caused by alignment calculations using the global RTL flag instead of explicit directional alignment for each language column.
- **`_drawCompanyInfoBlockExplicit()` method added** — New internal method that accepts explicit `PdfTextAlignment` and `PdfTextDirection` parameters for precise control over text positioning in bilingual layouts.
- **English column now always left-aligned with LTR direction** — Regardless of global RTL setting.
- **Arabic column now always right-aligned with RTL direction** — Regardless of global RTL setting.

### Added

#### Header Info Groups for Structured Content

- **`GeniusPdfHeaderInfoGroup` class** — New model for organizing header information into logical groups (registration, contact, address, etc.).
- **`GeniusPdfHeaderInfoGroup.registration()` factory** — Creates a group with VAT, CR, and license number items.
- **`GeniusPdfHeaderInfoGroup.contact()` factory** — Creates a group with phone, email, website, and fax items.
- **`GeniusPdfHeaderInfoGroup.address()` factory** — Creates a group with street, city, country, and postal code.
- **`GeniusPdfHeaderInfoGroup.custom()` constructor** — Creates a custom group with any items and optional title.
- **`GeniusPdfHeaderInfoItem` class** — Label-value pair with bilingual support and optional color/icon.
- **`infoGroups` parameter on `GeniusPdfReportHeader`** — Accepts a list of info groups for structured display.
- **`_drawInfoGroups()` and `_drawInfoGroupsExplicit()` methods** — Renders info groups with proper alignment.

#### Layout Dimension Calculator

- **`GeniusPdfHeaderLayoutCalculator` class** — Utility for calculating optimal column widths and element heights.
- **`calculateBilingualColumns()` method** — Returns left, center, right widths for bilingual layouts.
- **`calculateStandardColumns()` method** — Returns logo and content widths for standard layouts.
- **`estimateTextHeight()` method** — Estimates height based on line count and font size.
- **`layoutCalculator` parameter on `GeniusPdfReportHeader`** — For advanced positioning control.

### Changed

- **`_drawBilingualSplitLayout()` rewritten** — Now uses `_drawCompanyInfoBlockExplicit()` with explicit alignment parameters to ensure correct column positioning regardless of global RTL setting.

### Example

```dart
// Bilingual split header (now works correctly in both RTL and LTR modes)
GeniusPdfReportHeader.bilingualSplit(
  config: config,  // Can be RTL or LTR
  title: 'Trial Balance',
  titleAr: 'ميزان المراجعة',
  company: companyInfo,
  date: DateTime.now(),
);

// Header with info groups
GeniusPdfReportHeader(
  config: config,
  title: 'Annual Report',
  titleAr: 'التقرير السنوي',
  company: companyInfo,
  infoGroups: [
    GeniusPdfHeaderInfoGroup.registration(
      vatNumber: '300123456789003',
      crNumber: '1010123456',
    ),
    GeniusPdfHeaderInfoGroup.contact(
      phone: '+966 11 123 4567',
      email: 'info@company.com',
    ),
  ],
  style: GeniusPdfReportHeaderStyle.corporate(),
);

// Custom info group with title
GeniusPdfHeaderInfoGroup.custom(
  title: 'Bank Details',
  titleAr: 'تفاصيل البنك',
  showTitle: true,
  items: [
    GeniusPdfHeaderInfoItem(
      label: 'Bank',
      labelAr: 'البنك',
      value: 'Al Rajhi Bank',
    ),
    GeniusPdfHeaderInfoItem(
      label: 'IBAN',
      labelAr: 'الآيبان',
      value: 'SA0380000000608010167519',
    ),
  ],
);
```

---

## [2.12.6] - 2026-02-03

### Added

#### Enhanced Chart Components with Groups and Accurate Dimension Calculations

- **`GeniusChartDataGroup` model** — New class for organizing chart data points into logical groups. Each group can have a bilingual name, custom color, and optional header background color.
- **`GeniusChartDataGroup.highlighted()` factory** — Creates a group with a grey highlighted header background.
- **`GeniusChartDataGroup.income()` factory** — Creates a group with a green-tinted header for revenue/income data.
- **`GeniusChartDataGroup.expense()` factory** — Creates a group with a red-tinted header for expense/cost data.
- **`groups` parameter on all chart types** — `GeniusPdfBarChart`, `GeniusPdfLineChart`, `GeniusPdfPieChart`, and `GeniusPdfAreaChart` now accept a `groups` parameter for grouped data visualization.
- **`GeniusChartLayoutConfig` class** — New configuration class for controlling chart layout dimensions with factories:
  - `.standard()` — Default balanced layout
  - `.compact()` — Smaller margins for tight spaces
  - `.spacious()` — Larger margins for detailed charts
- **`GeniusChartDimensionCalculator` utility** — Helper class for accurate chart dimension calculations based on content and font sizes.
- **`layoutConfig` parameter on all charts** — All chart types now accept a `GeniusChartLayoutConfig` for precise control over spacing and margins.

### Changed

- **Axis label width calculation improved** — Now calculates width based on actual value string length and font size instead of fixed hardcoded values.
- **Plot area calculation rewritten** — Uses `GeniusChartLayoutConfig` multipliers and clamp values for adaptive sizing.
- **Value label positioning improved** — Uses `layoutConfig.valueLabelOffset` for consistent spacing above bars/points.
- **Group separator rendering** — Draws vertical lines between groups with configurable width via `layoutConfig.groupSeparatorWidth`.
- **Group header backgrounds** — Groups with `headerBackgroundColor` now render colored rectangles behind group labels.

### Example

```dart
// Bar chart with grouped data
GeniusPdfBarChart(
  title: 'Sales by Quarter',
  series: const [],
  groups: [
    GeniusChartDataGroup.income(
      name: 'Q1 2026',
      nameAr: 'ر١ ٢٠٢٦',
      dataPoints: [
        GeniusChartDataPoint(label: 'Electronics', value: 125),
        GeniusChartDataPoint(label: 'Clothing', value: 85),
      ],
    ),
    GeniusChartDataGroup.expense(
      name: 'Q2 2026',
      nameAr: 'ر٢ ٢٠٢٦',
      dataPoints: [
        GeniusChartDataPoint(label: 'Electronics', value: 145),
        GeniusChartDataPoint(label: 'Clothing', value: 95),
      ],
    ),
  ],
  layoutConfig: GeniusChartLayoutConfig.standard(),
);

// Compact layout for small charts
GeniusPdfLineChart(
  title: 'Quick View',
  series: [...],
  layoutConfig: GeniusChartLayoutConfig.compact(),
);
```

---

## [2.12.5] - 2026-02-03

### Added

#### Enhanced Summary Sections with Groups and Accurate Layout

- **`GeniusPdfSummaryGroup` model** — New class for organizing summary items into logical groups within a section. Each group can have a bilingual title, custom header styling, and optional background color for the header row.
- **`GeniusPdfSummaryGroup.highlighted()` factory** — Creates a group with a grey highlighted header background.
- **`GeniusPdfSummaryGroup.income()` factory** — Creates a group with a green-tinted header for revenue/income items.
- **`GeniusPdfSummaryGroup.expense()` factory** — Creates a group with a red-tinted header for expense/deduction items.
- **`groups` parameter on `GeniusPdfSummarySection`** — Accepts a list of `GeniusPdfSummaryGroup` for grouped summary display with group headers rendered between items.
- **Separator line rendering** — When `style.showSeparatorLine` is true, horizontal lines are now drawn between items using `separatorLineColor` and `separatorLineWidth`.
- **`highlightTextColor` applied to total rows** — Highlighted/total items now use `style.highlightTextColor` when set.
- **Indent support** — Items with `indent > 0` now have their label X position shifted by `indent * style.indentWidth`.
- **`labelValueGap` applied** — The gap between label and value columns is now respected in width calculations.
- **`customHeight` per item** — Items with `customHeight` set now use that value instead of calculated height.
- **`totalLabelStyle` / `totalValueStyle`** — Bold/total items now use dedicated total styles when provided in the style configuration.

### Changed

- **Row height calculation rewritten** — `_calculateContentHeight()` now computes accurate heights by:
  - Using per-item `customHeight` when set
  - Calculating effective font size from `item.labelFontSize` / `item.valueFontSize` with fallback to style defaults
  - Applying 1.4x multiplier for line height
  - Accounting for group headers when groups are present
  - Including title height with proper style resolution
- **Group header rendering** — New `_drawGroupHeader()` method renders group titles with optional background color and custom text style.
- **Unified rendering via `_RenderableItem`** — Internal class consolidates items and group headers into a single render list for consistent spacing and separator handling.

### Example

```dart
// Summary with income and expense groups
GeniusPdfSummarySection(
  title: 'Financial Summary',
  titleAr: 'الملخص المالي',
  groups: [
    GeniusPdfSummaryGroup.income(
      title: 'Revenue',
      titleAr: 'الإيرادات',
      items: [
        GeniusPdfSummaryItem(label: 'Sales', value: '50,000'),
        GeniusPdfSummaryItem(label: 'Services', value: '15,000'),
        GeniusPdfSummaryItem.subtotal(label: 'Total Revenue', value: '65,000'),
      ],
    ),
    GeniusPdfSummaryGroup.expense(
      title: 'Expenses',
      titleAr: 'المصروفات',
      items: [
        GeniusPdfSummaryItem(label: 'Cost of Goods', value: '25,000'),
        GeniusPdfSummaryItem(label: 'Operating', value: '10,000'),
        GeniusPdfSummaryItem.subtotal(label: 'Total Expenses', value: '35,000'),
      ],
    ),
  ],
  items: [
    GeniusPdfSummaryItem.total(label: 'Net Profit', value: '30,000'),
  ],
  style: GeniusPdfSummaryStyle.invoice(),
);

// Indented hierarchical summary
GeniusPdfSummarySection(
  items: [
    GeniusPdfSummaryItem(label: 'Total Revenue', value: '100,000'),
    GeniusPdfSummaryItem(label: 'Product Sales', value: '80,000', indent: 1),
    GeniusPdfSummaryItem(label: 'Service Revenue', value: '20,000', indent: 1),
    GeniusPdfSummaryItem.total(label: 'Net Income', value: '100,000'),
  ],
  style: GeniusPdfSummaryStyle.bordered(),
);
```

---

## [2.12.2] - 2026-02-02

### Added

#### Customizable Grid Styles with `primaryColor`

- **5 new `GeniusPdfGridStyle` factories** — `striped()`, `dark()`, `elegant()`, `pastel()`, `bordered()` — each with a `primaryColor` parameter that drives all header, border, total row, and group header colors.
- **`primaryColor` added to all existing style factories** — `modern()`, `classic()`, `minimal()`, and `invoice()` now accept an optional `primaryColor` parameter. Colors for header backgrounds, borders, total rows, and group headers are automatically derived from the primary color using alpha blending.

### Changed

- **`GeniusPdfGridStyle.modern()` and `.classic()` converted from `const` to `factory`** — Necessary to support `primaryColor` parameter. All call sites updated to remove `const` keyword.
- **`GeniusPdfGridStyle.minimal()` renamed `accentColor` to `primaryColor`** — For consistent API across all styles.

### Style Reference

| Style | Default primaryColor | Description |
|-------|---------------------|-------------|
| `modern` | `#1565C0` (Blue) | Bottom-border header, no vertical lines |
| `classic` | `#333333` (Dark Grey) | All borders, traditional grid |
| `corporate` | `#1565C0` (Blue) | Filled header, professional look |
| `minimal` | `#424242` (Grey) | Top/bottom borders only, clean |
| `saudi` | `#006C35` (Green) | Saudi-themed with green accents |
| `invoice` | `#555555` (Grey) | Financial grid with outer border |
| `striped` | `#37474F` (Blue Grey) | Strong alternating rows, no borders |
| `dark` | `#263238` (Dark Slate) | Dark header/footer with white text |
| `elegant` | `#5D4037` (Brown) | Horizontal rules, no grid lines |
| `pastel` | `#7E57C2` (Purple) | Soft pastel tints, light borders |
| `bordered` | `#1B5E20` (Green) | Strong borders, filled header |

### Example

```dart
// Use any style with a custom primary color
GeniusPdfGridStyle.striped(primaryColor: Color(0xFF00897B))  // Teal striped
GeniusPdfGridStyle.dark(primaryColor: Color(0xFF1A237E))      // Indigo dark
GeniusPdfGridStyle.elegant(primaryColor: Color(0xFF5D4037))   // Brown elegant
GeniusPdfGridStyle.pastel(primaryColor: Color(0xFF7E57C2))    // Purple pastel
GeniusPdfGridStyle.bordered(primaryColor: Color(0xFF2E7D32))  // Green bordered

// Existing styles with custom colors
GeniusPdfGridStyle.modern(primaryColor: Color(0xFFD84315))    // Orange modern
GeniusPdfGridStyle.classic(primaryColor: Color(0xFF3F51B5))   // Indigo classic
GeniusPdfGridStyle.invoice(primaryColor: Color(0xFFC62828))   // Red invoice
```

---

## [2.12.1] - 2026-02-02

### Fixed

- Fixed `DataGridDemoBuilder` example: added missing required `rows: const []` parameter to parent `GeniusPdfGridGroup` with subgroups.
- Removed invalid `level` parameter from `GeniusPdfGridGroup.withSummary()` factory calls (parameter only exists on the main constructor).

---

## [2.12.0] - 2026-02-02

### Added

#### Enhanced Data Grid — Column Widths, Multiple Totals & Groups

- **`widthPercent` on `GeniusPdfGridColumn`** — Set column width as a percentage of the available page width (0.0–1.0). Takes priority over `flexFactor`. Example: `widthPercent: 0.30` allocates 30% of grid width.
- **`footerRows` on `GeniusPdfDataGrid`** — Explicit footer/total rows appended after all data rows. Accepts a `List<GeniusPdfGridRow>` for subtotal, tax, discount, and grand total rows.
- **`autoTotals` on `GeniusPdfDataGrid`** — Auto-calculated total rows using `GeniusPdfAutoTotal`. Supports sum, average, count, min, max, and custom calculations.
- **`GeniusPdfAutoTotal` model** — Defines an auto-calculated total row with factories: `.sum()`, `.average()`, `.count()`, `.min()`, `.max()`, `.custom()`. Each can specify label, label column, target columns, style, and extra cells.
- **`GeniusPdfTotalType` enum** — Calculation types: `sum`, `average`, `count`, `min`, `max`, `custom`.
- **Recursive subgroup rendering** — `GeniusPdfGridGroup.subgroups` are now rendered recursively with proper level-based indentation and per-group summaries.
- **Multiple summaries per group** — Groups now render both `summary` (primary) and `summaries` (additional) rows when `showSummary` is true.
- **`GeniusDataGridUtils.autoGroup()`** — Automatically groups flat row data by a column value, optionally computing subtotals for each group.
- **`GeniusDataGridUtils.invoiceTotals()`** — Creates standard invoice footer rows (subtotal, discount, tax, grand total) from a subtotal amount.
- **`PdfDataGridExtensions.invoice()`** — Factory that builds a complete invoice grid with column definitions and auto-calculated footer rows.
- **`_allDataRows` getter** — Collects all data rows across groups and subgroups for accurate auto-total calculations.

### Changed

- **Column width algorithm rewritten** — Replaced single-pass distribution with a multi-pass (up to 3 iterations) constraint redistribution algorithm. Columns clamped by min/max constraints return their excess width to the pool, which is then redistributed to unclamped columns.
- **RTL column ordering bug fixed** — The old algorithm reversed columns during width calculation (`cols.reversed`) but used direct indices in the redistribution pass, causing index mismatches. Width calculation now uses a consistent order; RTL mapping is applied only during cell population.
- **Percentage-based widths** — Columns with `widthPercent` are resolved in Pass 1 alongside fixed-width columns, before flex distribution.
- **Final width scaling** — After all passes, if total column widths deviate from available width by > 1px, columns are proportionally scaled to fit exactly, with rounding error absorbed by the last column.
- **`_clampWidth` uses both column and global constraints** — Applies `col.minWidth` / `col.maxWidth` with fallback to `style.minColumnWidth` / `style.maxColumnWidth`.
- **Group rendering refactored** — `_addGroupedRows` delegates to `_addGroup` which handles recursive subgroup traversal, header styling, and multiple summary rows.

### Example

```dart
// Multiple auto-calculated totals
final grid = GeniusPdfDataGrid(
  columns: columns,
  rows: dataRows,
  config: config,
  autoTotals: [
    GeniusPdfAutoTotal.sum(label: 'Total', labelAr: 'الإجمالي', labelColumnId: 'desc'),
    GeniusPdfAutoTotal.average(label: 'Average', labelAr: 'المتوسط', labelColumnId: 'desc'),
    GeniusPdfAutoTotal.count(label: 'Count', labelAr: 'العدد', labelColumnId: 'desc'),
  ],
  footerRows: [
    GeniusPdfGridRow.total({'desc': 'Grand Total', 'amount': grandTotal}),
  ],
);

// Percentage column widths
GeniusPdfGridColumn(id: 'name', title: 'Name', widthPercent: 0.40);
GeniusPdfGridColumn(id: 'price', title: 'Price', widthPercent: 0.25);

// Auto-grouping utility
final groups = GeniusDataGridUtils.autoGroup(
  rows: allRows,
  groupByColumn: 'department',
  sumColumns: ['salary'],
  summaryLabelColumnId: 'name',
);

// Nested subgroups
GeniusPdfGridGroup(
  title: 'Electronics',
  subgroups: [
    GeniusPdfGridGroup.withSummary(title: 'Computers', rows: computerRows, sumColumns: ['total']),
    GeniusPdfGridGroup.withSummary(title: 'Accessories', rows: accessoryRows, sumColumns: ['total']),
  ],
  summary: GeniusPdfGridRow.total({'desc': 'Electronics Total', 'total': 33000}),
);
```

---

## [2.11.0] - 2026-02-02

### Added

#### PdfTextWebLink Integration & Rich Text Improvements

- **`PdfTextWebLink` for hyperlinks** — Link spans now use Syncfusion's `PdfTextWebLink` instead of manual `PdfUriAnnotation`, producing proper clickable hyperlinks with built-in annotation handling
- **`GeniusPdfTextSpan.webLink` factory** — New constructor for creating web link spans: `GeniusPdfTextSpan.webLink('Click here', url: 'https://example.com')`
- **`GeniusPdfRichTextBuilder.webLink()` method** — Fluent builder method for adding web links: `.webLink('Google', 'https://google.com')`
- **`String.toWebLinkSpan()` extension** — Quick conversion from String to web link span: `'Click'.toWebLinkSpan('https://example.com')`
- **Font size caching** — Sized fonts are cached by style+size key to avoid repeated `PdfTrueTypeFont` construction

### Changed

- **`_resolveSizedFont()` replaces `_resolveFont()` in draw/layout** — When `span.fontSize` is set or superscript/subscript scaling applies, a correctly sized font is now created from config font bytes, ensuring text renders at the intended size
- **Drawing bounds use calculated padding** — Replaced magic `drawWidth + 10` constant with `drawWidth + letterSpacing * textLength + 2` for accurate text bounds
- **Trailing whitespace trimming** — `flushLine()` now trims trailing whitespace from the last segment on each line, preventing extra width at line boundaries
- **Background X clamped** — `drawX - backgroundPadding` is now clamped to `>= 0` to prevent background rectangles from extending outside the page

### Fixed

- **`_createLayoutResult` Y overshoot** — Previously drew a dummy element at `bounds.bottom`, causing `result.bounds.bottom` to overshoot by one font height. Now draws at `bounds.bottom - fontHeight` so the returned bounds are accurate
- **`span.fontSize` ignored during rendering** — Text was always rendered at the base font's built-in size regardless of `span.fontSize`. Now creates a properly sized font from config bytes
- **Superscript/subscript size not applied** — The `_scriptSizeRatio` scaling was calculated but never used to create a smaller font. Now uses `_resolveSizedFont()` which respects the scaling
- **Link underline double-drawn** — Manual underline decoration was drawn for link spans even though `PdfTextWebLink` renders its own underline. Now skips manual underline for `span.hasLink`
- **Line height 0 on empty newlines** — Flushing a newline line could produce height `0`. Now falls back to `_defaultLineHeight()` for empty lines

### Example

```dart
// Using PdfTextWebLink via the builder
final richText = GeniusPdfRichTextBuilder(config: config)
    .text('Visit ')
    .webLink('Google', 'https://www.google.com')
    .text(' or ')
    .webLink('GitHub', 'https://github.com', color: Color(0xFF6E5494))
    .text(' for more info.')
    .build();

// Using the factory directly
final spans = [
  GeniusPdfTextSpan('Read the '),
  GeniusPdfTextSpan.webLink('documentation', url: 'https://docs.example.com'),
];

// Using String extension
final span = 'Click here'.toWebLinkSpan('https://example.com');
```

---

## [2.10.0] - 2026-02-02

### Added

#### Smart Space Management in GeniusPdfDocumentBuilder

- **`_headerHeight` / `_footerHeight` tracking** — The builder now tracks header and footer template heights internally, deducting them from available page space automatically
- **`headerHeight` / `footerHeight` / `effectivePageHeight` getters** — Public read-only access to reserved header/footer space and the effective content area height
- **`reserveHeaderSpace(double)` / `reserveFooterSpace(double)`** — Manually reserve header/footer space for custom-drawn headers/footers without using `addHeader`/`addFooter`
- **Automatic page-break for all non-Grid methods** — `addSummary`, `addInfoBox`, `addRichText`, `addReportHeader`, `addBulletList`, `addDualInfoBox`, and `addSectionDivider` now call `_ensureSpace` before drawing, creating a new page automatically if the content doesn't fit
- **Footer-aware `remainingHeight`** — `remainingHeight` now subtracts `_footerHeight` to prevent content from overlapping the footer area
- **Header-offset new pages** — `newPage()` sets `currentY` to `_headerHeight` instead of `0`, so content never overlaps the header template

### Changed

- **`addHeader()` stores `_headerHeight`** — After creating the header template, the builder records its height and adjusts the current page's Y position
- **`addFooter()` stores `_footerHeight`** — After creating the footer template, the builder records its height for `remainingHeight` calculations
- **`newPage()` respects header height** — New pages start at `_headerHeight` instead of `0`
- **`generate()` respects header height** — Initial Y position is set to `_headerHeight`
- **`resetY()` defaults to header height** — Without arguments, resets to `_headerHeight` instead of `0`
- **`GeniusPdfReportComposer` applies header/footer before actions** — `withHeader()` and `withFooter()` now store parameters and apply them at the start of `build()`, ensuring `_headerHeight` and `_footerHeight` are available during all content rendering
- **`withFooter()` supports `qrCodeUrl` and `qrCodeSize`** — Previously missing QR code parameters are now available in the Composer's fluent API

### Fixed

- **Content overlapping footer** — Previously, `remainingHeight` did not account for footer space, causing content to render behind the footer template
- **Content overlapping header on new pages** — Previously, `newPage()` reset Y to `0`, causing content on continuation pages to render behind the header template
- **Composer header/footer timing** — `withHeader()` used to queue `addHeader()` as an action, meaning `_headerHeight` was `0` during early content rendering; now header/footer are applied first

### Example

```dart
class SmartLayoutReport extends GeniusPdfDocumentBuilder {
  SmartLayoutReport(super.config);

  @override
  void build() {
    // Header and footer reserve space automatically.
    addHeader(title: 'Monthly Report');
    addFooter(userName: 'Admin', showPageNumber: true);

    newPage(); // starts at headerHeight, not 0

    // These methods auto page-break if content won't fit:
    addReportHeader(myReportHeader, height: 100);
    addInfoBox(myInfoBox, spacing: 10);
    addSummary(mySummary, spacing: 10);
    addRichText(myRichText, spacing: 5);
    addBulletList(myBulletList, spacing: 10);
    addSectionDivider(title: 'Details');

    // Grid handles its own pagination — no auto page-break:
    addGrid(myGrid, spacing: 10);

    // remainingHeight correctly accounts for footer space.
    if (canFit(200)) {
      addBarChart(myChart, height: 200);
    }
  }
}
```

---

## [2.9.1] - 2026-02-02

### Added

#### GeniusPdfDocumentBuilder — Enhanced Component Methods

- **`addReportHeader(GeniusPdfReportHeader)`** — Draw a report header at the current Y position with automatic Y advancement
- **`addDualInfoBox(leftBox, rightBox)`** — Draw two info boxes side by side with equal or flexible heights
- **`addRichText(GeniusPdfRichText)`** — Draw rich text at the current Y position with auto advancement
- **`addBulletList(GeniusPdfBulletList)`** — Draw bullet lists at the current Y position
- **`addInfoBox(GeniusPdfInfoBox)`** — Draw an info box at the current Y position with automatic Y advancement

### Changed

- **Config-driven component settings** — `GeniusPdfRichTextBuilder` no longer accepts per-instance font/RTL overrides; fonts and direction now come from `GeniusPdfConfig`
- **Section constructor cleanup** — removed deprecated parameters from `GeniusPdfSection` in favor of `GeniusPdfSectionStyle`

### Example

```dart
class MyReportBuilder extends GeniusPdfDocumentBuilder {
  MyReportBuilder(super.config);

  @override
  void build() {
    newPage();
    
    addSectionDivider(title: 'Report Header');
    addSpace(10);
    
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Invoice',
        titleAr: 'فاتورة',
        company: companyInfo,
      ),
      spacing: 15,
    );
    
    addDualInfoBox(
      leftBox: customerBox,
      rightBox: companyBox,
      equalHeight: true,
      boxSpacing: 20,
      spacing: 10,
    );
    
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
        .text('Hello ')
        .bold('World')
        .build(),
      spacing: 5,
    );
    
    addBulletList(
      GeniusPdfBulletList(
        items: [
          GeniusPdfBulletItem.simple('First item'),
          GeniusPdfBulletItem.simple('Second item'),
        ],
        config: config,
      ),
      spacing: 10,
    );
    
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: 'Note',
        titleAr: 'ملاحظة',
        items: [...],
        style: GeniusPdfInfoBoxStyle.info(),
      ),
      spacing: 10,
    );
  }
}
```

---

## [2.9.0] - 2026-02-01

### Added

#### GeniusPdfReportComposer — Fluent API for Report Building

- **`GeniusPdfReportComposer`** — Concrete implementation of `GeniusPdfDocumentBuilder` with a chainable fluent API; no subclassing needed
- **Header/Footer**: `withHeader()`, `withReportHeader()`, `withFooter()` — Configure page headers and footers
- **Text**: `text()`, `boldText()`, `richText()` — Add text content with various styles
- **Layout**: `space()`, `line()`, `section()`, `page()` — Spacing, dividers, sections, and page breaks
- **Components**: `grid()`, `summary()`, `gridWithSummary()`, `reportSummary()`, `infoBox()`, `twoColumns()` — All builder components as chainable methods
- **Charts**: `barChart()`, `lineChart()`, `pieChart()`, `areaChart()` — Add charts with chaining
- **QR & Images**: `qrCode()`, `image()`, `imageAttachment()`, `imagePage()`, `attachments()` — QR codes and image attachments
- **Custom**: `custom()` — Execute arbitrary code within the fluent chain
- **`buildPdf()`** — Convenience method to generate and return PDF bytes
- **Example** — `buildComposerDemoReport()` in `example/lib/documents/` demonstrates a complete sales report using the fluent API

---

## [2.8.0] - 2026-02-01

### Added

#### GeniusPdfDocumentBuilder — Advanced Layout

- **`addRichText(GeniusPdfRichText)`** — Draw rich text (bold, colors, links, styled spans) at the current Y position with auto advancement
- **`addInfoBox(GeniusPdfInfoBox)`** — Draw an info box with labeled values at the current Y position; supports multi-column layouts
- **`addReportHeader(GeniusPdfReportHeader)`** — Draw a professional report header with company info, bilingual titles, and document metadata
- **`addTwoColumns()`** — Two-column layout with flexible width ratios; each column receives a callback with `(PdfPage, Rect)` and returns height
- **`setPageTemplate(PdfPageTemplateElement)`** — Set page-level stamps, watermarks, or template elements at top/bottom/left/right/stamp positions
- **Example** — `AdvancedLayoutDemoBuilder` in `example/lib/documents/` demonstrates all five advanced layout features

---

## [2.7.0] - 2026-02-01

### Added

#### GeniusPdfDocumentBuilder — QR Code & Image Attachments

- **`addQRCode(GeniusPdfQRCodeGenerator)`** — Draw a QR code at the current Y position with configurable size and alignment (start/center/end)
- **`addImageAttachment(GeniusPdfImage)`** — Draw a labeled image attachment inline with optional title, auto-scaling to page width
- **`addImagePage(GeniusPdfImage)`** — Add an image on a dedicated new page, scaled to fit the full content area (ideal for scanned documents)
- **`addAttachments(List<GeniusPdfImage>)`** — Batch-add multiple images, each on its own page, with optional per-image titles
- **Example** — `QRAttachmentsDemoBuilder` in `example/lib/documents/` demonstrates QR codes (URL, WiFi, vCard) and image attachments

---

## [2.6.0] - 2026-02-01

### Added

#### GeniusPdfDocumentBuilder — Charts Integration

- **`addBarChart(GeniusPdfBarChart)`** — Draw a bar chart at the current Y position with auto page-break and position advancement
- **`addLineChart(GeniusPdfLineChart)`** — Draw a line chart at the current Y position
- **`addPieChart(GeniusPdfPieChart)`** — Draw a pie chart at the current Y position
- **`addAreaChart(GeniusPdfAreaChart)`** — Draw an area chart at the current Y position
- **`_addChart()` internal helper** — Unified chart drawing with auto page-break, spacing, and logging
- **Example** — `ChartsInBuilderDemoBuilder` in `example/lib/documents/` demonstrates all four chart types with section dividers

---

## [2.5.0] - 2026-02-01

### Added

#### GeniusPdfDocumentBuilder — Grid & Summary Integration

- **`addGrid(GeniusPdfDataGrid)`** — Draw a data grid at the current Y position with automatic position advancement; supports Syncfusion's built-in pagination for multi-page grids
- **`addSummary(GeniusPdfSummarySection)`** — Draw a summary section at the current Y position with automatic position advancement
- **`addGridWithSummary()`** — Convenience method that draws a grid followed by its summary section in a single call; returns both results as a record
- **`addReportSummary()`** — Overall report summary with optional title/titleAr heading; useful for aggregating totals from multiple grids
- **`addSectionDivider()`** — Visual divider with optional centered title text; draws a line-title-line pattern or a plain horizontal line
- **Example** — `MultiGridSummaryDemoBuilder` in `example/lib/documents/` demonstrates multiple grids, per-grid summaries, section dividers, and an overall report summary

---

## [2.4.0] - 2026-02-01

### Added

#### GeniusPdfDocumentBuilder — Position Engine & Page Management

- **`_currentY` position tracker** — Independent Y-position tracking replaces the old `_spaceOffset` + `_layoutResult` combo; all draw methods now update `_currentY` automatically
- **`_ensureSpace(double needed)`** — Auto page-break: if the remaining vertical space is insufficient, a new page is created transparently
- **`_advanceY(double height)`** — Internal helper to move the Y position with debug logging
- **`remainingHeight` getter** — Returns the available vertical space on the current page
- **`canFit(double height)`** — Check whether content of a given height fits on the current page
- **`contentBounds` getter** — Returns a `Rect` from `(0, currentY)` to the bottom of the page
- **`resetY([double y = 0])`** — Reset the Y position (e.g., after custom absolute drawing)
- **`isLTR` / `isRTL` getters** — Convenience accessors for text direction from config
- **`pageCount` getter** — Returns the total number of pages created so far
- **`GeniusPdfImageAlignment` enum** — Direction-aware alignment: `start`, `center`, `end` (respects RTL/LTR)
- **`addImage()` alignment** — New `alignment` parameter for horizontal image positioning
- **`addImage()` spacing** — New `spacing` parameter for vertical space before the image
- **`addImage()` advancePosition** — Control whether `addImage()` advances `currentY` (default: `true`)
- **`addHorizontalLine()` spacing** — New `spacing` parameter (default: 5px) for vertical space before and after the line
- **`addHorizontalLine()` advancePosition** — Control whether the line advances `currentY` (default: `true`)
- **`addFooter()` userLabel** — Configurable label before the username (defaults to `'المستخدم : '` in RTL, `'User: '` in LTR)
- **`addFooter()` pageNumberFormat** — Configurable page number format string (default: `'{0}/{1}'`)
- **Logger integration** — All position changes and page-break events are logged via `GeniusPdfLogger.debug()`
- **Example** — `PositionTrackingDemoBuilder` in `example/lib/documents/` demonstrates all v2.4.0 features

### Fixed

- **`availableWidth` bug** — In portrait orientation, `availableWidth` incorrectly used `pageSize.height` instead of `pageSize.width`; now correctly calculates `pageSize.width - (margins.left + margins.right)`
- **`addImage()` not advancing position** — Images no longer leave `currentY` unchanged; subsequent content renders correctly below
- **`addHorizontalLine()` not advancing position** — Horizontal lines now advance `currentY` so following content doesn't overlap
- **`addFooter()` hardcoded Arabic** — Removed hardcoded `'المستخدم : '` string; now uses configurable `userLabel` parameter
- **`addFooter()` hardcoded time position** — Replaced `const Rect.fromLTWH(200, ...)` with dynamic `availableWidth * 0.35`

### Changed

- **`addLine()` uses `_ensureSpace`** — Text that overflows the page triggers an automatic page-break instead of drawing off-page
- **`newPage()` resets `_currentY`** — Consistent position tracking across page transitions
- **`addSpace()` uses `_advanceY`** — Spacing is tracked precisely in the position system
- **`addInlineText()` updates `_currentY`** — Inline text no longer leaves the position tracker stale

---

## [2.3.3+10] - 2026-01-31

### Added

#### GeniusPdfRichText — Enhanced Links & Auto-Detection

- **`GeniusPdfMarkdownConfig`** — New configuration class for parser with `linkColor`, `autoDetectUrls`, `autoDetectEmails`, `autoDetectPhones`, `autoLinkColor`
- **Auto-detect bare URLs** — `https://...`, `http://...`, `www.…` auto-converted to clickable link spans (opt-in via config)
- **Auto-detect emails** — `user@domain.com` auto-converted to `mailto:` link spans (opt-in via config)
- **Auto-detect phone numbers** — `+123-456-7890` auto-converted to `tel:` link spans (opt-in via config)
- **Inline hex color syntax** — `[text](url){#RRGGBB}` for per-link color in markdown
- **Configurable link color** — `GeniusPdfSimpleMarkdownParser.parse()` now accepts `config` parameter for link styling
- **`autoLinkColor`** — Separate color for auto-detected links vs explicit markdown links
- **Preset configs** — `GeniusPdfMarkdownConfig.defaultConfig` (auto-detect on) and `.noAutoDetect` (backward-compatible)

### Changed

- **`GeniusPdfSimpleMarkdownParser.parse()`** — Added optional `config` parameter (backward-compatible, defaults to no auto-detect)
- **`toLinkSpan()` extension** — Now accepts optional `color` parameter
- **`parseMarkdownSpans()` extension** — Now accepts optional `config` parameter
- **Two-pass parsing** — First pass handles markdown syntax, second pass auto-detects URLs/emails/phones in plain text only
- **Overlap resolution** — Auto-detected links properly de-duplicated (earlier/longer match wins)

---

## [2.3.3+9] - 2026-01-29

### Added

#### GeniusPdfReportHeader Overhaul

- **Direction-Aware Enums** - `GeniusPdfLogoPosition` now uses `start`, `end`, `center`, `centerTop`, `centerBottom`, `background` (resolves based on RTL/LTR)
- **Direction-Aware Title Alignment** - `GeniusPdfTitleAlignment` now uses `start`, `end`, `center` (resolves based on RTL/LTR)
- **Bilingual Split Layout** - New `GeniusPdfReportHeaderLayout.bilingualSplit` with English info on left, logo centered, Arabic info on right
- **`GeniusPdfReportHeader.bilingualSplit()` factory** - Pre-configured bilingual split header
- **`GeniusPdfReportHeaderStyle.bilingualSplit()` style preset** - Saudi-themed bilingual style
- **Alignment Helpers** - `_resolveTextAlignment()`, `_resolveLogoX()`, `_textFormat()` for direction-aware rendering
- **Logo Positions** - `centerBottom` for logo below content, `center` for horizontally centered logo
- **Background Logo** - Watermark-style logo rendering with transparency
- **Title Underline** - `showTitleUnderline`, `titleUnderlineColor`, `titleUnderlineWidth` properties
- **Date Spacing** - New `dateSpacing` property on style to control gap between date and border
- **Shadow Support** - `shadowEnabled`, `shadowColor`, `shadowOffset` properties
- **Logger Integration** - Debug logging for header draw operations

### Fixed

- **Border overlapping date** - Print date was drawn overlapping the bottom border line; now date is drawn above the border with proper `dateSpacing`
- **Logo position not applied** - `logoPosition` property was ignored in draw methods; now properly used to position logo via `_resolveLogoX()`
- **Title alignment not applied** - `titleAlignment` and `companyInfoAlignment` were ignored; now properly resolved via `_resolveTextAlignment()`

### Changed

- **Spacing improvements** - Proper spacing between logo/company info row, title section, subtitle section, and date/border
- **Extracted reusable helpers** - `_drawBackground`, `_drawDateSection`, `_drawBottomBorder`, `_drawCompanyInfoBlock`, `_drawTitleBlock`, `_drawSubtitleBlock`, `_drawDocumentInfo`
- **Layout enum expanded** - Added `bilingualSplit`, `letterhead`, `reportCard`, `minimal`, `fullWidth` values

---

## [2.3.3+8] - 2026-01-29

### Added

#### GeniusPdfInfoBox Overhaul

- **Status-Themed Style Presets** - 4 new factory constructors: `GeniusPdfInfoBoxStyle.info()`, `.warning()`, `.success()`, `.error()` with distinct colors and icons
- **New Style Factories** - `GeniusPdfInfoBoxStyle.corporate()`, `.minimal()`, `.saudi()`, `.invoice()` for professional presets
- **Item Separators** - `showItemSeparators`, `itemSeparatorColor`, `itemSeparatorWidth` properties on style
- **Min/Max Height** - `minHeight` and `maxHeight` constraints on `GeniusPdfInfoBoxStyle`
- **RTL-Aware Alignment** - `effectiveLabelAlign()` and `effectiveValueAlign()` methods auto-swap left↔right in RTL mode
- **copyWith()** - Full `copyWith()` on both `GeniusPdfInfoBoxStyle` and `GeniusPdfInfoBox`
- **Icon Rendering** - Actual PDF icon drawing using `PdfBitmap` with RTL-aware positioning (previously was a placeholder)
- **Subtitle Rendering** - New `subtitle` / `subtitleAr` support rendered below the title
- **Footer Rendering** - New `footerStyle` property with footer text drawing
- **Multi-Column Layout** - `columns` and `columnSpacing` properties for multi-column item arrangement
- **Shadow Drawing** - Box shadow support when `hasShadow` is enabled
- **Empty Item Handling** - `showEmptyItems` and `emptyItemPlaceholder` properties
- **Tag Support** - `tag` property for component identification

#### GeniusPdfInfoBox Factories

- `GeniusPdfInfoBox.company()` - Pre-configured company info box with name, VAT, CR, city, phone, email fields
- `GeniusPdfInfoBox.contact()` - Pre-configured contact info box with name, phone, email, address fields

#### GeniusPdfDualInfoBox Enhancements

- **equalHeight Implementation** - Pre-calculates both box heights and forces the max via `copyWith` on style's `minHeight`
- `GeniusPdfDualInfoBox.customerInvoice()` - Pre-configured customer + invoice dual box
- `GeniusPdfDualInfoBox.shippingBilling()` - Pre-configured shipping + billing dual box
- **Background Color** - `backgroundColor` property for combined area
- **Border Style** - `borderStyle` property for outer border
- **Padding & Alignment** - `padding` and `alignment` properties

#### GeniusPdfSection Enhancements

- New `GeniusPdfSectionStyle` class with `copyWith()` and factory constructors (`corporate`, `minimal`, `card`, `saudi`)
- `GeniusPdfSection.corporate()` and `GeniusPdfSection.card()` factory constructors
- Subtitle support, shadow support, title background, title underline
- `keepTogether`, `pageBreakBefore`, `minHeight`, `maxHeight` properties

### Fixed

- **Missing style presets** - `GeniusPdfInfoBoxStyle.info()` and `.warning()` were referenced in examples but didn't exist (compilation error)
- **Null-safety issues** - Removed all unnecessary `!` operators on non-nullable `baseFont` / `boldFont` fields
- **Color null-safety** - Added null-coalescing for `style.contentStyle.color` before `.withValues()` call
- **draw() wrong bounds** - `draw()` now returns actual drawn bounds instead of pre-calculated `boxBounds`
- **Unused variables** - Removed unused `graphics` variable in `_drawVertical` and `_drawDiagonal` methods
- **equalHeight not implemented** - `equalHeight` property in `GeniusPdfDualInfoBox` was declared but never used in draw methods

### Changed

- Logger integration added across all InfoBox, DualInfoBox, and Section components
- `GeniusPdfSection` old constructor parameters deprecated in favor of new `style` parameter

---

## [2.3.3+7] - 2026-01-29

### Added

#### Enhanced Logger System (`GeniusPdfLogger`)

- **Automatic Source Location** - Logger automatically detects caller file and line via `StackTrace.current`
  - Console output includes clickable `→ lib/src/xxx.dart:42` paths for IDE navigation
  - `GeniusSourceLocation` class with `file` and `line` properties
- **Enhanced Log Entries** - `GeniusLogEntry` now includes `location`, `duration`, and `data` fields
  - `format()` method produces human-readable output with timestamps and source locations
- **Performance Timers** - `startTimer(name)` / `stopTimer(name)` for measuring operation durations
  - Timer results logged with elapsed milliseconds
  - Used across job processing, export, and print operations
- **Configuration Enhancements**
  - `showLocation` flag to enable/disable source location in output (default: true)
  - `showTimestamp` flag to enable/disable timestamps in output (default: true)
  - `GeniusPdfLoggerConfig.enabled()` convenience constructor
  - `GeniusPdfLoggerConfig.errorsOnly()` convenience constructor
  - `configureFrom(GeniusPdfLoggerConfig)` method for simplified setup
- **Zero-Cost When Disabled** - Early return before any StackTrace parsing when logging is off
- **ANSI Color Improvements** - Gray for debug, cyan for info, yellow for warning, red for error

#### Library-Wide Logger Integration

- **Printing Module** - Logging in `GeniusPrinterService` (print, share, raster, save, cancel), `GeniusPrintPreview` (print, share, save actions)
- **Services Module** - Logging in `GeniusPdfService` (generate, merge, split, watermark, rotate, extract), `GeniusPdfGenerationManager` (add/process/cancel/pause/resume jobs), `GeniusPdfExportService` (export, batch export)
- **Components Module** - Logging in `GeniusPdfDataGrid` (grid drawing), `GeniusPdfRichText` (rich text drawing), `GeniusPdfBarcode` (barcode/QR generation with error logging)

### Changed

- `pdf_config.dart` now uses `GeniusPdfLogger.configureFrom(loggerConfig)` instead of manual parameter passing
- Replaced all `Logger()` (from `logger` package) usage in `pdf_service.dart` with `GeniusPdfLogger`
- Removed `logger` package dependency from `pubspec.yaml` (no longer needed)

---

## [2.3.3+6] - 2026-01-28

### Added

#### Rich Text Engine Overhaul (`GeniusPdfRichText`)

- **Background Color Rendering** - Background highlights now correctly draw behind text
  - `backgroundColor` property on spans is now fully rendered with configurable padding
  - `backgroundPadding` parameter on `GeniusPdfRichText` for control over highlight size
- **Strikethrough Rendering** - `isStrikethrough` now draws a line through the text center
- **Overline Decoration** - New `isOverline` property draws a line above text
- **Superscript/Subscript Positioning** - Proper font size scaling (65%) and Y-offset
  - Superscript: raised by 30% of line height
  - Subscript: lowered by 20% of line height
- **Letter & Word Spacing** - `letterSpacing` and `wordSpacing` now applied via `PdfStringFormat`
- **Opacity Support** - New `opacity` property (0.0–1.0) for transparent text
- **Italic Font Resolution** - New `italicFont` and `boldItalicFont` parameters on `GeniusPdfRichText`
- **Word-Level Line Wrapping** - Text now wraps at word boundaries, not just span boundaries
- **Paragraph Alignment** - New `GeniusPdfParagraphAlignment` enum (start, center, end)
- **Max Lines & Overflow** - `maxLines` parameter to limit rendered lines
  - `GeniusPdfTextOverflow.clip` - Cut off at bounds
  - `GeniusPdfTextOverflow.ellipsis` - Show "…" at the end of last visible line
- **Height Measurement** - `measureHeight(availableWidth)` to pre-calculate layout height
- **Fixed `_createLayoutResult`** - No longer uses hardcoded Helvetica; uses `baseFont` instead

#### New TextSpan Factories

- `GeniusPdfTextSpan.italic()` - Italic text
- `GeniusPdfTextSpan.boldItalic()` - Bold-italic text
- `GeniusPdfTextSpan.label()` - Form field label style (bold, 11pt, gray)
- `GeniusPdfTextSpan.currency()` - Currency formatting with optional symbol placement
- `GeniusPdfTextSpan.heading()` - Heading style (14pt bold)
- `GeniusPdfTextSpan.small()` - Caption/small text (8pt, gray)
- `GeniusPdfTextSpan.badge()` - Badge style with colored background and white text
- New properties: `wordSpacing`, `isOverline`, `opacity`, `textDirectionOverride`

#### Enhanced Builder (`GeniusPdfRichTextBuilder`)

- New text methods: `italic()`, `boldItalic()`, `highlight()`, `superscript()`, `subscript()`, `strikethrough()`, `code()`, `label()`, `heading()`, `small()`, `badge()`, `currency()`
- Spacing helpers: `tab()` (4 spaces), `separator()` (styled delimiter like " | ")
- Conditional methods: `addIf()`, `textIf()`, `boldIf()` - add spans conditionally
- `amount()` - auto-styles as positive (green) or negative (red) based on value
- State getters: `spanCount`, `isEmpty`, `isNotEmpty`
- `paragraphAlignment` parameter for center/end aligned text
- `build()` now accepts `maxLines` and `overflow` parameters

#### Bullet & Numbered Lists (`GeniusPdfBulletList`)

- **Bullet styles**: disc (•), circle (○), square (■), dash (–)
- **Numbered styles**: Arabic (1. 2. 3.), Arabic-Indic (١. ٢. ٣.), alphabetic (a. b. c.)
- **Nested sub-items** with automatic style cycling (disc → circle → dash)
- **Rich text items** via `GeniusPdfBulletItem.rich()` with span lists
- RTL support with proper marker and text positioning
- Configurable: `bulletColor`, `textColor`, `itemSpacing`, `indentWidth`, `startNumber`

#### Multi-Paragraph Component (`GeniusPdfParagraph`)

- Wraps multiple `GeniusPdfRichText` blocks with `paragraphSpacing`
- `firstLineIndent` for paragraph indentation
- `measureHeight()` to pre-calculate total height
- Automatic vertical overflow handling

#### Text Measurer (`GeniusPdfTextMeasurer`)

- `measureSpan()` - Measure a single span's Size
- `measureSpanWidth()` / `measureSpansWidth()` - Width calculations
- `measureRichTextHeight()` - Full rich text height at given width
- `fitsInSingleLine()` - Check if spans fit in one line
- `estimateLineCount()` - Estimate number of wrapped lines

#### Simple Markdown Parser (`GeniusPdfSimpleMarkdownParser`)

- `**bold**` → bold span
- `*italic*` → italic span
- `***bold italic***` → bold-italic span
- `~~strikethrough~~` → strikethrough span
- `==highlight==` → highlighted span
- `^superscript^` → superscript span
- `` `code` `` → code span
- `[text](url)` → link span

#### String Extensions (`GeniusPdfStringSpanExtension`)

- `toSpan()`, `toBoldSpan()`, `toItalicSpan()`, `toColoredSpan()`
- `toHighlightSpan()`, `toLinkSpan()`, `toBadgeSpan()`
- `toLabelSpan()`, `toHeadingSpan()`, `toSmallSpan()`
- `parseMarkdownSpans()` - Parse markdown string into spans

#### Labeled Value Enhancements (`GeniusPdfLabeledValue`)

- `GeniusPdfLabeledValue.positive()` - Green value styling
- `GeniusPdfLabeledValue.negative()` - Red value styling
- New `valueColor` property for explicit value coloring

### Fixed

- Background color on text spans was defined but never rendered
- Strikethrough decoration was defined but never drawn
- Superscript/subscript had no visual effect (no size reduction or positioning)
- Letter spacing property was ignored during drawing
- `_createLayoutResult` used hardcoded `PdfTrueTypeFont(geniusPdfConfig.baseFontBytes, 1)` instead of `baseFont`
- Multi-column `GeniusPdfKeyValueList` could crash when `startIndex >= items.length`
- **Duplicate `GeniusPrinterService` class** causing "name already defined" error — removed old version, kept enhanced version with share/raster/save methods
- **`GeniusPdfGridRow` missing properties** — `GeniusConditionalFormattingExtension.withFormatting()` used non-existent `type`, `spanColumns`, `customRenderer`, `isPageBreakBefore` — now uses `copyWith()`
- **`GeniusPdfGridRowType` undefined** — `GeniusDataGridUtils.calculateTotals/Averages` referenced non-existent enum — now uses `!row.isSpecialRow`
- **`imageQuality` parameter** — `GeniusExportPresets` used `imageQuality:` instead of `quality:` as named parameter
- Updated example screens (`components_demo_screen`, `custom_report_screen`, `job_manager_demo_screen`) to use new Rich Text features

### Example

```dart
// Fluent builder with new methods
final richText = GeniusPdfRichTextBuilder(baseFont: font, boldFont: boldFont)
  .heading('Invoice Summary')
  .newLine()
  .label('Total')
  .separator(': ')
  .currency('34,615.00', symbol: 'SAR')
  .space()
  .badge('PAID', backgroundColor: const Color(0xFF4CAF50))
  .newLine()
  .text('Previous: ')
  .strikethrough('28,500.00')
  .space()
  .positive('34,615.00')
  .superscript('*')
  .build(maxLines: 5, overflow: GeniusPdfTextOverflow.ellipsis);

// Bullet list with nested items
final list = GeniusPdfBulletList(
  items: [
    GeniusPdfBulletItem.simple('Revenue increased by 15%'),
    GeniusPdfBulletItem(text: 'Expenses', subItems: [
      GeniusPdfBulletItem.simple('Salaries: 45%'),
      GeniusPdfBulletItem.simple('Operations: 30%'),
    ]),
  ],
  style: GeniusPdfBulletStyle.disc,
  baseFont: font,
  boldFont: boldFont,
);

// Markdown to spans
final spans = 'This is **bold** and *italic* with `code`'.parseMarkdownSpans();

// String extensions
final span = 'Important'.toBoldSpan(color: const Color(0xFFC62828));

// Pre-measure before drawing
final measurer = GeniusPdfTextMeasurer(baseFont: font, boldFont: boldFont);
final fits = measurer.fitsInSingleLine(mySpans, pageWidth);
```

---

## [2.3.3+5] - 2026-01-28

### Added

#### PDF Manipulation (`GeniusPdfService`)

- **Merge PDFs** - Combine multiple PDF documents into one
  - `mergePdfs()` - Merge with configurable options
  - `GeniusPdfMergeResult` - Result with page count and file size
- **Split PDF** - Split a document into separate files
  - `splitPdf()` - Split by page ranges or page count
  - `GeniusPdfSplitResult` - Result with list of split documents
- **Extract Pages** - Extract specific pages from a document
  - `extractPages()` - Extract by page numbers or range
- **Add Watermark** - Add text watermark to pages
  - `addWatermark()` - Customizable text, position, opacity, rotation
- **Rotate Pages** - Rotate specific pages
  - `rotatePages()` - Rotate by 90, 180, or 270 degrees
- **PDF Info** - Get detailed document information
  - `getPdfInfo()` - Page count, size, title, author, dates
  - `GeniusPdfInfo` and `GeniusPdfMetadata` - Info classes
- **Batch Generation** - Generate multiple PDFs
  - `generateBatch()` - Generate with progress callbacks
- **Share with Options** - Enhanced sharing
  - `shareWithOptions()` - Share with custom subject and message
- **Cancellation Support** - Cancel long-running operations
  - `GeniusPdfCancellationToken` - Token for operation cancellation

#### Job Scheduling (`GeniusPdfGenerationManager`)

- **Schedule Jobs** - Schedule PDF generation for later
  - `GeniusPdfScheduler` - Timer-based job scheduling
  - `scheduleJob()` - Schedule with delay
  - `scheduleAfter()` - Schedule after another job completes
  - `cancelScheduledJob()` - Cancel a scheduled job
- **Job Statistics** - Track generation metrics
  - `GeniusPdfJobStatistics` - Completed, failed, avg duration
  - Statistics extension on `GeniusPdfGenerationManager`
- **Job Chains** - Chain jobs with dependencies
  - `GeniusPdfJobChain` - Chain multiple jobs sequentially
  - `addJob()`, `start()`, `cancel()` - Chain methods

#### Export Validation (`GeniusPdfExportService`)

- **Export Validator** - Validate export configuration
  - `GeniusExportValidator` - Validate before export
  - Validates format, page range, quality, filename
  - Bilingual error messages (Arabic/English)
- **Batch Export Summary** - Detailed batch results
  - `GeniusBatchExportSummary` - Success rate, duration, file sizes
  - Average file size calculation
- **Format Detection** - Auto-detect export format
  - `GeniusExportFormatDetector` - Detect from filename or content
  - Supports MIME type detection
- **Export Presets** - Common export configurations
  - `GeniusExportPresets.archival()` - PDF/A with full quality
  - `GeniusExportPresets.webOptimized()` - Compressed PNG
  - `GeniusExportPresets.print()` - High DPI for printing
  - `GeniusExportPresets.email()` - Optimized for email
  - `GeniusExportPresets.thumbnail()` - Small preview images

#### Conditional Formatting (`GeniusPdfDataGrid`)

- **Condition Types** - Multiple condition operators
  - `GeniusConditionType` - equals, greaterThan, lessThan, between, contains, isEmpty, custom, etc.
- **Formatting Rules** - Define conditional format rules
  - `GeniusConditionalFormatRule` - Rule with condition and formatting
  - `GeniusConditionalFormatRule.positive()` - Green for positive values
  - `GeniusConditionalFormatRule.negative()` - Red for negative values
  - `GeniusConditionalFormatRule.aboveThreshold()` - Highlight above value
  - `GeniusConditionalFormatRule.belowThreshold()` - Highlight below value
  - `GeniusConditionalFormatRule.between()` - Highlight value range
  - `GeniusConditionalFormatRule.contains()` - Text contains match
  - `GeniusConditionalFormatRule.empty()` - Highlight empty cells
- **Format Manager** - Manage multiple rules
  - `GeniusConditionalFormatManager` - Add/remove/evaluate rules
  - Priority-based rule evaluation
- **Cell Formatting** - Format applied to cells
  - `GeniusCellFormatting` - Background, text color, bold, italic
- **Data Grid Utils** - Utility functions for grids
  - `GeniusDataGridUtils.calculateTotals()` - Sum numeric columns
  - `GeniusDataGridUtils.calculateAverages()` - Average numeric columns
  - `GeniusDataGridUtils.sortBy()` - Sort rows by column
  - `GeniusDataGridUtils.filter()` - Filter rows by condition
  - `GeniusDataGridUtils.groupBy()` - Group rows by column value

### Example

```dart
// Merge multiple PDFs
final mergeResult = await GeniusPdfService.instance.mergePdfs(
  documents: [pdf1Bytes, pdf2Bytes, pdf3Bytes],
  outputFileName: 'merged.pdf',
);

// Split PDF by pages
final splitResult = await GeniusPdfService.instance.splitPdf(
  pdfBytes: pdfBytes,
  pageRanges: [(1, 5), (6, 10), (11, 15)],
);

// Add watermark
await GeniusPdfService.instance.addWatermark(
  pdfBytes: pdfBytes,
  text: 'CONFIDENTIAL',
  opacity: 0.3,
  rotation: 45,
);

// Schedule a job for later
final scheduler = GeniusPdfScheduler();
scheduler.scheduleJob(
  delay: Duration(minutes: 5),
  builder: myBuilder,
  onComplete: (result) => print('Scheduled job completed'),
);

// Validate export configuration
final validation = GeniusExportValidator.validate(config, totalPages: 10);
if (!validation.isValid) {
  print('Error: ${validation.getErrorMessage(isRTL: true)}');
}

// Use export presets
final archivalConfig = GeniusExportPresets.archival();
final webConfig = GeniusExportPresets.webOptimized();
final printConfig = GeniusExportPresets.print();

// Apply conditional formatting
final manager = GeniusConditionalFormatManager();
manager.addRule(GeniusConditionalFormatRule.positive(
  columnId: 'profit',
  formatting: GeniusCellFormatting(
    backgroundColor: PdfColor(0.9, 1.0, 0.9),
    textColor: PdfColor(0, 0.5, 0),
    isBold: true,
  ),
));
manager.addRule(GeniusConditionalFormatRule.negative(
  columnId: 'profit',
  formatting: GeniusCellFormatting(
    backgroundColor: PdfColor(1.0, 0.9, 0.9),
    textColor: PdfColor(0.8, 0, 0),
  ),
));

// Calculate grid totals
final totals = GeniusDataGridUtils.calculateTotals(
  rows: myRows,
  columns: ['quantity', 'price', 'total'],
);

// Sort and filter
final sorted = GeniusDataGridUtils.sortBy(rows, 'date', ascending: false);
final filtered = GeniusDataGridUtils.filter(rows, 'status', 'active');
```

---

## [2.3.3+4] - 2026-01-28

### Added

#### Enhanced Printing Service (`GeniusPrinterService`)

- **PDF Sharing** - Share PDF documents via system share sheet
  - `sharePdf()` - Share using share_plus with subject and text
  - `sharePdfNative()` - Share using printing package's native share
  - `savePdfToFile()` - Save PDF to documents directory or custom path
  - `GeniusPdfShareResult` - Result class for share operations
- **PDF Rasterization** - Convert PDF pages to images
  - `rasterPdf()` - Convert all or specific pages to PNG images
  - `getPageImage()` - Get a single page as an image
  - `generateThumbnail()` - Generate a thumbnail for the first page
  - `convertPdfToHtml()` - Convert PDF to HTML with embedded images
  - `GeniusPdfRasterResult` - Result class with page images, DPI, and format
  - `GeniusRasterFormat` - PNG or JPEG format options
- **Platform Capabilities** - Check available features
  - `isPrintingAvailable()` - Check if printing is supported
  - `isSharingAvailable()` - Check if sharing is supported
  - `isRasterAvailable()` - Check if rasterization is supported
  - `getPrintingInfo()` - Get detailed platform printing info
- **Extension Methods** - Easy-to-use extensions on `Uint8List`
  - `.share()` - Share PDF bytes
  - `.saveToFile()` - Save PDF bytes to file
  - `.toImages()` - Convert PDF bytes to images
  - `.toThumbnail()` - Generate thumbnail from PDF bytes

#### Enhanced Printer Discovery (`GeniusPrinterDiscovery`)

- **Filtered Printer Lists** - Get printers by category
  - `availablePrinters` - Only ready printers
  - `networkPrinters` - Network-connected printers
  - `usbPrinters` - USB-connected printers
  - `bluetoothPrinters` - Bluetooth-connected printers
  - `colorPrinters` - Printers that support color
  - `duplexPrinters` - Printers that support duplex
- **Printing Capabilities** - `GeniusPrintingCapabilities` class
  - Detect available features (print, share, raster, list printers, direct print)
  - Bilingual summary text (English/Arabic)
- **Discovery Extensions** - Enhanced discovery methods
  - `discoverPrintersWithDetails()` - Get full discovery result
  - `getCapabilities()` - Get platform capabilities

#### Enhanced Print Preview (`GeniusPrintPreviewEnhanced`)

- **Share Button** - Share PDF directly from preview
- **Save Button** - Save PDF to file from preview
- **Processing Overlay** - Visual feedback during operations
- **Bilingual Messages** - Arabic/English status messages
- **Dialog Helper** - `GeniusPrintPreviewEnhancedDialog.show()`

#### Barcode Validation (`GeniusBarcodeValidator`)

- Validate barcode data before generation
- Support for all barcode types (EAN-13, EAN-8, UPC-A, Code128, Code39, ITF, QR, DataMatrix, PDF417)
- `GeniusBarcodeValidationResult` - Result with bilingual error messages
- Check digit verification for EAN/UPC barcodes
- `calculateEan13CheckDigit()` - Calculate check digit for EAN-13

#### Barcode Groups (`GeniusBarcodeGroup`)

- Arrange multiple barcodes in layouts
- `GeniusBarcodeGroupLayout` - horizontal, vertical, grid
- Configurable spacing and grid columns
- Group title support (bilingual)

#### Barcode Batch Generation (`GeniusBarcodeGenerator`)

- `generateSequence()` - Generate barcodes with incrementing numbers
- `fromDataList()` - Generate barcodes from a list of data
- `validateDataList()` - Validate all data before generation

### Example

```dart
// Share a PDF
final shareResult = await GeniusPrinterService.instance.sharePdf(
  pdfBytes: pdfBytes,
  fileName: 'invoice.pdf',
  subject: 'Invoice #123',
  text: 'Please find attached your invoice.',
);

// Convert PDF to images
final images = await GeniusPrinterService.instance.rasterPdf(
  pdfBytes: pdfBytes,
  dpi: 150,
  onProgress: (current, total) => print('Page $current of $total'),
);

// Save PDF to file
final saveResult = await GeniusPrinterService.instance.savePdfToFile(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
);

// Validate barcode data
final validation = GeniusBarcodeValidator.validate(
  data: '5901234123457',
  type: GeniusBarcodeType.ean13,
);
if (!validation.isValid) {
  print('Error: ${validation.getErrorMessage(isRTL: true)}');
}

// Generate a sequence of barcodes
final barcodes = GeniusBarcodeGenerator.generateSequence(
  prefix: 'SKU-',
  start: 1,
  count: 10,
  type: GeniusBarcodeType.code128,
  baseFont: config.baseFont,
);

// Group barcodes in a grid
final group = GeniusBarcodeGroup(
  barcodes: barcodes,
  layout: GeniusBarcodeGroupLayout.grid,
  gridColumns: 3,
  groupTitle: 'Product Barcodes',
  groupTitleAr: 'باركودات المنتجات',
  baseFont: config.baseFont,
);
group.draw(page: page, bounds: bounds);

// Use enhanced preview with share/save
await GeniusPrintPreviewEnhancedDialog.show(
  context: context,
  pdfBytes: pdfBytes,
  documentName: 'Invoice_001',
  showShareButton: true,
  showSaveButton: true,
);

// Use extension methods
await pdfBytes.share(fileName: 'document.pdf');
await pdfBytes.saveToFile(fileName: 'document.pdf');
final thumbnail = await pdfBytes.toThumbnail(dpi: 72);
```

---

## [2.3.3+3] - 2026-01-27

### Added

#### Barcodes & QR Codes

- `GeniusPdfBarcode` - 1D/2D barcode generation component for PDF documents
  - Factory constructors: `.ean13()`, `.code128()`, `.shipping()`
  - Supports EAN-13, EAN-8, UPC-A, Code 128, Code 39, ITF, QR Code, DataMatrix, PDF417
  - `GeniusPdfBarcodeStyle` with presets: `.retail()`, `.shipping()`, `.compact()`, `.document()`
- `GeniusPdfQRCodeGenerator` - Dynamic QR code generation component
  - Factory constructors: `.url()`, `.zatca()`, `.wifi()`, `.vCard()`
  - ZATCA TLV (Tag-Length-Value) encoding for Saudi e-invoice QR codes
  - WiFi network sharing QR codes
  - vCard contact sharing QR codes
  - `GeniusPdfQRCodeStyle` with presets: `.invoice()`, `.payment()`, `.compact()`, `.branded()`
  - `GeniusQRErrorCorrection` levels: low, medium, quartile, high
- `GeniusBarcodeType` enum for all supported barcode formats
- `GeniusPdfCaptionPosition` enum (above/below)
- Barcode demo screen with 3 tabs: 1D Barcodes, QR Codes, All-in-One
- Dashboard navigation updated with Barcodes & QR section

### Fixed

#### Template Bug Fixes

- **customer_statement_template.dart** - Fixed duplicate info box: right panel was showing identical customer data instead of statement details (period, opening balance, currency)
- **purchase_order_template.dart** - Fixed status badge text position drawn at (0,0) instead of correct badge rectangle bounds
- **payslip_template.dart** - Added missing newline between notes label and text content

#### Template Improvements

- **tax_invoice_template.dart** - Implemented proper number-to-words conversion for English and Arabic (supports values up to billions, with currency/sub-currency names: SAR/Halalas, USD/Cents, etc.)
- **attendance_report_template.dart** - Fixed inconsistent bold font fallback to use `PdfFontStyle.bold` from config assets
- **balance_sheet_template.dart** - Enhanced unbalanced warning with colored background box (green/red), left accent border, and difference amount display
- Added thousands separators to currency formatting across 9 templates: balance_sheet, budget_report, cash_flow, credit_note, income_statement, payslip, purchase_order, quotation, tax_invoice

---

## [2.3.3+2] - 2026-01-26

### Added

#### Comprehensive Print Theme System (`GeniusPdfPrintTheme`)

A centralized theming system for all PDF components with preset themes and full customization.

##### Core Theme Components

- `GeniusPdfPrintTheme` - Main theme class with colors, typography, spacing, and borders
- `GeniusPdfColorSchemeTheme` - Color definitions (primary, secondary, accent, text, background, border, success, warning, error)
- `GeniusPdfTypographyTheme` - Font sizes (title, subtitle, header, body, caption, small)
- `GeniusPdfSpacingTheme` - Spacing values (none, xs, sm, md, lg, xl, xxl)
- `GeniusPdfBorderTheme` - Border settings (width, color, radius)

##### Component-Specific Themes

- `GeniusPdfGridTheme` - Grid styling (header, row, alternate row colors, borders)
- `GeniusPdfSummaryTheme` - Summary section styling (label, total, spacing)
- `GeniusPdfInfoBoxTheme` - Info box styling (background, border, title, content)
- `GeniusPdfHeaderTheme` - Report header styling (title, subtitle, company name)
- `GeniusPdfSectionTheme` - Section styling (title background, content padding)

##### Preset Themes

- `GeniusPdfPrintTheme.defaults()` - Default professional theme
- `GeniusPdfPrintTheme.corporate()` - Blue corporate theme
- `GeniusPdfPrintTheme.minimal()` - Clean minimal theme
- `GeniusPdfPrintTheme.saudi()` - Saudi-inspired green theme
- `GeniusPdfPrintTheme.invoice()` - Optimized for invoices

##### GeniusPdfConfig Integration

- Added `printTheme` parameter to `GeniusPdfConfig` for centralized theme configuration
- All components can now inherit theme settings from config

#### Enhanced Grid Components

##### GeniusPdfGridColumn Improvements

- `subtitle` - Optional subtitle text for column headers
- `subtitleAr` - Arabic subtitle text
- `sortable` - Mark column as sortable
- `sortOrder` - Sort direction (ascending/descending)
- `wrapText` - Enable text wrapping in cells
- `maxLines` - Maximum lines when wrapping
- `prefix` / `suffix` - Text prefix and suffix for values
- `valueFormatter` - Custom value formatting function
- New factory constructors:
  - `GeniusPdfGridColumn.index()` - Index/row number column
  - `GeniusPdfGridColumn.date()` - Date formatted column
  - `GeniusPdfGridColumn.percentage()` - Percentage formatted column
  - `GeniusPdfGridColumn.quantity()` - Quantity column
  - `GeniusPdfGridColumn.description()` - Description column (wider, wrap text)
  - `GeniusPdfGridColumn.action()` - Action status column

##### GeniusPdfGridRow Improvements

- `subtitle` - Row subtitle text
- `isHighlighted` - Highlight row
- `highlightColor` - Custom highlight color
- `indent` - Row indentation level
- `height` - Custom row height
- `minHeight` / `maxHeight` - Height constraints
- New factory constructors:
  - `GeniusPdfGridRow.subtotal()` - Subtotal row with styling
  - `GeniusPdfGridRow.separator()` - Visual separator row
  - `GeniusPdfGridRow.spacer()` - Empty spacer row

##### GeniusPdfGridStyle Factory Constructors

- `GeniusPdfGridStyle.corporate()` - Corporate blue style
- `GeniusPdfGridStyle.minimal()` - Minimal borders style
- `GeniusPdfGridStyle.saudi()` - Saudi green style
- `GeniusPdfGridStyle.invoice()` - Invoice optimized style

##### GeniusPdfGridGroup Improvements

- `level` - Hierarchical group level (for nested groups)
- `isExpanded` - Expansion state
- `showSummary` - Show group summary row
- `summaryLabel` / `summaryLabelAr` - Summary row labels
- `summaryColumns` - Columns to summarize
- `autoCalculateSummary` - Auto-calculate summary values
- `indent` - Group indentation
- `backgroundColor` - Group background color

#### Enhanced Info Box Components

##### GeniusPdfInfoBoxStyle Improvements

- `titleFontSize` / `titleColor` / `titleIsBold` - Title styling
- `contentFontSize` / `contentColor` - Content styling
- `labelColor` / `valueColor` - Label/value colors
- `labelValueLayout` - Layout options (horizontal, vertical, inline)
- `itemSpacing` - Spacing between items
- `borderRadius` - Rounded corners support
- `shadowColor` / `shadowOffset` / `shadowBlur` - Shadow effects
- New factory constructors:
  - `GeniusPdfInfoBoxStyle.corporate()` - Corporate style
  - `GeniusPdfInfoBoxStyle.minimal()` - Minimal style
  - `GeniusPdfInfoBoxStyle.saudi()` - Saudi green style
  - `GeniusPdfInfoBoxStyle.invoice()` - Invoice style
  - `GeniusPdfInfoBoxStyle.compact()` - Compact spacing
  - `GeniusPdfInfoBoxStyle.modern()` - Modern with shadows

##### GeniusPdfInfoBox Improvements

- `footer` / `footerAr` - Footer text
- `columns` - Multi-column layout
- `maxItemsPerColumn` - Items per column limit
- `alignment` - Box alignment (left, center, right, stretch)
- New factory constructor:
  - `GeniusPdfInfoBox.address()` - Pre-configured address box

##### GeniusPdfDualInfoBox Improvements

- `layout` - Layout options (horizontal, vertical, diagonal)
- `spacing` - Spacing between boxes
- `alignment` - Dual box alignment

##### GeniusPdfSection Improvements

- New `GeniusPdfSectionStyle` class with:
  - Title position (top, left, inside, floating)
  - Title alignment and styling
  - Content padding and background
  - Border and shadow settings
  - Factory constructors: `.card()`, `.panel()`, `.outlined()`, `.filled()`

#### Enhanced Report Header Components

##### GeniusPdfCompanyInfo Improvements

- `address` / `addressAr` - Company address
- `city` / `cityAr` - City
- `country` / `countryAr` - Country
- `postalCode` - Postal code
- `phone` / `fax` / `email` / `website` - Contact information
- `commercialRegistration` - CR number
- `additionalInfo` - Map of additional info

##### GeniusPdfReportHeaderStyle Improvements

- `logoPosition` - Logo placement (left, right, center, background)
- `showAccentLine` - Accent line under header
- `accentLineColor` / `accentLineHeight` - Accent styling
- `titleAlignment` - Title alignment options
- `companyInfoPosition` - Company info placement
- `showBorder` / `borderColor` / `borderWidth` - Border settings
- New factory constructors:
  - `GeniusPdfReportHeaderStyle.corporate()` - Corporate style
  - `GeniusPdfReportHeaderStyle.minimal()` - Minimal style
  - `GeniusPdfReportHeaderStyle.saudi()` - Saudi green style
  - `GeniusPdfReportHeaderStyle.invoice()` - Invoice style
  - `GeniusPdfReportHeaderStyle.compact()` - Compact style
  - `GeniusPdfReportHeaderStyle.centered()` - Centered style

##### GeniusPdfReportHeader Improvements

- `bilingualOrder` - Control Arabic/English order
- `showDate` / `dateLabel` / `dateLabelAr` - Date display
- `dateFormat` - Custom date format
- `customDate` - Override current date
- `metadata` - Additional metadata map
- New factory constructors:
  - `GeniusPdfReportHeader.invoice()` - Invoice header preset
  - `GeniusPdfReportHeader.simple()` - Simple header without company
  - `GeniusPdfReportHeader.withCompany()` - Full company header

#### Enhanced Summary Components

##### GeniusPdfSummaryItem Improvements

- `prefix` / `suffix` - Value prefix and suffix
- `indent` - Item indentation
- `showLine` - Show separator line
- `lineColor` - Line color
- `valueAlignment` - Value text alignment
- `showColon` - Show colon after label
- `showBackground` - Show item background

##### GeniusPdfSummaryStyle Improvements

- `itemSpacing` - Spacing between items
- `showBorder` / `borderColor` - Border settings
- `borderRadius` - Rounded corners
- `showBackground` / `backgroundColor` - Background
- `dividerColor` / `dividerThickness` - Divider styling
- `alignment` - Section alignment
- `maxWidth` - Maximum section width
- New factory constructors:
  - `GeniusPdfSummaryStyle.card()` - Card style
  - `GeniusPdfSummaryStyle.minimal()` - Minimal style
  - `GeniusPdfSummaryStyle.invoice()` - Invoice style

#### Enhanced Rich Text Components

##### GeniusPdfTextSpan Improvements

- `backgroundColor` - Text background color
- `letterSpacing` - Character spacing
- `wordSpacing` - Word spacing
- `decoration` - Text decoration (underline, strikethrough)
- `decorationColor` - Decoration color
- `decorationStyle` - Decoration style (solid, dotted, dashed)
- `superscript` / `subscript` - Super/subscript text
- `isRtl` - RTL text direction override
- New factory constructors:
  - `GeniusPdfTextSpan.currency()` - Currency formatting
  - `GeniusPdfTextSpan.percentage()` - Percentage formatting
  - `GeniusPdfTextSpan.date()` - Date formatting
  - `GeniusPdfTextSpan.highlight()` - Highlighted text
  - `GeniusPdfTextSpan.code()` - Code/monospace text
  - `GeniusPdfTextSpan.superscript()` - Superscript text
  - `GeniusPdfTextSpan.subscript()` - Subscript text

#### New Enums

- `GeniusPdfBilingualOrder` - Arabic first or English first
- `GeniusPdfLogoPosition` - left, right, center, background
- `GeniusPdfTitleAlignment` - left, center, right
- `GeniusPdfLabelValueLayout` - horizontal, vertical, inline
- `GeniusPdfInfoBoxAlignment` - left, center, right, stretch
- `GeniusPdfDualInfoBoxLayout` - horizontal, vertical, diagonal
- `GeniusPdfSectionTitlePosition` - top, left, inside, floating
- `GeniusPdfTextDecoration` - none, underline, strikethrough, overline
- `GeniusPdfTextDecorationStyle` - solid, dotted, dashed, wavy

### Example

```dart
// Use preset theme
final theme = GeniusPdfPrintTheme.corporate();

// Create config with theme
final config = GeniusPdfConfig(
  baseFont: myFont,
  printTheme: theme,
);

// Use new grid features
final grid = GeniusPdfDataGrid(
  columns: [
    GeniusPdfGridColumn.index(),
    GeniusPdfGridColumn.description(id: 'desc', title: 'Description'),
    GeniusPdfGridColumn.quantity(id: 'qty', title: 'Qty'),
    GeniusPdfGridColumn.currency(id: 'price', title: 'Price'),
  ],
  rows: [
    GeniusPdfGridRow(cells: {...}),
    GeniusPdfGridRow.subtotal({'desc': 'Subtotal', 'price': 1000}),
  ],
  style: GeniusPdfGridStyle.invoice(),
);

// Use new info box features
final box = GeniusPdfInfoBox.address(
  title: 'Billing Address',
  titleAr: 'عنوان الفواتير',
  items: [...],
  style: GeniusPdfInfoBoxStyle.modern(),
);

// Use new header features
final header = GeniusPdfReportHeader.invoice(
  invoiceNumber: 'INV-001',
  company: GeniusPdfCompanyInfo(
    name: 'Company',
    nameAr: 'الشركة',
    address: '123 Main St',
    city: 'Riyadh',
    phone: '+966123456789',
  ),
  bilingualOrder: GeniusPdfBilingualOrder.arabicFirst,
);
```

---

## [2.3.3+1] - 2026-01-25

### Changed

#### Architecture: Config Instance Pattern (Breaking Change)

- **No Global Singleton** - Removed `GeniusPdfConfig.instance` and `GeniusPdfConfig.instanceOrNull`
- **Per-Builder Config** - Each `GeniusPdfDocumentBuilder` must have its own `GeniusPdfConfig` instance
- **Assets via Config** - `GeniusPdfAssets` is now only accessible through `GeniusPdfConfig.assets`
- **Factory Methods** - Use `GeniusPdfConfig.create()` or `GeniusPdfConfig.createSync()` to create instances
- **Required Fonts** - `GeniusPdfRichText` now requires `baseFont` and `boldFont` parameters

### Migration Guide

#### Before (v2.3.3)

```dart
// Global initialization
await GeniusPdfConfig.initialize(
  baseFont: myFont,
  assetPaths: GeniusPdfAssetPaths(...),
);

// Access anywhere via singleton
final config = GeniusPdfConfig.instance;
final assets = GeniusPdfConfig.assets;
final font = GeniusPdfAssets.instance.primaryFont;
```

#### After (v2.3.3+1)

```dart
// Create config instance
final config = await GeniusPdfConfig.create(
  baseFont: myFont,
  assetPaths: GeniusPdfAssetPaths(...),
);

// Pass config to document builders
final builder = MyDocumentBuilder(config);

// Access assets via config instance
final assets = config.assets;
final font = config.assets.primaryFont;
```

### Why This Change?

- **Thread Safety** - Each document generation can have independent configuration
- **Testing** - Easier to test with isolated config instances
- **Flexibility** - Different documents can use different settings simultaneously
- **Explicit Dependencies** - No hidden global state, clearer code flow

---

## [2.3.3] - 2026-01-24

### Added

#### App Sharing Service (`GeniusAppShareService`)

- **Known Apps** - Pre-configured support for popular apps:
  - Messaging: WhatsApp, WhatsApp Business, Telegram, Signal, Viber, Line, WeChat, Messenger
  - Email: Gmail, Outlook
  - Storage: Google Drive, Dropbox, OneDrive
  - Work: Slack, Microsoft Teams
- **App Categories** - Organize apps by type (messaging, email, storage, work)
- **Direct App Sharing** - Share to specific apps
- **Local Storage** - Save to Downloads, Documents, or custom location
- **External Viewer** - Open PDF in device's default viewer

### Example

```dart
final appService = GeniusAppShareService.instance;

// Share to WhatsApp
await appService.shareToWhatsApp(
  pdfBytes: pdfBytes,
  fileName: 'invoice.pdf',
  phoneNumber: '+966123456789',
  message: 'Here is your invoice',
);

// Save to Downloads
await appService.saveToLocal(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
  location: GeniusStorageLocation.downloads,
);

// Open in external PDF viewer
await appService.openInExternalApp(
  pdfBytes: pdfBytes,
  fileName: 'document.pdf',
);
```

---

## [2.3.2] - 2026-01-24

### Added

#### Bluetooth Sharing Service (`GeniusBluetoothShareService`)

- **Device Discovery** - Find nearby Bluetooth devices
- **Device Types** - Support for computers, phones, tablets, printers
- **Saved Devices** - Save and manage favorite devices
- **File Transfer** - Send PDFs to Bluetooth devices
- **Transfer Tracking** - Monitor progress, speed, and estimated time
- **Nearby Share** - Support for Android Nearby Share / iOS AirDrop

#### Bluetooth Models

- `GeniusBluetoothDevice` - Device info with type, status, and signal strength
- `GeniusBluetoothTransfer` - Transfer tracking with progress and speed
- `GeniusBluetoothResult` - Operation result with detailed status

### Example

```dart
final btService = GeniusBluetoothShareService.instance;

// Discover devices
final devices = await btService.discoverDevices();

// Send to a device
final result = await btService.sendFile(
  pdfBytes: pdfBytes,
  fileName: 'document.pdf',
  device: devices.first,
  onProgress: (progress) => print('Progress: ${progress * 100}%'),
);

// Use Nearby Share
await btService.shareViaNearby(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
);
```

---

## [2.3.1] - 2026-01-24

### Added

#### Email Sharing Service (`GeniusEmailShareService`)

- **Compose Email** - Open email client with pre-filled data
- **Gmail Integration** - Open Gmail app or web directly
- **Outlook Integration** - Open Outlook app or web directly
- **Email Validation** - Validate email addresses
- **Attachment Support** - Attach PDFs with size validation
- **SMTP Placeholder** - API for future direct SMTP sending

#### Email Models

- `GeniusEmailData` - Email composition data (to, cc, bcc, subject, body)
- `GeniusEmailAttachment` - Attachment with size and MIME type
- `GeniusSmtpConfig` - SMTP server configuration
- `GeniusEmailResult` - Operation result

### Example

```dart
final emailService = GeniusEmailShareService.instance;

// Compose email
await emailService.composeEmail(
  email: GeniusEmailData(
    to: ['client@example.com'],
    subject: 'Invoice #12345',
    body: 'Please find attached your invoice.',
  ),
);

// Open Gmail with email
await emailService.openGmail(
  email: GeniusEmailData(
    to: ['sales@company.com'],
    subject: 'Monthly Report',
  ),
);

// Create email from template
final email = emailService.createFromTemplate(
  template: GeniusShareMessageTemplate.invoice(),
  variables: {
    'invoiceNumber': '12345',
    'customerName': 'Ahmed',
    'amount': '1,500 SAR',
  },
  recipients: ['client@example.com'],
);
```

---

## [2.3.0] - 2026-01-24

### Added

#### Unified Sharing Service (`GeniusShareService`)

- **Single API** - One service for all sharing methods
- **Multiple Targets** - System share sheet, email, Bluetooth, apps, cloud, local
- **Quick Share** - Share to saved contacts with one call
- **Share History** - Track all sharing activity
- **Share Events** - Stream of sharing updates

#### Share Models

- `GeniusShareTarget` - Define share destination (system, email, bluetooth, app, cloud, local)
- `GeniusShareResult` - Detailed operation result with status
- `GeniusShareHistoryItem` - History entry with timestamp and metadata
- `GeniusShareConfig` - Configuration for size limits, compression, timestamps

#### Quick Share Contacts

- `GeniusQuickShareContact` - Save favorite share recipients
- **Favorite Contacts** - Mark contacts as favorites
- **Usage Tracking** - Track share frequency and recent activity
- **Contact Management** - Add, remove, toggle favorites

#### Message Templates

- `GeniusShareMessageTemplate` - Reusable email templates
- **Built-in Templates** - Invoice, Report, Document templates
- **Variable Substitution** - Replace placeholders with values
- **Bilingual Support** - Arabic and English templates

### Example

```dart
// Initialize service
final shareService = GeniusShareService.instance;
await shareService.initialize();

// Share via system share sheet
final result = await shareService.share(
  pdfBytes: pdfBytes,
  fileName: 'document.pdf',
  target: GeniusShareTarget.system(),
);

// Share via email
await shareService.share(
  pdfBytes: pdfBytes,
  fileName: 'invoice.pdf',
  target: GeniusShareTarget.email(
    toAddress: 'client@example.com',
    subject: 'Your Invoice',
  ),
);

// Quick share to contact
await shareService.quickShare(
  pdfBytes: pdfBytes,
  fileName: 'report.pdf',
  contact: favoriteContact,
);

// Share with template
await shareService.shareWithTemplate(
  pdfBytes: pdfBytes,
  fileName: 'invoice.pdf',
  target: GeniusShareTarget.email(),
  template: GeniusShareMessageTemplate.invoice(),
  variables: {'invoiceNumber': '12345', 'amount': '1,000 SAR'},
);

// View history
final history = shareService.history;
final successfulShares = shareService.successfulShares;
```

---

## [2.2.1] - 2026-01-24

### Added

#### Print Preview Widget (`GeniusPrintPreview`)

- **Visual Preview** - See document before printing with full page rendering
- **Settings Panel** - Adjust all print settings from the preview screen
- **Settings Summary** - Quick overview of current settings (paper, orientation, color, copies)
- **Quick Presets** - Apply default, eco, high quality, or draft settings instantly
- **Full Dialog Support** - Use `GeniusPrintPreviewDialog.show()` for modal preview

#### Print Settings Manager (`GeniusPrintSettingsManager`)

- **Save Profiles** - Save custom print settings as reusable profiles
- **System Presets** - Built-in presets (Default, Eco, High Quality, Draft, Booklet, Presentation)
- **Profile Management** - Create, update, delete, and organize print profiles
- **Usage Tracking** - Track recently used and most used profiles
- **Import/Export** - Export and import profiles as JSON
- **Default Profile** - Set a default profile for quick printing
- **Persistence Support** - Callbacks for saving profiles to storage

#### Print Profile Model (`GeniusPrintProfile`)

- **Profile Data** - Name, Arabic name, icon, settings, and metadata
- **Usage Statistics** - Track usage count and last used date
- **JSON Serialization** - Full serialization support for persistence

### Example

```dart
// Show print preview dialog
final printed = await GeniusPrintPreviewDialog.show(
  context: context,
  pdfBytes: pdfBytes,
  documentName: 'Invoice_001',
  initialSettings: GeniusPrintSettings.defaults(),
);

// Save settings as profile
final profile = mySettings.saveAsProfile(
  name: 'My Invoice Settings',
  nameAr: 'إعدادات فواتيري',
);

// Get and use saved profiles
final manager = GeniusPrintSettingsManager.instance;
final recentProfiles = manager.recentProfiles;
final defaultProfile = manager.defaultProfile;

// Apply profile settings
if (defaultProfile != null) {
  await printer.printWithDialog(
    pdfBytes: pdfBytes,
    documentName: 'Document',
    settings: defaultProfile.settings,
  );
}
```

---

## [2.2.0] - 2026-01-24

### Added

#### Advanced Printing Service

This release introduces a comprehensive printing module with advanced features.

##### Printer Service (`GeniusPrinterService`)

- **Print with Dialog** - Show native print dialog for user-controlled printing
- **Direct Printing** - Print directly to a specific printer (when supported)
- **Print Copies** - Print multiple copies with collation support
- **Job Tracking** - Track print job status, progress, and history
- **Job Management** - Cancel jobs, view history, clear completed jobs

##### Printer Discovery (`GeniusPrinterDiscovery`)

- **Discover Printers** - Find available printers on the system/network
- **Printer Info** - Get detailed printer information (name, status, capabilities)
- **Printer Status** - Check if a printer is available and ready
- **Caching** - Efficient caching to reduce discovery overhead

##### Print Settings (`GeniusPrintSettings`)

- **Paper Size** - Support for A3, A4, A5, Letter, Legal, and more
- **Orientation** - Portrait, Landscape, or Auto-detect
- **Color Mode** - Color, Grayscale, or Black & White
- **Quality** - Draft, Normal, High, or Photo quality
- **Duplex** - Single-sided, Long Edge, or Short Edge
- **Page Range** - Print all, specific range, or custom pages
- **Copies** - Multiple copies with collation
- **Scale** - Fit to page or custom scale percentage

##### Printer Models

- `GeniusPrinterInfo` - Printer information with status and capabilities
- `GeniusPrinterCapabilities` - Printer feature detection
- `GeniusPrintJob` - Print job with status tracking
- `GeniusPrintResult` - Print operation result
- `GeniusPaperSize` - Paper size enum with dimensions
- `GeniusPageRange` - Flexible page range specification

### Example

```dart
// Print with dialog
final result = await GeniusPrinterService.instance.printWithDialog(
  pdfBytes: pdfBytes,
  documentName: 'Invoice_001',
  settings: GeniusPrintSettings(
    copies: 2,
    colorMode: GeniusPrintColorMode.grayscale,
    duplexMode: GeniusDuplexMode.longEdge,
  ),
);

// Discover printers
final printers = await GeniusPrinterDiscovery.instance.discoverPrinters();
for (final printer in printers) {
  print('${printer.name}: ${printer.statusTextEn}');
}

// Print directly (if supported)
final directResult = await GeniusPrinterService.instance.printDirect(
  pdfBytes: pdfBytes,
  documentName: 'Report',
  printerId: printers.first.id,
);

// Use preset settings
final ecoSettings = GeniusPrintSettings.eco(); // Duplex, grayscale, draft
final highQuality = GeniusPrintSettings.highQuality(); // Color, high quality
```

---

## [2.1.2] - 2026-01-24

### Added

- **`GeniusPdfConfig.fontBuild()`** - Helper method to build fonts from config assets:

  ```dart
  // Build font from config assets with custom size
  final titleFont = GeniusPdfConfig.fontBuild(fontSize: 18);
  
  // Or with specific config
  final font = GeniusPdfConfig.fontBuild(config: myConfig, fontSize: 14);
  ```

### Changed

- **Simplified GeniusPdfAssets.instance** - Fixed backward compatibility getter to properly delegate to `GeniusPdfConfig.assetsOrNull`
- **GeniusPdfRichText** - Now defaults to `GeniusPdfConfig.instance` fonts when `baseFont`/`boldFont` not provided

### Removed

- Removed unused reset/dispose methods from `GeniusPdfConfig`:
  - `reset()`, `resetConfig()`, `resetAssets()`, `resetLogger()`, `dispose()`
  - These methods were rarely used and added unnecessary complexity

---

## [2.1.1] - 2026-01-24

### Added

#### Centralized Configuration System

A unified configuration center that merges all PDF settings into a single entry point.

##### `GeniusPdfConfig` Enhancements

- **Assets as Instance Field** - `configAssets` is now an instance field, allowing each config to have its own assets:
  - Each `GeniusPdfConfig` instance can have its own set of fonts and images
  - Access via `config.configAssets` for local instances
  - Static `GeniusPdfConfig.assets` delegates to singleton's `configAssets`
- **Unified Initialization** - Initialize config, assets, and logger in one call:
  - `GeniusPdfConfig.initialize()` now accepts `assetPaths`, `assetData`, and `loggerConfig`
  - `GeniusPdfConfig.initializeSync()` for synchronous initialization without asset loading
- **Logger Access** - Access logger through `GeniusPdfConfig.logger`
  - `GeniusPdfConfig.logger.enable()` / `.disable()` - Control logging
  - `GeniusPdfConfig.logger.debug()`, `.info()`, `.warning()`, `.error()` - Log messages

##### New Configuration Classes

- `GeniusPdfAssetPaths` - Combined paths configuration for fonts and branding
- `GeniusPdfAssetsData` - Pre-loaded asset data configuration
- `GeniusPdfLoggerConfig` - Logger configuration (enabled, minLevel, useConsole, etc.)
- `GeniusPdfLoggerAccess` - Logger access wrapper for convenient method access

### Changed

- **Deprecated Direct Access** - `GeniusPdfAssets.initialize()` and `GeniusPdfLogger.configure()` are now deprecated. Use `GeniusPdfConfig.initialize()` instead for centralized configuration.
- **Backward Compatibility** - Old code using `GeniusPdfAssets` and `GeniusPdfLogger` directly will continue to work.

### Example

```dart
// Before (v2.1.0 - Multiple initialization calls)
await GeniusPdfAssets.initialize(
  fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din.ttf'),
);
GeniusPdfLogger.enable();
GeniusPdfConfig.initialize(
  baseFont: PdfTrueTypeFont(GeniusPdfAssets.instance.primaryFont, 12),
);

// After (v2.1.1 - Single centralized initialization)
await GeniusPdfConfig.initialize(
  baseFont: PdfTrueTypeFont(fontData, 12),
  assetPaths: GeniusPdfAssetPaths(
    fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din.ttf'),
    brandingPaths: GeniusPdfBrandingPaths(logo: 'assets/images/logo.png'),
  ),
  loggerConfig: GeniusPdfLoggerConfig(
    enabled: true,
    useConsole: true,
    minLevel: GeniusLogLevel.info,
  ),
);

// Access assets and logger through config
final font = GeniusPdfConfig.assets.primaryFont;
GeniusPdfConfig.logger.info('PDF generation started');
```

---

## [2.1.0] - 2026-01-24

### Added

#### AI-Powered Features

This release introduces intelligent features for PDF creation and analysis.

##### Content Analysis (`GeniusPdfContentAnalyzer`)

- **Text Extraction** - Extract text content from PDF documents
- **Document Classification** - Automatically detect document types (invoice, report, letter, contract, etc.)
- **Language Detection** - Detect languages used in the document with RTL support
- **Keyword Extraction** - Extract important keywords from content
- **Structured Data Extraction**:
  - Dates (multiple formats, Arabic and English)
  - Monetary amounts (SAR, USD, EUR, GBP)
  - Email addresses
  - Phone numbers
  - Reference numbers (invoice, order, etc.)
- **Metadata Extraction** - Extract document metadata

##### Smart Layout Engine (`GeniusSmartLayoutEngine`)

- **Font Size Analysis** - Suggests optimal font sizes based on content density
- **Margin Optimization** - Smart margin suggestions for print or screen
- **Spacing Analysis** - Optimal spacing between elements
- **Column Layout** - Suggests single or multi-column layouts
- **Color Scheme Suggestions** - Document-type-based color schemes
- **Print Optimization** - Settings for professional print output
- **RTL Support** - Full RTL layout support

##### Smart Text Services (`GeniusSmartTextServices`)

- **Text Summarization** - Summarize long documents with key points extraction
- **Language Detection** - Detect primary language with confidence scores
- **Smart Title Generation** - Generate document titles based on content
- **Keyword Extraction** - Extract relevant keywords from text
- **RTL Detection** - Automatically detect RTL text

##### Smart Image Optimizer (`GeniusSmartImageOptimizer`)

- **Image Analysis** - Analyze image dimensions and quality
- **Optimization Recommendations** - Smart suggestions for image optimization
- **Size Calculation** - Calculate optimal image sizes for PDF
- **Format Suggestions** - Recommend best image format for use case
- **Print vs Screen** - Different optimization for print and screen

### Example

```dart
// Analyze PDF content
final analyzer = GeniusPdfContentAnalyzer();
final result = await analyzer.analyzeBytes(pdfBytes);
print('Document type: ${result.documentType}');
print('Keywords: ${result.keywords}');

// Smart layout suggestions
final layoutEngine = GeniusSmartLayoutEngine();
final suggestions = layoutEngine.analyzeFontSizes(
  contentLength: 5000,
  pageSize: PdfPageSize.a4,
);

// Text summarization
final textServices = GeniusSmartTextServices();
final summary = textServices.summarize(longText);
final titles = textServices.generateTitles(text);

// Image optimization
final imageOptimizer = GeniusSmartImageOptimizer();
final analysis = await imageOptimizer.analyze(imageBytes);
```

---

## [2.0.9] - 2026-01-24

### Fixed

#### Custom Report Screen

- **custom_report_screen** - Fixed app hanging when generating PDF
  - Changed from PdfStandardFont (Helvetica) to PdfTrueTypeFont for LTR mode
  - Now uses DIN font for LTR and Hacen Tunisia font for RTL
  - Fixed null font being passed to components (v2.0.5+ compatibility)
  - All components now receive proper TrueType fonts
  - Fixed missing const keyword

### Changed

- Custom report generation now works reliably in both LTR and RTL modes

---

## [2.0.8] - 2026-01-24

### Fixed

#### V2 Architecture Demo Screen

- **v2_architecture_demo_screen** - Fixed missing const keyword
- Added comprehensive documentation explaining the screen's purpose:
  - Fluent API for building PDFs
  - Plugin System for extensibility
  - Dependency Injection container
  - Event-driven architecture

### Changed

- Improved code documentation for better developer experience

---

## [2.0.7] - 2026-01-24

### Fixed

#### Template Engine Stability

- **ConditionalElement** - Fixed null check error when condition is null
  - Added safe null handling in `render()` and `calculateHeight()` methods
  - Fixed `toJson()` to handle null condition gracefully
  - Fixed `fromJson()` to provide default condition when missing
- **template_engine_demo_screen** - Fixed missing const keyword causing potential issues

### Changed

- Improved template engine robustness with better null safety handling

---

## [2.0.6] - 2026-01-24

### Added

#### Default Output Path

- **GeniusPdfConfig** - Added `defaultOutputPath` property for setting a default directory for generated PDF files

#### File Opening in Demo Screens

- **job_manager_demo_screen** - Added ability to open generated PDF files directly from the app
  - Files are saved to documents directory
  - Open button appears for completed jobs
- **export_demo_screen** - Added ability to open exported PDF files
  - Files are saved with format-specific names
  - Quick open button after successful export

### Changed

- Updated example app to demonstrate file opening functionality
- Improved user experience with direct file access after generation

---

## [2.0.5] - 2026-01-24

### Changed

#### Font System Improvement

- **GeniusPdfConfig** - Added new font properties for unified font management:
  - `boldFont` - Bold version of the base font
  - `headerFont` - Font for headers and titles
  - `smallFont` - Smaller font for captions and footnotes
- **All Components** - Updated to use fonts from Config exclusively:
  - `GeniusPdfDataGrid` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfInfoBox` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfSummarySection` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfReportHeader` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfRichText` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfBarChart` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfLineChart` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfPieChart` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfAreaChart` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfDigitalSignature` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfWatermark` - Now requires `baseFont`
  - `GeniusPdfTotalBar` - Now requires `baseFont`/`boldFont`
  - `GeniusPdfSignatureArea` - Now requires `baseFont`
  - `GeniusPdfQRCode` - Now requires `baseFont`
  - `GeniusPdfSection` - Now requires `baseFont`/`boldFont`

### Breaking Changes

- **Font Requirement** - All components now require fonts to be provided explicitly. No fallback to Helvetica (which doesn't support Arabic). This ensures proper Arabic text rendering in all PDF components.

### Migration Guide

Before (v2.0.2):

```dart
// Fonts were optional, Helvetica was used as fallback
final grid = GeniusPdfDataGrid(
  columns: [...],
  rows: [...],
);
```

After (v2.0.5):

```dart
// Fonts must be provided
final grid = GeniusPdfDataGrid(
  columns: [...],
  rows: [...],
  baseFont: config.baseFont,  // Required
  boldFont: config.boldFont,  // Optional, falls back to baseFont
);
```

Or use Config:

```dart
GeniusPdfConfig.initialize(
  baseFont: PdfTrueTypeFont(arabicFontData, 10),
  boldFont: PdfTrueTypeFont(arabicBoldFontData, 10),
);

// Then use config fonts in components
final config = GeniusPdfConfig.instance;
final grid = GeniusPdfDataGrid(
  columns: [...],
  rows: [...],
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);
```

---

## [2.0.2] - 2026-01-24

### Added

#### Logging System

- `GeniusPdfLogger` - Centralized logging system for the library
  - Enable/disable logging with `enable()` and `disable()`
  - Multiple log levels: `debug`, `info`, `warning`, `error`, `none`
  - Set minimum log level with `setMinLevel()`
  - Custom log handlers with `addHandler()`
  - Built-in console handler with colored output
  - Log history with configurable size
  - Stream-based logging for reactive listening
  - Quick configuration with `configure()`
- `GeniusLogLevel` - Log level enum (debug, info, warning, error, none)
- `GeniusLogEntry` - Log entry with timestamp, level, message, tag, error, and stack trace
- `GeniusLoggable` mixin - Add logging capabilities to any class

### Features

- **Logging Control** - Enable/disable logging at runtime
- **Level Filtering** - Show only warnings and errors in production
- **Custom Handlers** - Send logs to analytics, files, or external services
- **Log History** - Keep recent logs in memory for debugging
- **Stream Support** - Listen to logs in real-time
- **Colored Console** - Easy-to-read colored console output
- **Class Mixin** - Add logging to your classes with `GeniusLoggable`

---

## [2.0.1] - 2026-01-24

### Fixed

- **Custom Report / Print**: "Invalid argument (The character is not supported by the font.): 1561" when generating or printing with RTL or Arabic content. Helvetica does not support Arabic; the example now loads an Arabic-capable font (Hacen Tunisia) when RTL is enabled and passes `baseFont`/`boldFont` to InfoBox, DataGrid, and Summary. Header draw uses `PdfTextDirection.rightToLeft` for RTL.

## [2.0.0] - 2026-01-23

### Added

#### Plugin System Architecture

- `GeniusPdfPlugin` - Base abstract class for creating plugins
  - Unique ID and versioning support
  - Dependencies management between plugins
  - Priority-based loading order
  - Enable/disable functionality
  - Lifecycle methods (initialize, dispose, onEnable, onDisable)
- `GeniusPluginManager` - Singleton manager for plugins
  - Register and unregister plugins
  - Initialize plugins with dependency resolution
  - Plugin events stream for monitoring
  - Get plugins by ID or type
- `GeniusComponentPlugin` - Base class for component plugins
- `GeniusTemplatePlugin` - Base class for template plugins
- `GeniusExporterPlugin` - Base class for exporter plugins
- `GeniusPluginEvent` - Plugin lifecycle events

#### Dependency Injection

- `GeniusPdfContainer` - Lightweight DI container
  - Singleton registration with `registerSingleton()`
  - Factory registration with `registerFactory()`
  - Lazy singleton registration with `registerLazySingleton()`
  - Async factory registration with `registerAsyncFactory()`
  - Named registrations support
  - Type-safe dependency resolution
- `GeniusServiceLocator` mixin - Easy access to dependencies in classes
- `inject<T>()` - Global function for quick dependency resolution
- `injectAsync<T>()` - Async dependency resolution
- `GeniusDependencyException` - Clear error messages for DI issues

#### Event-Driven Architecture

- `GeniusPdfEventBus` - Centralized event bus
  - Emit events with `emit()` and `emitAsync()`
  - Listen to specific event types with `on<T>()`
  - Register handlers with `handle<T>()`
  - Wait for specific events with `waitFor<T>()`
  - Filter events with `where<T>()`
- `GeniusPdfEvent` - Base class for all events
- Document events: `GeniusDocumentCreatedEvent`, `GeniusDocumentModifiedEvent`, `GeniusDocumentSavedEvent`
- Page events: `GeniusPageAddedEvent`, `GeniusPageRemovedEvent`
- Render events: `GeniusRenderStartedEvent`, `GeniusRenderProgressEvent`, `GeniusRenderCompletedEvent`, `GeniusRenderFailedEvent`
- Export events: `GeniusExportStartedEvent`, `GeniusExportCompletedEvent`
- Template events: `GeniusTemplateLoadedEvent`, `GeniusTemplateAppliedEvent`
- Error events: `GeniusErrorEvent`, `GeniusWarningEvent`
- `GeniusEventEmitter` mixin - Add event capabilities to any class

#### Reactive Streams

- `GeniusPdfReactiveStreams` - Reactive streams for operations
  - Operation progress stream
  - Document state stream
- `GeniusOperationProgress` - Progress tracking with percentage
- `GeniusDocumentState` - Document state tracking
- `GeniusDocumentStatus` - Status enum (creating, editing, rendering, saving, saved, error)

#### Enhanced Fluent API

- `GeniusPdfBuilder` - Chainable PDF document builder
  - Configure with `configure()` and `metadata()`
  - Set page format with `pageFormat()`
  - Enable RTL with `rtl()`
  - Add pages with `addPage()` and `addPages()`
  - Add multi-page content with `addMultiPage()`
  - Build document or bytes with `build()` and `buildBytes()`
- `GeniusDocumentConfig` - Document configuration
- `GeniusPageBuilder` - Fluent page content builder
  - Header, subheader, paragraph
  - Bullet and numbered lists
  - Tables with automatic formatting
  - Dividers and spacers
  - Images and custom widgets
  - Rows and columns
- `GeniusMultiPageBuilder` - Multi-page document builder
  - Custom headers and footers
  - Page number footers
  - Headings and paragraphs
- `GeniusPageContent` - Page content container
- `GeniusMultiPageContent` - Multi-page content container

#### Smart Caching System

- `GeniusPdfCache` - Main caching system
  - Set and get cached values
  - Time-to-live (TTL) support
  - `getOrSet()` - Compute if absent (sync)
  - `getOrCompute()` - Compute if absent (async)
  - Multiple eviction strategies (LRU, LFU, FIFO, Priority)
  - Automatic cleanup with `startAutoCleanup()`
  - Cache statistics with `stats`
- `GeniusCacheStrategy` - Eviction strategies enum
- `GeniusCachePriority` - Priority levels (low, normal, high, critical)
- `GeniusCacheStats` - Cache statistics
- `GeniusFontCache` - Specialized cache for fonts
- `GeniusImageCache` - Specialized cache for images
- `GeniusTemplateCache` - Cache for compiled templates with versioning
- `GeniusObjectPool<T>` - Generic object pool for memory optimization
- `Cacheable` mixin - Add caching support to any class

#### Platform Compatibility

- `GeniusPdfPlatform` - Platform detection utility
  - Platform type detection (Android, iOS, Windows, macOS, Linux, Web)
  - Platform capability checks (`isWeb`, `isMobile`, `isDesktop`)
  - Feature availability checks (`hasFileSystem`, `hasNativePrinting`, `hasSharing`)
  - Platform override for testing
  - Platform-specific configuration
- `GeniusPlatformType` - Platform type enum
- `GeniusPlatformConfig` - Platform configuration
- `GeniusPlatformFileAdapter` - Abstract file operations adapter
- `GeniusMobileFileAdapter` - Mobile platform adapter
- `GeniusDesktopFileAdapter` - Desktop platform adapter
- `GeniusWebFileAdapter` - Web platform adapter
- `GeniusFeatureDetector` - Feature availability detection
- `GeniusPlatformAware` mixin - Add platform awareness to classes

### Features

- **Plugin Architecture** - Extend the library with custom plugins
- **Dependency Injection** - Clean dependency management
- **Event-Driven** - React to document lifecycle events
- **Reactive Streams** - Real-time progress and state updates
- **Fluent API** - Expressive, chainable API for document creation
- **Smart Caching** - Intelligent caching with multiple strategies
- **Platform Support** - Consistent API across Web, Mobile, and Desktop
- **Performance** - Object pooling and lazy loading for efficiency

### Changed

- **Genius branding** - Core classes and components now use the `Genius` prefix (e.g. `GeniusPdfConfig`, `GeniusPdfService`, `GeniusPdfDataGrid`) for consistent branding across the library.

### Breaking Changes

- This is a major version with new architecture. The v1.x API remains available.
- New imports available: `import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'` now includes v2.

---

## [1.5.0] - 2026-01-23

### Added

#### Template Engine

- `PdfTemplateEngine` - Main engine for rendering templates
  - Render templates with variable substitution
  - Support for conditional rendering
  - Loop/iteration support for lists
  - Multi-page layout handling
  - Progress tracking during render
- `TemplateBuilder` - Fluent API for building templates programmatically

#### Template Definition

- `TemplateDefinition` - Complete template structure
  - Template metadata (id, name, version, author)
  - Variable definitions with validation
  - Content elements with header/footer support
  - JSON serialization/deserialization
- `TemplatePageSettings` - Page configuration
- `TemplateMargins` - Margin settings
- `TemplateCategory` - Built-in category constants

#### Template Variables

- `TemplateVariable` - Variable definition with types
  - String, number, currency, date, boolean, list, object, image
  - Factory constructors for each type
  - Default values and validation rules
- `VariableValidation` - Validation rules (min/max, pattern, allowed values)

#### Template Conditions

- `TemplateCondition` - Conditional logic
  - Comparison operators (equals, not equals, greater/less than)
  - String operators (contains, startsWith, endsWith)
  - AND/OR combination support
- `ConditionOperator` - Enum of operators

#### Template Loops

- `TemplateLoop` - List iteration with filtering and sorting
- `TemplateContext` - Rendering context with nested data access

#### Template Elements

- `TextElement` - Static text with RTL support
- `VariableElement` - Variable placeholder with prefix/suffix
- `SpacerElement` - Vertical spacing
- `DividerElement` - Horizontal line/divider
- `ContainerElement` - Element container with styling
- `RowElement` - Horizontal layout with flex support
- `ColumnElement` - Vertical layout
- `LoopElement` - Repeating content for lists
- `ConditionalElement` - If/else rendering
- `TableElement` - Simple table with columns
- `ImageElement` - Image placeholder
- `ElementStyle` - Styling (padding, margin, background, border)

#### Template Registry

- `TemplateRegistry` - Central template management
  - Singleton instance support
  - Search by name, tags, category
  - JSON import/export
- `TemplateLibrary` - Pre-built templates (Invoice, Report, Letter)

### Features

- JSON-based template definition for portability
- Full RTL/LTR support with bilingual labels
- Nested variable access (dot notation)
- Validation before rendering
- Progress callbacks during rendering

---

## [1.4.0] - 2026-01-23

### Added

#### Multi-Format Export

- `GeniusExportFormat` - Supported export formats (PDF/A, PNG, JPEG, HTML, Text)
- `GeniusExportConfiguration` - Configuration for export operations
  - Image quality settings (72-600 DPI)
  - Page range selection
  - Compression options
  - Format-specific settings
- `GeniusExportResult` - Sealed class for export results
  - `GeniusExportSuccess` - Successful export with data and metadata
  - `GeniusExportFailure` - Failed export with error details
- `GeniusExportProgress` - Progress tracking for export operations

#### Export Services

- `GeniusPdfExportService` - Unified export service
  - Export to multiple formats
  - Save to file or return bytes
  - Export to documents directory
  - Export individual pages to images
- `GeniusPdfToImageExporter` - Export PDF pages to PNG/JPEG
  - Configurable image quality (DPI)
  - Page range selection
  - Progress callbacks
- `GeniusPdfToHtmlExporter` - Export PDF to HTML
  - RTL/LTR text detection
  - Responsive CSS styling
  - Optional embedded styles
  - Clean semantic HTML output
- `GeniusPdfToTextExporter` - Export PDF to plain text
  - Text extraction with cleanup
  - Page number markers
  - Layout preservation option

#### Batch Export

- `GeniusBatchExporter` - Export multiple documents
  - Concurrent processing (configurable limit)
  - Progress tracking
  - Stop on error option
- `GeniusBatchExportItem` - Individual batch item configuration
- `GeniusBatchExportResult` - Batch operation results
  - Success/failure counts
  - Duration tracking
  - Success rate calculation

#### Data Models

- `GeniusImageQuality` - Quality presets (low, medium, high, maximum)
- `GeniusPageRange` - Page range specification
  - Single page, from start, to page, custom range

#### Extension Methods

- `PdfDocument.exportTo()` - Quick export to any format
- `PdfDocument.exportToFile()` - Export and save to file
- `PdfDocument.exportToImages()` - Export pages as images
- `PdfDocument.exportToHtml()` - Export to HTML
- `PdfDocument.exportToText()` - Export to plain text
- `List<PdfDocument>.exportAllTo()` - Batch export helper

### Features

- Support for PDF/A long-term archival format
- Image export with quality control (72-600 DPI)
- HTML export with responsive styling
- Plain text extraction with layout options
- Batch processing with concurrency control
- Progress tracking for all export operations
- Bilingual status messages (Arabic/English)
- File size formatting helpers

---

## [1.3.1] - 2026-01-23

### Added

#### GeniusPdfConfig Singleton Pattern

- `GeniusPdfConfig.instance` - Global singleton access to PDF configuration
- `GeniusPdfConfig.instanceOrNull` - Safe access (returns null if not initialized)
- `GeniusPdfConfig.isInitialized` - Check if singleton is initialized
- `GeniusPdfConfig.initialize()` - Initialize the global configuration
- `GeniusPdfConfig.update()` - Update the global configuration
- `GeniusPdfConfig.reset()` - Reset the singleton (useful for testing)

### Features

- Global PDF configuration accessible from anywhere in the app
- Safe initialization with clear error messages
- Ability to update configuration at runtime
- Both singleton and local instance patterns supported

---

## [1.3.0] - 2026-01-23

### Added

#### Financial Report Templates

- `BalanceSheetTemplate` - Balance sheet reports
  - Assets, liabilities, and equity sections
  - Account hierarchy with levels
  - Section totals and grand total
  - Balance verification indicator
  - RTL/LTR support with Arabic/English labels
- `IncomeStatementTemplate` - Income statement (P&L) reports
  - Revenue and expenses sections
  - Gross profit and operating income calculations
  - Tax expense support
  - Profitability ratios (gross margin, net margin)
  - Color-coded profit/loss indicators
- `CashFlowTemplate` - Cash flow statements
  - Operating, investing, and financing activities
  - Net change in cash calculation
  - Cash reconciliation section
  - Color-coded positive/negative cash flows
- `BudgetReportTemplate` - Budget vs actual reports
  - Multiple budget sections
  - Variance calculation (amount and percentage)
  - Color-coded over/under budget indicators
  - Variance summary section
  - Highlighted variance rows

#### Sales Document Templates

- `QuotationTemplate` - Price quotations
  - Customer information
  - Itemized pricing with quantities
  - Tax calculations
  - Validity period
  - Terms and conditions
  - Signature areas (company and customer)
- `PurchaseOrderTemplate` - Purchase orders
  - Vendor information with vendor code
  - Product codes and descriptions
  - Expected delivery date
  - Shipping information section
  - Status badge (Draft, Approved, Sent, etc.)
  - Three signature areas (prepared, approved, received)
- `DeliveryNoteTemplate` - Delivery notes
  - Recipient information
  - Ordered vs delivered quantity comparison
  - Remaining quantity tracking
  - Partial/full delivery status indicator
  - Batch number support
  - Driver and vehicle information
  - Delivery summary section
- `CreditNoteTemplate` - Credit notes
  - Original invoice reference
  - Reason for credit
  - Line items with individual reasons
  - Tax recalculation
  - Credit amount summary
- `DebitNoteTemplate` - Debit notes (alias for CreditNoteTemplate)
  - Same features as credit note with debit styling

#### HR Report Templates

- `PayslipTemplate` - Employee payslips
  - Employee information section
  - Pay period details
  - Earnings breakdown (salary, allowances, overtime)
  - Deductions breakdown (GOSI, tax, etc.)
  - Net pay calculation with color coding
  - Bank account details
  - Computer-generated notice
- `EmployeeReportTemplate` - Employee reports
  - Summary statistics boxes
  - Department summary with counts
  - Employee listing with status
  - Optional salary display
  - Contact information
  - Status indicators (active, on leave, probation)
- `AttendanceReportTemplate` - Attendance reports
  - Overall summary statistics
  - Employee attendance summary table
  - Present/absent/late/leave counts
  - Working hours and overtime tracking
  - Attendance rate percentage
  - Optional daily details view
- `LeaveReportTemplate` - Leave reports
  - Overview statistics (total, pending, approved)
  - Leave balance table
  - Leave requests table
  - Leave type breakdown with visual bars
  - Entitlement and carry forward tracking

#### Data Models

- Balance sheet models: `BalanceSheetItem`, `BalanceSheetSection`, `BalanceSheetData`
- Income statement models: `IncomeStatementItem`, `IncomeStatementSection`, `IncomeStatementData`
- Cash flow models: `CashFlowItem`, `CashFlowSection`, `CashFlowData`, `CashFlowActivityType`
- Budget models: `BudgetItem`, `BudgetSection`, `BudgetReportData`
- Quotation models: `QuotationItem`, `QuotationCustomer`, `QuotationData`
- Purchase order models: `PurchaseOrderItem`, `PurchaseOrderVendor`, `ShippingInfo`, `PurchaseOrderData`
- Delivery note models: `DeliveryItem`, `DeliveryRecipient`, `DeliveryNoteData`
- Credit/debit note models: `NoteLineItem`, `NoteParty`, `CreditDebitNoteData`, `NoteType`
- Payslip models: `PayslipEmployee`, `EarningsItem`, `DeductionsItem`, `PayslipData`
- Employee models: `EmployeeRecord`, `DepartmentSummary`, `EmployeeReportData`, `EmployeeStatus`
- Attendance models: `DailyAttendance`, `AttendanceEmployeeSummary`, `AttendanceReportData`, `AttendanceStatus`
- Leave models: `LeaveRecord`, `LeaveBalance`, `LeaveReportData`, `LeaveType`, `LeaveStatus`

### Features

- 13 new report templates covering financial, sales, and HR domains
- Consistent RTL/LTR support across all templates
- Bilingual labels (Arabic/English) for all templates
- Color-coded indicators for positive/negative values
- Status badges and indicators
- Automatic calculations (totals, variances, rates)
- Professional styling with section headers
- Pre-built data models for each template

### Examples

- New templates demo screen with three tabs (Financial, Sales, HR)
- Sample data generation for all new templates
- Home screen updated with new templates section

---

## [1.2.0] - 2026-01-23

### Added

#### Watermarks

- `GeniusPdfWatermark` - Watermark component for PDF documents
  - Text watermarks with customizable font, size, color, and opacity
  - Image watermarks with scaling and positioning
  - Diagonal watermarks across the page
  - Tiled/repeated watermarks for full page coverage
  - Pre-built templates: confidential, draft, copy, cancelled
- `GeniusTextWatermarkSettings` - Text watermark configuration
- `GeniusImageWatermarkSettings` - Image watermark configuration
- `GeniusDiagonalWatermarkSettings` - Diagonal watermark configuration
- `GeniusTiledWatermarkSettings` - Tiled/repeated watermark configuration
- `GeniusWatermarkPosition` - Position options (center, corners, edges, fill)
- `GeniusWatermarkLayer` - Layer options (background, foreground)

#### Security & Encryption

- `GeniusPdfSecuritySettings` - Comprehensive security configuration
  - Password protection (user and owner passwords)
  - Encryption levels: 40-bit RC4, 128-bit RC4, 256-bit AES
  - Document permissions control
  - Metadata encryption
- `GeniusPdfPermissions` - Granular permission controls
  - Print permission (standard and high quality)
  - Copy content permission
  - Modify content permission
  - Add annotations permission
  - Fill forms permission
  - Assemble document permission
  - Accessibility permission
- `GeniusPdfSecurityService` - Security operations service
  - Apply security settings
  - Password protection helpers
  - Remove protection (with owner password)
  - Check if document is protected
  - Change password
- Pre-built security configurations:
  - `GeniusPdfSecuritySettings.passwordProtected()`
  - `GeniusPdfSecuritySettings.readOnly()`
  - `GeniusPdfSecuritySettings.fullProtection()`
  - `GeniusPdfSecuritySettings.printOnly()`
- Pre-built permission sets:
  - `GeniusPdfPermissions.all()`
  - `GeniusPdfPermissions.none()`
  - `GeniusPdfPermissions.readOnly()`
  - `GeniusPdfPermissions.printOnly()`
  - `GeniusPdfPermissions.fillFormsOnly()`
  - `GeniusPdfPermissions.annotateOnly()`

#### Digital Signatures

- `GeniusPdfDigitalSignature` - Digital signature component
  - Visual signature appearance
  - Certificate-based signatures (PKCS#12)
  - Approval and certification signatures
  - Timestamp server support
  - Customizable appearance (name, date, reason, location)
- `GeniusDigitalSignatureSettings` - Signature configuration
- `GeniusSignatureAppearance` - Visual appearance settings
- `GeniusSignatureType` - Approval or certified signature
- `GeniusDigitalSignatureService` - Signature operations
  - Verify signatures
  - Remove signatures
  - Get signature count
- `GeniusSignatureVerificationResult` - Verification results
- `GeniusSignatureInfo` - Signature metadata

### Features

- Document extensions for easy watermark and security application
- Page-level watermark application
- Selective page watermarking (specific pages)
- Multiple watermark support per document
- RTL/LTR text support in watermarks
- Opacity and rotation controls for watermarks
- Pre-built watermark templates for common use cases

### Examples

- Watermark demonstrations (text, diagonal, tiled)
- Password protection examples
- Permission configuration examples
- Digital signature examples
- Security demo screen in example app

---

## [1.1.0] - 2026-01-23

### Added

#### Charts and Graphs

- `GeniusPdfBarChart` - Bar chart component for PDF documents
  - Vertical bar charts
  - Horizontal bar charts
  - Stacked bar charts
  - Grouped bar charts
  - Customizable bar width, spacing, and corner radius
  - Value labels on bars
  - Gradient support
- `GeniusPdfLineChart` - Line chart component for PDF documents
  - Straight line charts
  - Curved (smooth) line charts
  - Stepped line charts
  - Data point markers
  - Area fill under lines
  - Multiple series support
- `GeniusPdfPieChart` - Pie chart component for PDF documents
  - Standard pie charts
  - Donut charts (with inner radius)
  - Percentage labels
  - Value labels
  - Exploded slices
  - Customizable start angle
- `GeniusPdfAreaChart` - Area chart component for PDF documents
  - Overlapping area charts
  - Stacked area charts
  - Curved and straight line options
  - Customizable fill opacity
  - Multiple series support

#### Chart Data Models

- `GeniusChartDataPoint` - Individual data point with label and value
- `GeniusChartSeries` - Data series with multiple points
- `GeniusChartAxis` - Axis configuration (title, min, max, divisions, grid lines)
- `GeniusChartLegend` - Legend configuration (position, orientation, icon size)
- `GeniusChartStyle` - Chart styling (colors, fonts, padding, borders)
- `GeniusChartColors` - Pre-defined color palettes (default, blue, green, warm)

#### Chart Settings

- `GeniusBarChartSettings` - Bar chart specific settings
- `GeniusLineChartSettings` - Line chart specific settings
- `GeniusPieChartSettings` - Pie chart specific settings
- `GeniusAreaChartSettings` - Area chart specific settings

#### Enums

- `GeniusBarChartType` - vertical, horizontal, stacked, grouped
- `GeniusLineChartType` - straight, curved, stepped
- `GeniusPieLabelPosition` - inside, outside, none
- `GeniusChartLegendPosition` - top, bottom, left, right
- `GeniusChartLegendOrientation` - horizontal, vertical

### Features

- Full RTL/LTR support for chart labels and legends
- Bilingual labels (Arabic/English) for all chart elements
- Automatic axis scaling with nice round numbers
- Grid lines with customizable colors
- Multiple color palettes for data visualization
- Classic, modern, and dark chart styles

### Examples

- Bar chart demonstrations (all types)
- Line chart demonstrations (all types)
- Pie and donut chart examples
- Area chart examples (overlapping and stacked)
- Combined charts in reports

---

## [1.0.0] - 2026-01-22

### Added

#### Core

- `GeniusPdfDocumentBuilder` - Abstract base class for building PDF documents
- `GeniusPdfConfig` - Configuration class for PDF settings with RTL/LTR support
- `GeniusPdfAssets` - Centralized asset management for fonts and images
- `GeniusPdfService` - Service for PDF generation, saving, sharing, and printing
- `GeniusPdfResult` - Sealed class for type-safe result handling (Success/Failure)
- `GeniusPdfImage` - Image model with scaling capabilities
- `GeniusPdfPageSize` - Pre-defined page sizes (A4, A3, Letter, Legal)

#### PDF Generation Manager

- `GeniusPdfGenerationManager` - Job queue management for PDF generation
- `GeniusPdfJob` - Represents a PDF generation job with status tracking
- `GeniusPdfJobStatus` - Job states (queued, processing, completed, failed, cancelled)
- `GeniusPdfJobPriority` - Priority levels (low, normal, high, urgent)
- Background/foreground execution support
- Concurrent job processing with configurable limits
- Progress tracking and callbacks
- Batch job processing
- Automatic cleanup of completed jobs

#### Components

- `GeniusPdfDataGrid` - Professional data tables with RTL support
  - Custom column definitions (text, numeric, currency)
  - Header rows with bilingual support
  - Alternating row colors
  - Group headers and totals
  - Automatic pagination
- `GeniusPdfRichText` - Styled text with multiple formats
  - Multiple colors and fonts
  - Clickable links
  - Bold/italic/underline support
  - Positive (green) and negative (red) amounts
- `GeniusPdfRichTextBuilder` - Fluent API for building rich text
- `GeniusPdfInfoBox` - Information boxes for grouped content
  - Multiple style options (card, highlighted, headerContent)
  - Bilingual title support
- `GeniusPdfDualInfoBox` - Two info boxes side by side
- `GeniusPdfReportHeader` - Professional report headers
  - Company logo and information
  - Bilingual titles (Arabic/English)
  - Multiple layout options (standard, compact, centered, invoice)
  - Print date display
- `GeniusPdfSummarySection` - Totals and calculations display
  - Subtotals and grand totals
  - Tax calculations
  - Customizable alignment
- `GeniusPdfTotalBar` - Highlighted total display bar
- `GeniusPdfSignatureArea` - Signature areas with date fields
- `GeniusPdfQRCode` - QR code display for invoices
- `GeniusPdfLabeledValue` - Key-value pair display
- `GeniusPdfKeyValueList` - Multiple key-value pairs
- `GeniusPdfSection` - Bordered sections for grouping

#### Styling System

- `GeniusPdfTextStyle` - Text styling (title, header, subtitle, body, caption)
- `GeniusPdfCellStyle` - Cell styling for grids
- `GeniusPdfBorderStyle` - Border configuration (all, none, horizontal, vertical)
- `GeniusPdfCellPadding` - Padding configuration
- `GeniusPdfGridStyle` - Grid appearance (classic, modern)
- `GeniusPdfInfoBoxStyle` - Info box styling
- `GeniusPdfReportHeaderStyle` - Header styling (classic, modern)
- `GeniusPdfSummaryStyle` - Summary section styling
- `GeniusPdfColorScheme` - Pre-defined color schemes (default, professional, saudi)

#### Report Templates

- `TaxInvoiceTemplate` - ZATCA-compliant tax invoices
  - Customer and company information boxes
  - Line items table with totals
  - VAT calculations and breakdown
  - Amount in words (Arabic/English)
  - QR code and signature areas
- `TrialBalanceTemplate` - Trial balance financial reports
  - Categorized account listings
  - Debit and credit columns
  - Category subtotals
  - Grand total row
- `CustomerStatementTemplate` - Customer account statements
  - Transaction history with running balance
  - Opening and closing balances
  - Aging analysis table
  - Signature area
- `InventoryReportTemplate` - Inventory valuation reports
  - Items grouped by category
  - Quantity, cost, and total value
  - Category subtotals
  - Grand total

#### Preview Widgets

- `GeniusPdfPreviewPage` - Full-screen preview with actions
- `GeniusPdfPreviewWidget` - Embeddable preview widget
- `GeniusPdfFilePreviewPage` - Load and preview from file path
- `GeniusPdfPreviewDialog` - Modal dialog preview

#### Extensions

- `ColorToPdfExtension` - Convert Flutter colors to PDF colors
- `PdfColorUtilities` - Lighter/darker color variants
- `PdfDateTimeExtension` - Date/time formatting for PDFs

### Features

- Full RTL/LTR text direction support
- Bilingual support throughout (Arabic/English)
- Background processing with isolates
- Fluent API for document construction
- Header and footer templates
- Automatic page management
- Job queue with priority management
- Progress tracking and callbacks
- Comprehensive documentation

### Examples

- Complete example project with all use cases
- Tax invoice generation
- Trial balance reports
- Customer statements
- Inventory reports
- Data grid demonstrations
- Rich text examples
- Component showcase
