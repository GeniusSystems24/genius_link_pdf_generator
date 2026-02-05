/// Trade Voucher Demo — builds 4 trade vouchers in one batch PDF.
///
/// Demonstrates PurchaseVoucher, SalesVoucher,
/// PurchaseReturnVoucher, and SalesReturnVoucher templates.
library;

import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a demo PDF containing 4 trade vouchers in a single batch.
List<int> buildTradeVoucherDemoReport({
  required GeniusPdfConfig config,
}) {
  final company = GeniusPdfCompanyInfo(
    name: 'Genius Systems',
    nameAr: 'أنظمة الجينيس',
    vatNumber: '311234567890003',
    crNumber: '1010123456',
  );

  // ── 1. Credit Purchase ──
  final creditPurchase = PurchaseVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.creditPurchase,
      voucherNumber: 'PU-2026-0042',
      voucherDate: DateTime(2026, 2, 5),
      amount: 28750,
      description: 'Office equipment and supplies procurement',
      descriptionAr: 'شراء معدات ولوازم مكتبية',
      party: const VoucherParty(
        name: 'Modern Office Supplies',
        nameAr: 'لوازم المكاتب الحديثة',
        code: 'SUP-1078',
        vatNumber: '300987654321003',
        phone: '+966 55 123 4567',
      ),
      items: [
        const VoucherLineItem(
          lineNumber: 1,
          itemCode: 'OFF-001',
          description: 'Ergonomic Office Chair',
          descriptionAr: 'كرسي مكتبي مريح',
          quantity: 5,
          unit: 'Pcs',
          unitAr: 'قطعة',
          unitPrice: 2500,
          discountPercent: 10,
          discountAmount: 1250,
          taxRate: 15,
          taxAmount: 1687.50,
          totalAmount: 12937.50,
        ),
        const VoucherLineItem(
          lineNumber: 2,
          itemCode: 'OFF-015',
          description: 'Standing Desk 160cm',
          descriptionAr: 'مكتب قائم 160 سم',
          quantity: 3,
          unit: 'Pcs',
          unitAr: 'قطعة',
          unitPrice: 3800,
          discountAmount: 570,
          taxRate: 15,
          taxAmount: 1483.50,
          totalAmount: 12382.50,
        ),
        const VoucherLineItem(
          lineNumber: 3,
          itemCode: 'OFF-042',
          description: 'Printer Paper A4 (500 sheets)',
          descriptionAr: 'ورق طابعة A4 (500 ورقة)',
          quantity: 100,
          unit: 'Pack',
          unitAr: 'رزمة',
          unitPrice: 22,
          taxRate: 15,
          taxAmount: 330,
          totalAmount: 2530,
        ),
        const VoucherLineItem(
          lineNumber: 4,
          itemCode: 'OFF-088',
          description: 'Wireless Mouse & Keyboard Set',
          descriptionAr: 'طقم ماوس ولوحة مفاتيح لاسلكية',
          quantity: 10,
          unit: 'Set',
          unitAr: 'طقم',
          unitPrice: 85,
          taxRate: 15,
          taxAmount: 127.50,
          totalAmount: 977.50,
        ),
      ],
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1500',
          accountName: 'Office Equipment',
          accountNameAr: 'معدات مكتبية',
          debitAmount: 25000,
        ),
        const VoucherAccountEntry(
          accountCode: '1150',
          accountName: 'Input VAT',
          accountNameAr: 'ضريبة مدخلات',
          debitAmount: 3750,
        ),
        const VoucherAccountEntry(
          accountCode: '2100',
          accountName: 'Accounts Payable',
          accountNameAr: 'حسابات الدائنين',
          creditAmount: 28750,
        ),
      ],
    ),
    tradeData: VoucherTradeData(
      orderNumber: 'PO-2026-0042',
      orderDate: DateTime(2026, 2, 1),
      subtotal: 25000,
      totalDiscount: 1820,
      taxableAmount: 25000,
      vatRate: 15,
      vatAmount: 3750,
      grandTotal: 28750,
      dueDate: DateTime(2026, 3, 7),
      creditPeriodDays: 30,
      warehouseName: 'Main Warehouse',
      warehouseNameAr: 'المستودع الرئيسي',
      receivedBy: 'Khalid Al-Otaibi',
      receivedByAr: 'خالد العتيبي',
    ),
    style: GeniusPdfVoucherStyle.formal(),
  );

  // ── 2. Cash Sale ──
  final cashSale = SalesVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.cashSale,
      voucherNumber: 'SL-2026-0189',
      voucherDate: DateTime(2026, 2, 5),
      amount: 17250,
      party: const VoucherParty(
        name: 'Al Salam Trading Co.',
        nameAr: 'شركة السلام التجارية',
        code: 'CUS-2045',
        vatNumber: '310111222333003',
      ),
      items: [
        const VoucherLineItem(
          lineNumber: 1,
          itemCode: 'PRD-100',
          description: 'Smart Conference System',
          descriptionAr: 'نظام مؤتمرات ذكي',
          quantity: 1,
          unit: 'Unit',
          unitAr: 'وحدة',
          unitPrice: 12000,
          taxRate: 15,
          taxAmount: 1800,
          totalAmount: 13800,
        ),
        const VoucherLineItem(
          lineNumber: 2,
          itemCode: 'PRD-205',
          description: 'Installation & Setup Service',
          descriptionAr: 'خدمة التركيب والإعداد',
          quantity: 1,
          unit: 'Service',
          unitAr: 'خدمة',
          unitPrice: 3000,
          taxRate: 15,
          taxAmount: 450,
          totalAmount: 3450,
        ),
      ],
      paymentDetails: const VoucherPaymentDetails(
        method: VoucherPaymentMethod.cash,
      ),
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1000',
          accountName: 'Cash in Hand',
          accountNameAr: 'النقد في الصندوق',
          debitAmount: 17250,
        ),
        const VoucherAccountEntry(
          accountCode: '4100',
          accountName: 'Sales Revenue',
          accountNameAr: 'إيرادات المبيعات',
          creditAmount: 15000,
        ),
        const VoucherAccountEntry(
          accountCode: '2200',
          accountName: 'Output VAT',
          accountNameAr: 'ضريبة مخرجات',
          creditAmount: 2250,
        ),
      ],
    ),
    tradeData: VoucherTradeData(
      orderNumber: 'SO-2026-0189',
      orderDate: DateTime(2026, 2, 3),
      salesperson: 'Omar Al-Harbi',
      salespersonAr: 'عمر الحربي',
      subtotal: 15000,
      taxableAmount: 15000,
      vatRate: 15,
      vatAmount: 2250,
      grandTotal: 17250,
      deliveryMethod: 'Company Vehicle',
      deliveryMethodAr: 'سيارة الشركة',
      shippingAddress: 'King Fahd Road, Riyadh',
      shippingAddressAr: 'طريق الملك فهد، الرياض',
      deliveryDate: DateTime(2026, 2, 7),
    ),
    style: GeniusPdfVoucherStyle.financial(),
  );

  // ── 3. Cash Purchase Return ──
  final purchaseReturn = PurchaseReturnVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.cashPurchaseReturn,
      voucherNumber: 'PR-2026-0008',
      voucherDate: DateTime(2026, 2, 5),
      amount: 5750,
      party: const VoucherParty(
        name: 'Modern Office Supplies',
        nameAr: 'لوازم المكاتب الحديثة',
        code: 'SUP-1078',
      ),
      items: [
        const VoucherLineItem(
          lineNumber: 1,
          itemCode: 'OFF-001',
          description: 'Ergonomic Office Chair (Defective)',
          descriptionAr: 'كرسي مكتبي مريح (معيب)',
          quantity: 2,
          unit: 'Pcs',
          unitAr: 'قطعة',
          unitPrice: 2500,
          taxRate: 15,
          taxAmount: 750,
          totalAmount: 5750,
        ),
      ],
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '2100',
          accountName: 'Accounts Payable',
          accountNameAr: 'حسابات الدائنين',
          debitAmount: 5750,
        ),
        const VoucherAccountEntry(
          accountCode: '1500',
          accountName: 'Office Equipment',
          accountNameAr: 'معدات مكتبية',
          creditAmount: 5000,
        ),
        const VoucherAccountEntry(
          accountCode: '1150',
          accountName: 'Input VAT',
          accountNameAr: 'ضريبة مدخلات',
          creditAmount: 750,
        ),
      ],
    ),
    tradeData: VoucherTradeData(
      originalVoucherNumber: 'PU-2026-0042',
      originalVoucherDate: DateTime(2026, 2, 1),
      returnReason: VoucherReturnReason.defective,
      returnReasonDescription: 'Hydraulic lift mechanism failure on 2 chairs',
      returnReasonDescriptionAr: 'عطل في آلية الرفع الهيدروليكي في كرسيين',
      subtotal: 5000,
      vatAmount: 750,
      grandTotal: 5750,
      refundAmount: 5750,
      refundMethod: 'Cash',
      refundMethodAr: 'نقدي',
      warehouseName: 'Main Warehouse',
      warehouseNameAr: 'المستودع الرئيسي',
      inspectedBy: 'Saeed Al-Qahtani',
      inspectedByAr: 'سعيد القحطاني',
    ),
  );

  // ── 4. Credit Sales Return ──
  final salesReturn = SalesReturnVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.creditSalesReturn,
      voucherNumber: 'SR-2026-0015',
      voucherDate: DateTime(2026, 2, 5),
      amount: 3450,
      party: const VoucherParty(
        name: 'Al Salam Trading Co.',
        nameAr: 'شركة السلام التجارية',
        code: 'CUS-2045',
      ),
      items: [
        const VoucherLineItem(
          lineNumber: 1,
          itemCode: 'PRD-205',
          description: 'Installation Service (Cancelled)',
          descriptionAr: 'خدمة التركيب (ملغاة)',
          quantity: 1,
          unit: 'Service',
          unitAr: 'خدمة',
          unitPrice: 3000,
          taxRate: 15,
          taxAmount: 450,
          totalAmount: 3450,
        ),
      ],
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '4100',
          accountName: 'Sales Revenue',
          accountNameAr: 'إيرادات المبيعات',
          debitAmount: 3000,
        ),
        const VoucherAccountEntry(
          accountCode: '2200',
          accountName: 'Output VAT',
          accountNameAr: 'ضريبة مخرجات',
          debitAmount: 450,
        ),
        const VoucherAccountEntry(
          accountCode: '1200',
          accountName: 'Accounts Receivable',
          accountNameAr: 'حسابات المدينين',
          creditAmount: 3450,
        ),
      ],
    ),
    tradeData: VoucherTradeData(
      originalVoucherNumber: 'SL-2026-0189',
      originalVoucherDate: DateTime(2026, 2, 3),
      returnReason: VoucherReturnReason.orderCancellation,
      returnReasonDescription: 'Customer requested cancellation of installation service',
      returnReasonDescriptionAr: 'طلب العميل إلغاء خدمة التركيب',
      subtotal: 3000,
      vatAmount: 450,
      grandTotal: 3450,
      warehouseName: 'Main Warehouse',
      warehouseNameAr: 'المستودع الرئيسي',
      inspectedBy: 'Saeed Al-Qahtani',
      inspectedByAr: 'سعيد القحطاني',
    ),
    style: GeniusPdfVoucherStyle.minimal(),
  );

  // ── Build Batch ──
  final batch = GeniusPdfVoucherBatch(
    config: config,
    vouchers: [creditPurchase, cashSale, purchaseReturn, salesReturn],
    options: const GeniusPdfVoucherBatchOptions(
      addPageBreakBetweenVouchers: true,
      addBatchSummary: true,
      batchTitle: 'Trade Vouchers — Feb 5, 2026',
      batchTitleAr: 'سندات التجارة — 5 فبراير 2026',
    ),
  );

  final bytes = batch.generate();
  batch.dispose();
  return bytes;
}
