
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';
import 'models.dart';
import 'rendering.dart';

abstract class _ManufacturingOperationalDocument
    extends GeniusErpOperationalForm {
  _ManufacturingOperationalDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _ManufacturingRegisterDocument
    extends GeniusErpRegisterDocument {
  _ManufacturingRegisterDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _ManufacturingAnalyticalDocument
    extends GeniusErpAnalyticalReport {
  _ManufacturingAnalyticalDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _QualityCertificateDocument
    extends GeniusErpCertificateDocument {
  _QualityCertificateDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S18-T01 — Bill of Materials.
class GeniusBillOfMaterialsDocument
    extends _ManufacturingRegisterDocument {
  GeniusBillOfMaterialsDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T02 — Production Order.
class GeniusProductionOrderDocument
    extends _ManufacturingOperationalDocument {
  GeniusProductionOrderDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T03 — Work Order.
class GeniusWorkOrderDocument
    extends _ManufacturingOperationalDocument {
  GeniusWorkOrderDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T04 — Job Card.
class GeniusJobCardDocument
    extends _ManufacturingOperationalDocument {
  GeniusJobCardDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T05 — Material Requirement.
class GeniusMaterialRequirementDocument
    extends _ManufacturingOperationalDocument {
  GeniusMaterialRequirementDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T06 — Material Issue.
class GeniusMaterialIssueDocument
    extends _ManufacturingOperationalDocument {
  GeniusMaterialIssueDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T07 — Material Return.
class GeniusMaterialReturnDocument
    extends _ManufacturingOperationalDocument {
  GeniusMaterialReturnDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T08 — Production Receipt.
class GeniusProductionReceiptDocument
    extends _ManufacturingOperationalDocument {
  GeniusProductionReceiptDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T09 — Routing/Traveler.
class GeniusRoutingTravelerDocument
    extends _ManufacturingOperationalDocument {
  GeniusRoutingTravelerDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T10 — Machine Operation Report.
class GeniusMachineOperationReportDocument
    extends _ManufacturingRegisterDocument {
  GeniusMachineOperationReportDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T11 — Labor Report.
class GeniusLaborReportDocument
    extends _ManufacturingRegisterDocument {
  GeniusLaborReportDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T12 — Scrap Report.
class GeniusScrapReportDocument
    extends _ManufacturingRegisterDocument {
  GeniusScrapReportDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T13 — Work in Progress.
class GeniusWorkInProgressDocument
    extends _ManufacturingRegisterDocument {
  GeniusWorkInProgressDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T14 — Production Variance.
class GeniusProductionVarianceDocument
    extends _ManufacturingAnalyticalDocument {
  GeniusProductionVarianceDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T15 — Quality Inspection.
class GeniusQualityInspectionDocument
    extends _ManufacturingOperationalDocument {
  GeniusQualityInspectionDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T16 — Incoming Inspection.
class GeniusIncomingInspectionDocument
    extends _ManufacturingOperationalDocument {
  GeniusIncomingInspectionDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T17 — In-process Inspection.
class GeniusInProcessInspectionDocument
    extends _ManufacturingOperationalDocument {
  GeniusInProcessInspectionDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T18 — Final Inspection.
class GeniusFinalInspectionDocument
    extends _ManufacturingOperationalDocument {
  GeniusFinalInspectionDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T19 — NCR.
class GeniusNonConformanceReportDocument
    extends _ManufacturingOperationalDocument {
  GeniusNonConformanceReportDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T20 — CAPA.
class GeniusCorrectivePreventiveActionDocument
    extends _ManufacturingOperationalDocument {
  GeniusCorrectivePreventiveActionDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T21 — Certificate of Analysis.
class GeniusCertificateOfAnalysisDocument
    extends _QualityCertificateDocument {
  GeniusCertificateOfAnalysisDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T22 — Quality Checklist.
class GeniusQualityChecklistDocument
    extends _ManufacturingOperationalDocument {
  GeniusQualityChecklistDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T23 — Audit Form.
class GeniusQualityAuditFormDocument
    extends _ManufacturingOperationalDocument {
  GeniusQualityAuditFormDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T24 — Calibration Record.
class GeniusCalibrationRecordDocument
    extends _ManufacturingOperationalDocument {
  GeniusCalibrationRecordDocument(
    super.config, {
    required super.report,
  });
}

/// S18-T25 — nested operation/material table verification document.
class GeniusManufacturingNestedTableDocument
    extends GeniusErpOperationalForm {
  GeniusManufacturingNestedTableDocument(
    super.config, {
    required this.data,
  });

  final GeniusManufacturingNestedTableData data;

  @override
  void build() => renderManufacturingNestedTable(data);
}
