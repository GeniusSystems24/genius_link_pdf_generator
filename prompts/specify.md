/speckit.specify

Feature name:
Financial Calculation Correctness and Validation

Problem:
The PDF generator includes financial templates, vouchers, remittance documents, trade vouchers, banking vouchers, tax vouchers, summaries, grid totals, and amount-to-words conversion. These areas require strict mathematical correctness. Any mismatch between line items, subtotal, VAT, discounts, fees, exchange rates, net amounts, and grand totals can produce incorrect financial documents.

Goal:
Create a deterministic financial calculation and validation layer used by all financial templates and voucher templates.

Scope:
- Validate subtotal calculations from line items.
- Validate VAT calculations.
- Validate grand total calculations.
- Validate discount calculations.
- Validate transfer fee and commission calculations.
- Validate source amount, exchange rate, and target amount calculations.
- Validate debit and credit equality for accounting entries.
- Validate payment deductions.
- Validate budget variance and variance percentage.
- Validate grid total rows, averages, min, max, and counts.
- Validate amount-to-words input values after rounding.
- Detect inconsistent template data before rendering.
- Return structured validation errors instead of silently generating incorrect PDFs.

Requirements:
1. All money calculations must use a safe money representation.
2. Rounding rules must be explicit and configurable.
3. Default rounding should be suitable for financial documents with 2 decimal places.
4. Currency minor units must be supported.
5. All templates must either calculate totals internally or validate provided totals against calculated totals.
6. If provided totals differ from calculated totals beyond the allowed tolerance, the library must return a validation error.
7. Validation must be optional but enabled by default for financial templates.
8. The system must support Arabic and English error messages.
9. Existing public APIs should not break unless absolutely necessary.
10. README examples must be reviewed and corrected if they contain inconsistent calculations.

Acceptance Criteria:
- A purchase voucher with inconsistent subtotal fails validation.
- A VAT voucher validates net VAT as output VAT minus input VAT.
- A transfer voucher validates net amount as amount minus transfer fees and commissions when applicable.
- A remittance voucher validates target amount using source amount and exchange rate according to rounding policy.
- A grid with grouped totals validates totals at group and report levels.
- Amount-to-words receives the final rounded amount, not the raw floating value.
- Regression tests exist for zero, negative, large, decimal, multi-currency, and rounding edge cases.