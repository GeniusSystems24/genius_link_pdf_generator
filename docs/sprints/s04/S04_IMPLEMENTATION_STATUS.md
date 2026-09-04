# Sprint S04 Implementation Status

Version: **4.0.0**

## A — Column sizing

- [x] S04-T01 fixed width.
- [x] S04-T02 weighted/flex width.
- [x] S04-T03 min/max width.
- [x] S04-T04 auto-fit.
- [x] S04-T05 text wrapping.
- [x] S04-T06 ellipsis/clip policies.
- [x] S04-T07 decimal/numeric alignment.

## B — Pagination

- [x] S04-T08 repeated headers.
- [x] S04-T09 keepRowTogether.
- [x] S04-T10 controlled row split policy.
- [x] S04-T11 active top-level group-header repetition.
- [x] S04-T12 group subtotal placement.
- [x] S04-T13 grand-total placement.

## C — Grouping

- [x] S04-T14 group headers.
- [x] S04-T15 group footers through summary rows.
- [x] S04-T16 subtotals.
- [x] S04-T17 grand totals.
- [x] S04-T18 nested groups.
- [x] S04-T19 tree/hierarchical indentation.
- [x] S04-T20 summary-expression contract.

## D — Cell structure

- [x] S04-T21 row span.
- [x] S04-T22 column span.
- [x] S04-T23 conditional row style.
- [x] S04-T24 conditional cell style.
- [x] S04-T25 row builder.
- [x] S04-T26 cell builder.
- [x] S04-T27 empty state.

## E — ERP format integration

- [x] S04-T28 money formatter hook.
- [x] S04-T29 percentage formatter hook.
- [x] S04-T30 quantity formatter hook.
- [x] S04-T31 date/time formatter hook.
- [x] S04-T32 debit/credit semantic style.
- [x] S04-T33 negative accounting values.
- [x] S04-T34 multi-currency display.

## F — Directionality

- [x] S04-T35 followDirection/preserveDefinitionOrder.
- [x] S04-T36 per-column direction.
- [x] S04-T37 RTL grouping indentation.
- [x] S04-T38 logical RTL header/cell padding.
- [x] S04-T39 mixed numeric/text rows.

## G — Performance

- [x] S04-T40 very-large-data mode.
- [x] S04-T41 lazy row preparation where possible.
- [x] S04-T42 measured-width cache.
- [x] S04-T43 repeated resolved-style cache.
- [x] S04-T44 1k/10k benchmark harness and baseline document.

## Manual Verification

- [x] S04-VX01 dedicated S04 Dashboard page.
- [x] S04-VX02 Dashboard/sidebar/mobile/home registration.
- [x] S04-VX03 normal, long, LTR/RTL, empty, grouped, multi-page, span,
  conditional-style and large-data scenarios.
- [x] S04-VX04 real public DataGrid vNext API with actual PDF preview.
- [x] S04-VX05 Expected Result for every important scenario.

## Exit Gate

The source implementation and acceptance harnesses are installed by the
migration. S04 is not formally closed until the target environment verifies:

- [ ] financial/inventory baseline tables need no custom renderer;
- [ ] RTL column order and numeric rendering are visually correct;
- [ ] repeated headers work on multi-page output;
- [ ] no overlap occurs in long wrapped cells;
- [ ] the 1k/10k benchmark has been run and recorded;
- [ ] analyzer has no errors;
- [ ] S04 tests pass;
- [ ] S00/S01/S02/S03 regressions remain green.
