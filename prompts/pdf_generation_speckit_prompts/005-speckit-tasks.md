# 005 — /speckit.tasks

```markdown
/speckit.tasks

Generate implementation tasks for the PDF Generation Engine Stability feature.

Task rules:
- Write tests before fixes when possible.
- Keep tasks small and file-specific.
- Do not create tasks for validating financial or business data.
- Do not rewrite all templates.
- Do not change public APIs unless a task explicitly justifies it.
- Mark parallel tasks with [P] only when they do not touch the same files.
- Include exact file paths.

Required task groups:

1. Baseline audit
   - Inspect lib/src/builders/pdf_document_builder.dart state transitions.
   - Inspect lib/src/services/pdf_generation_manager.dart result handling.
   - Inspect lib/src/services/pdf_service.dart generation behavior.
   - Inspect lib/src/services/export/pdf_export_service.dart export failure behavior.
   - Inspect lib/src/services/export/batch_exporter.dart batch failure behavior.
   - Inspect lib/src/components/widgets/pdf_data_grid.dart draw result handling.
   - Inspect image, QR, barcode, watermark draw bounds behavior.
   - Identify high-risk templates only as reproduction cases.

2. Builder state tests
   - Add tests for currentY, remainingHeight, headerHeight, footerHeight.
   - Add tests for newPage() state.
   - Add tests for resetY().
   - Add tests for reserveHeaderSpace().
   - Add tests for reserveFooterSpace().
   - Add tests for content near footer.
   - Add tests for generate() state initialization.

3. Page-break tests
   - Long text should not draw beyond page bounds.
   - Summary near page bottom should move safely.
   - InfoBox near page bottom should move safely.
   - RichText near page bottom should move safely.
   - Section divider near page bottom should move safely.
   - Large spacing should not corrupt the page state.
   - Image near page bottom should move or scale safely according to the chosen policy.

4. Multi-page grid tests
   - Grid spanning multiple pages must update builder current page.
   - Summary after multi-page grid must render after the grid on the final page.
   - Multiple grid+summary sections must not overlap.
   - Grid draw result must update page index if final page changes.

5. RTL/LTR layout tests
   - Direction-aware start/end alignment.
   - RTL content should not use LTR-only positioning assumptions.
   - Bilingual header/report components should not overlap.
   - Page-break behavior must work in both RTL and LTR modes.

6. Image, QR, barcode tests
   - Oversized image behavior must be deterministic.
   - Image page must respect margins, header, and footer.
   - QR code draw failure must be handled safely.
   - Barcode validation/rendering failure must not corrupt the entire PDF unless required.

7. Service reliability tests
   - Successful generation returns valid non-empty bytes.
   - Generation exceptions are converted to GeniusPdfFailure or equivalent failure model where applicable.
   - Batch generation reports progress and per-job results correctly.
   - stopOnError behavior is correct.
   - dispose is safe and not forgotten in service paths.

8. Implementation fixes
   - Fix builder page state synchronization after PdfLayoutResult.
   - Fix any component that updates currentY without syncing final page.
   - Fix unsafe overflow behavior.
   - Fix image scaling/oversize behavior.
   - Fix QR/barcode safe failure behavior if needed.
   - Fix generation service error handling if needed.
   - Fix batch exporter partial failure reporting if needed.

9. Documentation
   - Update README.md only for changed generation behavior or usage guidance.
   - Update CHANGELOG.md with a concise Fixed/Changed section.
   - Document non-goal: the library does not validate user-provided business data.
   - Add migration notes only if a public API changes.

10. Final validation
   - Run dart analyze.
   - Run all tests.
   - Generate sample PDFs from example documents.
   - Confirm no empty/corrupted PDFs are produced in tested scenarios.
   - Confirm no tasks modified business calculation semantics.

Suggested task output format:
- [ ] T001 [P] Add builder state test file at test/builders/pdf_document_builder_state_test.dart
- [ ] T002 [P] Add page-break regression tests at test/builders/pdf_page_break_test.dart
- [ ] T003 [P] Add RTL/LTR layout tests at test/builders/pdf_directionality_test.dart
- [ ] T004 Add multi-page grid tests at test/components/pdf_data_grid_pagination_test.dart
- [ ] T005 Fix builder state synchronization in lib/src/builders/pdf_document_builder.dart
- [ ] T006 Fix summary-after-grid placement behavior if failing tests confirm defect
- [ ] T007 Fix image overflow behavior if failing tests confirm defect
- [ ] T008 Fix generation service failure handling if failing tests confirm defect
- [ ] T009 Update README.md only for changed behavior
- [ ] T010 Update CHANGELOG.md with generation stability fixes
```
