---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories),
research.md, data-model.md, contracts/

**Validation**: Validation is mandatory in this repo. Automated tests are
optional only when they are not practical for the affected surface. Every task
set MUST still define targeted `flutter analyze`, focused tests where useful,
and manual/example verification for rendering, export, share, or print flows.

**Organization**: Tasks are grouped by user story to enable independent
implementation and verification.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## Path Conventions

- **Public entrypoints**: `lib/genius_link_pdf_generator.dart` and package
  barrel files under `lib/src/**`
- **Core library layers**: `lib/src/components/`, `lib/src/builders/`,
  `lib/src/services/`, `lib/src/printing/`, `lib/src/sharing/`,
  `lib/src/templates/`, `lib/src/widgets/`, `lib/src/core/`
- **Examples**: `example/lib/screens/`, `example/lib/documents/`,
  `example/lib/data/`, `example/lib/widgets/`
- **Docs and release notes**: `README.md`, `CHANGELOG.md`

## Phase 1: Setup (Shared Context)

**Purpose**: Confirm scope, touched layers, and validation paths before edits

- [ ] T001 Map the feature to exact package layers and public barrels
- [ ] T002 Identify README, CHANGELOG, and example surfaces affected by the change
- [ ] T003 [P] Capture validation commands and manual verification steps

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core changes that must land before any user story is complete

- [ ] T004 Update or add shared models/config/helpers required by multiple stories
- [ ] T005 [P] Add or adjust validation scaffolding for pure logic where practical
- [ ] T006 [P] Update shared barrel exports only if new public surface is intentional

**Checkpoint**: Foundation ready - user story implementation can now proceed

---

## Phase 3: User Story 1 - [Title] (Priority: P1)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Validation for User Story 1

- [ ] T007 [P] [US1] Add or update focused tests for logic-heavy behavior when practical
- [ ] T008 [P] [US1] Define manual/example verification for rendering, share, export, or print behavior

### Implementation for User Story 1

- [ ] T009 [P] [US1] Update model or config files in [exact path]
- [ ] T010 [P] [US1] Implement layer-owned changes in [exact path]
- [ ] T011 [US1] Integrate the feature through the owning builder/service/printing path
- [ ] T012 [US1] Update public barrels if and only if the new surface is intentional

**Checkpoint**: User Story 1 is functional and verifiable on its own

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Validation for User Story 2

- [ ] T013 [P] [US2] Add focused tests or reproducible validation steps
- [ ] T014 [P] [US2] Verify RTL/LTR and Arabic/English impact where applicable

### Implementation for User Story 2

- [ ] T015 [P] [US2] Update supporting files in [exact path]
- [ ] T016 [US2] Implement story behavior in [exact path]
- [ ] T017 [US2] Integrate with existing user story surfaces without breaking compatibility

**Checkpoint**: User Stories 1 and 2 both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Validation for User Story 3

- [ ] T018 [P] [US3] Add focused tests or example-driven verification
- [ ] T019 [P] [US3] Confirm no regression to public API, printing, or export behavior

### Implementation for User Story 3

- [ ] T020 [P] [US3] Update supporting files in [exact path]
- [ ] T021 [US3] Implement story behavior in [exact path]
- [ ] T022 [US3] Integrate the story with existing package flows

**Checkpoint**: All requested stories are independently functional

---

## Phase N: Contract Sync & Polish

**Purpose**: Close the loop on the package contract and release readiness

- [ ] TXXX Update `README.md` for any user-visible API or behavior change
- [ ] TXXX Update `CHANGELOG.md` with the correct Keep a Changelog category and SemVer impact
- [ ] TXXX Update `example/` screens, documents, and sample data for public-surface changes
- [ ] TXXX Run targeted `flutter analyze` for touched library and example surfaces
- [ ] TXXX Run focused tests and record manual/example verification results

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies
- **Foundational (Phase 2)**: Depends on Setup completion and blocks story completion
- **User Stories (Phase 3+)**: Depend on Foundational work that affects shared ownership or exports
- **Contract Sync & Polish**: Depends on all desired user stories being complete

### Within Each User Story

- Validation tasks MUST be defined before the story is called done
- Shared models/config before layer integrations
- Layer-owned implementation before public barrel updates
- Public contract updates before final validation

### Parallel Opportunities

- Tasks marked `[P]` may run in parallel when they touch different files
- Example updates can run in parallel with internal implementation when contracts are stable
- Validation tasks can run in parallel with documentation sync once behavior stabilizes

## Notes

- Each task MUST name the exact files it changes
- Public-surface changes MUST include README, CHANGELOG, and example tasks
- RTL/LTR and Arabic/English verification MUST be explicit when affected
- Avoid cross-layer drift: place work in the narrowest owning package path
