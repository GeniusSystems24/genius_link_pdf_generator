
import '../../domain/erp/erp.dart';
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';
import 'models.dart';

/// Hook for S13 landed charges.
///
/// The hook returns S06 `ErpCharge` values before family planning; no landed
/// charge arithmetic lives in PDF rendering code.
typedef GeniusPurchasingLandedChargesHook =
    List<ErpCharge> Function(
      GeniusErpPackTransactionRequest request,
    );

/// Shared S13 transaction-family base.
///
/// The existing S09 `PurchaseOrderTemplate` is migrated to this superclass.
class GeniusPurchasingTransactionDocument
    extends GeniusErpTransactionDocument {
  GeniusPurchasingTransactionDocument(
    super.config, {
    this.request,
    this.documentTitle = 'Purchasing Transaction',
    this.documentTitleAr = 'معاملة مشتريات',
    this.primaryPartyTitle = 'Supplier',
    this.primaryPartyTitleAr = 'المورد',
    this.landedChargesHook,
    super.plan,
    super.printProfile,
  });

  final GeniusErpPackTransactionRequest? request;
  final String documentTitle;
  final String documentTitleAr;
  final String primaryPartyTitle;
  final String primaryPartyTitleAr;
  final GeniusPurchasingLandedChargesHook? landedChargesHook;

  @override
  GeniusErpFamilyPlan createFamilyPlan() {
    final value = request;
    if (value == null) {
      return super.createFamilyPlan();
    }

    final landed = landedChargesHook?.call(value) ?? const <ErpCharge>[];

    return value.toFamilyPlan(
      title: documentTitle,
      titleAr: documentTitleAr,
      primaryPartyTitle: primaryPartyTitle,
      primaryPartyTitleAr: primaryPartyTitleAr,
      additionalCharges: landed,
    );
  }
}

/// S13-T01 — Purchase Requisition.
class GeniusPurchaseRequisitionDocument
    extends GeniusPurchasingTransactionDocument {
  GeniusPurchaseRequisitionDocument(
    super.config, {
    required GeniusErpPackTransactionRequest super.request,
    super.printProfile,
  }) : super(
          documentTitle: 'Purchase Requisition',
          documentTitleAr: 'طلب شراء',
        );
}

/// S13-T02 — Request for Quotation.
class GeniusRequestForQuotationDocument
    extends GeniusPurchasingTransactionDocument {
  GeniusRequestForQuotationDocument(
    super.config, {
    required GeniusErpPackTransactionRequest request,
    super.printProfile,
  }) : super(
          request: request.copyWith(showSummary: false),
          documentTitle: 'Request for Quotation',
          documentTitleAr: 'طلب عرض سعر',
        );
}

/// S13-T03 — Supplier Quotation.
class GeniusSupplierQuotationDocument
    extends GeniusPurchasingTransactionDocument {
  GeniusSupplierQuotationDocument(
    super.config, {
    required GeniusErpPackTransactionRequest super.request,
    super.printProfile,
  }) : super(
          documentTitle: 'Supplier Quotation',
          documentTitleAr: 'عرض سعر مورد',
        );
}

/// S13-T05 — Purchase Order.
class GeniusPurchaseOrderDocument
    extends GeniusPurchasingTransactionDocument {
  GeniusPurchaseOrderDocument(
    super.config, {
    required GeniusErpPackTransactionRequest super.request,
    super.landedChargesHook,
    super.printProfile,
  }) : super(
          documentTitle: 'Purchase Order',
          documentTitleAr: 'أمر شراء',
        );
}

/// S13-T07 — Purchase Invoice.
class GeniusPurchaseInvoiceDocument
    extends GeniusPurchasingTransactionDocument {
  GeniusPurchaseInvoiceDocument(
    super.config, {
    required GeniusErpPackTransactionRequest super.request,
    super.landedChargesHook,
    super.printProfile,
  }) : super(
          documentTitle: 'Purchase Invoice',
          documentTitleAr: 'فاتورة مشتريات',
        );
}

/// S13-T08 — Purchase Debit/Credit Note.
class GeniusPurchaseAdjustmentDocument
    extends GeniusPurchasingTransactionDocument {
  GeniusPurchaseAdjustmentDocument(
    super.config, {
    required GeniusErpPackTransactionRequest request,
    required this.kind,
    super.printProfile,
  }) : super(
          request: kind == GeniusPurchaseAdjustmentKind.credit
              ? request.copyWith(allowNegativeValues: true)
              : request,
          documentTitle: kind == GeniusPurchaseAdjustmentKind.debit
              ? 'Purchase Debit Note'
              : 'Purchase Credit Note',
          documentTitleAr: kind == GeniusPurchaseAdjustmentKind.debit
              ? 'إشعار مدين مشتريات'
              : 'إشعار دائن مشتريات',
        );

  final GeniusPurchaseAdjustmentKind kind;
}

/// S13-T09 — Supplier Return.
class GeniusSupplierReturnDocument
    extends GeniusPurchasingTransactionDocument {
  GeniusSupplierReturnDocument(
    super.config, {
    required GeniusErpPackTransactionRequest request,
    super.printProfile,
  }) : super(
          request: request.copyWith(allowNegativeValues: true),
          documentTitle: 'Supplier Return',
          documentTitleAr: 'مرتجع مورد',
        );
}

abstract class _PurchasingOperationalReport
    extends GeniusErpOperationalForm {
  _PurchasingOperationalReport(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _PurchasingRegisterReport
    extends GeniusErpRegisterDocument {
  _PurchasingRegisterReport(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _PurchasingStatementReport
    extends GeniusErpStatementDocument {
  _PurchasingStatementReport(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _PurchasingAnalyticalReport
    extends GeniusErpAnalyticalReport {
  _PurchasingAnalyticalReport(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S13-T04 — Quotation Comparison.
class GeniusQuotationComparisonDocument
    extends _PurchasingAnalyticalReport {
  GeniusQuotationComparisonDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Quotation Comparison',
            titleAr: 'مقارنة عروض الأسعار',
          ),
        );
}

/// S13-T06 — Goods Receipt Note.
class GeniusGoodsReceiptNoteDocument
    extends _PurchasingOperationalReport {
  GeniusGoodsReceiptNoteDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Goods Receipt Note',
            titleAr: 'إشعار استلام بضاعة',
          ),
        );
}

/// S13-T10 — Supplier Statement.
class GeniusSupplierStatementDocument
    extends _PurchasingStatementReport {
  GeniusSupplierStatementDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Supplier Statement',
            titleAr: 'كشف حساب المورد',
          ),
        );
}

/// S13-T11 — Supplier Aging.
class GeniusSupplierAgingDocument
    extends _PurchasingStatementReport {
  GeniusSupplierAgingDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Supplier Aging',
            titleAr: 'أعمار ديون الموردين',
          ),
        );
}

/// S13-T12 — Purchase Register.
class GeniusPurchaseRegisterDocument
    extends _PurchasingRegisterReport {
  GeniusPurchaseRegisterDocument(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Purchase Register',
            titleAr: 'سجل المشتريات',
          ),
        );
}

/// S13-T13 — Purchase Analysis.
class GeniusPurchaseAnalysisReport
    extends _PurchasingAnalyticalReport {
  GeniusPurchaseAnalysisReport(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Purchase Analysis',
            titleAr: 'تحليل المشتريات',
          ),
        );
}

/// S13-T14 — Outstanding Purchase Orders.
class GeniusOutstandingPurchaseOrdersReport
    extends _PurchasingRegisterReport {
  GeniusOutstandingPurchaseOrdersReport(
    super.config, {
    required GeniusErpPackReportData report,
  }) : super(
          report: report.withTitle(
            'Outstanding Purchase Orders',
            titleAr: 'أوامر الشراء المعلقة',
          ),
        );
}
