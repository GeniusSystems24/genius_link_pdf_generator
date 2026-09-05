
# Sprint S07 Implementation Status

Version: **4.0.0**

## A — Identity & party

- [x] S07-T01 — `GeniusPdfDocumentIdentity`.
- [x] S07-T02 — `GeniusPdfPartyBlock`.
- [x] S07-T03 — `GeniusPdfAddressBlock`.
- [x] S07-T04 — `GeniusPdfReferenceBlock`.

## B — Financial

- [x] S07-T05 — `GeniusPdfMoney`.
- [x] S07-T06 — `GeniusPdfAmountInWords`.
- [x] S07-T07 — `GeniusPdfTaxSummary`.
- [x] S07-T08 — discount/charge summary block.
- [x] S07-T09 — balance/due block.

## C — Operational

- [x] S07-T10 — `GeniusPdfTermsSection`.
- [x] S07-T11 — `GeniusPdfApprovalTrail`.
- [x] S07-T12 — `GeniusPdfStamp`.
- [x] S07-T13 — `GeniusPdfMetricCards`.
- [x] S07-T14 — `GeniusPdfLabel`.

## D — Optional sections

- [x] S07-T15 — nullable data where semantically valid.
- [x] S07-T16 — null section collapses completely.
- [x] S07-T17 — component group adds no spacing for hidden sections.
- [x] S07-T18 — explicit hide/empty-state policy for empty lists.

## E — Directionality

- [x] S07-T19 — logical start/end public geometry.
- [x] S07-T20 — independent value-run direction categories.
- [x] S07-T21 — EN/AR/bilingual verification + semantic goldens.
- [x] S07-T22 — mixed address/phone/ID coverage.

## F — Docs

- [x] S07-T23 — Flutter-style API documentation.
- [x] S07-T24 — usage examples.
- [x] S07-T25 — composition examples.
- [x] S07-T26 — Do/Don't duplication guidance.

## Manual Verification

- [x] S07-VX01 — dedicated S07 verification page.
- [x] S07-VX02 — Dashboard/navigation integration.
- [x] S07-VX03 — normal/null/empty/bilingual/LTR/RTL/long/multi-page
  scenarios.
- [x] S07-VX04 — real public components and PDF Preview/Generate.
- [x] S07-VX05 — Expected Result per scenario.

## Exit Gate

Source implementation and fixtures are installed. Formal Sprint closure still
requires the project owner to run analyzer/tests and manually verify:

- [ ] a new ERP template can use the shared identity/party/tax/terms components
  instead of rebuilding them;
- [ ] all components pass visual LTR/RTL/bilingual review;
- [ ] null sections leave no gaps.
