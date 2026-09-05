
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

GeniusAccountingPosting posting({
  required String account,
  required double debit,
  required double credit,
  int level = 0,
  String? costCenter,
  String? project,
  ErpCurrency currency = ErpCurrency.sar,
  int day = 1,
}) =>
    GeniusAccountingPosting(
      date: DateTime(2026, 9, day),
      documentNumber: 'JV-$account-$day',
      account: GeniusAccountingAccount(
        code: account,
        name: 'Account $account',
        nameAr: 'حساب $account',
        level: level,
      ),
      description: 'Posting $account',
      descriptionAr: 'قيد $account',
      debit: ErpMoney.fromAmount(debit, currency: currency),
      credit: ErpMoney.fromAmount(credit, currency: currency),
      costCenter: costCenter,
      project: project,
    );

void main() {
  const service = GeniusAccountingService();

  test('journal reconciliation is balanced before rendering', () {
    final report = service.journalEntry([
      posting(account: '1000', debit: 100, credit: 0),
      posting(account: '4000', debit: 0, credit: 100),
    ]);

    expect(report.rows.last.isTotal, isTrue);
    expect(report.rows.last.cells['debit'], 100);
    expect(report.rows.last.cells['credit'], 100);
    expect(report.rows.last.cells['description'], 'Balanced');
  });

  test('accounting negatives use parentheses and zero uses dash', () {
    final negative = ErpMoney.fromAmount(
      -123.45,
      currency: ErpCurrency.sar,
    );
    final zero = ErpMoney.zero(ErpCurrency.sar);

    expect(
      GeniusAccountingFormat.accounting(negative),
      contains('(123.45 SAR)'),
    );
    expect(GeniusAccountingFormat.accounting(zero), '-');
  });

  test('opening movement closing remains deterministic', () {
    final rows = service.openingMovementClosing(
      [
        posting(account: '1000', debit: 25, credit: 0),
        posting(account: '1000', debit: 0, credit: 10),
      ],
      openingByAccount: {
        '1000': ErpMoney.fromAmount(
          100,
          currency: ErpCurrency.sar,
        ),
      },
    );

    expect(rows, hasLength(1));
    expect(rows.single.opening.toDouble(), 100);
    expect(rows.single.debit.toDouble(), 25);
    expect(rows.single.credit.toDouble(), 10);
    expect(rows.single.closing.toDouble(), 115);
  });

  test('carry/brought-forward policy inserts deterministic rows', () {
    final report = service.generalLedger(
      List.generate(
        5,
        (index) => posting(
          account: '1000',
          debit: 1,
          credit: 0,
          day: index + 1,
        ),
      ),
      openingBalance: ErpMoney.zero(ErpCurrency.sar),
      carryPolicy: GeniusAccountingCarryPolicy.estimatedPageRows,
      estimatedRowsPerPage: 2,
    );

    final labels = report.rows
        .map((row) => row.cells['account'])
        .whereType<String>()
        .toList();

    expect(labels.where((value) => value == 'Carried Forward').length, 2);
    expect(labels.where((value) => value == 'Brought Forward').length, 2);
  });

  test('decimal precision honors currency precision', () {
    final kwd = ErpMoney.fromAmount(
      1.2346,
      currency: ErpCurrency.kwd,
    );
    final jpy = ErpMoney.fromAmount(
      10.6,
      currency: ErpCurrency.jpy,
    );

    expect(kwd.toDouble(), 1.235);
    expect(jpy.toDouble(), 11);
  });

  test('multi-currency ledger preparation stays separated by currency', () {
    final reports = service.ledgersByCurrency(
      [
        posting(
          account: '1000',
          debit: 10,
          credit: 0,
          currency: ErpCurrency.sar,
        ),
        posting(
          account: '1000',
          debit: 5,
          credit: 0,
          currency: ErpCurrency.usd,
        ),
      ],
    );

    expect(reports.keys.toSet(), {'SAR', 'USD'});
    expect(reports['SAR']!.rows, hasLength(1));
    expect(reports['USD']!.rows, hasLength(1));
  });

  test('hierarchy helper adds subtotal rows', () {
    final rows = service.openingMovementClosing(
      [
        posting(account: '1.01', debit: 10, credit: 0),
        posting(account: '1.02', debit: 5, credit: 0),
      ],
      openingByAccount: const {},
    );

    final withSubtotals = service.addTopLevelSubtotals(rows);

    expect(withSubtotals.last.isSubtotal, isTrue);
    expect(withSubtotals.last.debit.toDouble(), 15);
  });

  test('mixed currency ledger is rejected instead of silently combined', () {
    expect(
      () => service.generalLedger(
        [
          posting(
            account: '1000',
            debit: 10,
            credit: 0,
            currency: ErpCurrency.sar,
          ),
          posting(
            account: '1000',
            debit: 10,
            credit: 0,
            currency: ErpCurrency.usd,
          ),
        ],
        openingBalance: ErpMoney.zero(ErpCurrency.sar),
      ),
      throwsArgumentError,
    );
  });

  test('long chart hierarchy remains semantic data, not manual RTL text', () {
    final report = service.generalLedger(
      [
        posting(
          account: '1.01.001.0001',
          debit: 10,
          credit: 0,
          level: 8,
        ),
      ],
      openingBalance: ErpMoney.zero(ErpCurrency.sar),
    );

    expect(report.rows, isNotEmpty);
    expect(
      report.rows.single.cells['account'],
      isA<GeniusErpPackLocalizedValue>(),
    );
  });

  test('10k ledger preparation is supported', () {
    final report = service.generalLedger(
      List.generate(
        10000,
        (index) => posting(
          account: '10${index % 20}',
          debit: index.isEven ? 1 : 0,
          credit: index.isOdd ? 1 : 0,
          day: (index % 28) + 1,
        ),
      ),
      openingBalance: ErpMoney.zero(ErpCurrency.sar),
    );

    expect(report.rows, hasLength(10000));
  });
}
