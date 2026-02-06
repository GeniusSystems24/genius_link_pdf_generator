/// Bill Payment Voucher template (Service IDs: 10300–10305).
///
/// Generates vouchers for:
/// - **10300** Utility Bill Payment — electricity, water, gas, phone
/// - **10301** General Bill Payment — miscellaneous bills and dues
/// - **10302** Internet Bill Payment — internet service bills
/// - **10303** Telecom Recharge — mobile operator packages and credit
/// - **10304** Game Credit Recharge — gaming platform credit
/// - **10305** Entertainment Recharge — streaming and entertainment subscriptions
library;

import 'package:flutter/material.dart' as m;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Generates a bill payment voucher PDF page.
///
/// ```dart
/// final voucher = BillPaymentVoucher(
///   config: config,
///   company: companyInfo,
///   data: VoucherData(
///     serviceId: VoucherServiceId.utilityBillPayment,
///     voucherNumber: 'BP-2026-001',
///     voucherDate: DateTime.now(),
///     amount: 850,
///   ),
///   billData: VoucherBillData(
///     providerName: 'Saudi Electricity Company',
///     providerNameAr: 'شركة الكهرباء السعودية',
///     subscriberNumber: '1234567890',
///     serviceType: 'Electricity',
///     serviceTypeAr: 'كهرباء',
///   ),
/// );
/// ```
class BillPaymentVoucher extends GeniusPdfVoucherTemplate {
  BillPaymentVoucher({
    required GeniusPdfConfig config,
    required GeniusPdfCompanyInfo company,
    required VoucherData data,
    required this.billData,
    GeniusPdfVoucherStyle style = const GeniusPdfVoucherStyle(),
  }) : super(config: config, company: company, data: data, style: style);

  /// Bill-specific payment data.
  final VoucherBillData billData;

  @override
  void buildVoucherContent() {
    // Account allocation
    drawAccountEntriesTable();

    // Amount block
    drawAmountBlock();

    // Payment method
    drawPaymentDetails();

    // Service provider info
    _drawProviderInfo();

    // Bill details (varies by subtype)
    _drawBillDetails();

    // Confirmation / transaction reference
    if (billData.confirmationNumber != null) {
      _drawConfirmation();
    }
  }

  void _drawProviderInfo() {
    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Provider',
        labelAr: 'مقدم الخدمة',
        value: billData.displayProvider(isRTL: isRTL),
      ),
      if (billData.subscriberNumber != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Subscriber No',
          labelAr: 'رقم المشترك',
          value: billData.subscriberNumber!,
        ),
    ];

    addInfoSection(
      labelAr: 'مقدم الخدمة',
      labelEn: 'Service Provider',
      items: items,
      columns: 2,
    );
  }

  void _drawBillDetails() {
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
      case VoucherServiceId.utilityBillPayment:
        if (billData.serviceType != null) {
          addItem(
            'نوع الخدمة',
            'Service Type',
            isRTL
                ? (billData.serviceTypeAr ?? billData.serviceType!)
                : billData.serviceType!,
          );
        }
        if (billData.meterNumber != null) {
          addItem('رقم العداد', 'Meter No', billData.meterNumber!);
        }
        if (billData.billingPeriod != null) {
          addItem(
            'فترة الفوترة',
            'Billing Period',
            isRTL
                ? (billData.billingPeriodAr ?? billData.billingPeriod!)
                : billData.billingPeriod!,
          );
        }
        if (billData.consumption != null) {
          final unit = billData.consumptionUnit ?? 'kWh';
          addItem(
            'الاستهلاك',
            'Consumption',
            '${billData.consumption} $unit',
          );
        }
        if (billData.rate != null) {
          addItem('التعرفة', 'Rate', billData.rate!.toStringAsFixed(4));
        }
        break;

      case VoucherServiceId.generalBillPayment:
        if (billData.billNumber != null) {
          addItem('رقم الفاتورة', 'Bill No', billData.billNumber!);
        }
        if (billData.dueDate != null) {
          addItem(
            'تاريخ الاستحقاق',
            'Due Date',
            _fmtDate(billData.dueDate!),
          );
        }
        if (billData.serviceType != null) {
          addItem(
            'نوع الفاتورة',
            'Bill Type',
            isRTL
                ? (billData.serviceTypeAr ?? billData.serviceType!)
                : billData.serviceType!,
          );
        }
        break;

      case VoucherServiceId.internetBillPayment:
        if (billData.planName != null) {
          addItem(
            'الباقة',
            'Plan',
            isRTL
                ? (billData.planNameAr ?? billData.planName!)
                : billData.planName!,
          );
        }
        if (billData.billingPeriod != null) {
          addItem(
            'فترة الفوترة',
            'Billing Period',
            isRTL
                ? (billData.billingPeriodAr ?? billData.billingPeriod!)
                : billData.billingPeriod!,
          );
        }
        break;

      case VoucherServiceId.telecomRecharge:
        if (billData.mobileNumber != null) {
          addItem('رقم الجوال', 'Mobile No', billData.mobileNumber!);
        }
        if (billData.planName != null) {
          addItem(
            'الباقة',
            'Package',
            isRTL
                ? (billData.planNameAr ?? billData.planName!)
                : billData.planName!,
          );
        }
        if (billData.validity != null) {
          addItem(
            'الصلاحية',
            'Validity',
            isRTL
                ? (billData.validityAr ?? billData.validity!)
                : billData.validity!,
          );
        }
        break;

      case VoucherServiceId.gameRecharge:
        if (billData.planName != null) {
          addItem(
            'اللعبة',
            'Game',
            isRTL
                ? (billData.planNameAr ?? billData.planName!)
                : billData.planName!,
          );
        }
        if (billData.serviceType != null) {
          addItem(
            'نوع الرصيد',
            'Credit Type',
            isRTL
                ? (billData.serviceTypeAr ?? billData.serviceType!)
                : billData.serviceType!,
          );
        }
        break;

      case VoucherServiceId.entertainmentRecharge:
        if (billData.planName != null) {
          addItem(
            'المنصة',
            'Platform',
            isRTL
                ? (billData.planNameAr ?? billData.planName!)
                : billData.planName!,
          );
        }
        if (billData.validity != null) {
          addItem(
            'الصلاحية',
            'Validity',
            isRTL
                ? (billData.validityAr ?? billData.validity!)
                : billData.validity!,
          );
        }
        break;

      default:
        break;
    }

    if (items.isNotEmpty) {
      addInfoSection(
        labelAr: 'تفاصيل الفاتورة',
        labelEn: 'Bill Details',
        items: items,
        columns: 2,
      );
    }
  }

  void _drawConfirmation() {
    final items = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Transaction Reference',
        labelAr: 'مرجع العملية',
        value: billData.confirmationNumber!,
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
      labelAr: 'مرجع العملية',
      labelEn: 'Transaction Reference',
      items: items,
      columns: 1,
      styleOverride: highlightStyle,
    );
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  List<VoucherSignatory> defaultSignatories() => [
        BankingSignatories.requester(),
        VoucherSignatory.accountant(),
      ];
}
