// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S16PosRetailPackVerificationPage.
enum S16PosRetailPackScenario {
  receipt58,
  receipt80,
  refund,
  exchange,
  gift,
  kot,
  shiftOpen,
  shiftClose,
  xReport,
  zReport,
  cashDrawer,
  paymentSummary,
  barcodeLabel,
  priceLabel,
  promotionLabel,
}

/// Executes one focused S16 verification scenario.
class S16PosRetailPackRunner {
  S16PosRetailPackRunner({
    required GeniusPdfConfig baseConfig,
    required S16PosRetailPackScenario scenario,
  })  : _baseConfig = baseConfig,
        _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S16PosRetailPackScenario _scenario;
bool _rtl = false;
  final bool _reprint = false;
  final int _itemCount = 1;
GeniusPdfConfig get _config => _baseConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String _label(S16PosRetailPackScenario value) => switch (value) {
        S16PosRetailPackScenario.receipt58 => '58mm Receipt',
        S16PosRetailPackScenario.receipt80 => '80mm Receipt',
        S16PosRetailPackScenario.refund => 'Refund Receipt',
        S16PosRetailPackScenario.exchange => 'Exchange Receipt',
        S16PosRetailPackScenario.gift => 'Gift Receipt',
        S16PosRetailPackScenario.kot => 'Kitchen Order Ticket',
        S16PosRetailPackScenario.shiftOpen => 'Shift Open',
        S16PosRetailPackScenario.shiftClose => 'Shift Close',
        S16PosRetailPackScenario.xReport => 'X Report',
        S16PosRetailPackScenario.zReport => 'Z Report',
        S16PosRetailPackScenario.cashDrawer => 'Cash Drawer',
        S16PosRetailPackScenario.paymentSummary => 'Payment Method Summary',
        S16PosRetailPackScenario.barcodeLabel => 'Barcode Label',
        S16PosRetailPackScenario.priceLabel => 'Price Label',
        S16PosRetailPackScenario.promotionLabel => 'Promotion Label',
      };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the S16 public API, '
      '${_rtl ? 'RTL/compact Arabic' : 'LTR'} layout and $_itemCount item(s). '
      'Long names wrap, Arabic notes remain under the item, SKU/QR/barcode '
      'payloads stay LTR, tax/promotion/cash/change/multi-payment remain '
      'visible when applicable, and no content is cut at the thermal end.'
      '${_reprint ? ' Reprint marker must be visible.' : ''}';

  Future<Uint8List> generate() async {
    final config = _config;
    const service = GeniusPosService();
    final receipt = _receipt(_itemCount);
    final shift = _shift();
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case S16PosRetailPackScenario.receipt58:
        document = GeniusPosReceipt58Document(
          config: config,
          request: receipt,
        );
        break;
      case S16PosRetailPackScenario.receipt80:
        document = GeniusPosReceipt80Document(
          config: config,
          request: receipt,
        );
        break;
      case S16PosRetailPackScenario.refund:
        document = GeniusRefundReceiptDocument(
          config: config,
          request: receipt,
        );
        break;
      case S16PosRetailPackScenario.exchange:
        document = GeniusExchangeReceiptDocument(
          config: config,
          request: receipt,
        );
        break;
      case S16PosRetailPackScenario.gift:
        document = GeniusGiftReceiptDocument(
          config: config,
          request: receipt,
        );
        break;
      case S16PosRetailPackScenario.kot:
        document = GeniusKitchenOrderTicketDocument(
          config: config,
          request: receipt,
        );
        break;
      case S16PosRetailPackScenario.shiftOpen:
        document = GeniusShiftOpenReport(
          config,
          report: service.shiftOpen(shift),
        );
        break;
      case S16PosRetailPackScenario.shiftClose:
        document = GeniusShiftCloseReport(
          config,
          report: service.shiftClose(shift),
        );
        break;
      case S16PosRetailPackScenario.xReport:
        document = GeniusXReport(
          config,
          report: service.xReport(shift),
        );
        break;
      case S16PosRetailPackScenario.zReport:
        document = GeniusZReport(
          config,
          report: service.zReport(shift),
        );
        break;
      case S16PosRetailPackScenario.cashDrawer:
        document = GeniusCashDrawerReport(
          config,
          report: service.cashDrawer(shift),
        );
        break;
      case S16PosRetailPackScenario.paymentSummary:
        document = GeniusPaymentMethodSummaryReport(
          config,
          report: service.paymentMethodSummary(shift.payments),
        );
        break;
      case S16PosRetailPackScenario.barcodeLabel:
        document = GeniusRetailBarcodeLabelDocument(
          config: config,
          labels: _retailLabels(_itemCount.clamp(1, 50).toInt()),
        );
        break;
      case S16PosRetailPackScenario.priceLabel:
        document = GeniusRetailPriceLabelDocument(
          config: config,
          labels: _retailLabels(_itemCount.clamp(1, 50).toInt()),
        );
        break;
      case S16PosRetailPackScenario.promotionLabel:
        document = GeniusRetailPromotionLabelDocument(
          config: config,
          labels: _retailLabels(_itemCount.clamp(1, 50).toInt()),
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }

  GeniusPosReceiptRequest _receipt(int count) {
    final lines = List.generate(
      count,
      (index) => GeniusPosReceiptLine(
        description: index == 0
            ? 'Very long retail product name that must wrap on narrow thermal paper without clipping'
            : 'Retail Product ${index + 1}',
        descriptionAr: index == 0
            ? 'اسم منتج تجزئة عربي طويل جداً يجب أن يلتف داخل الورق الحراري الضيق دون قص'
            : 'منتج تجزئة ${index + 1}',
        sku: 'SKU-${(index + 1).toString().padLeft(6, '0')}',
        quantity: index.isEven ? 1.5 : 2,
        unitPrice: 10 + index % 7,
        discount: index % 4 == 0 ? 1.5 : 0,
        tax: 1.5 + index % 3,
        promotion: index % 5 == 0 ? 'BUY-MORE' : null,
        promotionAr: index % 5 == 0 ? 'عرض شراء' : null,
        note: index == 0 ? 'No sugar / extra hot' : null,
        noteAr: index == 0 ? 'بدون سكر / ساخن جداً' : null,
      ),
    );

    final tax = lines.fold<double>(
      0,
      (sum, line) => sum + line.tax,
    );
    final taxable = lines.fold<double>(
      0,
      (sum, line) => sum + line.lineSubtotal - line.discount,
    );

    return GeniusPosReceiptRequest(
      merchantName: 'Genius Retail Store',
      merchantNameAr: 'متجر جينيس للتجزئة',
      receiptNumber: 'POS-2026-0001',
      date: DateTime(2026, 9, 4),
      lines: lines,
      documentDiscount: 2,
      payments: const [
        GeniusPosPayment(
          method: GeniusPosPaymentMethod.cash,
          amount: 20,
        ),
        GeniusPosPayment(
          method: GeniusPosPaymentMethod.card,
          amount: 30,
          reference: 'AUTH-001',
        ),
        GeniusPosPayment(
          method: GeniusPosPaymentMethod.wallet,
          amount: 10,
          reference: 'WALLET-01',
        ),
      ],
      taxSummary: [
        GeniusPosTaxSummaryLine(
          code: 'VAT',
          ratePercent: 15,
          taxableAmount: taxable,
          taxAmount: tax,
        ),
      ],
      cashReceived: 50,
      change: 5,
      qrData: 'https://example.com/receipts/POS-2026-0001',
      barcodeData: 'POS20260001',
      reprint: _reprint,
      copyLabel: _reprint ? 'REPRINT COPY' : 'Original',
      copyLabelAr: _reprint ? 'نسخة معاد طباعتها' : 'الأصل',
      footer: 'Thank you — Please keep your receipt.',
      footerAr: 'شكراً لكم — يرجى الاحتفاظ بالإيصال.',
    );
  }

  GeniusPosShiftSummary _shift() => GeniusPosShiftSummary(
        shiftId: 'SHIFT-2026-09-04-A',
        openedAt: DateTime(2026, 9, 4, 8),
        closedAt: DateTime(2026, 9, 4, 20),
        cashier: 'Cashier 01',
        terminal: 'POS-01',
        openingCash: ErpMoney.fromAmount(
          500,
          currency: ErpCurrency.sar,
        ),
        sales: ErpMoney.fromAmount(
          5000,
          currency: ErpCurrency.sar,
        ),
        refunds: ErpMoney.fromAmount(
          200,
          currency: ErpCurrency.sar,
        ),
        discounts: ErpMoney.fromAmount(
          100,
          currency: ErpCurrency.sar,
        ),
        tax: ErpMoney.fromAmount(
          705,
          currency: ErpCurrency.sar,
        ),
        expectedCash: ErpMoney.fromAmount(
          1800,
          currency: ErpCurrency.sar,
        ),
        actualCash: ErpMoney.fromAmount(
          1795,
          currency: ErpCurrency.sar,
        ),
        payments: [
          GeniusPosPaymentSummary(
            method: GeniusPosPaymentMethod.cash,
            amount: ErpMoney.fromAmount(
              1300,
              currency: ErpCurrency.sar,
            ),
            transactionCount: 42,
          ),
          GeniusPosPaymentSummary(
            method: GeniusPosPaymentMethod.card,
            amount: ErpMoney.fromAmount(
              3000,
              currency: ErpCurrency.sar,
            ),
            transactionCount: 70,
          ),
          GeniusPosPaymentSummary(
            method: GeniusPosPaymentMethod.wallet,
            amount: ErpMoney.fromAmount(
              700,
              currency: ErpCurrency.sar,
            ),
            transactionCount: 15,
          ),
        ],
      );

  List<GeniusPosRetailLabel> _retailLabels(int count) =>
      List.generate(
        count,
        (index) => GeniusPosRetailLabel(
          itemCode: 'SKU-${index + 1}',
          itemName: 'Retail Label ${index + 1}',
          itemNameAr: 'ملصق تجزئة ${index + 1}',
          price: ErpMoney.fromAmount(
            25 + index,
            currency: ErpCurrency.sar,
          ),
          oldPrice: index % 2 == 0
              ? ErpMoney.fromAmount(
                  30 + index,
                  currency: ErpCurrency.sar,
                )
              : null,
          promotion: index % 2 == 0 ? '20% OFF' : null,
          promotionAr: index % 2 == 0 ? 'خصم 20%' : null,
          qrData: 'https://example.com/retail/${index + 1}',
        ),
      );
}


Future<Uint8List> buildS16Receipt58VerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.receipt58,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16Receipt80VerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.receipt80,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16RefundVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.refund,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16ExchangeVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.exchange,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16GiftVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.gift,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16KotVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.kot,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16ShiftOpenVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.shiftOpen,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16ShiftCloseVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.shiftClose,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16XReportVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.xReport,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16ZReportVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.zReport,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16CashDrawerVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.cashDrawer,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16PaymentSummaryVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.paymentSummary,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16BarcodeLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.barcodeLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16PriceLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.priceLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS16PromotionLabelVerificationPdf(GeniusPdfConfig config) {
  final runner = S16PosRetailPackRunner(
    baseConfig: config,
    scenario: S16PosRetailPackScenario.promotionLabel,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
