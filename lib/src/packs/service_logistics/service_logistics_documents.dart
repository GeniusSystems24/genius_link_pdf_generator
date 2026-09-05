
import '../../core/pdf_config.dart';
import '../../families/erp/erp_families.dart';
import '../../printing/profiles/print_profiles.dart';
import '../shared/erp_pack_shared.dart';
import 'service_logistics_models.dart';
import 'service_logistics_service.dart';

abstract class _S20OperationalDocument
    extends GeniusErpOperationalForm {
  _S20OperationalDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _S20RegisterDocument extends GeniusErpRegisterDocument {
  _S20RegisterDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _S20AnalyticalDocument
    extends GeniusErpAnalyticalReport {
  _S20AnalyticalDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S20-T01 — Service Order.
class GeniusServiceOrderDocument extends _S20OperationalDocument {
  GeniusServiceOrderDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T02 — Maintenance Work Order.
class GeniusMaintenanceWorkOrderDocument
    extends _S20OperationalDocument {
  GeniusMaintenanceWorkOrderDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T03 — Preventive Maintenance Schedule.
class GeniusPreventiveMaintenanceScheduleDocument
    extends _S20RegisterDocument {
  GeniusPreventiveMaintenanceScheduleDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T04/T25 — Maintenance Checklist.
class GeniusMaintenanceChecklistDocument
    extends _S20OperationalDocument {
  GeniusMaintenanceChecklistDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T05/T24/T27 — Technician Report.
class GeniusTechnicianReportDocument extends _S20RegisterDocument {
  GeniusTechnicianReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T06/T26/T28 — Service Completion Report.
class GeniusServiceCompletionReportDocument
    extends _S20OperationalDocument {
  GeniusServiceCompletionReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T07 — Spare Parts Usage.
class GeniusSparePartsUsageDocument extends _S20RegisterDocument {
  GeniusSparePartsUsageDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T08 — Warranty Report.
class GeniusWarrantyReportDocument extends _S20RegisterDocument {
  GeniusWarrantyReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T09 — Inspection Report.
class GeniusServiceInspectionReportDocument
    extends _S20OperationalDocument {
  GeniusServiceInspectionReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T10 — Calibration/Service History.
class GeniusCalibrationServiceHistoryDocument
    extends _S20RegisterDocument {
  GeniusCalibrationServiceHistoryDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T11 — Shipment Document.
class GeniusShipmentDocument extends _S20OperationalDocument {
  GeniusShipmentDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T12 — Packing List variant.
class GeniusLogisticsPackingListDocument extends _S20OperationalDocument {
  GeniusLogisticsPackingListDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T13 — Dispatch Note.
class GeniusDispatchNoteDocument extends _S20OperationalDocument {
  GeniusDispatchNoteDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T14 — Waybill.
class GeniusWaybillDocument extends _S20OperationalDocument {
  GeniusWaybillDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T15/T23/T29 — Manifest.
class GeniusManifestDocument extends _S20RegisterDocument {
  GeniusManifestDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T16 — Trip Sheet.
class GeniusTripSheetDocument extends _S20OperationalDocument {
  GeniusTripSheetDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T17 — Trip Report.
class GeniusTripReportDocument extends _S20RegisterDocument {
  GeniusTripReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T32 — verification document for label/thermal profile hooks.
class GeniusServiceLogisticsProfileMatrixDocument
    extends _S20RegisterDocument {
  GeniusServiceLogisticsProfileMatrixDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T18/T31/T32 — Shipping Label using S11 profile/label engine.
class GeniusShippingLabelDocument extends GeniusPdfLabelPrintDocument {
  GeniusShippingLabelDocument({
    required GeniusPdfConfig config,
    required GeniusPdfPrintProfile profile,
    required List<GeniusShipmentData> shipments,
    GeniusServiceLogisticsService service =
        const GeniusServiceLogisticsService(),
  }) : super(
          config: config,
          profile: profile,
          labels: [
            for (final shipment in shipments)
              service.shippingLabelData(shipment),
          ],
        );
}

/// S20-T19/T32 — Pallet Label using S11 profile/label engine.
class GeniusPalletLabelRequest {
  const GeniusPalletLabelRequest({
    required this.palletNumber,
    required this.shipment,
    this.packageCount,
    this.weight,
  });

  final String palletNumber;
  final GeniusShipmentData shipment;
  final int? packageCount;
  final double? weight;
}

class GeniusPalletLabelDocument extends GeniusPdfLabelPrintDocument {
  GeniusPalletLabelDocument({
    required GeniusPdfConfig config,
    required GeniusPdfPrintProfile profile,
    required List<GeniusPalletLabelRequest> pallets,
    GeniusServiceLogisticsService service =
        const GeniusServiceLogisticsService(),
  }) : super(
          config: config,
          profile: profile,
          labels: [
            for (final pallet in pallets)
              service.palletLabelData(
                palletNumber: pallet.palletNumber,
                shipment: pallet.shipment,
                packageCount: pallet.packageCount,
                weight: pallet.weight,
              ),
          ],
        );
}

/// S20-T20 — Container List.
class GeniusContainerListDocument extends _S20RegisterDocument {
  GeniusContainerListDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T21 — Freight Summary.
class GeniusFreightSummaryDocument extends _S20AnalyticalDocument {
  GeniusFreightSummaryDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S20-T22/T26/T27/T28/T33 — Proof of Delivery.
class GeniusProofOfDeliveryDocument
    extends _S20OperationalDocument {
  GeniusProofOfDeliveryDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}
