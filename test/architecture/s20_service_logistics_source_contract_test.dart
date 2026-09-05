
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S20 exposes all planned service/logistics documents', () {
    final source = File(
      'lib/src/packs/service_logistics/service_logistics_documents.dart',
    ).readAsStringSync();

    for (final marker in <String>[
      'GeniusServiceOrderDocument',
      'GeniusMaintenanceWorkOrderDocument',
      'GeniusPreventiveMaintenanceScheduleDocument',
      'GeniusMaintenanceChecklistDocument',
      'GeniusTechnicianReportDocument',
      'GeniusServiceCompletionReportDocument',
      'GeniusSparePartsUsageDocument',
      'GeniusWarrantyReportDocument',
      'GeniusServiceInspectionReportDocument',
      'GeniusCalibrationServiceHistoryDocument',
      'GeniusShipmentDocument',
      'GeniusLogisticsPackingListDocument',
      'GeniusDispatchNoteDocument',
      'GeniusWaybillDocument',
      'GeniusManifestDocument',
      'GeniusTripSheetDocument',
      'GeniusTripReportDocument',
      'GeniusShippingLabelDocument',
      'GeniusPalletLabelDocument',
      'GeniusContainerListDocument',
      'GeniusFreightSummaryDocument',
      'GeniusProofOfDeliveryDocument',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });

  test('S20 shared mechanics are typed and reused', () {
    final models = File(
      'lib/src/packs/service_logistics/service_logistics_models.dart',
    ).readAsStringSync();
    final service = File(
      'lib/src/packs/service_logistics/service_logistics_service.dart',
    ).readAsStringSync();

    expect(models, contains('GeniusLogisticsRouteReference'));
    expect(models, contains('GeniusServicePersonIdentity'));
    expect(models, contains('GeniusLogisticsVehicleIdentity'));
    expect(models, contains('typedef GeniusServiceChecklistItem'));
    expect(models, contains('GeniusDeliveryProofSignature'));
    expect(models, contains('GeniusGeoTimeMetadata'));
    expect(models, contains('GeniusServiceAttachmentReference'));
    expect(service, contains('GeniusPdfPrintProfile.thermal58'));
    expect(service, contains('GeniusPdfPrintProfile.thermal80'));
  });

  test('S20 labels reuse S11 label renderer', () {
    final source = File(
      'lib/src/packs/service_logistics/service_logistics_documents.dart',
    ).readAsStringSync();

    expect(
      RegExp('extends GeniusPdfLabelPrintDocument')
          .allMatches(source)
          .length,
      2,
    );
  });
}
