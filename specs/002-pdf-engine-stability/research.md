# Research: PDF Generation Engine Stability and Layout Correctness

**Feature**: `002-pdf-engine-stability`  
**Date**: 2026-05-08  
**Status**: Complete - planning decisions resolved

---

## Decision 1: Canonical Output Path

**Decision**: Raw PDF bytes from `GeniusPdfDocumentBuilder.generate()` and `GeniusPdfService.generate()` remain the canonical success contract. Save, open, share, print, and export wrappers must operate on that same validated byte output.

**Rationale**: This matches the constitution's correctness-first and deterministic-output rules. The final clarification question about output-path priority was not answered because the user advanced directly to `/speckit-plan`, so this is an explicit planning inference from the spec, prompt, and current architecture.

**Alternatives considered**:
- Save to file as the primary contract: rejected because file-system and platform-service failures are wrapper concerns, not the core generation contract.
- Preview/print/share as the primary contract: rejected because they all depend on successful raw byte generation first.

---

## Decision 2: Supported Baseline Versions

**Decision**: Keep the current package baseline and do not combine this fix feature with dependency upgrades.

- Dart: `>=3.0.0 <4.0.0`
- Flutter: `>=3.0.0`
- Syncfusion PDF: `syncfusion_flutter_pdf:^32.2.4`
- Printing: `printing:^5.13.3`
- Sharing: `share_plus:^12.0.1`
- File storage: `path_provider:^2.1.4`, `open_file:^3.5.9`
- Media/code generation: `image:^4.3.0`, `barcode:^2.2.8`

**Rationale**: The failures described by the spec are wrapper-layer and builder-layer issues, not version-blocked feature gaps. Upgrading dependencies at the same time would enlarge the diff and weaken defect isolation.

---

## Decision 3: Builder State Coordinator Lives Inside `pdf_document_builder.dart`

**Decision**: Keep state coordination inside `lib/src/builders/pdf_document_builder.dart` using internal helpers rather than introducing a new public coordinator type.

**Rationale**: The file already owns `_currentPage`, `_currentIndex`, `_currentY`, `_layoutResult`, `_headerHeight`, `_footerHeight`, `setCurrentPage()`, and `updateFromLayoutResult()`. The safest change is to make those helpers authoritative rather than scatter more page-state writes across components.

**Current gaps confirmed in code**:
- `addGrid()` updates `_currentY` from `result.bounds.bottom` but does not call `setCurrentPage()` / `updateFromLayoutResult()`.
- `addRichText()` updates `_currentY` only, even though its `draw()` path can paginate.
- `addGridWithSummary()` inherits the grid-sync problem because it composes `addGrid()` and `addSummary()`.

**Alternatives considered**:
- New public `BuilderStateCoordinator` class: rejected as unnecessary API surface for an internal invariants problem.
- Per-component sync logic: rejected because the bug pattern is shared across multiple `PdfLayoutResult` consumers.

---

## Decision 4: Centralize Page Flow Guarding Before Coordinates Are Calculated

**Decision**: Flow guards must run before any final `drawY` or placement bounds are derived. `addSpace()` becomes footer-aware and page-breaking. Helpers that currently calculate positions before `_ensureSpace()` must be corrected.

**Rationale**: Several helpers currently compute placement from stale pre-break state:

- `addImage()` computes `drawY` before `_ensureSpace()`
- `addQRCode()` computes `drawY` before `_ensureSpace()`
- auto-positioned `addHorizontalLine()` computes `yPos` before `_ensureSpace()`
- `addSpace()` only calls `_advanceY()` and can move directly into the footer band

These are not isolated component bugs; they are a shared guard-ordering problem.

**Alternatives considered**:
- Patch each bug ad hoc: rejected because the same stale-position pattern already appears in multiple helpers.
- Clamp `currentY` after the fact: rejected because it hides the real continuation error and can still place content on the wrong page.

---

## Decision 5: `PdfLayoutResult` Synchronization Applies to Every Paginating Draw Path

**Decision**: Every draw path that returns or internally depends on `PdfLayoutResult` must synchronize builder state through one common helper, not just the grid path.

**Rationale**: The spec calls out grids, but the same state-shift risk exists anywhere Syncfusion paginates. Fixing grids alone would leave similar continuation bugs in rich text and any long flowing text path that can move onto a later page.

**Minimum scope**:
- `addGrid()`
- `addRichText()`
- any text path where the final result page can differ from the starting page
- convenience flows that chain paginated components (`addGridWithSummary()`, `addReportSummary()`)

---

## Decision 6: Component Overflow Behavior Remains Component-Specific

**Decision**: Preserve the clarified component-specific overflow policy instead of forcing one global rule.

**Policy table**:

| Component | Behavior |
| --------- | -------- |
| Text / rich text | Paginate using Syncfusion layout result and sync final page |
| Grid | Use Syncfusion pagination and sync final page/result |
| Summary / info box / report header | Keep together when possible; move to next page if they do not fit |
| Image | Scale to available bounds when safe; otherwise fail clearly |
| QR / barcode | Validate render bounds and fail clearly on invalid placement/rendering |
| `addSpace()` | Auto-create a new page when remaining usable height is insufficient |
| Absolute-position helpers | Continue to allow overlap by default; validation is optional and explicit |

**Rationale**: This is the smallest behavior-preserving route and matches the clarified spec.

---

## Decision 7: Absolute Position Helpers Stay Supported with Optional Validation

**Decision**: `addTextAt()` and similar absolute helpers remain supported. If external control is required, the preferred additive surface is a default-off `validateBounds` parameter that checks content bounds and reserved header/footer regions.

**Rationale**: The clarified direction was to preserve power and API compatibility while enabling safe-mode validation. A default-off additive toggle gives that without forcing existing templates into a flow-layout rewrite.

**Preferred additive signature if needed**:

```dart
void addTextAt(
  String text, {
  required double x,
  required double y,
  PdfFont? font,
  PdfBrush? brush,
  PdfStringFormat? format,
  bool validateBounds = false,
})
```

**Alternatives considered**:
- Always validate and reject unsafe placement: rejected because it can break existing templates silently on upgrade.
- Deprecate absolute positioning entirely: rejected because the spec explicitly preserves these helpers.

---

## Decision 8: Batch and Service Failure Reporting Must Preserve Item Traceability

**Decision**: `GeniusPdfGenerationManager` continues to use job IDs as the per-item traceability mechanism. `GeniusBatchExporter` must preserve input/result mapping by keeping `results[index]` aligned to `items[index]` and honoring `stopOnError` deterministically.

**Rationale**: The current batch exporter appends results in completion order while exposing only a plain `List<GeniusExportResult>`, which makes it harder to identify which input item failed. Reordering internally is enough to fix this without inventing a larger public API.

**Alternatives considered**:
- Add a new public `BatchExportItemResult` model: rejected unless internal result-order preservation proves insufficient.
- Keep completion-order results: rejected because the spec requires callers to identify exactly which jobs failed.

---

## Decision 9: Regression Test Strategy

**Decision**: Add a new `test/pdf_stability/` suite from package root using `flutter_test`. Structural validity checks use raw bytes plus `PdfDocument(inputBytes: bytes)` reopening, page-count inspection, and builder-state assertions.

**Rationale**: The repo currently has financial tests only. The PDF stability feature needs its own dedicated regression layer for builder state, paginated continuation, media placement, and wrapper failures.

**Planned test groups**:
- `builder_state_test.dart`
- `layout_flow_test.dart`
- `grid_summary_sync_test.dart`
- `media_and_rtl_test.dart`
- `service_reliability_test.dart`

**Manual fixtures**:
- `example/lib/documents/smart_space_demo_document.dart`
- `example/lib/documents/multi_grid_summary_demo_document.dart`
- `example/lib/documents/qr_attachments_demo_document.dart`

---

## Decision 10: Platform Verification Order

**Decision**: Automated coverage remains platform-neutral. Manual verification starts on the Windows example runner because that is the current workspace target and the example already includes Windows plugin registration for `printing` and `share_plus`. If wrapper flows change, mobile/web smoke follows as a second step.

**Rationale**: This gives a real local validation loop without pretending that Windows-specific success proves every platform-service path automatically.

---

## Resolved Planning Assumptions

| Topic | Resolution |
| ----- | ---------- |
| Primary output path | Raw PDF bytes (planning inference because the final clarify question was skipped) |
| Builder ownership | Internal helper refactor inside `pdf_document_builder.dart` |
| Overflow behavior | Component-specific, per clarified spec |
| `addSpace()` behavior | Auto page-break when remaining space is insufficient |
| Absolute-position policy | Keep supported, add optional validation only |
| Batch traceability | Preserve input/result mapping without broad public API churn |
