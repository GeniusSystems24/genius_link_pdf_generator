import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  test('Summary and Grid use the same shared formatter result', () {
    const formatter = GeniusPdfDefaultFormatter(
      settings: GeniusPdfFormatSettings(
        locale: 'en_US',
        currencyDisplay: GeniusPdfCurrencyDisplay.code,
        currencyPosition: GeniusPdfCurrencyPosition.after,
      ),
    );

    final summary = GeniusPdfSummaryItem.formatted(
      label: 'Total',
      rawValue: 15697.5,
      formatter: formatter,
      formatSpec: const GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
    );

    const column = GeniusPdfGridColumn(
      id: 'amount',
      title: 'Amount',
      formatSpec: GeniusPdfFormatSpec.money(currencyCode: 'SAR'),
    );
    const row = GeniusPdfGridRow(cells: {'amount': 15697.5});

    expect(
      row.getFormattedValue(column, formatter: formatter),
      summary.value,
    );
    expect(summary.value, '15,697.50 SAR');
  });

  test('legacy string APIs remain valid', () {
    const summary = GeniusPdfSummaryItem(label: 'Legacy', value: '15,697.50 SAR');
    const column = GeniusPdfGridColumn(id: 'value', title: 'Value');
    const row = GeniusPdfGridRow(cells: {'value': 'legacy'});
    expect(summary.getFormattedValue(), '15,697.50 SAR');
    expect(row.getFormattedValue(column), 'legacy');
  });
}
