# S04 — DataGrid vNext for ERP Reports

Version: **4.0.0**

## Goal

S04 adds ERP-grade grid behavior without cloning the existing low-level PDF
renderer. `GeniusPdfDataGridVNext` prepares sizing, grouping, formatting,
directionality, styles and spans, then composes the established
`GeniusPdfDataGrid`.

## Column sizing

`GeniusPdfGridColumnPolicy` supports fixed, weighted/flex and auto-fit sizing,
plus min/max constraints. Existing `GeniusPdfGridColumn.width`,
`widthPercent`, `minWidth`, `maxWidth` and `flexFactor` remain valid and are
used when no explicit S04 policy is supplied.

Overflow can be `wrap`, `ellipsis`, or `clip`. Numeric ERP columns use stable
end/right alignment.

## Pagination

- `repeatHeaderOnPages` delegates repeated column headers to the established
  Syncfusion `PdfGrid`.
- `GeniusPdfGridRowSplitPolicy.keepTogether` disables row breaking across
  pages; `allowSplit` enables controlled splitting for very tall wrapped rows.
- With dynamic grouping, each top-level group is a paginated grid and the
  active top-level group header is a repeated header row.
- Group subtotals are emitted after groups.
- Grand totals are emitted after the final group.

## Grouping and summaries

One or more `GeniusPdfGridGroupDefinition` values create nested group levels.
`GeniusPdfGridSummaryExpression` supports sum, average, count, min, max and
custom aggregate callbacks.

Tree indentation follows the right edge in RTL and the left edge in LTR.

## Cell structure

S04 adds:

- `GeniusPdfGridCellSpan` for row and column spans;
- `rowBuilder`;
- `cellBuilder`;
- `rowStyleBuilder`;
- `cellStyleBuilder`;
- bilingual `GeniusPdfGridEmptyState`.

Column spans reuse the established `GeniusPdfGridRow.span`. Row spans are
applied to the final Syncfusion cells after the legacy grid is built.

## ERP formatter hooks

S04 introduces DataGrid-local hooks only. S05 owns the final package-wide
formatter engine.

Supported semantic value kinds are number, money, percentage, quantity, date,
dateTime, identifier, debit and credit. S04 also supports accounting
parentheses for negative values and a per-row currency resolver.

## Directionality

`followDirection` and `preserveDefinitionOrder` are explicit. Per-column
`headerDirection` and `contentDirection` are package-owned
`GeniusPdfDirection` values. Numeric and identifier data default to LTR inside
RTL grids. `GeniusPdfGridDirectionalPadding` resolves logical start/end at the
renderer boundary.

## Large data and benchmark

`GeniusPdfGridRowSource` avoids constructing all source rows in the DataGrid
constructor. `GeniusPdfGridLazyRowSource` builds rows only when preparation is
requested. Auto-fit sampling is bounded. Column widths and repeated resolved
group styles are cached when enabled.

The migration installs:

```text
benchmark/s04_data_grid_benchmark.dart
```

for 1,000 and 10,000 row cold/warm preparation runs. Runtime numbers must be
recorded from the real target environment in
`docs/sprints/s04/BENCHMARK_BASELINE.md`; the migration does not fabricate
performance measurements.

## Compatibility

`GeniusPdfDataGrid` remains available and unchanged as the existing low-level
renderer. S04 is opt-in through `GeniusPdfDataGridVNext`.
