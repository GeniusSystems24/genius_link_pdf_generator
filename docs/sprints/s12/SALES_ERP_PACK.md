
# S12 — Sales ERP Pack

Version: **4.0.0**

S12 builds the Sales pack on the S06 domain/calculation layer, S08/S10
document families and the S11 print-profile hook.

## Documents

Transaction family:

- `GeniusSalesOrderDocument`
- `GeniusProformaInvoiceDocument`
- `GeniusPosInvoiceDocument`
- `GeniusSalesDebitNoteDocument`
- `GeniusSalesReturnDocument`
- `GeniusCustomerReceiptDocument`

Operational/Register/Statement/Analytical families:

- `GeniusPickingListDocument`
- `GeniusPackingListDocument`
- `GeniusBackorderDocument`
- `GeniusCustomerAgingDocument`
- `GeniusSalesRegisterDocument`
- `GeniusSalesByCustomerReport`
- `GeniusSalesByItemReport`
- `GeniusSalesBySalespersonReport`
- `GeniusPriceListDocument`
- `GeniusCommissionReport`

Existing S09 `QuotationTemplate` and `TaxInvoiceTemplate` now inherit
`GeniusSalesTransactionDocument`, so legacy/current Sales transaction templates
stay on the same pack/family path.

## Shared calculation contract

All Sales transaction calculations are performed by
`GeniusErpPackCalculationService`, which delegates arithmetic and rounding to
S06 `ErpCalculationService`.

Supported inputs include:

- line/document discounts;
- charges;
- taxes;
- tax-exclusive and tax-inclusive unit-price semantics;
- multi-currency/base-currency exchange rate;
- paid/due state;
- negative return values;
- payment terms;
- expected delivery;
- shipping/billing references;
- copy/reprint metadata from `ErpPrintMetadata`;
- batch and serial metadata on `ErpLineItem`.

Renderer classes never multiply quantities/prices or calculate taxes.

## Analytics

`GeniusSalesAnalytics` calculates report rows before PDF rendering:

- customer aging;
- sales register;
- sales by customer;
- sales by item;
- sales by salesperson;
- price list;
- commission report;
- backorders.

These outputs are independently unit-testable.

## Print profiles

All transaction constructors accept `GeniusErpPrintProfile?`.

When S11's concrete profile is used:

```dart
final document = GeniusPosInvoiceDocument(
  config,
  request: request,
  printProfile: GeniusPdfPrintProfile.thermal80().toFamilyProfile(),
);
```

The Sales pack does not duplicate S11 page/profile logic.

## Return values

`GeniusSalesReturnDocument` explicitly enables the S06 negative-value
calculation configuration. It does not hide or absolute-value negative values.

## QA

The semantic QA matrix is stored at:

`test/goldens/s12/sales_pack_matrix.txt`

The dedicated Dashboard verification page provides real PDF generation for the
public pack API with LTR/RTL and 1/50/500-line scenarios.
