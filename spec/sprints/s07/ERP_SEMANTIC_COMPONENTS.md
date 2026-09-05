
# S07 — ERP Semantic Components

Version: **4.0.0**

S07 builds reusable semantic PDF sections on top of the S06 ERP domain and
the direction-safe core components from S01/S02 plus the S05 formatter/theme.

## Identity & party

### `GeniusPdfDocumentIdentity`

```dart
GeniusPdfDocumentIdentity(
  config: config,
  data: context.identity,
  directionality: builder.directionality,
)
```

Document numbers, dates and identifiers use independent value direction.

### `GeniusPdfPartyBlock`

```dart
GeniusPdfPartyBlock(
  config: config,
  party: context.recipient,
  title: 'Customer',
  titleAr: 'العميل',
)
```

The block renders party name plus optional registration/tax/contact fields.
Null party data collapses by default.

### `GeniusPdfAddressBlock`

Use the same component for registered, billing, shipping or warehouse
addresses. `ErpAddressRole` remains domain data; the component does not infer a
different address from unrelated fields.

### `GeniusPdfReferenceBlock`

Renders typed document references with document numbers and dates kept as LTR
value runs inside RTL content.

## Financial

### `GeniusPdfMoney`

`GeniusPdfMoney` formats `ErpMoney` only through `config.formatter`.

### `GeniusPdfAmountInWords`

Pass audited/localized prose:

```dart
GeniusPdfAmountInWords(
  config: config,
  amount: result.grandTotal,
  text: 'One hundred Saudi riyals only',
  textAr: 'مائة ريال سعودي فقط',
)
```

S07 deliberately does not guess legal number-to-words text. Applications may
provide `GeniusPdfAmountInWordsResolver`.

### `GeniusPdfTaxSummary`

Consumes `ErpCalculationResult.taxTotals`; it does not calculate taxes.

### `GeniusPdfAdjustmentSummary`

Consumes line/document discount totals and charge total from the typed S06
calculation result.

### `GeniusPdfBalanceDueBlock`

Displays grand total and optional paid/due values. If payment state was not
supplied to S06, no dummy `0.00` paid/due values are created.

## Operational

- `GeniusPdfTermsSection`
- `GeniusPdfApprovalTrail`
- `GeniusPdfStamp`
- `GeniusPdfMetricCards`
- `GeniusPdfLabel`

## Null/empty behavior

Every component exposes `isVisible`.

Null data collapses by default. List components use:

```dart
GeniusPdfEmptySectionPolicy.hide
GeniusPdfEmptySectionPolicy.emptyState
```

Use `GeniusPdfErpComponentGroup` to compose semantic components. The group
inserts spacing only between components that actually rendered:

```dart
final group = GeniusPdfErpComponentGroup(
  spacing: 12,
  components: [
    GeniusPdfDocumentIdentity(
      config: config,
      data: context.identity,
    ),
    GeniusPdfPartyBlock(
      config: config,
      party: context.recipient,
    ),
    GeniusPdfAddressBlock(
      config: config,
      address: context.shippingAddress,
    ),
    GeniusPdfTermsSection(
      config: config,
      text: context.terms,
    ),
  ],
);
```

A null shipping address or null terms section leaves no residual margin.

## Directionality contract

New S07 public geometry uses logical primitives only:

- `GeniusPdfDirectionalInsets(start/end/top/bottom)`;
- `GeniusPdfLogicalAlignment.start/center/end`;
- inherited `GeniusPdfDirectionality`.

Physical left/right is resolved at draw time.

Value categories use the package-owned value-direction policy:

- money/numbers → LTR by default;
- document numbers/IDs/tax IDs → LTR;
- phone/email → LTR;
- dates/times → LTR;
- prose → inherited direction.

Strings are never reversed.

## Composition guidance

S07 components are semantic building blocks, not document families. S08 owns
the generic document-family structure.

Use semantic components for identity/party/address/tax/terms and compose them.
Do not copy their internal label/value/layout logic into every new template.
