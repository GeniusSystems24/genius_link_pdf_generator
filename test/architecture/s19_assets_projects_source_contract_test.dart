
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S19 exposes all Asset and Project public documents', () {
    final source = File(
      'lib/src/packs/assets_projects/assets_projects_documents.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'GeniusAssetCardDocument',
      'GeniusAssetRegisterDocument',
      'GeniusAssetLabelDocument',
      'GeniusAssetTransferDocument',
      'GeniusAssetAssignmentDocument',
      'GeniusAssetReturnDocument',
      'GeniusAssetDisposalDocument',
      'GeniusAssetDepreciationReportDocument',
      'GeniusAssetMaintenanceReportDocument',
      'GeniusAssetCountDocument',
      'GeniusAssetMovementReportDocument',
      'GeniusProjectSummaryDocument',
      'GeniusProjectBudgetDocument',
      'GeniusProjectCostDocument',
      'GeniusProjectProfitabilityDocument',
      'GeniusProjectTimesheetDocument',
      'GeniusProjectExpenseReportDocument',
      'GeniusProjectMilestoneReportDocument',
      'GeniusProjectProgressReportDocument',
      'GeniusProjectCompletionCertificateDocument',
      'GeniusProjectBillingDocument',
      'GeniusProjectResourceUtilizationDocument',
      'GeniusProjectPurchasingReportDocument',
      'GeniusProjectMultiPeriodFinancialDocument',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('S19 label output reuses S11 label engine', () {
    final source = File(
      'lib/src/packs/assets_projects/assets_projects_documents.dart',
    ).readAsStringSync();
    final service = File(
      'lib/src/packs/assets_projects/assets_projects_service.dart',
    ).readAsStringSync();

    expect(source, contains('extends GeniusPdfLabelPrintDocument'));
    expect(service, contains('GeniusPdfPrintProfile.customLabel'));
    expect(service, contains('GeniusPdfPrintProfile.labelSheet'));
    expect(service, contains('assetLabelData'));
  });

  test('S19 rendering wrappers contain no depreciation math', () {
    final source = File(
      'lib/src/packs/assets_projects/assets_projects_documents.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('usefulLifeMonths /')));
    expect(source, isNot(contains('decliningAnnualRatePercent')));
    expect(source, isNot(contains('projectFinancialsByPeriod')));
    expect(source, contains('renderErpPackReport(report)'));
  });
}
