import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:genius_pdf_example/features/modern_vouchers/models/documents/modern_vouchers_demo_documents.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/new_templates_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/models/documents/templates_demo_documents.dart';



/// A queueable template exposed by the example application.
class JobTemplateOption {
  const JobTemplateOption({
    required this.id,
    required this.label,
    required this.labelAr,
    required this.fileName,
    required this.builder,
  });

  final String id;
  final String label;
  final String labelAr;
  final String fileName;
  final GeniusPdfDocumentBuilder Function(bool isRtl) builder;
}

/// Central registry used by Job Queue so any preserved template example can be queued.
abstract final class JobTemplateRegistry {
  static final List<JobTemplateOption> templates = <JobTemplateOption>[
    JobTemplateOption(
      id: 'tax-invoice', label: 'Tax invoice', labelAr: 'فاتورة ضريبية',
      fileName: 'tax_invoice_job', builder: (rtl) => buildTaxInvoiceTemplate(isRtl: rtl),
    ),
    JobTemplateOption(
      id: 'trial-balance', label: 'Trial balance', labelAr: 'ميزان مراجعة',
      fileName: 'trial_balance_job', builder: (rtl) => buildTrialBalanceTemplate(isRtl: rtl),
    ),
    JobTemplateOption(
      id: 'customer-statement', label: 'Customer statement', labelAr: 'كشف حساب عميل',
      fileName: 'customer_statement_job', builder: (rtl) => buildCustomerStatementTemplate(isRtl: rtl),
    ),
    JobTemplateOption(
      id: 'inventory-report', label: 'Inventory report', labelAr: 'تقرير مخزون',
      fileName: 'inventory_report_job', builder: (rtl) => buildInventoryReportTemplate(isRtl: rtl),
    ),
    JobTemplateOption(
      id: 'balance-sheet', label: 'Balance sheet', labelAr: 'الميزانية العمومية',
      fileName: 'balance_sheet_job', builder: (rtl) => buildBalanceSheetDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'income-statement', label: 'Income statement', labelAr: 'قائمة الدخل',
      fileName: 'income_statement_job', builder: (rtl) => buildIncomeStatementDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'cash-flow', label: 'Cash flow statement', labelAr: 'قائمة التدفقات النقدية',
      fileName: 'cash_flow_job', builder: (rtl) => buildCashFlowDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'budget-report', label: 'Budget report', labelAr: 'تقرير الميزانية',
      fileName: 'budget_report_job', builder: (rtl) => buildBudgetReportDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'quotation', label: 'Quotation', labelAr: 'عرض سعر',
      fileName: 'quotation_job', builder: (rtl) => buildQuotationDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'purchase-order', label: 'Purchase order', labelAr: 'أمر شراء',
      fileName: 'purchase_order_job', builder: (rtl) => buildPurchaseOrderDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'delivery-note', label: 'Delivery note', labelAr: 'إشعار تسليم',
      fileName: 'delivery_note_job', builder: (rtl) => buildDeliveryNoteDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'credit-note', label: 'Credit note', labelAr: 'إشعار دائن',
      fileName: 'credit_note_job', builder: (rtl) => buildCreditNoteDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'payslip', label: 'Payslip', labelAr: 'قسيمة راتب',
      fileName: 'payslip_job', builder: (rtl) => buildPayslipDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'employee-report', label: 'Employee report', labelAr: 'تقرير موظف',
      fileName: 'employee_report_job', builder: (rtl) => buildEmployeeReportDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'attendance-report', label: 'Attendance report', labelAr: 'تقرير حضور',
      fileName: 'attendance_report_job', builder: (rtl) => buildAttendanceReportDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'leave-report', label: 'Leave report', labelAr: 'تقرير إجازات',
      fileName: 'leave_report_job', builder: (rtl) => buildLeaveReportDemo(isRtl: rtl).builder,
    ),
    JobTemplateOption(
      id: 'modern-sales-voucher', label: 'Modern sales voucher', labelAr: 'سند مبيعات حديث',
      fileName: 'modern_sales_voucher_job', builder: (rtl) => buildModernSalesVoucher(isRtl: rtl),
    ),
    JobTemplateOption(
      id: 'modern-purchase-voucher', label: 'Modern purchase voucher', labelAr: 'سند مشتريات حديث',
      fileName: 'modern_purchase_voucher_job', builder: (rtl) => buildModernPurchaseVoucher(isRtl: rtl),
    ),
    JobTemplateOption(
      id: 'modern-sales-return', label: 'Modern sales return', labelAr: 'مرتجع مبيعات حديث',
      fileName: 'modern_sales_return_job', builder: (rtl) => buildModernSalesReturnVoucher(isRtl: rtl),
    ),
    JobTemplateOption(
      id: 'modern-purchase-return', label: 'Modern purchase return', labelAr: 'مرتجع مشتريات حديث',
      fileName: 'modern_purchase_return_job', builder: (rtl) => buildModernPurchaseReturnVoucher(isRtl: rtl),
    ),
    JobTemplateOption(
      id: 'b5-payment-voucher', label: 'B5 payment voucher', labelAr: 'سند صرف B5',
      fileName: 'b5_payment_voucher_job', builder: (rtl) => buildB5PaymentVoucher(isRtl: rtl),
    ),
  ];

  static JobTemplateOption byId(String id) =>
      templates.firstWhere((template) => template.id == id);
}
