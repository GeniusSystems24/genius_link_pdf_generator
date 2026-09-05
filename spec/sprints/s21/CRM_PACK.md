
# S21 — CRM Pack

Version: **4.0.0**

S21 completes the Advanced ERP milestone with CRM/customer-facing print
outputs built on the shared ERP report/family infrastructure.

## Documents

- Customer Profile
- Lead Report
- Opportunity Report
- Pipeline Report
- Activity Report
- Visit Report
- Call Report
- Customer History
- Proposal
- Contract Summary / document shell

`GeniusCrmService` prepares totals, filtering, weighted pipeline values,
history order and proposal totals before rendering.

## Presentation primitives

S21 adds renderer-neutral printable primitives for metric cards, textual
stage/status presentation, timeline/history entries, contact/party blocks and
attachment/reference lists. Stage presentation always has a textual/status
representation and never depends on charts only.

## Directionality and privacy

Arabic names/notes/descriptions are kept separate from Latin emails, phones,
document numbers and CRM IDs. CRM documents support `none`, `draft` and
`confidential` watermark variants through the existing watermark component.

## QA

Tests cover long activity histories, Arabic notes with Latin contacts, pipeline
reconciliation, 250-line multi-page proposal preparation and watermark/source
contracts. The S21 Dashboard verification page uses real public APIs, LTR/RTL,
large row counts and Preview/Generate.
