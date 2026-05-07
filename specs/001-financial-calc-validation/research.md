# Research: Financial Calculation Correctness and Validation

**Feature**: `001-financial-calc-validation`  
**Date**: 2026-05-07  
**Status**: Complete — all decisions resolved

---

## Decision 1: Money Representation

**Decision**: Integer minor-unit arithmetic via an internal `GeniusMoney` class.

**Rationale**: Dart's `double` is IEEE 754 binary64. Operations like `1000.00 * 0.15` produce `149.99999999999997` instead of `150.00`. The only safe approach without an external dependency is to convert amounts to integer minor units (halalas, cents, fils) at the point of ingestion, do all arithmetic in integers, and convert back to `double` only for display. The codebase already uses `int _pow10(int exp)` in `AmountToWords` and `.round()` on fraction parts — confirming awareness of the problem but no systematic fix yet.

**Alternatives considered**:
- `decimal` pub.dev package: rejected because it adds a production dependency for a self-contained calculation problem, and the user explicitly requested a small internal abstraction.
- `double.roundToDouble()` at each step: rejected because rounding errors accumulate across multiple operations and the source of truth is still a float.
- `BigInt`-based fixed-point: equivalent to the integer minor-unit approach but heavier; `int` is sufficient for currency amounts up to ~92 trillion minor units (covers any realistic invoice).

**Files affected**: New `lib/src/core/financial/genius_money.dart`

---

## Decision 2: Rounding Chain

**Decision**: Round once per named financial field. Each named output (subtotal, discount amount, VAT amount, grand total) is computed from already-rounded inputs, then rounded itself. No intermediate rounding occurs within a single field's formula.

**Rationale**: Confirmed by clarification Q2. This matches the ZATCA e-invoicing specification for Saudi Arabia (FATOORA), which rounds each line total, subtotal, tax amount, and grand total independently. It is also the approach used by most ERP systems (SAP, Oracle, Microsoft Dynamics).

**Implementation**: `GeniusMoney.multiplyByRate(rate)` applies rounding immediately and returns a new `GeniusMoney`. Arithmetic operators (`+`, `-`) between two `GeniusMoney` values are exact integer operations (no rounding needed). The rounding mode is supplied by `GeniusRoundingPolicy`.

---

## Decision 3: VAT Base

**Decision**: VAT is always calculated on the post-discount amount: `(subtotal − total_discounts) × vat_rate`.

**Rationale**: Confirmed by clarification Q1. This matches ZATCA rules (KSA VAT law Article 53) and international VAT standards (EU VAT Directive). The existing `InvoiceData.totalTax` calls `tax.calculate(subtotal)` where `subtotal` already incorporates per-item discounts (each `lineTotal = quantity × unitPrice − lineDiscount`). If a header-level discount exists, validation must apply it before computing VAT.

**Existing gap found**: `InvoiceData` does not have a header-level `discount` field — per-item discounts only. Templates that add a header discount are responsible for supplying the correct VAT base to the validator. The validator accepts an explicit `vatBase` parameter rather than computing it internally.

---

## Decision 4: Validation Tolerance

**Decision**: Two configurable tolerance modes — absolute (default: 1 minor unit) and relative (caller-supplied percentage). When both are set, the looser bound applies.

**Rationale**: Confirmed by clarification Q3. Absolute tolerance (e.g., 0.01 SAR) is safe for small documents; relative tolerance (e.g., 0.01%) can accommodate accumulated per-line rounding in large multi-line documents where the sum of independently rounded lines can differ from the independently rounded total by more than one minor unit.

**Default**: `absoluteTolerance = 1 minor unit`, `relativeTolerance = null` (not used). Callers who need stricter enforcement pass `absoluteTolerance = 0`.

---

## Decision 5: Multi-Currency Validation Strategy

**Decision**: Two-stage validation — (1) source-currency subtotal validated against source-currency line items using the source currency's rounding policy; (2) document-currency total validated against converted source subtotal using the document currency's rounding policy.

**Rationale**: Confirmed by clarification Q4. This separates data errors (wrong source subtotal) from arithmetic errors (wrong exchange rate application) and produces actionable errors at the correct level.

**Implementation**: `GeniusFinancialValidator.validateCurrencyConversion()` accepts separate `sourcePolicy` and `documentPolicy` parameters. `GeniusFinancialValidationContext` carries both policies.

---

## Decision 6: Backward Compatibility Opt-Out

**Decision**: Each financial template's `generate()` method (or equivalent) gains one optional named parameter: `validateFinancials: bool = true`. No global flag is provided.

**Rationale**: Confirmed by clarification Q5. Per-call opt-out is auditable, does not introduce global mutable state (upholds Constitution Principle IX), and allows callers to migrate gradually without affecting other call sites.

**Affected base classes**: `GeniusPdfVoucherTemplate` (covers all 16 voucher types via one change), plus individual `generate()` methods on `TaxInvoiceTemplate`, `CreditNoteTemplate`, `BalanceSheetTemplate`, `IncomeStatementTemplate`, `CashFlowTemplate`, `BudgetReportTemplate`, `TrialBalanceTemplate`, `PayslipTemplate`, `PurchaseOrderTemplate`, `QuotationTemplate`, `CustomerStatementTemplate`, `InventoryReportTemplate`.

---

## Decision 7: Amount-to-Words Pre-Rounding

**Decision**: Templates apply `GeniusRoundingPolicy.round(rawAmount)` before passing any value to `AmountToWords.toEnglish/toArabic`. No API change to `AmountToWords` is required.

**Rationale**: `AmountToWords.toEnglish` calls `amount.truncate()` on the raw double. If the raw double is `1499.9999999`, truncate gives `1499` not `1500`. The fix is at the call site: the template holds a `GeniusMoney` for every financial field, calls `.toDouble()` on the rounded value, and passes that to `AmountToWords`. This is a guaranteed implementation-level fix that requires no public API change.

---

## Decision 8: Test Strategy

**Decision**: Pure Dart unit tests in `test/financial/`. No Flutter widget infrastructure required for the financial layer. Use `flutter test` (available via `flutter_test` in dev_dependencies) for consistency with the project toolchain.

**Test files planned**:
- `test/financial/genius_money_test.dart` — GeniusMoney arithmetic, rounding, overflow
- `test/financial/genius_rounding_policy_test.dart` — tolerance modes, currency presets
- `test/financial/genius_financial_validator_test.dart` — all rule types, bilingual errors
- `test/financial/edge_cases_test.dart` — zero, negative, large, multi-currency, rounding boundary

**Coverage target**: All validator rule functions covered. Edge cases from spec SC-006 each have at least one named test case.

---

## Decision 9: Layer Placement

**Decision**: `lib/src/core/financial/` — below all templates, components, services, and builders. Nothing inside `lib/src/core/financial/` imports from any other `lib/src/` module.

**Dependency graph** (arrows = "imports from"):
```
templates/vouchers/ → core/financial/
templates/          → core/financial/
components/         → (does not import financial — grid validation is caller's responsibility)
services/           → (does not import financial — validation is pre-generation)
core/financial/     → (Dart core only: dart:math, dart:core)
```

**Rationale**: Pure calculation, no rendering, no I/O. Keeps the layer testable with `dart test` (no Flutter dependency). Upholds Constitution Principle VI (Separation of Concerns).

---

## Resolved NEEDS CLARIFICATION Items

All were resolved in the clarification session on 2026-05-07. See `spec.md` Clarifications section.

| Topic | Resolution |
|-------|-----------|
| VAT base | Post-discount amount × VAT rate |
| Rounding chain | Once per named field |
| Tolerance mode | Both absolute and relative; looser bound applies |
| Multi-currency | Two-stage: source-currency then document-currency |
| Opt-out API | `validateFinancials: bool = true` parameter on generate() |
