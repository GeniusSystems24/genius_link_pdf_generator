
# S17 — HR & Payroll Pack

Version: **4.0.0**

S17 completes the HR/Payroll part of Core ERP Coverage with typed data,
privacy policies, deterministic payroll/settlement calculations, certificate
constraints and reusable ERP family documents.

## Employee

Public outputs:

- `GeniusEmployeeProfileDocument`
- `GeniusEmployeeListDocument`
- `GeniusEmploymentContractDocument`
- `GeniusEmployeeActionFormDocument`

`GeniusHrEmployee` keeps Arabic names separate from Latin IDs, bank references
and other structured values.

## Time and attendance

- Attendance Report
- Timesheet
- Overtime Report
- Leave Balance
- Leave Request

Worked time, late time, weighted overtime hours and leave availability are
prepared by `GeniusHrPayrollService` before rendering.

## Payroll

- Payslip
- Payroll Sheet
- Payroll Summary
- Allowances Report
- Deductions Report
- Employee Loan / Advance Report

`GeniusHrPayrollEntry` is an input model. `calculatePayroll()` produces the
reconciled `GeniusHrPayrollResult`:

```text
gross = base salary + earnings
net   = gross - deductions
```

The PDF document classes only render prepared values.

## Certificates and settlement

- Salary Certificate
- Employment Certificate
- Experience Certificate
- End-of-Service calculation/report
- Final Settlement

End-of-service is deliberately policy-driven via
`GeniusHrEndOfServicePolicy`; the package does not hardcode one country's legal
formula. Applications configure threshold years, eligible days and partial
year behavior.

`GeniusHrCertificatePolicy` provides a conservative single-page content guard.
It validates body/field size before certificate rendering instead of pretending
to know a physical page break from business data alone.

## Privacy and security

`GeniusHrPrintPolicy` provides:

- field visibility policies;
- sensitive identifier masking;
- role-specific defaults;
- role-specific report hooks;
- confidential watermark;
- optional custom watermark text.

Default masking protects National ID, Passport, Bank Account and IBAN. The
actual visible fields depend on the selected printable role.

## QA

Automated source/domain tests cover:

- Arabic employee names;
- Latin employee IDs and IBAN/bank values;
- long allowance/deduction lists;
- payroll reconciliation;
- end-of-service/final-settlement calculations;
- certificate single-page guard;
- masking/visibility/watermark contracts.

The S17 Dashboard verification page uses the real public API and supports
LTR/RTL, role/privacy variants, long payroll lines and PDF preview/generation.
