import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/src/domain/financial/financial.dart';
import 'package:genius_link_pdf_generator/src/models/pdf_result.dart';

void main() {
  final policy = GeniusRoundingPolicy.defaults();
  late GeniusFinancialValidator v;

  setUp(() {
    v = GeniusFinancialValidator(policy);
  });

  // ── SC-006 regression suite ───────────────────────────────────────────────

  group('Zero amounts', () {
    test('zero items, subtotal = 0 passes', () {
      final r = v.validateSubtotal(lineTotals: [], providedSubtotal: 0.0);
      expect(r.isValid, isTrue);
    });

    test('zero grand total (all zeros) passes', () {
      final r = v.validateGrandTotal(
        subtotal: 0.0,
        discounts: 0.0,
        vatAmount: 0.0,
        fees: 0.0,
        providedGrandTotal: 0.0,
      );
      expect(r.isValid, isTrue);
    });
  });

  group('Negative amounts (credit notes / refunds)', () {
    test('negative line totals summing to -800 passes', () {
      final r = v.validateSubtotal(
        lineTotals: [-500.00, -300.00],
        providedSubtotal: -800.00,
      );
      expect(r.isValid, isTrue);
    });

    test('negative grand total passes', () {
      final r = v.validateGrandTotal(
        subtotal: -1000.00,
        discounts: 0.0,
        vatAmount: -150.00,
        fees: 0.0,
        providedGrandTotal: -1150.00,
      );
      expect(r.isValid, isTrue);
    });
  });

  group('Large amounts', () {
    test('999999999.99 rounds correctly at 2dp', () {
      final m = GeniusMoney.fromDouble(999999999.99, policy: policy);
      expect(m.toDouble(), closeTo(999999999.99, 1e-4));
      expect(m.minorUnits, 99999999999);
    });

    test('large subtotal validation passes', () {
      final r = v.validateSubtotal(
        lineTotals: [500000000.00, 499999999.99],
        providedSubtotal: 999999999.99,
      );
      expect(r.isValid, isTrue);
    });
  });

  group('Rounding boundary cases', () {
    test('roundForWords(1499.9999999) → 1500.00 (no floating-point noise)', () {
      expect(v.roundForWords(1499.9999999), closeTo(1500.00, 1e-9));
    });

    test('roundForWords(100.004) → 100.00', () {
      expect(v.roundForWords(100.004), closeTo(100.00, 1e-9));
    });

    test('roundForWords(100.005) → 100.01 (halfUp)', () {
      expect(v.roundForWords(100.005), closeTo(100.01, 1e-9));
    });

    test('round(2.345) at 2dp halfUp → 2.35', () {
      expect(policy.round(2.345), closeTo(2.35, 1e-9));
    });
  });

  group('Multi-currency two-stage', () {
    test('500 USD × 3.75 = 1875.00 SAR passes', () {
      final srcPolicy = GeniusRoundingPolicy.forCurrency('USD');
      final r = v.validateCurrencyConversion(
        sourceAmount: 500.00,
        exchangeRate: 3.75,
        providedTargetAmount: 1875.00,
        sourceCurrencyPolicy: srcPolicy,
      );
      expect(r.isValid, isTrue);
    });

    test('wrong target amount fails with bilingual error', () {
      final r = v.validateCurrencyConversion(
        sourceAmount: 500.00,
        exchangeRate: 3.75,
        providedTargetAmount: 1874.00,
      );
      expect(r.isValid, isFalse);
      expect(r.errors.first.message, isNotEmpty);
      expect(r.errors.first.messageAr, isNotEmpty);
    });
  });

  group('Accumulation behaviour', () {
    test('100 lines of raw 0.333: sum = 33.3 → rounded subtotal = 33.30 passes', () {
      // The validator sums raw doubles, then rounds once.
      // sum(100 × 0.333) = 33.3 → round(33.3) = 33.30
      final lines = List.filled(100, 0.333);
      final r = v.validateSubtotal(lineTotals: lines, providedSubtotal: 33.30);
      expect(r.isValid, isTrue);
    });

    test('100 lines individually rounded to 0.33: sum = 33.00 FAILS against 33.30', () {
      // If a caller pre-rounds each line to 0.33 and sums, they get 33.00,
      // which does NOT match the validator's expected 33.30.
      // This test documents the accumulation error that per-field rounding avoids.
      final lines = List.filled(100, 0.333);
      final r = v.validateSubtotal(lineTotals: lines, providedSubtotal: 33.00);
      expect(r.isValid, isFalse);
    });
  });

  group('VAT post-discount correctness (ZATCA)', () {
    test('subtotal=1000, discount=100, vatBase=900 → vat=135, NOT 150', () {
      const vatBase = 1000.00 - 100.00; // 900
      final r = v.validateVat(
          vatBase: vatBase, vatRate: 15.0, providedVatAmount: 135.00);
      expect(r.isValid, isTrue);
    });

    test('vat=150 fails because it uses pre-discount base', () {
      final r = v.validateVat(
          vatBase: 900.00, vatRate: 15.0, providedVatAmount: 150.00);
      expect(r.isValid, isFalse);
    });

    test('full ZATCA scenario: subtotal=1000, discount=100, vatBase=900, vat=135, grand=1035', () {
      const subtotal = 1000.00;
      const discount = 100.00;
      const vatBase = subtotal - discount;
      final vat = GeniusRoundingPolicy.defaults().round(vatBase * 0.15);
      final grand = vatBase + vat;

      final rVat = v.validateVat(
          vatBase: vatBase, vatRate: 15.0, providedVatAmount: vat);
      final rGrand = v.validateGrandTotal(
        subtotal: subtotal,
        discounts: discount,
        vatAmount: vat,
        fees: 0.0,
        providedGrandTotal: grand,
      );

      expect(vat, closeTo(135.00, 1e-9));
      expect(grand, closeTo(1035.00, 1e-9));
      expect(rVat.isValid, isTrue);
      expect(rGrand.isValid, isTrue);
    });
  });

  // ── AmountToWords pre-rounding ─────────────────────────────────────────────

  group('AmountToWords pre-rounding', () {
    test('roundForWords(1499.9999999) → 1500.00', () {
      final result = v.roundForWords(1499.9999999);
      expect(result, closeTo(1500.00, 1e-9));
      // Verify truncate() on the pre-rounded value gives 1500, not 1499
      expect(result.truncate(), 1500);
    });

    test('roundForWords(100.004) → 100.00', () {
      final result = v.roundForWords(100.004);
      expect(result, closeTo(100.00, 1e-9));
      expect(result.truncate(), 100);
    });
  });

  // ── GeniusPdfFailure.fromValidation ───────────────────────────────────────

  group('GeniusPdfFailure.fromValidation', () {
    test('fromValidation carries validationResult', () {
      final vr = v.validateSubtotal(
          lineTotals: [100.00], providedSubtotal: 200.00);
      final failure = GeniusPdfFailure.fromValidation(vr);
      expect(failure.validationResult, isNotNull);
      expect(failure.validationResult!.isValid, isFalse);
      expect(failure.message, isNotEmpty);
    });

    test('validationResult getter returns null for non-validation failures', () {
      final failure = GeniusPdfFailure.fromException(Exception('oops'));
      expect(failure.validationResult, isNull);
    });
  });
}
