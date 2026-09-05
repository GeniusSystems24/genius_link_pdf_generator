
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  const service = GeniusAccountingService();
  final postings = List.generate(
    10000,
    (index) => GeniusAccountingPosting(
      date: DateTime(2026, 1, (index % 28) + 1),
      documentNumber: 'JV-${index + 1}',
      account: GeniusAccountingAccount(
        code: '10${index % 100}',
        name: 'Account ${index % 100}',
        level: index % 6,
      ),
      description: '10k accounting benchmark row ${index + 1}',
      debit: ErpMoney.fromAmount(
        index.isEven ? 1 : 0,
        currency: ErpCurrency.sar,
      ),
      credit: ErpMoney.fromAmount(
        index.isOdd ? 1 : 0,
        currency: ErpCurrency.sar,
      ),
    ),
  );

  final stopwatch = Stopwatch()..start();
  final report = service.generalLedger(
    postings,
    openingBalance: ErpMoney.zero(ErpCurrency.sar),
  );
  stopwatch.stop();

  print(
    'S14 accounting preparation: '
    '${report.rows.length} rows in ${stopwatch.elapsedMilliseconds} ms',
  );
}
