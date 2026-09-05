
import '../../core/pdf_config.dart';
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';

abstract class _AccountingRegisterDocument
    extends GeniusErpRegisterDocument {
  _AccountingRegisterDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _AccountingStatementDocument
    extends GeniusErpStatementDocument {
  _AccountingStatementDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _AccountingAnalyticalDocument
    extends GeniusErpAnalyticalReport {
  _AccountingAnalyticalDocument(
    GeniusPdfConfig config, {
    required this.report,
  }) : super(config);

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S14-T01.
class GeniusGeneralLedgerDocument
    extends _AccountingRegisterDocument {
  GeniusGeneralLedgerDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T02.
class GeniusJournalEntryDocument
    extends _AccountingRegisterDocument {
  GeniusJournalEntryDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T03.
class GeniusJournalRegisterDocument
    extends _AccountingRegisterDocument {
  GeniusJournalRegisterDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T04.
class GeniusAccountStatementDocument
    extends _AccountingStatementDocument {
  GeniusAccountStatementDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T05.
class GeniusArAgingDocument extends _AccountingStatementDocument {
  GeniusArAgingDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T06.
class GeniusApAgingDocument extends _AccountingStatementDocument {
  GeniusApAgingDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T07.
class GeniusCustomerBalancesDocument
    extends _AccountingStatementDocument {
  GeniusCustomerBalancesDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T08.
class GeniusSupplierBalancesDocument
    extends _AccountingStatementDocument {
  GeniusSupplierBalancesDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T09.
class GeniusCashBookDocument extends _AccountingRegisterDocument {
  GeniusCashBookDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T10.
class GeniusBankBookDocument extends _AccountingRegisterDocument {
  GeniusBankBookDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T11.
class GeniusBankReconciliationDocument
    extends _AccountingStatementDocument {
  GeniusBankReconciliationDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T12.
class GeniusPettyCashDocument extends _AccountingRegisterDocument {
  GeniusPettyCashDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T13.
class GeniusPaymentRegisterDocument
    extends _AccountingRegisterDocument {
  GeniusPaymentRegisterDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T14.
class GeniusReceiptRegisterDocument
    extends _AccountingRegisterDocument {
  GeniusReceiptRegisterDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T15.
class GeniusVatTaxSummaryDocument
    extends _AccountingAnalyticalDocument {
  GeniusVatTaxSummaryDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T16.
class GeniusTaxRegisterDocument
    extends _AccountingRegisterDocument {
  GeniusTaxRegisterDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T17.
class GeniusTaxBreakdownDocument
    extends _AccountingAnalyticalDocument {
  GeniusTaxBreakdownDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T18.
class GeniusRoundingReconciliationDocument
    extends _AccountingAnalyticalDocument {
  GeniusRoundingReconciliationDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T19.
class GeniusCostCenterStatementDocument
    extends _AccountingStatementDocument {
  GeniusCostCenterStatementDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T20.
class GeniusCostCenterTrialBalanceDocument
    extends _AccountingAnalyticalDocument {
  GeniusCostCenterTrialBalanceDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T21.
class GeniusProjectFinancialReport
    extends _AccountingAnalyticalDocument {
  GeniusProjectFinancialReport(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T22.
class GeniusBudgetVsActualReport
    extends _AccountingAnalyticalDocument {
  GeniusBudgetVsActualReport(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}

/// S14-T23.
class GeniusMultiPeriodComparisonReport
    extends _AccountingAnalyticalDocument {
  GeniusMultiPeriodComparisonReport(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
  }) : super(config, report: report);
}
