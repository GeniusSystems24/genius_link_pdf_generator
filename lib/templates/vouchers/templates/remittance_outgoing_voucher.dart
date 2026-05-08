/// Outgoing Remittance Voucher template (Service IDs: 10400–10401, 10500–10501).
///
/// Generates vouchers for:
/// - **10400** Domestic Personal Outgoing — personal remittance within the country
/// - **10401** Domestic Commercial Outgoing — commercial remittance within the country
/// - **10500** International Personal Outgoing — personal remittance abroad
/// - **10501** International Commercial Outgoing — commercial remittance abroad
library;

import 'package:flutter/material.dart' as m;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Generates an outgoing remittance voucher PDF page.
///
/// ```dart
/// final voucher = RemittanceOutgoingVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.internationalPersonalOutgoing,
///     voucherNumber: 'RO-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 5000,
///   ),
///   remittanceData: VoucherRemittanceData(
///     senderName: 'Mohammed Al-Ahmed',
///     beneficiaryName: 'Ali Hassan',
///     beneficiaryCountry: 'Egypt',
///   ),
/// );
/// ```
class RemittanceOutgoingVoucher extends GeniusPdfVoucherTemplate {
  RemittanceOutgoingVoucher({
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

    // Amount block
    drawAmountBlock();

    // Domestic / International badge
    _drawTypeBadge();

    // Sender info
    _drawSenderInfo();

    // Beneficiary info
    _drawBeneficiaryInfo();

    // Remittance details
    _drawRemittanceDetails();

    // Fees
    _drawFees();

    // Compliance
    if (remittanceData.amlReference != null ||
        remittanceData.purposeCode != null) {
      _drawCompliance();
    }

    // Tracking
    if (remittanceData.trackingNumber != null) {
      _drawTracking();
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
      if (remittanceData.senderIdNumber != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'ID No',
          labelAr: 'رقم الهوية',
          value: remittanceData.senderIdNumber!,
        ),
      if (remittanceData.senderIdType != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'ID Type',
          labelAr: 'نوع الهوية',
          value: isRTL
              ? (remittanceData.senderIdTypeAr ?? remittanceData.senderIdType!)
              : remittanceData.senderIdType!,
        ),
      if (remittanceData.senderPhone != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Phone',
          labelAr: 'الهاتف',
          value: remittanceData.senderPhone!,
        ),
      if (remittanceData.senderAddress != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Address',
          labelAr: 'العنوان',
          value: isRTL
              ? (remittanceData.senderAddressAr ??
                  remittanceData.senderAddress!)
              : remittanceData.senderAddress!,
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
      if (remittanceData.beneficiaryCountry != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Country',
          labelAr: 'الدولة',
          value: isRTL
              ? (remittanceData.beneficiaryCountryAr ??
                  remittanceData.beneficiaryCountry!)
              : remittanceData.beneficiaryCountry!,
        ),
      if (remittanceData.beneficiaryAddress != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Address',
          labelAr: 'العنوان',
          value: isRTL
              ? (remittanceData.beneficiaryAddressAr ??
                  remittanceData.beneficiaryAddress!)
              : remittanceData.beneficiaryAddress!,
        ),
      if (remittanceData.beneficiaryBankName != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Bank',
          labelAr: 'البنك',
          value: isRTL
              ? (remittanceData.beneficiaryBankNameAr ??
                  remittanceData.beneficiaryBankName!)
              : remittanceData.beneficiaryBankName!,
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
      if (_isInternational && remittanceData.beneficiarySwiftCode != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'SWIFT',
          labelAr: 'سويفت',
          value: remittanceData.beneficiarySwiftCode!,
        ),
      if (_isInternational && remittanceData.correspondentBank != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Correspondent Bank',
          labelAr: 'البنك المراسل',
          value: isRTL
              ? (remittanceData.correspondentBankAr ??
                  remittanceData.correspondentBank!)
              : remittanceData.correspondentBank!,
        ),
    ];

    addInfoSection(
      labelAr: 'معلومات المستفيد',
      labelEn: 'Beneficiary Information',
      items: items,
      columns: 2,
    );
  }

  void _drawRemittanceDetails() {
    if (!_isInternational) return; // domestic has no exchange details

    final items = <GeniusPdfLabeledValue>[
      if (remittanceData.sourceCurrency != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Source Currency',
          labelAr: 'العملة المصدر',
          value: remittanceData.sourceCurrency!,
        ),
      if (remittanceData.targetCurrency != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Target Currency',
          labelAr: 'العملة المستهدفة',
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
          label: 'Source Amount',
          labelAr: 'المبلغ الأصلي',
          value: _fmtNum(remittanceData.sourceAmount!),
        ),
      if (remittanceData.targetAmount != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Target Amount',
          labelAr: 'المبلغ المحوّل',
          value: _fmtNum(remittanceData.targetAmount!),
        ),
    ];

    addInfoSection(
      labelAr: 'تفاصيل التحويل',
      labelEn: 'Remittance Details',
      items: items,
      columns: 2,
    );
  }

  void _drawFees() {
    if (remittanceData.transferFee == null &&
        remittanceData.exchangeMargin == null &&
        remittanceData.totalCost == null) {
      return;
    }

    final items = <GeniusPdfLabeledValue>[
      if (remittanceData.transferFee != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Transfer Fee',
          labelAr: 'رسوم التحويل',
          value: '${_fmtNum(remittanceData.transferFee!)} ${data.currency}',
        ),
      if (remittanceData.exchangeMargin != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Exchange Margin',
          labelAr: 'هامش الصرف',
          value: '${_fmtNum(remittanceData.exchangeMargin!)} ${data.currency}',
        ),
      if (remittanceData.totalCost != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Total Cost',
          labelAr: 'التكلفة الإجمالية',
          value: '${_fmtNum(remittanceData.totalCost!)} ${data.currency}',
        ),
    ];

    addInfoSection(
      labelAr: 'الرسوم',
      labelEn: 'Fees',
      items: items,
      columns: 2,
    );
  }

  void _drawCompliance() {
    final items = <GeniusPdfLabeledValue>[
      if (remittanceData.purposeCode != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Purpose Code',
          labelAr: 'رمز الغرض',
          value: remittanceData.purposeCode!,
        ),
      if (remittanceData.purposeDescription != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Purpose',
          labelAr: 'الغرض',
          value: isRTL
              ? (remittanceData.purposeDescriptionAr ??
                  remittanceData.purposeDescription!)
              : remittanceData.purposeDescription!,
        ),
      if (remittanceData.amlReference != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'AML Reference',
          labelAr: 'مرجع مكافحة غسل الأموال',
          value: remittanceData.amlReference!,
        ),
    ];

    if (items.isEmpty) return;

    addInfoSection(
      labelAr: 'الامتثال',
      labelEn: 'Compliance',
      items: items,
      columns: 2,
    );
  }

  void _drawTracking() {
    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Tracking No',
        labelAr: 'رقم التتبع',
        value: remittanceData.trackingNumber!,
      ),
      if (remittanceData.expectedDeliveryDate != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Expected Delivery',
          labelAr: 'التسليم المتوقع',
          value: _fmtDate(remittanceData.expectedDeliveryDate!),
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
      labelAr: 'التتبع',
      labelEn: 'Tracking',
      items: items,
      columns: items.length > 1 ? 2 : 1,
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

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  List<VoucherSignatory> defaultSignatories() => [
        RemittanceSignatories.sender(),
        BankingSignatories.operator(),
        RemittanceSignatories.complianceOfficer(),
        VoucherSignatory.manager(),
      ];
}
