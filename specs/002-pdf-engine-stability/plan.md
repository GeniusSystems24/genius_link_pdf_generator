# Implementation Plan: PDF Generation Engine Stability and Layout Correctness

**Branch**: `002-pdf-engine-stability` | **Date**: 2026-05-08 | **Spec**: [spec.md](spec.md)  
**Input**: Feature specification from `specs/002-pdf-engine-stability/spec.md`

---

## Summary

Stabilize the library's PDF generation core without rewriting the package or replacing Syncfusion. The implementation will be test-first and focused on five concrete areas: builder state coordination in `lib/src/builders/pdf_document_builder.dart`, centralized page-flow guarding, mandatory synchronization from `PdfLayoutResult` back into builder state, component-specific overflow behavior for grids/summaries/images/QR-barcode content, and consistent failure reporting in the generation/export wrappers. The canonical success path remains raw PDF bytes from `GeniusPdfDocumentBuilder.generate()` / `GeniusPdfService.generate()`; save, open, share, print, and export flows must wrap that same validated output path.

---

## Technical Context

**Language/Version**: Dart `>=3.0.0 <4.0.0` / Flutter `>=3.0.0`  
**Primary Dependencies**: `syncfusion_flutter_pdf:^32.2.4`, `printing:^5.13.3`, `share_plus:^12.0.1`, `path_provider:^2.1.4`, `open_file:^3.5.9`, `image:^4.3.0`, `barcode:^2.2.8`  
**Storage**: Raw PDF bytes are the canonical output; save/export wrappers write those bytes to local files, temp files, and platform print/share services  
**Testing**: `flutter test` for focused package-root regression suites, `flutter analyze lib test example`, plus manual example verification for print/share/viewer flows where platform services are involved  
**Target Platform**: Flutter package consumed by mobile, desktop, and web apps; current manual-first environment is Windows  
**Project Type**: Flutter package / library  
**Performance Goals**: Preserve current generation throughput, avoid extra full-document passes where possible, and keep layout validation bounded to the component currently being placed  
**Constraints**: No whole-library rewrite; no Syncfusion replacement; no template redesign unless a template exposes a generation defect; no business-data validation; preserve public API compatibility unless an additive optional parameter is required for absolute-position validation; keep raw-byte generation deterministic  
**Scale/Scope**: Core changes centered on `lib/src/builders/`, selected `lib/src/components/widgets/`, `lib/src/services/`, and `lib/src/services/export/`; new `test/pdf_stability/` suites; manual verification through `example/lib/documents/`; README/CHANGELOG only if public API or user-visible behavior changes

---

## Constitution Check

### I. PDF Generation Correctness First - PASS

This feature is explicitly about structural validity, page-flow correctness, and safe wrapper behavior. No ergonomics or feature expansion is allowed to weaken openability, page integrity, or output correctness.

### II. Scope Boundary - PASS

All work stays inside PDF generation mechanics: page state, page breaks, header/footer reservations, layout bounds, component placement, raw-byte generation, and save/share/export failure handling. No business-data, tax, voucher, or financial semantic validation is introduced.

### III. Builder State Integrity - PASS

The main implementation target is state synchronization around `_currentPage`, `_currentIndex`, `_currentY`, `_layoutResult`, `_headerHeight`, and `_footerHeight`. The design centralizes updates in builder helpers rather than scattering bespoke state writes per component.

### IV. Header/Footer Safety - PASS

All page-flow fixes are required to respect reserved header/footer zones. `newPage()`, `addSpace()`, keep-together components, and post-pagination sync must all land inside the content area rather than silently pushing into the footer band.

### V. Multi-page Component Safety - PASS

The plan treats `PdfLayoutResult` as the authoritative continuation signal. `addGrid()`, `addRichText()`, and any other paginating draw path must update page reference, page index, and `currentY` from the final layout result before subsequent content is placed.

### VI. Deterministic PDF Output - PASS

The canonical output path is raw PDF bytes. The feature will not add timestamps, random identifiers, or mutable global state to library generation defaults. Existing example-only timestamps remain example behavior, not core output requirements.

### VII. Fail Fast With Clear Errors - PASS

Unsafe placement, impossible fit requests, barcode/QR render failures, and export/save wrapper failures must return or throw explicit errors instead of producing clipped, empty, or silently corrupted output.

### VIII. Test Before Fix - PASS

There are currently no builder/layout regression tests in the repo. Phase A introduces failing reproduction tests first for page-flow, grid-summary sync, media overflow, and service/export failure handling before implementation changes begin.

### IX. Minimal Public API Breakage - PASS

The default plan is behavior fixes with no breaking public API changes. If absolute-position validation requires a public toggle, it must be additive, optional, default-off, and documented as a MINOR bump. Everything else should ship as PATCH-safe behavioral correction.

### X. Documentation Discipline - PASS

README, CHANGELOG, and example updates are conditional on public or user-visible behavior changes. Example documents used for manual verification are part of done for this feature even if the README remains unchanged.

### XI. Regression Protection - PASS

This feature formalizes regression coverage for known page-flow issues that previously lived only in examples and ad hoc manual testing. The new suites become the canonical guardrail for later builder/service changes.

### XII. Resource Safety - PASS

Generation and export wrappers already dispose documents/builders in several paths; this feature reviews those paths to ensure failure handling still preserves deterministic cleanup and does not mask the original error.

### XIII. Platform Awareness - PASS

Implementation stays platform-neutral at the raw-byte layer. Manual-first verification will run on Windows because that is the current workspace target, then any changed print/share wrappers receive platform smoke follow-up rather than Windows-only assumptions.

### XIV. No Silent Layout Corruption - PASS

The implementation explicitly rejects silent clipping, stale-page continuation, footer overlap, and out-of-bounds absolute placement when validation is enabled. Clear failure beats invisible corruption.

---

## Project Structure

### Documentation (this feature)

```text
specs/002-pdf-engine-stability/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
|   `-- public-api.md
|-- checklists/
|   `-- requirements.md
`-- tasks.md
```

### Source Code Changes

```text
lib/
|-- genius_link_pdf_generator.dart                 MAY CHANGE only if a new additive public API/config type is exported
`-- src/
    |-- builders/
    |   `-- pdf_document_builder.dart             MODIFIED - state sync, page-flow guard, component placement rules
    |-- components/
    |   `-- widgets/
    |       |-- pdf_data_grid.dart                MODIFIED - pagination result handoff remains authoritative
    |       |-- pdf_barcode.dart                  MODIFIED - safe render failure behavior if reproduced
    |       |-- pdf_summary.dart                  MODIFIED only if summary keep-together/bounds behavior needs component changes
    |       `-- pdf_report_header.dart            MODIFIED only if report-header fit behavior needs component changes
    |-- models/
    |   `-- pdf_result.dart                       POSSIBLE MODIFIED - only if clearer failure context becomes necessary
    |-- services/
    |   |-- pdf_service.dart                      MODIFIED - canonical bytes, save/share/open failure propagation
    |   `-- pdf_generation_manager.dart           MODIFIED - per-job reliability, auto-actions after successful bytes only
    `-- services/export/
        |-- pdf_export_service.dart               MODIFIED - export/save failure propagation
        `-- batch_exporter.dart                   MODIFIED - preserve input-result mapping and stopOnError semantics

test/
`-- pdf_stability/                               NEW - focused builder/layout/service regression suites
    |-- builder_state_test.dart
    |-- layout_flow_test.dart
    |-- grid_summary_sync_test.dart
    |-- media_and_rtl_test.dart
    `-- service_reliability_test.dart

example/
`-- lib/documents/
    |-- smart_space_demo_document.dart           MODIFIED - manual verification fixture for header/footer/page-flow behavior
    |-- multi_grid_summary_demo_document.dart    MODIFIED - manual verification fixture for grid-summary sync
    `-- qr_attachments_demo_document.dart        MODIFIED - manual verification fixture for image/QR safety
```

**Structure Decision**:

- `lib/src/builders/` owns the state coordinator and page-flow guard because the broken invariants originate there.
- `lib/src/components/widgets/` is only touched where a component must surface safer layout information or fail more clearly; the plan avoids moving layout policy into templates.
- `lib/src/services/` and `lib/src/services/export/` own wrapper reliability, per-job status propagation, and input-to-result mapping.
- `test/pdf_stability/` is a new feature-local suite because the repo currently has financial tests only, not builder/layout/service regression coverage.
- `example/lib/documents/` remains the manual reproduction surface; no new example app scaffolding is required.

---

## Phase 0: Research Summary

Research findings are captured in [research.md](research.md). The planning decisions that drive implementation are:

1. Raw PDF bytes are the canonical output contract; all wrappers validate and transport that same output path.
2. The builder keeps ownership of page state coordination; no new public coordinator type is introduced.
3. Component overflow is intentionally component-specific, not a single global policy.
4. `addSpace()` becomes footer-aware and page-breaking when necessary.
5. `PdfLayoutResult` synchronization applies to all paginating draw paths, not just grids.
6. Absolute-position helpers stay supported; any validation toggle must be additive and default-off.
7. Batch export results must remain traceable back to the input sequence without inventing a new broad public surface unless internal ordering fixes prove insufficient.

---

## Phase A: Reproduction Tests and Fixtures

*Prerequisite: none. No implementation fixes land before these tests exist and fail.*

### A.1 - Builder state suite (`test/pdf_stability/builder_state_test.dart`)

Cover the core state invariants:

- initial state before any page exists
- `newPage()` resets `currentY` to `headerHeight`
- `reserveHeaderSpace()` / `reserveFooterSpace()` affect `remainingHeight`
- `addSpace()` creates a new page when the requested spacing crosses the footer boundary
- `canFit()` and `contentBounds` remain footer-aware
- `updateFromLayoutResult()` moves `currentPage`, `currentIndex`, and `currentY` together

### A.2 - Layout flow suite (`test/pdf_stability/layout_flow_test.dart`)

Create failing reproductions for:

- long flowing text over multiple pages
- content placed near the footer band
- `addImage()` stale `drawY` after auto page-break
- `addQRCode()` stale `drawY` after auto page-break
- auto-positioned `addHorizontalLine()` after page-break
- `addSectionDivider()` and `addReportHeader()` keep-together behavior

### A.3 - Grid and summary suite (`test/pdf_stability/grid_summary_sync_test.dart`)

Cover:

- one-page grid
- multi-page grid
- summary immediately after multi-page grid
- `addGridWithSummary()` keeps the summary on the grid's final page or safely moves it forward
- multiple grids with final report summary
- `pageCount`, `currentPage`, and `currentY` match the final paginated result

### A.4 - Media and RTL suite (`test/pdf_stability/media_and_rtl_test.dart`)

Cover:

- oversized image scaled to fit available content bounds
- impossible image placement fails clearly instead of clipping silently
- invalid barcode/QR payload failure remains explicit and does not corrupt surrounding output
- LTR and RTL alignment parity for text and aligned media
- bilingual layouts keep column order and do not overlap

### A.5 - Service reliability suite (`test/pdf_stability/service_reliability_test.dart`)

Cover:

- `GeniusPdfService.generate()` returns non-empty bytes on success
- service failures return `GeniusPdfFailure`, not silent success
- generation manager per-job success/failure tracking
- auto-open/share/print run only after successful byte generation and file save
- batch export preserves input/result mapping and respects `stopOnError`

### A.6 - Shared structural validation helper

Use `PdfDocument(inputBytes: bytes)` in tests to confirm:

- bytes are non-empty
- the saved bytes reopen successfully
- expected page count is observable from the reopened document

---

## Phase B: Builder State Coordinator and Page Flow Guard

*Prerequisite: Phase A tests exist and fail against current behavior.*

### B.1 - Centralize state synchronization in `pdf_document_builder.dart`

Refactor the builder so paginating operations update state through one path instead of hand-written assignments. The target ownership is:

- `setCurrentPage(...)`
- `updateFromLayoutResult(...)`
- explicit helpers for "after-new-page" and "after-non-paginated-draw" state updates

### B.2 - Harden flow guards before draw coordinates are computed

Correct methods that currently compute placement from stale pre-break state:

- `addSpace()`
- `addImage()`
- `addQRCode()`
- auto-positioned `addHorizontalLine()`
- any other helper that calculates `drawY` before calling `_ensureSpace()`

### B.3 - Introduce impossible-fit failure logic

If content cannot fit, split, scale, or move safely:

- do not silently clamp or clip
- return/throw a clear error identifying the component and the invalid bounds condition

### B.4 - Preserve deterministic generation entry

`generate()` remains the canonical raw-byte entry point. No extra hidden page creation, timestamp injection, or wrapper-side state mutation is added there.

---

## Phase C: Component Integration Fixes

*Prerequisite: Phase B complete and builder invariants enforced.*

### C.1 - Layout-result consumers

Update `PdfLayoutResult` flows so the final page becomes authoritative for subsequent drawing:

- `addGrid()`
- `addRichText()`
- any paginating text path that can return a final page different from the starting page
- `addGridWithSummary()` and `addReportSummary()` convenience wrappers

### C.2 - Keep-together components

Ensure summary/info-box/report-header style components:

- estimate or pre-compute needed height conservatively
- move to a new page when they do not fit
- never draw into the footer zone

### C.3 - Media and code components

Apply the clarified policy:

- images scale when safe, otherwise fail clearly
- QR/barcode drawing validates render bounds and propagates clear failures
- full-page image attachments respect header/footer and margin boundaries

### C.4 - Absolute-position validation

Keep `addTextAt()` available. If public control is required, the preferred additive contract is:

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

Behavioral contract:

- default remains existing free-placement behavior
- `validateBounds: true` checks content bounds and reserved header/footer regions
- unsafe placement fails clearly instead of silently drawing outside the intended region

If the same behavior can be achieved without a public parameter, PATCH scope is preferred.

---

## Phase D: Service, Batch, and Export Reliability

*Prerequisite: raw-byte generation is stable and component placement regressions are closed.*

### D.1 - `pdf_service.dart`

Keep the service wrappers thin over canonical bytes:

- generate raw bytes once
- save/open/share from that same byte source
- return `GeniusPdfFailure` on generation, save, open, or share failure
- preserve deterministic cleanup in `finally`

### D.2 - `pdf_generation_manager.dart`

Tighten per-job reliability:

- job IDs remain the per-item identity source
- auto actions (`autoOpen`, `autoShare`, `autoPrint`) run only after successful bytes and file save
- cancellation cleanup must not hide the original generation failure
- `job.result` and `job.errorMessage` always match the real final status

### D.3 - `batch_exporter.dart` and `pdf_export_service.dart`

Improve batch traceability without broad API churn:

- preserve `results.length == items.length`
- keep `results[index]` aligned to input `items[index]`
- maintain `stopOnError` semantics deterministically
- surface `GeniusExportFailure` for file-system/export failures, not partial success shells

### D.4 - Result-model review

`lib/src/models/pdf_result.dart` should only change if the current failure surface is insufficient to explain a newly validated error. Any such change must be additive only.

---

## Phase E: Examples, Docs, and Validation

*Prerequisite: all regression suites pass and wrapper behavior is stable.*

### E.1 - Example fixtures

Update the existing example documents so they are useful regression fixtures:

- `smart_space_demo_document.dart`
- `multi_grid_summary_demo_document.dart`
- `qr_attachments_demo_document.dart`

These examples must demonstrate the corrected behavior rather than merely exercise the API.

### E.2 - Documentation policy

- If no public API changes are introduced, README/CHANGELOG updates are optional and limited to user-visible behavior notes.
- If absolute-position validation or any other additive public surface is introduced, update `README.md` and `CHANGELOG.md` in the same change and treat the release as MINOR.

### E.3 - Verification commands

Expected final verification from package root:

```powershell
flutter test test/pdf_stability
flutter analyze lib test example
```

Manual-first follow-up:

```powershell
cd example
flutter run -d windows
```

Use the example app to generate the stability documents and verify:

- no header/footer overlap
- correct multi-page grid -> summary continuation
- safe image/QR behavior
- RTL/LTR parity
- non-empty, reopenable bytes

---

## Complexity Tracking

No constitution violations are planned. If implementation later requires a public additive API for absolute-position validation, that remains acceptable only as an additive, default-off change with matching docs and SemVer handling.

---

## Artifacts

| Artifact | Path | Status |
| -------- | ---- | ------ |
| Spec | `specs/002-pdf-engine-stability/spec.md` | Complete |
| Requirements checklist | `specs/002-pdf-engine-stability/checklists/requirements.md` | Complete |
| Research | `specs/002-pdf-engine-stability/research.md` | Complete |
| Data model | `specs/002-pdf-engine-stability/data-model.md` | Complete |
| Public API contract | `specs/002-pdf-engine-stability/contracts/public-api.md` | Complete |
| Quickstart | `specs/002-pdf-engine-stability/quickstart.md` | Complete |
| Plan (this file) | `specs/002-pdf-engine-stability/plan.md` | Complete |
| Tasks | `specs/002-pdf-engine-stability/tasks.md` | Next: `/speckit-tasks` |
