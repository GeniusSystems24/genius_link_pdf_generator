/// Transfer Voucher template (Service IDs: 10200–10203).
///
/// Generates vouchers for:
/// - **10200** Bank Transfer — transfer from one bank account to another
/// - **10201** Inter-Account Transfer — transfer between own accounts
/// - **10202** Electronic Transfer — transfer via electronic platforms
/// - **10203** Currency Exchange — foreign exchange transaction
library;

import 'package:flutter/painting.dart' show Rect;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../components/components.dart';
import '../../../core/pdf_config.dart';
import '../../../extensions/color_extensions.dart';
import '../models/voucher_enums.dart';
import '../models/voucher_models.dart';
import '../models/voucher_style.dart';
import 'voucher_base_template.dart';

/// Generates a transfer voucher PDF page.
///
/// ```dart
/// final voucher = TransferVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.bankTransfer,
///     voucherNumber: 'TF-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 30000,
///   ),
///   transferData: VoucherTransferData(
///     sourceAccount: VoucherBankInfo(bankName: 'Al Rajhi Bank'),
///     destinationAccount: VoucherBankInfo(bankName: 'NCB'),
///   ),
/// );
/// ```
class TransferVoucher extends GeniusPdfVoucherTemplate {
  TransferVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    required this.transferData,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  /// Transfer-specific data.
  final VoucherTransferData transferData;

  @override
  void buildVoucherContent() {
    // Source account
    _drawAccountBlock(
      labelAr: 'حساب المصدر',
      labelEn: 'Source Account',
      account: transferData.sourceAccount,
    );

    // Destination account
    _drawAccountBlock(
      labelAr: 'حساب الوجهة',
      labelEn: 'Destination Account',
      account: transferData.destinationAccount,
    );

    // Transfer-specific details
    _drawTransferDetails();

    // Fees
    if (transferData.transferFee != null || transferData.commission != null) {
      _drawFeesBlock();
    }

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

  void _drawAccountBlock({
    required String labelAr,
    required String labelEn,
    required VoucherBankInfo account,
  }) {
    final y = currentY;
    _drawLabel(y, labelAr, labelEn);
    var infoY = y + 16;

    final fields = <_TransferInfoPair>[
      _TransferInfoPair('البنك', 'Bank', account.displayBankName(isRTL: isRTL)),
      if (account.branchName != null)
        _TransferInfoPair('الفرع', 'Branch',
            isRTL ? (account.branchNameAr ?? account.branchName!) : account.branchName!),
      if (account.accountNumber != null)
        _TransferInfoPair('رقم الحساب', 'Account No', account.accountNumber!),
      if (account.iban != null)
        _TransferInfoPair('الآيبان', 'IBAN', account.iban!),
      if (account.swiftCode != null)
        _TransferInfoPair('سويفت', 'SWIFT', account.swiftCode!),
      _TransferInfoPair('العملة', 'Currency', account.currency),
      if (account.balanceBefore != null)
        _TransferInfoPair('الرصيد قبل', 'Balance Before', _fmtNum(account.balanceBefore!)),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      final pair1 = fields[i];
      final pair2 = (i + 1 < fields.length) ? fields[i + 1] : null;
      _drawFieldPair(infoY, pair1, pair2);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawTransferDetails() {
    final y = currentY;
    _drawLabel(y, 'تفاصيل التحويل', 'Transfer Details');
    var infoY = y + 16;

    final fields = <_TransferInfoPair>[];

    switch (data.serviceId) {
      case VoucherServiceId.bankTransfer:
        if (transferData.beneficiaryName != null) {
          fields.add(_TransferInfoPair('اسم المستفيد', 'Beneficiary',
              isRTL ? (transferData.beneficiaryNameAr ?? transferData.beneficiaryName!) : transferData.beneficiaryName!));
        }
        if (data.paymentDetails?.transferReference != null) {
          fields.add(_TransferInfoPair('مرجع التحويل', 'Transfer Ref', data.paymentDetails!.transferReference!));
        }
        break;
      case VoucherServiceId.interAccountTransfer:
        fields.add(_TransferInfoPair('نوع التحويل', 'Transfer Type',
            isRTL ? 'تحويل بين حسابات' : 'Inter-Account Transfer'));
        break;
      case VoucherServiceId.electronicTransfer:
        if (transferData.platform != null) {
          fields.add(_TransferInfoPair('المنصة', 'Platform', transferData.platform!));
        }
        if (data.paymentDetails?.transactionId != null) {
          fields.add(_TransferInfoPair('رقم العملية', 'Transaction ID', data.paymentDetails!.transactionId!));
        }
        if (transferData.processingTime != null) {
          fields.add(_TransferInfoPair('وقت المعالجة', 'Processing Time', transferData.processingTime!));
        }
        break;
      case VoucherServiceId.currencyExchange:
        final pd = data.paymentDetails;
        if (pd != null) {
          if (pd.sourceCurrency != null) fields.add(_TransferInfoPair('عملة المصدر', 'Source Currency', pd.sourceCurrency!));
          if (pd.targetCurrency != null) fields.add(_TransferInfoPair('العملة المستهدفة', 'Target Currency', pd.targetCurrency!));
          if (pd.exchangeRate != null) fields.add(_TransferInfoPair('سعر الصرف', 'Exchange Rate', pd.exchangeRate!.toStringAsFixed(4)));
          if (pd.sourceAmount != null) fields.add(_TransferInfoPair('المبلغ الأصلي', 'Source Amount', _fmtNum(pd.sourceAmount!)));
          if (pd.targetAmount != null) fields.add(_TransferInfoPair('المبلغ المحوّل', 'Target Amount', _fmtNum(pd.targetAmount!)));
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

  void _drawFeesBlock() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawLabel(y, 'الرسوم', 'Fees');
    var infoY = y + 16;

    final fields = <_TransferInfoPair>[];
    if (transferData.transferFee != null) {
      fields.add(_TransferInfoPair('رسوم التحويل', 'Transfer Fee', '${_fmtNum(transferData.transferFee!)} ${data.currency}'));
    }
    if (transferData.commission != null) {
      fields.add(_TransferInfoPair('العمولة', 'Commission', '${_fmtNum(transferData.commission!)} ${data.currency}'));
    }

    for (var i = 0; i < fields.length; i += 2) {
      final pair1 = fields[i];
      final pair2 = (i + 1 < fields.length) ? fields[i + 1] : null;
      _drawFieldPair(infoY, pair1, pair2);
      infoY += 14;
    }

    // Net amount after fees
    if (transferData.netAmount != null) {
      infoY += 2;
      final netLabel = isRTL ? 'صافي المبلغ' : 'Net Amount';
      final netText = '${_fmtNum(transferData.netAmount!)} ${data.currency}';

      g.drawRectangle(
        brush: PdfSolidBrush(style.amountHighlightColor.toPdfColor()),
        pen: PdfPen(style.primaryColor.toPdfColor(), width: 0.5),
        bounds: Rect.fromLTWH(0, infoY, contentWidth, 18),
      );
      g.drawString(
        '$netLabel:  $netText',
        boldBodyFont,
        brush: PdfSolidBrush(style.primaryColor.toPdfColor()),
        bounds: Rect.fromLTWH(4, infoY + 3, contentWidth - 8, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.center, textDirection: textDir),
      );
      infoY += 20;
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
      brush: PdfSolidBrush(style.primaryColor.toPdfColor()),
      bounds: Rect.fromLTWH(0, y, 3, 13),
    );
    g.drawString(
      '$labelAr  |  $labelEn',
      boldBodyFont,
      brush: PdfSolidBrush(style.primaryColor.toPdfColor()),
      bounds: Rect.fromLTWH(8, y, contentWidth - 8, 13),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );
  }

  void _drawFieldPair(double y, _TransferInfoPair pair1, [_TransferInfoPair? pair2]) {
    final g = currentPage.graphics;
    final halfWidth = contentWidth / 2;

    final label1 = isRTL ? pair1.labelAr : pair1.labelEn;
    g.drawString('$label1: ', boldBodyFont,
      brush: PdfSolidBrush(style.accentColor.toPdfColor()),
      bounds: Rect.fromLTWH(4, y, halfWidth * 0.4 - 4, 12),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir));
    g.drawString(pair1.value, bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(halfWidth * 0.4, y, halfWidth * 0.6 - 4, 12),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir));

    if (pair2 != null) {
      final label2 = isRTL ? pair2.labelAr : pair2.labelEn;
      g.drawString('$label2: ', boldBodyFont,
        brush: PdfSolidBrush(style.accentColor.toPdfColor()),
        bounds: Rect.fromLTWH(halfWidth + 4, y, halfWidth * 0.4 - 4, 12),
        format: PdfStringFormat(alignment: startAlign, textDirection: textDir));
      g.drawString(pair2.value, bodyFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(halfWidth + halfWidth * 0.4, y, halfWidth * 0.6 - 4, 12),
        format: PdfStringFormat(alignment: startAlign, textDirection: textDir));
    }
  }

  String _fmtNum(double n) {
    if (n == n.truncateToDouble()) return n.truncate().toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    return n.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  @override
  List<VoucherSignatory> defaultSignatories() => [
        BankingSignatories.requester(),
        BankingSignatories.treasury(),
        VoucherSignatory.manager(),
      ];
}

class _TransferInfoPair {
  const _TransferInfoPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
}
