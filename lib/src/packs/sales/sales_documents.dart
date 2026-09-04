
import '../../core/pdf_config.dart';
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';

/// Shared S12 transaction-family base.
///
/// Existing S09 Quotation/TaxInvoice are migrated to this superclass, so old
/// and new Sales documents share the same family path.
class GeniusSalesTransactionDocument extends GeniusErpTransactionDocument {
  GeniusSalesTransactionDocument(
    super.config, {
    this.request,
    this.documentTitle = 'Sales Transaction',
    this.documentTitleAr = 'معاملة مبيعات',
    this.primaryPartyTitle = 'Customer',
    this.primaryPartyTitleAr = 'العميل',
    super.plan,
    super.printProfile,
  });

  final GeniusErpPackTransactionRequest? request;
  final String documentTitle;
  final String documentTitleAr;
  final String primaryPartyTitle;
  final String primaryPartyTitleAr;

  @override
  GeniusErpFamilyPlan createFamilyPlan() {
    final value = request;
    if (value == null) {
      return super.createFamilyPlan();
    }
    return value.toFamilyPlan(
      title: documentTitle,
      titleAr: documentTitleAr,
      primaryPartyTitle: primaryPartyTitle,
      primaryPartyTitleAr: primaryPartyTitleAr,
    );
  }
}

/// S12-T01 — Sales Order.
class GeniusSalesOrderDocument extends GeniusSalesTransactionDocument {
  GeniusSalesOrderDocument(
    super.config, {
    required GeniusErpPackTransactionRequest super.request,
    super.printProfile,
  }) : super(
          documentTitle: 'Sales Order',
          documentTitleAr: 'أمر مبيعات',
        );
}

/// S12-T02 — Proforma Invoice.
class GeniusProformaInvoiceDocument extends GeniusSalesTransactionDocument {
  GeniusProformaInvoiceDocument(
    super.config, {
    required GeniusErpPackTransactionRequest super.request,
    super.printProfile,
  }) : super(
          documentTitle: 'Proforma Invoice',
          documentTitleAr: 'فاتورة مبدئية',
        );
}

/// S12-T03 — Simplified/POS Invoice.
///
/// Supply an S11 profile through `profile.toFamilyProfile()` when printing on
/// a thermal/compact medium.
class GeniusPosInvoiceDocument extends GeniusSalesTransactionDocument {
  GeniusPosInvoiceDocument(
    super.config, {
    required GeniusErpPackTransactionRequest super.request,
    super.printProfile,
  }) : super(
          documentTitle: 'Simplified / POS Invoice',
          documentTitleAr: 'فاتورة مبسطة / نقاط البيع',
        );
}

/// S12-T04 — Debit Note.
class GeniusSalesDebitNoteDocument extends GeniusSalesTransactionDocument {
  GeniusSalesDebitNoteDocument(
    super.config, {
    required GeniusErpPackTransactionRequest super.request,
    super.printProfile,
  }) : super(
          documentTitle: 'Debit Note',
          documentTitleAr: 'إشعار مدين',
        );
}

/// S12-T05 — Sales Return.
///
/// Negative quantity/value paths are enabled before S06 calculation.
class GeniusSalesReturnDocument extends GeniusSalesTransactionDocument {
  GeniusSalesReturnDocument(
    super.config, {
    required GeniusErpPackTransactionRequest request,
    super.printProfile,
  }) : super(
          request: request.copyWith(allowNegativeValues: true),
          documentTitle: 'Sales Return',
          documentTitleAr: 'مرتجع مبيعات',
        );
}

/// S12-T06 — Customer Receipt.
class GeniusCustomerReceiptDocument extends GeniusSalesTransactionDocument {
  GeniusCustomerReceiptDocument(
    super.config, {
    required GeniusErpPackTransactionRequest super.request,
    super.printProfile,
  }) : super(
          documentTitle: 'Customer Receipt',
          documentTitleAr: 'سند قبض عميل',
        );
}

abstract class _SalesOperationalReport
    extends GeniusErpOperationalForm {
  _SalesOperationalReport(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _SalesRegisterReport
    extends GeniusErpRegisterDocument {
  _SalesRegisterReport(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _SalesStatementReport
    extends GeniusErpStatementDocument {
  _SalesStatementReport(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _SalesAnalyticalReport
    extends GeniusErpAnalyticalReport {
  _SalesAnalyticalReport(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S12-T07 — Picking List.
class GeniusPickingListDocument extends _SalesOperationalReport {
  GeniusPickingListDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Picking List',
            titleAr: 'قائمة التجهيز',
          ),
        );
}

/// S12-T08 — Packing List.
class GeniusPackingListDocument extends _SalesOperationalReport {
  GeniusPackingListDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Packing List',
            titleAr: 'قائمة التعبئة',
          ),
        );
}

/// S12-T09 — Backorder document/report.
class GeniusBackorderDocument extends _SalesRegisterReport {
  GeniusBackorderDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Backorders',
            titleAr: 'الطلبات المتأخرة',
          ),
        );
}

/// S12-T10 — Customer Aging.
class GeniusCustomerAgingDocument extends _SalesStatementReport {
  GeniusCustomerAgingDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Customer Aging',
            titleAr: 'أعمار ديون العملاء',
          ),
        );
}

/// S12-T11 — Sales Register.
class GeniusSalesRegisterDocument extends _SalesRegisterReport {
  GeniusSalesRegisterDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Sales Register',
            titleAr: 'سجل المبيعات',
          ),
        );
}

/// S12-T12 — Sales by Customer.
class GeniusSalesByCustomerReport extends _SalesAnalyticalReport {
  GeniusSalesByCustomerReport(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Sales by Customer',
            titleAr: 'المبيعات حسب العميل',
          ),
        );
}

/// S12-T13 — Sales by Item.
class GeniusSalesByItemReport extends _SalesAnalyticalReport {
  GeniusSalesByItemReport(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Sales by Item',
            titleAr: 'المبيعات حسب الصنف',
          ),
        );
}

/// S12-T14 — Sales by Salesperson.
class GeniusSalesBySalespersonReport extends _SalesAnalyticalReport {
  GeniusSalesBySalespersonReport(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Sales by Salesperson',
            titleAr: 'المبيعات حسب مندوب المبيعات',
          ),
        );
}

/// S12-T15 — Price List.
class GeniusPriceListDocument extends _SalesRegisterReport {
  GeniusPriceListDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Price List',
            titleAr: 'قائمة الأسعار',
          ),
        );
}

/// S12-T16 — Commission Report.
class GeniusCommissionReport extends _SalesAnalyticalReport {
  GeniusCommissionReport(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Commission Report',
            titleAr: 'تقرير العمولات',
          ),
        );
}
