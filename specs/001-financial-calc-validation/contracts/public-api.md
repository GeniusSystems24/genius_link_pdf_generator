# Public API Contract: Financial Calculation Correctness and Validation

**Feature**: `001-financial-calc-validation`  
**Date**: 2026-05-07  
**Barrel**: `lib/genius_link_pdf_generator.dart`  
**SemVer Impact**: MINOR (additive new exports + optional parameter) + documented behavioral change

---

## New Exports (Additive)

All types below are new. Existing callers are unaffected.

### `GeniusRoundingMode` (enum)

```dart
enum GeniusRoundingMode { halfUp, halfEven, truncate, floor, ceiling }
```

### `GeniusRoundingPolicy`

```dart
class GeniusRoundingPolicy {
  const GeniusRoundingPolicy({
    this.decimalPlaces = 2,
    this.mode = GeniusRoundingMode.halfUp,
    this.absoluteTolerance,    // null → 1 minor unit
    this.relativeTolerance,    // null → disabled
  });

  factory GeniusRoundingPolicy.defaults();
  factory GeniusRoundingPolicy.strict();
  factory GeniusRoundingPolicy.forCurrency(String currencyCode);
  factory GeniusRoundingPolicy.withRelative(double fractionTolerance);

  double round(double value);
  bool isWithinTolerance(double expected, double actual);
}
```

### `GeniusMoney`

```dart
class GeniusMoney {
  const GeniusMoney.fromMinorUnits(int minorUnits, {
    required String currency,
    int decimalPlaces = 2,
  });

  factory GeniusMoney.fromDouble(double value, {
    String currency = 'SAR',
    GeniusRoundingPolicy? policy,
  });

  factory GeniusMoney.zero({String currency = 'SAR', int decimalPlaces = 2});

  GeniusMoney operator +(GeniusMoney other);
  GeniusMoney operator -(GeniusMoney other);
  GeniusMoney multiplyByRate(double rate, {GeniusRoundingPolicy? policy});

  bool isWithinTolerance(GeniusMoney other, GeniusRoundingPolicy policy);

  double toDouble();
  String toDisplayString({int? decimalPlaces});

  final int minorUnits;
  final String currency;
  final int decimalPlaces;
}
```

### `GeniusFinancialValidationError`

```dart
class GeniusFinancialValidationError {
  const GeniusFinancialValidationError({
    required this.fieldId,
    required this.ruleId,
    required this.expectedValue,
    required this.actualValue,
    required this.message,
    required this.messageAr,
  });

  final String fieldId;
  final String ruleId;
  final GeniusMoney expectedValue;
  final GeniusMoney actualValue;
  final String message;     // English
  final String messageAr;   // Arabic
}
```

### `GeniusFinancialValidationResult`

```dart
class GeniusFinancialValidationResult {
  factory GeniusFinancialValidationResult.valid();
  factory GeniusFinancialValidationResult.invalid(
      List<GeniusFinancialValidationError> errors);

  final bool isValid;
  final List<GeniusFinancialValidationError> errors;
}
```

### `GeniusFinancialValidationContext`

```dart
class GeniusFinancialValidationContext {
  const GeniusFinancialValidationContext({
    GeniusRoundingPolicy? roundingPolicy,
    this.sourceCurrencyPolicy,
    this.documentCurrency = 'SAR',
  });

  final GeniusRoundingPolicy roundingPolicy;
  final GeniusRoundingPolicy? sourceCurrencyPolicy;
  final String documentCurrency;
}
```

### `GeniusFinancialValidator`

```dart
class GeniusFinancialValidator {
  const GeniusFinancialValidator(this.policy);
  final GeniusRoundingPolicy policy;

  GeniusFinancialValidationResult validateSubtotal({
    required List<double> lineTotals,
    required double providedSubtotal,
  });

  GeniusFinancialValidationResult validateVat({
    required double vatBase,
    required double vatRate,
    required double providedVatAmount,
  });

  GeniusFinancialValidationResult validateGrandTotal({
    required double subtotal,
    required double discounts,
    required double vatAmount,
    required double fees,
    required double providedGrandTotal,
  });

  GeniusFinancialValidationResult validateTransferNet({
    required double sourceAmount,
    required double fee,
    required double commission,
    required double providedNetAmount,
  });

  GeniusFinancialValidationResult validateCurrencyConversion({
    required double sourceAmount,
    required double exchangeRate,
    required double providedTargetAmount,
    GeniusRoundingPolicy? sourceCurrencyPolicy,
  });

  GeniusFinancialValidationResult validateAccountingEntries({
    required List<double> debits,
    required List<double> credits,
  });

  GeniusFinancialValidationResult validateGridColumn({
    required List<double> rowValues,
    required double providedTotal,
    required String columnId,
  });

  GeniusFinancialValidationResult validateBudgetVariance({
    required double actual,
    required double budget,
    required double providedVariance,
    double? providedVariancePct,
  });

  double roundForWords(double rawAmount);

  GeniusFinancialValidationResult combineResults(
      List<GeniusFinancialValidationResult> results);
}
```

---

## Modified Exports (Backward Compatible)

### `GeniusPdfFailure` — new factory and getter

```dart
// ADDED (new factory — no existing constructors changed)
factory GeniusPdfFailure.fromValidation(GeniusFinancialValidationResult result);

// ADDED (new getter — no existing fields changed)
GeniusFinancialValidationResult? get validationResult;
```

### Financial template `generate()` methods — new optional parameter

All financial templates that previously exposed:
```dart
Future<GeniusPdfResult> generate() async { ... }
```

Now expose:
```dart
Future<GeniusPdfResult> generate({
  bool validateFinancials = true,
  GeniusFinancialValidationContext? validationContext,
}) async { ... }
```

**Backward compatibility**: Existing call sites `template.generate()` compile and run unchanged. `validateFinancials` defaults to `true`, so callers that previously passed inconsistent data will now receive a `GeniusPdfFailure` rather than a wrong PDF. This is documented as an intentional behavioral change under MINOR version bump.

**Affected templates** (all in `lib/src/templates/` and `lib/src/templates/vouchers/`):

| File | Class | Change |
|------|-------|--------|
| `tax_invoice_template.dart` | `TaxInvoiceTemplate` | `generate({validateFinancials, validationContext})` |
| `credit_note_template.dart` | `CreditNoteTemplate` | `generate({validateFinancials, validationContext})` |
| `purchase_order_template.dart` | `PurchaseOrderTemplate` | `generate({validateFinancials, validationContext})` |
| `quotation_template.dart` | `QuotationTemplate` | `generate({validateFinancials, validationContext})` |
| `payslip_template.dart` | `PayslipTemplate` | `generate({validateFinancials, validationContext})` |
| `customer_statement_template.dart` | `CustomerStatementTemplate` | `generate({validateFinancials, validationContext})` |
| `balance_sheet_template.dart` | `BalanceSheetTemplate` | `generate({validateFinancials, validationContext})` |
| `income_statement_template.dart` | `IncomeStatementTemplate` | `generate({validateFinancials, validationContext})` |
| `cash_flow_template.dart` | `CashFlowTemplate` | `generate({validateFinancials, validationContext})` |
| `budget_report_template.dart` | `BudgetReportTemplate` | `generate({validateFinancials, validationContext})` |
| `trial_balance_template.dart` | `TrialBalanceTemplate` | `generate({validateFinancials, validationContext})` |
| `inventory_report_template.dart` | `InventoryReportTemplate` | `generate({validateFinancials, validationContext})` |
| `vouchers/voucher_base_template.dart` | `GeniusPdfVoucherTemplate` | `generate({validateFinancials, validationContext})` — covers all 16 voucher types |

---

## Unchanged Exports

All other public types, factories, enums, and barrel exports are unchanged. `AmountToWords` API is unchanged — caller-side pre-rounding is applied internally by templates before invoking it.

---

## SemVer Guidance

| Change | SemVer | Note |
|--------|--------|------|
| New classes (GeniusMoney, RoundingPolicy, etc.) | MINOR | Additive |
| New `GeniusPdfFailure` factory + getter | MINOR | Additive |
| New optional parameters on `generate()` | MINOR | Additive, backward compatible |
| Behavioral change: inconsistent totals now fail | MINOR | Documented; callers can opt out |

**Recommended version bump**: `3.5.0 → 3.6.0`
