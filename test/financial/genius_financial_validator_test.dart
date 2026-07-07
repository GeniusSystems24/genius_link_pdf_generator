import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/src/domain/financial/financial.dart';

void main() {
  final policy = GeniusRoundingPolicy.defaults();
  late GeniusFinancialValidator v;

  setUp(() {
    v = GeniusFinancialValidator(policy);
  });

  // ── validateSubtotal ──────────────────────────────────────────────────────

  group('validateSubtotal', () {
    test('pass: [500, 300, 200] sum = 1000, provided = 1000', () {
      final r = v.validateSubtotal(
          lineTotals: [500.00, 300.00, 200.00], providedSubtotal: 1000.00);
      expect(r.isValid, isTrue);
    });

    test('fail: provided 950 differs from sum 1000 by 50 > 0.01', () {
      final r = v.validateSubtotal(
          lineTotals: [500.00, 300.00, 200.00], providedSubtotal: 950.00);
      expect(r.isValid, isFalse);
      expect(r.errors.first.fieldId, 'subtotal');
      expect(r.errors.first.ruleId, 'subtotal_sum');
      expect(r.errors.first.messageAr, isNotEmpty);
    });

    test('pass: empty list with provided = 0', () {
      final r = v.validateSubtotal(lineTotals: [], providedSubtotal: 0.0);
      expect(r.isValid, isTrue);
    });
  });

  // ── validateVat ───────────────────────────────────────────────────────────

  group('validateVat', () {
    test('pass: post-discount base=900, rate=15%, vat=135.00', () {
      final r = v.validateVat(
          vatBase: 900.00, vatRate: 15.0, providedVatAmount: 135.00);
      expect(r.isValid, isTrue);
    });

    test('fail: provided 150.00 uses pre-discount base (1000×15% instead of 900×15%)', () {
      final r = v.validateVat(
          vatBase: 900.00, vatRate: 15.0, providedVatAmount: 150.00);
      expect(r.isValid, isFalse);
      expect(r.errors.first.fieldId, 'vat_amount');
      expect(r.errors.first.messageAr, isNotEmpty);
    });

    test('fail: small rounding off (135.01 instead of 135.00)', () {
      final r = v.validateVat(
          vatBase: 900.00, vatRate: 15.0, providedVatAmount: 135.02);
      expect(r.isValid, isFalse);
    });
  });

  // ── validateGrandTotal ────────────────────────────────────────────────────

  group('validateGrandTotal', () {
    test('pass: subtotal=900 + vat=135 = grand=1035', () {
      final r = v.validateGrandTotal(
        subtotal: 900.00,
        discounts: 0.0,
        vatAmount: 135.00,
        fees: 0.0,
        providedGrandTotal: 1035.00,
      );
      expect(r.isValid, isTrue);
    });

    test('pass: full formula subtotal=1000, discount=100, vat=135, fees=0, grand=1035', () {
      final r = v.validateGrandTotal(
        subtotal: 1000.00,
        discounts: 100.00,
        vatAmount: 135.00,
        fees: 0.0,
        providedGrandTotal: 1035.00,
      );
      expect(r.isValid, isTrue);
    });

    test('fail: provided 1085 (uses pre-discount subtotal 1000+135=1135... no)', () {
      final r = v.validateGrandTotal(
        subtotal: 900.00,
        discounts: 0.0,
        vatAmount: 135.00,
        fees: 0.0,
        providedGrandTotal: 1085.00,
      );
      expect(r.isValid, isFalse);
      expect(r.errors.first.fieldId, 'grand_total');
    });
  });

  // ── validateTransferNet ───────────────────────────────────────────────────

  group('validateTransferNet', () {
    test('pass: 1000 − 15 − 5 = 980', () {
      final r = v.validateTransferNet(
        sourceAmount: 1000.00,
        fee: 15.00,
        commission: 5.00,
        providedNetAmount: 980.00,
      );
      expect(r.isValid, isTrue);
    });

    test('fail: provided 975 (off by 5)', () {
      final r = v.validateTransferNet(
        sourceAmount: 1000.00,
        fee: 15.00,
        commission: 5.00,
        providedNetAmount: 975.00,
      );
      expect(r.isValid, isFalse);
      expect(r.errors.first.fieldId, 'net_amount');
      expect(r.errors.first.messageAr, isNotEmpty);
    });
  });

  // ── validateCurrencyConversion ────────────────────────────────────────────

  group('validateCurrencyConversion', () {
    test('pass: 500 USD × 3.75 = 1875.00 SAR', () {
      final srcPolicy = GeniusRoundingPolicy.forCurrency('USD');
      final r = v.validateCurrencyConversion(
        sourceAmount: 500.00,
        exchangeRate: 3.75,
        providedTargetAmount: 1875.00,
        sourceCurrencyPolicy: srcPolicy,
      );
      expect(r.isValid, isTrue);
    });

    test('fail: provided 1876.00 (off by 1.00)', () {
      final r = v.validateCurrencyConversion(
        sourceAmount: 500.00,
        exchangeRate: 3.75,
        providedTargetAmount: 1876.00,
      );
      expect(r.isValid, isFalse);
      expect(r.errors.first.fieldId, 'target_amount');
      expect(r.errors.first.messageAr, isNotEmpty);
    });

    test('pass: no sourceCurrencyPolicy falls back to document policy', () {
      final r = v.validateCurrencyConversion(
        sourceAmount: 100.00,
        exchangeRate: 3.75,
        providedTargetAmount: 375.00,
      );
      expect(r.isValid, isTrue);
    });
  });

  // ── validateAccountingEntries ─────────────────────────────────────────────

  group('validateAccountingEntries', () {
    test('pass: balanced — [5000, 3000] debits = [8000] credit', () {
      final r = v.validateAccountingEntries(
        debits: [5000.00, 3000.00],
        credits: [8000.00],
      );
      expect(r.isValid, isTrue);
    });

    test('fail: unbalanced — debits 5000 ≠ credits 4999.99', () {
      final r = v.validateAccountingEntries(
        debits: [5000.00],
        credits: [4999.99],
      );
      expect(r.isValid, isFalse);
      expect(r.errors.first.fieldId, 'debit_credit_balance');
      expect(r.errors.first.messageAr, isNotEmpty);
    });

    test('pass: empty lists (zero = zero)', () {
      final r = v.validateAccountingEntries(debits: [], credits: []);
      expect(r.isValid, isTrue);
    });
  });

  // ── validateGridColumn ────────────────────────────────────────────────────

  group('validateGridColumn', () {
    test('pass: [100, 200, 300] sum = 600', () {
      final r = v.validateGridColumn(
        rowValues: [100.00, 200.00, 300.00],
        providedTotal: 600.00,
        columnId: 'amount',
      );
      expect(r.isValid, isTrue);
    });

    test('fail: provided 601 — error has correct columnId', () {
      final r = v.validateGridColumn(
        rowValues: [100.00, 200.00, 300.00],
        providedTotal: 601.00,
        columnId: 'amount',
      );
      expect(r.isValid, isFalse);
      expect(r.errors.first.fieldId, 'amount');
    });
  });

  // ── validateBudgetVariance ────────────────────────────────────────────────

  group('validateBudgetVariance', () {
    test('pass: actual=1100, budget=1000, variance=100', () {
      final r = v.validateBudgetVariance(
        actual: 1100.00,
        budget: 1000.00,
        providedVariance: 100.00,
      );
      expect(r.isValid, isTrue);
    });

    test('pass: with variance% — 100/1000 = 10%', () {
      final r = v.validateBudgetVariance(
        actual: 1100.00,
        budget: 1000.00,
        providedVariance: 100.00,
        providedVariancePct: 10.00,
      );
      expect(r.isValid, isTrue);
    });

    test('fail: wrong variance amount', () {
      final r = v.validateBudgetVariance(
        actual: 1100.00,
        budget: 1000.00,
        providedVariance: 50.00,
      );
      expect(r.isValid, isFalse);
      expect(r.errors.first.fieldId, 'variance');
    });

    test('fail: wrong variance %', () {
      final r = v.validateBudgetVariance(
        actual: 1100.00,
        budget: 1000.00,
        providedVariance: 100.00,
        providedVariancePct: 5.00, // should be 10%
      );
      expect(r.isValid, isFalse);
      expect(r.errors.first.fieldId, 'variance_pct');
    });

    test('zero-budget guard: skips variance% check when budget = 0', () {
      final r = v.validateBudgetVariance(
        actual: 100.00,
        budget: 0.00,
        providedVariance: 100.00,
        providedVariancePct: 999.00, // any value — should be ignored
      );
      // variance check: 100 - 0 = 100 = provided → valid
      expect(r.isValid, isTrue);
    });
  });

  // ── combineResults ────────────────────────────────────────────────────────

  group('combineResults', () {
    test('all valid → combined is valid', () {
      final r = v.combineResults([
        GeniusFinancialValidationResult.valid(),
        GeniusFinancialValidationResult.valid(),
      ]);
      expect(r.isValid, isTrue);
      expect(r.errors, isEmpty);
    });

    test('one invalid → combined is invalid with merged errors', () {
      final invalid = v.validateSubtotal(
          lineTotals: [100.00], providedSubtotal: 200.00);
      final r = v.combineResults([
        GeniusFinancialValidationResult.valid(),
        invalid,
      ]);
      expect(r.isValid, isFalse);
      expect(r.errors.length, 1);
    });

    test('two invalids → combined accumulates all errors', () {
      final r1 = v.validateSubtotal(
          lineTotals: [100.00], providedSubtotal: 200.00);
      final r2 = v.validateVat(
          vatBase: 900.00, vatRate: 15.0, providedVatAmount: 150.00);
      final combined = v.combineResults([r1, r2]);
      expect(combined.errors.length, 2);
    });
  });

  // ── roundForWords ─────────────────────────────────────────────────────────

  group('roundForWords', () {
    test('delegates to policy.round()', () {
      final result = v.roundForWords(135.004);
      expect(result, closeTo(135.00, 1e-9));
    });

    test('1499.9999999 rounds to 1500.00', () {
      expect(v.roundForWords(1499.9999999), closeTo(1500.00, 1e-9));
    });
  });
}
