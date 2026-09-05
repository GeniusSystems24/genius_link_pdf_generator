import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/shared/data/sample_data.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart' show geniusPdfConfig;

GeniusPdfConfig createTemplatesDemoConfig({required bool isRtl}) {
  return geniusPdfConfig.copyWith(
    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
  );
}

ModernSalesVoucher buildModernSalesVoucher({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return ModernSalesVoucher(
    config: config,
    company: SampleData.companyInfo,
    data: VoucherData(
// ... existing code ...

      serviceId: VoucherServiceId.cashSale,
      voucherNumber: 'INV-2026-001',
      voucherDate: DateTime.now(),
      amount: 4500.00,
      currency: 'SAR',
      party: VoucherParty(
        name: 'Tech Solutions Ltd',
        nameAr: 'شركة الحلول التقنية',
        vatNumber: '300012345600003',
        address: 'Riyadh, Olaya St.',
        addressAr: 'الرياض، شارع العليا',
      ),
      items: [
        VoucherLineItem(
          lineNumber: 1,
          description: 'Software License',
          descriptionAr: 'رخصة برمجيات',
          quantity: 1,
          unitPrice: 1500.00,
          totalAmount: 1500.00,
          unit: 'Lic',
          unitAr: 'رخصة',
        ),
        VoucherLineItem(
          lineNumber: 2,
          description: 'Consulting Services',
          descriptionAr: 'خدمات استشارية',
          quantity: 10,
          unitPrice: 300.00,
          totalAmount: 3000.00,
          unit: 'Hour',
          unitAr: 'ساعة',
        )
      ],
    ),
    tradeData: VoucherTradeData(
      salesperson: 'Ahmed Al-Sales',
      subtotal: 4500.00,
      grandTotal: 4500.00,
    ),
  );
}

ModernPurchaseVoucher buildModernPurchaseVoucher({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return ModernPurchaseVoucher(
    config: config,
    company: SampleData.companyInfo,
    data: VoucherData(
      serviceId: VoucherServiceId.creditPurchase,
      voucherNumber: 'PUR-2026-088',
      voucherDate: DateTime.now(),
      amount: 12500.00,
      currency: 'SAR',
      party: VoucherParty(
        name: 'Mega Suppliers Co',
        nameAr: 'شركة الموردين الكبرى',
        vatNumber: '311122233300003',
        address: 'Jeddah, Port Road',
        addressAr: 'جدة، طريق الميناء',
      ),
      items: [
        VoucherLineItem(
          lineNumber: 1,
          itemCode: 'HW-001',
          description: 'Server Rack 42U',
          descriptionAr: 'خزانة سيرفر 42 وحدة',
          quantity: 2,
          unitPrice: 5000.00,
          totalAmount: 10000.00,
        ),
        VoucherLineItem(
          lineNumber: 2,
          itemCode: 'Net-SW',
          description: 'Network Switch 24-Port',
          descriptionAr: 'محول شبكة 24 منفذ',
          quantity: 5,
          unitPrice: 500.00,
          totalAmount: 2500.00,
        ),
      ],
    ),
    tradeData: VoucherTradeData(
      orderNumber: 'PO-998877',
      orderDate: DateTime.now().subtract(const Duration(days: 5)),
      subtotal: 12500.00,
      grandTotal: 12500.00,
      warehouseName: 'Main Warehouse',
      warehouseNameAr: 'المستودع الرئيسي',
    ),
  );
}

ModernSalesReturnVoucher buildModernSalesReturnVoucher({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return ModernSalesReturnVoucher(
    config: config,
    company: SampleData.companyInfo,
    data: VoucherData(
      serviceId: VoucherServiceId.cashSalesReturn,
      voucherNumber: 'RET-2026-005',
      voucherDate: DateTime.now(),
      amount: 1500.00,
      currency: 'SAR',
      party: VoucherParty(
        name: 'Tech Solutions Ltd',
        nameAr: 'شركة الحلول التقنية',
        vatNumber: '300012345600003',
      ),
      items: [
        VoucherLineItem(
          lineNumber: 1,
          description: 'Software License (Refund)',
          descriptionAr: 'رخصة برمجيات (استرجع)',
          quantity: 1,
          unitPrice: 1500.00,
          totalAmount: 1500.00,
        ),
      ],
    ),
    tradeData: VoucherTradeData(
      originalVoucherNumber: 'INV-2026-001',
      originalVoucherDate: DateTime.now().subtract(const Duration(days: 2)),
      returnReason: VoucherReturnReason.defective,
      returnReasonDescription: 'License key not working',
      returnReasonDescriptionAr: 'مفتاح الرخصة لا يعمل',
      refundAmount: 1500.00,
      refundMethod: 'Cash',
      refundMethodAr: 'نقداً',
    ),
  );
}

ModernPurchaseReturnVoucher buildModernPurchaseReturnVoucher(
    {required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return ModernPurchaseReturnVoucher(
    config: config,
    company: SampleData.companyInfo,
    data: VoucherData(
      serviceId: VoucherServiceId.creditPurchaseReturn,
      voucherNumber: 'PRET-2026-002',
      voucherDate: DateTime.now(),
      amount: 500.00,
      currency: 'SAR',
      party: VoucherParty(
        name: 'Mega Suppliers Co',
        nameAr: 'شركة الموردين الكبرى',
      ),
      items: [
        VoucherLineItem(
          lineNumber: 1,
          itemCode: 'Net-SW',
          description: 'Network Switch 24-Port',
          descriptionAr: 'محول شبكة 24 منفذ',
          quantity: 1,
          unitPrice: 500.00,
          totalAmount: 500.00,
        ),
      ],
    ),
    tradeData: VoucherTradeData(
      originalVoucherNumber: 'PUR-2026-088',
      returnReason: VoucherReturnReason.wrongItem,
      warehouseName: 'Main Warehouse',
      warehouseNameAr: 'المستودع الرئيسي',
    ),
  );
}

PaymentVoucher buildB5PaymentVoucher({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl).copyWith(
    pageSize: GeniusPdfPageSize.b5,
  );

  return PaymentVoucher(
      config: config,
      company: SampleData.companyInfo,
      data: VoucherData(
        serviceId: VoucherServiceId.cashPayment,
        voucherNumber: 'PAY-2026-B5',
        voucherDate: DateTime.now(),
        amount: 55400.00,
        currency: 'YR',
        currencyAr: '���� ����',
        party: VoucherParty(
          name: 'Hatem Hafiz Allah Yahya Al-Jassar',
          nameAr: '���� ��� ���� ���� ������',
        ),
        description:
            'Transfer Amount Written: Fifty-five thousand four hundred Yemeni Rials',
        descriptionAr:
            '���� ������� �����: ���� ������ ��� ��������� ���� ���� �� ���',
        accountEntries: [
          VoucherAccountEntry(
              accountCode: '772874567',
              accountName: 'Ahmed Suleiman Ali Zaaim Qatab',
              accountNameAr: '���� ������ ��� ���� ����',
              debitAmount: 55400,
              description: 'Receiver Phone / ����� ������')
        ],
      ),
      deductions: [
        PaymentDeduction(
            name: 'Transfer Fee', nameAr: '��� �������', amount: 400),
        PaymentDeduction(name: 'Service Tax', nameAr: '����� ����', amount: 50),
      ]);
}

// BEGIN MODERN VOUCHER PREVIEW GENERATORS

/// Generates the Modern Sales Voucher example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateModernSalesVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildModernSalesVoucher(
    isRtl: config.textDirection == TextDirection.rtl,
  );

  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

/// Generates the Modern Purchase Voucher example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateModernPurchaseVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildModernPurchaseVoucher(
    isRtl: config.textDirection == TextDirection.rtl,
  );

  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

/// Generates the Modern Sales Return example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateModernSalesReturnVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildModernSalesReturnVoucher(
    isRtl: config.textDirection == TextDirection.rtl,
  );

  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

/// Generates the Modern Purchase Return example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateModernPurchaseReturnVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildModernPurchaseReturnVoucher(
    isRtl: config.textDirection == TextDirection.rtl,
  );

  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

/// Generates the B5 Payment Voucher example for inline PDF preview.
///
/// The returned bytes are the exact bytes shown by `GeniusPdfPreviewWidget`
/// and later reused by the screen's **Open PDF** action.
Future<Uint8List> generateB5PaymentVoucherPdf(GeniusPdfConfig config) async {
  final builder = buildB5PaymentVoucher(
    isRtl: config.textDirection == TextDirection.rtl,
  );

  try {
    return Uint8List.fromList(builder.generate());
  } finally {
    builder.dispose();
  }
}

// END MODERN VOUCHER PREVIEW GENERATORS
