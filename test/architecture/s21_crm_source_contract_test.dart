
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S21 exposes all planned CRM documents', () {
    final source = File(
      'lib/src/packs/crm/crm_documents.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'GeniusCustomerProfileDocument',
      'GeniusLeadReportDocument',
      'GeniusOpportunityReportDocument',
      'GeniusPipelineReportDocument',
      'GeniusActivityReportDocument',
      'GeniusVisitReportDocument',
      'GeniusCallReportDocument',
      'GeniusCustomerHistoryDocument',
      'GeniusProposalDocument',
      'GeniusContractSummaryDocument',
      'GeniusCrmPresentationOverviewDocument',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('S21 watermark variants use shared watermark API', () {
    final source = File(
      'lib/src/packs/crm/crm_documents.dart',
    ).readAsStringSync();

    expect(source, contains('GeniusPdfWatermark.draft'));
    expect(source, contains('GeniusPdfWatermark.confidential'));
  });
}
