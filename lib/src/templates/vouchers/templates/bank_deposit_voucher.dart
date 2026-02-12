/// Bank Deposit Voucher template (Service IDs: 10000–10002).
///
/// Generates vouchers for:
/// - **10000** Cash Deposit — cash deposited into bank account
/// - **10001** Check Deposit — check deposited into bank account
/// - **10002** Electronic Deposit — electronic transfer deposit
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
    required super.config,
    required super.company,
    required super.data,
    required this.bankInfo,
    super.style,
  });

  /// Bank account information for the deposit.
  final VoucherBankInfo bankInfo;

  @override
  void buildVoucherContent() {
    // Account allocation
    drawAccountEntriesTable();

    // Amount block
    drawAmountBlock();

    // Bank information
    _drawBankInfo();

    // Deposit details (varies by subtype)
    _drawDepositDetails();

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

  void _drawDepositDetails() {
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
      case VoucherServiceId.cashDeposit:
        addItem(
          'نوع الإيداع',
          'Deposit Type',
          isRTL ? 'إيداع نقدي' : 'Cash Deposit',
        );
        if (data.paymentDetails?.denominations != null) {
          // Denomination breakdown will be drawn as a table below
        }
        break;
      case VoucherServiceId.checkDeposit:
        addItem(
          'نوع الإيداع',
          'Deposit Type',
          isRTL ? 'إيداع شيك' : 'Check Deposit',
        );
        final pd = data.paymentDetails;
        if (pd != null) {
          if (pd.checkNumber != null) {
            addItem('رقم الشيك', 'Check No', pd.checkNumber!);
          }
          if (pd.draweeBankName != null) {
            addItem('البنك المسحوب عليه', 'Drawee Bank', pd.draweeBankName!);
          }
          if (pd.checkDate != null) {
            addItem('تاريخ الشيك', 'Check Date', _fmtDate(pd.checkDate!));
          }
          if (pd.dueDate != null) {
            addItem('تاريخ الاستحقاق', 'Due Date', _fmtDate(pd.dueDate!));
          }
        }
        if (data.party != null) {
          addItem(
            'اسم المحرر',
            'Drawer Name',
            data.party!.displayName(isRTL: isRTL),
          );
        }
        break;
      case VoucherServiceId.electronicDeposit:
        addItem(
          'نوع الإيداع',
          'Deposit Type',
          isRTL ? 'إيداع إلكتروني' : 'Electronic Deposit',
        );
        final pd = data.paymentDetails;
        if (pd != null) {
          if (pd.transferReference != null) {
            addItem('مرجع التحويل', 'Transfer Ref', pd.transferReference!);
          }
          if (pd.transactionId != null) {
            addItem('رقم العملية', 'Transaction ID', pd.transactionId!);
          }
          if (pd.gatewayName != null) {
            addItem('مصدر التحويل', 'Transfer Source', pd.gatewayName!);
          }
        }
        break;
      default:
        break;
    }
    if (items.isNotEmpty) {
      addInfoSection(
        labelAr: 'تفاصيل الإيداع',
        labelEn: 'Deposit Details',
        items: items,
        columns: 2,
      );
    }

    // Denomination table for cash deposit
    if (data.serviceId == VoucherServiceId.cashDeposit &&
        data.paymentDetails?.denominations != null &&
        data.paymentDetails!.denominations!.isNotEmpty) {
      _drawDenominationTable();
    }
  }

  void _drawDenominationTable() {
    final denominations = data.paymentDetails!.denominations!;
    final sortedKeys = denominations.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    drawItemsTable(
      labelAr: 'تفصيل الفئات النقدية',
      labelEn: 'Cash Denomination Breakdown',
      columns: [
        const GeniusPdfGridColumn(
          id: 'denom',
          title: 'Denomination',
          titleAr: 'الفئة',
          width: 120,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'count',
          title: 'Count',
          titleAr: 'العدد',
          width: 80,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn.currency(
          id: 'total',
          title: 'Total',
          titleAr: 'المجموع',
          width: 120,
          currencySymbol: '',
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
          'total': denominations.entries
              .fold<double>(0, (s, e) => s + e.key * e.value),
        }),
      ],
    );
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

  String _fmtNum(double n) {
    if (n == n.truncateToDouble()) return n.truncate().toString();
    return n.toStringAsFixed(2);
  }

  @override
  List<VoucherSignatory> defaultSignatories() => [
        BankingSignatories.depositor(),
        VoucherSignatory.cashier(),
        BankingSignatories.bankTeller(),
      ];
}
