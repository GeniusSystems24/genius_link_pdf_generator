# Data Model: Financial Calculation Correctness and Validation

**Feature**: `001-financial-calc-validation`  
**Date**: 2026-05-07  
**Layer**: `lib/src/core/financial/`

---

## Overview

All entities live in `lib/src/core/financial/`. They have zero imports from any other `lib/src/` module. Templates, vouchers, and services import from this layer — never the reverse.

---

## Entities

### `GeniusRoundingMode` (enum)

Rounding behaviour applied when converting a computed value to minor units.

| Value | Behaviour |
|-------|-----------|
| `halfUp` | Round half away from zero (default; matches ZATCA FATOORA) |
| `halfEven` | Round half to nearest even (banker's rounding) |
| `truncate` | Always round toward zero |
| `floor` | Always round down |
| `ceiling` | Always round up |

---

### `GeniusRoundingPolicy`

Configuration for how monetary amounts are rounded and how close a provided total must be to the calculated total to pass validation.

**Fields**:

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| `decimalPlaces` | `int` | `2` | Minor-unit precision (0=JPY, 2=SAR/USD, 3=KWD) |
| `mode` | `GeniusRoundingMode` | `halfUp` | Rounding mode applied per named field |
| `absoluteTolerance` | `double?` | `null` → 1 minor unit | Fixed monetary tolerance (e.g., 0.01) |
| `relativeTolerance` | `double?` | `null` (disabled) | Fractional tolerance (e.g., 0.001 = 0.1%) |

When both tolerances are set, the **looser** bound applies (i.e., `|diff| ≤ max(absolute, relative × expected)`).

**Factory constructors**:

| Constructor | Behaviour |
|------------|-----------|
| `GeniusRoundingPolicy.defaults()` | 2dp, halfUp, absolute 1 minor unit |
| `GeniusRoundingPolicy.strict()` | 2dp, halfUp, absolute 0 (exact match) |
| `GeniusRoundingPolicy.forCurrency(String)` | Looks up decimal places from `AmountToWords.currencies`; halfUp; absolute 1 minor unit |
| `GeniusRoundingPolicy.withRelative(double pct)` | 2dp, halfUp, relative tolerance only |

**Key method**:
- `double round(double value)` — converts to integer minor units, applies mode, returns rounded double.
- `bool isWithinTolerance(double expected, double actual)` — returns true if `|expected − actual|` ≤ the looser bound.

---

### `GeniusMoney`

An immutable, safe monetary value stored as an integer count of minor currency units.

**Fields**:

| Field | Type | Notes |
|-------|------|-------|
| `minorUnits` | `int` | e.g., `15025` for 150.25 SAR |
| `currency` | `String` | ISO 4217 code (e.g., `'SAR'`) |
| `decimalPlaces` | `int` | From currency info or policy |

**Factory constructors**:

| Constructor | Behaviour |
|------------|-----------|
| `GeniusMoney.fromDouble(double, {String currency, GeniusRoundingPolicy? policy})` | Converts via integer minor-unit rounding |
| `GeniusMoney.fromMinorUnits(int, {String currency, int decimalPlaces})` | Direct constructor |
| `GeniusMoney.zero({String currency, int decimalPlaces})` | 0 minor units |

**Arithmetic** (all return `GeniusMoney`, all exact integer ops except `multiplyByRate`):

| Method | Behaviour |
|--------|-----------|
| `operator +(GeniusMoney)` | Exact integer addition; currencies must match |
| `operator -(GeniusMoney)` | Exact integer subtraction; currencies must match |
| `multiplyByRate(double rate, {GeniusRoundingPolicy? policy})` | `round(minorUnits × rate)` using policy; returns same currency |
| `multiplyByDouble(double, {GeniusRoundingPolicy?})` | Alias for multiplyByRate |

**Comparison**:

| Method | Behaviour |
|--------|-----------|
| `operator ==(Object)` | Exact minor-unit equality + currency match |
| `compareTo(GeniusMoney)` | Numeric comparison |
| `isWithinTolerance(GeniusMoney other, GeniusRoundingPolicy policy)` | Delegates to `policy.isWithinTolerance` |

**Conversion**:

| Method | Behaviour |
|--------|-----------|
| `toDouble()` | `minorUnits / pow10(decimalPlaces)` |
| `toDisplayString({int? decimalPlaces})` | Formatted string for display/debugging |

---

### `GeniusFinancialValidationError`

A single rule violation found during validation.

**Fields**:

| Field | Type | Notes |
|-------|------|-------|
| `fieldId` | `String` | Machine-readable field identifier (e.g., `'subtotal'`, `'vat_amount'`) |
| `ruleId` | `String` | Rule that failed (e.g., `'subtotal_sum'`, `'vat_calc'`, `'debit_credit_balance'`) |
| `expectedValue` | `GeniusMoney` | Calculated expected value |
| `actualValue` | `GeniusMoney` | Provided actual value |
| `message` | `String` | English error message |
| `messageAr` | `String` | Arabic error message |

---

### `GeniusFinancialValidationResult`

The aggregate outcome of validating a document.

**Fields**:

| Field | Type | Notes |
|-------|------|-------|
| `isValid` | `bool` | `true` iff `errors` is empty |
| `errors` | `List<GeniusFinancialValidationError>` | All violations found |

**Factory constructors**:

| Constructor | Behaviour |
|------------|-----------|
| `GeniusFinancialValidationResult.valid()` | `isValid: true`, empty errors |
| `GeniusFinancialValidationResult.invalid(List<...> errors)` | `isValid: false`, non-empty errors |

---

### `GeniusFinancialValidationContext`

Carries rounding configuration into a template's generate call. Optional — if not supplied, the template uses `GeniusRoundingPolicy.defaults()`.

**Fields**:

| Field | Type | Default | Notes |
|-------|------|---------|-------|
| `roundingPolicy` | `GeniusRoundingPolicy` | `GeniusRoundingPolicy.defaults()` | Document-currency policy |
| `sourceCurrencyPolicy` | `GeniusRoundingPolicy?` | `null` | Source-currency policy for multi-currency docs |
| `documentCurrency` | `String` | `'SAR'` | ISO 4217 document currency code |

---

### `GeniusFinancialValidator`

Stateless validator. Constructed with a `GeniusRoundingPolicy`; all methods are pure functions of their arguments.

**Constructor**: `GeniusFinancialValidator(GeniusRoundingPolicy policy)`

**Methods**:

| Method | Validates | Returns |
|--------|-----------|---------|
| `validateSubtotal({required List<double> lineTotals, required double providedSubtotal})` | Sum of line totals ≈ providedSubtotal | `GeniusFinancialValidationResult` |
| `validateVat({required double vatBase, required double vatRate, required double providedVatAmount})` | `round(vatBase × vatRate/100)` ≈ providedVatAmount | `GeniusFinancialValidationResult` |
| `validateGrandTotal({required double subtotal, required double discounts, required double vatAmount, required double fees, required double providedGrandTotal})` | `subtotal − discounts + vatAmount + fees` ≈ providedGrandTotal | `GeniusFinancialValidationResult` |
| `validateTransferNet({required double sourceAmount, required double fee, required double commission, required double providedNetAmount})` | `sourceAmount − fee − commission` ≈ providedNetAmount | `GeniusFinancialValidationResult` |
| `validateCurrencyConversion({required double sourceAmount, required double exchangeRate, required double providedTargetAmount, GeniusRoundingPolicy? sourceCurrencyPolicy})` | Two-stage: source subtotal then converted target | `GeniusFinancialValidationResult` |
| `validateAccountingEntries({required List<double> debits, required List<double> credits})` | `sum(debits)` ≈ `sum(credits)` | `GeniusFinancialValidationResult` |
| `validateGridColumn({required List<double> rowValues, required double providedTotal, required String columnId})` | `sum(rowValues)` ≈ `providedTotal` | `GeniusFinancialValidationResult` |
| `validateAverage({required List<double> values, required double providedAverage, required String columnId})` | `sum/count` ≈ `providedAverage` | `GeniusFinancialValidationResult` |
| `validateBudgetVariance({required double actual, required double budget, required double providedVariance, double? providedVariancePct})` | Variance and optional variance% | `GeniusFinancialValidationResult` |
| `roundForWords(double rawAmount)` | — | `double` — pre-rounded value safe for AmountToWords |
| `combineResults(List<GeniusFinancialValidationResult>)` | — | Merged `GeniusFinancialValidationResult` |

---

## Modified Entities (existing files)

### `GeniusPdfFailure` (existing — `lib/src/models/pdf_result.dart`)

**Added factory**:
```
GeniusPdfFailure.fromValidation(GeniusFinancialValidationResult result)
  → error: result
  → message: result.errors.first.message (English, first error)
  → stackTrace: null
```

The `validationResult` field is exposed as:
```
GeniusFinancialValidationResult? get validationResult
  → returns error as GeniusFinancialValidationResult if applicable, else null
```

### `VoucherData` (existing — `lib/src/templates/vouchers/models/voucher_models.dart`)

No structural change. Validation is applied externally by `GeniusPdfVoucherTemplate` using existing fields (`amount`, `items`, `accountEntries`).

### `InvoiceData` (existing — `lib/src/templates/tax_invoice_template.dart`)

No structural change. The template's `generate()` method calls the validator internally using existing computed getters (`subtotal`, `totalTax`, `total`).

---

## State Transitions

Validation is stateless and synchronous. The only state transition is:

```
generate() called
  ↓
validateFinancials == true?
  → YES: run GeniusFinancialValidator → GeniusFinancialValidationResult
    → isValid == true:  proceed to render → GeniusPdfSuccess
    → isValid == false: return GeniusPdfFailure.fromValidation(result)
  → NO:  proceed to render → GeniusPdfSuccess (or GeniusPdfFailure on render error)
```

---

## Barrel File

`lib/src/core/financial/financial.dart` exports:
- `genius_money.dart`
- `genius_rounding_policy.dart`
- `genius_financial_validator.dart`
- `genius_validation_result.dart`
- `genius_validation_context.dart`

`lib/pdf_generator.dart` re-exports `src/core/financial/financial.dart`.
