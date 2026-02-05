/// Payment Voucher template (Service IDs: 00200–00203).
///
/// Generates vouchers for:
/// - **00200** Cash Payment — cash paid to supplier/employee
/// - **00201** Bank Transfer Payment — paid via bank transfer
/// - **00202** Check Payment — check issued for payment
/// - **00203** Electronic Payment — paid via electronic method
library;

import 'package:flutter/painting.dart' show Rect, Offset;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../../components/components.dart';
import '../../../core/pdf_config.dart';
import '../models/voucher_models.dart';
import '../models/voucher_style.dart';
import 'voucher_base_template.dart';

/// Generates a payment voucher PDF page.
///
/// ```dart
/// final voucher = PaymentVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.cashPayment,
///     voucherNumber: 'PV-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 8500,
///     party: VoucherParty(name: 'ABC Supplies', nameAr: 'مؤسسة أبك'),
///   ),
/// );
/// ```
class PaymentVoucher extends GeniusPdfVoucherTemplate {
  PaymentVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    this.deductions = const [],
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  /// Optional deductions (tax withholding, discounts, penalties).
  final List<PaymentDeduction> deductions;

  @override
  void buildVoucherContent() {
    // Paid to
    drawPartyInfo(labelAr: 'صرفنا إلى', labelEn: 'Paid To');

    // Payment details
    drawPaymentDetails();

    // Amount block
    drawAmountBlock();

    // Purpose / description
    if (data.description != null || data.descriptionAr != null) {
      _drawPurpose();
    }

    // Deductions (if any)
    if (deductions.isNotEmpty) {
      _drawDeductions();
    }

    // Account allocation
    if (data.accountEntries.isNotEmpty) {
      drawAccountEntriesTable();
    }
  }

  void _drawPurpose() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawLabel(y, 'وذلك عن', 'Purpose');

    final text = isRTL
        ? (data.descriptionAr ?? data.description ?? '')
        : (data.description ?? '');
    g.drawString(
      text,
      bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(4, y + 16, contentWidth - 8, 28),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );

    resetY(y + 46 + style.sectionSpacing);
  }

  void _drawDeductions() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawLabel(y, 'الاستقطاعات', 'Deductions');

    var rowY = y + 18;
    double totalDeductions = 0;

    for (final ded in deductions) {
      final label = isRTL ? (ded.nameAr ?? ded.name) : ded.name;
      g.drawString(
        label,
        bodyFont,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(8, rowY, contentWidth * 0.6, 12),
        format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
      );
      g.drawString(
        ded.amount.toString(),
        bodyFont,
        brush: PdfSolidBrush((style.debitColor.toPdfColor())),
        bounds:
            Rect.fromLTWH(contentWidth * 0.6, rowY, contentWidth * 0.4 - 8, 12),
        format: PdfStringFormat(alignment: endAlign),
      );
      totalDeductions += ded.amount;
      rowY += 14;
    }

    // Net amount
    final netAmount = data.amount - totalDeductions;
    g.drawLine(
      PdfPen((style.borderColor.toPdfColor()), width: 0.5),
      Offset(contentWidth * 0.5, rowY),
      Offset(contentWidth, rowY),
    );
    rowY += 4;

    final netLabel = isRTL ? 'صافي المبلغ' : 'Net Amount';
    g.drawString(
      netLabel,
      boldBodyFont,
      brush: PdfSolidBrush((style.primaryColor.toPdfColor())),
      bounds: Rect.fromLTWH(8, rowY, contentWidth * 0.6, 12),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );
    g.drawString(
      '${(netAmount)} ${data.currency}',
      boldBodyFont,
      brush: PdfSolidBrush((style.primaryColor.toPdfColor())),
      bounds:
          Rect.fromLTWH(contentWidth * 0.6, rowY, contentWidth * 0.4 - 8, 12),
      format: PdfStringFormat(alignment: endAlign),
    );

    resetY(rowY + 16 + style.sectionSpacing);
  }

  void _drawLabel(double y, String labelAr, String labelEn) {
    final g = currentPage.graphics;
    g.drawRectangle(
      brush: PdfSolidBrush((style.primaryColor.toPdfColor())),
      bounds: Rect.fromLTWH(0, y, 3, 13),
    );
    g.drawString(
      '$labelAr  |  $labelEn',
      boldBodyFont,
      brush: PdfSolidBrush((style.primaryColor.toPdfColor())),
      bounds: Rect.fromLTWH(8, y, contentWidth - 8, 13),
      format: PdfStringFormat(alignment: startAlign, textDirection: textDir),
    );
  }

  @override
  List<VoucherSignatory> defaultSignatories() => [
        VoucherSignatory.preparedBy(),
        VoucherSignatory.accountant(),
        VoucherSignatory.manager(),
        VoucherSignatory(
          role: 'Beneficiary',
          roleAr: 'المستفيد',
        ),
      ];
}

/// A deduction applied to a payment.
class PaymentDeduction {
  const PaymentDeduction({
    required this.name,
    this.nameAr,
    required this.amount,
  });

  final String name;
  final String? nameAr;
  final double amount;
}
