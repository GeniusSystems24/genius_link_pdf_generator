
# S03 — Flow Layout, Blocks, Bands & Pagination Contract

Version: **4.0.0**

## Purpose

S03 replaces scattered page-break checks for new ERP document work with a
deterministic flow abstraction. Existing builder methods remain valid and are
not deprecated.

## Core abstractions

- `PdfBlock` — measurable/renderable unit.
- `PdfBand` — top/bottom page chrome unit.
- `PdfFlowSection` — body blocks + page spec + bands + metadata.
- `PdfKeepTogether` — keeps a block together when possible.
- `PdfRepeatableBand` — repeats section/group/table/page bands.
- `PdfPageBreakPolicy` — keep/break/conditional rules.

## Two-pass layout

The engine first calls `measure()` and creates a `PdfFlowPlan`. No render
callback is executed during planning. The second pass renders the finalized
plan.

```dart
final plan = builder.planFlowSection(section);
final result = builder.addFlowSection(section, plan: plan);
```

Measurement is authoritative for `currentY`. With `strictMeasurement: true`
(the default), render height must match measured height within
`measurementTolerance`.

## Pagination

Supported rules:

- `keepTogether`
- `keepWithNext`
- `pageBreakBefore`
- `pageBreakAfter`
- `breakBeforeWhen`
- text/list orphan and widow protection where the built-in splitters can
  determine safe lines.

An unsplittable block taller than an empty page body throws
`PdfFlowLayoutException` unless `allowOverflow` is explicitly enabled.

## Repeated bands

`PdfRepeatableBand` can represent:

- section header
- group header
- table header
- table footer
- document marker
- custom top/bottom band

A `firstPageHeader` replaces the normal page header on page 1. A
`lastPageFooter` replaces the normal footer on the final section page.

## Header/footer reservation

The planner combines:

1. existing builder `_headerHeight` / `_footerHeight` reservations created by
   the current `addHeader()` / `addFooter()` APIs;
2. flow page header/footer bands;
3. repeatable top/bottom bands.

This is the unified page-chrome budget used by every S03 page plan.

## Page X of Y

`PdfPageNumberBand` supports section or document-at-render-time numbering. The
existing `addFooter(showPageNumber: true)` API remains the preferred whole
document page-count field when pages may be appended after a flow section.

## Custom page size/orientation

A section can use:

```dart
PdfFlowPageSpec(
  size: const Size(420, 595),
  orientation: PdfPageOrientation.landscape,
)
```

The builder restores its previous page settings after the flow section so the
custom spec does not leak to future pages.

## Status / Original / Copy

Use `PdfDocumentMarkerBand` plus `documentStatus` / `copyLabel` on
`PdfFlowSection`. Marker text follows the section direction; ERP numeric values
inside normal blocks continue to use the S01/S02 mixed-BiDi rules.

## Compatibility

No existing builder/composer method is removed or deprecated in S03.

`PdfLegacyCallbackBlock` adapts the current:

```dart
double Function(PdfPage page, Rect bounds)
```

pattern to the new flow engine without changing the callback itself.

`GeniusPdfReportComposer.flowSection(...)` simply queues the new flow API
alongside existing fluent actions.
