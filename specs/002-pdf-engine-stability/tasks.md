# Tasks: PDF Generation Engine Stability and Layout Correctness

**Input**: Design documents from `/specs/002-pdf-engine-stability/`
**Prerequisites**: `plan.md` (required), `spec.md` (required for user stories), `research.md`, `data-model.md`, `contracts/public-api.md`, `quickstart.md`

**Validation**: Validation is mandatory in this repo. This feature explicitly requires automated regression tests plus targeted `flutter analyze`, focused PDF openability checks, and manual example verification for rendering/export/share flows.

**Organization**: Tasks are grouped by user story so each story can be implemented and verified independently.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel when the task touches different files and does not depend on unfinished work
- **[Story]**: Which user story this task belongs to (`[US1]`, `[US2]`, `[US3]`, `[US4]`, `[US5]`, `[US6]`)
- Every task below names the exact file paths it must inspect or modify

## Phase 1: Setup (Shared Context)

**Purpose**: Confirm the exact package surfaces, baseline defects, and verification fixtures before edits begin.

- [ ] T001 Audit builder state transitions, pagination helpers, and absolute-position paths in `lib/src/builders/pdf_document_builder.dart`
- [ ] T002 [P] Audit generation/export failure handling in `lib/src/services/pdf_service.dart`, `lib/src/services/pdf_generation_manager.dart`, `lib/src/services/export/pdf_export_service.dart`, and `lib/src/services/export/batch_exporter.dart`
- [ ] T003 [P] Audit paginated/media component behavior in `lib/src/components/widgets/pdf_data_grid.dart`, `lib/src/components/widgets/pdf_rich_text.dart`, `lib/src/components/widgets/pdf_summary.dart`, `lib/src/components/widgets/pdf_info_box.dart`, `lib/src/components/widgets/pdf_report_header.dart`, `lib/src/components/widgets/pdf_barcode.dart`, `lib/src/components/widgets/summary/genius_pdf_q_r_code.dart`, and `lib/src/components/widgets/pdf_watermark.dart`
- [ ] T004 [P] Confirm high-risk reproduction fixtures in `example/lib/documents/smart_space_demo_document.dart`, `example/lib/documents/multi_grid_summary_demo_document.dart`, `example/lib/documents/qr_attachments_demo_document.dart`, `example/lib/documents/components/grid_watermark_demo_builder.dart`, `example/lib/documents/components/info_box_demo_builder.dart`, `example/lib/documents/components/rich_text_demo_builder.dart`, and `example/lib/documents/components/summary_demo_builder.dart`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Create the shared regression scaffolding used by all stories.

- [ ] T005 Create shared PDF openability and page-count assertions in `test/pdf_stability/support/pdf_openability_assertions.dart`
- [ ] T006 [P] Create reusable builder/layout fixtures in `test/pdf_stability/support/pdf_stability_fixtures.dart`
- [ ] T007 [P] Create reusable invalid-media and batch-failure fixtures in `test/pdf_stability/support/pdf_failure_scenarios.dart`

**Checkpoint**: Shared test helpers exist and all story work can build on the same structural validation pattern.

---

## Phase 3: User Story 1 - Safe Multi-Page Document Generation (Priority: P1)

**Goal**: Make the core builder produce valid multi-page PDFs with correct page state and safe general page-break behavior.

**Independent Test**: Generate multi-page documents with long text and forced overflow; verify non-empty bytes, PDF openability, page count, and correct final builder state without overlap or corruption.

### Validation for User Story 1

- [ ] T008 [P] [US1] Add builder state regression coverage for `currentY`, `remainingHeight`, `newPage()`, `resetY()`, `reserveHeaderSpace()`, `reserveFooterSpace()`, and `generate()` in `test/pdf_stability/builder_state_test.dart`
- [ ] T009 [P] [US1] Add general page-break regressions for long text, rich text, section dividers, large spacing, and content near the footer in `test/pdf_stability/layout_flow_test.dart`

### Implementation for User Story 1

- [ ] T010 [US1] Refactor shared builder state transitions in `lib/src/builders/pdf_document_builder.dart` so `newPage()`, `resetY()`, `reserveHeaderSpace()`, `reserveFooterSpace()`, and `generate()` keep page state consistent
- [ ] T011 [US1] Fix pre-break coordinate ordering in `lib/src/builders/pdf_document_builder.dart` for `addSpace()`, `addHorizontalLine()`, flowing text paths, and any helper that computes draw positions before `_ensureSpace()`
- [ ] T012 [US1] Update manual regression fixtures in `example/lib/documents/smart_space_demo_document.dart` and `example/lib/documents/components/rich_text_demo_builder.dart` to exercise forced multi-page flow safely

**Checkpoint**: User Story 1 is functional and verifiable on its own.

---

## Phase 4: User Story 2 - Header and Footer Safety (Priority: P1)

**Goal**: Keep every continuation page and keep-together component inside the content zone between the reserved header and footer.

**Independent Test**: Generate multi-page documents with reserved header/footer space and components placed near the bottom boundary; verify no content overlaps reserved regions on any page.

### Validation for User Story 2

- [ ] T013 [US2] Add header/footer boundary and keep-together regressions for summaries, info boxes, report headers, and near-footer content in `test/pdf_stability/layout_flow_test.dart`

### Implementation for User Story 2

- [ ] T014 [US2] Make content-zone start and footer-aware remaining-height calculations authoritative in `lib/src/builders/pdf_document_builder.dart`
- [ ] T015 [US2] Fix near-footer keep-together behavior in `lib/src/components/widgets/pdf_summary.dart`, `lib/src/components/widgets/pdf_info_box.dart`, and `lib/src/components/widgets/pdf_report_header.dart`
- [ ] T016 [US2] Update header/footer verification fixtures in `example/lib/documents/report_composer_demo_document.dart`, `example/lib/documents/components/info_box_demo_builder.dart`, and `example/lib/documents/components/summary_demo_builder.dart`

**Checkpoint**: User Stories 1 and 2 both work independently.

---

## Phase 5: User Story 3 - Multi-Page Grid and Summary Synchronization (Priority: P1)

**Goal**: Ensure multi-page grids leave the builder on the correct final page so summaries and follow-up sections continue below the last rendered grid row.

**Independent Test**: Render grids that span multiple pages, then render summaries immediately after them; verify the summary stays on the grid's final page or moves safely to the next page when required.

### Validation for User Story 3

- [ ] T017 [US3] Add grid pagination, repeated grid-plus-summary, and final page-state regressions in `test/pdf_stability/grid_summary_sync_test.dart`

### Implementation for User Story 3

- [ ] T018 [US3] Synchronize `currentPage`, page index, `currentY`, and layout result from `PdfLayoutResult` in `lib/src/builders/pdf_document_builder.dart`
- [ ] T019 [US3] Keep grid draw results authoritative in `lib/src/components/widgets/pdf_data_grid.dart` and the summary follow-up flows in `lib/src/builders/pdf_document_builder.dart`
- [ ] T020 [US3] Update `example/lib/documents/multi_grid_summary_demo_document.dart` to remain the canonical manual reproduction fixture for grid-summary continuation

**Checkpoint**: All P1 continuation and pagination defects are reproducible and fixable through the shared builder flow.

---

## Phase 6: User Story 4 - RTL and LTR Layout Correctness (Priority: P2)

**Goal**: Preserve correct alignment, mirrored positioning, and bilingual non-overlap for both RTL and LTR documents across page breaks and constrained layouts.

**Independent Test**: Generate the same small-page and portrait/landscape documents in RTL and LTR modes; verify mirrored alignment, readable bilingual layouts, and clean page-break behavior in both directions.

### Validation for User Story 4

- [ ] T021 [US4] Add RTL/LTR, portrait/landscape, and bilingual non-overlap regressions in `test/pdf_stability/media_and_rtl_test.dart`

### Implementation for User Story 4

- [ ] T022 [US4] Fix direction-aware layout defaults and mirrored positioning in `lib/src/builders/pdf_document_builder.dart` and `lib/src/components/widgets/pdf_rich_text.dart`
- [ ] T023 [US4] Fix bilingual alignment and non-overlap behavior in `lib/src/components/widgets/pdf_report_header.dart`, `lib/src/components/widgets/pdf_summary.dart`, and `lib/src/components/widgets/pdf_info_box.dart`
- [ ] T024 [US4] Update RTL/LTR verification fixtures in `example/lib/documents/report_document.dart` and `example/lib/documents/components/rich_text_demo_builder.dart`

**Checkpoint**: User Story 4 is independently testable in both directions and orientations.

---

## Phase 7: User Story 5 - Image, QR, and Barcode Safety (Priority: P2)

**Goal**: Make image, QR, barcode, and watermark drawing deterministic, bounds-aware, and explicit about failure instead of silently corrupting output.

**Independent Test**: Generate documents with oversized images, invalid QR/barcode payloads, and watermark/media combinations; verify scale-or-fail behavior, preserved PDF openability, and safe surrounding content.

### Validation for User Story 5

- [ ] T025 [US5] Add oversized image, QR/barcode failure, and watermark coexistence regressions in `test/pdf_stability/media_and_rtl_test.dart`

### Implementation for User Story 5

- [ ] T026 [US5] Fix image page-break ordering and scale-or-fail placement behavior in `lib/src/builders/pdf_document_builder.dart`
- [ ] T027 [US5] Harden barcode validation and render-failure handling in `lib/src/components/widgets/pdf_barcode.dart`
- [ ] T028 [US5] Harden QR, full-page media, and watermark bounds behavior in `lib/src/components/widgets/summary/genius_pdf_q_r_code.dart` and `lib/src/components/widgets/pdf_watermark.dart`
- [ ] T029 [US5] Update `example/lib/documents/qr_attachments_demo_document.dart` and `example/lib/documents/components/grid_watermark_demo_builder.dart` to verify safe media placement manually

**Checkpoint**: User Story 5 handles deterministic media placement and explicit render failures without corrupting the surrounding PDF.

---

## Phase 8: User Story 6 - Export, Save, and Batch Generation (Priority: P2)

**Goal**: Preserve raw-byte generation as the canonical success path while surfacing per-job and per-batch failures clearly through service and export wrappers.

**Independent Test**: Run successful and intentionally failing generation jobs, save/open/share flows, and mixed batch exports; verify non-empty bytes on success and explicit result objects for each failure without swallowed exceptions.

### Validation for User Story 6

- [ ] T030 [US6] Add generation, wrapper-failure, batch mapping, `stopOnError`, and disposal regressions in `test/pdf_stability/service_reliability_test.dart`

### Implementation for User Story 6

- [ ] T031 [US6] Fix canonical raw-byte generation and wrapper failure propagation in `lib/src/services/pdf_service.dart`
- [ ] T032 [US6] Fix per-job result, status, progress, and error synchronization in `lib/src/services/pdf_generation_manager.dart`
- [ ] T033 [US6] Fix export failure propagation and input-result mapping in `lib/src/services/export/pdf_export_service.dart` and `lib/src/services/export/batch_exporter.dart`
- [ ] T034 [US6] Apply additive-only failure surface changes in `lib/src/models/pdf_result.dart` and `lib/genius_link_pdf_generator.dart` only if the validated defects cannot be explained through existing public result shapes

**Checkpoint**: User Story 6 preserves explicit per-job and per-batch outcomes over the same validated raw-byte generation path.

---

## Phase 9: Contract Sync & Polish

**Purpose**: Close the loop on docs, release notes, and final validation without expanding scope into business-data validation.

- [ ] T035 Update `README.md` only if a user-visible generation behavior or additive public API change needs guidance, and explicitly note that business-data validation remains out of scope
- [ ] T036 Update `CHANGELOG.md` with concise `Fixed` and `Changed` entries for PDF generation stability, layout safety, and any additive API surface
- [ ] T037 Update `specs/002-pdf-engine-stability/quickstart.md` if final validation commands or manual fixtures change during implementation
- [ ] T038 Run `flutter analyze lib test example` from the package root and resolve issues in touched files
- [ ] T039 Run `flutter test test/pdf_stability` plus Windows example verification against `example/lib/documents/smart_space_demo_document.dart`, `example/lib/documents/multi_grid_summary_demo_document.dart`, and `example/lib/documents/qr_attachments_demo_document.dart`, confirming no empty or corrupted PDFs and no business-calculation semantic changes

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1: Setup** has no dependencies.
- **Phase 2: Foundational** depends on Phase 1 and blocks all story work because every story uses the shared PDF validation helpers.
- **Phase 3: US1** depends on Phase 2 and establishes the core builder/page-flow contract.
- **Phase 4: US2** depends on US1 because header/footer safety relies on the stabilized content-zone and page-break primitives.
- **Phase 5: US3** depends on US1 and US2 because grid-summary continuation relies on correct page state plus footer-safe follow-up placement.
- **Phase 6: US4** depends on US1 for stable page-flow behavior, but can begin after the core builder contract is fixed.
- **Phase 7: US5** depends on US1 and US2 because media placement must use the same footer-aware page-flow rules.
- **Phase 8: US6** depends on US1 because service/export reliability wraps the canonical raw-byte generation path, and it should land after the core generation contract is stable.
- **Phase 9: Contract Sync & Polish** depends on all completed stories selected for delivery.

### Within Each User Story

- Write the regression tests before changing the implementation files for that story.
- Update the owning builder/service path before changing examples or public-surface docs.
- Keep public API changes additive and default-off if they become necessary for bounds validation.
- Do not add tasks that validate business data, financial calculations, or template semantics beyond PDF generation correctness.

### User Story Dependency Graph

- `US1 -> US2 -> US3`
- `US1 -> US4`
- `US1 + US2 -> US5`
- `US1 -> US6`

---

## Parallel Opportunities

### Setup

- T002, T003, and T004 can run in parallel after T001 starts because they touch service, component, and example surfaces separately.

### Foundational

- T006 and T007 can run in parallel after T005 because they create different support files under `test/pdf_stability/support/`.

### User Story 1

- T008 and T009 can run in parallel because they touch different test files.

### User Story 2

- T015 and T016 can run in parallel after T014 because component fixes and example fixture updates touch different files.

### User Story 3

- T019 and T020 can run in parallel after T018 because grid widget alignment and example fixture updates do not touch the same files.

### User Story 4

- T023 and T024 can run in parallel after T022 because component alignment fixes and example fixture updates touch different files.

### User Story 5

- T027 and T028 can run in parallel after T026 because barcode handling and QR/watermark handling live in different files.

### User Story 6

- T032 and T033 can run in parallel after T031 because manager reliability and export mapping touch different service files.

---

## Implementation Strategy

### MVP First

- Deliver Setup, Foundational, and all P1 stories (`US1`, `US2`, `US3`) first. That is the minimum trustworthy engine-stability slice because it closes the known page-flow, footer-overlap, and multi-page grid continuation defects before lower-priority media and wrapper work.

### Incremental Delivery

- After the P1 slice is stable, implement `US4` for direction correctness, then `US5` for deterministic media safety, then `US6` for service/export reliability.
- Leave `README.md` untouched unless implementation proves a user-visible behavior contract or additive API needs documentation.
- Treat any additive public API for absolute-position bounds validation as a deliberate follow-up inside the same implementation batch, with matching `CHANGELOG.md` and example updates.

### Final Validation Gate

- Do not mark the feature complete until `flutter analyze lib test example`, `flutter test test/pdf_stability`, and the Windows example verification from `specs/002-pdf-engine-stability/quickstart.md` all pass.

