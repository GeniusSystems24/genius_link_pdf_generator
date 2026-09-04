
# S10 — Existing Template Consolidation & Voucher Family

Version: **4.0.0**

S10 maps the remaining package-owned templates to the S08 family hierarchy
without renaming their public classes.

## Family mapping

| Existing template | S08 family |
|---|---|
| BalanceSheetTemplate | `GeniusErpAnalyticalReport` |
| BudgetReportTemplate | `GeniusErpAnalyticalReport` |
| CashFlowTemplate | `GeniusErpAnalyticalReport` |
| IncomeStatementTemplate | `GeniusErpAnalyticalReport` |
| TrialBalanceTemplate | `GeniusErpRegisterDocument` |
| CustomerStatementTemplate | `GeniusErpStatementDocument` |
| AttendanceReportTemplate | `GeniusErpRegisterDocument` |
| EmployeeReportTemplate | `GeniusErpRegisterDocument` |
| LeaveReportTemplate | `GeniusErpRegisterDocument` |
| PayslipTemplate | `GeniusErpOperationalForm` |
| InventoryReportTemplate | `GeniusErpRegisterDocument` |
| DeliveryNoteTemplate | `GeniusErpOperationalForm` |
| CreditNoteTemplate / DebitNoteTemplate | `GeniusErpTransactionDocument` |

S09's `QuotationTemplate`, `PurchaseOrderTemplate`, and `TaxInvoiceTemplate`
remain on `GeniusErpTransactionDocument`.

Every voucher type now reaches `GeniusErpVoucherDocument` through
`GeniusPdfVoucherTemplate`.

## Why the existing `build()` methods still exist

S10 changes the structural parent first while preserving current public output
and constructors. Existing specialized report bodies remain legal family
extensions because analytical/register/statement/operational documents do not
share identical business rows.

Common structure must live in S07/S08 or a family base. Template-specific
analysis or domain-specific rows stay local.

## Voucher consolidation

The package already had a central `GeniusPdfVoucherTemplate`. S10 makes that
base a real `GeniusErpVoucherDocument`.

The following remain centralized once in the voucher base:

- account entries table;
- party details;
- payment details;
- amount highlight;
- amount in words;
- notes;
- signatures;
- footer metadata;
- page border.

Concrete vouchers keep only voucher-specific fields/sections as configuration
or `buildVoucherContent()` extensions.

Repeated two/three-signature geometry in Attendance, Employee, Leave, Payslip,
Inventory and Trial Balance is also centralized in
`drawErpSignatureRow()`; the old private `_drawSignatures()` copies are removed.

## Registry

`GeniusErpExistingTemplateFamilyRegistry` is the package audit source for
family coverage.

```dart
final family =
    GeniusErpExistingTemplateFamilyRegistry.kindForTypeName(
  'TrialBalanceTemplate',
);
// GeniusErpDocumentFamilyKind.register
```

The existing `TemplateRegistry` gets non-breaking ERP metadata through
`GeniusErpTemplateRegistryExtension`; its existing JSON/schema remains intact.

## Directionality / goldens

`test/goldens/s10/template_family_matrix.txt` records EN/LTR and AR/RTL family
coverage. Visual acceptance still requires the Dashboard S10 verification
screen and existing template-specific previews.

S10 does not reintroduce physical left/right helpers. Inherited S08/S07
components remain responsible for logical start/end behavior.
