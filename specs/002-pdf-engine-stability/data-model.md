# Data Model: PDF Generation Engine Stability and Layout Correctness

**Feature**: `002-pdf-engine-stability`  
**Date**: 2026-05-08  
**Primary Layers**: `lib/src/builders/`, `lib/src/components/widgets/`, `lib/src/services/`, `lib/src/services/export/`

---

## Overview

This feature does not introduce business-data models. Its data model is the set of internal state and outcome structures required to keep PDF generation mechanically correct, traceable, and testable.

---

## Entities

### `BuilderState` (existing logical entity in `GeniusPdfDocumentBuilder`)

Authoritative per-document mutable state owned by `lib/src/builders/pdf_document_builder.dart`.

| Field | Type | Source |
| ----- | ---- | ------ |
| `document` | `PdfDocument` | existing `_document` |
| `currentPage` | `PdfPage?` | existing `_currentPage` |
| `currentIndex` | `int` | existing `_currentIndex` |
| `currentY` | `double` | existing `_currentY` |
| `layoutResult` | `PdfLayoutResult?` | existing `_layoutResult` |
| `headerHeight` | `double` | existing `_headerHeight` |
| `footerHeight` | `double` | existing `_footerHeight` |
| `defaultPageBorderPen` | `PdfPen?` | existing `_defaultPageBorderPen` |

**Invariants**:

- `currentIndex == -1` when no page exists.
- When `currentPage != null`, `0 <= currentIndex < document.pages.count`.
- When a paginating draw call completes, `layoutResult?.page == currentPage`.
- For flow-based placement, `currentY >= headerHeight`.
- For safe placement, `currentY <= pageHeight - footerHeight`.

**Primary transitions**:

- `newPage()`
- `setCurrentPage(...)`
- `updateFromLayoutResult(...)`
- `resetY(...)`
- `reserveHeaderSpace(...)`
- `reserveFooterSpace(...)`
- `generate()`

---

### `PageFlowGuardDecision` (new internal logical entity)

The normalized decision produced before any flow-based component draws.

| Field | Type | Notes |
| ----- | ---- | ----- |
| `operationId` | `String` | e.g. `addSpace`, `addImage`, `addSummary` |
| `requestedHeight` | `double` | height needed by the upcoming operation |
| `spacingBefore` | `double` | spacing requested before drawing |
| `remainingHeight` | `double` | footer-aware remaining height before action |
| `headerHeight` | `double` | reserved header height |
| `footerHeight` | `double` | reserved footer height |
| `decision` | enum-like value | `stay`, `newPage`, `split`, `scale`, `fail` |
| `reason` | `String` | debugging / error context |

**Consumers**:

- `addSpace()`
- `addImage()`
- `addQRCode()`
- `addSummary()`
- `addInfoBox()`
- `addReportHeader()`
- `addSectionDivider()`
- `addBulletList()`

---

### `LayoutSyncSnapshot` (new internal logical entity)

Normalized state extracted from a `PdfLayoutResult` before it is written back into `BuilderState`.

| Field | Type | Notes |
| ----- | ---- | ----- |
| `sourceMethod` | `String` | `addGrid`, `addRichText`, etc. |
| `startPageIndex` | `int` | page index before draw |
| `finalPage` | `PdfPage` | final page returned by Syncfusion |
| `finalPageIndex` | `int` | derived from `document.pages` |
| `finalBottom` | `double` | `result.bounds.bottom` |
| `spacingAfter` | `double` | optional post-layout spacing |
| `paginated` | `bool` | whether the result ended on a later page |

**Purpose**: ensures all paginating components update page reference, page index, `currentY`, and optionally `layoutResult` the same way.

---

### `ComponentPlacementPolicy` (new internal logical entity)

Canonical per-component overflow/fit behavior used by tests and implementation.

| Component | Policy | Failure Mode |
| --------- | ------ | ------------ |
| text | paginate and sync final layout | fail only on invalid renderer state |
| rich text | paginate and sync final layout | fail only on invalid renderer state |
| grid | Syncfusion paginate + final page sync | fail only on invalid renderer state |
| summary | keep together if possible; otherwise move page | explicit layout failure if impossible |
| info box | keep together if possible; otherwise move page | explicit layout failure if impossible |
| report header | keep together if possible; otherwise move page | explicit layout failure if impossible |
| image | scale to fit, otherwise move page or fail | explicit placement failure |
| QR/barcode | validate bounds, draw safely, fail clearly | explicit render/placement failure |
| `addSpace()` | page-break before consuming spacing | no silent footer overlap |
| absolute text | free placement by default; optional validation | explicit validation failure when enabled |

---

### `AbsolutePlacementValidationRequest` (new internal/public-if-needed logical entity)

Represents an opt-in validation request for absolute-position helpers.

| Field | Type | Notes |
| ----- | ---- | ----- |
| `x` | `double` | requested x coordinate |
| `y` | `double` | requested y coordinate |
| `width` | `double` | measured or provided content width |
| `height` | `double` | measured or provided content height |
| `contentBounds` | `Rect` | footer-aware content rect |
| `pageWidth` | `double` | current page width |
| `pageHeight` | `double` | current page height |
| `validateBounds` | `bool` | default false |

**Validation outcomes**:

- `valid`
- overlaps reserved header region
- overlaps reserved footer region
- exceeds page width
- exceeds page height

---

### `GenerationJobState` (existing `GeniusPdfJob`)

Queue-managed generation status owned by `lib/src/services/pdf_generation_manager.dart`.

| Field | Type |
| ----- | ---- |
| `id` | `String` |
| `builder` | `GeniusPdfDocumentBuilder` |
| `fileName` | `String` |
| `priority` | `GeniusPdfJobPriority` |
| `runInBackground` | `bool` |
| `autoOpen` | `bool` |
| `autoShare` | `bool` |
| `autoPrint` | `bool` |
| `status` | `GeniusPdfJobStatus` |
| `progress` | `double` |
| `result` | `GeniusPdfResult?` |
| `errorMessage` | `String?` |

**Lifecycle**:

`queued -> processing -> completed | failed | cancelled`

**Feature-specific requirement**: `result`, `status`, and `errorMessage` must always describe the same final outcome.

---

### `BatchExportMapping` (logical contract over `GeniusBatchExportResult`)

The feature treats batch export traceability as a mapping problem rather than a brand-new business entity.

| Field | Type | Notes |
| ----- | ---- | ----- |
| `results` | `List<GeniusExportResult>` | existing public field |
| `inputIndex` | derived index | must align with the input item index |
| `successCount` | `int` | existing public field |
| `failureCount` | `int` | existing public field |
| `duration` | `Duration` | existing public field |

**Invariant**:

- `results.length == totalCount`
- `results[index]` corresponds to the input batch item at `index`

This avoids a public shape change unless preserving order internally proves insufficient.

---

## Modified Public Outcome Types

### `GeniusPdfResult`

No structural change is required by the plan. The important feature-level rule is behavioral:

- success means non-empty, reopenable bytes
- failure means an explicit `GeniusPdfFailure`, not a silent partial success

### `GeniusExportResult` / `GeniusBatchExportResult`

No new exported classes are required by the plan. The feature relies on stronger mapping and failure semantics rather than a redesigned result hierarchy.

---

## State Transition Summary

### Builder Flow

```text
start
  -> reserve header/footer state (optional)
  -> create page if needed
  -> page-flow guard decides stay/newPage/split/scale/fail
  -> component draws
  -> if PdfLayoutResult exists: build LayoutSyncSnapshot
  -> synchronize BuilderState
  -> continue to next component
  -> generate bytes
```

### Service / Job Flow

```text
job queued
  -> processing
  -> generate canonical raw bytes
  -> optional save
  -> optional open/share/print wrappers
  -> completed or failed or cancelled
```

### Batch Export Flow

```text
input items
  -> export each item
  -> preserve result mapping by input index
  -> aggregate success/failure counts
  -> return GeniusBatchExportResult
```
