
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S17 exposes all planned HR/payroll document classes', () {
    final source = File(
      'lib/src/packs/hr/hr_documents.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'GeniusEmployeeProfileDocument',
      'GeniusEmployeeListDocument',
      'GeniusEmploymentContractDocument',
      'GeniusEmployeeActionFormDocument',
      'GeniusAttendanceReportDocument',
      'GeniusTimesheetDocument',
      'GeniusOvertimeReportDocument',
      'GeniusLeaveBalanceDocument',
      'GeniusLeaveRequestDocument',
      'GeniusPayslipDocument',
      'GeniusPayrollSheetDocument',
      'GeniusPayrollSummaryDocument',
      'GeniusAllowancesReportDocument',
      'GeniusDeductionsReportDocument',
      'GeniusEmployeeLoanAdvanceReportDocument',
      'GeniusSalaryCertificateDocument',
      'GeniusEmploymentCertificateDocument',
      'GeniusExperienceCertificateDocument',
      'GeniusEndOfServiceReportDocument',
      'GeniusFinalSettlementDocument',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('S17 privacy policy includes visibility masking watermark and roles', () {
    final policy = File(
      'lib/src/packs/hr/hr_privacy.dart',
    ).readAsStringSync();
    final documents = File(
      'lib/src/packs/hr/hr_documents.dart',
    ).readAsStringSync();

    expect(policy, contains('visibleFields'));
    expect(policy, contains('maskedFields'));
    expect(policy, contains('maskIdentifier'));
    expect(policy, contains('variantHooks'));
    expect(policy, contains('GeniusHrPrintableRole'));
    expect(documents, contains('GeniusPdfWatermark.confidential'));
    expect(documents, contains('GeniusPdfWatermark.draft'));
  });

  test('payroll/settlement calculations stay outside rendering files', () {
    final documents = File(
      'lib/src/packs/hr/hr_documents.dart',
    ).readAsStringSync();

    expect(documents, isNot(contains('multiply(')));
    expect(documents, isNot(contains('baseSalary +')));
    expect(documents, isNot(contains('netSettlement =')));
    expect(documents, contains('renderErpPackReport(report)'));
  });
}
