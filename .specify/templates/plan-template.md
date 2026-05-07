# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit-plan` command. It is
project-specific for `genius_link_pdf_generator`, so capture the real package
paths and validation steps rather than generic app scaffolding.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

**Language/Version**: Dart / Flutter [record exact versions or NEEDS CLARIFICATION]  
**Primary Dependencies**: `syncfusion_flutter_pdf`, `printing`, `share_plus`,
`path_provider`, `open_file`, `barcode`, `image` [adjust as needed]  
**Storage**: Local files, temporary files, and platform print/share services, or N/A  
**Testing**: `flutter analyze`, focused `flutter test` where practical, and
example/manual verification for rendering or platform flows  
**Target Platform**: Flutter package consumed by mobile, desktop, and web apps  
**Project Type**: Flutter package / library  
**Performance Goals**: Preserve non-blocking generation and avoid regressions in
render, export, share, and print workflows  
**Constraints**: Preserve `GeniusPdfConfig` ownership, RTL/LTR correctness,
bilingual behavior, public API compatibility, and same-change doc/example sync  
**Scale/Scope**: [affected public exports, templates, example screens, or internal-only scope]

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- **I. Library-first**: Is all new behavior in `lib/src/`? Is any logic
  currently only in `example/` that must be promoted to the library?
- **II. Financial correctness**: Does this feature touch monetary calculations?
  If yes, what rounding strategy is used, and what unit tests cover the totals?
- **III. Rendering correctness**: What layout, Y-position, column-width, or
  page-break logic is affected? What single-page and multi-page verification
  steps are planned in both RTL and LTR modes?
- **IV. Test-driven bug fixing**: If this is a bug fix, what regression test or
  documented reproduction script ships in the same change?
- **V. Backward compatibility**: Does this change any public API, factory
  constructor, enum value, or behavioral contract? What is the SemVer impact
  and where is the migration guidance?
- **VI. Separation of concerns**: Which package layer owns each change:
  `components`, `builders`, `services`, `printing`, `sharing`, `templates`,
  `widgets`, or `core`? Why is that the narrowest valid layer? Does any module
  import across a concern boundary?
- **VII. RTL/LTR parity**: What Arabic/English text, labels, alignment rules,
  column order, or RTL/LTR layout calculations are affected? Which example
  screen or manual verification step exercises both directions?
- **VIII. Documentation consistency**: Which public barrels, `README.md`,
  `CHANGELOG.md`, and `example/` files must change with this work? Are all
  README code examples compilable or marked pseudo-code?
- **IX. Deterministic outputs**: Does the feature introduce wall-clock time,
  random seeds, locale-sensitive defaults, or mutable global state that could
  cause output to vary between calls with identical inputs?
- **X. Performance safety**: Does the feature process more than one page of
  content? If yes, is it off the UI thread, and does it provide a progress
  callback?

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
|-- plan.md
|-- research.md
|-- data-model.md
|-- quickstart.md
|-- contracts/
`-- tasks.md
```

### Source Code (repository root)

```text
lib/
|-- genius_link_pdf_generator.dart
`-- src/
    |-- ai/
    |-- builders/
    |-- components/
    |   |-- models/
    |   `-- widgets/
    |-- core/
    |-- extensions/
    |-- models/
    |-- printing/
    |-- services/
    |   `-- export/
    |-- sharing/
    |-- templates/
    `-- widgets/

example/
|-- lib/data/
|-- lib/documents/
|-- lib/screens/
`-- lib/widgets/
```

**Structure Decision**: [List the exact touched directories, public barrels, and
example/doc files for this feature. State why each change belongs in that layer.]

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., public API break] | [current need] | [why compatibility path was insufficient] |
| [e.g., cross-layer change] | [current need] | [why narrower ownership was not possible] |
