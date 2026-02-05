/// Bill Payment Voucher template (Service IDs: 10300–10305).
///
/// Generates vouchers for:
/// - **10300** Utility Bill Payment — electricity, water, gas, phone
/// - **10301** General Bill Payment — miscellaneous bills and dues
/// - **10302** Internet Bill Payment — internet service bills
/// - **10303** Telecom Recharge — mobile operator packages and credit
/// - **10304** Game Credit Recharge — gaming platform credit
/// - **10305** Entertainment Recharge — streaming and entertainment subscriptions
library;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../components/components.dart';
import '../../../core/pdf_config.dart';
import '../models/voucher_enums.dart';
import '../models/voucher_models.dart';
import '../models/voucher_style.dart';
import 'voucher_base_template.dart';

/// Generates a bill payment voucher PDF page.
///
/// ```dart
/// final voucher = BillPaymentVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.utilityBillPayment,
///     voucherNumber: 'BP-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 850,
///   ),
///   billData: VoucherBillData(
///     providerName: 'Saudi Electricity Company',
///     providerNameAr: 'شركة الكهرباء السعودية',
///     subscriberNumber: '1234567890',
///     serviceType: 'Electricity',
///     serviceTypeAr: 'كهرباء',
///   ),
/// );
/// ```
class BillPaymentVoucher extends GeniusPdfVoucherTemplate {
  BillPaymentVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    required this.billData,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  /// Bill-specific payment data.
  final VoucherBillData billData;

  @override
  void buildVoucherContent() {
    // Service provider info
    _drawProviderInfo();

    // Bill details (varies by subtype)
    _drawBillDetails();

    // Payment method
    drawPaymentDetails();

    // Amount block
    drawAmountBlock();

    // Confirmation / transaction reference
    if (billData.confirmationNumber != null) {
      _drawConfirmation();
    }

    // Account allocation
    if (data.accountEntries.isNotEmpty) {
      drawAccountEntriesTable();
    }
  }

  void _drawProviderInfo() {
    final y = currentY;
    _drawLabel(y, 'مقدم الخدمة', 'Service Provider');
    var infoY = y + 16;

    final fields = <_BillInfoPair>[
      _BillInfoPair('مقدم الخدمة', 'Provider', billData.displayProvider(isRTL: isRTL)),
      if (billData.subscriberNumber != null)
        _BillInfoPair('رقم المشترك', 'Subscriber No', billData.subscriberNumber!),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      final pair1 = fields[i];
      final pair2 = (i + 1 < fields.length) ? fields[i + 1] : null;
      _drawFieldPair(infoY, pair1, pair2);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawBillDetails() {
    final y = currentY;
    _drawLabel(y, 'تفاصيل الفاتورة', 'Bill Details');
    var infoY = y + 16;

    final fields = <_BillInfoPair>[];

    switch (data.serviceId) {
      case VoucherServiceId.utilityBillPayment:
        if (billData.serviceType != null) {
          fields.add(_BillInfoPair('نوع الخدمة', 'Service Type',
              isRTL ? (billData.serviceTypeAr ?? billData.serviceType!) : billData.serviceType!));
        }
        if (billData.meterNumber != null) fields.add(_BillInfoPair('رقم العداد', 'Meter No', billData.meterNumber!));
        if (billData.billingPeriod != null) {
          fields.add(_BillInfoPair('فترة الفوترة', 'Billing Period',
              isRTL ? (billData.billingPeriodAr ?? billData.billingPeriod!) : billData.billingPeriod!));
        }
        if (billData.consumption != null) {
          final unit = billData.consumptionUnit ?? 'kWh';
          fields.add(_BillInfoPair('الاستهلاك', 'Consumption', '${billData.consumption} $unit'));
        }
        if (billData.rate != null) fields.add(_BillInfoPair('التعرفة', 'Rate', billData.rate!.toStringAsFixed(4)));
        break;

      case VoucherServiceId.generalBillPayment:
        if (billData.billNumber != null) fields.add(_BillInfoPair('رقم الفاتورة', 'Bill No', billData.billNumber!));
        if (billData.dueDate != null) fields.add(_BillInfoPair('تاريخ الاستحقاق', 'Due Date', _fmtDate(billData.dueDate!)));
        if (billData.serviceType != null) {
          fields.add(_BillInfoPair('نوع الفاتورة', 'Bill Type',
              isRTL ? (billData.serviceTypeAr ?? billData.serviceType!) : billData.serviceType!));
        }
        break;

      case VoucherServiceId.internetBillPayment:
        if (billData.planName != null) {
          fields.add(_BillInfoPair('الباقة', 'Plan',
              isRTL ? (billData.planNameAr ?? billData.planName!) : billData.planName!));
        }
        if (billData.billingPeriod != null) {
          fields.add(_BillInfoPair('فترة الفوترة', 'Billing Period',
              isRTL ? (billData.billingPeriodAr ?? billData.billingPeriod!) : billData.billingPeriod!));
        }
        break;

      case VoucherServiceId.telecomRecharge:
        if (billData.mobileNumber != null) fields.add(_BillInfoPair('رقم الجوال', 'Mobile No', billData.mobileNumber!));
        if (billData.planName != null) {
          fields.add(_BillInfoPair('الباقة', 'Package',
              isRTL ? (billData.planNameAr ?? billData.planName!) : billData.planName!));
        }
        if (billData.validity != null) {
          fields.add(_BillInfoPair('الصلاحية', 'Validity',
              isRTL ? (billData.validityAr ?? billData.validity!) : billData.validity!));
        }
        break;

      case VoucherServiceId.gameRecharge:
        if (billData.planName != null) {
          fields.add(_BillInfoPair('اللعبة', 'Game',
              isRTL ? (billData.planNameAr ?? billData.planName!) : billData.planName!));
        }
        if (billData.serviceType != null) {
          fields.add(_BillInfoPair('نوع الرصيد', 'Credit Type',
              isRTL ? (billData.serviceTypeAr ?? billData.serviceType!) : billData.serviceType!));
        }
        break;

      case VoucherServiceId.entertainmentRecharge:
        if (billData.planName != null) {
          fields.add(_BillInfoPair('المنصة', 'Platform',
              isRTL ? (billData.planNameAr ?? billData.planName!) : billData.planName!));
        }
        if (billData.validity != null) {
          fields.add(_BillInfoPair('الصلاحية', 'Validity',
              isRTL ? (billData.validityAr ?? billData.validity!) : billData.validity!));
        }
        break;

      default:
        break;
    }

    for (var i = 0; i < fields.length; i += 2) {
      final pair1 = fields[i];
      final pair2 = (i + 1 < fields.length) ? fields[i + 1] : null;
      _drawFieldPair(infoY, pair1, pair2);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawConfirmation() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawLabel(y, 'مرجع العملية', 'Transaction Reference');

    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(style.amountHighlightColor)),
      pen: PdfPen(_pdfColor(style.primaryColor), width: 0.5),
      bounds: Rect.fromLTWH(0, y + 16, contentWidth, 18),
    );
    g.drawString(
      billData.confirmationNumber!,
      boldBodyFont,
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(4, y + 19, contentWidth - 8, 14),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    resetY(y + 38 + style.sectionSpacing);
  }

  void _drawLabel(double y, String labelAr, String labelEn) {
    final g = currentPage.graphics;
    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(0, y, 3, 13),
    );
    g.drawString(
      '$labelAr  |  $labelEn',
      boldBodyFont,
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(8, y, contentWidth - 8, 13),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );
  }

  void _drawFieldPair(double y, _BillInfoPair pair1, [_BillInfoPair? pair2]) {
    final g = currentPage.graphics;
    final halfWidth = contentWidth / 2;

    final label1 = isRTL ? pair1.labelAr : pair1.labelEn;
    g.drawString('$label1: ', boldBodyFont,
      brush: PdfSolidBrush(_pdfColor(style.accentColor)),
      bounds: Rect.fromLTWH(4, y, halfWidth * 0.4 - 4, 12),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir));
    g.drawString(pair1.value, bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(halfWidth * 0.4, y, halfWidth * 0.6 - 4, 12),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir));

    if (pair2 != null) {
      final label2 = isRTL ? pair2.labelAr : pair2.labelEn;
      g.drawString('$label2: ', boldBodyFont,
        brush: PdfSolidBrush(_pdfColor(style.accentColor)),
        bounds: Rect.fromLTWH(halfWidth + 4, y, halfWidth * 0.4 - 4, 12),
        format: PdfStringFormat(alignment: startAlign, textDirection: textDir));
      g.drawString(pair2.value, bodyFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(halfWidth + halfWidth * 0.4, y, halfWidth * 0.6 - 4, 12),
        format: PdfStringFormat(alignment: startAlign, textDirection: textDir));
    }
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  List<VoucherSignatory> _defaultSignatories() => [
        BankingSignatories.requester(),
        VoucherSignatory.accountant(),
      ];
}

class _BillInfoPair {
  const _BillInfoPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
}
