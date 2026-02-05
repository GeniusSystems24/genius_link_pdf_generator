/// Banking Voucher Demo — builds 4 banking vouchers in one batch PDF.
///
/// Demonstrates BankDepositVoucher, BankWithdrawalVoucher,
/// TransferVoucher, and BillPaymentVoucher templates.
library;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a demo PDF containing 4 banking vouchers in a single batch.
List<int> buildBankingVoucherDemoReport({
  required GeniusPdfConfig config,
}) {
  final company = GeniusPdfCompanyInfo(
    name: 'Genius Systems',
    nameAr: 'أنظمة الجينيس',
    vatNumber: '311234567890003',
    crNumber: '1010123456',
  );

  // ── 1. Cash Deposit ──
  final cashDeposit = BankDepositVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.cashDeposit,
      voucherNumber: 'BD-2026-0031',
      voucherDate: DateTime(2026, 2, 5),
      amount: 75000,
      description: 'Weekly sales revenue deposit',
      descriptionAr: 'إيداع إيرادات المبيعات الأسبوعية',
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1010',
          accountName: 'Bank - Al Rajhi',
          accountNameAr: 'البنك - الراجحي',
          debitAmount: 75000,
        ),
        const VoucherAccountEntry(
          accountCode: '1000',
          accountName: 'Cash in Hand',
          accountNameAr: 'النقد في الصندوق',
          creditAmount: 75000,
        ),
      ],
      paymentDetails: VoucherPaymentDetails(
        method: VoucherPaymentMethod.cash,
        denominations: {
          500.0: 100,
          200.0: 50,
          100.0: 100,
          50.0: 50,
          10.0: 250,
        },
      ),
    ),
    bankInfo: VoucherBankInfo(
      bankName: 'Al Rajhi Bank',
      bankNameAr: 'مصرف الراجحي',
      branchName: 'King Fahd Road Branch',
      branchNameAr: 'فرع طريق الملك فهد',
      accountNumber: '608010167519',
      iban: 'SA0380000000608010167519',
    ),
    style: GeniusPdfVoucherStyle.financial(),
  );

  // ── 2. Check Withdrawal ──
  final checkWithdrawal = BankWithdrawalVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.checkWithdrawal,
      voucherNumber: 'BW-2026-0012',
      voucherDate: DateTime(2026, 2, 5),
      amount: 32000,
      description: 'Supplier payment — office furniture',
      descriptionAr: 'دفع مورد — أثاث مكتبي',
      paymentDetails: VoucherPaymentDetails(
        method: VoucherPaymentMethod.check,
        checkNumber: 'CHK-045872',
        draweeBankName: 'Al Rajhi Bank',
        checkDate: DateTime(2026, 2, 5),
      ),
      party: const VoucherParty(
        name: 'Modern Office Supplies',
        nameAr: 'لوازم المكاتب الحديثة',
        code: 'SUP-1078',
      ),
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '2100',
          accountName: 'Accounts Payable',
          accountNameAr: 'حسابات الدائنين',
          debitAmount: 32000,
        ),
        const VoucherAccountEntry(
          accountCode: '1010',
          accountName: 'Bank - Al Rajhi',
          accountNameAr: 'البنك - الراجحي',
          creditAmount: 32000,
        ),
      ],
    ),
    bankInfo: const VoucherBankInfo(
      bankName: 'Al Rajhi Bank',
      bankNameAr: 'مصرف الراجحي',
      accountNumber: '608010167519',
      iban: 'SA0380000000608010167519',
    ),
  );

  // ── 3. Bank Transfer ──
  final bankTransfer = TransferVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.bankTransfer,
      voucherNumber: 'TF-2026-0089',
      voucherDate: DateTime(2026, 2, 5),
      amount: 150000,
      description: 'Internal fund allocation — project capital',
      descriptionAr: 'تخصيص أموال داخلي — رأس مال المشروع',
      paymentDetails: const VoucherPaymentDetails(
        method: VoucherPaymentMethod.bankTransfer,
        transferReference: 'TRF-20260205-0089',
      ),
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '1020',
          accountName: 'Bank - NCB',
          accountNameAr: 'البنك - الأهلي',
          debitAmount: 150000,
        ),
        const VoucherAccountEntry(
          accountCode: '1010',
          accountName: 'Bank - Al Rajhi',
          accountNameAr: 'البنك - الراجحي',
          creditAmount: 150000,
        ),
      ],
    ),
    transferData: const VoucherTransferData(
      sourceAccount: VoucherBankInfo(
        bankName: 'Al Rajhi Bank',
        bankNameAr: 'مصرف الراجحي',
        accountNumber: '608010167519',
        iban: 'SA0380000000608010167519',
        currency: 'SAR',
        balanceBefore: 520000,
      ),
      destinationAccount: VoucherBankInfo(
        bankName: 'National Commercial Bank',
        bankNameAr: 'البنك الأهلي التجاري',
        accountNumber: '20501234567',
        iban: 'SA4410000020501234567890',
        currency: 'SAR',
        balanceBefore: 85000,
      ),
      beneficiaryName: 'Genius Systems — Project Fund',
      beneficiaryNameAr: 'أنظمة الجينيس — صندوق المشروع',
      transferFee: 25,
      netAmount: 149975,
    ),
    style: GeniusPdfVoucherStyle.formal(),
  );

  // ── 4. Utility Bill Payment ──
  final utilityBill = BillPaymentVoucher(
    config: config,
    company: company,
    data: VoucherData(
      serviceId: VoucherServiceId.utilityBillPayment,
      voucherNumber: 'BP-2026-0155',
      voucherDate: DateTime(2026, 2, 5),
      amount: 2850,
      paymentDetails: const VoucherPaymentDetails(
        method: VoucherPaymentMethod.electronic,
        gatewayName: 'SADAD',
        transactionId: 'SDT-20260205-78542',
      ),
      accountEntries: [
        const VoucherAccountEntry(
          accountCode: '6100',
          accountName: 'Utilities Expense',
          accountNameAr: 'مصاريف الخدمات',
          debitAmount: 2850,
        ),
        const VoucherAccountEntry(
          accountCode: '1010',
          accountName: 'Bank - Al Rajhi',
          accountNameAr: 'البنك - الراجحي',
          creditAmount: 2850,
        ),
      ],
    ),
    billData: VoucherBillData(
      providerName: 'Saudi Electricity Company',
      providerNameAr: 'شركة الكهرباء السعودية',
      subscriberNumber: '1100234567',
      serviceType: 'Electricity',
      serviceTypeAr: 'كهرباء',
      meterNumber: 'MTR-00045872',
      billingPeriod: 'Jan 2026',
      billingPeriodAr: 'يناير 2026',
      consumption: 4200,
      consumptionUnit: 'kWh',
      rate: 0.18,
      dueDate: DateTime(2026, 2, 15),
      confirmationNumber: 'SADAD-20260205-78542-CONF',
    ),
    style: GeniusPdfVoucherStyle.minimal(),
  );

  // ── Build Batch ──
  final batch = GeniusPdfVoucherBatch(
    config: config,
    vouchers: [cashDeposit, checkWithdrawal, bankTransfer, utilityBill],
    options: const GeniusPdfVoucherBatchOptions(
      addPageBreakBetweenVouchers: true,
      addBatchSummary: true,
      batchTitle: 'Banking Vouchers — Feb 5, 2026',
      batchTitleAr: 'السندات البنكية — 5 فبراير 2026',
    ),
  );

  final bytes = batch.generate();
  batch.dispose();
  return bytes;
}
