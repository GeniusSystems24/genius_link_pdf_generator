/// Accounting Entry Voucher template (Service IDs: 00001–00004).
///
/// Generates vouchers for:
/// - **00001** Simple Entry — one debit, one credit
/// - **00002** Compound Entry — multiple debits/credits
/// - **00003** Opening Entry — beginning-of-period balances
/// - **00004** Adjusting Entry — end-of-period corrections
library;

import 'package:flutter/painting.dart' show Rect;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';


/// Generates an accounting entry voucher PDF page.
///
/// ```dart
/// final voucher = AccountingEntryVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.simpleEntry,
///     voucherNumber: 'JV-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 15000,
///     accountEntries: [
///       VoucherAccountEntry(accountCode: '1100', accountName: 'Cash', debitAmount: 15000),
///       VoucherAccountEntry(accountCode: '4100', accountName: 'Sales', creditAmount: 15000),
///     ],
///   ),
/// );
/// ```
class AccountingEntryVoucher extends GeniusPdfVoucherTemplate {
  AccountingEntryVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  @override
  void buildVoucherContent() {
    // Description
    if (data.description != null || data.descriptionAr != null) {
      _drawDescription();
    }

    // Account entries table (the core of accounting voucher)
    drawAccountEntriesTable();

    // Amount block
    drawAmountBlock();
  }

  void _drawDescription() {
    final g = currentPage.graphics;
    final y = currentY;

    _drawSectionLabelLocal(y, 'البيان', 'Description');

    final descAr = data.descriptionAr ?? data.description ?? '';
    final descEn = data.description ?? '';

    // Arabic description
    g.drawString(
      descAr,
      bodyFont,
      brush: PdfBrushes.black,
      bounds: Rect.fromLTWH(8, y + 16, contentWidth - 16, 14),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.right,
        textDirection: PdfTextDirection.rightToLeft,
      ),
    );

    // English description below
    if (descEn.isNotEmpty && descEn != descAr) {
      g.drawString(
        descEn,
        smallFont,
        brush: PdfSolidBrush(PdfColor(120, 120, 120)),
        bounds: Rect.fromLTWH(8, y + 32, contentWidth - 16, 12),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          textDirection: PdfTextDirection.leftToRight,
        ),
      );
      resetY(y + 48 + style.sectionSpacing);
    } else {
      resetY(y + 32 + style.sectionSpacing);
    }
  }

  void _drawSectionLabelLocal(double y, String labelAr, String labelEn) {
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
        VoucherSignatory.reviewedBy(),
        VoucherSignatory.approvedBy(),
      ];
}
