/// Service ID registry and enums for voucher templates.
///
/// Each voucher type maps to a specific service ID that determines
/// the voucher layout, required fields, and accounting treatment.
library;

/// All supported voucher service IDs organized by category.
enum VoucherServiceId {
  // ── Accounting Entries (00001–00004) ──
  simpleEntry('00001', 'قيد بسيط', 'Simple Entry', VoucherCategory.accountingEntry),
  compoundEntry('00002', 'قيد مركب', 'Compound Entry', VoucherCategory.accountingEntry),
  openingEntry('00003', 'قيد افتتاحي', 'Opening Entry', VoucherCategory.accountingEntry),
  adjustingEntry('00004', 'قيد تسوية', 'Adjusting Entry', VoucherCategory.accountingEntry),

  // ── Receipt Vouchers (00100–00103) ──
  cashReceipt('00100', 'سند قبض نقدي', 'Cash Receipt', VoucherCategory.receipt),
  bankTransferReceipt('00101', 'سند قبض تحويل بنكي', 'Bank Transfer Receipt', VoucherCategory.receipt),
  checkReceipt('00102', 'سند قبض شيك', 'Check Receipt', VoucherCategory.receipt),
  electronicReceipt('00103', 'سند قبض إلكتروني', 'Electronic Receipt', VoucherCategory.receipt),

  // ── Payment Vouchers (00200–00203) ──
  cashPayment('00200', 'سند صرف نقدي', 'Cash Payment', VoucherCategory.payment),
  bankTransferPayment('00201', 'سند صرف تحويل بنكي', 'Bank Transfer Payment', VoucherCategory.payment),
  checkPayment('00202', 'سند صرف شيك', 'Check Payment', VoucherCategory.payment),
  electronicPayment('00203', 'سند صرف إلكتروني', 'Electronic Payment', VoucherCategory.payment),

  // ── Tax Vouchers (00300–00304) ──
  incomeTax('00300', 'سند ضريبة دخل', 'Income Tax Voucher', VoucherCategory.tax),
  vatVoucher('00301', 'سند ضريبة قيمة مضافة', 'VAT Voucher', VoucherCategory.tax),
  governmentFees('00302', 'سند رسوم حكومية', 'Government Fees Voucher', VoucherCategory.tax),
  customsDuty('00303', 'سند رسوم جمركية', 'Customs Duty Voucher', VoucherCategory.tax),
  taxSettlement('00304', 'سند تسوية ضريبية', 'Tax Settlement Voucher', VoucherCategory.tax);

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
  tax('سندات ضريبية', 'Tax Vouchers');

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
  installment('تقسيط', 'Installment');

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
