/// Remittance Voucher Demo — builds 4 remittance vouchers in one batch PDF.
///
/// Demonstrates RemittanceOutgoingVoucher and RemittanceIncomingVoucher
/// for both domestic and international, personal and commercial flows.
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a demo PDF containing 4 remittance vouchers in a single batch.
List<int> buildRemittanceVoucherDemoReport({
  required GeniusPdfConfig config,
}) {
  final company = GeniusPdfCompanyInfo(
    name: 'Genius Systems',
    nameAr: 'أنظمة الجينيس',
    vatNumber: '311234567890003',
    crNumber: '1010123456',
  );

  // ── 1. Domestic Personal Outgoing ──
  final domesticOutgoing = RemittanceOutgoingVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.domesticPersonalOutgoing,
      voucherNumber: 'RO-2026-0041',
      voucherDate: DateTime(2026, 2, 5),
      amount: 12000,
      description: 'Monthly family support transfer',
      descriptionAr: 'حوالة دعم عائلي شهرية',
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '2300',
          accountName: 'Remittance Payable',
          accountNameAr: 'حوالات مستحقة',
          debitAmount: 12000,
        ),
        const VoucherAccountEntry(
          accountCode: '1010',
          accountName: 'Bank - Al Rajhi',
          accountNameAr: 'البنك - الراجحي',
          creditAmount: 12000,
        ),
      ],
    ),
    remittanceData: const VoucherRemittanceData(
      senderName: 'Mohammed Al-Ahmed',
      senderNameAr: 'محمد الأحمد',
      senderIdNumber: '1012345678',
      senderIdType: 'National ID',
      senderIdTypeAr: 'هوية وطنية',
      senderPhone: '+966501234567',
      beneficiaryName: 'Abdullah Al-Ahmed',
      beneficiaryNameAr: 'عبدالله الأحمد',
      beneficiaryIdNumber: '1098765432',
      beneficiaryBankName: 'Al Rajhi Bank',
      beneficiaryBankNameAr: 'مصرف الراجحي',
      beneficiaryAccountNumber: '68020145879',
      beneficiaryIban: 'SA4480000068020145879000',
      transferFee: 15,
      purposeCode: 'FAM',
      purposeDescription: 'Family Support',
      purposeDescriptionAr: 'دعم عائلي',
      trackingNumber: 'DOM-2026020541-001',
    ),
  );

  // ── 2. International Personal Outgoing ──
  final intlOutgoing = RemittanceOutgoingVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.internationalPersonalOutgoing,
      voucherNumber: 'RO-2026-0042',
      voucherDate: DateTime(2026, 2, 5),
      amount: 8500,
      description: 'International personal remittance to Egypt',
      descriptionAr: 'حوالة شخصية دولية إلى مصر',
    ),
    remittanceData: VoucherRemittanceData(
      senderName: 'Khaled Ibrahim',
      senderNameAr: 'خالد إبراهيم',
      senderIdNumber: '2312345678',
      senderIdType: 'Iqama',
      senderIdTypeAr: 'إقامة',
      senderPhone: '+966559876543',
      senderCountry: 'Saudi Arabia',
      senderCountryAr: 'المملكة العربية السعودية',
      beneficiaryName: 'Hassan Ibrahim',
      beneficiaryNameAr: 'حسن إبراهيم',
      beneficiaryPhone: '+20101234567',
      beneficiaryCountry: 'Egypt',
      beneficiaryCountryAr: 'مصر',
      beneficiaryBankName: 'National Bank of Egypt',
      beneficiaryBankNameAr: 'البنك الأهلي المصري',
      beneficiaryAccountNumber: '1234567890123',
      beneficiarySwiftCode: 'NBEGEGCX',
      correspondentBank: 'Citibank N.A.',
      sourceCurrency: 'SAR',
      targetCurrency: 'EGP',
      exchangeRate: 13.2450,
      sourceAmount: 8500,
      targetAmount: 112582.50,
      transferFee: 45,
      exchangeMargin: 12,
      totalCost: 8557,
      purposeCode: 'PER',
      purposeDescription: 'Personal Transfer',
      purposeDescriptionAr: 'تحويل شخصي',
      amlReference: 'AML-2026-FEB-04521',
      trackingNumber: 'INT-2026020542-002',
      expectedDeliveryDate: DateTime(2026, 2, 7),
    ),
  );

  // ── 3. Domestic Commercial Incoming ──
  final domesticIncoming = RemittanceIncomingVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.domesticCommercialIncoming,
      voucherNumber: 'RI-2026-0028',
      voucherDate: DateTime(2026, 2, 5),
      amount: 95000,
      description: 'Client payment received — Project Alpha',
      descriptionAr: 'دفعة عميل مستلمة — مشروع ألفا',
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1010',
          accountName: 'Bank - Al Rajhi',
          accountNameAr: 'البنك - الراجحي',
          debitAmount: 95000,
        ),
        const VoucherAccountEntry(
          accountCode: '1200',
          accountName: 'Accounts Receivable',
          accountNameAr: 'حسابات المدينين',
          creditAmount: 95000,
        ),
      ],
    ),
    remittanceData: const VoucherRemittanceData(
      senderName: 'Al-Faisal Trading Co.',
      senderNameAr: 'شركة الفيصل التجارية',
      senderPhone: '+966112345678',
      beneficiaryName: 'Genius Systems',
      beneficiaryNameAr: 'أنظمة الجينيس',
      beneficiaryAccountNumber: '608010167519',
      beneficiaryIban: 'SA0380000000608010167519',
      disbursementMethod: 'To Account',
      disbursementMethodAr: 'إلى الحساب البنكي',
    ),
  );

  // ── 4. International Commercial Incoming ──
  final intlIncoming = RemittanceIncomingVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.internationalCommercialIncoming,
      voucherNumber: 'RI-2026-0029',
      voucherDate: DateTime(2026, 2, 5),
      amount: 187500,
      description: 'Export payment — UAE client',
      descriptionAr: 'دفعة تصدير — عميل إماراتي',
    ),
    remittanceData: const VoucherRemittanceData(
      senderName: 'Gulf Tech Solutions LLC',
      senderNameAr: 'شركة حلول الخليج التقنية',
      senderCountry: 'UAE',
      senderCountryAr: 'الإمارات',
      beneficiaryName: 'Genius Systems',
      beneficiaryNameAr: 'أنظمة الجينيس',
      beneficiaryAccountNumber: '608010167519',
      beneficiaryIban: 'SA0380000000608010167519',
      sourceCurrency: 'AED',
      targetCurrency: 'SAR',
      exchangeRate: 1.0204,
      sourceAmount: 183750,
      targetAmount: 187500,
      transferFee: 0,
      exchangeMargin: 35,
      correspondentBank: 'SWIFT Ref: EABORAE2026FEB0029',
      disbursementMethod: 'To Account',
      disbursementMethodAr: 'إلى الحساب البنكي',
    ),
  );

  // ── Build Batch ──
  final batch = GeniusPdfVoucherBatch(
    config: config,
    vouchers: [domesticOutgoing, intlOutgoing, domesticIncoming, intlIncoming],
    options: const GeniusPdfVoucherBatchOptions(
      addPageBreakBetweenVouchers: true,
      addBatchSummary: true,
      batchTitle: 'Remittance Vouchers — Feb 5, 2026',
      batchTitleAr: 'سندات الحوالات — 5 فبراير 2026',
    ),
  );

  final bytes = batch.generate();
  batch.dispose();
  return bytes;
}
