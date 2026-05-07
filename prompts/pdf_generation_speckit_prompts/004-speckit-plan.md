# 004 — /speckit.plan

```markdown
/speckit.plan

Technical plan for Flutter/Dart PDF generation stability.

Tech stack:
- Flutter / Dart
- syncfusion_flutter_pdf
- Existing project structure
- Existing GeniusPdfConfig
- Existing GeniusPdfDocumentBuilder
- Existing GeniusPdfResult models
- Dart test framework
- flutter test if widget/asset loading is required

Implementation strategy:
Use a test-first, incremental fix strategy.

Do not rewrite the whole library.
Do not replace Syncfusion.
Do not redesign templates unless a template exposes a generation defect.
Do not add business-data validation.

Architecture focus:

1. Builder State Coordinator
   Ensure the builder has a consistent internal state after each operation:
   - _currentPage
   - _currentIndex
   - _currentY
   - _layoutResult
   - _headerHeight
   - _footerHeight

2. Page Flow Guard
   Centralize safe checks for:
   - remaining height
   - footer reserved area
   - header reserved area
   - impossible component height
   - new page creation
   - currentY reset

3. Layout Result Synchronization
   Any draw operation returning PdfLayoutResult must update:
   - current page
   - page index
   - currentY
   especially after multi-page content.

4. Component Fit Policy
   Define behavior for each component:
   - text: page-break or flow
   - rich text: page-break/flow according to Syncfusion result
   - grid: use built-in pagination and sync final result
   - summary: keep together if possible
   - info box: keep together if possible
   - image: scale, move page, or fail clearly
   - QR/barcode: validate render bounds and fail safely
   - watermarks/templates: apply safely without corrupting page layout

5. Generation Service Reliability
   Ensure services expose failures consistently:
   - no swallowed exceptions
   - result model includes error message and context when appropriate
   - batch jobs report each failed item
   - dispose is performed safely

Test plan:

1. Unit tests for builder state
   - initial state
   - newPage()
   - resetY()
   - reserveHeaderSpace()
   - reserveFooterSpace()
   - canFit()
   - remainingHeight

2. Layout tests
   - long text over multiple pages
   - content near footer
   - header/footer applied before content
   - new page starts below header
   - summary after near-bottom content
   - info box near bottom
   - large spacing behavior
   - image larger than page
   - multiple images and attachments

3. Grid tests
   - grid fits one page
   - grid spans multiple pages
   - summary after multi-page grid
   - multiple grids with summaries
   - builder current page matches final grid page

4. RTL/LTR tests
   - LTR text layout
   - RTL text layout
   - start/end image alignment
   - bilingual header layout if applicable

5. Service tests
   - successful generation returns non-empty bytes
   - generation exception returns failure result
   - batch generation continues or stops according to stopOnError
   - dispose is called where appropriate

Proposed implementation phases:

Phase 0 — Baseline audit
- Identify the exact generation paths.
- Identify current failure risks.
- Confirm which public APIs must remain stable.

Phase 1 — Tests and reproduction
- Add failing tests for page flow, footer overlap, multi-page grid, and large images.

Phase 2 — Builder state fixes
- Fix current page/currentY synchronization.
- Improve page-break guards.
- Ensure header/footer reserved space is respected.

Phase 3 — Component integration fixes
- Fix grid, summary, info box, rich text, image, QR/barcode drawing safety.

Phase 4 — Service/export reliability
- Fix generation manager, export service, batch exporter error handling.

Phase 5 — Documentation and validation
- Update README.md and CHANGELOG.md only where behavior changes.
- Run analyze and tests.
- Generate representative example PDFs.

Expected deliverables:
- Updated implementation only where needed
- Tests covering PDF generation mechanics
- Updated README.md if behavior changes
- Updated CHANGELOG.md if behavior changes
- No changes to user-data validation or business calculations
```
