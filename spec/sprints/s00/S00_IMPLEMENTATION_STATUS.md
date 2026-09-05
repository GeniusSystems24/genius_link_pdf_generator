# S00 Implementation Status — 4.0.0

## Migration deliverables

- [x] S00-T01 — generated public component API inventory.
- [x] S00-T02 — EN/LTR, AR/RTL, bilingual reference-PDF harness.
- [x] S00-T03 — Summary EN/AR capture + PDF-to-PNG golden renderer.
- [x] S00-T04 — deterministic Quotation / PurchaseOrder / TaxInvoice fixtures.
- [x] S00-T05 — runtime page-count/page-dimension metadata capture.
- [x] S00-T06..T12 — canonical directionality/data fixtures.
- [x] S00-T13..T18 — passing guards plus isolated opt-in known-target tests.
- [x] S00-T19 — unified PDF artifact capture helper.
- [x] S00-T20 — unified PDF-to-PNG renderer.
- [x] S00-T21 — canonical golden naming.
- [x] S00-T22 — deliberate `--accept` golden workflow.
- [x] S00-T23 — known-failure register.
- [x] S00-VX01..VX05 — dashboard manual verification page, navigation,
  scenarios, actual package preview, and Expected Result guidance.

## Exit-gate acceptance still required in the target Flutter environment

The source implementation is installed by this migration, but the S00 Exit
Gate must not be signed off until the generated harness is actually run:

- [ ] normal S00 tests pass;
- [ ] opt-in known-target mode reproduces the documented RTL targets;
- [ ] PDF baselines are captured;
- [ ] candidate PNGs are visually reviewed;
- [ ] reviewed goldens are explicitly accepted;
- [ ] the dashboard S00 page is manually reviewed in LTR and RTL;
- [ ] analyzer/test failures unrelated to known S00 targets are resolved.

S00 must not contain the RTL fix itself. That starts in S01/S02.
