/// Receipt Voucher template (Service IDs: 00100–00103).
///
/// Generates vouchers for:
/// - **00100** Cash Receipt — cash received from customer
/// - **00101** Bank Transfer Receipt — received via bank transfer
/// - **00102** Check Receipt — check received from customer
/// - **00103** Electronic Receipt — received via electronic payment
library;

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
    // Account allocation
    drawAccountEntriesTable();

    // Amount block
    drawAmountBlock();

    // Received from
    drawPartyInfo(labelAr: 'استلمنا من', labelEn: 'Received From');

    // Payment details
    drawPaymentDetails();

    // Purpose / description
    if (data.description != null || data.descriptionAr != null) {
      _drawPurpose();
    }
  }

  void _drawPurpose() {
    final text = isRTL
        ? (data.descriptionAr ?? data.description ?? '')
        : (data.description ?? '');
    addSectionHeading('وذلك عن', 'Purpose');
    addLine(text, font: bodyFont, topMargin: 2);
    addSpace(style.sectionSpacing);
  }

  @override
  List<VoucherSignatory> defaultSignatories() => [
        VoucherSignatory.cashier(),
        VoucherSignatory.accountant(),
        VoucherSignatory.manager(),
        VoucherSignatory.receivedBy(),
      ];
}
