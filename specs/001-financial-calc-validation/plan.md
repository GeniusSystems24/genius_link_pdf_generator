# Implementation Plan: Financial Calculation Correctness and Validation

**Branch**: `001-financial-calc-validation` | **Date**: 2026-05-07 | **Spec**: [spec.md](spec.md)  
**Input**: Feature specification from `specs/001-financial-calc-validation/spec.md`

---

## Summary

Add a deterministic financial calculation and validation layer (`lib/src/core/financial/`) to the `genius_link_pdf_generator` library. The layer uses integer minor-unit arithmetic (no floating-point for monetary operations) to validate that subtotals, VAT, discounts, fees, exchange-rate conversions, debit/credit entries, and grid aggregates are mathematically consistent before any PDF bytes are produced. All financial template `generate()` methods gain an optional `validateFinancials: bool = true` parameter; callers who omit it receive validation by default. Errors are returned as structured `GeniusFinancialValidationResult` objects with bilingual (English + Arabic) messages. No rendering code is changed in this phase.

---

## Technical Context

**Language/Version**: Dart 3.x / Flutter 3.x (SDK `>=3.0.0 <4.0.0`)  
**Primary Dependencies**: No new dependencies. Uses only `dart:core` and `dart:math` in the financial layer. Existing: `syncfusion_flutter_pdf`, `printing`, `intl`, `share_plus`, `path_provider`.  
**Storage**: N/A for the financial layer. Existing template storage/export behaviour unchanged.  
**Testing**: `flutter test` via existing `flutter_test` dev-dependency. Financial layer has zero Flutter imports — tests are pure Dart and fast.  
**Target Platform**: Flutter package (mobile, desktop, web). Financial validation is platform-agnostic pure Dart.  
**Project Type**: Flutter package / library  
**Performance Goals**: Validation is synchronous pure-arithmetic (sub-millisecond for any realistic document). No progress callback required (Principle X — single-page-equivalent computation). No UI thread impact since `generate()` is already `async`.  
**Constraints**: No new pub.dev dependencies. No rendering code changes unless required by validation hook. Public API additive only (no removals, no renames). Bilingual errors (EN + AR). RTL/LTR not affected (calculation layer, no layout).  
**Scale/Scope**: New `lib/src/core/financial/` module (5 files + barrel). Modified: `lib/pdf_generator.dart`, `lib/src/models/pdf_result.dart`, 12 main templates + `GeniusPdfVoucherTemplate` base (covers 16 vouchers). New: `test/financial/` (4 test files).

---

## Constitution Check

### I. Library-first Architecture ✅

All new code lives in `lib/src/core/financial/`. No logic is written in `example/`. Template integration adds only a parameter and a pre-render validation call — the rendering code itself is untouched. The `example/` changes are screen additions demonstrating the new API, not logic.

### II. Financial Correctness First ✅

This feature IS the financial correctness initiative. Integer minor-unit arithmetic eliminates floating-point drift. Tests are written in Phase A before any template is touched. `GeniusMoney.multiplyByRate()` rounds once per named field. `AmountToWords` receives pre-rounded values from template call sites, not raw doubles.

### III. Rendering Correctness ✅

No rendering code is changed. Validation runs entirely before `syncfusion_flutter_pdf` is invoked. If validation fails, the method returns immediately with a `GeniusPdfFailure` — the PDF document is never opened or drawn.

### IV. Test-Driven Bug Fixing ✅

This is a new feature, not a bug fix. However, the approach is test-first: all `GeniusFinancialValidator` rule functions are covered by unit tests (Phase A) before template integration begins (Phase B). Edge cases from spec SC-006 (zero, negative, large, rounding boundary, multi-currency) each have a named test case.

### V. Backward Compatibility ✅

`validateFinancials: bool = true` is an optional named parameter with a default value — existing call sites compile and run unchanged. `GeniusPdfFailure.fromValidation()` is an additive factory. All new classes are additive exports. Behavioral change (inconsistent totals now fail) is documented under MINOR version bump (3.5.0 → 3.6.0) with migration guidance in CHANGELOG.

### VI. Separation of Concerns ✅

`lib/src/core/financial/` imports nothing from `lib/src/`. Templates import from `core/financial/` — this is a downward import into a lower layer, which is correct. No component, service, builder, or widget imports from `core/financial/` (the financial layer is only consumed by templates and the public barrel). Grid validation is the responsibility of the template that owns the grid data, not the `PdfDataGrid` component.

### VII. RTL/LTR Parity ✅

The financial layer is calculation-only and produces no rendered output. All error messages carry both `message` (English) and `messageAr` (Arabic). No alignment, pagination, or column-order logic is affected.

### VIII. Documentation Consistency ✅

Deliverables include: README "Financial Validation" section, README code-example audit (all financial totals must be consistent), CHANGELOG under `Added`/`Changed`, and an example screen showing valid + invalid invoice generation. These are explicit task items — not optional.

### IX. Deterministic Outputs ✅

Integer minor-unit arithmetic is fully deterministic — same input produces same `minorUnits` on every platform and Dart version. No wall-clock time, random seeds, or mutable global state is introduced. `GeniusRoundingPolicy` is immutable (`const`-constructable). Validation result depends only on the input data and the policy.

### X. Performance Safety ✅

Validation is pure arithmetic with O(n) complexity in the number of line items. For any realistic invoice or grid, this completes in under 1 ms. No progress callback is needed. The validation runs synchronously inside the existing `async generate()` body — it does not block the UI thread and does not require an Isolate.

---

## Project Structure

### Documentation (this feature)

```text
specs/001-financial-calc-validation/
├── spec.md
├── plan.md           ← this file
├── research.md
├── data-model.md
├── quickstart.md
├── checklists/
│   └── requirements.md
└── contracts/
    └── public-api.md
```

### Source Code Changes

```text
lib/
├── genius_link_pdf_generator.dart           MODIFIED — export core/financial/financial.dart
└── src/
    ├── core/
    │   └── financial/                       NEW — pure Dart, no Flutter imports
    │       ├── genius_money.dart
    │       ├── genius_rounding_policy.dart
    │       ├── genius_financial_validator.dart
    │       ├── genius_validation_result.dart
    │       ├── genius_validation_context.dart
    │       └── financial.dart               (barrel)
    ├── models/
    │   └── pdf_result.dart                  MODIFIED — GeniusPdfFailure.fromValidation() + validationResult getter
    └── templates/
        ├── tax_invoice_template.dart        MODIFIED — generate({validateFinancials, validationContext})
        ├── credit_note_template.dart        MODIFIED
        ├── purchase_order_template.dart     MODIFIED
        ├── quotation_template.dart          MODIFIED
        ├── payslip_template.dart            MODIFIED
        ├── customer_statement_template.dart MODIFIED
        ├── balance_sheet_template.dart      MODIFIED
        ├── income_statement_template.dart   MODIFIED
        ├── cash_flow_template.dart          MODIFIED
        ├── budget_report_template.dart      MODIFIED
        ├── trial_balance_template.dart      MODIFIED
        ├── inventory_report_template.dart   MODIFIED
        └── vouchers/
            ├── voucher_base_template.dart   MODIFIED — generate() in base covers all 16 vouchers
            └── models/
                └── amount_to_words.dart     MODIFIED (caller-side only) — templates pass pre-rounded doubles

test/
└── financial/                               NEW — pure Dart unit tests
    ├── genius_money_test.dart
    ├── genius_rounding_policy_test.dart
    ├── genius_financial_validator_test.dart
    └── edge_cases_test.dart

example/
└── lib/
    ├── screens/
    │   └── financial_validation_screen.dart NEW — demonstrates valid + invalid invoice generation
    └── data/
        └── sample_data.dart                 MODIFIED — add consistent financial sample data
```

**Layer ownership rationale**:

- `core/financial/` — calculation concerns; the narrowest valid layer (no rendering, no I/O, no platform)
- `models/pdf_result.dart` — result types; correct home for the validation failure factory
- `templates/` — integration point; they own the data and call the validator before rendering
- `test/financial/` — mirrors `lib/src/core/financial/`; pure Dart, fast

---

## Phase A: Core Financial Layer + Tests

*Prerequisite: none. This phase produces no template changes.*

### A.1 — `lib/src/core/financial/genius_rounding_policy.dart`

```dart
enum GeniusRoundingMode { halfUp, halfEven, truncate, floor, ceiling }

class GeniusRoundingPolicy {
  const GeniusRoundingPolicy({...});
  factory GeniusRoundingPolicy.defaults();
  factory GeniusRoundingPolicy.strict();
  factory GeniusRoundingPolicy.forCurrency(String currencyCode);
  factory GeniusRoundingPolicy.withRelative(double fractionTolerance);

  double round(double value);
  bool isWithinTolerance(double expected, double actual);
}
```

Key implementation: `round(v)` → `(v * pow10(dp) + modeOffset).floor() / pow10(dp)`. All operations on `int`.

### A.2 — `lib/src/core/financial/genius_money.dart`

Immutable. `minorUnits` is the canonical representation. `fromDouble` calls `GeniusRoundingPolicy.round()` as the first and only floating-point-to-integer conversion. All arithmetic between two `GeniusMoney` values is exact integer arithmetic.

### A.3 — `lib/src/core/financial/genius_validation_result.dart`

`GeniusFinancialValidationError` and `GeniusFinancialValidationResult`. Both `const`-constructable. `combineErrors` is a static helper.

### A.4 — `lib/src/core/financial/genius_validation_context.dart`

`GeniusFinancialValidationContext`. `const`-constructable. Carries `roundingPolicy` (required, defaults to `GeniusRoundingPolicy.defaults()`), `sourceCurrencyPolicy?`, `documentCurrency`.

### A.5 — `lib/src/core/financial/genius_financial_validator.dart`

All rule methods follow the same pattern:

1. Convert each `double` input to `GeniusMoney` via `GeniusMoney.fromDouble(v, policy: policy)`.
2. Compute the expected value using `GeniusMoney` arithmetic.
3. Compare using `policy.isWithinTolerance(expected.toDouble(), actual.toDouble())`.
4. If outside tolerance, build `GeniusFinancialValidationError` with EN + AR messages.
5. Return `GeniusFinancialValidationResult`.

### A.6 — `lib/src/core/financial/financial.dart` (barrel)

### A.7 — Unit tests (`test/financial/`)

Tests must exist before Phase B begins. Each test file covers:

**`genius_money_test.dart`**:

- `fromDouble` round-trip (2dp, 3dp, 0dp)
- Addition, subtraction (exact integer)
- `multiplyByRate` with halfUp, halfEven, truncate
- Negative amounts
- Currency mismatch throws `AssertionError`

**`genius_rounding_policy_test.dart`**:

- `round()` for each `GeniusRoundingMode`
- `isWithinTolerance` with absolute only
- `isWithinTolerance` with relative only
- `isWithinTolerance` with both (looser bound wins)
- `forCurrency('KWD')` → 3dp; `forCurrency('JPY')` → 0dp

**`genius_financial_validator_test.dart`**:

- `validateSubtotal`: pass, fail (diff > tolerance), exact zero
- `validateVat`: post-discount base, pass, fail
- `validateGrandTotal`: pass, fail
- `validateTransferNet`: pass, fail
- `validateCurrencyConversion`: two-stage pass, stage-1 fail, stage-2 fail
- `validateAccountingEntries`: balanced, unbalanced
- `validateGridColumn`: sum, fail
- `validateBudgetVariance`: variance pass, variance% fail, division by zero
- `combineResults`: merges errors from multiple results

**`edge_cases_test.dart`** (SC-006 regression suite):

- Zero amount (subtotal = 0 with no line items)
- Negative amounts (credit note: negative line totals)
- Large amounts (> 999,999,999.99 SAR)
- Rounding boundary: 1499.9999999 rounds to 1500.00
- Multi-currency: USD→SAR two-stage validation
- Accumulation: 100 × 0.333 line items summed then rounded
- VAT on post-discount: discount=100, subtotal=1000, vat=135 (not 150)

---

## Phase B: Template Integration

*Prerequisite: Phase A complete and all tests passing.*

**Integration pattern** (same for every template):

```dart
Future<GeniusPdfResult> generate({
  bool validateFinancials = true,
  GeniusFinancialValidationContext? validationContext,
}) async {
  if (validateFinancials) {
    final ctx = validationContext ??
        GeniusFinancialValidationContext(documentCurrency: data.currency);
    final validator = GeniusFinancialValidator(ctx.roundingPolicy);
    final result = _validate(validator);           // template-specific private method
    if (!result.isValid) {
      return GeniusPdfFailure.fromValidation(result);
    }
  }
  // ... existing rendering code unchanged
}
```

### B.1 — `lib/src/models/pdf_result.dart`

Add `GeniusPdfFailure.fromValidation(GeniusFinancialValidationResult)` factory.  
Add `GeniusFinancialValidationResult? get validationResult` getter.

### B.2 — Priority 1: Tax Invoice + Credit Note

`TaxInvoiceTemplate._validate()` calls in order:

1. `validateSubtotal(lineTotals: items.map((i) => i.lineTotal).toList(), providedSubtotal: data.subtotal)`
2. For each tax: `validateVat(vatBase: data.subtotal, vatRate: tax.rate, providedVatAmount: tax.calculate(data.subtotal))`
3. `validateGrandTotal(subtotal: data.subtotal, discounts: 0, vatAmount: data.totalTax, fees: 0, providedGrandTotal: data.total)`
4. Combine and return.

Amount-to-words fix: `data.total` → `GeniusFinancialValidator(ctx.roundingPolicy).roundForWords(data.total)` before passing to `AmountToWords`.

`CreditNoteTemplate` follows same pattern with negative amounts treated normally.

### B.3 — Priority 2: Voucher Base Template

`GeniusPdfVoucherTemplate._validate()` dispatches based on `data.serviceId`:

- **Accounting entry vouchers** (10100-10105): `validateAccountingEntries`
- **Transfer vouchers** (10200-10203): `validateTransferNet` + `validateCurrencyConversion` if exchange rate present
- **Remittance vouchers** (10300-10305): `validateCurrencyConversion` (two-stage)
- **Tax vouchers** (10400-10402): `validateVat` (output VAT − input VAT = net VAT)
- **Purchase/Sales vouchers** with items: `validateSubtotal`
- **Simple amount vouchers** (payment, receipt, gift, etc.): no structural validation needed beyond `amount > 0`

### B.4 — Priority 3: Financial Statement Templates

Each template implements `_validate()` appropriate to its domain:

- `BalanceSheetTemplate`: `validateAccountingEntries(debits: assets, credits: liabilities + equity)`
- `TrialBalanceTemplate`: `validateAccountingEntries`
- `IncomeStatementTemplate`: `validateGrandTotal(subtotal: revenue, discounts: 0, vatAmount: 0, fees: expenses, grand: netIncome)`
- `CashFlowTemplate`: `validateSubtotal` on each section, `validateGrandTotal` on net cash flow
- `BudgetReportTemplate`: `validateBudgetVariance` for each budget line
- `PayslipTemplate`: `validateGrandTotal(gross, deductions, 0, 0, net)`
- `PurchaseOrderTemplate`, `QuotationTemplate`: same as invoice (subtotal + VAT + grand total)
- `CustomerStatementTemplate`: `validateSubtotal` on balance movements
- `InventoryReportTemplate`: `validateGridColumn` on quantity and value columns

---

## Phase C: Documentation and Example

*Prerequisite: Phase B complete. All templates integrated and `flutter analyze` clean.*

### C.1 — README.md

- Add "Financial Validation" section (overview, code example, opt-out, custom policy).
- Audit all existing README code examples with financial amounts: apply `GeniusRoundingPolicy.defaults().round()` to any inconsistent values and annotate with comment `// consistent: subtotal + VAT = grand total`.

### C.2 — CHANGELOG.md

```markdown
## [3.6.0] - 2026-05-07

### Added
- `GeniusMoney` — immutable integer minor-unit monetary type
- `GeniusRoundingPolicy` — configurable rounding with absolute + relative tolerance
- `GeniusRoundingMode` — halfUp, halfEven, truncate, floor, ceiling
- `GeniusFinancialValidator` — deterministic rule-based financial validation
- `GeniusFinancialValidationResult` and `GeniusFinancialValidationError` — structured bilingual error types
- `GeniusFinancialValidationContext` — per-call rounding and currency configuration
- `GeniusPdfFailure.fromValidation()` factory and `validationResult` getter

### Changed
- All financial templates' `generate()` methods now accept `validateFinancials: bool = true`
  and `validationContext: GeniusFinancialValidationContext?`. Callers with consistent data
  are unaffected. Callers with inconsistent totals will now receive `GeniusPdfFailure`
  instead of a silently incorrect PDF. To restore previous behaviour: pass `validateFinancials: false`.

### Fixed
- Amount-to-words conversion now always receives a rounded value, eliminating
  floating-point trailing-digit noise in written amount text.
- README financial examples corrected so displayed totals are consistent with their line items.
```

### C.3 — Example App

- Add `example/lib/screens/financial_validation_screen.dart`: two buttons — "Generate Valid Invoice" and "Generate Invalid Invoice (trigger validation error)". Displays validation error messages in both languages.
- Update `example/lib/data/sample_data.dart`: ensure all existing financial sample data has consistent totals.
- Register screen in `example/lib/screens/home_screen.dart`.

---

## Complexity Tracking

No Constitution violations. No complexity justification required.

---

## Artifacts

| Artifact | Path | Status |
| -------- | ---- | ------ |
| Spec | `specs/001-financial-calc-validation/spec.md` | ✅ Complete |
| Research | `specs/001-financial-calc-validation/research.md` | ✅ Complete |
| Data model | `specs/001-financial-calc-validation/data-model.md` | ✅ Complete |
| Public API contract | `specs/001-financial-calc-validation/contracts/public-api.md` | ✅ Complete |
| Quickstart | `specs/001-financial-calc-validation/quickstart.md` | ✅ Complete |
| Plan (this file) | `specs/001-financial-calc-validation/plan.md` | ✅ Complete |
| Tasks | `specs/001-financial-calc-validation/tasks.md` | ⏳ Next: `/speckit-tasks` |
