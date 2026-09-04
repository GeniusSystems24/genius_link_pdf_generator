
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final expectations = <String, (String className, String family)>{
    'lib/templates/balance_sheet_template.dart':
        ('BalanceSheetTemplate', 'GeniusErpAnalyticalReport'),
    'lib/templates/budget_report_template.dart':
        ('BudgetReportTemplate', 'GeniusErpAnalyticalReport'),
    'lib/templates/cash_flow_template.dart':
        ('CashFlowTemplate', 'GeniusErpAnalyticalReport'),
    'lib/templates/income_statement_template.dart':
        ('IncomeStatementTemplate', 'GeniusErpAnalyticalReport'),
    'lib/templates/trial_balance_template.dart':
        ('TrialBalanceTemplate', 'GeniusErpRegisterDocument'),
    'lib/templates/customer_statement_template.dart':
        ('CustomerStatementTemplate', 'GeniusErpStatementDocument'),
    'lib/templates/attendance_report_template.dart':
        ('AttendanceReportTemplate', 'GeniusErpRegisterDocument'),
    'lib/templates/employee_report_template.dart':
        ('EmployeeReportTemplate', 'GeniusErpRegisterDocument'),
    'lib/templates/leave_report_template.dart':
        ('LeaveReportTemplate', 'GeniusErpRegisterDocument'),
    'lib/templates/payslip_template.dart':
        ('PayslipTemplate', 'GeniusErpOperationalForm'),
    'lib/templates/inventory_report_template.dart':
        ('InventoryReportTemplate', 'GeniusErpRegisterDocument'),
    'lib/templates/delivery_note_template.dart':
        ('DeliveryNoteTemplate', 'GeniusErpOperationalForm'),
    'lib/templates/credit_note_template.dart':
        ('CreditNoteTemplate', 'GeniusErpTransactionDocument'),
  };

  test('all S10 root templates inherit an S08 family', () {
    for (final entry in expectations.entries) {
      final source = File(entry.key).readAsStringSync();
      final expected =
          'class ${entry.value.$1} extends ${entry.value.$2}';
      expect(source, contains(expected), reason: entry.key);
    }
  });

  test('voucher base itself inherits the S08 voucher family', () {
    final source = File(
      'lib/templates/vouchers/templates/voucher_base_template.dart',
    ).readAsStringSync();

    expect(
      source,
      contains(
        'abstract class GeniusPdfVoucherTemplate '
        'extends GeniusErpVoucherDocument',
      ),
    );

    // S10-T30..T35: these shared features remain centralized once in base.
    for (final marker in <String>[
      'void drawAccountEntriesTable()',
      'void drawPartyInfo(',
      'void drawPaymentDetails()',
      'void drawAmountBlock()',
      'void drawAmountInWords()',
      'void drawSignatureBlock()',
      'void drawNotesBlock()',
      'setDefaultPageBorder(',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('S09 transaction templates remain family-backed', () {
    final files = <String, String>{
      'lib/templates/quotation_template.dart': 'QuotationTemplate',
      'lib/templates/purchase_order_template.dart': 'PurchaseOrderTemplate',
      'lib/templates/tax_invoice_template.dart': 'TaxInvoiceTemplate',
    };

    for (final entry in files.entries) {
      final source = File(entry.key).readAsStringSync();
      expect(
        source,
        contains(
          'class ${entry.value} extends GeniusErpTransactionDocument',
        ),
      );
    }
  });
}
