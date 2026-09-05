# S10 Duplication & Family Audit

Version: **4.0.0**

S10 moves every current public template to an S08 family superclass while
preserving public constructors/build behavior.

Private `_draw*` counts below are retained only for document-specific business
sections. Common family structure belongs to S07/S08. A non-zero count is not
by itself duplication.

| Template | Family | private `_draw*` helpers | local `_format*` helpers |
|---|---|---:|---:|
| `BalanceSheetTemplate` | `GeniusErpAnalyticalReport` | 5 | 2 |
| `BudgetReportTemplate` | `GeniusErpAnalyticalReport` | 8 | 3 |
| `CashFlowTemplate` | `GeniusErpAnalyticalReport` | 8 | 2 |
| `IncomeStatementTemplate` | `GeniusErpAnalyticalReport` | 7 | 2 |
| `TrialBalanceTemplate` | `GeniusErpRegisterDocument` | 9 | 4 |
| `CustomerStatementTemplate` | `GeniusErpStatementDocument` | 5 | 2 |
| `AttendanceReportTemplate` | `GeniusErpRegisterDocument` | 10 | 2 |
| `EmployeeReportTemplate` | `GeniusErpRegisterDocument` | 10 | 2 |
| `LeaveReportTemplate` | `GeniusErpRegisterDocument` | 11 | 1 |
| `PayslipTemplate` | `GeniusErpOperationalForm` | 12 | 2 |
| `InventoryReportTemplate` | `GeniusErpRegisterDocument` | 9 | 5 |
| `DeliveryNoteTemplate` | `GeniusErpOperationalForm` | 7 | 1 |
| `CreditNoteTemplate` | `GeniusErpTransactionDocument` | 7 | 2 |

## Voucher common-code audit

All concrete vouchers inherit:

```text
concrete voucher
  → GeniusPdfVoucherTemplate
  → GeniusErpVoucherDocument
  → GeniusErpDocumentFamily
```

The existing voucher base is intentionally the single implementation point for
shared voucher rendering. S10 also removes repeated `_drawSignatures()` geometry
from Attendance, Employee, Leave, Payslip, Inventory and Trial Balance and
routes it through `drawErpSignatureRow()` in
`erp_shared_layout.dart`:

- `drawAccountEntriesTable`: centralized
- `drawPartyInfo`: centralized
- `drawPaymentDetails`: centralized
- `drawAmountBlock`: centralized
- `drawAmountInWords`: centralized
- `drawSignatureBlock`: centralized
- `drawNotesBlock`: centralized

Concrete voucher files remain responsible only for voucher-specific fields and
`buildVoucherContent()` extensions.

## Registry invariant

`GeniusErpExistingTemplateFamilyRegistry` includes S09 transaction templates,
all S10 root templates, Credit/Debit Note and every current voucher class.
`test/architecture/s10_template_family_source_contract_test.dart` verifies the
source inheritance rather than trusting registry metadata alone.
