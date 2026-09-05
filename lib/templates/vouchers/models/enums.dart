/// Service ID registry and enums for voucher templates.
///
/// Each voucher type maps to a specific service ID that determines
/// the voucher layout, required fields, and accounting treatment.
library;

/// All supported voucher service IDs organized by category.
enum VoucherServiceId {
  // ── Accounting Entries (00001–00004) ──
  simpleEntry(
      '00001', 'قيد بسيط', 'Simple Entry', VoucherCategory.accountingEntry),
  compoundEntry(
      '00002', 'قيد مركب', 'Compound Entry', VoucherCategory.accountingEntry),
  openingEntry(
      '00003', 'قيد افتتاحي', 'Opening Entry', VoucherCategory.accountingEntry),
  adjustingEntry(
      '00004', 'قيد تسوية', 'Adjusting Entry', VoucherCategory.accountingEntry),

  // ── Receipt Vouchers (00100–00103) ──
  cashReceipt('00100', 'سند قبض نقدي', 'Cash Receipt', VoucherCategory.receipt),
  bankTransferReceipt('00101', 'سند قبض تحويل بنكي', 'Bank Transfer Receipt',
      VoucherCategory.receipt),
  checkReceipt(
      '00102', 'سند قبض شيك', 'Check Receipt', VoucherCategory.receipt),
  electronicReceipt('00103', 'سند قبض إلكتروني', 'Electronic Receipt',
      VoucherCategory.receipt),

  // ── Payment Vouchers (00200–00203) ──
  cashPayment('00200', 'سند صرف نقدي', 'Cash Payment', VoucherCategory.payment),
  bankTransferPayment('00201', 'سند صرف تحويل بنكي', 'Bank Transfer Payment',
      VoucherCategory.payment),
  checkPayment(
      '00202', 'سند صرف شيك', 'Check Payment', VoucherCategory.payment),
  electronicPayment('00203', 'سند صرف إلكتروني', 'Electronic Payment',
      VoucherCategory.payment),

  // ── Tax Vouchers (00300–00304) ──
  incomeTax(
      '00300', 'سند ضريبة دخل', 'Income Tax Voucher', VoucherCategory.tax),
  vatVoucher(
      '00301', 'سند ضريبة قيمة مضافة', 'VAT Voucher', VoucherCategory.tax),
  governmentFees('00302', 'سند رسوم حكومية', 'Government Fees Voucher',
      VoucherCategory.tax),
  customsDuty(
      '00303', 'سند رسوم جمركية', 'Customs Duty Voucher', VoucherCategory.tax),
  taxSettlement('00304', 'سند تسوية ضريبية', 'Tax Settlement Voucher',
      VoucherCategory.tax),

  // ── Bank Deposit Vouchers (10000–10002) ──
  cashDeposit(
      '10000', 'إيداع نقدي', 'Cash Deposit', VoucherCategory.bankDeposit),
  checkDeposit(
      '10001', 'إيداع شيك', 'Check Deposit', VoucherCategory.bankDeposit),
  electronicDeposit('10002', 'إيداع إلكتروني', 'Electronic Deposit',
      VoucherCategory.bankDeposit),

  // ── Bank Withdrawal Vouchers (10100–10102) ──
  cashWithdrawal(
      '10100', 'سحب نقدي', 'Cash Withdrawal', VoucherCategory.bankWithdrawal),
  checkWithdrawal(
      '10101', 'سحب بشيك', 'Check Withdrawal', VoucherCategory.bankWithdrawal),
  atmWithdrawal('10102', 'سحب عبر الصراف', 'ATM Withdrawal',
      VoucherCategory.bankWithdrawal),

  // ── Transfer Vouchers (10200–10203) ──
  bankTransfer(
      '10200', 'تحويل بنكي', 'Bank Transfer', VoucherCategory.transfer),
  interAccountTransfer('10201', 'تحويل بين حسابات', 'Inter-Account Transfer',
      VoucherCategory.transfer),
  electronicTransfer('10202', 'تحويل إلكتروني', 'Electronic Transfer',
      VoucherCategory.transfer),
  currencyExchange(
      '10203', 'تحويل عملات', 'Currency Exchange', VoucherCategory.transfer),

  // ── Bill Payment Vouchers (10300–10305) ──
  utilityBillPayment('10300', 'دفع فواتير خدمات', 'Utility Bill Payment',
      VoucherCategory.billPayment),
  generalBillPayment('10301', 'دفع فواتير متنوعة', 'General Bill Payment',
      VoucherCategory.billPayment),
  internetBillPayment('10302', 'دفع فواتير إنترنت', 'Internet Bill Payment',
      VoucherCategory.billPayment),
  telecomRecharge(
      '10303', 'شحن اتصالات', 'Telecom Recharge', VoucherCategory.billPayment),
  gameRecharge('10304', 'شحن ألعاب', 'Game Credit Recharge',
      VoucherCategory.billPayment),
  entertainmentRecharge('10305', 'شحن ترفيه', 'Entertainment Recharge',
      VoucherCategory.billPayment),

  // ── Outgoing Remittance Vouchers (10400–10401, 10500–10501) ──
  domesticPersonalOutgoing('10400', 'حوالة محلية شخصية صادرة',
      'Domestic Personal Outgoing', VoucherCategory.remittanceOutgoing),
  domesticCommercialOutgoing('10401', 'حوالة محلية تجارية صادرة',
      'Domestic Commercial Outgoing', VoucherCategory.remittanceOutgoing),
  internationalPersonalOutgoing('10500', 'حوالة دولية شخصية صادرة',
      'International Personal Outgoing', VoucherCategory.remittanceOutgoing),
  internationalCommercialOutgoing('10501', 'حوالة دولية تجارية صادرة',
      'International Commercial Outgoing', VoucherCategory.remittanceOutgoing),

  // ── Incoming Remittance Vouchers (10450–10451, 10550–10551) ──
  domesticPersonalIncoming('10450', 'حوالة محلية شخصية واردة',
      'Domestic Personal Incoming', VoucherCategory.remittanceIncoming),
  domesticCommercialIncoming('10451', 'حوالة محلية تجارية واردة',
      'Domestic Commercial Incoming', VoucherCategory.remittanceIncoming),
  internationalPersonalIncoming('10550', 'حوالة دولية شخصية واردة',
      'International Personal Incoming', VoucherCategory.remittanceIncoming),
  internationalCommercialIncoming('10551', 'حوالة دولية تجارية واردة',
      'International Commercial Incoming', VoucherCategory.remittanceIncoming),

  // ── Purchase Vouchers (20000–20003) ──
  cashPurchase('20000', 'شراء نقدي', 'Cash Purchase', VoucherCategory.purchase),
  creditPurchase(
      '20001', 'شراء آجل', 'Credit Purchase', VoucherCategory.purchase),
  advancePurchase('20002', 'شراء بدفعة مقدمة', 'Advance Purchase',
      VoucherCategory.purchase),
  installmentPurchase('20003', 'شراء بالتقسيط', 'Installment Purchase',
      VoucherCategory.purchase),

  // ── Sales Vouchers (20200–20203) ──
  cashSale('20200', 'بيع نقدي', 'Cash Sale', VoucherCategory.sales),
  creditSale('20201', 'بيع آجل', 'Credit Sale', VoucherCategory.sales),
  advanceSale(
      '20202', 'بيع بدفعة مقدمة', 'Advance Sale', VoucherCategory.sales),
  installmentSale(
      '20203', 'بيع بالتقسيط', 'Installment Sale', VoucherCategory.sales),

  // ── Purchase Return Vouchers (20400–20403) ──
  cashPurchaseReturn('20400', 'مرتجع شراء نقدي', 'Cash Purchase Return',
      VoucherCategory.purchaseReturn),
  creditPurchaseReturn('20401', 'مرتجع شراء آجل', 'Credit Purchase Return',
      VoucherCategory.purchaseReturn),
  advancePurchaseReturn('20402', 'مرتجع شراء بدفعة مقدمة',
      'Advance Purchase Return', VoucherCategory.purchaseReturn),
  installmentPurchaseReturn('20403', 'مرتجع شراء بالتقسيط',
      'Installment Purchase Return', VoucherCategory.purchaseReturn),

  // ── Sales Return Vouchers (20450–20453) ──
  cashSalesReturn('20450', 'مرتجع بيع نقدي', 'Cash Sales Return',
      VoucherCategory.salesReturn),
  creditSalesReturn('20451', 'مرتجع بيع آجل', 'Credit Sales Return',
      VoucherCategory.salesReturn),
  advanceSalesReturn('20452', 'مرتجع بيع بدفعة مقدمة', 'Advance Sales Return',
      VoucherCategory.salesReturn),
  installmentSalesReturn('20453', 'مرتجع بيع بالتقسيط',
      'Installment Sales Return', VoucherCategory.salesReturn),

  // ── Gift/Grant Vouchers (20500–20501) ──
  receivedGift(
      '20500', 'هدية واردة', 'Received Gift/Grant', VoucherCategory.gift),
  givenGift('20501', 'هدية صادرة', 'Given Gift', VoucherCategory.gift),

  // ── Inventory Vouchers (20600–20604) ──
  inventoryAddition(
      '20600', 'إضافة مخزون', 'Inventory Addition', VoucherCategory.inventory),
  inventoryIssue(
      '20601', 'صرف مخزون', 'Inventory Issue', VoucherCategory.inventory),
  inventoryAdjustment('20602', 'تسوية مخزون', 'Inventory Adjustment',
      VoucherCategory.inventory),
  inventoryTransfer(
      '20603', 'تحويل مخزون', 'Inventory Transfer', VoucherCategory.inventory),
  inventoryDamage('20604', 'إتلاف مخزون', 'Inventory Damage/Write-off',
      VoucherCategory.inventory);

  const VoucherServiceId(this.code, this.nameAr, this.nameEn, this.category);

  final String code;
  final String nameAr;
  final String nameEn;
  final VoucherCategory category;

  /// Returns the display name based on text direction.
  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;

  /// Returns the bilingual display: "Arabic / English"
  String bilingualName() => '$nameAr / $nameEn';

  /// Look up a service ID by its code string.
  static VoucherServiceId? fromCode(String code) {
    for (final id in values) {
      if (id.code == code) return id;
    }
    return null;
  }
}

/// Voucher category groupings.
enum VoucherCategory {
  accountingEntry('قيود محاسبية', 'Accounting Entries'),
  receipt('سندات قبض', 'Receipt Vouchers'),
  payment('سندات صرف', 'Payment Vouchers'),
  tax('سندات ضريبية', 'Tax Vouchers'),
  bankDeposit('إيداعات بنكية', 'Bank Deposits'),
  bankWithdrawal('سحوبات بنكية', 'Bank Withdrawals'),
  transfer('التحويلات', 'Transfers'),
  billPayment('دفع الفواتير', 'Bill Payments'),
  remittanceOutgoing('حوالات صادرة', 'Outgoing Remittances'),
  remittanceIncoming('حوالات واردة', 'Incoming Remittances'),
  purchase('مشتريات', 'Purchases'),
  sales('مبيعات', 'Sales'),
  purchaseReturn('مرتجعات مشتريات', 'Purchase Returns'),
  salesReturn('مرتجعات مبيعات', 'Sales Returns'),
  gift('الهدايا والمنح', 'Gifts & Grants'),
  inventory('سندات المخزون', 'Inventory Vouchers');

  const VoucherCategory(this.nameAr, this.nameEn);

  final String nameAr;
  final String nameEn;

  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;
}

/// Payment methods for receipt and payment vouchers.
enum VoucherPaymentMethod {
  cash('نقدي', 'Cash'),
  bankTransfer('تحويل بنكي', 'Bank Transfer'),
  check('شيك', 'Check'),
  electronic('إلكتروني', 'Electronic'),
  installment('تقسيط', 'Installment'),
  currencyExchange('تحويل عملات', 'Currency Exchange');

  const VoucherPaymentMethod(this.nameAr, this.nameEn);

  final String nameAr;
  final String nameEn;

  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;
}

/// Copy type for printed vouchers.
enum VoucherCopyType {
  original('أصل', 'Original'),
  copy('صورة', 'Copy'),
  duplicate('نسخة مكررة', 'Duplicate');

  const VoucherCopyType(this.nameAr, this.nameEn);

  final String nameAr;
  final String nameEn;

  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;
}

/// Tax types.
enum VoucherTaxType {
  incomeTax('ضريبة دخل', 'Income Tax'),
  vat('ضريبة قيمة مضافة', 'Value Added Tax'),
  governmentFee('رسوم حكومية', 'Government Fee'),
  customsDuty('رسوم جمركية', 'Customs Duty'),
  taxSettlement('تسوية ضريبية', 'Tax Settlement');

  const VoucherTaxType(this.nameAr, this.nameEn);

  final String nameAr;
  final String nameEn;

  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;
}

/// Return reasons for purchase/sales return vouchers.
enum VoucherReturnReason {
  defective('منتج معيب', 'Defective Product'),
  wrongItem('منتج خاطئ', 'Wrong Item'),
  qualityIssue('مشكلة جودة', 'Quality Issue'),
  orderCancellation('إلغاء الطلب', 'Order Cancellation'),
  overDelivery('زيادة في التسليم', 'Over Delivery'),
  other('أخرى', 'Other');

  const VoucherReturnReason(this.nameAr, this.nameEn);

  final String nameAr;
  final String nameEn;

  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;
}

/// Gift direction for gift vouchers.
enum GiftDirection {
  received('واردة', 'Received'),
  given('صادرة', 'Given');

  const GiftDirection(this.nameAr, this.nameEn);

  final String nameAr;
  final String nameEn;

  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;
}

/// Inventory operation types.
enum InventoryOperationType {
  addition('إضافة', 'Addition'),
  issue('صرف', 'Issue'),
  adjustment('تسوية', 'Adjustment'),
  transfer('تحويل', 'Transfer'),
  damage('إتلاف', 'Damage/Write-off');

  const InventoryOperationType(this.nameAr, this.nameEn);

  final String nameAr;
  final String nameEn;

  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;
}

/// Inventory adjustment reasons.
enum InventoryAdjustmentReason {
  physicalCount('جرد فعلي', 'Physical Count'),
  dataEntryError('خطأ إدخال', 'Data Entry Error'),
  revaluation('إعادة تقييم', 'Revaluation'),
  reconciliation('مطابقة', 'Reconciliation'),
  systemCorrection('تصحيح نظام', 'System Correction'),
  other('أخرى', 'Other');

  const InventoryAdjustmentReason(this.nameAr, this.nameEn);

  final String nameAr;
  final String nameEn;

  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;
}

/// Inventory damage types.
enum InventoryDamageType {
  expired('منتهي الصلاحية', 'Expired'),
  broken('مكسور', 'Broken'),
  lost('مفقود', 'Lost'),
  obsolete('متقادم', 'Obsolete'),
  waterDamage('تلف مائي', 'Water Damage'),
  fireDamage('تلف حريق', 'Fire Damage'),
  other('أخرى', 'Other');

  const InventoryDamageType(this.nameAr, this.nameEn);

  final String nameAr;
  final String nameEn;

  String displayName({bool isRTL = true}) => isRTL ? nameAr : nameEn;
}
