/// Outgoing Remittance Voucher template (Service IDs: 10400–10401, 10500–10501).
///
/// Generates vouchers for:
/// - **10400** Domestic Personal Outgoing — personal remittance within the country
/// - **10401** Domestic Commercial Outgoing — commercial remittance within the country
/// - **10500** International Personal Outgoing — personal remittance abroad
/// - **10501** International Commercial Outgoing — commercial remittance abroad
library;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../components/components.dart';
import '../../../core/pdf_config.dart';
import '../models/voucher_enums.dart';
import '../models/voucher_models.dart';
import '../models/voucher_style.dart';
import 'voucher_base_template.dart';

/// Generates an outgoing remittance voucher PDF page.
///
/// ```dart
/// final voucher = RemittanceOutgoingVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.internationalPersonalOutgoing,
///     voucherNumber: 'RO-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 5000,
///   ),
///   remittanceData: VoucherRemittanceData(
///     senderName: 'Mohammed Al-Ahmed',
///     beneficiaryName: 'Ali Hassan',
///     beneficiaryCountry: 'Egypt',
///   ),
/// );
/// ```
class RemittanceOutgoingVoucher extends GeniusPdfVoucherTemplate {
  RemittanceOutgoingVoucher({
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

    // Remittance details
    _drawRemittanceDetails();

    // Fees
    _drawFees();

    // Amount block
    drawAmountBlock();

    // Compliance
    if (remittanceData.amlReference != null ||
        remittanceData.purposeCode != null) {
      _drawCompliance();
    }

    // Tracking
    if (remittanceData.trackingNumber != null) {
      _drawTracking();
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
      if (remittanceData.senderIdNumber != null)
        _RPair('رقم الهوية', 'ID No', remittanceData.senderIdNumber!),
      if (remittanceData.senderIdType != null)
        _RPair('نوع الهوية', 'ID Type',
            isRTL ? (remittanceData.senderIdTypeAr ?? remittanceData.senderIdType!) : remittanceData.senderIdType!),
      if (remittanceData.senderPhone != null)
        _RPair('الهاتف', 'Phone', remittanceData.senderPhone!),
      if (remittanceData.senderAddress != null)
        _RPair('العنوان', 'Address',
            isRTL ? (remittanceData.senderAddressAr ?? remittanceData.senderAddress!) : remittanceData.senderAddress!),
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
      if (remittanceData.beneficiaryCountry != null)
        _RPair('الدولة', 'Country',
            isRTL ? (remittanceData.beneficiaryCountryAr ?? remittanceData.beneficiaryCountry!) : remittanceData.beneficiaryCountry!),
      if (remittanceData.beneficiaryAddress != null)
        _RPair('العنوان', 'Address',
            isRTL ? (remittanceData.beneficiaryAddressAr ?? remittanceData.beneficiaryAddress!) : remittanceData.beneficiaryAddress!),
      if (remittanceData.beneficiaryBankName != null)
        _RPair('البنك', 'Bank',
            isRTL ? (remittanceData.beneficiaryBankNameAr ?? remittanceData.beneficiaryBankName!) : remittanceData.beneficiaryBankName!),
      if (remittanceData.beneficiaryAccountNumber != null)
        _RPair('رقم الحساب', 'Account No', remittanceData.beneficiaryAccountNumber!),
      if (remittanceData.beneficiaryIban != null)
        _RPair('الآيبان', 'IBAN', remittanceData.beneficiaryIban!),
      if (_isInternational && remittanceData.beneficiarySwiftCode != null)
        _RPair('سويفت', 'SWIFT', remittanceData.beneficiarySwiftCode!),
      if (_isInternational && remittanceData.correspondentBank != null)
        _RPair('البنك المراسل', 'Correspondent Bank',
            isRTL ? (remittanceData.correspondentBankAr ?? remittanceData.correspondentBank!) : remittanceData.correspondentBank!),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      _drawFieldPair(infoY, fields[i], i + 1 < fields.length ? fields[i + 1] : null);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawRemittanceDetails() {
    if (!_isInternational) return; // domestic has no exchange details

    final y = currentY;
    _drawLabel(y, 'تفاصيل التحويل', 'Remittance Details');
    var infoY = y + 16;

    final fields = <_RPair>[
      if (remittanceData.sourceCurrency != null)
        _RPair('العملة المصدر', 'Source Currency', remittanceData.sourceCurrency!),
      if (remittanceData.targetCurrency != null)
        _RPair('العملة المستهدفة', 'Target Currency', remittanceData.targetCurrency!),
      if (remittanceData.exchangeRate != null)
        _RPair('سعر الصرف', 'Exchange Rate', remittanceData.exchangeRate!.toStringAsFixed(4)),
      if (remittanceData.sourceAmount != null)
        _RPair('المبلغ الأصلي', 'Source Amount', _fmtNum(remittanceData.sourceAmount!)),
      if (remittanceData.targetAmount != null)
        _RPair('المبلغ المحوّل', 'Target Amount', _fmtNum(remittanceData.targetAmount!)),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      _drawFieldPair(infoY, fields[i], i + 1 < fields.length ? fields[i + 1] : null);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawFees() {
    if (remittanceData.transferFee == null &&
        remittanceData.exchangeMargin == null &&
        remittanceData.totalCost == null) return;

    final y = currentY;
    _drawLabel(y, 'الرسوم', 'Fees');
    var infoY = y + 16;

    final fields = <_RPair>[
      if (remittanceData.transferFee != null)
        _RPair('رسوم التحويل', 'Transfer Fee', '${_fmtNum(remittanceData.transferFee!)} ${data.currency}'),
      if (remittanceData.exchangeMargin != null)
        _RPair('هامش الصرف', 'Exchange Margin', '${_fmtNum(remittanceData.exchangeMargin!)} ${data.currency}'),
      if (remittanceData.totalCost != null)
        _RPair('التكلفة الإجمالية', 'Total Cost', '${_fmtNum(remittanceData.totalCost!)} ${data.currency}'),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      _drawFieldPair(infoY, fields[i], i + 1 < fields.length ? fields[i + 1] : null);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawCompliance() {
    final y = currentY;
    _drawLabel(y, 'الامتثال', 'Compliance');
    var infoY = y + 16;

    final fields = <_RPair>[
      if (remittanceData.purposeCode != null)
        _RPair('رمز الغرض', 'Purpose Code', remittanceData.purposeCode!),
      if (remittanceData.purposeDescription != null)
        _RPair('الغرض', 'Purpose',
            isRTL ? (remittanceData.purposeDescriptionAr ?? remittanceData.purposeDescription!) : remittanceData.purposeDescription!),
      if (remittanceData.amlReference != null)
        _RPair('مرجع مكافحة غسل الأموال', 'AML Reference', remittanceData.amlReference!),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      _drawFieldPair(infoY, fields[i], i + 1 < fields.length ? fields[i + 1] : null);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawTracking() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawLabel(y, 'التتبع', 'Tracking');

    g.drawRectangle(
      brush: PdfSolidBrush(_pdfColor(style.amountHighlightColor)),
      pen: PdfPen(_pdfColor(style.primaryColor), width: 0.5),
      bounds: Rect.fromLTWH(0, y + 16, contentWidth, 28),
    );

    final trackingText =
        '${isRTL ? "رقم التتبع" : "Tracking No"}: ${remittanceData.trackingNumber}';
    g.drawString(
      trackingText,
      boldBodyFont,
      brush: PdfSolidBrush(_pdfColor(style.primaryColor)),
      bounds: Rect.fromLTWH(8, y + 19, contentWidth / 2 - 8, 14),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );

    if (remittanceData.expectedDeliveryDate != null) {
      final dateText =
          '${isRTL ? "التسليم المتوقع" : "Expected Delivery"}: ${_fmtDate(remittanceData.expectedDeliveryDate!)}';
      g.drawString(
        dateText,
        bodyFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(contentWidth / 2, y + 19, contentWidth / 2 - 8, 14),
        format: PdfStringFormat(alignment: endAlign, textDirection: textDir),
      );
    }

    resetY(y + 48 + style.sectionSpacing);
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

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  List<VoucherSignatory> _defaultSignatories() => [
        RemittanceSignatories.sender(),
        BankingSignatories.operator(),
        RemittanceSignatories.complianceOfficer(),
        VoucherSignatory.manager(),
      ];
}

class _RPair {
  const _RPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
}
