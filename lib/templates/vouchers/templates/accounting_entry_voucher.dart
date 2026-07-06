/// Accounting Entry Voucher template (Service IDs: 00001–00004).
///
/// Generates vouchers for:
/// - **00001** Simple Entry — one debit, one credit
/// - **00002** Compound Entry — multiple debits/credits
/// - **00003** Opening Entry — beginning-of-period balances
/// - **00004** Adjusting Entry — end-of-period corrections
library;

import '../voucher_support.dart';

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
    required super.config,
    required super.company,
    required super.data,
    super.style,
  });

  @override
  void buildVoucherContent() {
    // Account entries table (the core of accounting voucher)
    drawAccountEntriesTable();

    // Amount block
    drawAmountBlock();

    // Description
    if (data.description != null || data.descriptionAr != null) {
      _drawDescription();
    }
  }

  void _drawDescription() {
    addSectionHeading('البيان', 'Description');
    final descAr = data.descriptionAr ?? data.description ?? '';
    final descEn = data.description ?? '';

    if (descAr.isNotEmpty) {
      addLine(descAr, font: bodyFont, topMargin: 2);
    }

    if (descEn.isNotEmpty && descEn != descAr) {
      addLine(descEn, font: smallFont, topMargin: 2);
    }
    addSpace(style.sectionSpacing);
  }

  @override
  List<VoucherSignatory> defaultSignatories() => [
        VoucherSignatory.preparedBy(),
        VoucherSignatory.reviewedBy(),
        VoucherSignatory.approvedBy(),
      ];
}
