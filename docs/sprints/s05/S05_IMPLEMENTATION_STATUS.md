# Sprint S05 Implementation Status

Version: **4.0.0**

## Source tasks

- [x] S05-T01..T09 — formatting contract, money/number/quantity/percentage/date/time/identifier/null policy.
- [x] S05-T10..T16 — locale separators, precision, currency, accounting negatives, digit policy, exchange rate, units.
- [x] S05-T17..T24 — GeniusPdfTheme and typography/spacing/border/table/document/semantic/summary tokens.
- [x] S05-T25..T28 — logical spacing, logical borders, RTL/LTR alignment defaults, direction-independent semantic color/weight.
- [x] S05-T29..T32 — duplicate format helper removal, example migration, DataGrid/Summary/Info integration, backward-compatible defaults.
- [x] S05-T33..T37 — multi-currency golden, precision/accounting/digits tests, formatter/theme docs.
- [x] S05-VX01..VX05 — verification page, navigation, scenarios, real public API/PDF preview, Expected Result.

## Exit Gate

The source migration intentionally does not mark the S05 Exit Gate complete.
Run analyzer/tests/goldens and manually verify the Dashboard page before
closing the four Exit Gate items in `docs/ERP_PRINTING_SPRINTS.md`.
