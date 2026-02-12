/// Transfer Voucher template (Service IDs: 10200–10203).
///
/// Generates vouchers for:
/// - **10200** Bank Transfer — transfer from one bank account to another
/// - **10201** Inter-Account Transfer — transfer between own accounts
/// - **10202** Electronic Transfer — transfer via electronic platforms
/// - **10203** Currency Exchange — foreign exchange transaction
library;

import 'package:flutter/material.dart' as m;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
    required super.config,
    required super.company,
    required super.data,
    required this.transferData,
    super.style,
  });

  /// Transfer-specific data.
  final VoucherTransferData transferData;

  @override
  void buildVoucherContent() {
    // Account allocation
    drawAccountEntriesTable();

    // Amount block
    drawAmountBlock();

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

    // Purpose / description
    if (data.description != null || data.descriptionAr != null) {
      _drawPurpose();
    }
  }

  void _drawAccountBlock({
    required String labelAr,
    required String labelEn,
    required VoucherBankInfo account,
  }) {
    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Bank',
        labelAr: 'البنك',
        value: account.displayBankName(isRTL: isRTL),
      ),
      if (account.branchName != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Branch',
          labelAr: 'الفرع',
          value: isRTL
              ? (account.branchNameAr ?? account.branchName!)
              : account.branchName!,
        ),
      if (account.accountNumber != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Account No',
          labelAr: 'رقم الحساب',
          value: account.accountNumber!,
        ),
      if (account.iban != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'IBAN',
          labelAr: 'الآيبان',
          value: account.iban!,
        ),
      if (account.swiftCode != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'SWIFT',
          labelAr: 'سويفت',
          value: account.swiftCode!,
        ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Currency',
        labelAr: 'العملة',
        value: account.currency,
      ),
      if (account.balanceBefore != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Balance Before',
          labelAr: 'الرصيد قبل',
          value: _fmtNum(account.balanceBefore!),
        ),
    ];

    addInfoSection(
      labelAr: labelAr,
      labelEn: labelEn,
      items: items,
      columns: 2,
    );
  }

  void _drawTransferDetails() {
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
      case VoucherServiceId.bankTransfer:
        if (transferData.beneficiaryName != null) {
          addItem(
            'اسم المستفيد',
            'Beneficiary',
            isRTL
                ? (transferData.beneficiaryNameAr ??
                    transferData.beneficiaryName!)
                : transferData.beneficiaryName!,
          );
        }
        if (data.paymentDetails?.transferReference != null) {
          addItem(
            'مرجع التحويل',
            'Transfer Ref',
            data.paymentDetails!.transferReference!,
          );
        }
        break;
      case VoucherServiceId.interAccountTransfer:
        addItem(
          'نوع التحويل',
          'Transfer Type',
          isRTL ? 'تحويل بين حسابات' : 'Inter-Account Transfer',
        );
        break;
      case VoucherServiceId.electronicTransfer:
        if (transferData.platform != null) {
          addItem('المنصة', 'Platform', transferData.platform!);
        }
        if (data.paymentDetails?.transactionId != null) {
          addItem(
            'رقم العملية',
            'Transaction ID',
            data.paymentDetails!.transactionId!,
          );
        }
        if (transferData.processingTime != null) {
          addItem(
            'وقت المعالجة',
            'Processing Time',
            transferData.processingTime!,
          );
        }
        break;
      case VoucherServiceId.currencyExchange:
        final pd = data.paymentDetails;
        if (pd != null) {
          if (pd.sourceCurrency != null) {
            addItem('عملة المصدر', 'Source Currency', pd.sourceCurrency!);
          }
          if (pd.targetCurrency != null) {
            addItem('العملة المستهدفة', 'Target Currency', pd.targetCurrency!);
          }
          if (pd.exchangeRate != null) {
            addItem(
              'سعر الصرف',
              'Exchange Rate',
              pd.exchangeRate!.toStringAsFixed(4),
            );
          }
          if (pd.sourceAmount != null) {
            addItem(
                'المبلغ الأصلي', 'Source Amount', _fmtNum(pd.sourceAmount!));
          }
          if (pd.targetAmount != null) {
            addItem(
                'المبلغ المحوّل', 'Target Amount', _fmtNum(pd.targetAmount!));
          }
        }
        break;
      default:
        break;
    }
    if (items.isNotEmpty) {
      addInfoSection(
        labelAr: 'تفاصيل التحويل',
        labelEn: 'Transfer Details',
        items: items,
        columns: 2,
      );
    }
  }

  void _drawFeesBlock() {
    final items = <GeniusPdfLabeledValue>[];
    if (transferData.transferFee != null) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Transfer Fee',
        labelAr: 'رسوم التحويل',
        value: '${_fmtNum(transferData.transferFee!)} ${data.currency}',
      ));
    }
    if (transferData.commission != null) {
      items.add(GeniusPdfLabeledValue(
        config: config,
        label: 'Commission',
        labelAr: 'العمولة',
        value: '${_fmtNum(transferData.commission!)} ${data.currency}',
      ));
    }

    if (items.isNotEmpty) {
      addInfoSection(
        labelAr: 'الرسوم',
        labelEn: 'Fees',
        items: items,
        columns: 2,
      );
    }

    if (transferData.netAmount != null) {
      final highlightStyle = GeniusPdfInfoBoxStyle(
        backgroundColor: style.amountHighlightColor,
        borderStyle: GeniusPdfBorderStyle.all(
          color: style.primaryColor,
          width: style.borderWidth,
        ),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
        labelStyle: GeniusPdfTextStyle(
          fontSize: style.bodyFontSize,
          fontWeight: m.FontWeight.w600,
          color: style.primaryColor,
        ),
        valueStyle: GeniusPdfTextStyle(
          fontSize: style.bodyFontSize,
          fontWeight: m.FontWeight.bold,
          color: style.primaryColor,
        ),
        labelAlign: GeniusPdfTextAlign.start,
        valueAlign: GeniusPdfTextAlign.end,
        labelValueLayout: GeniusPdfLabelValueLayout.horizontal,
        showDivider: false,
      );

      addInfoSection(
        labelAr: 'صافي المبلغ',
        labelEn: 'Net Amount',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: 'Net Amount',
            labelAr: 'صافي المبلغ',
            value: '${_fmtNum(transferData.netAmount!)} ${data.currency}',
          ),
        ],
        columns: 1,
        styleOverride: highlightStyle,
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

  String _fmtNum(double n) {
    if (n == n.truncateToDouble()) {
      return n.truncate().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
    }
    return n
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');
  }

  @override
  List<VoucherSignatory> defaultSignatories() => [
        BankingSignatories.requester(),
        BankingSignatories.treasury(),
        VoucherSignatory.manager(),
      ];
}
