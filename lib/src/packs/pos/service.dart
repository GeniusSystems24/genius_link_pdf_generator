
import '../../printing/profiles/print_profiles.dart';
import '../shared/erp_pack_shared.dart';
import 'models.dart';

import '../../families/erp/erp_families.dart';
import '../../core/directionality.dart' show GeniusPdfValueKind;
/// S16 POS preparation service.
///
/// Receipt calculations are completed before thermal rendering. The service
/// only adapts already-calculated line/tender/tax values to S11 thermal data.
class GeniusPosService {
  const GeniusPosService();

  GeniusPdfThermalReceiptData thermalData(
    GeniusPosReceiptRequest request,
  ) {
    final taxSummaryText = request.taxSummary
        .map(
          (tax) =>
              '${tax.code} ${tax.ratePercent.toStringAsFixed(2)}%: '
              '${tax.taxAmount.toStringAsFixed(2)} ${request.currency}',
        )
        .join('\n');

    final copyText = request.reprint
        ? (request.copyLabel ?? 'REPRINT')
        : (request.copyLabel ?? 'Original');
    final copyTextAr = request.reprint
        ? (request.copyLabelAr ?? 'إعادة طباعة')
        : (request.copyLabelAr ?? 'الأصل');

    final footer = [
      if (taxSummaryText.isNotEmpty) 'Tax Summary\n$taxSummaryText',
      copyText,
      if (request.footer != null && request.footer!.trim().isNotEmpty)
        request.footer!,
    ].join('\n');

    final footerAr = [
      if (taxSummaryText.isNotEmpty) 'ملخص الضريبة\n$taxSummaryText',
      copyTextAr,
      if (request.footerAr != null &&
          request.footerAr!.trim().isNotEmpty)
        request.footerAr!,
    ].join('\n');

    final paymentLines = <GeniusPdfThermalPaymentLine>[
      for (final payment in request.payments)
        GeniusPdfThermalPaymentLine(
          label: payment.label ?? _paymentLabel(payment.method),
          labelAr:
              payment.labelAr ?? _paymentLabelAr(payment.method),
          amount: payment.amount,
        ),
      if (request.cashReceived != null)
        GeniusPdfThermalPaymentLine(
          label: 'Cash Received',
          labelAr: 'النقد المستلم',
          amount: request.cashReceived!,
        ),
      if (request.change != null)
        GeniusPdfThermalPaymentLine(
          label: 'Change',
          labelAr: 'الباقي',
          amount: -request.change!,
        ),
    ];

    final multiplier = request.kind == GeniusPosReceiptKind.refund
        ? -1.0
        : 1.0;

    final defaultTitle = switch (request.kind) {
      GeniusPosReceiptKind.sale => ('Receipt', 'إيصال'),
      GeniusPosReceiptKind.refund => ('Refund Receipt', 'إيصال مرتجع'),
      GeniusPosReceiptKind.exchange => ('Exchange Receipt', 'إيصال استبدال'),
      GeniusPosReceiptKind.gift => ('Gift Receipt', 'إيصال هدية'),
    };
    final receiptTitle = request.title ?? defaultTitle.$1;
    final receiptTitleAr = request.titleAr ?? defaultTitle.$2;

    return GeniusPdfThermalReceiptData(
      merchantName: request.merchantName,
      merchantNameAr: request.merchantNameAr,
      title: receiptTitle,
      titleAr: receiptTitleAr,
      showAmounts: request.kind != GeniusPosReceiptKind.gift,
      receiptNumber: request.receiptNumber,
      date: request.date,
      currency: request.currency,
      items: [
        for (final line in request.lines)
          GeniusPdfThermalLineItem(
            description: _withNote(
              line.description,
              line.note,
              line.promotion,
            ),
            descriptionAr: _withNote(
              line.descriptionAr ?? line.description,
              line.noteAr ?? line.note,
              line.promotionAr ?? line.promotion,
            ),
            sku: line.sku,
            quantity: multiplier * line.quantity,
            unitPrice: line.unitPrice,
            discount: multiplier * line.discount,
          ),
      ],
      discount: multiplier * request.documentDiscount,
      tax: multiplier * request.taxTotal,
      total: multiplier * request.total,
      payments: paymentLines,
      footer: footer,
      footerAr: footerAr,
      qrData: request.qrData,
      barcodeData: request.barcodeData,
    );
  }

  GeniusPdfPrintProfile profile58() =>
      GeniusPdfPrintProfile.thermal58();

  GeniusPdfPrintProfile profile80() =>
      GeniusPdfPrintProfile.thermal80();

  GeniusErpPackReportData shiftOpen(
    GeniusPosShiftSummary shift,
  ) =>
      _shiftReport(
        shift,
        title: 'Shift Open Report',
        titleAr: 'تقرير فتح الوردية',
        includeActual: false,
      );

  GeniusErpPackReportData shiftClose(
    GeniusPosShiftSummary shift,
  ) =>
      _shiftReport(
        shift,
        title: 'Shift Close Report',
        titleAr: 'تقرير إغلاق الوردية',
        includeActual: true,
      );

  GeniusErpPackReportData xReport(
    GeniusPosShiftSummary shift,
  ) =>
      _shiftReport(
        shift,
        title: 'X Report',
        titleAr: 'تقرير X',
        includeActual: true,
      );

  GeniusErpPackReportData zReport(
    GeniusPosShiftSummary shift,
  ) =>
      _shiftReport(
        shift,
        title: 'Z Report',
        titleAr: 'تقرير Z',
        includeActual: true,
      );

  GeniusErpPackReportData cashDrawer(
    GeniusPosShiftSummary shift,
  ) {
    return GeniusErpPackReportData(
      title: 'Cash Drawer Report',
      titleAr: 'تقرير درج النقدية',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Item',
          titleAr: 'البند',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'item': 'Opening Cash',
            'amount': shift.openingCash.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'item': 'Expected Cash',
            'amount': shift.expectedCash.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'item': 'Actual Cash',
            'amount': shift.actualCash.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'item': 'Variance',
            'amount': shift.cashVariance.toDouble(),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData paymentMethodSummary(
    List<GeniusPosPaymentSummary> payments,
  ) {
    return GeniusErpPackReportData(
      title: 'Payment Method Summary',
      titleAr: 'ملخص طرق الدفع',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'method',
          title: 'Method',
          titleAr: 'الطريقة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'transactions',
          title: 'Transactions',
          titleAr: 'العمليات',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final payment in payments)
          GeniusErpPackReportRow(
            cells: {
              'method': GeniusErpPackLocalizedValue(
                value: _paymentLabel(payment.method),
                valueAr: _paymentLabelAr(payment.method),
              ),
              'transactions': payment.transactionCount,
              'amount': payment.amount.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData _shiftReport(
    GeniusPosShiftSummary shift, {
    required String title,
    required String titleAr,
    required bool includeActual,
  }) {
    final rows = <GeniusErpPackReportRow>[
      GeniusErpPackReportRow(
        cells: {
          'metric': 'Opening Cash',
          'value': shift.openingCash.toDouble(),
        },
      ),
      GeniusErpPackReportRow(
        cells: {
          'metric': 'Sales',
          'value': shift.sales.toDouble(),
        },
      ),
      GeniusErpPackReportRow(
        cells: {
          'metric': 'Refunds',
          'value': shift.refunds.toDouble(),
        },
      ),
      GeniusErpPackReportRow(
        cells: {
          'metric': 'Discounts',
          'value': shift.discounts.toDouble(),
        },
      ),
      GeniusErpPackReportRow(
        cells: {
          'metric': 'Tax',
          'value': shift.tax.toDouble(),
        },
      ),
      GeniusErpPackReportRow(
        cells: {
          'metric': 'Expected Cash',
          'value': shift.expectedCash.toDouble(),
        },
      ),
      if (includeActual)
        GeniusErpPackReportRow(
          cells: {
            'metric': 'Actual Cash',
            'value': shift.actualCash.toDouble(),
          },
        ),
      if (includeActual)
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'metric': 'Cash Variance',
            'value': shift.cashVariance.toDouble(),
          },
        ),
    ];

    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      details: [
        GeniusErpDetailField(
          label: 'Shift',
          labelAr: 'الوردية',
          value: shift.shiftId,
          valueKind: GeniusPdfValueKind.customIdentifier,
        ),
        if (shift.cashier != null)
          GeniusErpDetailField(
            label: 'Cashier',
            labelAr: 'الكاشير',
            value: shift.cashier!,
          ),
        if (shift.terminal != null)
          GeniusErpDetailField(
            label: 'Terminal',
            labelAr: 'الجهاز',
            value: shift.terminal!,
            valueKind: GeniusPdfValueKind.customIdentifier,
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'metric',
          title: 'Metric',
          titleAr: 'البند',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'value',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: rows,
    );
  }

  String _withNote(
    String value,
    String? note,
    String? promotion,
  ) =>
      [
        value,
        if (promotion != null && promotion.trim().isNotEmpty)
          'Promo: $promotion',
        if (note != null && note.trim().isNotEmpty) note,
      ].join('\n');

  String _paymentLabel(GeniusPosPaymentMethod method) =>
      switch (method) {
        GeniusPosPaymentMethod.cash => 'Cash',
        GeniusPosPaymentMethod.card => 'Card',
        GeniusPosPaymentMethod.bank => 'Bank',
        GeniusPosPaymentMethod.wallet => 'Wallet',
        GeniusPosPaymentMethod.voucher => 'Voucher',
        GeniusPosPaymentMethod.other => 'Other',
      };

  String _paymentLabelAr(GeniusPosPaymentMethod method) =>
      switch (method) {
        GeniusPosPaymentMethod.cash => 'نقداً',
        GeniusPosPaymentMethod.card => 'بطاقة',
        GeniusPosPaymentMethod.bank => 'بنك',
        GeniusPosPaymentMethod.wallet => 'محفظة',
        GeniusPosPaymentMethod.voucher => 'قسيمة',
        GeniusPosPaymentMethod.other => 'أخرى',
      };
}
