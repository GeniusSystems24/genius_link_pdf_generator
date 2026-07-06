/// Incoming Remittance Voucher template (Service IDs: 10450-10451, 10550-10551).
///
/// Generates vouchers for:
/// - **10450** Domestic Personal Incoming - personal remittance received locally
/// - **10451** Domestic Commercial Incoming - commercial remittance received locally
/// - **10550** International Personal Incoming - personal remittance from abroad
/// - **10551** International Commercial Incoming - commercial remittance from abroad
library;

import 'package:flutter/material.dart' as m;
import '../voucher_support.dart';

/// Generates an incoming remittance voucher PDF page.
///
/// ```dart
/// final voucher = RemittanceIncomingVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.internationalPersonalIncoming,
///     voucherNumber: 'RI-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 3500,
///   ),
///   remittanceData: VoucherRemittanceData(
///     senderName: 'Ali Hassan',
///     senderCountry: 'Egypt',
///     beneficiaryName: 'Mohammed Al-Ahmed',
///     disbursementMethod: 'To Account',
///   ),
/// );
/// ```
class RemittanceIncomingVoucher extends GeniusPdfVoucherTemplate {
  RemittanceIncomingVoucher({
    required super.config,
    required super.company,
    required super.data,
    required this.remittanceData,
    super.style,
  });

  /// Remittance-specific data.
  final VoucherRemittanceData remittanceData;

  bool get _isInternational => remittanceData.isInternational(data.serviceId);

  @override
  void buildVoucherContent() {
    // Account allocation
    drawAccountEntriesTable();

    // Net amount credited
    drawAmountBlock();

    // Domestic / International badge
    _drawTypeBadge();

    // Sender info
    _drawSenderInfo();

    // Beneficiary info
    _drawBeneficiaryInfo();

    // Remittance details (exchange info for international)
    if (_isInternational) {
      _drawExchangeDetails();
    }

    // Fees
    _drawFees();

    // Disbursement method
    if (remittanceData.disbursementMethod != null) {
      _drawDisbursement();
    }
  }

  void _drawTypeBadge() {
    final badgeText = _isInternational
        ? (isRTL ? 'دولية' : 'International')
        : (isRTL ? 'محلية' : 'Domestic');
    final badgeColor = _isInternational
        ? const m.Color(0xFF1565C0)
        : const m.Color(0xFF2E7D32);

    final richText = GeniusPdfRichTextBuilder(
      config: config,
      paragraphAlignment: GeniusPdfParagraphAlignment.center,
    )
        .badge(
          badgeText,
          backgroundColor: badgeColor,
          color: const m.Color(0xFFFFFFFF),
        )
        .build();

    addRichText(richText, spacing: 0);
    addSpace(style.sectionSpacing);
  }

  void _drawSenderInfo() {
    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Name',
        labelAr: 'الاسم',
        value: isRTL
            ? (remittanceData.senderNameAr ?? remittanceData.senderName)
            : remittanceData.senderName,
      ),
      if (remittanceData.senderCountry != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Country',
          labelAr: 'الدولة',
          value: isRTL
              ? (remittanceData.senderCountryAr ??
                  remittanceData.senderCountry!)
              : remittanceData.senderCountry!,
        ),
      if (remittanceData.senderPhone != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Phone',
          labelAr: 'الهاتف',
          value: remittanceData.senderPhone!,
        ),
      if (_isInternational && remittanceData.beneficiaryBankName != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Source Bank',
          labelAr: 'بنك المصدر',
          value: isRTL
              ? (remittanceData.beneficiaryBankNameAr ??
                  remittanceData.beneficiaryBankName!)
              : remittanceData.beneficiaryBankName!,
        ),
    ];

    addInfoSection(
      labelAr: 'معلومات المرسل',
      labelEn: 'Sender Information',
      items: items,
      columns: 2,
    );
  }

  void _drawBeneficiaryInfo() {
    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Name',
        labelAr: 'الاسم',
        value: isRTL
            ? (remittanceData.beneficiaryNameAr ??
                remittanceData.beneficiaryName)
            : remittanceData.beneficiaryName,
      ),
      if (remittanceData.beneficiaryIdNumber != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'ID No',
          labelAr: 'رقم الهوية',
          value: remittanceData.beneficiaryIdNumber!,
        ),
      if (remittanceData.beneficiaryPhone != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Phone',
          labelAr: 'الهاتف',
          value: remittanceData.beneficiaryPhone!,
        ),
      if (remittanceData.beneficiaryAccountNumber != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Account No',
          labelAr: 'رقم الحساب',
          value: remittanceData.beneficiaryAccountNumber!,
        ),
      if (remittanceData.beneficiaryIban != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'IBAN',
          labelAr: 'الآيبان',
          value: remittanceData.beneficiaryIban!,
        ),
    ];

    addInfoSection(
      labelAr: 'معلومات المستفيد',
      labelEn: 'Beneficiary Information',
      items: items,
      columns: 2,
    );
  }

  void _drawExchangeDetails() {
    final items = <GeniusPdfLabeledValue>[
      if (remittanceData.sourceCurrency != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Original Currency',
          labelAr: 'العملة الأصلية',
          value: remittanceData.sourceCurrency!,
        ),
      if (remittanceData.targetCurrency != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Converted Currency',
          labelAr: 'العملة المحولة',
          value: remittanceData.targetCurrency!,
        ),
      if (remittanceData.exchangeRate != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Exchange Rate',
          labelAr: 'سعر الصرف',
          value: remittanceData.exchangeRate!.toStringAsFixed(4),
        ),
      if (remittanceData.sourceAmount != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Original Amount',
          labelAr: 'المبلغ الأصلي',
          value: _fmtNum(remittanceData.sourceAmount!),
        ),
      if (remittanceData.targetAmount != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Converted Amount',
          labelAr: 'المبلغ المحول',
          value: _fmtNum(remittanceData.targetAmount!),
        ),
      if (remittanceData.correspondentBank != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'SWIFT Ref',
          labelAr: 'سويفت المرجعي',
          value: isRTL
              ? (remittanceData.correspondentBankAr ??
                  remittanceData.correspondentBank!)
              : remittanceData.correspondentBank!,
        ),
    ];

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'تفاصيل التحويل',
      labelEn: 'Exchange Details',
      items: items,
      columns: 2,
    );
  }

  void _drawFees() {
    if (remittanceData.transferFee == null &&
        remittanceData.exchangeMargin == null) {
      return;
    }

    final items = <GeniusPdfLabeledValue>[
      if (remittanceData.transferFee != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Receiving Fee',
          labelAr: 'رسوم الاستلام',
          value: '${_fmtNum(remittanceData.transferFee!)} ${data.currency}',
        ),
      if (remittanceData.exchangeMargin != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Exchange Difference',
          labelAr: 'فرق الصرف',
          value: '${_fmtNum(remittanceData.exchangeMargin!)} ${data.currency}',
        ),
    ];

    addInfoSection(
      labelAr: 'الرسوم',
      labelEn: 'Fees',
      items: items,
      columns: 2,
    );
  }

  void _drawDisbursement() {
    final text = isRTL
        ? (remittanceData.disbursementMethodAr ??
            remittanceData.disbursementMethod!)
        : remittanceData.disbursementMethod!;

    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Method',
        labelAr: 'الطريقة',
        value: text,
      ),
    ];

    final highlightStyle = GeniusPdfInfoBoxStyle(
      backgroundColor: style.amountHighlightColor,
      borderStyle: GeniusPdfBorderStyle.all(
        color: style.primaryColor,
        width: style.borderWidth,
      ),
      padding: const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
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
      labelAr: 'طريقة الصرف',
      labelEn: 'Disbursement Method',
      items: items,
      columns: 1,
      styleOverride: highlightStyle,
    );
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
        RemittanceSignatories.beneficiary(),
        BankingSignatories.operator(),
        VoucherSignatory.manager(),
      ];
}
