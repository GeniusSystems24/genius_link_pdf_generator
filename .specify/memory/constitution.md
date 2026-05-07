<!--
Sync Impact Report
Version change: 1.0.0 → 2.0.0
Modified principles:
- I. Config-Scoped Document Construction → IX. Deterministic Outputs (absorbed and renamed)
- II. Bilingual and Directional Correctness → VII. RTL/LTR Parity (renamed and refocused)
- III. Layer Ownership by Path → split into I. Library-first Architecture + VI. Separation of Concerns
- IV. Public Surface, Examples, and Release Notes Stay in Sync → split into V. Backward Compatibility + VIII. Documentation Consistency
- V. Validation Must Match the Risk → split into III. Rendering Correctness + IV. Test-Driven Bug Fixing
Added principles:
- II. Financial Correctness First (new)
- X. Performance Safety (new)
Removed sections:
- None (all prior content absorbed, renamed, or promoted into the expanded principle set)
Templates requiring updates:
- ✅ UPDATED: .specify/templates/plan-template.md (Constitution Check now references all 10 principles)
- ✅ CHECKED: .specify/templates/spec-template.md (no structural changes required)
- ✅ CHECKED: .specify/templates/tasks-template.md (no structural changes required)
- N/A: .specify/templates/commands/ (directory absent in this repo)
Follow-up TODOs:
- None
-->
# Genius Link PDF Generator Constitution

## Core Principles

### I. Library-first Architecture

All functionality MUST be implemented as reusable library code under `lib/src/`.
Demo-only code in `example/` MUST NOT introduce behavior or logic that belongs in
the library. Any utility, helper, model, or service first written in an example
screen MUST be promoted to `lib/src/` before the feature is considered complete.
Features exist to serve library consumers, not to satisfy the demo app alone.
Rationale: the package is consumed by other apps; demo convenience cannot
substitute for library-grade API design, and unreachable code in `example/` has
no value for downstream teams.

### II. Financial Correctness First

All monetary calculations MUST be deterministic, explicitly rounded (using integer
arithmetic in minor currency units, `Decimal`-equivalent types, or documented
`double.roundToDouble()` with explicit decimal precision), and covered by focused
unit tests before any feature that touches financial values ships. PDF renderers
MUST display the rounded value, never a raw floating-point intermediate. Totals
MUST equal the sum of their rounded line items — not the rounded sum of
unrounded items.
Rationale: financial documents carry legal and audit weight; uncontrolled
floating-point drift produces displayed amounts that differ from calculated ones,
which is a defect category with real liability.

### III. Rendering Correctness

PDF layout MUST prevent overlapping content, clipped text, broken RTL alignment,
invalid page breaks, and incorrect header/footer spacing. Any change touching
layout measurement, Y-position tracking, column widths, page-break logic, or
header/footer drawing MUST include a rendering verification step — either
automated or example-driven — that exercises both single-page and multi-page
output in both RTL and LTR modes.
Rationale: undetected rendering bugs corrupt end-user documents and are difficult
to diagnose after release; they cannot be caught by `flutter analyze` alone.

### IV. Test-Driven Bug Fixing

Every bug fix MUST include a regression test that (a) reproduces the reported
failure before the fix, (b) passes after the fix, and (c) is committed in the
same change as the fix. When automated testing is impractical for the affected
surface (e.g., platform print dialogs, share sheets, native PDF viewers), a
documented manual reproduction script committed alongside the fix is required
instead. A bug fix without a regression artifact is incomplete.
Rationale: bugs that recur impose hidden maintenance costs and erode consumer
confidence; the regression test is the durable record of what broke.

### V. Backward Compatibility

Public APIs MUST remain compatible across patch and minor releases. Any breaking
change — removal, rename, parameter type change, or behavioral change that breaks
existing consumers — MUST be documented in `CHANGELOG.md` under a MINOR or MAJOR
version bump with explicit migration guidance. Deprecation MUST precede removal by
at least one published minor release. No breaking change MAY be committed silently
or under a patch bump.
Rationale: downstream app teams depend on this library; silent breaks force
emergency migrations and destroy release confidence in ways that patch notes
cannot repair.

### VI. Separation of Concerns

Financial calculations, layout measurement, PDF drawing, export/share workflows,
platform-specific behavior, template composition, and UI preview widgets MUST live
in separate, independent modules. No module MUST import from a module that owns
a concern above it in the dependency order (e.g., a reusable component MUST NOT
import from a service or a template). Coupling MUST be introduced only at the
narrowest valid integration layer.
Rationale: mixed concerns make individual modules untestable in isolation and
cause cascading failures when one concern changes; the package's layer structure
exists to enforce this boundary.

### VII. RTL/LTR Parity

Every public component, builder, template, and service that renders or exposes
user-facing content MUST work correctly in both Arabic RTL and English LTR modes.
Correct behavior includes: text alignment, numeric alignment, header and column
order, page-flow direction, and bilingual label helpers. RTL and LTR behavior
MUST each be exercised by at least one example screen or by a documented manual
verification step committed alongside the feature.
Rationale: the package explicitly contracts bilingual, bidirectional document
support; asymmetric RTL/LTR behavior is a functional defect regardless of which
mode was tested first.

### VIII. Documentation Consistency

`README.md` code examples MUST compile without errors or be explicitly marked as
pseudo-code with a visible comment. Financial values in any documentation MUST be
mathematically consistent: displayed totals MUST equal the sum of their displayed
line items. Any change that adds, renames, removes, or materially redefines a
public API, template, factory constructor, enum value, or builder behavior MUST
update `README.md`, `CHANGELOG.md`, and the relevant `example/` screens in the
same change. No documentation update is optional polish; it is part of the
definition of done.
Rationale: consumers rely on documentation to integrate the library; inconsistent
examples produce integration failures that are invisible until runtime.

### IX. Deterministic Outputs

The same input data and configuration MUST produce identical PDF bytes, identical
calculated financial values, and identical layout measurements across repeated
calls on the same platform and Dart version. No feature MUST introduce wall-clock
timestamps, random seeds, uncontrolled locale defaults, or mutable global state
that causes output to vary between calls with identical inputs, unless such
variance is explicitly documented and made opt-in via a configuration parameter.
Rationale: deterministic output enables byte-level diffing, meaningful caching,
and reproducible audit trails — properties that financial and legal documents
require.

### X. Performance Safety

Large reports, large grids, batch exports, and image-heavy PDFs MUST NOT block
the UI thread and MUST NOT cause unbounded memory growth. Any feature that
processes more than a single page of content MUST use `Future`-based,
`Isolate`-based, or streaming APIs. Progress callbacks (e.g.,
`void Function(int current, int total)?`) MUST be provided for operations where
processing time is expected to exceed one second under typical mobile conditions.
Rationale: the package targets mobile apps where blocking the UI thread causes ANR
events; memory leaks under large batch loads degrade the host app for all users,
not just during PDF generation.

## Architecture Constraints

- `lib/src/components/**` MUST stay reusable and free of file I/O, printer
  discovery, and platform workflow orchestration (Principle VI).
- `lib/src/builders/**` MUST compose existing components before inventing
  one-off drawing logic in templates or services (Principle I).
- `lib/src/services/**` and `lib/src/printing/**` MUST translate between
  builders/documents and platform or filesystem operations without leaking
  operational logic back into reusable components (Principle VI).
- All monetary totals MUST be explicitly rounded before being passed to any PDF
  renderer or display surface (Principle II).
- Any feature processing more than one page MUST expose progress and run off the
  UI thread (Principle X).
- Public API additions SHOULD prefer the package's established ergonomics:
  factory constructors for presets, `copyWith()` for immutable adjustments,
  result types for fallible operations, and barrel exports for intentional
  public surfaces (Principle V).
- User-visible models that surface statuses, labels, or selection choices MUST
  provide deterministic English and Arabic display helpers when they are part of
  the package contract (Principles VII and IX).

## Delivery Workflow

- Specs and plans MUST name the touched layer or layers, the affected public
  barrels, any README or CHANGELOG impact, any example-app impact, any
  Arabic/English or RTL/LTR implications, and any financial calculation surfaces.
- Constitution checks in plans MUST explicitly review all ten principles before
  implementation begins; checks are not optional and not implicit.
- Task lists MUST include documentation, changelog, and example updates when a
  public surface changes; those updates are not optional polish — they are part
  of the definition of done.
- Bug-fix tasks MUST include a regression test or documented reproduction script
  as a separate task item that ships in the same change (Principle IV).
- Release notes MUST follow Keep a Changelog categories and MUST use Semantic
  Versioning rules that match the actual contract impact of the change (Principle V).

## Governance

This constitution is the authoritative engineering policy for this repository.
When other guidance conflicts with it, this document wins until the conflicting
guidance is updated. Amendments MUST be made by updating this file, adding a new
Sync Impact Report comment at the top, and syncing the affected Spec Kit templates
in the same change. Compliance review is required for every plan, tasks file, and
final implementation review that touches package behavior. Constitution versioning
follows Semantic Versioning: MAJOR for removed or materially redefined principles,
MINOR for new principles or materially expanded sections, and PATCH for
clarifications that do not change the policy meaning.

**Version**: 2.0.0 | **Ratified**: 2026-05-07 | **Last Amended**: 2026-05-07
