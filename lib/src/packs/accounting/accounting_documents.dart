
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';

abstract class _AccountingRegisterDocument
    extends GeniusErpRegisterDocument {
  _AccountingRegisterDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _AccountingStatementDocument
    extends GeniusErpStatementDocument {
  _AccountingStatementDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _AccountingAnalyticalDocument
    extends GeniusErpAnalyticalReport {
  _AccountingAnalyticalDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S14-T01.
class GeniusGeneralLedgerDocument
    extends _AccountingRegisterDocument {
  GeniusGeneralLedgerDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T02.
class GeniusJournalEntryDocument
    extends _AccountingRegisterDocument {
  GeniusJournalEntryDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T03.
class GeniusJournalRegisterDocument
    extends _AccountingRegisterDocument {
  GeniusJournalRegisterDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T04.
class GeniusAccountStatementDocument
    extends _AccountingStatementDocument {
  GeniusAccountStatementDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T05.
class GeniusArAgingDocument extends _AccountingStatementDocument {
  GeniusArAgingDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T06.
class GeniusApAgingDocument extends _AccountingStatementDocument {
  GeniusApAgingDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T07.
class GeniusCustomerBalancesDocument
    extends _AccountingStatementDocument {
  GeniusCustomerBalancesDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T08.
class GeniusSupplierBalancesDocument
    extends _AccountingStatementDocument {
  GeniusSupplierBalancesDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T09.
class GeniusCashBookDocument extends _AccountingRegisterDocument {
  GeniusCashBookDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T10.
class GeniusBankBookDocument extends _AccountingRegisterDocument {
  GeniusBankBookDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T11.
class GeniusBankReconciliationDocument
    extends _AccountingStatementDocument {
  GeniusBankReconciliationDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T12.
class GeniusPettyCashDocument extends _AccountingRegisterDocument {
  GeniusPettyCashDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T13.
class GeniusPaymentRegisterDocument
    extends _AccountingRegisterDocument {
  GeniusPaymentRegisterDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T14.
class GeniusReceiptRegisterDocument
    extends _AccountingRegisterDocument {
  GeniusReceiptRegisterDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T15.
class GeniusVatTaxSummaryDocument
    extends _AccountingAnalyticalDocument {
  GeniusVatTaxSummaryDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T16.
class GeniusTaxRegisterDocument
    extends _AccountingRegisterDocument {
  GeniusTaxRegisterDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T17.
class GeniusTaxBreakdownDocument
    extends _AccountingAnalyticalDocument {
  GeniusTaxBreakdownDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T18.
class GeniusRoundingReconciliationDocument
    extends _AccountingAnalyticalDocument {
  GeniusRoundingReconciliationDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T19.
class GeniusCostCenterStatementDocument
    extends _AccountingStatementDocument {
  GeniusCostCenterStatementDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T20.
class GeniusCostCenterTrialBalanceDocument
    extends _AccountingAnalyticalDocument {
  GeniusCostCenterTrialBalanceDocument(
    super.config, {
    required super.report,
  });
}

/// S14-T21.
class GeniusProjectFinancialReport
    extends _AccountingAnalyticalDocument {
  GeniusProjectFinancialReport(
    super.config, {
    required super.report,
  });
}

/// S14-T22.
class GeniusBudgetVsActualReport
    extends _AccountingAnalyticalDocument {
  GeniusBudgetVsActualReport(
    super.config, {
    required super.report,
  });
}

/// S14-T23.
class GeniusMultiPeriodComparisonReport
    extends _AccountingAnalyticalDocument {
  GeniusMultiPeriodComparisonReport(
    super.config, {
    required super.report,
  });
}
