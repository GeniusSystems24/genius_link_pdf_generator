# S05 — Formatting Engine & Design Tokens

Version: **4.0.0**

## Shared formatting engine

`GeniusPdfFormatter` is the single stable contract used by components for
money, number, quantity, percentage, date, time, date-time, identifier,
exchange-rate, and unit formatting. `GeniusPdfDefaultFormatter` is the
`intl`-based default implementation.

`GeniusPdfFormatSettings` owns locale, decimal precision, digit shape,
currency label/position, accounting negatives, null placeholder, and default
date/time patterns. `GeniusPdfFormatSpec` is the value-level formatting
contract stored by components.

Identifiers intentionally bypass digit conversion so values such as
`INV-2026-000123`, SKU, IBAN, serial, tax IDs, phone, email, and URL-like
identifiers remain stable in RTL.

## Theme/design tokens

`GeniusPdfTheme` is a backward-compatible facade over the established
`GeniusPdfPrintTheme`. Existing print-theme consumers remain valid, while S05
adds semantic and logical tokens:

- semantic colors;
- logical start/end spacing;
- logical leading/trailing borders;
- typography alignment defaults;
- table tokens;
- document tokens;
- summary/highlight tokens.

Direction changes geometry/alignment only. Semantic color and font weight are
not tied to RTL/LTR.

## Component integration

Summary:

```dart
GeniusPdfSummaryItem.formatted(
  label: 'Grand Total',
  rawValue: 15697.5,
  formatter: config.formatter,
  formatSpec: const GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
)
```

DataGrid:

```dart
const GeniusPdfGridColumn(
  id: 'amount',
  title: 'Amount',
  isNumeric: true,
  formatSpec: GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
)
```

Labeled-value / InfoBox content:

```dart
GeniusPdfLabeledValue.formatted(
  config: config,
  label: 'Amount',
  rawValue: 15697.5,
  formatSpec: const GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
)
```

Legacy `String value`, custom DataGrid `valueFormatter`, and
`GeniusPdfPrintTheme` paths remain supported. Custom format callbacks retain
higher precedence than shared defaults.

## Historical baselines

S00 literal canonical strings stay unchanged intentionally because they are
regression fixtures. Normal post-S05 examples use raw values and the shared
formatter instead of hardcoded formatted amounts.
