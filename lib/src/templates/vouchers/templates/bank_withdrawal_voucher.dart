/// Bank Withdrawal Voucher template (Service IDs: 10100–10102).
///
/// Generates vouchers for:
/// - **10100** Cash Withdrawal — cash withdrawn from bank account
/// - **10101** Check Withdrawal — withdrawal via issued check
/// - **10102** ATM Withdrawal — withdrawal from ATM machine
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
    // Account allocation
    drawAccountEntriesTable();

    // Amount block
    drawAmountBlock();

    // Bank information
    _drawBankInfo();

    // Withdrawal details (varies by subtype)
    _drawWithdrawalDetails();

    // Purpose / description
    if (data.description != null || data.descriptionAr != null) {
      _drawPurpose();
    }
  }

  void _drawBankInfo() {
    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Bank',
        labelAr: 'البنك',
        value: bankInfo.displayBankName(isRTL: isRTL),
      ),
      if (bankInfo.branchName != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Branch',
          labelAr: 'الفرع',
          value: isRTL
              ? (bankInfo.branchNameAr ?? bankInfo.branchName!)
              : bankInfo.branchName!,
        ),
      if (bankInfo.accountNumber != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Account No',
          labelAr: 'رقم الحساب',
          value: bankInfo.accountNumber!,
        ),
      if (bankInfo.iban != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'IBAN',
          labelAr: 'الآيبان',
          value: bankInfo.iban!,
        ),
    ];

    addInfoSection(
      labelAr: 'معلومات البنك',
      labelEn: 'Bank Information',
      items: items,
      columns: 2,
    );
  }

  void _drawWithdrawalDetails() {
    final items = <GeniusPdfLabeledValue>[];
    void addItem(String labelAr, String labelEn, String value) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: labelEn,
        labelAr: labelAr,
        value: value,
      ));
    }

    switch (data.serviceId) {
      case VoucherServiceId.cashWithdrawal:
        addItem(
          'نوع السحب',
          'Withdrawal Type',
          isRTL ? 'سحب نقدي' : 'Cash Withdrawal',
        );
        if (authorizedPerson != null) {
          addItem(
            'الشخص المخول',
            'Authorized Person',
            isRTL
                ? (authorizedPersonAr ?? authorizedPerson!)
                : authorizedPerson!,
          );
        }
        break;
      case VoucherServiceId.checkWithdrawal:
        addItem(
          'نوع السحب',
          'Withdrawal Type',
          isRTL ? 'سحب بشيك' : 'Check Withdrawal',
        );
        final pd = data.paymentDetails;
        if (pd != null) {
          if (pd.checkNumber != null) {
            addItem('رقم الشيك', 'Check No', pd.checkNumber!);
          }
          if (pd.checkDate != null) {
            addItem('تاريخ الشيك', 'Check Date', _fmtDate(pd.checkDate!));
          }
        }
        if (data.party != null) {
          addItem(
            'اسم المستفيد',
            'Payee Name',
            data.party!.displayName(isRTL: isRTL),
          );
        }
        break;
      case VoucherServiceId.atmWithdrawal:
        addItem(
          'نوع السحب',
          'Withdrawal Type',
          isRTL ? 'سحب عبر الصراف' : 'ATM Withdrawal',
        );
        if (atmLocation != null) {
          addItem('موقع الصراف', 'ATM Location', atmLocation!);
        }
        if (maskedCardNumber != null) {
          addItem('رقم البطاقة', 'Card No', maskedCardNumber!);
        }
        final pd = data.paymentDetails;
        if (pd?.transactionId != null) {
          addItem('مرجع العملية', 'Transaction Ref', pd!.transactionId!);
        }
        break;
      default:
        break;
    }
    if (items.isNotEmpty) {
      addInfoSection(
        labelAr: 'تفاصيل السحب',
        labelEn: 'Withdrawal Details',
        items: items,
        columns: 2,
      );
    }
  }

  void _drawPurpose() {
    final text = isRTL
        ? (data.descriptionAr ?? data.description ?? '')
        : (data.description ?? '');
    addSectionHeading('الغرض', 'Purpose');
    addLine(text, font: bodyFont, topMargin: 2);
    addSpace(style.sectionSpacing);
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  List<VoucherSignatory> defaultSignatories() => [
        BankingSignatories.requester(),
        VoucherSignatory.accountant(),
        BankingSignatories.authorizedSignatory(),
      ];
}
