<!--
Sync Impact Report
Version change: 2.0.0 → 3.0.0
Modified principles:
- I. Library-first Architecture → removed (folded into II. Scope Boundary)
- II. Financial Correctness First → removed (business-data validation explicitly prohibited by new II)
- III. Rendering Correctness → I. PDF Generation Correctness First (refocused on structural validity)
- IV. Test-Driven Bug Fixing → VIII. Test Before Fix (renamed; same intent, sharper rule)
- V. Backward Compatibility → IX. Minimal Public API Breakage (renamed; simplified)
- VI. Separation of Concerns → II. Scope Boundary (renamed; refocused on lib/templates vs lib/src)
- VII. RTL/LTR Parity → absorbed into I. PDF Generation Correctness First scope
- VIII. Documentation Consistency → X. Documentation Discipline (renamed)
- IX. Deterministic Outputs → VI. Deterministic PDF Output (refocused on PDF bytes)
- X. Performance Safety → XII. Resource Safety (renamed; refocused on safe resource handling)
Added principles:
- III. Builder State Integrity (new)
- IV. Header/Footer Safety (new)
- V. Multi-page Component Safety (new)
- VII. Fail Fast With Clear Errors (new)
- XI. Regression Protection (new)
- XIII. Platform Awareness (new)
- XIV. No Silent Layout Corruption (new)
Removed sections:
- Architecture Constraints (removed; scope reduced to PDF generation mechanics)
- Delivery Workflow (removed; governance section covers process obligations)
Templates requiring updates:
- ✅ UPDATED: .specify/templates/plan-template.md (Constitution Check updated for all 14 principles)
- ✅ CHECKED: .specify/templates/spec-template.md (no structural changes required)
- ✅ CHECKED: .specify/templates/tasks-template.md (no structural changes required)
Follow-up TODOs:
- None
-->
# Genius Link PDF Generator Constitution

## Core Principles

### I. PDF Generation Correctness First

The primary goal of this library MUST be to produce PDF files that are
structurally valid, openable, printable, exportable, and stable across all
supported layouts. Every change MUST preserve this outcome as the highest
priority. Features that improve aesthetics, API ergonomics, or developer
convenience MUST NOT be introduced at the cost of structural validity.
Rationale: a PDF that cannot be opened, printed, or exported is worthless
regardless of how it was generated; structural correctness is the non-negotiable
minimum viable product for every change to this library.

### II. Scope Boundary

This library's work MUST focus exclusively on PDF generation mechanics:
page creation, page breaks, layout bounds, header/footer reserved space,
`currentY` tracking, multi-page components, image scaling, grid pagination,
summary placement, RTL/LTR layout behavior, file byte generation, and
export/save failure handling.

Templates and their supporting files MUST be placed under `lib/templates`.
`lib/src` MUST remain reserved for core document-generation library components
only. No template file MAY reside under `lib/src`.

User-provided business data MUST NOT be validated, corrected, or reinterpreted
by this library. Financial totals, tax values, voucher amounts, and report data
are outside this library's scope. Business-data validation is explicitly
prohibited unless a separate, independently scoped feature is created for it.
Rationale: conflating layout mechanics with data-validation concerns produces
code that is untestable in isolation, violates single-responsibility, and causes
changes in one domain to break the other.

### III. Builder State Integrity

The PDF builder MUST keep page state, current page index, current page
reference, `currentY`, layout result, header space, and footer space
synchronized after every drawing operation. No drawing operation MAY leave
these values in an inconsistent state. Any multi-step operation that can fail
partway through MUST either complete atomically or restore the previous
consistent state before propagating the failure.
Rationale: inconsistent builder state produces corrupt, partially drawn PDFs
that are difficult to diagnose; the builder's internal invariants are the
foundation of all correctness guarantees above it.

### IV. Header/Footer Safety

No content MAY overlap header or footer templates under any circumstances.
Every new page MUST start below the reserved header area and MUST stop before
the reserved footer area. The reserved areas MUST be calculated before any
content is drawn on the page. Any component that does not respect these
boundaries MUST fail with a clear error rather than silently drawing into
the reserved area.
Rationale: overlapping header/footer content corrupts the document's visual
structure and violates the page contract that all consumers depend on.

### V. Multi-page Component Safety

Any component that can create or continue content on new pages MUST return
sufficient layout information for the builder to update the current page
reference, current page index, and `currentY` correctly after the operation.
No multi-page component MAY complete without leaving the builder in a known,
consistent state. Components that cannot determine their own continuation
behavior MUST delegate that decision to the builder, not assume it.
Rationale: silent failures in page-continuation logic produce documents where
content is placed on the wrong page or `currentY` is incorrect, corrupting
all subsequent layout.

### VI. Deterministic PDF Output

PDF generation MUST be deterministic for the same input data, configuration,
fonts, page size, orientation, and layout options. The same inputs MUST produce
identical PDF bytes across repeated calls. No feature MAY introduce
wall-clock timestamps, random seeds, uncontrolled locale defaults, or mutable
global state that causes output to vary between calls with identical inputs,
unless explicitly documented and made opt-in via a configuration parameter.
Rationale: deterministic output enables meaningful diffing, reproducible audit
trails, and reliable regression testing — properties required for any document
with legal or financial significance.

### VII. Fail Fast With Clear Errors

Invalid generation states MUST fail with descriptive, actionable error messages
instead of silently producing corrupted, clipped, empty, or partially generated
PDFs. An error message MUST identify the component, the invalid state, and the
expected state. Returning partial output for an invalid input is not acceptable;
throwing a well-described exception is always preferable to silent corruption.
Rationale: silent failures delay detection and shift debugging effort onto
consumers who have no visibility into the library's internal state.

### VIII. Test Before Fix

A focused test that reproduces the reported layout or generation defect MUST be
added before any fix is implemented. The test MUST fail before the fix and pass
after it. Committing a fix without a prior-failing test is not acceptable. When
automated testing is impractical for the affected surface (e.g., native PDF
viewer rendering), a documented manual reproduction script committed alongside
the fix is required instead.
Rationale: a fix without a prior-failing test provides no confidence that the
defect was actually reproduced, and no protection against future regression.

### IX. Minimal Public API Breakage

Existing public APIs MUST remain compatible across patch and minor releases.
A breaking change — removal, rename, parameter type change, or behavioral
change that breaks existing consumers — MUST be documented in `README.md` and
`CHANGELOG.md` under a MINOR or MAJOR version bump with explicit migration
guidance. No breaking change MAY be committed silently or under a patch bump.
Rationale: downstream app teams depend on this library; silent breaks force
emergency migrations that destroy release confidence.

### X. Documentation Discipline

`README.md` and `CHANGELOG.md` MUST be updated only for behavior, API, or
migration-relevant changes. Any library modification or addition MUST also
update the relevant `example/` usage so that examples remain aligned with the
current package behavior and public surface. An example that is out of sync
with the library is a defect. Documentation updates are not optional polish —
they are part of the definition of done for any public-surface change.
Rationale: consumers rely on documentation and examples to integrate the
library; stale examples produce integration failures that are invisible until
runtime.

### XI. Regression Protection

Any previously fixed PDF layout behavior MUST be covered by a regression test
before related code is changed again. A change to previously fixed logic without
a covering regression test is not acceptable. The regression test suite is the
canonical record of what has broken in the past and MUST be maintained as a
first-class artifact.
Rationale: regressions impose hidden maintenance costs and erode consumer
confidence; the regression test is the only reliable defense when the original
author is no longer available to explain the fix.

### XII. Resource Safety

PDF documents, image resources, fonts, and generated bytes MUST be handled
safely. Resources MUST NOT be accessed after disposal. Resources MUST NOT be
disposed more than once. No generation path MAY produce memory leaks through
unclosed documents or retained large byte buffers. Any resource acquired during
generation MUST have a deterministic release path.
Rationale: memory leaks and double-dispose errors degrade the host application
for all users, not just during PDF generation, and are particularly severe on
mobile targets.

### XIII. Platform Awareness

All fixes and features MUST remain safe and correct across mobile, desktop, and
web where the library claims support. No fix MAY assume a single target platform
unless the affected behavior is explicitly documented as platform-specific. Any
change that affects platform-specific behavior MUST identify which platforms are
affected and how.
Rationale: the library targets a multi-platform consumer base; platform-specific
regressions on non-tested targets are indistinguishable from new defects to the
consumer.

### XIV. No Silent Layout Corruption

If a component cannot fit, split, scale, or move safely within page bounds, it
MUST fail with a clear, descriptive error. No component MAY silently draw
outside page bounds, overlap reserved areas, clip content without reporting it,
or produce invisible or zero-size output without signaling the failure.
Silent layout corruption is always a defect, regardless of whether the output
is technically a valid PDF file.
Rationale: corrupt layout is invisible to automated validation but immediately
visible to end users; silent corruption is worse than an explicit failure because
it reaches production undetected.

## Governance

This constitution is the authoritative engineering policy for this repository.
When other guidance conflicts with it, this document wins until the conflicting
guidance is updated. Amendments MUST be made by updating this file, adding a
new Sync Impact Report comment at the top, and syncing the affected Spec Kit
templates in the same change. Compliance review is required for every plan,
tasks file, and final implementation review that touches package behavior.
Constitution versioning follows Semantic Versioning: MAJOR for removed or
materially redefined principles, MINOR for new principles or materially expanded
sections, and PATCH for clarifications that do not change the policy meaning.
Business-data validation is explicitly prohibited for all features governed by
this constitution unless a separate, independently scoped feature is created.
If implementation conflicts with these principles, work MUST stop and the spec
or plan MUST be updated before coding resumes.

**Version**: 3.0.0 | **Ratified**: 2026-05-07 | **Last Amended**: 2026-05-08
