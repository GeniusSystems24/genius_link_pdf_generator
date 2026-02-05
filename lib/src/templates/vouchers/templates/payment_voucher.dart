/// Payment Voucher template (Service IDs: 00200–00203).
///
/// Generates vouchers for:
/// - **00200** Cash Payment — cash paid to supplier/employee
/// - **00201** Bank Transfer Payment — paid via bank transfer
/// - **00202** Check Payment — check issued for payment
/// - **00203** Electronic Payment — paid via electronic method
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
    // Account allocation
    drawAccountEntriesTable();

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
  }

  void _drawPurpose() {
    final text = isRTL
        ? (data.descriptionAr ?? data.description ?? '')
        : (data.description ?? '');
    addSectionHeading('وذلك عن', 'Purpose');
    addLine(text, font: bodyFont, topMargin: 2);
    addSpace(style.sectionSpacing);
  }

  void _drawDeductions() {
    double totalDeductions = 0;
    final rows = <GeniusPdfGridRow>[
      for (final ded in deductions)
        GeniusPdfGridRow(cells: {
          'name': isRTL ? (ded.nameAr ?? ded.name) : ded.name,
          'amount': ded.amount,
        }),
    ];

    for (final ded in deductions) {
      totalDeductions += ded.amount;
    }

    final netAmount = data.amount - totalDeductions;
    rows.add(GeniusPdfGridRow.total({
      'name': isRTL ? 'صافي المبلغ' : 'Net Amount',
      'amount': netAmount,
    }));

    addSectionHeading('الاستقطاعات', 'Deductions');
    addSpace(4);

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'name',
          title: 'Deduction',
          titleAr: 'الاستقطاع',
          flexFactor: 3,
        ),
        GeniusPdfGridColumn.currency(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          width: 90,
          currencySymbol: '',
        ),
      ],
      rows: rows,
      style: GeniusPdfGridStyle.classic(),
    );

    final result = addGrid(grid, spacing: 0);
    if (result != null) {
      updateFromLayoutResult(result, spacing: style.sectionSpacing);
    } else {
      addSpace(style.sectionSpacing);
    }
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
