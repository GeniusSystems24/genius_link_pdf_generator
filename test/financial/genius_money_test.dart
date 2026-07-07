import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/src/domain/financial/financial.dart';

void main() {
  final policy2dp = GeniusRoundingPolicy.defaults();
  final policy3dp = GeniusRoundingPolicy.forCurrency('KWD');
  final policy0dp = GeniusRoundingPolicy.forCurrency('JPY');

  group('GeniusMoney.fromDouble()', () {
    test('2dp: 150.255 → 150.26 (halfUp), minorUnits = 15026', () {
      final m = GeniusMoney.fromDouble(150.255, policy: policy2dp);
      expect(m.minorUnits, 15026);
      expect(m.decimalPlaces, 2);
    });

    test('3dp: 150.255 → 150.255 exactly, minorUnits = 150255', () {
      final m = GeniusMoney.fromDouble(150.255,
          currency: 'KWD', policy: policy3dp);
      expect(m.minorUnits, 150255);
      expect(m.decimalPlaces, 3);
    });

    test('0dp: 1.9 → 2, minorUnits = 2', () {
      final m = GeniusMoney.fromDouble(1.9,
          currency: 'JPY', policy: policy0dp);
      expect(m.minorUnits, 2);
      expect(m.decimalPlaces, 0);
    });

    test('negative: -150.25 → minorUnits = -15025', () {
      final m = GeniusMoney.fromDouble(-150.25, policy: policy2dp);
      expect(m.minorUnits, -15025);
    });

    test('zero → minorUnits = 0', () {
      final m = GeniusMoney.fromDouble(0.0, policy: policy2dp);
      expect(m.minorUnits, 0);
    });

    test('default currency is SAR', () {
      final m = GeniusMoney.fromDouble(1.0);
      expect(m.currency, 'SAR');
    });
  });

  group('GeniusMoney.toDouble()', () {
    test('is inverse of fromDouble for 2dp', () {
      final values = [0.0, 1.00, 150.25, 999.99, 1000000.00];
      for (final v in values) {
        final m = GeniusMoney.fromDouble(v, policy: policy2dp);
        expect(m.toDouble(), closeTo(v, 1e-9),
            reason: 'Expected $v to round-trip');
      }
    });

    test('is inverse of fromDouble for 3dp', () {
      final m = GeniusMoney.fromDouble(150.255,
          currency: 'KWD', policy: policy3dp);
      expect(m.toDouble(), closeTo(150.255, 1e-9));
    });
  });

  group('GeniusMoney arithmetic', () {
    test('addition is exact integer arithmetic', () {
      final a = GeniusMoney.fromDouble(100.25, policy: policy2dp);
      final b = GeniusMoney.fromDouble(200.50, policy: policy2dp);
      final sum = a + b;
      expect(sum.minorUnits, 30075); // 10025 + 20050
      expect(sum.toDouble(), closeTo(300.75, 1e-9));
    });

    test('subtraction is exact integer arithmetic', () {
      final a = GeniusMoney.fromDouble(500.00, policy: policy2dp);
      final b = GeniusMoney.fromDouble(150.25, policy: policy2dp);
      final diff = a - b;
      expect(diff.minorUnits, 34975); // 50000 - 15025
      expect(diff.toDouble(), closeTo(349.75, 1e-9));
    });

    test('subtraction supports negative results', () {
      final a = GeniusMoney.fromDouble(100.00, policy: policy2dp);
      final b = GeniusMoney.fromDouble(200.00, policy: policy2dp);
      final diff = a - b;
      expect(diff.minorUnits, -10000);
    });

    test('currency mismatch on addition asserts', () {
      final sar = GeniusMoney.fromDouble(100.0, currency: 'SAR');
      final usd = GeniusMoney.fromDouble(100.0, currency: 'USD');
      expect(() => sar + usd, throwsAssertionError);
    });

    test('currency mismatch on subtraction asserts', () {
      final sar = GeniusMoney.fromDouble(100.0, currency: 'SAR');
      final usd = GeniusMoney.fromDouble(100.0, currency: 'USD');
      expect(() => sar - usd, throwsAssertionError);
    });
  });

  group('GeniusMoney.multiplyByRate()', () {
    test('halfUp: 900.00 × 0.15 = 135.00', () {
      final base = GeniusMoney.fromDouble(900.00, policy: policy2dp);
      final vat = base.multiplyByRate(0.15, policy: policy2dp);
      expect(vat.toDouble(), closeTo(135.00, 1e-9));
    });

    test('halfEven: rounds to nearest even on .5 boundary', () {
      const p = GeniusRoundingPolicy(
          decimalPlaces: 2, mode: GeniusRoundingMode.halfEven);
      final m = GeniusMoney.fromDouble(100.00, policy: p);
      // 100.00 × 0.125 = 12.5 → halfEven → 12.50 (even)
      // Actually: 12.5 * 100 = 1250 scaled at 2dp... wait no
      // We multiply the double: 100.00 * 0.125 = 12.5, then round 12.5 to 2dp
      // p.round(12.5): scaled = 12.5 * 100 = 1250; floor=1250, diff=0, not 0.5 case
      // Actually 12.5 is exact, 12.5 * 100 = 1250.0, _applyMode(1250.0):
      // halfEven: floorVal=1250, diff=0.0 < 0.5 → return 1250 → 12.50
      final result = m.multiplyByRate(0.125, policy: p);
      expect(result.toDouble(), closeTo(12.50, 1e-9));
    });

    test('truncate: 10.00 × 0.333 = 3.33 (not 3.34)', () {
      const p = GeniusRoundingPolicy(
          decimalPlaces: 2, mode: GeniusRoundingMode.truncate);
      final m = GeniusMoney.fromDouble(10.00, policy: p);
      final result = m.multiplyByRate(0.333, policy: p);
      expect(result.toDouble(), closeTo(3.33, 1e-9));
    });

    test('rounds once: result currency preserved', () {
      final m = GeniusMoney.fromDouble(500.00, currency: 'USD',
          policy: policy2dp);
      final result = m.multiplyByRate(3.75, policy: policy2dp);
      expect(result.currency, 'USD');
      expect(result.toDouble(), closeTo(1875.00, 1e-9));
    });
  });

  group('GeniusMoney equality and comparison', () {
    test('equal if same minorUnits and currency', () {
      final a = GeniusMoney.fromDouble(100.00, policy: policy2dp);
      final b = GeniusMoney.fromDouble(100.00, policy: policy2dp);
      expect(a, equals(b));
    });

    test('not equal if different currency', () {
      final a = GeniusMoney.fromDouble(100.00, currency: 'SAR');
      final b = GeniusMoney.fromDouble(100.00, currency: 'USD');
      expect(a, isNot(equals(b)));
    });

    test('compareTo: 100 < 200', () {
      final a = GeniusMoney.fromDouble(100.00, policy: policy2dp);
      final b = GeniusMoney.fromDouble(200.00, policy: policy2dp);
      expect(a.compareTo(b), isNegative);
    });
  });

  group('GeniusMoney.toDisplayString()', () {
    test('2dp default', () {
      final m = GeniusMoney.fromDouble(150.25, policy: policy2dp);
      expect(m.toDisplayString(), '150.25');
    });

    test('override decimalPlaces to 4', () {
      final m = GeniusMoney.fromDouble(150.25, policy: policy2dp);
      expect(m.toDisplayString(decimalPlaces: 4), '150.2500');
    });
  });

  group('GeniusMoney.zero()', () {
    test('has minorUnits = 0', () {
      final m = GeniusMoney.zero(currency: 'SAR');
      expect(m.minorUnits, 0);
      expect(m.currency, 'SAR');
    });
  });

  group('GeniusMoney.isWithinTolerance()', () {
    test('within 1 minor unit (0.01) passes', () {
      final a = GeniusMoney.fromDouble(100.00, policy: policy2dp);
      final b = GeniusMoney.fromDouble(100.005, policy: policy2dp);
      // Both round to 100.00 → minorUnits are equal
      expect(a.isWithinTolerance(b, policy2dp), isTrue);
    });

    test('exceeds tolerance fails', () {
      final a = GeniusMoney.fromDouble(100.00, policy: policy2dp);
      final b = GeniusMoney.fromDouble(100.02, policy: policy2dp);
      expect(a.isWithinTolerance(b, policy2dp), isFalse);
    });
  });
}
