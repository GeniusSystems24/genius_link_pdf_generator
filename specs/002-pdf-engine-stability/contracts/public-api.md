# Public API Contract: PDF Generation Engine Stability and Layout Correctness

**Feature**: `002-pdf-engine-stability`  
**Date**: 2026-05-08  
**Barrel**: `lib/genius_link_pdf_generator.dart`

---

## Public Surface Summary

This feature is primarily behavioral. The core public surfaces under review are:

- `GeniusPdfDocumentBuilder`
- `GeniusPdfReportComposer`
- `GeniusPdfService`
- `GeniusPdfGenerationManager`
- `GeniusPdfResult`
- `GeniusPdfExportService`
- `GeniusBatchExporter`
- `GeniusExportResult` / `GeniusBatchExportResult`

No existing public name should be removed or renamed.

---

## Planned SemVer Impact

**Preferred target**: PATCH, if all changes remain internal behavior fixes.

**Allowed escalation**: MINOR, but only if absolute-position validation requires an additive optional public parameter such as `validateBounds` on `addTextAt()` or a similarly additive helper/config surface.

Any public additive change requires README + CHANGELOG updates in the same change.

---

## Behavioral Guarantees

### 1. Canonical Generation Contract

- `GeniusPdfDocumentBuilder.generate()` remains the canonical raw-byte generation entry point.
- Successful generation means non-empty bytes that can be reopened by `PdfDocument(inputBytes: bytes)`.
- Save/open/share/print/export wrappers must build on those same bytes rather than inventing alternate success criteria.

### 2. Builder State Guarantees

- `newPage()` starts at the content area top (`headerHeight`), not page Y=0.
- `currentPage`, `pageCount`, `currentY`, and any tracked layout result must stay synchronized after paginated component draws.
- `addGridWithSummary()` must place the summary on the final page of the grid or move it safely to the next page when it does not fit.
- `addSpace()` must create a new page automatically when the remaining usable height is insufficient.

### 3. Header/Footer Safety

- No flow-based component may silently overlap reserved header/footer regions.
- `remainingHeight` and `contentBounds` remain footer-aware contracts.

### 4. Failure Reporting

- `GeniusPdfService.generate*()` methods must return `GeniusPdfFailure` when generation, save, open, or share fails.
- `GeniusPdfGenerationManager` must keep per-job failure visibility through job IDs and final job state.
- `GeniusExportFailure` remains the error contract for export/save failures.
- `GeniusBatchExportResult` must let callers identify which input item failed by preserving input/result mapping.

---

## Unchanged Public APIs

The following APIs stay supported exactly as concepts, even if internal behavior is corrected:

- `GeniusPdfDocumentBuilder.addTextAt()`
- `GeniusPdfDocumentBuilder.addGrid()`
- `GeniusPdfDocumentBuilder.addSummary()`
- `GeniusPdfDocumentBuilder.addGridWithSummary()`
- `GeniusPdfDocumentBuilder.addImage()`
- `GeniusPdfDocumentBuilder.addQRCode()`
- `GeniusPdfService.generate()`
- `GeniusPdfService.generateAndSave()`
- `GeniusPdfService.generateAndOpen()`
- `GeniusPdfService.generateAndShare()`
- `GeniusPdfGenerationManager` job queue API
- `GeniusPdfExportService.export*()`
- `GeniusBatchExporter.exportBatch()` and related helpers

---

## Preferred Additive API (Only If Needed)

If external control is required for the clarified absolute-position safety rule, the preferred additive public contract is:

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

**Behavior**:

- `validateBounds: false` preserves current free-placement behavior.
- `validateBounds: true` validates placement against current page content bounds and reserved header/footer zones.
- Invalid placement fails clearly rather than silently drawing outside the intended region.

If the implementation can achieve the same feature requirement without a new public parameter, PATCH scope is preferred.

---

## Batch Export Contract

`GeniusBatchExporter` keeps its current broad surface, but the planned contract is stronger:

- `results.length == totalCount`
- `results[index]` corresponds to the input item at `index`
- `successCount` and `failureCount` match the classified results
- `stopOnError` stops scheduling further work deterministically after the first failure boundary

No broad result-hierarchy redesign is planned.

---

## Documentation Triggers

README and CHANGELOG updates are required if:

- an additive public parameter/configuration surface is introduced
- a user-visible behavior contract changes in a way consumers must understand explicitly

If all fixes remain internal and behavior-only, documentation changes can stay limited to examples or release notes.
