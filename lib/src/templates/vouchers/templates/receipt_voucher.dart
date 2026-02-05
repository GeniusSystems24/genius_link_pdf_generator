/// Receipt Voucher template (Service IDs: 00100–00103).
///
/// Generates vouchers for:
/// - **00100** Cash Receipt — cash received from customer
/// - **00101** Bank Transfer Receipt — received via bank transfer
/// - **00102** Check Receipt — check received from customer
/// - **00103** Electronic Receipt — received via electronic payment
library;

import 'package:flutter/painting.dart' show Rect;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';


/// Generates a receipt voucher PDF page.
///
/// ```dart
/// final voucher = ReceiptVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.cashReceipt,
///     voucherNumber: 'RV-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 5000,
///     party: VoucherParty(name: 'Ahmed', nameAr: 'أحمد'),
///   ),
/// );
/// ```
class ReceiptVoucher extends GeniusPdfVoucherTemplate {
  ReceiptVoucher({
    required super.config,
    required super.company,
    required super.data,
    super.style,
  });

  @override
  void buildVoucherContent() {
    // Received from
    drawPartyInfo(labelAr: 'استلمنا من', labelEn: 'Received From');

    // Payment details
    drawPaymentDetails();

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

  void _drawPurpose() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawLabel(y, 'وذلك عن', 'Purpose');

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
        VoucherSignatory.cashier(),
        VoucherSignatory.accountant(),
        VoucherSignatory.manager(),
        VoucherSignatory.receivedBy(),
      ];
}
