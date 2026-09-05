
import '../../families/erp/erp_families.dart';
import '../../printing/profiles/print_profiles.dart';
import '../shared/erp_pack_shared.dart';
import 'models.dart';
import 'service.dart';

/// S16-T01 — 58mm receipt.
class GeniusPosReceipt58Document
    extends GeniusPdfThermalReceiptEngine {
  GeniusPosReceipt58Document({
    required super.config,
    required GeniusPosReceiptRequest request,
  }) : super(profile: const GeniusPosService().profile58(), data: const GeniusPosService().thermalData(request));
}

/// S16-T02 — 80mm receipt.
class GeniusPosReceipt80Document
    extends GeniusPdfThermalReceiptEngine {
  GeniusPosReceipt80Document({
    required super.config,
    required GeniusPosReceiptRequest request,
  }) : super(profile: const GeniusPosService().profile80(), data: const GeniusPosService().thermalData(request));
}

/// S16-T03 — Refund Receipt.
class GeniusRefundReceiptDocument
    extends GeniusPdfThermalReceiptEngine {
  GeniusRefundReceiptDocument({
    required super.config,
    required GeniusPosReceiptRequest request,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? const GeniusPosService().profile80(), data: const GeniusPosService().thermalData(
            GeniusPosReceiptRequest(
              merchantName: request.merchantName,
              merchantNameAr: request.merchantNameAr,
              receiptNumber: request.receiptNumber,
              date: request.date,
              kind: GeniusPosReceiptKind.refund,
              lines: request.lines,
              currency: request.currency,
              documentDiscount: request.documentDiscount,
              payments: request.payments,
              taxSummary: request.taxSummary,
              cashReceived: request.cashReceived,
              change: request.change,
              qrData: request.qrData,
              barcodeData: request.barcodeData,
              copyLabel: request.copyLabel,
              copyLabelAr: request.copyLabelAr,
              reprint: request.reprint,
              footer: request.footer,
              footerAr: request.footerAr,
            ),
          ));
}

/// S16-T04 — Exchange Receipt.
class GeniusExchangeReceiptDocument
    extends GeniusPdfThermalReceiptEngine {
  GeniusExchangeReceiptDocument({
    required super.config,
    required GeniusPosReceiptRequest request,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? const GeniusPosService().profile80(), data: const GeniusPosService().thermalData(
            GeniusPosReceiptRequest(
              merchantName: request.merchantName,
              merchantNameAr: request.merchantNameAr,
              receiptNumber: request.receiptNumber,
              date: request.date,
              kind: GeniusPosReceiptKind.exchange,
              lines: request.lines,
              currency: request.currency,
              documentDiscount: request.documentDiscount,
              payments: request.payments,
              taxSummary: request.taxSummary,
              cashReceived: request.cashReceived,
              change: request.change,
              qrData: request.qrData,
              barcodeData: request.barcodeData,
              copyLabel: request.copyLabel,
              copyLabelAr: request.copyLabelAr,
              reprint: request.reprint,
              footer: request.footer,
              footerAr: request.footerAr,
            ),
          ));
}

/// S16-T05 — Gift Receipt.
///
/// Gift receipts intentionally suppress monetary values in the adapted thermal
/// payload while keeping item identities and QR/barcode references.
class GeniusGiftReceiptDocument
    extends GeniusPdfThermalReceiptEngine {
  GeniusGiftReceiptDocument({
    required super.config,
    required GeniusPosReceiptRequest request,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? const GeniusPosService().profile80(), data: const GeniusPosService().thermalData(
            GeniusPosReceiptRequest(
              merchantName: request.merchantName,
              merchantNameAr: request.merchantNameAr,
              receiptNumber: request.receiptNumber,
              date: request.date,
              kind: GeniusPosReceiptKind.gift,
              lines: request.lines,
              currency: request.currency,
              qrData: request.qrData,
              barcodeData: request.barcodeData,
              copyLabel: request.copyLabel,
              copyLabelAr: request.copyLabelAr,
              reprint: request.reprint,
              footer: request.footer,
              footerAr: request.footerAr,
            ),
          ));
}

/// S16-T06 — optional Kitchen Order Ticket.
///
/// It uses the same thermal engine with zero-priced ticket lines so there is
/// no independent page-flow/thermal renderer.
class GeniusKitchenOrderTicketDocument
    extends GeniusPdfThermalReceiptEngine {
  GeniusKitchenOrderTicketDocument({
    required super.config,
    required GeniusPosReceiptRequest request,
    GeniusPdfPrintProfile? profile,
  }) : super(profile: profile ?? const GeniusPosService().profile80(), data: const GeniusPosService().thermalData(
            GeniusPosReceiptRequest(
              merchantName: request.merchantName,
              merchantNameAr: request.merchantNameAr,
              receiptNumber: request.receiptNumber,
              date: request.date,
              kind: GeniusPosReceiptKind.gift,
              title: 'Kitchen Order Ticket',
              titleAr: 'تذكرة طلب المطبخ',
              lines: request.lines,
              currency: request.currency,
              footer: 'KITCHEN ORDER TICKET',
              footerAr: 'تذكرة طلب المطبخ',
            ),
          ));
}

abstract class _PosRegisterDocument extends GeniusErpRegisterDocument {
  _PosRegisterDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

abstract class _PosAnalyticalDocument
    extends GeniusErpAnalyticalReport {
  _PosAnalyticalDocument(
    super.config, {
    required this.report,
  });

  final GeniusErpPackReportData report;

  @override
  void build() => renderErpPackReport(report);
}

/// S16-T07.
class GeniusShiftOpenReport extends _PosRegisterDocument {
  GeniusShiftOpenReport(
    super.config, {
    required super.report,
  });
}

/// S16-T08.
class GeniusShiftCloseReport extends _PosRegisterDocument {
  GeniusShiftCloseReport(
    super.config, {
    required super.report,
  });
}

/// S16-T09.
class GeniusXReport extends _PosAnalyticalDocument {
  GeniusXReport(
    super.config, {
    required super.report,
  });
}

/// S16-T10.
class GeniusZReport extends _PosAnalyticalDocument {
  GeniusZReport(
    super.config, {
    required super.report,
  });
}

/// S16-T11.
class GeniusCashDrawerReport extends _PosRegisterDocument {
  GeniusCashDrawerReport(
    super.config, {
    required super.report,
  });
}

/// S16-T12.
class GeniusPaymentMethodSummaryReport
    extends _PosAnalyticalDocument {
  GeniusPaymentMethodSummaryReport(
    super.config, {
    required super.report,
  });
}
