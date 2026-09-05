
import '../../core/pdf_config.dart';
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';
import 'manufacturing_quality_models.dart';
import 'manufacturing_quality_rendering.dart';

abstract class _ManufacturingOperationalDocument
    extends GeniusErpOperationalForm {
  _ManufacturingOperationalDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _ManufacturingRegisterDocument
    extends GeniusErpRegisterDocument {
  _ManufacturingRegisterDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _ManufacturingAnalyticalDocument
    extends GeniusErpAnalyticalReport {
  _ManufacturingAnalyticalDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _QualityCertificateDocument
    extends GeniusErpCertificateDocument {
  _QualityCertificateDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S18-T01 — Bill of Materials.
class GeniusBillOfMaterialsDocument
    extends _ManufacturingRegisterDocument {
  GeniusBillOfMaterialsDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T02 — Production Order.
class GeniusProductionOrderDocument
    extends _ManufacturingOperationalDocument {
  GeniusProductionOrderDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T03 — Work Order.
class GeniusWorkOrderDocument
    extends _ManufacturingOperationalDocument {
  GeniusWorkOrderDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T04 — Job Card.
class GeniusJobCardDocument
    extends _ManufacturingOperationalDocument {
  GeniusJobCardDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T05 — Material Requirement.
class GeniusMaterialRequirementDocument
    extends _ManufacturingOperationalDocument {
  GeniusMaterialRequirementDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T06 — Material Issue.
class GeniusMaterialIssueDocument
    extends _ManufacturingOperationalDocument {
  GeniusMaterialIssueDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T07 — Material Return.
class GeniusMaterialReturnDocument
    extends _ManufacturingOperationalDocument {
  GeniusMaterialReturnDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T08 — Production Receipt.
class GeniusProductionReceiptDocument
    extends _ManufacturingOperationalDocument {
  GeniusProductionReceiptDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T09 — Routing/Traveler.
class GeniusRoutingTravelerDocument
    extends _ManufacturingOperationalDocument {
  GeniusRoutingTravelerDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T10 — Machine Operation Report.
class GeniusMachineOperationReportDocument
    extends _ManufacturingRegisterDocument {
  GeniusMachineOperationReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T11 — Labor Report.
class GeniusLaborReportDocument
    extends _ManufacturingRegisterDocument {
  GeniusLaborReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T12 — Scrap Report.
class GeniusScrapReportDocument
    extends _ManufacturingRegisterDocument {
  GeniusScrapReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T13 — Work in Progress.
class GeniusWorkInProgressDocument
    extends _ManufacturingRegisterDocument {
  GeniusWorkInProgressDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T14 — Production Variance.
class GeniusProductionVarianceDocument
    extends _ManufacturingAnalyticalDocument {
  GeniusProductionVarianceDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T15 — Quality Inspection.
class GeniusQualityInspectionDocument
    extends _ManufacturingOperationalDocument {
  GeniusQualityInspectionDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T16 — Incoming Inspection.
class GeniusIncomingInspectionDocument
    extends _ManufacturingOperationalDocument {
  GeniusIncomingInspectionDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T17 — In-process Inspection.
class GeniusInProcessInspectionDocument
    extends _ManufacturingOperationalDocument {
  GeniusInProcessInspectionDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T18 — Final Inspection.
class GeniusFinalInspectionDocument
    extends _ManufacturingOperationalDocument {
  GeniusFinalInspectionDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T19 — NCR.
class GeniusNonConformanceReportDocument
    extends _ManufacturingOperationalDocument {
  GeniusNonConformanceReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T20 — CAPA.
class GeniusCorrectivePreventiveActionDocument
    extends _ManufacturingOperationalDocument {
  GeniusCorrectivePreventiveActionDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T21 — Certificate of Analysis.
class GeniusCertificateOfAnalysisDocument
    extends _QualityCertificateDocument {
  GeniusCertificateOfAnalysisDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T22 — Quality Checklist.
class GeniusQualityChecklistDocument
    extends _ManufacturingOperationalDocument {
  GeniusQualityChecklistDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T23 — Audit Form.
class GeniusQualityAuditFormDocument
    extends _ManufacturingOperationalDocument {
  GeniusQualityAuditFormDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T24 — Calibration Record.
class GeniusCalibrationRecordDocument
    extends _ManufacturingOperationalDocument {
  GeniusCalibrationRecordDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S18-T25 — nested operation/material table verification document.
class GeniusManufacturingNestedTableDocument
    extends GeniusErpOperationalForm {
  GeniusManufacturingNestedTableDocument(
    GeniusPdfConfig config, {
    required this.data,
  }) : super(config);

  final GeniusManufacturingNestedTableData data;

  @override
  void build() => renderManufacturingNestedTable(data);
}
