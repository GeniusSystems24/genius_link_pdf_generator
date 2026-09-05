# Sprint S01 Completion Audit

Version: **4.0.0**

## Source-level task coverage

- [x] S01-T01..T06 — package-owned direction enum/context/resolver,
  precedence, value policy and stable direction API.
- [x] S01-T07..T11 — logical alignment/insets/leading-trailing, conversion
  helpers, plus a guard against left/right semantic alternatives.
- [x] S01-T12..T17 — numeric/money/date/ID/contact LTR policies, no string
  reversal, and directed mixed-text runs.
- [x] S01-T18..T22 — DocumentBuilder, ReportComposer, component/custom
  overrides, TemplateDefinition/page direction, legacy JSON compatibility,
  and nested inheritance.
- [x] S01-T23..T28 — resolver, geometry, value, mixed-text, nested override,
  and preserve-by-default media tests.
- [x] S01-VX01..VX05 — verification page, dashboard exposure, scenario matrix,
  real PDF preview/regeneration, and scenario-specific Expected Result.

The completion pass adds explicit tests for S01-T11 and S01-T21 and expands
manual coverage with long/multi-page and AUTO-inheritance scenarios.

`null` is not a direction state in S01. `auto` is the explicit
inheritance/absence state.

## Runtime Exit Gate still requires execution

A source-editing Python script cannot truthfully claim runtime acceptance. Before
starting S02:

- [ ] analyzer has no errors;
- [ ] all S01 tests pass;
- [ ] S00 baselines remain available;
- [ ] S01 opens from desktop/mobile/dashboard-home navigation;
- [ ] every scenario matches its Expected Result;
- [ ] ERP values remain textually unchanged in LTR/RTL;
- [ ] RTL alone never mirrors media.
