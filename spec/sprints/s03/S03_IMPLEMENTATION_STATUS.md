
# Sprint S03 Implementation Status

Version: **4.0.0**

## A — Core layout model

- [x] S03-T01 — `PdfBlock`.
- [x] S03-T02 — `PdfBand`.
- [x] S03-T03 — `PdfFlowSection`.
- [x] S03-T04 — `PdfKeepTogether`.
- [x] S03-T05 — `PdfRepeatableBand`.
- [x] S03-T06 — `PdfPageBreakPolicy`.

## B — Pagination rules

- [x] S03-T07 — keepTogether.
- [x] S03-T08 — keepWithNext.
- [x] S03-T09 — pageBreakBefore.
- [x] S03-T10 — pageBreakAfter.
- [x] S03-T11 — conditional page break.
- [x] S03-T12 — orphan/widow-aware text/list splitting where measurable.
- [x] S03-T13 — repeated section/group headers via repeatable bands.
- [x] S03-T14 — repeated table header/footer bands.
- [x] S03-T15 — section landscape/custom page size.

## C — Measurement

- [x] S03-T16 — explicit measurement contract.
- [x] S03-T17 — two-pass plan/render API.
- [x] S03-T18 — render callbacks never execute during planning; measurements
  are cached per block/page geometry.
- [x] S03-T19 — measured height is authoritative for predictable currentY.

## D — Header/footer/page metadata

- [x] S03-T20 — unified legacy + flow page-chrome reservation.
- [x] S03-T21 — Page X of Y band plus existing whole-document footer support.
- [x] S03-T22 — first-page header variant.
- [x] S03-T23 — last-page footer variant.
- [x] S03-T24 — document status/original-copy marker bands.

## E — Compatibility

- [x] S03-T25 — current builder methods kept intact.
- [x] S03-T26 — `PdfLegacyCallbackBlock` adapter.
- [x] S03-T27 — existing custom callbacks remain valid.
- [x] S03-T28 — no API is deprecated in S03 because the new path has not yet
  completed downstream template migration.

## F — Tests

- [x] S03-T29 — 1-page test source.
- [x] S03-T30 — 50-row multi-page test source.
- [x] S03-T31 — 500-row stress planning test source.
- [x] S03-T32 — long-note split test source.
- [x] S03-T33 — keepTogether near page end.
- [x] S03-T34 — repeated headers.
- [x] S03-T35 — RTL/LTR pagination parity.
- [x] S03-T36 — custom page size.

## Manual Verification

- [x] S03-VX01 — `s03_flow_layout_verification_page.dart`.
- [x] S03-VX02 — Dashboard/sidebar/mobile/home registration.
- [x] S03-VX03 — normal, 50/500 row, long, keepTogether, repeated bands,
  metadata, custom page and legacy-adapter scenarios; LTR/RTL control.
- [x] S03-VX04 — real public flow API + actual PDF preview.
- [x] S03-VX05 — Expected Result shown for every scenario.

## Exit Gate

Source implementation is installed by the Python migration. The Sprint is not
formally closed until the package owner runs the project in the target Flutter
environment and verifies:

- [ ] analyzer has no errors;
- [ ] all S03 tests pass;
- [ ] 500-row stress case completes within the accepted project budget;
- [ ] no overlap occurs with legacy or flow headers/footers;
- [ ] first/last page variants are visually correct;
- [ ] RTL/LTR page-count parity matches the semantic tests;
- [ ] custom landscape pages render with the expected dimensions;
- [ ] all Dashboard Expected Results are manually accepted;
- [ ] existing S00/S01/S02 regression suites remain green.

The manual/runtime checks above cannot be truthfully marked complete by a
source-editing Python script.

## S03 analyzer repair

The post-implementation repair:

- uses `GeniusPdfConfig` font accessors directly from flow components to avoid inherited-member collisions;
- removes the unused page local from the render pass;
- converts forwarded constructor parameters to super parameters;
- adds `PdfSpacerBlock`, `PdfPageBreakBlock`, `PdfSectionHeaderBand`,
  `PdfGroupHeaderBand`, `PdfTableHeaderBand`, `PdfTableFooterBand`,
  `PdfStatusMarkerBand`, and `PdfOriginalCopyBand`.

These wrappers remain inside S03 flow/pagination scope and do not add S04
advanced DataGrid features.

### Font-access compatibility correction

S03 does not add `boldFont`, `headerFont`, or `smallFont` members to
`GeniusPdfDocumentBuilder`. Existing templates already use nullable fields with
some of those names. Flow components therefore access
`builder.config.boldFont`, `builder.config.headerFont`, and
`builder.config.smallFont` directly. This keeps the pre-S03 template API
backward compatible and avoids invalid Dart overrides.
