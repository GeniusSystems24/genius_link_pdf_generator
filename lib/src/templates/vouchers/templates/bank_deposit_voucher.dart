/// Bank Deposit Voucher template (Service IDs: 10000–10002).
///
/// Generates vouchers for:
/// - **10000** Cash Deposit — cash deposited into bank account
/// - **10001** Check Deposit — check deposited into bank account
/// - **10002** Electronic Deposit — electronic transfer deposit
library;

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../components/components.dart';
import '../../../core/pdf_config.dart';
import '../models/voucher_enums.dart';
import '../models/voucher_models.dart';
import '../models/voucher_style.dart';
import 'voucher_base_template.dart';

/// Generates a bank deposit voucher PDF page.
///
/// ```dart
/// final voucher = BankDepositVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.cashDeposit,
///     voucherNumber: 'BD-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 50000,
///   ),
///   bankInfo: VoucherBankInfo(
///     bankName: 'Al Rajhi Bank',
///     bankNameAr: 'مصرف الراجحي',
///     accountNumber: '1234567890',
///     iban: 'SA0380000000608010167519',
///   ),
/// );
/// ```
class BankDepositVoucher extends GeniusPdfVoucherTemplate {
  BankDepositVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    required this.bankInfo,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  /// Bank account information for the deposit.
  final VoucherBankInfo bankInfo;

  @override
  void buildVoucherContent() {
    // Bank information
    _drawBankInfo();

    // Deposit details (varies by subtype)
    _drawDepositDetails();

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

    final fields = <_DepositInfoPair>[
      _DepositInfoPair('البنك', 'Bank', bankInfo.displayBankName(isRTL: isRTL)),
      if (bankInfo.branchName != null)
        _DepositInfoPair('الفرع', 'Branch',
            isRTL ? (bankInfo.branchNameAr ?? bankInfo.branchName!) : bankInfo.branchName!),
      if (bankInfo.accountNumber != null)
        _DepositInfoPair('رقم الحساب', 'Account No', bankInfo.accountNumber!),
      if (bankInfo.iban != null)
        _DepositInfoPair('الآيبان', 'IBAN', bankInfo.iban!),
    ];

    for (var i = 0; i < fields.length; i += 2) {
      final pair1 = fields[i];
      final pair2 = (i + 1 < fields.length) ? fields[i + 1] : null;
      _drawFieldPair(infoY, pair1, pair2);
      infoY += 14;
    }

    resetY(infoY + style.sectionSpacing);
  }

  void _drawDepositDetails() {
    final y = currentY;
    _drawLabel(y, 'تفاصيل الإيداع', 'Deposit Details');
    var infoY = y + 16;

    final fields = <_DepositInfoPair>[];

    switch (data.serviceId) {
      case VoucherServiceId.cashDeposit:
        fields.add(_DepositInfoPair('نوع الإيداع', 'Deposit Type',
            isRTL ? 'إيداع نقدي' : 'Cash Deposit'));
        if (data.paymentDetails?.denominations != null) {
          // Denomination breakdown will be drawn as a table below
        }
        break;
      case VoucherServiceId.checkDeposit:
        fields.add(_DepositInfoPair('نوع الإيداع', 'Deposit Type',
            isRTL ? 'إيداع شيك' : 'Check Deposit'));
        final pd = data.paymentDetails;
        if (pd != null) {
          if (pd.checkNumber != null) fields.add(_DepositInfoPair('رقم الشيك', 'Check No', pd.checkNumber!));
          if (pd.draweeBankName != null) fields.add(_DepositInfoPair('البنك المسحوب عليه', 'Drawee Bank', pd.draweeBankName!));
          if (pd.checkDate != null) fields.add(_DepositInfoPair('تاريخ الشيك', 'Check Date', _fmtDate(pd.checkDate!)));
          if (pd.dueDate != null) fields.add(_DepositInfoPair('تاريخ الاستحقاق', 'Due Date', _fmtDate(pd.dueDate!)));
        }
        if (data.party != null) {
          fields.add(_DepositInfoPair('اسم المحرر', 'Drawer Name', data.party!.displayName(isRTL: isRTL)));
        }
        break;
      case VoucherServiceId.electronicDeposit:
        fields.add(_DepositInfoPair('نوع الإيداع', 'Deposit Type',
            isRTL ? 'إيداع إلكتروني' : 'Electronic Deposit'));
        final pd = data.paymentDetails;
        if (pd != null) {
          if (pd.transferReference != null) fields.add(_DepositInfoPair('مرجع التحويل', 'Transfer Ref', pd.transferReference!));
          if (pd.transactionId != null) fields.add(_DepositInfoPair('رقم العملية', 'Transaction ID', pd.transactionId!));
          if (pd.gatewayName != null) fields.add(_DepositInfoPair('مصدر التحويل', 'Transfer Source', pd.gatewayName!));
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

    // Denomination table for cash deposit
    if (data.serviceId == VoucherServiceId.cashDeposit &&
        data.paymentDetails?.denominations != null &&
        data.paymentDetails!.denominations!.isNotEmpty) {
      _drawDenominationTable();
    }
  }

  void _drawDenominationTable() {
    final denominations = data.paymentDetails!.denominations!;
    final sortedKeys = denominations.keys.toList()..sort((a, b) => b.compareTo(a));

    drawItemsTable(
      labelAr: 'تفصيل الفئات النقدية',
      labelEn: 'Cash Denomination Breakdown',
      columns: [
        const GeniusPdfGridColumn(
          id: 'denom', title: 'Denomination', titleAr: 'الفئة',
          width: 120, alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'count', title: 'Count', titleAr: 'العدد',
          width: 80, alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn.currency(
          id: 'total', title: 'Total', titleAr: 'المجموع',
          width: 120, currencySymbol: '',
        ),
      ],
      rows: [
        for (final key in sortedKeys)
          GeniusPdfGridRow(cells: {
            'denom': _fmtNum(key),
            'count': denominations[key]!,
            'total': key * denominations[key]!,
          }),
        GeniusPdfGridRow.total({
          'denom': isRTL ? 'الإجمالي' : 'Total',
          'count': '',
          'total': denominations.entries.fold<double>(0, (s, e) => s + e.key * e.value),
        }),
      ],
    );
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

  void _drawFieldPair(double y, _DepositInfoPair pair1, [_DepositInfoPair? pair2]) {
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

  String _fmtNum(double n) {
    if (n == n.truncateToDouble()) return n.truncate().toString();
    return n.toStringAsFixed(2);
  }

  @override
  List<VoucherSignatory> _defaultSignatories() => [
        BankingSignatories.depositor(),
        VoucherSignatory.cashier(),
        BankingSignatories.bankTeller(),
      ];
}

class _DepositInfoPair {
  const _DepositInfoPair(this.labelAr, this.labelEn, this.value);
  final String labelAr;
  final String labelEn;
  final String value;
}
