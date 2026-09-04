
# S09 — Quotation, Purchase Order & Tax Invoice Migration

Version: **4.0.0**

The three existing transaction templates now extend the same S08 family:

```text
QuotationTemplate      ┐
PurchaseOrderTemplate  ├── GeniusErpTransactionDocument
TaxInvoiceTemplate     ┘
```

Their legacy constructors and model class names remain available.

## Compatibility adapters

- `QuotationErpAdapter`
- `PurchaseOrderErpAdapter`
- `TaxInvoiceErpAdapter`

The adapters translate legacy models into:

- `ErpDocumentContext`;
- `ErpLineItem`;
- `ErpTaxLine`;
- `ErpCalculationRequest`.

Shared template structure then comes from S08 and shared semantic blocks from
S07.

## Quotation

Preserved:

- legacy constructor/fields;
- customer data;
- valid-until/status/currency details;
- item discount and line tax semantics;
- notes and terms;
- QR report link;
- authorized/customer signatures;
- `generateResult()` signature.

Legacy aggregate getters now delegate to the S06 calculation layer.

## Purchase Order

Preserved:

- legacy constructor/fields;
- vendor and order details;
- line discounts;
- document taxes;
- quotation reference;
- shipping address/contact/instructions;
- notes/terms;
- prepared/approved/vendor signatures;
- `generateResult()` signature.

## Tax Invoice

Preserved:

- legacy constructor/fields;
- customer/invoice details;
- line discounts;
- document taxes and VAT summary;
- amount-in-words;
- notes;
- supplied QR image or generated invoice QR;
- authorized signature;
- `generateResult()` signature.

## Intentional visual differences

The migration intentionally replaces template-local physical left/right layouts
with the shared logical start/end family structure. Therefore exact x positions,
box grouping, and spacing can differ from S00 when necessary to correct RTL.

These are acceptable only when:

- information is not lost;
- calculations remain unchanged;
- structured values remain readable LTR;
- Arabic prose/section ordering follows RTL;
- QR/image pixels are not mirrored.

Use the S09 Manual Verification page and the S00 baseline fixtures for review.

## Calculation ownership

The migrated template classes no longer create local DataGrid/InfoBox/Summary
render helpers and no longer own aggregate calculation loops. They adapt to S06
and let S08/S07 render shared slots.

Public legacy line-level convenience getters remain for source compatibility,
but document aggregate totals come from the shared calculation service.
