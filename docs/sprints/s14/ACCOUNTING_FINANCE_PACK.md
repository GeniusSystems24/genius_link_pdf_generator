
# S14 — Accounting & Finance Pack

Version: **4.0.0**

S14 introduces the Accounting & Finance ERP pack on the existing S06 money
model and S12/S13 shared report renderer. PDF classes do not perform accounting
arithmetic.

## Ledger and journal

Implemented public outputs:

- `GeniusGeneralLedgerDocument`
- `GeniusJournalEntryDocument`
- `GeniusJournalRegisterDocument`
- `GeniusAccountStatementDocument`

`GeniusAccountingPosting` models debit/credit explicitly. A posting validates
that currencies match and prevents simultaneous non-zero debit and credit.

`GeniusAccountingService.generalLedger()` owns opening/running/closing balance
preparation. `GeniusAccountingCarryPolicy.estimatedPageRows` is the explicit
opt-in brought/carried-forward policy. It is deterministic and disabled by
default because physical page boundaries depend on font metrics and wrapping.

## Receivables/payables

The pack provides:

- AR Aging
- AP Aging
- Customer Balances
- Supplier Balances

Aging reuses the shared `GeniusErpAgingService`; it does not implement a second
aging formula.

## Cash and bank

- Cash Book
- Bank Book
- Bank Reconciliation
- Petty Cash
- Payment Register
- Receipt Register

Bank reconciliation compares book and statement amounts and exposes a
deterministic difference.

## Tax

- VAT/Tax Summary
- Tax Register
- Taxable/Exempt/Zero-rated breakdown
- Rounding/Reconciliation report

Tax classification uses `GeniusAccountingTaxCategory`.

## Cost/project/budget

- Cost Center Statement
- Cost Center Trial Balance
- Project Financial Report
- Budget vs Actual
- Multi-period Comparison

All grouping/variance calculations are prepared before rendering.

## Financial presentation

`GeniusAccountingFormat` implements:

- accounting negatives as parentheses;
- zero as dash;
- currency precision;
- logical chart-of-accounts hierarchy labels.

Debit and credit remain distinct semantic columns. Structured financial values
remain LTR inside RTL documents via the shared DataGrid direction policy.

## QA and performance

Tests cover reconciliation, decimal precision, multi-currency rejection,
long chart hierarchy and carry rows.

`benchmark/s14_accounting_10k_benchmark.dart` provides the required 10k-row
preparation sample without fabricating performance numbers.

The S14 Dashboard verification page exposes LTR/RTL, carry policy and
1/100/10000-row scenarios with real PDF preview/generation.
