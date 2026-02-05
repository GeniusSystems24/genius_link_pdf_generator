/// Incoming Remittance Voucher template (Service IDs: 10450–10451, 10550–10551).
///
/// Generates vouchers for:
/// - **10450** Domestic Personal Incoming — personal remittance received locally
/// - **10451** Domestic Commercial Incoming — commercial remittance received locally
/// - **10550** International Personal Incoming — personal remittance from abroad
/// - **10551** International Commercial Incoming — commercial remittance from abroad
library;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../components/components.dart';
import '../../../core/pdf_config.dart';
import '../models/voucher_enums.dart';
import '../models/voucher_models.dart';
import '../models/voucher_style.dart';
import 'voucher_base_template.dart';

/// Generates an incoming remittance voucher PDF page.
///
/// ```dart
/// final voucher = RemittanceIncomingVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.internationalPersonalIncoming,
///     voucherNumber: 'RI-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 3500,
///   ),
///   remittanceData: VoucherRemittanceData(
///     senderName: 'Ali Hassan',
///     senderCountry: 'Egypt',
///     beneficiaryName: 'Mohammed Al-Ahmed',
///     disbursementMethod: 'To Account',
///   ),
/// );
/// ```
class RemittanceIncomingVoucher extends GeniusPdfVoucherTemplate {
  RemittanceIncomingVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    required this.remittanceData,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  /// Remittance-specific data.
  final VoucherRemittanceData remittanceData;

  bool get _isInternational => remittanceData.isInternational(data.serviceId);

  @override
  void buildVoucherContent() {
    // Domestic / International badge
    _drawTypeBadge();

    // Sender info
    _drawSenderInfo();

    // Beneficiary info
    _drawBeneficiaryInfo();

    // Remittance details (exchange info for international)
    if (_isInternational) {
      _drawExchangeDetails();
    }

    // Fees
    _drawFees();

    // Net amount credited
    drawAmountBlock();

    // Disbursement method
    if (remittanceData.disbursementMethod != null) {
      _drawDisbursement();
    }

    // Account allocation
    if (data.accountEntries.isNotEmpty) {
      drawAccountEntriesTable();
    }
  }

  void _drawTypeBadge() {
    final g = currentPage.graphics;
    final y = currentY;

    final badgeText = _isInternational
        ? (isRTL ? 'دولية' : 'International')
        : (isRTL ? 'محلية' : 'Domestic');
    final badgeColor =
        _isInternational ? const Color(0xFF1565C0) : const Color(0xFF2E7D32);

    final badgeWidth = 90.0;
    final badgeHeight = 18.0;
    final badgeX = (contentWidth - badgeWidth) / 2;

    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(badgeColor)),
      bounds: Rect.fromLTWH(badgeX, y, badgeWidth, badgeHeight),
    );
    g.drawString(
      badgeText,
      smallFont,
      brush: PdfSolidBrush(const PdfColor(255, 255, 255)),
      bounds: Rect.fromLTWH(badgeX, y + 3, badgeWidth, badgeHeight),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );

    resetY(y + badgeHeight + style.sectionSpacing);
  }

  void _drawSenderInfo() {
    final y = currentY;
    _drawLabel(y, 'معلومات المرسل', 'Sender Information');
    var infoY = y + 16;

    final fields = <_RPair>[
      _RPair('الاسم', 'Name',
          isRTL ? (remittanceData.senderNameAr ?? remittanceData.senderName) : remittanceData.senderName),
      if (remittanceData.senderCountry != null)
        _RPair('الدولة', 'Country',
            isRTL ? (remittanceData.senderCountryAr ?? remittanceData.senderCountry!) : remittanceData.senderCountry!),
      if (remittanceData.senderPhone != null)
        _RPair('الهاتف', 'Phone', remittanceData.senderPhone!),
      if (_isInternational && remittanceData.beneficiaryBankName != null)
        _RPair('بنك المصدر', 'Source Bank',
            isRTL ? (remittanceData.beneficiaryBankNameAr ?? remittanceData.beneficiaryBankName!) : remittanceData.beneficiaryBankName!),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      _drawFieldPair(infoY, fields[i], i + 1 < fields.length ? fields[i + 1] : null);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawBeneficiaryInfo() {
    final y = currentY;
    _drawLabel(y, 'معلومات المستفيد', 'Beneficiary Information');
    var infoY = y + 16;

    final fields = <_RPair>[
      _RPair('الاسم', 'Name',
          isRTL ? (remittanceData.beneficiaryNameAr ?? remittanceData.beneficiaryName) : remittanceData.beneficiaryName),
      if (remittanceData.beneficiaryIdNumber != null)
        _RPair('رقم الهوية', 'ID No', remittanceData.beneficiaryIdNumber!),
      if (remittanceData.beneficiaryPhone != null)
        _RPair('الهاتف', 'Phone', remittanceData.beneficiaryPhone!),
      if (remittanceData.beneficiaryAccountNumber != null)
        _RPair('رقم الحساب', 'Account No', remittanceData.beneficiaryAccountNumber!),
      if (remittanceData.beneficiaryIban != null)
        _RPair('الآيبان', 'IBAN', remittanceData.beneficiaryIban!),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      _drawFieldPair(infoY, fields[i], i + 1 < fields.length ? fields[i + 1] : null);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawExchangeDetails() {
    final y = currentY;
    _drawLabel(y, 'تفاصيل التحويل', 'Exchange Details');
    var infoY = y + 16;

    final fields = <_RPair>[
      if (remittanceData.sourceCurrency != null)
        _RPair('العملة الأصلية', 'Original Currency', remittanceData.sourceCurrency!),
      if (remittanceData.targetCurrency != null)
        _RPair('العملة المحوّلة', 'Converted Currency', remittanceData.targetCurrency!),
      if (remittanceData.exchangeRate != null)
        _RPair('سعر الصرف', 'Exchange Rate', remittanceData.exchangeRate!.toStringAsFixed(4)),
      if (remittanceData.sourceAmount != null)
        _RPair('المبلغ الأصلي', 'Original Amount', _fmtNum(remittanceData.sourceAmount!)),
      if (remittanceData.targetAmount != null)
        _RPair('المبلغ المحوّل', 'Converted Amount', _fmtNum(remittanceData.targetAmount!)),
      if (remittanceData.correspondentBank != null)
        _RPair('سويفت المرجعي', 'SWIFT Ref',
            isRTL ? (remittanceData.correspondentBankAr ?? remittanceData.correspondentBank!) : remittanceData.correspondentBank!),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      _drawFieldPair(infoY, fields[i], i + 1 < fields.length ? fields[i + 1] : null);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawFees() {
    if (remittanceData.transferFee == null &&
        remittanceData.exchangeMargin == null) return;

    final y = currentY;
    _drawLabel(y, 'الرسوم', 'Fees');
    var infoY = y + 16;

    final fields = <_RPair>[
      if (remittanceData.transferFee != null)
        _RPair('رسوم الاستلام', 'Receiving Fee', '${_fmtNum(remittanceData.transferFee!)} ${data.currency}'),
      if (remittanceData.exchangeMargin != null)
        _RPair('فرق الصرف', 'Exchange Difference', '${_fmtNum(remittanceData.exchangeMargin!)} ${data.currency}'),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      _drawFieldPair(infoY, fields[i], i + 1 < fields.length ? fields[i + 1] : null);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawDisbursement() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawLabel(y, 'طريقة الصرف', 'Disbursement Method');

    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(style.amountHighlightColor)),
      pen: PdfPen(_pdfColor(style.primaryColor), width: 0.5),
      bounds: Rect.fromLTWH(0, y + 16, contentWidth, 18),
    );

    final text = isRTL
        ? (remittanceData.disbursementMethodAr ?? remittanceData.disbursementMethod!)
        : remittanceData.disbursementMethod!;
    g.drawString(
      text,
      boldBodyFont,
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(4, y + 19, contentWidth - 8, 14),
      format: PdfStringFormat(alignment: PdfTextAlignment.center, textDirection: textDir),
    );

    resetY(y + 38 + style.sectionSpacing);
  }

  // ── Drawing helpers ──

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

  void _drawFieldPair(double y, _RPair pair1, [_RPair? pair2]) {
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

  String _fmtNum(double n) {
    if (n == n.truncateToDouble()) {
      return n.truncate().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    return n.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  @override
  List<VoucherSignatory> _defaultSignatories() => [
        RemittanceSignatories.beneficiary(),
        BankingSignatories.operator(),
        VoucherSignatory.manager(),
      ];
}

class _RPair {
  const _RPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
}
