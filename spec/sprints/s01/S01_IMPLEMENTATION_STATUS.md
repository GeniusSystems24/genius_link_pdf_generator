
# Sprint S01 Implementation Status

Version: **4.0.0**

## Implemented

- [x] S01-T01 — `GeniusPdfDirection` with `auto/ltr/rtl`.
- [x] S01-T02 — `GeniusPdfDirectionality`.
- [x] S01-T03 — `GeniusPdfDirectionResolver`.
- [x] S01-T04 — element > component > template > document > locale precedence.
- [x] S01-T05 — ERP value-direction policy.
- [x] S01-T06 — stable direction API is package-owned and Syncfusion-free.
- [x] S01-T07 — logical start/end/center alignment.
- [x] S01-T08 — directional insets.
- [x] S01-T09 — leading/trailing semantics.
- [x] S01-T10 — logical-to-physical geometry helpers.
- [x] S01-T11 — new semantic inputs use logical geometry.
- [x] S01-T12..T15 — numeric, monetary, temporal, ID and contact value policies.
- [x] S01-T16 — no string-reversal RTL workaround in the new core.
- [x] S01-T17 — `GeniusPdfDirectedTextRun` + isolation semantics.
- [x] S01-T18 — directionality propagated to `GeniusPdfDocumentBuilder`.
- [x] S01-T19 — directionality propagated to `GeniusPdfReportComposer`.
- [x] S01-T20 — component/element/custom-block override helpers.
- [x] S01-T21 — TemplateDefinition/page-settings/context direction support with
  backward-compatible JSON defaults.
- [x] S01-T22 — nested context inheritance.
- [x] S01-T23..T28 — resolver, geometry, value, mixed text, nested override,
  architecture and media-mirroring tests.
- [x] S01-VX01..VX05 — dashboard manual-verification page using the real API.

## Acceptance still required after running the migration

The Python migration does not run Flutter commands. Before starting S02:

- [ ] run analyzer/tests in the target Flutter environment;
- [ ] verify all S01 resolver/geometry/value tests pass;
- [ ] open the S01 dashboard page;
- [ ] test precedence combinations in LTR/RTL;
- [ ] verify `15,697.50 SAR` and ERP IDs remain unchanged;
- [ ] verify logical START/END move physically with direction;
- [ ] verify no QR/image/barcode mirroring is introduced;
- [ ] confirm the existing S00 baselines are still available.

S02 is responsible for migrating the existing components onto this core.

## Post-migration repair

The S01 repair script verifies the concrete integration points that caused the
initial example diagnostics:

- [x] `GeniusPdfDocumentBuilder` accepts `directionality:` as a named argument.
- [x] the builder exposes the inherited `directionality` getter.
- [x] `GeniusPdfReportComposer` forwards the context to the builder.
- [x] S01 verification dropdowns use `initialValue` instead of the deprecated
  `DropdownButtonFormField.value`.
- [x] S00/S01 PDF regeneration never returns a `Future` from a `setState`
  callback.
- [x] a builder-level directionality integration regression test is included.

## Completion audit

See `docs/sprints/s01/S01_COMPLETION_AUDIT.md`. Source/test/manual-harness
coverage is complete; runtime Exit Gate closure still requires analyzer/tests
and manual review in the target Flutter environment.

### Template direction repair

`TemplateDefinition.direction` and `TemplatePageSettings.direction` are now
real package-owned public fields. They parse old JSON as `auto`, serialize only
when non-`auto`, and propagate through `TemplateBuilder`,
`PdfTemplateEngine`, and `TemplateContext`.
