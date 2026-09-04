import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  group('S05 formatter', () {
    test('money uses one source for separators and precision', () {
      const formatter = GeniusPdfDefaultFormatter(
        settings: GeniusPdfFormatSettings(
          locale: 'en_US',
          digitPolicy: GeniusPdfDigitPolicy.latin,
          currencyDisplay: GeniusPdfCurrencyDisplay.code,
          currencyPosition: GeniusPdfCurrencyPosition.after,
        ),
      );
      expect(formatter.formatMoney(15697.5, currencyCode: 'SAR'), '15,697.50 SAR');
      expect(formatter.formatMoney(2047.5, currencyCode: 'USD'), '2,047.50 USD');
    });

    test('decimal precision is explicit', () {
      const formatter = GeniusPdfDefaultFormatter();
      expect(formatter.formatNumber(12.3456, decimalPlaces: 0), '12');
      expect(formatter.formatNumber(12.3456, decimalPlaces: 2), '12.35');
      expect(formatter.formatNumber(12.3456, decimalPlaces: 4), '12.3456');
    });

    test('negative accounting values use parentheses', () {
      const formatter = GeniusPdfDefaultFormatter(
        settings: GeniusPdfFormatSettings(
          negativeFormat: GeniusPdfNegativeFormat.accounting,
        ),
      );
      expect(formatter.formatMoney(-1250, currencyCode: 'SAR'), '(1,250.00 SAR)');
    });

    test('Arabic digit policy is deterministic', () {
      const formatter = GeniusPdfDefaultFormatter(
        settings: GeniusPdfFormatSettings(
          locale: 'ar_SA',
          digitPolicy: GeniusPdfDigitPolicy.arabicIndic,
          currencyDisplay: GeniusPdfCurrencyDisplay.code,
          currencyPosition: GeniusPdfCurrencyPosition.after,
        ),
      );
      final value = formatter.formatMoney(15697.5, currencyCode: 'SAR');
      expect(value, contains('١'));
      expect(value, contains('٥'));
      expect(value, contains('SAR'));
    });

    test('identifier is never digit-shaped or reversed', () {
      const formatter = GeniusPdfDefaultFormatter(
        settings: GeniusPdfFormatSettings(
          locale: 'ar_SA',
          digitPolicy: GeniusPdfDigitPolicy.arabicIndic,
        ),
      );
      expect(formatter.formatIdentifier('INV-2026-000123'), 'INV-2026-000123');
      expect(formatter.formatIdentifier('SKU-00125'), 'SKU-00125');
    });

    test('null placeholder is shared', () {
      const formatter = GeniusPdfDefaultFormatter(
        settings: GeniusPdfFormatSettings(
          nullPolicy: GeniusPdfNullPlaceholderPolicy.emDash(),
        ),
      );
      expect(formatter.formatNumber(null), '—');
      expect(formatter.formatMoney(null), '—');
      expect(formatter.formatIdentifier(null), '—');
    });

    test('percentage quantity date time rate and unit are shared', () {
      const formatter = GeniusPdfDefaultFormatter(
        settings: GeniusPdfFormatSettings(locale: 'en_US'),
      );
      expect(formatter.formatPercentage(0.15, isFraction: true, decimalPlaces: 2), '15.00%');
      expect(formatter.formatQuantity(1250.5, unit: 'KG', decimalPlaces: 3), '1,250.500 KG');
      expect(formatter.formatDate(DateTime(2026, 9, 4)), '2026-09-04');
      expect(formatter.formatTime(DateTime(2026, 9, 4, 14, 5)), '14:05');
      expect(formatter.formatExchangeRate(3.75, from: 'USD', to: 'SAR', decimalPlaces: 4), '1 USD = 3.7500 SAR');
    });
  });
}
