
import '../../domain/erp/erp.dart';
import '../shared/erp_pack_shared.dart';
import 'models.dart';

import '../../families/erp/erp_families.dart';
/// S14 deterministic accounting/report preparation service.
///
/// PDF document classes only render [GeniusErpPackReportData]. Reconciliation,
/// balances, grouping, aging, tax and comparison arithmetic live here.
class GeniusAccountingService {
  const GeniusAccountingService();

  GeniusErpPackReportData generalLedger(
    List<GeniusAccountingPosting> postings, {
    required ErpMoney openingBalance,
    GeniusAccountingCarryPolicy carryPolicy =
        GeniusAccountingCarryPolicy.none,
    int estimatedRowsPerPage = 36,
  }) {
    _validatePostings(postings, openingBalance.currency);

    var balance = openingBalance;
    final rows = <GeniusErpPackReportRow>[];

    for (var index = 0; index < postings.length; index++) {
      if (carryPolicy == GeniusAccountingCarryPolicy.estimatedPageRows &&
          index > 0 &&
          index % estimatedRowsPerPage == 0) {
        rows.add(
          GeniusErpPackReportRow(
            isTotal: true,
            cells: {
              'date': '',
              'document': '',
              'account': 'Carried Forward',
              'description': '',
              'debit': '',
              'credit': '',
              'balance': GeniusAccountingFormat.accounting(balance),
            },
          ),
        );
        rows.add(
          GeniusErpPackReportRow(
            cells: {
              'date': '',
              'document': '',
              'account': 'Brought Forward',
              'description': '',
              'debit': '',
              'credit': '',
              'balance': GeniusAccountingFormat.accounting(balance),
            },
          ),
        );
      }

      final posting = postings[index];
      balance = balance + posting.movement;

      rows.add(
        GeniusErpPackReportRow(
          cells: {
            'date': posting.date.toIso8601String().split('T').first,
            'document': posting.documentNumber,
            'account': GeniusErpPackLocalizedValue(
              value: GeniusAccountingFormat.hierarchyLabel(
                posting.account,
              ),
              valueAr: GeniusAccountingFormat.hierarchyLabel(
                posting.account,
                isRtl: true,
              ),
            ),
            'description': GeniusErpPackLocalizedValue(
              value: posting.description,
              valueAr: posting.descriptionAr,
            ),
            'debit': posting.debit.isZero
                ? ''
                : posting.debit.toDouble(),
            'credit': posting.credit.isZero
                ? ''
                : posting.credit.toDouble(),
            'balance': GeniusAccountingFormat.accounting(balance),
          },
        ),
      );
    }

    return GeniusErpPackReportData(
      title: 'General Ledger',
      titleAr: 'دفتر الأستاذ العام',
      details: [
        GeniusErpDetailField(
          label: 'Opening Balance',
          labelAr: 'الرصيد الافتتاحي',
          value: GeniusAccountingFormat.accounting(openingBalance),
        ),
        GeniusErpDetailField(
          label: 'Closing Balance',
          labelAr: 'الرصيد الختامي',
          value: GeniusAccountingFormat.accounting(balance),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'document',
          title: 'Document',
          titleAr: 'المستند',
        ),
        GeniusErpPackReportColumn(
          id: 'account',
          title: 'Account',
          titleAr: 'الحساب',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'البيان',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'debit',
          title: 'Debit',
          titleAr: 'مدين',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'credit',
          title: 'Credit',
          titleAr: 'دائن',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'balance',
          title: 'Balance',
          titleAr: 'الرصيد',
        ),
      ],
      rows: rows,
    );
  }

  GeniusErpPackReportData journalEntry(
    List<GeniusAccountingPosting> postings,
  ) {
    if (postings.isEmpty) {
      return _emptyFinancialReport(
        'Journal Entry',
        'قيد يومية',
      );
    }
    _validatePostings(postings, postings.first.currency);

    final debit = _sum(
      postings.map((item) => item.debit),
      postings.first.currency,
    );
    final credit = _sum(
      postings.map((item) => item.credit),
      postings.first.currency,
    );

    final rows = <GeniusErpPackReportRow>[
      for (final posting in postings)
        GeniusErpPackReportRow(
          cells: {
            'account': GeniusErpPackLocalizedValue(
              value: GeniusAccountingFormat.hierarchyLabel(
                posting.account,
              ),
              valueAr: GeniusAccountingFormat.hierarchyLabel(
                posting.account,
                isRtl: true,
              ),
            ),
            'description': GeniusErpPackLocalizedValue(
              value: posting.description,
              valueAr: posting.descriptionAr,
            ),
            'debit': posting.debit.isZero
                ? ''
                : posting.debit.toDouble(),
            'credit': posting.credit.isZero
                ? ''
                : posting.credit.toDouble(),
          },
        ),
      GeniusErpPackReportRow(
        isTotal: true,
        cells: {
          'account': 'Total',
          'description': debit == credit ? 'Balanced' : 'Out of balance',
          'debit': debit.toDouble(),
          'credit': credit.toDouble(),
        },
      ),
    ];

    return GeniusErpPackReportData(
      title: 'Journal Entry',
      titleAr: 'قيد يومية',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'account',
          title: 'Account',
          titleAr: 'الحساب',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'البيان',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'debit',
          title: 'Debit',
          titleAr: 'مدين',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'credit',
          title: 'Credit',
          titleAr: 'دائن',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: rows,
    );
  }

  GeniusErpPackReportData journalRegister(
    List<GeniusAccountingPosting> postings,
  ) =>
      _postingRegister(
        postings,
        title: 'Journal Register',
        titleAr: 'سجل اليومية',
      );

  GeniusErpPackReportData accountStatement(
    List<GeniusAccountingPosting> postings, {
    required GeniusAccountingAccount account,
    required ErpMoney openingBalance,
  }) {
    final filtered = postings
        .where((item) => item.account.code == account.code)
        .toList(growable: false);

    return generalLedger(
      filtered,
      openingBalance: openingBalance,
    ).withTitle(
      'Account Statement — ${account.code}',
      titleAr:
          'كشف حساب — ${account.nameAr ?? account.name}',
    );
  }

  GeniusErpPackReportData arAging(
    List<GeniusErpOpenItem> items, {
    required DateTime asOf,
  }) =>
      _aging(
        items,
        asOf: asOf,
        title: 'AR Aging',
        titleAr: 'أعمار الذمم المدينة',
      );

  GeniusErpPackReportData apAging(
    List<GeniusErpOpenItem> items, {
    required DateTime asOf,
  }) =>
      _aging(
        items,
        asOf: asOf,
        title: 'AP Aging',
        titleAr: 'أعمار الذمم الدائنة',
      );

  GeniusErpPackReportData customerBalances(
    List<GeniusErpOpenItem> items,
  ) =>
      _partyBalances(
        items,
        title: 'Customer Balances',
        titleAr: 'أرصدة العملاء',
      );

  GeniusErpPackReportData supplierBalances(
    List<GeniusErpOpenItem> items,
  ) =>
      _partyBalances(
        items,
        title: 'Supplier Balances',
        titleAr: 'أرصدة الموردين',
      );

  GeniusErpPackReportData cashBook(
    List<GeniusAccountingPosting> postings,
  ) =>
      _postingRegister(
        postings,
        title: 'Cash Book',
        titleAr: 'دفتر النقدية',
      );

  GeniusErpPackReportData bankBook(
    List<GeniusAccountingPosting> postings,
  ) =>
      _postingRegister(
        postings,
        title: 'Bank Book',
        titleAr: 'دفتر البنك',
      );

  GeniusErpPackReportData pettyCash(
    List<GeniusAccountingPosting> postings,
  ) =>
      _postingRegister(
        postings,
        title: 'Petty Cash',
        titleAr: 'العهدة النقدية',
      );

  GeniusErpPackReportData paymentRegister(
    List<GeniusAccountingPosting> postings,
  ) =>
      _postingRegister(
        postings,
        title: 'Payment Register',
        titleAr: 'سجل المدفوعات',
      );

  GeniusErpPackReportData receiptRegister(
    List<GeniusAccountingPosting> postings,
  ) =>
      _postingRegister(
        postings,
        title: 'Receipt Register',
        titleAr: 'سجل المقبوضات',
      );

  GeniusErpPackReportData bankReconciliation(
    List<GeniusAccountingBankReconciliationLine> lines,
  ) {
    if (lines.isEmpty) {
      return _emptyFinancialReport(
        'Bank Reconciliation',
        'تسوية البنك',
      );
    }

    final currency = lines.first.bookAmount.currency;
    var book = ErpMoney.zero(currency);
    var statement = ErpMoney.zero(currency);

    final rows = <GeniusErpPackReportRow>[];
    for (final line in lines) {
      if (line.bookAmount.currency != currency ||
          line.statementAmount.currency != currency) {
        throw ArgumentError(
          'Bank reconciliation requires one currency.',
        );
      }
      book = book + line.bookAmount;
      statement = statement + line.statementAmount;
      rows.add(
        GeniusErpPackReportRow(
          cells: {
            'date': line.date.toIso8601String().split('T').first,
            'reference': line.reference,
            'description': GeniusErpPackLocalizedValue(
              value: line.description,
              valueAr: line.descriptionAr,
            ),
            'book': line.bookAmount.toDouble(),
            'statement': line.statementAmount.toDouble(),
            'difference':
                GeniusAccountingFormat.accounting(line.difference),
            'cleared': line.clearedDate
                    ?.toIso8601String()
                    .split('T')
                    .first ??
                '',
          },
        ),
      );
    }

    rows.add(
      GeniusErpPackReportRow(
        isTotal: true,
        cells: {
          'date': '',
          'reference': '',
          'description': 'Total',
          'book': book.toDouble(),
          'statement': statement.toDouble(),
          'difference':
              GeniusAccountingFormat.accounting(book - statement),
          'cleared': '',
        },
      ),
    );

    return GeniusErpPackReportData(
      title: 'Bank Reconciliation',
      titleAr: 'تسوية البنك',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'reference',
          title: 'Reference',
          titleAr: 'المرجع',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'البيان',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'book',
          title: 'Book',
          titleAr: 'الدفتر',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'statement',
          title: 'Statement',
          titleAr: 'الكشف',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'difference',
          title: 'Difference',
          titleAr: 'الفرق',
        ),
        GeniusErpPackReportColumn(
          id: 'cleared',
          title: 'Cleared',
          titleAr: 'التسوية',
        ),
      ],
      rows: rows,
    );
  }

  GeniusErpPackReportData vatSummary(
    List<GeniusAccountingTaxRecord> records,
  ) {
    final byCategory =
        <GeniusAccountingTaxCategory, (ErpMoney, ErpMoney)>{};

    for (final record in records) {
      final current = byCategory[record.category] ??
          (
            ErpMoney.zero(record.netAmount.currency),
            ErpMoney.zero(record.taxAmount.currency),
          );

      if (current.$1.currency != record.netAmount.currency ||
          current.$2.currency != record.taxAmount.currency) {
        throw ArgumentError('Tax summary requires one currency.');
      }

      byCategory[record.category] = (
        current.$1 + record.netAmount,
        current.$2 + record.taxAmount,
      );
    }

    return GeniusErpPackReportData(
      title: 'VAT / Tax Summary',
      titleAr: 'ملخص ضريبة القيمة المضافة',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'category',
          title: 'Category',
          titleAr: 'التصنيف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'net',
          title: 'Taxable Base',
          titleAr: 'الأساس',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'tax',
          title: 'Tax',
          titleAr: 'الضريبة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final entry in byCategory.entries)
          GeniusErpPackReportRow(
            cells: {
              'category': _taxCategoryLabel(entry.key),
              'net': entry.value.$1.toDouble(),
              'tax': entry.value.$2.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData taxRegister(
    List<GeniusAccountingTaxRecord> records,
  ) {
    return GeniusErpPackReportData(
      title: 'Tax Register',
      titleAr: 'سجل الضرائب',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'document',
          title: 'Document',
          titleAr: 'المستند',
        ),
        GeniusErpPackReportColumn(
          id: 'party',
          title: 'Party',
          titleAr: 'الطرف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'category',
          title: 'Category',
          titleAr: 'التصنيف',
        ),
        GeniusErpPackReportColumn(
          id: 'rate',
          title: 'Rate %',
          titleAr: 'النسبة %',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'net',
          title: 'Net',
          titleAr: 'الصافي',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'tax',
          title: 'Tax',
          titleAr: 'الضريبة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final record in records)
          GeniusErpPackReportRow(
            cells: {
              'date': record.date.toIso8601String().split('T').first,
              'document': record.documentNumber,
              'party': GeniusErpPackLocalizedValue(
                value: record.partyName,
                valueAr: record.partyNameAr,
              ),
              'category': _taxCategoryLabel(record.category),
              'rate': record.ratePercent,
              'net': record.netAmount.toDouble(),
              'tax': record.taxAmount.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData taxBreakdown(
    List<GeniusAccountingTaxRecord> records,
  ) =>
      vatSummary(records).withTitle(
        'Taxable / Exempt / Zero-Rated Breakdown',
        titleAr: 'تفصيل خاضع / معفى / صفري',
      );

  GeniusErpPackReportData reconciliation(
    List<GeniusAccountingReconciliationItem> items,
  ) {
    return GeniusErpPackReportData(
      title: 'Rounding / Reconciliation',
      titleAr: 'تقرير التقريب والتسوية',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'label',
          title: 'Item',
          titleAr: 'البند',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'expected',
          title: 'Expected',
          titleAr: 'المتوقع',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'actual',
          title: 'Actual',
          titleAr: 'الفعلي',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'difference',
          title: 'Difference',
          titleAr: 'الفرق',
        ),
      ],
      rows: [
        for (final item in items)
          GeniusErpPackReportRow(
            cells: {
              'label': GeniusErpPackLocalizedValue(
                value: item.label,
                valueAr: item.labelAr,
              ),
              'expected': item.expected.toDouble(),
              'actual': item.actual.toDouble(),
              'difference':
                  GeniusAccountingFormat.accounting(item.difference),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData costCenterStatement(
    List<GeniusAccountingPosting> postings,
    String costCenter,
  ) =>
      _postingRegister(
        postings
            .where((item) => item.costCenter == costCenter)
            .toList(growable: false),
        title: 'Cost Center Statement — $costCenter',
        titleAr: 'كشف مركز تكلفة — $costCenter',
      );

  GeniusErpPackReportData costCenterTrialBalance(
    List<GeniusAccountingPosting> postings,
  ) =>
      _groupBalance(
        postings,
        key: (item) => item.costCenter ?? 'Unassigned',
        title: 'Cost Center Trial Balance',
        titleAr: 'ميزان مراجعة مراكز التكلفة',
      );

  GeniusErpPackReportData projectFinancialReport(
    List<GeniusAccountingPosting> postings,
  ) =>
      _groupBalance(
        postings,
        key: (item) => item.project ?? 'Unassigned',
        title: 'Project Financial Report',
        titleAr: 'التقرير المالي للمشروعات',
      );

  GeniusErpPackReportData budgetVsActual(
    List<GeniusAccountingBudgetLine> lines,
  ) {
    return GeniusErpPackReportData(
      title: 'Budget vs Actual',
      titleAr: 'الموازنة مقابل الفعلي',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الرمز',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Account',
          titleAr: 'الحساب',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'budget',
          title: 'Budget',
          titleAr: 'الموازنة',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'actual',
          title: 'Actual',
          titleAr: 'الفعلي',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'variance',
          title: 'Variance',
          titleAr: 'الانحراف',
        ),
      ],
      rows: [
        for (final line in lines)
          GeniusErpPackReportRow(
            cells: {
              'code': line.code,
              'name': GeniusErpPackLocalizedValue(
                value: line.name,
                valueAr: line.nameAr,
              ),
              'budget': line.budget.toDouble(),
              'actual': line.actual.toDouble(),
              'variance':
                  GeniusAccountingFormat.accounting(line.variance),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData multiPeriodComparison(
    List<GeniusAccountingPeriodAmount> values,
  ) {
    final periods = values.map((item) => item.period).toSet().toList()
      ..sort();
    final accounts =
        <String, List<GeniusAccountingPeriodAmount>>{};

    for (final value in values) {
      accounts.putIfAbsent(value.accountCode, () => []).add(value);
    }

    return GeniusErpPackReportData(
      title: 'Multi-Period Comparison',
      titleAr: 'مقارنة متعددة الفترات',
      columns: [
        const GeniusErpPackReportColumn(
          id: 'account',
          title: 'Account',
          titleAr: 'الحساب',
          flexFactor: 2,
        ),
        for (final period in periods)
          GeniusErpPackReportColumn(
            id: period,
            title: period,
            titleAr: period,
            kind: GeniusErpPackReportColumnKind.money,
          ),
      ],
      rows: [
        for (final entry in accounts.entries)
          GeniusErpPackReportRow(
            cells: {
              'account': GeniusErpPackLocalizedValue(
                value: entry.value.first.accountName,
                valueAr: entry.value.first.accountNameAr,
              ),
              for (final period in periods)
                period: _periodAmount(entry.value, period),
            },
          ),
      ],
    );
  }

  List<GeniusAccountingBalanceRow> openingMovementClosing(
    List<GeniusAccountingPosting> postings, {
    required Map<String, ErpMoney> openingByAccount,
  }) {
    final accounts = <String, GeniusAccountingAccount>{};
    final debit = <String, ErpMoney>{};
    final credit = <String, ErpMoney>{};

    for (final posting in postings) {
      posting.validate();
      accounts[posting.account.code] = posting.account;
      debit[posting.account.code] =
          (debit[posting.account.code] ??
                  ErpMoney.zero(posting.currency)) +
              posting.debit;
      credit[posting.account.code] =
          (credit[posting.account.code] ??
                  ErpMoney.zero(posting.currency)) +
              posting.credit;
    }

    final codes = <String>{
      ...openingByAccount.keys,
      ...accounts.keys,
    }.toList()
      ..sort();

    return [
      for (final code in codes)
        _balanceRow(
          code,
          accounts[code],
          openingByAccount[code],
          debit[code],
          credit[code],
        ),
    ];
  }

  GeniusErpPackReportData balanceHierarchy(
    List<GeniusAccountingBalanceRow> rows, {
    String title = 'Trial Balance Hierarchy',
    String titleAr = 'هرمية ميزان المراجعة',
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'account',
          title: 'Account',
          titleAr: 'الحساب',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'opening',
          title: 'Opening',
          titleAr: 'افتتاحي',
        ),
        GeniusErpPackReportColumn(
          id: 'debit',
          title: 'Debit',
          titleAr: 'مدين',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'credit',
          title: 'Credit',
          titleAr: 'دائن',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'closing',
          title: 'Closing',
          titleAr: 'ختامي',
        ),
      ],
      rows: [
        for (final row in rows)
          GeniusErpPackReportRow(
            isTotal: row.isSubtotal,
            cells: {
              'account':
                  '${List.filled(row.level, '  ').join()}'
                  '${row.code} — ${row.name}',
              'opening':
                  GeniusAccountingFormat.accounting(row.opening),
              'debit': row.debit.toDouble(),
              'credit': row.credit.toDouble(),
              'closing':
                  GeniusAccountingFormat.accounting(row.closing),
            },
          ),
      ],
    );
  }

  /// Adds deterministic top-level subtotal rows to a chart hierarchy.
  ///
  /// Account codes are grouped by the segment before the first dot.
  List<GeniusAccountingBalanceRow> addTopLevelSubtotals(
    List<GeniusAccountingBalanceRow> rows,
  ) {
    if (rows.isEmpty) return const [];

    final groups = <String, List<GeniusAccountingBalanceRow>>{};
    for (final row in rows) {
      final key = row.code.split('.').first;
      groups.putIfAbsent(key, () => []).add(row);
    }

    final result = <GeniusAccountingBalanceRow>[];

    for (final entry in groups.entries) {
      final group = entry.value;
      final currency = group.first.opening.currency;
      var opening = ErpMoney.zero(currency);
      var debit = ErpMoney.zero(currency);
      var credit = ErpMoney.zero(currency);
      var closing = ErpMoney.zero(currency);

      for (final row in group) {
        if (row.opening.currency != currency ||
            row.debit.currency != currency ||
            row.credit.currency != currency ||
            row.closing.currency != currency) {
          throw ArgumentError(
            'Hierarchy subtotal group must use one currency.',
          );
        }
        opening = opening + row.opening;
        debit = debit + row.debit;
        credit = credit + row.credit;
        closing = closing + row.closing;
        result.add(row);
      }

      result.add(
        GeniusAccountingBalanceRow(
          code: '${entry.key}-TOTAL',
          name: 'Subtotal ${entry.key}',
          nameAr: 'المجموع الفرعي ${entry.key}',
          opening: opening,
          debit: debit,
          credit: credit,
          closing: closing,
          isSubtotal: true,
        ),
      );
    }

    return result;
  }

  /// Prepares separate ledger reports per currency.
  ///
  /// S14 never silently converts or sums different currencies. Callers can
  /// render each returned report independently, or explicitly convert through
  /// S06 before invoking this method.
  Map<String, GeniusErpPackReportData> ledgersByCurrency(
    List<GeniusAccountingPosting> postings, {
    Map<String, ErpMoney> openingByCurrency = const {},
  }) {
    final groups = <String, List<GeniusAccountingPosting>>{};
    for (final posting in postings) {
      groups
          .putIfAbsent(posting.currency.code, () => [])
          .add(posting);
    }

    return {
      for (final entry in groups.entries)
        entry.key: generalLedger(
          entry.value,
          openingBalance:
              openingByCurrency[entry.key] ??
              ErpMoney.zero(entry.value.first.currency),
        ),
    };
  }

  GeniusErpPackReportData _postingRegister(
    List<GeniusAccountingPosting> postings, {
    required String title,
    required String titleAr,
  }) {
    if (postings.isEmpty) {
      return _emptyFinancialReport(title, titleAr);
    }

    _validatePostings(postings, postings.first.currency);

    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'document',
          title: 'Document',
          titleAr: 'المستند',
        ),
        GeniusErpPackReportColumn(
          id: 'account',
          title: 'Account',
          titleAr: 'الحساب',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'البيان',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'debit',
          title: 'Debit',
          titleAr: 'مدين',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'credit',
          title: 'Credit',
          titleAr: 'دائن',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final posting in postings)
          GeniusErpPackReportRow(
            cells: {
              'date': posting.date.toIso8601String().split('T').first,
              'document': posting.documentNumber,
              'account': GeniusErpPackLocalizedValue(
                value:
                    '${posting.account.code} — ${posting.account.name}',
                valueAr:
                    '${posting.account.code} — '
                    '${posting.account.nameAr ?? posting.account.name}',
              ),
              'description': GeniusErpPackLocalizedValue(
                value: posting.description,
                valueAr: posting.descriptionAr,
              ),
              'debit': posting.debit.isZero
                  ? ''
                  : posting.debit.toDouble(),
              'credit': posting.credit.isZero
                  ? ''
                  : posting.credit.toDouble(),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData _aging(
    List<GeniusErpOpenItem> items, {
    required DateTime asOf,
    required String title,
    required String titleAr,
  }) {
    if (items.isEmpty) {
      return _emptyFinancialReport(title, titleAr);
    }

    final aging =
        const GeniusErpAgingService().calculate(items, asOf: asOf);

    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      subtitle:
          'As of ${asOf.toIso8601String().split('T').first}',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'bucket',
          title: 'Bucket',
          titleAr: 'الفترة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Outstanding',
          titleAr: 'الرصيد',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final bucket in aging.buckets)
          GeniusErpPackReportRow(
            cells: {
              'bucket': GeniusErpPackLocalizedValue(
                value: bucket.label,
                valueAr: bucket.labelAr,
              ),
              'amount': bucket.amount.toDouble(),
            },
          ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'bucket': 'Total',
            'amount': aging.total.toDouble(),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData _partyBalances(
    List<GeniusErpOpenItem> items, {
    required String title,
    required String titleAr,
  }) {
    if (items.isEmpty) {
      return _emptyFinancialReport(title, titleAr);
    }

    final grouped = <String, (String, String?, ErpMoney)>{};

    for (final item in items) {
      final current = grouped[item.partyId];
      if (current == null) {
        grouped[item.partyId] = (
          item.partyName,
          item.partyNameAr,
          item.outstanding,
        );
      } else {
        grouped[item.partyId] = (
          current.$1,
          current.$2,
          current.$3 + item.outstanding,
        );
      }
    }

    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'party',
          title: 'Party',
          titleAr: 'الطرف',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'balance',
          title: 'Balance',
          titleAr: 'الرصيد',
        ),
      ],
      rows: [
        for (final entry in grouped.entries)
          GeniusErpPackReportRow(
            cells: {
              'party': GeniusErpPackLocalizedValue(
                value: entry.value.$1,
                valueAr: entry.value.$2,
              ),
              'balance':
                  GeniusAccountingFormat.accounting(entry.value.$3),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData _groupBalance(
    List<GeniusAccountingPosting> postings, {
    required String Function(GeniusAccountingPosting) key,
    required String title,
    required String titleAr,
  }) {
    if (postings.isEmpty) {
      return _emptyFinancialReport(title, titleAr);
    }

    final currency = postings.first.currency;
    final grouped = <String, (ErpMoney, ErpMoney)>{};

    for (final posting in postings) {
      posting.validate();
      if (posting.currency != currency) {
        throw ArgumentError('Grouped accounting report requires one currency.');
      }
      final group = key(posting);
      final current = grouped[group] ??
          (
            ErpMoney.zero(currency),
            ErpMoney.zero(currency),
          );
      grouped[group] = (
        current.$1 + posting.debit,
        current.$2 + posting.credit,
      );
    }

    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'group',
          title: 'Group',
          titleAr: 'المجموعة',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'debit',
          title: 'Debit',
          titleAr: 'مدين',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'credit',
          title: 'Credit',
          titleAr: 'دائن',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'balance',
          title: 'Balance',
          titleAr: 'الرصيد',
        ),
      ],
      rows: [
        for (final entry in grouped.entries)
          GeniusErpPackReportRow(
            cells: {
              'group': entry.key,
              'debit': entry.value.$1.toDouble(),
              'credit': entry.value.$2.toDouble(),
              'balance': GeniusAccountingFormat.accounting(
                entry.value.$1 - entry.value.$2,
              ),
            },
          ),
      ],
    );
  }

  GeniusAccountingBalanceRow _balanceRow(
    String code,
    GeniusAccountingAccount? account,
    ErpMoney? opening,
    ErpMoney? debit,
    ErpMoney? credit,
  ) {
    final currency =
        opening?.currency ?? debit?.currency ?? credit?.currency;
    if (currency == null) {
      throw ArgumentError('Cannot determine account currency for $code.');
    }

    final effectiveOpening = opening ?? ErpMoney.zero(currency);
    final effectiveDebit = debit ?? ErpMoney.zero(currency);
    final effectiveCredit = credit ?? ErpMoney.zero(currency);

    return GeniusAccountingBalanceRow(
      code: code,
      name: account?.name ?? code,
      nameAr: account?.nameAr,
      opening: effectiveOpening,
      debit: effectiveDebit,
      credit: effectiveCredit,
      closing:
          effectiveOpening + effectiveDebit - effectiveCredit,
      level: account?.level ?? 0,
    );
  }

  double _periodAmount(
    List<GeniusAccountingPeriodAmount> values,
    String period,
  ) {
    for (final value in values) {
      if (value.period == period) {
        return value.amount.toDouble();
      }
    }
    return 0;
  }

  String _taxCategoryLabel(
    GeniusAccountingTaxCategory category,
  ) =>
      switch (category) {
        GeniusAccountingTaxCategory.taxable => 'Taxable',
        GeniusAccountingTaxCategory.exempt => 'Exempt',
        GeniusAccountingTaxCategory.zeroRated => 'Zero-rated',
      };

  ErpMoney _sum(
    Iterable<ErpMoney> values,
    ErpCurrency currency,
  ) {
    var result = ErpMoney.zero(currency);
    for (final value in values) {
      if (value.currency != currency) {
        throw ArgumentError('Currency mismatch in accounting sum.');
      }
      result = result + value;
    }
    return result;
  }

  void _validatePostings(
    List<GeniusAccountingPosting> postings,
    ErpCurrency currency,
  ) {
    for (final posting in postings) {
      posting.validate();
      if (posting.currency != currency) {
        throw ArgumentError(
          'Accounting report requires one currency per prepared report.',
        );
      }
    }
  }

  GeniusErpPackReportData _emptyFinancialReport(
    String title,
    String titleAr,
  ) =>
      GeniusErpPackReportData(
        title: title,
        titleAr: titleAr,
        columns: const [
          GeniusErpPackReportColumn(
            id: 'message',
            title: 'Result',
            titleAr: 'النتيجة',
          ),
        ],
        rows: const [
          GeniusErpPackReportRow(
            cells: {'message': 'No data'},
          ),
        ],
      );
}
