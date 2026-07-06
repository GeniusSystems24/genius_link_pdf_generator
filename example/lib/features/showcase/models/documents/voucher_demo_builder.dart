import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Builds a multi-page voucher demo PDF showcasing all v3.0.0 voucher types.
///
/// Generates 5 vouchers in a single PDF:
/// 1. Simple Accounting Entry
/// 2. Cash Receipt Voucher
/// 3. Bank Transfer Payment Voucher
/// 4. VAT Voucher
/// 5. Check Receipt Voucher
///
/// Uses [GeniusPdfVoucherBatch] to combine them into one document.
List<int> buildVoucherDemoReport({required GeniusPdfConfig config}) {
  final isRTL = config.isRTL;

  final company = GeniusPdfCompanyInfo(
    name: 'Genius Systems LLC',
    nameAr: 'مؤسسة جينيس للأنظمة',
    vatNumber: '300012345678903',
    crNumber: '1010123456',
    address: 'Riyadh, Saudi Arabia',
    addressAr: 'الرياض، المملكة العربية السعودية',
    phone: '+966 11 123 4567',
  );

  // ── 1. Simple Accounting Entry ──
  final accountingEntry = AccountingEntryVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.simpleEntry,
      voucherNumber: 'JV-2026-0001',
      voucherDate: DateTime(2026, 2, 4),
      amount: 15000,
      description: 'Purchase of office equipment with cash payment',
      descriptionAr: 'شراء معدات مكتبية بالدفع النقدي',
      fiscalPeriod: '2026-Q1',
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1500',
          accountName: 'Office Equipment',
          accountNameAr: 'معدات مكتبية',
          debitAmount: 15000,
        ),
        const VoucherAccountEntry(
          accountCode: '1100',
          accountName: 'Cash in Hand',
          accountNameAr: 'النقد في الصندوق',
          creditAmount: 15000,
        ),
      ],
      signatories: [
        VoucherSignatory.preparedBy(name: isRTL ? 'محمد أحمد' : 'Mohammed Ahmed'),
        VoucherSignatory.reviewedBy(name: isRTL ? 'خالد علي' : 'Khaled Ali'),
        VoucherSignatory.approvedBy(name: isRTL ? 'عبدالله سعود' : 'Abdullah Saud'),
      ],
    ),
  );

  // ── 2. Cash Receipt ──
  final cashReceipt = ReceiptVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.cashReceipt,
      voucherNumber: 'RV-2026-0142',
      voucherDate: DateTime(2026, 2, 4),
      amount: 25000,
      description: 'Payment for invoice INV-2026-089 — consulting services',
      descriptionAr: 'سداد الفاتورة INV-2026-089 — خدمات استشارية',
      referenceNumber: 'INV-2026-089',
      party: const VoucherParty(
        name: 'Al-Faisal Trading Co.',
        nameAr: 'شركة الفيصل التجارية',
        code: 'C-1024',
        vatNumber: '310098765432101',
        phone: '+966 55 987 6543',
        address: 'Jeddah, KSA',
        addressAr: 'جدة، المملكة العربية السعودية',
      ),
      paymentDetails: const VoucherPaymentDetails(
        method: VoucherPaymentMethod.cash,
      ),
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1100',
          accountName: 'Cash in Hand',
          accountNameAr: 'النقد في الصندوق',
          debitAmount: 25000,
        ),
        const VoucherAccountEntry(
          accountCode: '1200',
          accountName: 'Accounts Receivable',
          accountNameAr: 'ذمم مدينة',
          costCenter: 'Sales',
          costCenterAr: 'المبيعات',
          creditAmount: 25000,
        ),
      ],
    ),
  );

  // ── 3. Bank Transfer Payment ──
  final bankPayment = PaymentVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.bankTransferPayment,
      voucherNumber: 'PV-2026-0087',
      voucherDate: DateTime(2026, 2, 4),
      amount: 45000,
      description: 'Monthly office rent — February 2026',
      descriptionAr: 'إيجار المكتب الشهري — فبراير 2026',
      referenceNumber: 'RENT-2026-02',
      party: const VoucherParty(
        name: 'Al-Rajhi Real Estate',
        nameAr: 'شركة الراجحي العقارية',
        code: 'V-0512',
        bankName: 'Al Rajhi Bank',
        iban: 'SA0380000000608010167519',
      ),
      paymentDetails: const VoucherPaymentDetails(
        method: VoucherPaymentMethod.bankTransfer,
        bankName: 'Al Rajhi Bank',
        bankNameAr: 'مصرف الراجحي',
        accountNumber: '608010167519',
        iban: 'SA0380000000608010167519',
        transferReference: 'TRF-20260204-001',
        transferDate: null, // Will use voucherDate
      ),
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '6200',
          accountName: 'Rent Expense',
          accountNameAr: 'مصروف الإيجار',
          costCenter: 'Admin',
          costCenterAr: 'الإدارة',
          debitAmount: 45000,
        ),
        const VoucherAccountEntry(
          accountCode: '1110',
          accountName: 'Bank - Al Rajhi',
          accountNameAr: 'البنك - الراجحي',
          creditAmount: 45000,
        ),
      ],
    ),
    deductions: const [
      PaymentDeduction(name: 'Withholding Tax (5%)', nameAr: 'ضريبة استقطاع (5%)', amount: 2250),
    ],
  );

  // ── 4. VAT Voucher ──
  final vatVoucher = TaxVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.vatVoucher,
      voucherNumber: 'TV-2026-0015',
      voucherDate: DateTime(2026, 2, 4),
      amount: 37500,
      referenceNumber: 'ZATCA-2026-Q1',
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '2300',
          accountName: 'VAT Payable',
          accountNameAr: 'ضريبة القيمة المضافة المستحقة',
          debitAmount: 37500,
        ),
        const VoucherAccountEntry(
          accountCode: '1110',
          accountName: 'Bank - Al Rajhi',
          accountNameAr: 'البنك - الراجحي',
          creditAmount: 37500,
        ),
      ],
    ),
    taxData: VoucherTaxData(
      taxType: VoucherTaxType.vat,
      taxPeriodStart: DateTime(2026, 1, 1),
      taxPeriodEnd: DateTime(2026, 3, 31),
      filingDeadline: DateTime(2026, 4, 30),
      taxAuthorityName: 'Zakat, Tax and Customs Authority (ZATCA)',
      taxAuthorityNameAr: 'هيئة الزكاة والضريبة والجمارك',
      taxAuthorityRef: 'ZATCA-REF-2026-Q1-00142',
      outputVat: 75000,
      inputVat: 37500,
      netVat: 37500,
    ),
  );

  // ── 5. Check Receipt ──
  final checkReceipt = ReceiptVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.checkReceipt,
      voucherNumber: 'RV-2026-0143',
      voucherDate: DateTime(2026, 2, 4),
      amount: 120000,
      description: 'Annual maintenance contract payment',
      descriptionAr: 'سداد عقد الصيانة السنوية',
      referenceNumber: 'MC-2026-001',
      party: const VoucherParty(
        name: 'National Tech Solutions',
        nameAr: 'الحلول التقنية الوطنية',
        code: 'C-2048',
        vatNumber: '300087654321001',
      ),
      paymentDetails: VoucherPaymentDetails(
        method: VoucherPaymentMethod.check,
        checkNumber: '780142',
        draweeBankName: 'Saudi National Bank (SNB)',
        draweeBranch: 'Riyadh Main Branch',
        checkDate: DateTime(2026, 2, 4),
        dueDate: DateTime(2026, 3, 4),
      ),
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1150',
          accountName: 'Checks Receivable',
          accountNameAr: 'شيكات تحت التحصيل',
          debitAmount: 120000,
        ),
        const VoucherAccountEntry(
          accountCode: '1200',
          accountName: 'Accounts Receivable',
          accountNameAr: 'ذمم مدينة',
          creditAmount: 120000,
        ),
      ],
    ),
  );

  // ── Generate Batch ──
  final batch = GeniusPdfVoucherBatch(
    config: config,
    vouchers: [accountingEntry, cashReceipt, bankPayment, vatVoucher, checkReceipt],
    options: const GeniusPdfVoucherBatchOptions(
      addPageBreakBetweenVouchers: true,
      addBatchSummary: true,
      batchTitle: 'Service Vouchers Demo — v3.0.0',
      batchTitleAr: 'عرض سندات الخدمات — الإصدار 3.0.0',
    ),
  );

  final bytes = batch.generate();
  batch.dispose();
  return bytes;
}
