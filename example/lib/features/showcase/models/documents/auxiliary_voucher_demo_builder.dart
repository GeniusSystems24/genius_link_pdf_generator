/// Auxiliary Voucher Demo — builds gift and inventory vouchers in one batch PDF.
///
/// Demonstrates GiftVoucher and InventoryVoucher templates.
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a demo PDF containing gift and inventory vouchers in a single batch.
List<int> buildAuxiliaryVoucherDemoReport({
  required GeniusPdfConfig config,
}) {
  final company = GeniusPdfCompanyInfo(
    name: 'Genius Systems',
    nameAr: 'أنظمة الجينيس',
    vatNumber: '311234567890003',
    crNumber: '1010123456',
  );

  // ── 1. Received Gift ──
  final receivedGift = GiftVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.receivedGift,
      voucherNumber: 'GF-2026-0012',
      voucherDate: DateTime(2026, 2, 5),
      amount: 8500,
      description: 'Equipment grant from partner company',
      descriptionAr: 'منحة معدات من شركة شريكة',
      items: [
        const VoucherLineItem(
          lineNumber: 1,
          itemCode: 'EQ-500',
          description: 'Dell Monitor 27"',
          descriptionAr: 'شاشة ديل 27 بوصة',
          quantity: 2,
          unit: 'Pcs',
          unitAr: 'قطعة',
          unitPrice: 2500,
          totalAmount: 5000,
        ),
        const VoucherLineItem(
          lineNumber: 2,
          itemCode: 'EQ-501',
          description: 'Ergonomic Keyboard',
          descriptionAr: 'لوحة مفاتيح مريحة',
          quantity: 5,
          unit: 'Pcs',
          unitAr: 'قطعة',
          unitPrice: 700,
          totalAmount: 3500,
        ),
      ],
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1500',
          accountName: 'Office Equipment',
          accountNameAr: 'معدات مكتبية',
          debitAmount: 8500,
        ),
        const VoucherAccountEntry(
          accountCode: '4500',
          accountName: 'Gift/Grant Income',
          accountNameAr: 'إيرادات الهدايا والمنح',
          creditAmount: 8500,
        ),
      ],
    ),
    giftData: VoucherGiftData(
      direction: GiftDirection.received,
      donorName: 'Tech Partners Inc.',
      donorNameAr: 'شركة شركاء التقنية',
      occasion: 'Partnership Agreement Signing',
      occasionAr: 'توقيع اتفاقية الشراكة',
      giftReason: 'Welcome gift for new partnership',
      giftReasonAr: 'هدية ترحيبية للشراكة الجديدة',
      fairMarketValue: 8500,
      taxTreatment: 'VAT exempt - gift',
      taxTreatmentAr: 'معفاة من ضريبة القيمة المضافة - هدية',
      authorizationReference: 'AUTH-2026-0045',
    ),
    style: GeniusPdfVoucherStyle.formal(),
  );

  // ── 2. Given Gift ──
  final givenGift = GiftVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.givenGift,
      voucherNumber: 'GF-2026-0013',
      voucherDate: DateTime(2026, 2, 5),
      amount: 1200,
      description: 'Customer appreciation gift',
      descriptionAr: 'هدية تقدير للعميل',
      items: [
        const VoucherLineItem(
          lineNumber: 1,
          itemCode: 'PRD-100',
          description: 'Premium Gift Set',
          descriptionAr: 'طقم هدايا فاخر',
          quantity: 1,
          unit: 'Set',
          unitAr: 'طقم',
          unitPrice: 1200,
          totalAmount: 1200,
        ),
      ],
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '6200',
          accountName: 'Marketing Expense',
          accountNameAr: 'مصاريف التسويق',
          debitAmount: 1200,
        ),
        const VoucherAccountEntry(
          accountCode: '1300',
          accountName: 'Inventory',
          accountNameAr: 'المخزون',
          creditAmount: 1200,
        ),
      ],
    ),
    giftData: VoucherGiftData(
      direction: GiftDirection.given,
      recipientName: 'Al Salam Trading Co.',
      recipientNameAr: 'شركة السلام التجارية',
      occasion: 'Annual Partner Appreciation',
      occasionAr: 'تقدير الشركاء السنوي',
      giftReason: 'Thank you for 5 years of partnership',
      giftReasonAr: 'شكراً على 5 سنوات من الشراكة',
      taxTreatment: 'Deductible marketing expense',
      taxTreatmentAr: 'مصروف تسويقي قابل للخصم',
      authorizationReference: 'AUTH-2026-0046',
    ),
  );

  // ── 3. Inventory Transfer ──
  final inventoryTransfer = InventoryVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.inventoryTransfer,
      voucherNumber: 'INV-2026-0078',
      voucherDate: DateTime(2026, 2, 5),
      amount: 15750,
      referenceNumber: 'TO-2026-0034',
      description: 'Branch stock replenishment',
      descriptionAr: 'تجديد مخزون الفرع',
      items: [
        const VoucherLineItem(
          lineNumber: 1,
          itemCode: 'PRD-001',
          description: 'Widget A - Standard',
          descriptionAr: 'منتج أ - قياسي',
          quantity: 50,
          unit: 'Pcs',
          unitAr: 'قطعة',
          unitPrice: 150,
          totalAmount: 7500,
        ),
        const VoucherLineItem(
          lineNumber: 2,
          itemCode: 'PRD-002',
          description: 'Widget B - Premium',
          descriptionAr: 'منتج ب - مميز',
          quantity: 30,
          unit: 'Pcs',
          unitAr: 'قطعة',
          unitPrice: 275,
          totalAmount: 8250,
        ),
      ],
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1301',
          accountName: 'Inventory - Branch',
          accountNameAr: 'مخزون - الفرع',
          debitAmount: 15750,
        ),
        const VoucherAccountEntry(
          accountCode: '1300',
          accountName: 'Inventory - Main',
          accountNameAr: 'مخزون - الرئيسي',
          creditAmount: 15750,
        ),
      ],
    ),
    inventoryData: VoucherInventoryData(
      operationType: InventoryOperationType.transfer,
      sourceWarehouse: 'Main Warehouse',
      sourceWarehouseAr: 'المستودع الرئيسي',
      destinationWarehouse: 'Branch Warehouse - Jeddah',
      destinationWarehouseAr: 'مستودع الفرع - جدة',
      transferOrderNumber: 'TO-2026-0034',
      authorizationReference: 'AUTH-2026-0089',
    ),
    style: GeniusPdfVoucherStyle.financial(),
  );

  // ── 4. Inventory Damage ──
  final inventoryDamage = InventoryVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.inventoryDamage,
      voucherNumber: 'INV-2026-0079',
      voucherDate: DateTime(2026, 2, 5),
      amount: 4200,
      referenceNumber: 'DMG-2026-0012',
      description: 'Water damage from roof leak',
      descriptionAr: 'تلف مائي من تسرب السقف',
      items: [
        const VoucherLineItem(
          lineNumber: 1,
          itemCode: 'PRD-003',
          description: 'Paper Supplies Box',
          descriptionAr: 'صندوق لوازم ورقية',
          quantity: 20,
          unit: 'Box',
          unitAr: 'صندوق',
          unitPrice: 120,
          totalAmount: 2400,
        ),
        const VoucherLineItem(
          lineNumber: 2,
          itemCode: 'PRD-004',
          description: 'Cardboard Packaging',
          descriptionAr: 'تغليف كرتوني',
          quantity: 60,
          unit: 'Pcs',
          unitAr: 'قطعة',
          unitPrice: 30,
          totalAmount: 1800,
        ),
      ],
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '6800',
          accountName: 'Inventory Loss',
          accountNameAr: 'خسائر المخزون',
          debitAmount: 4200,
        ),
        const VoucherAccountEntry(
          accountCode: '1300',
          accountName: 'Inventory',
          accountNameAr: 'المخزون',
          creditAmount: 4200,
        ),
      ],
    ),
    inventoryData: VoucherInventoryData(
      operationType: InventoryOperationType.damage,
      sourceWarehouse: 'Main Warehouse',
      sourceWarehouseAr: 'المستودع الرئيسي',
      damageType: InventoryDamageType.waterDamage,
      damageDescription: 'Roof leak during heavy rain on Feb 3, 2026',
      damageDescriptionAr: 'تسرب من السقف أثناء المطر الغزير في 3 فبراير 2026',
      inspectedBy: 'Ahmed Al-Rashid',
      inspectedByAr: 'أحمد الراشد',
      disposalMethod: 'Recycling',
      disposalMethodAr: 'إعادة التدوير',
      insuranceClaim: true,
      insuranceClaimNumber: 'INS-2026-0089',
      authorizationReference: 'AUTH-2026-0090',
    ),
    style: GeniusPdfVoucherStyle.minimal(),
  );

  // ── 5. Inventory Adjustment ──
  final inventoryAdjustment = InventoryVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.inventoryAdjustment,
      voucherNumber: 'INV-2026-0080',
      voucherDate: DateTime(2026, 2, 5),
      amount: 850,
      referenceNumber: 'ADJ-2026-0015',
      description: 'Physical count variance adjustment',
      descriptionAr: 'تعديل فرق الجرد الفعلي',
      items: [
        const VoucherLineItem(
          lineNumber: 1,
          itemCode: 'PRD-005',
          description: 'USB Flash Drive 32GB',
          descriptionAr: 'ذاكرة USB 32 جيجا',
          quantity: 17,
          unit: 'Pcs',
          unitAr: 'قطعة',
          unitPrice: 50,
          totalAmount: 850,
        ),
      ],
      notes: 'Found additional units during annual physical count',
      notesAr: 'تم العثور على وحدات إضافية أثناء الجرد السنوي',
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1300',
          accountName: 'Inventory',
          accountNameAr: 'المخزون',
          debitAmount: 850,
        ),
        const VoucherAccountEntry(
          accountCode: '7100',
          accountName: 'Inventory Adjustment',
          accountNameAr: 'تعديل المخزون',
          creditAmount: 850,
        ),
      ],
    ),
    inventoryData: VoucherInventoryData(
      operationType: InventoryOperationType.adjustment,
      sourceWarehouse: 'Main Warehouse',
      sourceWarehouseAr: 'المستودع الرئيسي',
      adjustmentReason: InventoryAdjustmentReason.physicalCount,
      authorizationReference: 'AUTH-2026-0091',
    ),
  );

  // ── Build Batch ──
  final batch = GeniusPdfVoucherBatch(
    config: config,
    vouchers: [receivedGift, givenGift, inventoryTransfer, inventoryDamage, inventoryAdjustment],
    options: const GeniusPdfVoucherBatchOptions(
      addPageBreakBetweenVouchers: true,
      addBatchSummary: true,
      batchTitle: 'Auxiliary Vouchers — Feb 5, 2026',
      batchTitleAr: 'السندات المساعدة — 5 فبراير 2026',
    ),
  );

  final bytes = batch.generate();
  batch.dispose();
  return bytes;
}
