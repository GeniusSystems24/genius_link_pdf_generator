
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S14 pack exposes every planned report/document class', () {
    final source = File(
      'lib/src/packs/accounting/accounting_documents.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'GeniusGeneralLedgerDocument',
      'GeniusJournalEntryDocument',
      'GeniusJournalRegisterDocument',
      'GeniusAccountStatementDocument',
      'GeniusArAgingDocument',
      'GeniusApAgingDocument',
      'GeniusCustomerBalancesDocument',
      'GeniusSupplierBalancesDocument',
      'GeniusCashBookDocument',
      'GeniusBankBookDocument',
      'GeniusBankReconciliationDocument',
      'GeniusPettyCashDocument',
      'GeniusPaymentRegisterDocument',
      'GeniusReceiptRegisterDocument',
      'GeniusVatTaxSummaryDocument',
      'GeniusTaxRegisterDocument',
      'GeniusTaxBreakdownDocument',
      'GeniusRoundingReconciliationDocument',
      'GeniusCostCenterStatementDocument',
      'GeniusCostCenterTrialBalanceDocument',
      'GeniusProjectFinancialReport',
      'GeniusBudgetVsActualReport',
      'GeniusMultiPeriodComparisonReport',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('financial arithmetic stays out of document rendering', () {
    final source = File(
      'lib/src/packs/accounting/accounting_documents.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('debit +')));
    expect(source, isNot(contains('credit -')));
    expect(source, contains('renderErpPackReport(report)'));
  });
}
