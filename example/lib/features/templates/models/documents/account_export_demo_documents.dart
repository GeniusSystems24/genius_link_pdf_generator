import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart'
    show geniusPdfConfig;
import 'package:genius_pdf_example/shared/data/sample_data.dart';

List<AccountExportTransaction> _singleAccountDemoTransactions() {
  final transactions = <AccountExportTransaction>[];
  var yerBalance = 1500000.0;
  var usdBalance = 1950.0;

  // 120 YER rows: 60 debit + 60 credit rows.
  // Totals intentionally reconcile to the YER activity summary:
  // debit 890,000; credit 547,500; closing balance 1,842,500.
  for (var index = 0; index < 120; index++) {
    final sequence = index + 1;
    final day = (index ~/ 4) + 1;
    final isDebit = index.isEven;
    final debit = isDebit ? (index == 118 ? 64000.0 : 14000.0) : 0.0;
    final credit = !isDebit ? (index == 119 ? 16500.0 : 9000.0) : 0.0;
    yerBalance += debit - credit;

    transactions.add(
      AccountExportTransaction(
        transactionNumber: isDebit
            ? 'Y-${sequence.toString().padLeft(4, '0')}-SINV'
            : 'Y-${sequence.toString().padLeft(4, '0')}-RCPT',
        date: DateTime(2026, 8, day),
        type: isDebit ? 'Sales Invoice' : 'Receipt',
        typeAr: isDebit ? 'فاتورة مبيعات' : 'سند قبض',
        description: isDebit
            ? 'YER detailed demo row $sequence: wholesale supply transaction with item references, warehouse release, delivery confirmation, purchase-order cross-reference, and accounting allocation details retained to demonstrate long wrapped descriptions across many portrait pages.'
            : 'YER detailed demo row $sequence: customer collection matched to the remittance advice, bank or cashier evidence, invoice allocation schedule, value-date confirmation, and reconciliation references retained for audit readability.' ,
        descriptionAr: isDebit
            ? 'حركة تجريبية تفصيلية بالريال اليمني رقم $sequence: توريد جملة يتضمن مراجع الأصناف وإذن صرف المخزن وتأكيد التسليم وربط أمر الشراء وتفاصيل التخصيص المحاسبي لإظهار التفاف البيان الطويل عبر عدد كبير من صفحات الوضع الرأسي.'
            : 'حركة تجريبية تفصيلية بالريال اليمني رقم $sequence: تحصيل عميل تمت مطابقته مع إشعار التحويل ومستند البنك أو الصندوق وجدول توزيع المبلغ على الفواتير وتاريخ القيمة ومراجع التسوية لأغراض وضوح المراجعة.',
        currency: 'YER',
        debit: debit,
        credit: credit,
        balanceAfterTransaction: yerBalance,
      ),
    );
  }

  // 120 USD rows: 60 debit + 60 credit rows.
  // Totals intentionally reconcile to the USD activity summary:
  // debit 780.50; credit 550.00; closing balance 2,180.50.
  for (var index = 0; index < 120; index++) {
    final sequence = index + 1;
    final day = (index ~/ 4) + 1;
    final isDebit = index.isEven;
    final debit = isDebit ? (index == 118 ? 43.0 : 12.5) : 0.0;
    final credit = !isDebit ? (index == 119 ? 19.0 : 9.0) : 0.0;
    usdBalance += debit - credit;

    transactions.add(
      AccountExportTransaction(
        transactionNumber: isDebit
            ? 'U-${sequence.toString().padLeft(4, '0')}-SINV'
            : 'U-${sequence.toString().padLeft(4, '0')}-RCPT',
        date: DateTime(2026, 8, day),
        type: isDebit ? 'Sales Invoice' : 'Receipt',
        typeAr: isDebit ? 'فاتورة مبيعات' : 'سند قبض',
        description: isDebit
            ? 'USD detailed demo row $sequence: foreign-currency sale with purchase-order reference, imported-item traceability, dispatch evidence, delivery acknowledgement, and source-document allocation details kept deliberately long for portrait-page wrapping tests.'
            : 'USD detailed demo row $sequence: foreign-currency receipt reconciled to treasury evidence and the customer remittance schedule without netting against another currency, with complete invoice-allocation and verification references.',
        descriptionAr: isDebit
            ? 'حركة تجريبية تفصيلية بالدولار رقم $sequence: عملية بيع بعملة أجنبية تتضمن مرجع أمر الشراء وتتبع الأصناف المستوردة وإثبات الشحن وتأكيد التسليم وتفاصيل توزيع المستندات المصدرية مع بيان طويل لاختبار الالتفاف في صفحات الوضع الرأسي.'
            : 'حركة تجريبية تفصيلية بالدولار رقم $sequence: تحصيل بعملة أجنبية تمت تسويته مع إثبات الخزينة وجدول تحويل العميل دون إجراء مقاصة مع عملة أخرى، مع مراجع كاملة لتوزيع المبلغ على الفواتير والتحقق منها.',
        currency: 'USD',
        debit: debit,
        credit: credit,
        balanceAfterTransaction: usdBalance,
      ),
    );
  }

  transactions.sort((a, b) {
    final byCurrency = a.currency.compareTo(b.currency);
    if (byCurrency != 0) return byCurrency;
    final byDate = a.date.compareTo(b.date);
    if (byDate != 0) return byDate;
    return a.transactionNumber.compareTo(b.transactionNumber);
  });
  return transactions;
}

/// Shared realistic demo accounts for all account-export example screens.
final List<AccountExportAccount> accountExportDemoAccounts = <AccountExportAccount>[
  AccountExportAccount(
    accountNumber: '1101-001',
    accountName: 'Al Noor Trading',
    accountNameAr: 'مؤسسة النور للتجارة',
    parentAccountNumber: '1101',
    parentAccountName: 'Trade Receivables',
    parentAccountNameAr: 'الذمم المدينة التجارية',
    group: 'Customers - Retail',
    groupAr: 'العملاء - تجزئة',
    nature: AccountBalanceNature.debit,
    mobileNumber: '+967 777 120 001',
    personalId: 'CUST-00041',
    balances: const <AccountCurrencyBalance>[
      AccountCurrencyBalance(currency: 'YER', amount: 1842500, nature: AccountBalanceNature.debit),
      AccountCurrencyBalance(currency: 'USD', amount: 2180.50, nature: AccountBalanceNature.debit),
    ],
    activitySummaries: <AccountActivitySummary>[
      AccountActivitySummary(
        currency: 'YER',
        periodStart: DateTime(2026, 8, 1),
        periodEnd: DateTime(2026, 8, 31),
        openingBalance: 1500000,
        totalDebit: 890000,
        totalCredit: 547500,
        closingBalance: 1842500,
      ),
      AccountActivitySummary(
        currency: 'USD',
        periodStart: DateTime(2026, 8, 1),
        periodEnd: DateTime(2026, 8, 31),
        openingBalance: 1950,
        totalDebit: 780.50,
        totalCredit: 550,
        closingBalance: 2180.50,
      ),
    ],
    transactions: _singleAccountDemoTransactions(),
  ),
  AccountExportAccount(
    accountNumber: '1101-002',
    accountName: 'Sama Market',
    accountNameAr: 'سوق سما',
    parentAccountNumber: '1101',
    parentAccountName: 'Trade Receivables',
    parentAccountNameAr: 'الذمم المدينة التجارية',
    group: 'Customers - Retail',
    groupAr: 'العملاء - تجزئة',
    nature: AccountBalanceNature.debit,
    mobileNumber: '+967 777 120 002',
    personalId: 'CUST-00042',
    balances: const <AccountCurrencyBalance>[
      AccountCurrencyBalance(currency: 'YER', amount: 920000, nature: AccountBalanceNature.debit),
    ],
    activitySummaries: <AccountActivitySummary>[
      AccountActivitySummary(
        currency: 'YER',
        periodStart: DateTime(2026, 8, 1),
        periodEnd: DateTime(2026, 8, 31),
        openingBalance: 760000,
        totalDebit: 510000,
        totalCredit: 350000,
        closingBalance: 920000,
      ),
    ],
    transactions: <AccountExportTransaction>[
      AccountExportTransaction(
        transactionNumber: 'SINV-260840',
        date: DateTime(2026, 8, 9),
        type: 'Sales Invoice',
        typeAr: 'فاتورة مبيعات',
        description: 'Monthly supply',
        descriptionAr: 'توريد شهري',
        currency: 'YER',
        debit: 510000,
        balanceAfterTransaction: 1270000,
      ),
      AccountExportTransaction(
        transactionNumber: 'RCPT-260417',
        date: DateTime(2026, 8, 25),
        type: 'Receipt',
        typeAr: 'سند قبض',
        description: 'Partial settlement',
        descriptionAr: 'تسوية جزئية',
        currency: 'YER',
        credit: 350000,
        balanceAfterTransaction: 920000,
      ),
    ],
  ),
  AccountExportAccount(
    accountNumber: '2101-010',
    accountName: 'Regional Supplies LLC',
    accountNameAr: 'الإمدادات الإقليمية ذ.م.م',
    parentAccountNumber: '2101',
    parentAccountName: 'Trade Payables',
    parentAccountNameAr: 'الذمم الدائنة التجارية',
    group: 'Suppliers',
    groupAr: 'الموردون',
    nature: AccountBalanceNature.credit,
    balances: const <AccountCurrencyBalance>[
      AccountCurrencyBalance(currency: 'YER', amount: 1275000, nature: AccountBalanceNature.credit),
    ],
    activitySummaries: <AccountActivitySummary>[
      AccountActivitySummary(
        currency: 'YER',
        periodStart: DateTime(2026, 8, 1),
        periodEnd: DateTime(2026, 8, 31),
        openingBalance: 1080000,
        totalDebit: 420000,
        totalCredit: 615000,
        closingBalance: 1275000,
      ),
    ],
  ),
  AccountExportAccount(
    accountNumber: '1101-003',
    accountName: 'City Electronics',
    accountNameAr: 'إلكترونيات المدينة',
    parentAccountNumber: '1101',
    parentAccountName: 'Trade Receivables',
    parentAccountNameAr: 'الذمم المدينة التجارية',
    group: 'Customers - Wholesale',
    groupAr: 'العملاء - جملة',
    nature: AccountBalanceNature.debit,
    balances: const <AccountCurrencyBalance>[
      AccountCurrencyBalance(currency: 'YER', amount: 2310000, nature: AccountBalanceNature.debit),
    ],
    activitySummaries: <AccountActivitySummary>[
      AccountActivitySummary(
        currency: 'YER',
        periodStart: DateTime(2026, 8, 1),
        periodEnd: DateTime(2026, 8, 31),
        openingBalance: 2010000,
        totalDebit: 780000,
        totalCredit: 480000,
        closingBalance: 2310000,
      ),
    ],
  ),
];

GeniusPdfConfig accountExportDemoConfig({required bool isRtl}) =>
    geniusPdfConfig.copyWith(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
    );

AccountExportDocumentMeta accountExportDemoMeta({required bool isRtl}) =>
    AccountExportDocumentMeta(
      title: 'Account Export',
      titleAr: 'تصدير الحسابات',
      issueDate: DateTime(2026, 9, 6),
      exportingUserNumber: 'USR-0074',
      exportingUserName: 'Ahmed Al-Hakimi',
    );

SingleAccountPdf buildSingleAccountPdfDemo({
  required bool isRtl,
  AccountExportActivityMode activityMode = AccountExportActivityMode.detailed,
}) {
  return SingleAccountPdf(
    config: accountExportDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    meta: accountExportDemoMeta(isRtl: isRtl),
    account: accountExportDemoAccounts.first,
    reportId: 'ACC-EXP-20260906-1101001',
    configuration: AccountExportConfiguration(
      fields: AccountExportFieldVisibility.singlePdf,
      periodStart: DateTime(2026, 8, 1),
      periodEnd: DateTime(2026, 8, 31),
      showBalances: true,
      showActivity: true,
      activityMode: activityMode,
      showTotals: true,
    ),
  );
}

/// Builds 200 realistic accounts for the multi-account PDF example.
///
/// Every account includes an explicit last-transaction date. Account movement
/// is demonstrated through the Debit/Credit summary columns in the main grid;
/// the multi-account PDF intentionally does not append transaction-row tables.
List<AccountExportAccount> _buildMultiAccountPdfDemoAccounts() {
  const groupNames = <String>[
    'Customers - Retail',
    'Customers - Wholesale',
    'Suppliers - Local',
    'Suppliers - Import',
    'Other Receivables',
  ];
  const groupNamesAr = <String>[
    'العملاء - تجزئة',
    'العملاء - جملة',
    'الموردون - محليون',
    'الموردون - استيراد',
    'ذمم مدينة أخرى',
  ];
  const parentNumbers = <String>['1101', '1102', '2101', '2102', '1190'];
  const parentNames = <String>[
    'Retail Receivables',
    'Wholesale Receivables',
    'Local Payables',
    'Import Payables',
    'Other Receivables',
  ];
  const parentNamesAr = <String>[
    'ذمم عملاء التجزئة',
    'ذمم عملاء الجملة',
    'ذمم الموردين المحليين',
    'ذمم موردي الاستيراد',
    'ذمم مدينة أخرى',
  ];

  return List<AccountExportAccount>.generate(200, (index) {
    final sequence = index + 1;
    final groupIndex = index % groupNames.length;
    final day = (index % 31) + 1;
    final lastDate = DateTime(2026, 8, day);
    final opening = 300000.0 + (index * 4250.0);
    final debit = 45000.0 + ((index % 9) * 5250.0);
    final credit = 18000.0 + ((index % 7) * 3100.0);
    final closing = opening + debit - credit;
    final accountNumber =
        '${parentNumbers[groupIndex]}-${sequence.toString().padLeft(4, '0')}';


    return AccountExportAccount(
      accountNumber: accountNumber,
      accountName: 'Business Account ${sequence.toString().padLeft(3, '0')}',
      accountNameAr: 'حساب أعمال ${sequence.toString().padLeft(3, '0')}',
      parentAccountNumber: parentNumbers[groupIndex],
      parentAccountName: parentNames[groupIndex],
      parentAccountNameAr: parentNamesAr[groupIndex],
      group: groupNames[groupIndex],
      groupAr: groupNamesAr[groupIndex],
      nature: groupIndex == 2 || groupIndex == 3
          ? AccountBalanceNature.credit
          : AccountBalanceNature.debit,
      mobileNumber: '+967 77${(1000000 + sequence).toString().substring(1)}',
      personalId: 'ACC-${sequence.toString().padLeft(5, '0')}',
      lastTransactionDate: lastDate,
      balances: <AccountCurrencyBalance>[
        AccountCurrencyBalance(
          currency: 'YER',
          amount: closing.abs(),
          nature: groupIndex == 2 || groupIndex == 3
              ? AccountBalanceNature.credit
              : AccountBalanceNature.debit,
        ),
      ],
      activitySummaries: <AccountActivitySummary>[
        AccountActivitySummary(
          currency: 'YER',
          periodStart: DateTime(2026, 8, 1),
          periodEnd: DateTime(2026, 8, 31),
          openingBalance: opening,
          totalDebit: debit,
          totalCredit: credit,
          closingBalance: closing,
        ),
      ],
      transactions: const <AccountExportTransaction>[],
    );
  }, growable: false);
}

MultiAccountPdf buildMultiAccountPdfDemo({
  required bool isRtl,
}) {
  return MultiAccountPdf(
    config: accountExportDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    meta: accountExportDemoMeta(isRtl: isRtl),
    accounts: _buildMultiAccountPdfDemoAccounts(),
    reportId: 'MULTI-ACC-EXP-20260906-200',
    showQRCode: true,
    showNotes: true,
    configuration: AccountExportConfiguration(
      fields: AccountExportFieldVisibility.multiPdf,
      selectedCurrency: 'YER',
      periodStart: DateTime(2026, 8, 1),
      periodEnd: DateTime(2026, 8, 31),
      showBalances: true,
      showActivity: true,
      activityMode: AccountExportActivityMode.summary,
      grouping: AccountExportGrouping.accountGroup,
      showTotals: true,
    ),
  );
}

SingleAccountImage buildSingleAccountImageDemo({required bool isRtl}) {
  return SingleAccountImage(
    config: accountExportDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    meta: accountExportDemoMeta(isRtl: isRtl),
    account: accountExportDemoAccounts.first,
    reportId: 'SINGLE-ACC-IMG-20260906-001',
    showQRCode: true,
    showNotes: true,
    configuration: const AccountExportConfiguration(
      fields: AccountExportFieldVisibility.singleImage,
      selectedCurrency: 'YER',
      showBalances: true,
      showActivity: true,
      activityMode: AccountExportActivityMode.summary,
      showTotals: true,
    ),
  );
}

List<MultiAccountImage> buildMultiAccountImageDemos({required bool isRtl}) {
  final sourceAccounts = _buildMultiAccountPdfDemoAccounts().take(24).toList();
  return MultiAccountImage.split(
    config: accountExportDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    meta: accountExportDemoMeta(isRtl: isRtl),
    accounts: sourceAccounts,
    reportId: 'MULTI-ACC-IMG-20260906',
    maxAccountsPerImage: 8,
    showQRCode: true,
    showNotes: true,
    showLastTransactionDate: true,
    configuration:  AccountExportConfiguration(
      fields: AccountExportFieldVisibility.multiImage,
      selectedCurrency: 'YER',
      periodStart: DateTime(2026, 8, 1),
      periodEnd: DateTime(2026, 8, 31),
      showBalances: true,
      showActivity: true,
      activityMode: AccountExportActivityMode.summary,
      showTotals: true,
    ),
  );
}
