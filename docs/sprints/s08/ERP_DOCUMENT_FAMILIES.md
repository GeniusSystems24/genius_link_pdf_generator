
# S08 — Generic ERP Document Families

Version: **4.0.0**

S08 introduces a generic structural layer under:

```text
lib/src/families/erp
```

The families consume S06 `ErpDocumentContext` / `ErpCalculationResult` and S07
semantic components. They do not belong to Sales, Purchases, Accounting, HR or
Inventory modules.

## Families

- `GeniusErpTransactionDocument`
- `GeniusErpStatementDocument`
- `GeniusErpVoucherDocument`
- `GeniusErpAnalyticalReport`
- `GeniusErpOperationalForm`
- `GeniusErpRegisterDocument`
- `GeniusErpThermalReceipt`
- `GeniusErpLabelDocument`
- `GeniusErpCertificateDocument`

All families inherit `GeniusErpDocumentFamily` and consume a
`GeniusErpFamilyPlan`.

## Standard slots

`GeniusErpFamilySlot` defines:

1. `header`
2. `identity`
3. `parties`
4. `references`
5. `body`
6. `summary`
7. `notesTerms`
8. `approvalsSignatures`
9. `attachmentsCodes`
10. `footer`

Hidden/null semantic components do not consume spacing.

## Slot policies

```dart
slotPolicies: const {
  GeniusErpFamilySlot.body: GeniusErpSlotPolicy(
    breakPolicy: GeniusErpSlotBreakPolicy.auto,
    estimatedHeight: 140,
  ),
  GeniusErpFamilySlot.approvalsSignatures: GeniusErpSlotPolicy(
    breakPolicy: GeniusErpSlotBreakPolicy.keepTogether,
    estimatedHeight: 90,
    direction: GeniusPdfDirection.auto,
  ),
},
```

Each slot can control:

- page-break policy;
- estimated keep-together height;
- direction override;
- spacing after successful rendering.

## First/last page variants

`GeniusErpPageVariants` provides a first-page header replacement and a last-page
footer replacement. The footer is resolved only after body/summary flow has
completed, so the current page is the actual final page.

## Theme and print profile

Every family constructor accepts:

```dart
themeOverride: customTheme,
printProfile: GeniusErpPrintProfile(
  id: 'custom-profile',
  apply: (config) => config.copyWith(...),
),
```

S08 defines the hook. The standardized A4/A5/thermal/label profile catalog
belongs to S11.

## Extension model

Replace a standard component:

```dart
replacements: {
  GeniusErpFamilySlot.summary: (context) => MySummary(
    config: context.config,
    result: context.calculation,
  ),
},
```

Insert a custom semantic section:

```dart
customSections: [
  GeniusErpCustomSection(
    id: 'warehouse-note',
    slot: GeniusErpFamilySlot.body,
    position: GeniusErpCustomSectionPosition.after,
    builder: (context) => GeniusPdfLabel(
      config: context.config,
      text: 'Warehouse checked',
      textAr: 'تم فحص المستودع',
      directionality: context.directionality,
    ),
  ),
],
```

Lifecycle hooks receive `GeniusErpFamilyHookContext`, which intentionally does
not expose `PdfPage`, `PdfGraphics`, or Syncfusion renderer internals.

## Data adapters

Use `GeniusErpDocumentAdapter<T>` at module/legacy boundaries:

```dart
class MyOrderAdapter extends GeniusErpDocumentAdapter<MyOrder> {
  @override
  ErpDocumentContext adapt(MyOrder source) => ...;
}
```

The family itself remains module-neutral.

## Page flow

The shared body slot uses the existing multipage DataGrid drawing contract and
synchronizes the builder with `updateFromLayoutResult`. Other semantic slots
respect their slot break policy and collapse when hidden.

## Usage

```dart
final document = GeniusErpTransactionDocument(
  config,
  plan: GeniusErpFamilyPlan(
    document: context,
    calculation: calculation,
    company: company,
    title: 'Transaction',
    titleAr: 'معاملة',
    primaryParty: context.recipient,
  ),
);

final bytes = document.generate();
document.dispose();
```

See the Dashboard screen **S08 ERP Document Families** for transaction,
statement, voucher, analytical, operational, register, thermal, label,
certificate, RTL/bilingual, extension and multipage scenarios.
