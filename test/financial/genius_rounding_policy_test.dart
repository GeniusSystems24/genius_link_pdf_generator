import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/src/domain/financial/financial.dart';

void main() {
  group('GeniusRoundingMode via GeniusRoundingPolicy.round()', () {
    test('halfUp rounds 2.345 → 2.35 (2dp)', () {
      const p = GeniusRoundingPolicy(
          decimalPlaces: 2, mode: GeniusRoundingMode.halfUp);
      expect(p.round(2.345), closeTo(2.35, 1e-10));
    });

    test('halfEven rounds 0dp: 2.5 → 2 (rounds to nearest even)', () {
      const p = GeniusRoundingPolicy(
          decimalPlaces: 0, mode: GeniusRoundingMode.halfEven);
      // 2.5 is exactly representable; 2 is even so halfEven stays at 2
      expect(p.round(2.5), closeTo(2.0, 1e-10));
    });

    test('halfEven rounds 0dp: 3.5 → 4 (rounds to nearest even)', () {
      const p = GeniusRoundingPolicy(
          decimalPlaces: 0, mode: GeniusRoundingMode.halfEven);
      // 3.5 is exactly representable; 3 is odd so halfEven rounds up to 4
      expect(p.round(3.5), closeTo(4.0, 1e-10));
    });

    test('truncate rounds 2.999 → 2.99 (2dp, toward zero)', () {
      const p = GeniusRoundingPolicy(
          decimalPlaces: 2, mode: GeniusRoundingMode.truncate);
      expect(p.round(2.999), closeTo(2.99, 1e-10));
    });

    test('truncate rounds -2.999 → -2.99 (toward zero)', () {
      const p = GeniusRoundingPolicy(
          decimalPlaces: 2, mode: GeniusRoundingMode.truncate);
      expect(p.round(-2.999), closeTo(-2.99, 1e-10));
    });

    test('floor rounds 2.991 → 2.99 (2dp, toward −∞)', () {
      const p =
          GeniusRoundingPolicy(decimalPlaces: 2, mode: GeniusRoundingMode.floor);
      expect(p.round(2.991), closeTo(2.99, 1e-10));
    });

    test('ceiling rounds 2.901 → 2.91 (2dp, toward +∞)', () {
      const p = GeniusRoundingPolicy(
          decimalPlaces: 2, mode: GeniusRoundingMode.ceiling);
      expect(p.round(2.901), closeTo(2.91, 1e-10));
    });

    test('halfUp handles negative: -2.345 → -2.35 (away from zero)', () {
      const p = GeniusRoundingPolicy(
          decimalPlaces: 2, mode: GeniusRoundingMode.halfUp);
      expect(p.round(-2.345), closeTo(-2.35, 1e-10));
    });
  });

  group('GeniusRoundingPolicy factories', () {
    test('defaults() → 2dp, halfUp, no absolute override', () {
      final p = GeniusRoundingPolicy.defaults();
      expect(p.decimalPlaces, 2);
      expect(p.mode, GeniusRoundingMode.halfUp);
      expect(p.absoluteTolerance, isNull);
      expect(p.relativeTolerance, isNull);
    });

    test('strict() → absoluteTolerance = 0.0', () {
      final p = GeniusRoundingPolicy.strict();
      expect(p.absoluteTolerance, 0.0);
    });

    test('forCurrency(KWD) → 3dp', () {
      final p = GeniusRoundingPolicy.forCurrency('KWD');
      expect(p.decimalPlaces, 3);
    });

    test('forCurrency(JPY) → 0dp', () {
      final p = GeniusRoundingPolicy.forCurrency('JPY');
      expect(p.decimalPlaces, 0);
    });

    test('forCurrency(SAR) → 2dp (default)', () {
      final p = GeniusRoundingPolicy.forCurrency('SAR');
      expect(p.decimalPlaces, 2);
    });

    test('withRelative(0.001) → relativeTolerance = 0.001', () {
      final p = GeniusRoundingPolicy.withRelative(0.001);
      expect(p.relativeTolerance, 0.001);
    });
  });

  group('GeniusRoundingPolicy.isWithinTolerance()', () {
    test('absolute only: 0.01 tolerance — 0.005 diff passes', () {
      const p = GeniusRoundingPolicy(absoluteTolerance: 0.01);
      expect(p.isWithinTolerance(1000.00, 999.995), isTrue);
    });

    test('absolute only: 0.01 tolerance — 0.015 diff fails', () {
      const p = GeniusRoundingPolicy(absoluteTolerance: 0.01);
      expect(p.isWithinTolerance(1000.00, 999.985), isFalse);
    });

    test('default: 1 minor unit (0.01) tolerance — 0.005 passes', () {
      final p = GeniusRoundingPolicy.defaults();
      expect(p.isWithinTolerance(1000.00, 999.995), isTrue);
    });

    test('default: 1 minor unit (0.01) tolerance — 0.015 fails', () {
      final p = GeniusRoundingPolicy.defaults();
      expect(p.isWithinTolerance(1000.00, 999.985), isFalse);
    });

    test('relative only: 0.1% of 1000 = 1.0 — 0.50 diff passes', () {
      final p = GeniusRoundingPolicy.withRelative(0.001); // 0.1%
      expect(p.isWithinTolerance(1000.00, 999.50), isTrue);
    });

    test('relative only: 0.1% of 1000 = 1.0 — 1.5 diff fails', () {
      final p = GeniusRoundingPolicy.withRelative(0.001);
      expect(p.isWithinTolerance(1000.00, 998.50), isFalse);
    });

    test('both tolerances: looser (relative 1.0) wins over absolute 0.01', () {
      const p = GeniusRoundingPolicy(
          absoluteTolerance: 0.01, relativeTolerance: 0.001);
      // relLimit = 0.001 × 1000 = 1.0; diff = 0.5 ≤ 1.0 → passes
      expect(p.isWithinTolerance(1000.00, 999.50), isTrue);
      // diff = 1.5 > 1.0 → fails
      expect(p.isWithinTolerance(1000.00, 998.50), isFalse);
    });

    test('strict(): exact match required — 0.001 diff fails', () {
      final p = GeniusRoundingPolicy.strict();
      expect(p.isWithinTolerance(100.00, 99.999), isFalse);
      expect(p.isWithinTolerance(100.00, 100.00), isTrue);
    });

    test('3dp (KWD) default tolerance is 0.001', () {
      final p = GeniusRoundingPolicy.forCurrency('KWD');
      // Use non-boundary values to avoid IEEE 754 rounding at the 0.001 edge.
      expect(p.isWithinTolerance(100.000, 99.9991), isTrue);  // diff=0.0009 < 0.001
      expect(p.isWithinTolerance(100.000, 99.998), isFalse);  // diff=0.002 > 0.001
    });
  });
}
