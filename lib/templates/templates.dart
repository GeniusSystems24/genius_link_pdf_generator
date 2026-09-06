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
/// - [SingleAccountPdf] - Single-account summary/detailed exports
/// - [MultiAccountPdf] - Grouped multi-account summary/detailed exports
/// - [SingleAccountImage] - Compact single-account image source
/// - [MultiAccountImage] - Compact split multi-account image source
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
export 'tax_invoice.dart';
export 'trial_balance.dart';
export 'customer_statement.dart';
export 'inventory_report.dart';
export 'account_export/account_export.dart';
export 'transaction_transfer_export/transaction_transfer_export.dart';

// Financial templates (v1.3.0)
export 'balance_sheet.dart';
export 'income_statement.dart';
export 'cash_flow.dart';
export 'budget_report.dart';

// Sales templates (v1.3.0)
export 'quotation.dart';
export 'purchase_order.dart';
export 'delivery_note.dart';
export 'credit_note.dart';

// HR templates (v1.3.0)
export 'payslip.dart';
export 'employee_report.dart';
export 'attendance_report.dart';
export 'leave_report.dart';

// Service Voucher templates (v3.0.0)
export 'vouchers/vouchers.dart';

// S09 shared legacy compatibility
export 'erp_legacy_shared.dart';
export '../src/packs/sales/pack.dart';
export '../src/packs/purchasing/pack.dart';
export '../src/packs/accounting/pack.dart';
export '../src/packs/inventory/pack.dart';
export '../src/packs/pos/pack.dart';
export '../src/packs/hr/pack.dart';
export '../src/packs/mfg_quality/pack.dart';
export '../src/packs/assets_proj/pack.dart';
export '../src/packs/svc_logistics/pack.dart';
export '../src/packs/crm/pack.dart';
export '../src/engine_vnext/template_engine_vnext.dart';
export '../src/compliance/compliance.dart';
export '../src/designer/template_designer.dart';
export '../src/industries/industry_pack_api.dart';
