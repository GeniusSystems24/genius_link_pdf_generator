
import '../../components/components.dart';
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';
import 'crm_models.dart';

abstract class GeniusCrmDocumentBase extends GeniusErpRegisterDocument {
  GeniusCrmDocumentBase(
    super.config, {
    required this.report,
    this.confidentiality = GeniusCrmConfidentiality.none,
  });

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
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusLeadReportDocument extends GeniusCrmDocumentBase {
  GeniusLeadReportDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusOpportunityReportDocument extends GeniusCrmDocumentBase {
  GeniusOpportunityReportDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusPipelineReportDocument extends GeniusCrmDocumentBase {
  GeniusPipelineReportDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusActivityReportDocument extends GeniusCrmDocumentBase {
  GeniusActivityReportDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusVisitReportDocument extends GeniusCrmDocumentBase {
  GeniusVisitReportDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusCallReportDocument extends GeniusCrmDocumentBase {
  GeniusCallReportDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusCustomerHistoryDocument extends GeniusCrmDocumentBase {
  GeniusCustomerHistoryDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusProposalDocument extends GeniusCrmDocumentBase {
  GeniusProposalDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusContractSummaryDocument extends GeniusCrmDocumentBase {
  GeniusContractSummaryDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}

class GeniusCrmPresentationOverviewDocument extends GeniusCrmDocumentBase {
  GeniusCrmPresentationOverviewDocument(
    super.config, {
    required super.report,
    super.confidentiality,
  });
}
