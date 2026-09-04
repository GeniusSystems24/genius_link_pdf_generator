import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  test('S05 multi-currency formatting golden', () {
    const formatter = GeniusPdfDefaultFormatter(
      settings: GeniusPdfFormatSettings(
        locale: 'en_US',
        digitPolicy: GeniusPdfDigitPolicy.latin,
        currencyDisplay: GeniusPdfCurrencyDisplay.code,
        currencyPosition: GeniusPdfCurrencyPosition.after,
      ),
    );
    final actual = [
      'SAR=${formatter.formatMoney(15697.5, currencyCode: 'SAR')}',
      'USD=${formatter.formatMoney(2047.5, currencyCode: 'USD')}',
      'EUR=${formatter.formatMoney(-1250, currencyCode: 'EUR', negativeFormat: GeniusPdfNegativeFormat.accounting)}',
      'PCT=${formatter.formatPercentage(0.15, isFraction: true, decimalPlaces: 2)}',
      'QTY=${formatter.formatQuantity(1250.5, unit: 'KG', decimalPlaces: 3)}',
      'ID=${formatter.formatIdentifier('INV-2026-000123')}',
    ].join('\n');
    final expected = File('test/goldens/s05/multi_currency_expected.txt').readAsStringSync().trim();
    expect(actual, expected);
  });
}
