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

- **I. PDF Generation Correctness First**: Does this change preserve structural
  validity — openable, printable, exportable, and stable across supported
  layouts? Is correctness compromised in any way for ergonomics or performance?
- **II. Scope Boundary**: Does this work stay within PDF generation mechanics?
  Does it touch business-data validation, financial calculations, or tax logic
  (prohibited)? Are templates under `lib/templates` and core code under
  `lib/src` with no crossover?
- **III. Builder State Integrity**: Which builder state fields (`currentY`,
  page index, page reference, layout result, header space, footer space) are
  affected? Is the state synchronized after every drawing operation? Can a
  partial failure leave state inconsistent?
- **IV. Header/Footer Safety**: Does this change affect header/footer reserved
  space calculation? Is content guaranteed not to overlap reserved areas on
  any new page?
- **V. Multi-page Component Safety**: Does this component create or continue
  on new pages? Does it return sufficient layout information for the builder to
  update page reference, index, and `currentY` correctly after completion?
- **VI. Deterministic PDF Output**: Does this change introduce wall-clock time,
  random seeds, locale-sensitive defaults, or mutable global state that could
  cause output to vary between calls with identical inputs?
- **VII. Fail Fast With Clear Errors**: Are all invalid generation states caught
  and reported with descriptive errors? Is any silent partial or corrupt output
  possible?
- **VIII. Test Before Fix**: If this is a bug fix, what focused test was added
  to reproduce the defect before the fix? Does it fail before the fix and pass
  after? If automated testing is impractical, what manual reproduction script
  ships in the same change?
- **IX. Minimal Public API Breakage**: Does this change any public API,
  factory constructor, enum value, or behavioral contract? What is the SemVer
  impact and where is the migration guidance in `README.md`/`CHANGELOG.md`?
- **X. Documentation Discipline**: Which `README.md`, `CHANGELOG.md`, and
  `example/` files must change with this work? Are all example usages aligned
  with the updated public surface?
- **XI. Regression Protection**: Are any previously fixed PDF layout behaviors
  touched by this change? Are they covered by regression tests before the code
  is modified?
- **XII. Resource Safety**: Are PDF documents, images, fonts, and byte buffers
  acquired and released safely? Is there a deterministic release path for every
  resource opened during generation?
- **XIII. Platform Awareness**: Which platforms (mobile, desktop, web) are
  affected? Is any behavior platform-specific and explicitly documented as such?
- **XIV. No Silent Layout Corruption**: If a component cannot fit, split, scale,
  or move safely, does it fail with a clear error rather than silently drawing
  outside page bounds or producing zero-size output?

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
