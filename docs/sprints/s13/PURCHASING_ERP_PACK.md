
# S13 — Purchasing ERP Pack

Version: **4.0.0**

S13 builds Purchasing on the same S06/S08/S10/S11 foundation used by S12.

## Source-to-order

- `GeniusPurchaseRequisitionDocument`
- `GeniusRequestForQuotationDocument`
- `GeniusSupplierQuotationDocument`
- `GeniusQuotationComparisonDocument`

`GeniusQuotationComparisonDocument` uses the shared Analytical family/report
renderer; it does not introduce another page-flow engine.

## Order / receipt / invoice

- `GeniusPurchaseOrderDocument`
- `GeniusGoodsReceiptNoteDocument`
- `GeniusPurchaseInvoiceDocument`
- `GeniusPurchaseAdjustmentDocument`
- `GeniusSupplierReturnDocument`

The existing S09 `PurchaseOrderTemplate` now inherits
`GeniusPurchasingTransactionDocument`. This keeps the existing public API while
placing both legacy/current PO paths on the same Purchasing transaction base.

## Supplier statements and reports

- `GeniusSupplierStatementDocument`
- `GeniusSupplierAgingDocument`
- `GeniusPurchaseRegisterDocument`
- `GeniusPurchaseAnalysisReport`
- `GeniusOutstandingPurchaseOrdersReport`

`GeniusPurchasingAnalytics` calculates statement/aging/register/analysis data
before rendering.

## Shared behaviors

Vendor address and tax IDs stay in S06 `ErpParty`/`ErpTaxIdentity`.
Expected-delivery, warehouse/site and exchange-rate values are supplied through
`GeniusErpPackTransactionRequest`.

Approval trail data remains in `ErpDocumentContext.approvals` and is rendered
by the shared family.

Landed charges are added through:

```dart
GeniusPurchasingLandedChargesHook
```

The hook returns S06 `ErpCharge` objects before calculation. No landed-charge
arithmetic occurs in PDF rendering.

## Partial receipts

`GeniusPurchaseLedgerEntry` exposes:

- `orderedQuantity`
- `receivedQuantity`
- `outstandingQuantity`
- `isPartiallyReceived`

The same typed values drive GRN and Outstanding Purchase Orders reports.

## QA

The semantic QA matrix is:

`test/goldens/s13/purchasing_pack_matrix.txt`

Coverage includes partial receipts, long vendor terms, 1/50/500-line output,
Arabic/English mixed item codes, tax/discount validation, null shipping data,
multi-currency/exchange rate and approval trails.
