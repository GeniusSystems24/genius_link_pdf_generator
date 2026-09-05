
import '../../components/components.dart';
import '../../core/pdf_config.dart';
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';
import 'crm_models.dart';

abstract class GeniusCrmDocumentBase extends GeniusErpRegisterDocument {
  GeniusCrmDocumentBase(
    GeniusPdfConfig config, {
    required this.report,
    this.confidentiality = GeniusCrmConfidentiality.none,
  }) : super(config);

  final GeniusErpPackReportData report;
  final GeniusCrmConfidentiality confidentiality;

  /// Applies the shared watermark component to the underlying PDF.
  void addWatermark(GeniusPdfWatermark watermark) {
    watermark.applyToDocument(document);
  }

  @override
  void build() {
    renderErpPackReport(report);
    switch (confidentiality) {
      case GeniusCrmConfidentiality.none:
        break;
      case GeniusCrmConfidentiality.draft:
        addWatermark(
          GeniusPdfWatermark.draft(
            config: config,
            text: config.isRTL ? 'مسودة' : 'DRAFT',
          ),
        );
        break;
      case GeniusCrmConfidentiality.confidential:
        addWatermark(
          GeniusPdfWatermark.confidential(
            config: config,
            text: config.isRTL ? 'سري' : 'CONFIDENTIAL',
          ),
        );
        break;
    }
  }
}

class GeniusCustomerProfileDocument extends GeniusCrmDocumentBase {
  GeniusCustomerProfileDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusLeadReportDocument extends GeniusCrmDocumentBase {
  GeniusLeadReportDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusOpportunityReportDocument extends GeniusCrmDocumentBase {
  GeniusOpportunityReportDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusPipelineReportDocument extends GeniusCrmDocumentBase {
  GeniusPipelineReportDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusActivityReportDocument extends GeniusCrmDocumentBase {
  GeniusActivityReportDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusVisitReportDocument extends GeniusCrmDocumentBase {
  GeniusVisitReportDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusCallReportDocument extends GeniusCrmDocumentBase {
  GeniusCallReportDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusCustomerHistoryDocument extends GeniusCrmDocumentBase {
  GeniusCustomerHistoryDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusProposalDocument extends GeniusCrmDocumentBase {
  GeniusProposalDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusContractSummaryDocument extends GeniusCrmDocumentBase {
  GeniusContractSummaryDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}

class GeniusCrmPresentationOverviewDocument extends GeniusCrmDocumentBase {
  GeniusCrmPresentationOverviewDocument(
    GeniusPdfConfig config, {
    required super.report,
    super.confidentiality,
  }) : super(config);
}
