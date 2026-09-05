
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S18 exposes Manufacturing and Quality public documents', () {
    final source = File(
      'lib/src/packs/manufacturing_quality/'
      'manufacturing_quality_documents.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'GeniusBillOfMaterialsDocument',
      'GeniusProductionOrderDocument',
      'GeniusWorkOrderDocument',
      'GeniusJobCardDocument',
      'GeniusMaterialRequirementDocument',
      'GeniusMaterialIssueDocument',
      'GeniusMaterialReturnDocument',
      'GeniusProductionReceiptDocument',
      'GeniusRoutingTravelerDocument',
      'GeniusMachineOperationReportDocument',
      'GeniusLaborReportDocument',
      'GeniusScrapReportDocument',
      'GeniusWorkInProgressDocument',
      'GeniusProductionVarianceDocument',
      'GeniusQualityInspectionDocument',
      'GeniusIncomingInspectionDocument',
      'GeniusInProcessInspectionDocument',
      'GeniusFinalInspectionDocument',
      'GeniusNonConformanceReportDocument',
      'GeniusCorrectivePreventiveActionDocument',
      'GeniusCertificateOfAnalysisDocument',
      'GeniusQualityChecklistDocument',
      'GeniusQualityAuditFormDocument',
      'GeniusCalibrationRecordDocument',
      'GeniusManufacturingNestedTableDocument',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('nested table reuses DataGrid group rows', () {
    final source = File(
      'lib/src/packs/manufacturing_quality/'
      'manufacturing_quality_rendering.dart',
    ).readAsStringSync();

    expect(source, contains('GeniusPdfGridRow.groupHeader'));
    expect(source, contains('GeniusPdfDataGrid('));
    expect(source, contains('keepWithNext: true'));
    expect(source, contains('keepTogether: true'));
  });

  test('quality primitives cover checklist status tolerance trace/sign-off', () {
    final source = File(
      'lib/src/packs/manufacturing_quality/'
      'manufacturing_quality_models.dart',
    ).readAsStringSync();

    expect(source, contains('class GeniusQualityChecklistItem'));
    expect(source, contains('enum GeniusQualityStatus'));
    expect(source, contains('class GeniusQualityMeasurement'));
    expect(source, contains('toleranceText'));
    expect(source, contains('ErpBatchInfo? batch'));
    expect(source, contains('List<ErpSerialInfo>'));
    expect(source, contains('class GeniusQualitySignOff'));
  });
}
