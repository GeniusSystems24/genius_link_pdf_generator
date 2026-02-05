/// PDF Report Templates
///
/// Pre-built templates for common business reports.
///
/// Available templates:
///
/// **Financial Templates:**
/// - [TaxInvoiceTemplate] - ZATCA-compliant tax invoices
/// - [TrialBalanceTemplate] - Trial balance reports
/// - [CustomerStatementTemplate] - Customer account statements
/// - [InventoryReportTemplate] - Inventory valuation reports
/// - [BalanceSheetTemplate] - Balance sheet reports
/// - [IncomeStatementTemplate] - Income statement (P&L) reports
/// - [CashFlowTemplate] - Cash flow statements
/// - [BudgetReportTemplate] - Budget vs actual reports
///
/// **Sales Templates:**
/// - [QuotationTemplate] - Price quotations
/// - [PurchaseOrderTemplate] - Purchase orders
/// - [DeliveryNoteTemplate] - Delivery notes
/// - [CreditNoteTemplate] - Credit notes
/// - [DebitNoteTemplate] - Debit notes (alias for CreditNoteTemplate)
///
/// **HR Templates:**
/// - [PayslipTemplate] - Employee payslips
/// - [EmployeeReportTemplate] - Employee reports
/// - [AttendanceReportTemplate] - Attendance reports
/// - [LeaveReportTemplate] - Leave reports
library;

// Original templates
export 'tax_invoice_template.dart';
export 'trial_balance_template.dart';
export 'customer_statement_template.dart';
export 'inventory_report_template.dart';

// Financial templates (v1.3.0)
export 'balance_sheet_template.dart';
export 'income_statement_template.dart';
export 'cash_flow_template.dart';
export 'budget_report_template.dart';

// Sales templates (v1.3.0)
export 'quotation_template.dart';
export 'purchase_order_template.dart';
export 'delivery_note_template.dart';
export 'credit_note_template.dart';

// HR templates (v1.3.0)
export 'payslip_template.dart';
export 'employee_report_template.dart';
export 'attendance_report_template.dart';
export 'leave_report_template.dart';

// Service Voucher templates (v3.0.0)
export 'vouchers/vouchers.dart';
