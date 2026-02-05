/// Bank Withdrawal Voucher template (Service IDs: 10100–10102).
///
/// Generates vouchers for:
/// - **10100** Cash Withdrawal — cash withdrawn from bank account
/// - **10101** Check Withdrawal — withdrawal via issued check
/// - **10102** ATM Withdrawal — withdrawal from ATM machine
library;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../components/components.dart';
import '../../../core/pdf_config.dart';
import '../models/voucher_enums.dart';
import '../models/voucher_models.dart';
import '../models/voucher_style.dart';
import 'voucher_base_template.dart';

/// Generates a bank withdrawal voucher PDF page.
///
/// ```dart
/// final voucher = BankWithdrawalVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.cashWithdrawal,
///     voucherNumber: 'BW-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 10000,
///   ),
///   bankInfo: VoucherBankInfo(
///     bankName: 'Al Rajhi Bank',
///     bankNameAr: 'مصرف الراجحي',
///     accountNumber: '1234567890',
///   ),
/// );
/// ```
class BankWithdrawalVoucher extends GeniusPdfVoucherTemplate {
  BankWithdrawalVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    required this.bankInfo,
    this.authorizedPerson,
    this.authorizedPersonAr,
    this.atmLocation,
    this.maskedCardNumber,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  /// Bank account information for the withdrawal.
  final VoucherBankInfo bankInfo;

  /// Name of the person authorized to withdraw (for cash withdrawal).
  final String? authorizedPerson;
  final String? authorizedPersonAr;

  /// ATM location (for ATM withdrawal).
  final String? atmLocation;

  /// Masked card number (for ATM withdrawal).
  final String? maskedCardNumber;

  @override
  void buildVoucherContent() {
    // Bank information
    _drawBankInfo();

    // Withdrawal details (varies by subtype)
    _drawWithdrawalDetails();

    // Amount block
    drawAmountBlock();

    // Purpose / description
    if (data.description != null || data.descriptionAr != null) {
      _drawPurpose();
    }

    // Account allocation
    if (data.accountEntries.isNotEmpty) {
      drawAccountEntriesTable();
    }
  }

  void _drawBankInfo() {
    final y = currentY;
    _drawLabel(y, 'معلومات البنك', 'Bank Information');
    var infoY = y + 16;

    final fields = <_WithdrawInfoPair>[
      _WithdrawInfoPair('البنك', 'Bank', bankInfo.displayBankName(isRTL: isRTL)),
      if (bankInfo.branchName != null)
        _WithdrawInfoPair('الفرع', 'Branch',
            isRTL ? (bankInfo.branchNameAr ?? bankInfo.branchName!) : bankInfo.branchName!),
      if (bankInfo.accountNumber != null)
        _WithdrawInfoPair('رقم الحساب', 'Account No', bankInfo.accountNumber!),
      if (bankInfo.iban != null)
        _WithdrawInfoPair('الآيبان', 'IBAN', bankInfo.iban!),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      final pair1 = fields[i];
      final pair2 = (i + 1 < fields.length) ? fields[i + 1] : null;
      _drawFieldPair(infoY, pair1, pair2);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawWithdrawalDetails() {
    final y = currentY;
    _drawLabel(y, 'تفاصيل السحب', 'Withdrawal Details');
    var infoY = y + 16;

    final fields = <_WithdrawInfoPair>[];

    switch (data.serviceId) {
      case VoucherServiceId.cashWithdrawal:
        fields.add(_WithdrawInfoPair('نوع السحب', 'Withdrawal Type',
            isRTL ? 'سحب نقدي' : 'Cash Withdrawal'));
        if (authorizedPerson != null) {
          fields.add(_WithdrawInfoPair('الشخص المخول', 'Authorized Person',
              isRTL ? (authorizedPersonAr ?? authorizedPerson!) : authorizedPerson!));
        }
        break;
      case VoucherServiceId.checkWithdrawal:
        fields.add(_WithdrawInfoPair('نوع السحب', 'Withdrawal Type',
            isRTL ? 'سحب بشيك' : 'Check Withdrawal'));
        final pd = data.paymentDetails;
        if (pd != null) {
          if (pd.checkNumber != null) fields.add(_WithdrawInfoPair('رقم الشيك', 'Check No', pd.checkNumber!));
          if (pd.checkDate != null) fields.add(_WithdrawInfoPair('تاريخ الشيك', 'Check Date', _fmtDate(pd.checkDate!)));
        }
        if (data.party != null) {
          fields.add(_WithdrawInfoPair('اسم المستفيد', 'Payee Name', data.party!.displayName(isRTL: isRTL)));
        }
        break;
      case VoucherServiceId.atmWithdrawal:
        fields.add(_WithdrawInfoPair('نوع السحب', 'Withdrawal Type',
            isRTL ? 'سحب عبر الصراف' : 'ATM Withdrawal'));
        if (atmLocation != null) fields.add(_WithdrawInfoPair('موقع الصراف', 'ATM Location', atmLocation!));
        if (maskedCardNumber != null) fields.add(_WithdrawInfoPair('رقم البطاقة', 'Card No', maskedCardNumber!));
        final pd = data.paymentDetails;
        if (pd?.transactionId != null) {
          fields.add(_WithdrawInfoPair('مرجع العملية', 'Transaction Ref', pd!.transactionId!));
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

  void _drawPurpose() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawLabel(y, 'الغرض', 'Purpose');
    final text = isRTL ? (data.descriptionAr ?? data.description ?? '') : (data.description ?? '');
    g.drawString(
      text,
      bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(4, y + 16, contentWidth - 8, 28),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );

    resetY(y + 46 + style.sectionSpacing);
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

  void _drawFieldPair(double y, _WithdrawInfoPair pair1, [_WithdrawInfoPair? pair2]) {
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
        BankingSignatories.authorizedSignatory(),
      ];
}

class _WithdrawInfoPair {
  const _WithdrawInfoPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
}
