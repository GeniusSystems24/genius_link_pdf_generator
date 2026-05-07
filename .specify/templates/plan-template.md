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

- **Config scope**: Does the feature preserve per-document `GeniusPdfConfig`
  ownership and avoid hidden mutable generation state?
- **Directional correctness**: What Arabic/English text, labels, status
  messages, alignment rules, or RTL/LTR layout calculations are affected?
- **Layer ownership**: Which package layer owns each change:
  `components`, `builders`, `services`, `printing`, `sharing`, `templates`,
  `widgets`, or `core`? Why is that the narrowest valid layer?
- **Contract sync**: Which public barrels, `README.md`, `CHANGELOG.md`, and
  `example/` files must change with this work?
- **Validation**: What targeted `flutter analyze`, tests, and manual/example
  checks will prove the change without relying on assumptions?

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
