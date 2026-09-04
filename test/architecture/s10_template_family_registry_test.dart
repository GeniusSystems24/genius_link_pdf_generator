
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  test('S10 family registry covers current templates', () {
    const expected = <String>[
      'QuotationTemplate',
      'PurchaseOrderTemplate',
      'TaxInvoiceTemplate',
      'BalanceSheetTemplate',
      'BudgetReportTemplate',
      'CashFlowTemplate',
      'IncomeStatementTemplate',
      'TrialBalanceTemplate',
      'CustomerStatementTemplate',
      'AttendanceReportTemplate',
      'EmployeeReportTemplate',
      'LeaveReportTemplate',
      'PayslipTemplate',
      'InventoryReportTemplate',
      'DeliveryNoteTemplate',
      'CreditNoteTemplate',
      'DebitNoteTemplate',
      'AccountingEntryVoucher',
      'BankDepositVoucher',
      'BankWithdrawalVoucher',
      'BillPaymentVoucher',
      'GiftVoucher',
      'InventoryVoucher',
      'ModernVoucherTemplate',
      'PaymentVoucher',
      'PurchaseReturnVoucher',
      'PurchaseVoucher',
      'ReceiptVoucher',
      'RemittanceIncomingVoucher',
      'RemittanceOutgoingVoucher',
      'SalesReturnVoucher',
      'SalesVoucher',
      'TaxVoucher',
      'TransferVoucher',
    ];

    expect(
      GeniusErpExistingTemplateFamilyRegistry.coversAll(expected),
      isTrue,
    );
  });

  test('semantic EN/AR matrix remains complete', () {
    final source = File(
      'test/goldens/s10/template_family_matrix.txt',
    ).readAsStringSync();

    for (final registration
        in GeniusErpExistingTemplateFamilyRegistry.all) {
      expect(
        source,
        contains('${registration.templateType}|'),
        reason: registration.templateType,
      );
    }
    expect(source, contains('en=ltr|ar=rtl'));
  });
}
