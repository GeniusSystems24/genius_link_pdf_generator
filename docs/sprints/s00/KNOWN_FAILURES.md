# S00 Known Directionality Failures

Version: **4.0.0**  
Sprint: **S00**

These failures are registered before any production directionality change.
Normal CI remains green; opt-in target tests are enabled with
`GENIUS_RUN_KNOWN_FAILURES=1` so the defects can be reproduced separately.

## KF-S00-001 — Summary value direction follows document direction

`GeniusPdfSummarySection` already computes different physical label/value
regions in RTL, but its value `PdfStringFormat` still follows the enclosing
document text direction. ERP values such as `15,697.50 SAR`, invoice
numbers, SKUs, IBANs, emails, and URLs need an independent value-run policy.

**Target:** S01 directionality core, then S02 Summary migration.

## KF-S00-002 — InfoBox values follow document direction

`GeniusPdfInfoBox` mirrors label/value bounds in RTL, but both formats are
tied to the document direction. Mixed Arabic labels with Latin/numeric
values therefore have no explicit independent value-direction contract.

**Target:** S01/S02.

## KF-S00-003 — No unified component/nested direction override

Current components primarily consume `config.isRTL` / document direction.
Nested English blocks inside Arabic documents do not share a package-wide
component direction override contract.

**Target:** S01 resolver/context, S02 component migration.

## KF-S00-004 — Logical placement is not yet a unified abstraction

Existing paths still contain physical left/right calculations. S00 records
those outputs. S01/S02 introduce logical `start/end` and
`leading/trailing` semantics.

## Non-goal

Do not modify production rendering to make these targets pass in S00.
S00 makes the behavior visible, reproducible, and reviewable first.
