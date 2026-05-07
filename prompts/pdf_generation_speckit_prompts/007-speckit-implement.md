# 007 — /speckit.implement

```markdown
/speckit.implement

Implement the PDF Generation Engine Stability feature according to the approved spec, plan, and tasks.

Implementation rules:
1. Fix PDF generation mechanics only.
2. Do not validate or correct user-provided business data.
3. Preserve public APIs unless explicitly approved in the spec.
4. Keep fixes minimal and test-driven.
5. Ensure generated PDFs are valid, non-empty, and openable.
6. Ensure page state remains synchronized after every draw operation.
7. Ensure header/footer areas are respected.
8. Ensure multi-page components update the builder state correctly.
9. Ensure services return clear success/failure results.
10. Update README.md and CHANGELOG.md only for real behavior/API changes.

Implementation priorities:
1. Reproduce defects with tests.
2. Fix builder state synchronization.
3. Fix page-break and reserved-area behavior.
4. Fix multi-page component synchronization.
5. Fix image/QR/barcode overflow/failure behavior.
6. Fix generation/export service error handling.
7. Run validation.
8. Update documentation.

Critical rule:
When any component draws content across multiple pages and returns PdfLayoutResult, the builder must synchronize its internal current page and currentY with the final result page, not only update currentY.

Do not:
- change financial calculations
- modify voucher amounts
- validate tax correctness
- reinterpret report data
- alter user content
- rewrite templates for semantic accuracy
- hide generation errors

After implementation:
- Run dart analyze.
- Run tests.
- Generate representative example PDFs.
- Summarize changed files.
- Summarize fixed generation defects.
- Confirm explicitly that business-data validation was not added.
- List any public API changes, or state that none were made.
```
