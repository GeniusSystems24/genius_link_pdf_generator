
# Sprint S06 Implementation Status

Version: **4.0.0**

- [x] S06-T01..T07 — shared document context/identity/metadata/status.
- [x] S06-T08..T12 — party/address/tax/contact/address-role models.
- [x] S06-T13..T18 — money/currency/exchange/rounding/precision separation.
- [x] S06-T19..T26 — quantity/unit/line/tax/discount/charge/batch/serial.
- [x] S06-T27..T29 — approval/signature/attachment.
- [x] S06-T30..T39 — typed subtotal/discount/charge/tax/grand/rounding/
  paid-due/multi-currency calculation.
- [x] S06-T40..T46 — value semantics, validation, edge cases, multi-tax,
  before/after-tax policy and boundary-only serialization.
- [x] S06-VX01..VX05 — real Manual Verification page + Dashboard navigation.

## Exit Gate

Source tasks and deliverables are installed by the migration. Formal closure
still requires analyzer/tests/manual acceptance:

- [ ] Quotation/PO/Invoice representation review.
- [ ] calculation layer independence review.
- [ ] deterministic rounding/tax tests pass.
- [ ] null optional metadata produces no dummy values.
