/// Complete Voucher Demo — showcases all 16 voucher template classes in one batch PDF.
///
/// This comprehensive demo demonstrates every voucher type in the library:
/// - Accounting Entries (4 types): simple, compound, opening, adjusting
/// - Receipt Vouchers (4 types): cash, bank transfer, check, electronic
/// - Payment Vouchers (4 types): cash, bank transfer, check, electronic
/// - Tax Vouchers (5 types): income tax, VAT, government fees, customs, settlement
/// - Bank Deposit Vouchers (3 types): cash, check, electronic
/// - Bank Withdrawal Vouchers (3 types): cash, check, ATM
/// - Transfer Vouchers (4 types): bank, inter-account, electronic, currency exchange
/// - Bill Payment Vouchers (6 types): utility, general, internet, telecom, game, entertainment
/// - Outgoing Remittance Vouchers (4 types): domestic/international, personal/commercial
/// - Incoming Remittance Vouchers (4 types): domestic/international, personal/commercial
/// - Purchase Vouchers (4 types): cash, credit, advance, installment
/// - Sales Vouchers (4 types): cash, credit, advance, installment
/// - Purchase Return Vouchers (4 types): cash, credit, advance, installment
/// - Sales Return Vouchers (4 types): cash, credit, advance, installment
/// - Gift Vouchers (2 types): received, given
/// - Inventory Vouchers (5 types): addition, issue, adjustment, transfer, damage
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a comprehensive demo PDF containing one representative voucher
/// from each of the 16 template classes.
List<int> buildCompleteVoucherDemoReport({
  required GeniusPdfConfig config,
}) {
  final company = GeniusPdfCompanyInfo(
    name: 'Genius Systems',
    nameAr: 'أنظمة الجينيس',
    vatNumber: '311234567890003',
    crNumber: '1010123456',
  );

  final vouchers = <GeniusPdfVoucherTemplate>[
    // ═══════════════════════════════════════════════════════════════════════
    // FINANCIAL VOUCHERS (v3.0.0)
    // ═══════════════════════════════════════════════════════════════════════

    // ── 1. Accounting Entry — Compound Entry ──
    AccountingEntryVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.compoundEntry,
        voucherNumber: 'JE-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 25000,
        description: 'Monthly payroll distribution',
        descriptionAr: 'توزيع الرواتب الشهرية',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '5100',
            accountName: 'Salaries Expense',
            accountNameAr: 'مصروف الرواتب',
            debitAmount: 20000,
          ),
          const VoucherAccountEntry(
            accountCode: '5200',
            accountName: 'Social Insurance',
            accountNameAr: 'التأمينات الاجتماعية',
            debitAmount: 3000,
          ),
          const VoucherAccountEntry(
            accountCode: '5300',
            accountName: 'Housing Allowance',
            accountNameAr: 'بدل السكن',
            debitAmount: 2000,
          ),
          const VoucherAccountEntry(
            accountCode: '1100',
            accountName: 'Cash in Bank',
            accountNameAr: 'النقد في البنك',
            creditAmount: 25000,
          ),
        ],
      ),
      style: GeniusPdfVoucherStyle.formal(),
    ),

    // ── 2. Receipt Voucher — Cash Receipt ──
    ReceiptVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.cashReceipt,
        voucherNumber: 'RV-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 15000,
        payerName: 'Al Faisal Trading',
        payerNameAr: 'تجارة الفيصل',
        description: 'Payment for invoice INV-2026-089',
        descriptionAr: 'سداد الفاتورة INV-2026-089',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '1000',
            accountName: 'Cash',
            accountNameAr: 'النقدية',
            debitAmount: 15000,
          ),
          const VoucherAccountEntry(
            accountCode: '1200',
            accountName: 'Accounts Receivable',
            accountNameAr: 'ذمم مدينة',
            creditAmount: 15000,
          ),
        ],
      ),
      style: GeniusPdfVoucherStyle.financial(),
    ),

    // ── 3. Payment Voucher — Bank Transfer Payment ──
    PaymentVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.bankTransferPayment,
        voucherNumber: 'PV-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 42000,
        payeeName: 'National Suppliers Co.',
        payeeNameAr: 'شركة الموردين الوطنية',
        description: 'Supplier payment for PO-2026-045',
        descriptionAr: 'دفعة للمورد لأمر الشراء PO-2026-045',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '2100',
            accountName: 'Accounts Payable',
            accountNameAr: 'ذمم دائنة',
            debitAmount: 42000,
          ),
          const VoucherAccountEntry(
            accountCode: '1100',
            accountName: 'Cash in Bank',
            accountNameAr: 'النقد في البنك',
            creditAmount: 42000,
          ),
        ],
      ),
    ),

    // ── 4. Tax Voucher — VAT Voucher ──
    TaxVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.vatVoucher,
        voucherNumber: 'TAX-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 8500,
        description: 'Q4 2025 VAT payment',
        descriptionAr: 'دفعة ضريبة القيمة المضافة للربع الرابع 2025',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '2300',
            accountName: 'VAT Payable',
            accountNameAr: 'ضريبة القيمة المضافة المستحقة',
            debitAmount: 8500,
          ),
          const VoucherAccountEntry(
            accountCode: '1100',
            accountName: 'Cash in Bank',
            accountNameAr: 'النقد في البنك',
            creditAmount: 8500,
          ),
        ],
      ),
      taxData: VoucherTaxData(
        taxType: VoucherTaxType.vat,
        taxPeriod: 'Q4-2025',
        taxReferenceNumber: 'VAT-REF-2026-001',
        taxAuthority: 'General Authority of Zakat and Tax',
        taxAuthorityAr: 'هيئة الزكاة والضريبة والجمارك',
      ),
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // BANKING VOUCHERS (v3.1.0)
    // ═══════════════════════════════════════════════════════════════════════

    // ── 5. Bank Deposit — Cash Deposit ──
    BankDepositVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.cashDeposit,
        voucherNumber: 'DEP-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 50000,
        description: 'Daily sales deposit',
        descriptionAr: 'إيداع مبيعات اليوم',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '1100',
            accountName: 'Cash in Bank',
            accountNameAr: 'النقد في البنك',
            debitAmount: 50000,
          ),
          const VoucherAccountEntry(
            accountCode: '1000',
            accountName: 'Cash on Hand',
            accountNameAr: 'النقدية في الصندوق',
            creditAmount: 50000,
          ),
        ],
      ),
      bankingData: VoucherBankingData(
        bankName: 'Al Rajhi Bank',
        bankNameAr: 'مصرف الراجحي',
        accountNumber: '5201234567890',
        depositSlipNumber: 'DS-2026-001234',
      ),
    ),

    // ── 6. Bank Withdrawal — ATM Withdrawal ──
    BankWithdrawalVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.atmWithdrawal,
        voucherNumber: 'WTH-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 5000,
        description: 'Petty cash replenishment',
        descriptionAr: 'تجديد صندوق المصروفات النثرية',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '1000',
            accountName: 'Petty Cash',
            accountNameAr: 'صندوق المصروفات النثرية',
            debitAmount: 5000,
          ),
          const VoucherAccountEntry(
            accountCode: '1100',
            accountName: 'Cash in Bank',
            accountNameAr: 'النقد في البنك',
            creditAmount: 5000,
          ),
        ],
      ),
      bankingData: VoucherBankingData(
        bankName: 'Saudi National Bank',
        bankNameAr: 'البنك الأهلي السعودي',
        accountNumber: '4501234567890',
        atmLocation: 'Branch ATM - Riyadh Main',
        atmLocationAr: 'صراف الفرع - الرياض الرئيسي',
      ),
    ),

    // ── 7. Transfer Voucher — Inter-Account Transfer ──
    TransferVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.interAccountTransfer,
        voucherNumber: 'TRF-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 100000,
        description: 'Transfer to operations account',
        descriptionAr: 'تحويل إلى حساب العمليات',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '1101',
            accountName: 'Operations Account',
            accountNameAr: 'حساب العمليات',
            debitAmount: 100000,
          ),
          const VoucherAccountEntry(
            accountCode: '1100',
            accountName: 'Main Account',
            accountNameAr: 'الحساب الرئيسي',
            creditAmount: 100000,
          ),
        ],
      ),
      transferData: VoucherTransferData(
        sourceBankName: 'Al Rajhi Bank',
        sourceBankNameAr: 'مصرف الراجحي',
        sourceAccountNumber: '5201234567890',
        destinationBankName: 'Al Rajhi Bank',
        destinationBankNameAr: 'مصرف الراجحي',
        destinationAccountNumber: '5201234567891',
        transferReferenceNumber: 'IAT-2026-001234',
      ),
    ),

    // ── 8. Bill Payment — Utility Bill ──
    BillPaymentVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.utilityBillPayment,
        voucherNumber: 'BILL-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 3500,
        description: 'January 2026 electricity bill',
        descriptionAr: 'فاتورة الكهرباء لشهر يناير 2026',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '6100',
            accountName: 'Utilities Expense',
            accountNameAr: 'مصروف المرافق',
            debitAmount: 3500,
          ),
          const VoucherAccountEntry(
            accountCode: '1100',
            accountName: 'Cash in Bank',
            accountNameAr: 'النقد في البنك',
            creditAmount: 3500,
          ),
        ],
      ),
      billData: VoucherBillPaymentData(
        billerName: 'Saudi Electricity Company',
        billerNameAr: 'الشركة السعودية للكهرباء',
        billNumber: 'ELEC-2026-123456',
        billingPeriod: 'January 2026',
        billingPeriodAr: 'يناير 2026',
        accountNumber: '1234567890',
      ),
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // REMITTANCE VOUCHERS (v3.2.0)
    // ═══════════════════════════════════════════════════════════════════════

    // ── 9. Outgoing Remittance — International Commercial ──
    RemittanceOutgoingVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.internationalCommercialOutgoing,
        voucherNumber: 'RMT-OUT-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 75000,
        currency: 'USD',
        description: 'Supplier payment to China',
        descriptionAr: 'دفعة للمورد في الصين',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '2100',
            accountName: 'Accounts Payable',
            accountNameAr: 'ذمم دائنة',
            debitAmount: 75000,
          ),
          const VoucherAccountEntry(
            accountCode: '1100',
            accountName: 'Cash in Bank (USD)',
            accountNameAr: 'النقد في البنك (دولار)',
            creditAmount: 75000,
          ),
        ],
      ),
      remittanceData: VoucherRemittanceData(
        beneficiaryName: 'Shenzhen Electronics Ltd.',
        beneficiaryNameAr: 'شركة شنتشن للإلكترونيات المحدودة',
        beneficiaryBankName: 'Bank of China',
        beneficiaryBankNameAr: 'بنك الصين',
        beneficiaryAccountNumber: 'CN1234567890123456',
        swiftCode: 'BKCHCNBJ',
        remittancePurpose: 'Commercial - Import Payment',
        remittancePurposeAr: 'تجاري - دفعة استيراد',
        exchangeRate: 3.75,
        localCurrencyAmount: 281250,
      ),
    ),

    // ── 10. Incoming Remittance — International Personal ──
    RemittanceIncomingVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.internationalPersonalIncoming,
        voucherNumber: 'RMT-IN-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        amount: 5000,
        currency: 'USD',
        description: 'Personal remittance from USA',
        descriptionAr: 'حوالة شخصية من أمريكا',
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '1100',
            accountName: 'Cash in Bank',
            accountNameAr: 'النقد في البنك',
            debitAmount: 18750,
          ),
          const VoucherAccountEntry(
            accountCode: '4800',
            accountName: 'Remittance Income',
            accountNameAr: 'إيرادات الحوالات',
            creditAmount: 18750,
          ),
        ],
      ),
      remittanceData: VoucherRemittanceData(
        senderName: 'Ahmed Al-Rashid',
        senderNameAr: 'أحمد الراشد',
        senderBankName: 'Bank of America',
        senderBankNameAr: 'بنك أوف أمريكا',
        senderAccountNumber: 'US9876543210',
        swiftCode: 'BOFAUS3N',
        remittancePurpose: 'Personal - Family Support',
        remittancePurposeAr: 'شخصي - دعم عائلي',
        exchangeRate: 3.75,
        localCurrencyAmount: 18750,
      ),
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // TRADE VOUCHERS (v3.3.0)
    // ═══════════════════════════════════════════════════════════════════════

    // ── 11. Purchase Voucher — Credit Purchase ──
    PurchaseVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.creditPurchase,
        voucherNumber: 'PUR-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        referenceNumber: 'PO-2026-078',
        amount: 32500,
        description: 'Office supplies purchase',
        descriptionAr: 'شراء مستلزمات مكتبية',
        items: [
          const VoucherLineItem(
            lineNumber: 1,
            itemCode: 'OFF-001',
            description: 'A4 Paper (Box)',
            descriptionAr: 'ورق A4 (صندوق)',
            quantity: 50,
            unit: 'Box',
            unitAr: 'صندوق',
            unitPrice: 150,
            totalAmount: 7500,
          ),
          const VoucherLineItem(
            lineNumber: 2,
            itemCode: 'OFF-002',
            description: 'Printer Ink Cartridges',
            descriptionAr: 'خراطيش حبر طابعة',
            quantity: 20,
            unit: 'Pcs',
            unitAr: 'قطعة',
            unitPrice: 1250,
            totalAmount: 25000,
          ),
        ],
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '1300',
            accountName: 'Inventory',
            accountNameAr: 'المخزون',
            debitAmount: 32500,
          ),
          const VoucherAccountEntry(
            accountCode: '2100',
            accountName: 'Accounts Payable',
            accountNameAr: 'ذمم دائنة',
            creditAmount: 32500,
          ),
        ],
      ),
      tradeData: VoucherTradeData(
        supplierName: 'Office World Supplies',
        supplierNameAr: 'مستلزمات عالم المكتب',
        purchaseOrderNumber: 'PO-2026-078',
        paymentTerms: 'Net 30',
        paymentTermsAr: 'صافي 30 يوم',
      ),
    ),

    // ── 12. Sales Voucher — Cash Sale ──
    SalesVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.cashSale,
        voucherNumber: 'SAL-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        referenceNumber: 'INV-2026-0156',
        amount: 18400,
        description: 'Computer accessories sale',
        descriptionAr: 'بيع إكسسوارات حاسب',
        items: [
          const VoucherLineItem(
            lineNumber: 1,
            itemCode: 'ACC-001',
            description: 'Wireless Mouse',
            descriptionAr: 'فأرة لاسلكية',
            quantity: 10,
            unit: 'Pcs',
            unitAr: 'قطعة',
            unitPrice: 250,
            totalAmount: 2500,
          ),
          const VoucherLineItem(
            lineNumber: 2,
            itemCode: 'ACC-002',
            description: 'USB Hub 7-Port',
            descriptionAr: 'موزع USB 7 منافذ',
            quantity: 15,
            unit: 'Pcs',
            unitAr: 'قطعة',
            unitPrice: 180,
            totalAmount: 2700,
          ),
          const VoucherLineItem(
            lineNumber: 3,
            itemCode: 'ACC-003',
            description: 'Laptop Stand',
            descriptionAr: 'حامل لابتوب',
            quantity: 20,
            unit: 'Pcs',
            unitAr: 'قطعة',
            unitPrice: 350,
            totalAmount: 7000,
          ),
          const VoucherLineItem(
            lineNumber: 4,
            itemCode: 'ACC-004',
            description: 'Webcam HD 1080p',
            descriptionAr: 'كاميرا ويب HD 1080p',
            quantity: 10,
            unit: 'Pcs',
            unitAr: 'قطعة',
            unitPrice: 620,
            totalAmount: 6200,
          ),
        ],
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '1000',
            accountName: 'Cash',
            accountNameAr: 'النقدية',
            debitAmount: 18400,
          ),
          const VoucherAccountEntry(
            accountCode: '4100',
            accountName: 'Sales Revenue',
            accountNameAr: 'إيرادات المبيعات',
            creditAmount: 16000,
          ),
          const VoucherAccountEntry(
            accountCode: '2300',
            accountName: 'VAT Payable',
            accountNameAr: 'ضريبة القيمة المضافة المستحقة',
            creditAmount: 2400,
          ),
        ],
      ),
      tradeData: VoucherTradeData(
        customerName: 'Tech Solutions LLC',
        customerNameAr: 'حلول التقنية ذ.م.م',
        invoiceNumber: 'INV-2026-0156',
      ),
    ),

    // ── 13. Purchase Return Voucher ──
    PurchaseReturnVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.creditPurchaseReturn,
        voucherNumber: 'PR-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        referenceNumber: 'RMA-2026-012',
        amount: 2500,
        description: 'Return of defective items',
        descriptionAr: 'إرجاع بضاعة معيبة',
        items: [
          const VoucherLineItem(
            lineNumber: 1,
            itemCode: 'OFF-002',
            description: 'Printer Ink Cartridges (Defective)',
            descriptionAr: 'خراطيش حبر طابعة (معيبة)',
            quantity: 2,
            unit: 'Pcs',
            unitAr: 'قطعة',
            unitPrice: 1250,
            totalAmount: 2500,
          ),
        ],
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '2100',
            accountName: 'Accounts Payable',
            accountNameAr: 'ذمم دائنة',
            debitAmount: 2500,
          ),
          const VoucherAccountEntry(
            accountCode: '1300',
            accountName: 'Inventory',
            accountNameAr: 'المخزون',
            creditAmount: 2500,
          ),
        ],
      ),
      tradeData: VoucherTradeData(
        supplierName: 'Office World Supplies',
        supplierNameAr: 'مستلزمات عالم المكتب',
        returnReason: VoucherReturnReason.defective,
        originalInvoiceNumber: 'PUR-2026-001',
        originalInvoiceDate: DateTime(2026, 2, 1),
      ),
    ),

    // ── 14. Sales Return Voucher ──
    SalesReturnVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.cashSalesReturn,
        voucherNumber: 'SR-2026-001',
        voucherDate: DateTime(2026, 2, 6),
        referenceNumber: 'RET-2026-008',
        amount: 700,
        description: 'Customer return - wrong item',
        descriptionAr: 'مرتجع عميل - منتج خاطئ',
        items: [
          const VoucherLineItem(
            lineNumber: 1,
            itemCode: 'ACC-002',
            description: 'USB Hub 7-Port (Wrong Model)',
            descriptionAr: 'موزع USB 7 منافذ (موديل خاطئ)',
            quantity: 2,
            unit: 'Pcs',
            unitAr: 'قطعة',
            unitPrice: 350,
            totalAmount: 700,
          ),
        ],
        accountEntries: [
          const VoucherAccountEntry(
            accountCode: '4110',
            accountName: 'Sales Returns',
            accountNameAr: 'مردودات المبيعات',
            debitAmount: 700,
          ),
          const VoucherAccountEntry(
            accountCode: '1000',
            accountName: 'Cash',
            accountNameAr: 'النقدية',
            creditAmount: 700,
          ),
        ],
      ),
      tradeData: VoucherTradeData(
        customerName: 'Tech Solutions LLC',
        customerNameAr: 'حلول التقنية ذ.م.م',
        returnReason: VoucherReturnReason.wrongItem,
        originalInvoiceNumber: 'INV-2026-0156',
        originalInvoiceDate: DateTime(2026, 2, 5),
      ),
    ),

    // ═══════════════════════════════════════════════════════════════════════
    // AUXILIARY VOUCHERS (v3.4.0)
    // ═══════════════════════════════════════════════════════════════════════

    // ── 15. Gift Voucher — Received Gift ──
    GiftVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.receivedGift,
        voucherNumber: 'GF-2026-001',
        voucherDate: DateTime(2026, 2, 6),
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
    ),

    // ── 16. Inventory Voucher — Transfer ──
    InventoryVoucher(
      config: config,
      company: company,
      data: VoucherData(
        serviceId: VoucherServiceId.inventoryTransfer,
        voucherNumber: 'INV-2026-001',
        voucherDate: DateTime(2026, 2, 6),
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
    ),
  ];

  // ── Build Batch ──
  final batch = GeniusPdfVoucherBatch(
    config: config,
    vouchers: vouchers,
    options: const GeniusPdfVoucherBatchOptions(
      addPageBreakBetweenVouchers: true,
      addBatchSummary: true,
      batchTitle: 'Complete Voucher Demo — All 16 Template Classes',
      batchTitleAr: 'عرض السندات الشامل — جميع القوالب الـ 16',
    ),
  );

  final bytes = batch.generate();
  batch.dispose();
  return bytes;
}
