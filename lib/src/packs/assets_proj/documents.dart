
import '../../families/erp/erp_families.dart';
import '../../printing/profiles/print_profiles.dart';
import '../shared/erp_pack_shared.dart';
import 'asset_models.dart';
import 'service.dart';

abstract class _S19RegisterDocument extends GeniusErpRegisterDocument {
  _S19RegisterDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _S19OperationalDocument
    extends GeniusErpOperationalForm {
  _S19OperationalDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _S19AnalyticalDocument
    extends GeniusErpAnalyticalReport {
  _S19AnalyticalDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _S19CertificateDocument
    extends GeniusErpCertificateDocument {
  _S19CertificateDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S19-T01 — Asset Card.
class GeniusAssetCardDocument extends _S19RegisterDocument {
  GeniusAssetCardDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T02 — Asset Register.
class GeniusAssetRegisterDocument extends _S19RegisterDocument {
  GeniusAssetRegisterDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T03/T25 — Asset Label through the S11 label/profile engine.
class GeniusAssetLabelDocument extends GeniusPdfLabelPrintDocument {
  GeniusAssetLabelDocument({
    required super.config,
    required super.profile,
    required List<GeniusFixedAsset> assets,
    GeniusAssetsProjectsService service =
        const GeniusAssetsProjectsService(),
  }) : super(labels: [
            for (final asset in assets)
              service.assetLabelData(asset),
          ]);
}

/// S19-T04 — Asset Transfer.
class GeniusAssetTransferDocument extends _S19OperationalDocument {
  GeniusAssetTransferDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T05 — Asset Assignment.
class GeniusAssetAssignmentDocument extends _S19OperationalDocument {
  GeniusAssetAssignmentDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T06 — Asset Return.
class GeniusAssetReturnDocument extends _S19OperationalDocument {
  GeniusAssetReturnDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T07 — Asset Disposal.
class GeniusAssetDisposalDocument extends _S19OperationalDocument {
  GeniusAssetDisposalDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T08 — Depreciation Report.
class GeniusAssetDepreciationReportDocument
    extends _S19AnalyticalDocument {
  GeniusAssetDepreciationReportDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T09 — Asset Maintenance Report.
class GeniusAssetMaintenanceReportDocument
    extends _S19RegisterDocument {
  GeniusAssetMaintenanceReportDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T10 — Asset Count.
class GeniusAssetCountDocument extends _S19OperationalDocument {
  GeniusAssetCountDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T11 — Asset Movement Report.
class GeniusAssetMovementReportDocument
    extends _S19RegisterDocument {
  GeniusAssetMovementReportDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T12 — Project Summary.
class GeniusProjectSummaryDocument extends _S19RegisterDocument {
  GeniusProjectSummaryDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T13 — Project Budget.
class GeniusProjectBudgetDocument extends _S19AnalyticalDocument {
  GeniusProjectBudgetDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T14 — Project Cost.
class GeniusProjectCostDocument extends _S19AnalyticalDocument {
  GeniusProjectCostDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T15 — Project Profitability.
class GeniusProjectProfitabilityDocument
    extends _S19AnalyticalDocument {
  GeniusProjectProfitabilityDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T16 — Project Timesheet.
class GeniusProjectTimesheetDocument extends _S19RegisterDocument {
  GeniusProjectTimesheetDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T17 — Project Expense Report.
class GeniusProjectExpenseReportDocument
    extends _S19RegisterDocument {
  GeniusProjectExpenseReportDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T18 — Milestone Report.
class GeniusProjectMilestoneReportDocument
    extends _S19RegisterDocument {
  GeniusProjectMilestoneReportDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T19 — Progress Report.
class GeniusProjectProgressReportDocument
    extends _S19RegisterDocument {
  GeniusProjectProgressReportDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T20 — Completion Certificate.
class GeniusProjectCompletionCertificateDocument
    extends _S19CertificateDocument {
  GeniusProjectCompletionCertificateDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T21 — Project Billing.
class GeniusProjectBillingDocument extends _S19RegisterDocument {
  GeniusProjectBillingDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T22 — Resource Utilization.
class GeniusProjectResourceUtilizationDocument
    extends _S19AnalyticalDocument {
  GeniusProjectResourceUtilizationDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T23 — Project Purchasing Report.
class GeniusProjectPurchasingReportDocument
    extends _S19RegisterDocument {
  GeniusProjectPurchasingReportDocument(
    super.config, {
    required super.report,
  });
}

/// S19-T27 — explicit multi-period project financial document.
class GeniusProjectMultiPeriodFinancialDocument
    extends _S19AnalyticalDocument {
  GeniusProjectMultiPeriodFinancialDocument(
    super.config, {
    required super.report,
  });
}
