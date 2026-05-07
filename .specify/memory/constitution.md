<!--
Sync Impact Report
Version change: template -> 1.0.0
Modified principles:
- Template Principle 1 -> I. Config-Scoped Document Construction
- Template Principle 2 -> II. Bilingual and Directional Correctness
- Template Principle 3 -> III. Layer Ownership by Path
- Template Principle 4 -> IV. Public Surface, Examples, and Release Notes Stay in Sync
- Template Principle 5 -> V. Validation Must Match the Risk
Added sections:
- Architecture Constraints
- Delivery Workflow
Removed sections:
- None
Templates requiring updates:
- UPDATED: .specify/templates/plan-template.md
- UPDATED: .specify/templates/spec-template.md
- UPDATED: .specify/templates/tasks-template.md
- N/A: .specify/templates/commands/ (directory absent in this repo)
Follow-up TODOs:
- None
-->
# Genius Link PDF Generator Constitution

## Core Principles

### I. Config-Scoped Document Construction
Every document-generation entrypoint MUST accept or derive from a
`GeniusPdfConfig` instance, and new features MUST source fonts, margins, page
size, direction, theme, and assets from that config instead of introducing
hidden mutable generation state. The only allowed package-global exception is
shared operational infrastructure that is explicitly documented as global, such
as logging. Rationale: `lib/src/core/pdf_config.dart` defines per-document
config ownership, and the package depends on deterministic rendering inputs.

### II. Bilingual and Directional Correctness
Any public feature that renders or exposes user-facing text MUST define its
Arabic/English and RTL/LTR behavior explicitly. Components, builders, services,
and printing models MUST not rely on ambient direction defaults when alignment,
labels, status text, or layout calculations change; they MUST preserve explicit
direction-aware rendering and bilingual fields or helpers where the surface is
user-visible. Rationale: the package contract in `README.md`, component APIs,
and printing models repeatedly promises bilingual and RTL/LTR-safe behavior.

### III. Layer Ownership by Path
Changes MUST land in the narrowest owning layer. `lib/src/components/**` owns
reusable renderable PDF components and component-local models. `lib/src/builders/**`
owns pagination, spacing, Y-position tracking, and composition over reusable
components. `lib/src/services/**` owns generation, export, security, merge/split,
and operational byte-oriented workflows. `lib/src/printing/**` owns printer
discovery, preview, print settings, and print-job modeling. Public barrels MUST
only expose intentionally supported APIs after the internal layer boundary is
clear. Rationale: the package advertises clean architecture, and the current
codebase is already organized around these ownership boundaries.

### IV. Public Surface, Examples, and Release Notes Stay in Sync
Any change that adds, removes, renames, or materially redefines a public API,
template, factory constructor, enum value, builder capability, or printing
behavior MUST update `README.md`, `CHANGELOG.md`, and the relevant files under
`example/` in the same change. Public barrels such as
`lib/genius_link_pdf_generator.dart`, `lib/src/components/components.dart`, and
`lib/src/printing/printing.dart` MUST match the documented contract. Breaking
changes or removals MUST include migration guidance and a Semantic Versioning
justification. Rationale: this library is documentation-heavy, example-driven,
and publishes its package contract through those files.

### V. Validation Must Match the Risk
Every change MUST leave behind validation evidence proportionate to the risk of
the affected surface. Pure logic, calculation, mapping, and state transitions
SHOULD receive focused automated tests when practical. Rendering, printing,
sharing, and export changes that are difficult to cover with stable tests MUST
at minimum include targeted `flutter analyze` runs and reproducible manual or
example-driven verification. A feature is incomplete if it claims support for a
surface that has no updated validation path. Rationale: this repo currently
leans heavily on examples and platform behavior, so quality gates must be real,
not aspirational.

## Architecture Constraints

- `lib/src/components/**` MUST stay reusable and free of file I/O, printer
  discovery, and platform workflow orchestration.
- `lib/src/builders/**` MUST compose existing components before inventing
  one-off drawing logic in templates or services.
- `lib/src/services/**` and `lib/src/printing/**` MUST translate between
  builders/documents and platform or filesystem operations without leaking that
  operational logic back into reusable components.
- Public API additions SHOULD prefer the package's established ergonomics:
  factory constructors for presets, `copyWith()` for immutable adjustments,
  result types for operations, and barrel exports for supported entrypoints.
- User-visible models that surface statuses, labels, or selection choices
  SHOULD provide deterministic English and Arabic display helpers when they are
  part of the package contract.

## Delivery Workflow

- Specs and plans MUST name the touched layer or layers, the affected public
  barrels, any README or CHANGELOG impact, any example-app impact, and any
  Arabic/English or RTL/LTR implications.
- Constitution checks in plans MUST explicitly review config ownership,
  directional correctness, layer placement, contract sync, and validation
  evidence before implementation begins.
- Task lists MUST include documentation, changelog, and example updates when a
  public surface changes; those updates are not optional polish.
- Release notes MUST follow Keep a Changelog categories and MUST use Semantic
  Versioning rules that match the actual contract impact of the change.

## Governance

This constitution is the authoritative engineering policy for this repository.
When other guidance conflicts with it, this document wins until the conflicting
guidance is updated. Amendments MUST be made by updating this file, adding a
new Sync Impact Report, and syncing the affected Spec Kit templates in the same
change. Compliance review is required for every plan, tasks file, and final
implementation review that touches package behavior. Constitution versioning
follows Semantic Versioning: MAJOR for removed or materially redefined
principles, MINOR for new principles or materially expanded sections, and PATCH
for clarifications that do not change the policy meaning.

**Version**: 1.0.0 | **Ratified**: 2026-05-07 | **Last Amended**: 2026-05-07
