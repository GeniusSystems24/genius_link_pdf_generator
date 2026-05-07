---

description: "Task list for Financial Calculation Correctness and Validation"
---

# Tasks: Financial Calculation Correctness and Validation

**Input**: Design documents from `specs/001-financial-calc-validation/`
**Prerequisites**: plan.md ✅, spec.md ✅, research.md ✅, data-model.md ✅, contracts/public-api.md ✅, quickstart.md ✅

**Validation**: `flutter test test/financial/` for unit tests. `flutter analyze` for static analysis. Manual verification via example screen for rendering integration. Tests are mandatory for the calculation layer (Phase 2) per Constitution Principle II and plan Phase A.

**Organization**: Tasks are grouped by user story. Phase 2 (foundational) must complete in full before any user story phase begins.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies on each other)
- **[Story]**: User story this task belongs to (US1–US4)

---

## Phase 1: Setup

**Purpose**: Confirm scope, touched layers, and validation paths before any edits.

- [ ] T001 Confirm touched package layers against plan.md: new `lib/src/core/financial/`, modified `lib/src/models/pdf_result.dart`, modified financial templates, new `test/financial/`, modified `lib/genius_link_pdf_generator.dart`
- [ ] T002 [P] Identify and note all README, CHANGELOG, and example surfaces affected: `README.md` (new section + example audit), `CHANGELOG.md` (new `[3.6.0]` entry), `example/lib/screens/financial_validation_screen.dart` (new), `example/lib/data/sample_data.dart` (updated), `example/lib/screens/home_screen.dart` (updated)
- [ ] T003 [P] Verify `flutter test` can locate and run `test/financial/` — create the directory and confirm `flutter test test/financial/` exits cleanly with "No tests ran" before any test files are written

---

## Phase 2: Foundational — Core Financial Layer + Unit Tests

**Purpose**: Build the entire `lib/src/core/financial/` module and its unit tests. This phase MUST be complete and all tests MUST pass before any user story phase begins (Constitution Principle II: tests before templates).

**Checkpoint**: `flutter test test/financial/` passes 100% and `flutter analyze lib/src/core/financial/` is clean.

- [ ] T004 Create `lib/src/core/financial/genius_rounding_policy.dart` — define `GeniusRoundingMode` enum (halfUp, halfEven, truncate, floor, ceiling); define `GeniusRoundingPolicy` class with fields `decimalPlaces`, `mode`, `absoluteTolerance?`, `relativeTolerance?`; implement `double round(double value)` using integer minor-unit conversion with mode-appropriate offset; implement `bool isWithinTolerance(double expected, double actual)` applying the looser of absolute and relative bounds; factory constructors: `defaults()` (2dp, halfUp, abs=1 minor unit), `strict()` (2dp, halfUp, abs=0), `forCurrency(String)` (looks up from AmountToWords.currencies), `withRelative(double)`
- [ ] T005 [P] Create `lib/src/core/financial/genius_money.dart` — define immutable `GeniusMoney` with `final int minorUnits`, `final String currency`, `final int decimalPlaces`; factory `fromDouble(double, {String currency, GeniusRoundingPolicy? policy})` using `round()` for the single float→int conversion; factory `fromMinorUnits(int, ...)` and `zero(...)`; operators `+` and `-` as exact integer arithmetic (assert same currency); method `multiplyByRate(double rate, {GeniusRoundingPolicy? policy})` rounding the product once; `isWithinTolerance(GeniusMoney, GeniusRoundingPolicy)`; `double toDouble()` and `String toDisplayString({int?})`
- [ ] T006 [P] Create `lib/src/core/financial/genius_validation_result.dart` — define `GeniusFinancialValidationError` (const, fields: `fieldId`, `ruleId`, `expectedValue: GeniusMoney`, `actualValue: GeniusMoney`, `message`, `messageAr`); define `GeniusFinancialValidationResult` (factory `valid()`, factory `invalid(List<GeniusFinancialValidationError>)`, `isValid`, `errors`); static helper `GeniusFinancialValidationResult combine(List<GeniusFinancialValidationResult>)` merging all errors
- [ ] T007 [P] Create `lib/src/core/financial/genius_validation_context.dart` — define `GeniusFinancialValidationContext` (const; `roundingPolicy` defaults to `GeniusRoundingPolicy.defaults()`, `sourceCurrencyPolicy?`, `documentCurrency` defaults to `'SAR'`)
- [ ] T008 Create `lib/src/core/financial/genius_financial_validator.dart` — define `GeniusFinancialValidator(GeniusRoundingPolicy policy)` with all rule methods per data-model.md: `validateSubtotal`, `validateVat` (post-discount base × rate), `validateGrandTotal` (subtotal − discounts + vat + fees), `validateTransferNet` (source − fee − commission), `validateCurrencyConversion` (two-stage: source subtotal then source × rate ≈ target), `validateAccountingEntries` (sum debits ≈ sum credits), `validateGridColumn`, `validateAverage`, `validateBudgetVariance` (guard division-by-zero), `double roundForWords(double)`, `GeniusFinancialValidationResult combineResults(List<...>)`; every error carries both English `message` and Arabic `messageAr`
- [ ] T009 Create `lib/src/core/financial/financial.dart` — barrel exporting `genius_rounding_policy.dart`, `genius_money.dart`, `genius_validation_result.dart`, `genius_validation_context.dart`, `genius_financial_validator.dart`
- [ ] T010 Modify `lib/src/models/pdf_result.dart` — add `GeniusPdfFailure.fromValidation(GeniusFinancialValidationResult result)` factory (sets `error: result`, `message: result.errors.first.message`, `stackTrace: null`); add `GeniusFinancialValidationResult? get validationResult` getter (returns `error as GeniusFinancialValidationResult?`); import `core/financial/financial.dart`
- [ ] T011 Modify `lib/genius_link_pdf_generator.dart` — add `export 'src/core/financial/financial.dart';` after existing core exports
- [ ] T012 [P] Create `test/financial/genius_rounding_policy_test.dart` — group `GeniusRoundingMode`: test each mode (halfUp: 2.345→2.35, halfEven: 2.345→2.34, truncate: 2.999→2.99, floor: 2.991→2.99, ceiling: 2.901→2.91 for 2dp); group `isWithinTolerance`: absolute only (0.01 abs, 0.005 passes, 0.015 fails), relative only (0.1% of 1000=1.0, passes within), both (looser bound wins); `forCurrency('KWD')` → 3dp, `forCurrency('JPY')` → 0dp
- [ ] T013 [P] Create `test/financial/genius_money_test.dart` — `fromDouble` round-trip for 2dp (150.255→15026 minor units), 3dp (150.255→150255), 0dp (1.9→2); addition and subtraction as exact integers; `multiplyByRate` with halfUp/halfEven/truncate; negative amounts (-150.25); mismatched currency asserts; `toDouble` inverse of `fromDouble`; `toDisplayString` formatting
- [ ] T014 Create `test/financial/genius_financial_validator_test.dart` — test each validator method: `validateSubtotal` (pass: [500,300,200] sum=1000; fail: provided 950 diff=50>0.01); `validateVat` (pass: base=900, rate=15, vat=135; fail: provided 150 uses pre-discount base); `validateGrandTotal` (pass: 900+135=1035; fail: 1085); `validateTransferNet` (pass: 1000−15−5=980; fail: provided 975); `validateCurrencyConversion` (two-stage: USD subtotal ok then 500×3.75=1875 SAR ok; stage-1 fail; stage-2 fail); `validateAccountingEntries` (balanced 5000=5000; unbalanced 5000≠4999.99); `validateGridColumn`; `validateBudgetVariance` (variance=actual−budget, pct=variance/budget, zero-budget guard); `combineResults` merges errors
- [ ] T015 [P] Create `test/financial/edge_cases_test.dart` — SC-006 regression suite: zero subtotal (0 items, providedSubtotal=0 passes); negative amounts (credit note lines [-500,-300], subtotal=-800 passes); large amount (999999999.99 rounds correctly); rounding boundary (`roundForWords(1499.9999999)` → 1500.00, `roundForWords(100.004)` → 100.00); multi-currency (USD→SAR two-stage: 500 USD × 3.75 = 1875.00 SAR passes); accumulation (100 lines of 0.333 SAR: sum of individually-rounded values vs rounded sum); VAT post-discount (subtotal=1000, discount=100, vatBase=900, vat=135, NOT 150)
- [ ] T016 Run `flutter test test/financial/` — confirm all tests pass with zero failures before proceeding to Phase 3; fix any test failures in T004–T015 before advancing

---

## Phase 3: User Story 1 — Invoice and Voucher Validation (Priority: P1)

**Goal**: All invoice-type templates and purchase/sales vouchers validate subtotals, VAT (post-discount base), and grand totals before rendering. Inconsistent totals return `GeniusPdfFailure` with bilingual errors.

**Independent Test**: Call `TaxInvoiceTemplate(...).generate()` with a provided subtotal that differs from the sum of line items by 0.02. Verify the result is `GeniusPdfFailure` whose `validationResult.errors.first.fieldId == 'subtotal'` and `messageAr` is non-empty. Confirm a consistent invoice produces `GeniusPdfSuccess`.

- [ ] T017 [P] [US1] Modify `lib/src/templates/tax_invoice_template.dart` — add `validateFinancials: bool = true` and `validationContext: GeniusFinancialValidationContext?` to `TaxInvoiceTemplate.generate()`; add private `GeniusFinancialValidationResult _validate(GeniusFinancialValidator v)` calling `v.validateSubtotal`, `v.validateVat(vatBase: data.subtotal, vatRate: tax.rate, ...)` for each tax, `v.validateGrandTotal`, then `GeniusFinancialValidationResult.combine([...])`; apply `GeniusPdfFailure.fromValidation()` before rendering; import `core/financial/financial.dart`
- [ ] T018 [P] [US1] Modify `lib/src/templates/credit_note_template.dart` — same `validateFinancials`/`validationContext` pattern; `_validate()` calls `validateSubtotal` + `validateGrandTotal` (negative amounts are valid inputs)
- [ ] T019 [P] [US1] Modify `lib/src/templates/purchase_order_template.dart` — add `validateFinancials`/`validationContext` + `_validate()` calling `validateSubtotal` + `validateVat` (if tax rate present) + `validateGrandTotal`
- [ ] T020 [P] [US1] Modify `lib/src/templates/quotation_template.dart` — same pattern as purchase_order_template; `validateSubtotal` + `validateVat` (if present) + `validateGrandTotal`
- [ ] T021 [P] [US1] Modify `lib/src/templates/payslip_template.dart` — add `validateFinancials`/`validationContext` + `_validate()` calling `validateGrandTotal(subtotal: grossPay, discounts: 0, vatAmount: 0, fees: totalDeductions, providedGrandTotal: netPay)`
- [ ] T022 [P] [US1] Modify `lib/src/templates/customer_statement_template.dart` — add `validateFinancials`/`validationContext` + `_validate()` calling `validateSubtotal` on opening balance + transactions → closing balance
- [ ] T023 [US1] Modify `lib/src/templates/vouchers/voucher_base_template.dart` — add `validateFinancials: bool = true` and `validationContext: GeniusFinancialValidationContext?` to the base `generate()` method; add protected `GeniusFinancialValidationResult validateVoucherData(GeniusFinancialValidator validator)` with a dispatch `switch` on `data.serviceId`; for Phase 3 implement US1 service ID ranges: purchase voucher (10000–10049) and sales voucher (10050–10099) → `validateSubtotal` using `data.items`; all other IDs → `GeniusFinancialValidationResult.valid()` placeholder (filled in Phase 4 and 5)
- [ ] T024 [US1] Run `flutter analyze lib/src/templates/` — fix any errors; run `flutter test test/financial/` — confirm no regressions; manually open example app and verify: (a) a `TaxInvoiceTemplate` with consistent data generates a PDF, (b) a `TaxInvoiceTemplate` with subtotal off by 1.00 returns `GeniusPdfFailure` whose first error has a non-empty `messageAr`

**Checkpoint**: US1 complete — invoice validation is functional and independently verifiable.

---

## Phase 4: User Story 2 — Transfer and Remittance Validation (Priority: P2)

**Goal**: Transfer, remittance, and tax vouchers validate net amounts, exchange rate conversions, and VAT entries. Inconsistent amounts return `GeniusPdfFailure`.

**Independent Test**: Create a remittance voucher where `targetAmount ≠ sourceAmount × exchangeRate` (off by more than 0.01). Verify `GeniusPdfFailure` is returned with `validationResult.errors.first.fieldId` identifying the conversion stage that failed and both `message` and `messageAr` non-empty.

- [ ] T025 [P] [US2] Extend `voucher_base_template.dart` `validateVoucherData()` dispatch — add transfer voucher IDs (10200–10203): call `validator.validateTransferNet(sourceAmount: data.amount, fee: transferData.fee, commission: transferData.commission, providedNetAmount: data.netAmount)`; if exchange rate is present also call `validator.validateCurrencyConversion` with two-stage policy using `validationContext.sourceCurrencyPolicy`
- [ ] T026 [P] [US2] Extend dispatch for remittance voucher IDs (10300–10305) — call two-stage `validator.validateCurrencyConversion(sourceAmount, exchangeRate, providedTargetAmount, sourceCurrencyPolicy: ctx.sourceCurrencyPolicy)` using fields from `data.remittanceData` or equivalent remittance-specific data object
- [ ] T027 [P] [US2] Extend dispatch for tax voucher IDs (10400–10402) — call `validator.validateVat(vatBase: data.outputVatBase, vatRate: data.vatRate, providedVatAmount: data.netVatAmount)` (net VAT = output VAT − input VAT validated as: outputVatBase × rate − inputVatAmount ≈ providedNetVat)
- [ ] T028 [US2] Run `flutter analyze lib/src/templates/vouchers/` — fix any errors; run `flutter test test/financial/`; manually verify: a transfer voucher with correct net amount generates PDF, a transfer voucher with wrong net amount returns `GeniusPdfFailure` with bilingual error message

**Checkpoint**: US1 + US2 both independently functional.

---

## Phase 5: User Story 3 — Grid Totals and Accounting Entry Validation (Priority: P2)

**Goal**: Accounting-entry vouchers validate debit/credit balance. Financial statement templates validate their structural totals (assets = liabilities + equity, net income, variance, grid column sums).

**Independent Test**: Create a `BalanceSheetTemplate` where total assets ≠ total liabilities + equity. Verify `GeniusPdfFailure` with `fieldId == 'debit_credit_balance'` and a non-empty `messageAr`. Verify a balanced sheet generates a PDF.

- [ ] T029 [P] [US3] Extend `voucher_base_template.dart` `validateVoucherData()` dispatch — add accounting entry voucher IDs (10100–10105): call `validator.validateAccountingEntries(debits: data.accountEntries.where((e) => e.isDebit).map((e) => e.amount).toList(), credits: data.accountEntries.where((e) => !e.isDebit).map((e) => e.amount).toList())`
- [ ] T030 [P] [US3] Modify `lib/src/templates/balance_sheet_template.dart` — add `validateFinancials`/`validationContext` + `_validate()` calling `validator.validateAccountingEntries(debits: totalAssets, credits: totalLiabilities + totalEquity)`
- [ ] T031 [P] [US3] Modify `lib/src/templates/trial_balance_template.dart` — add `validateFinancials`/`validationContext` + `_validate()` calling `validator.validateAccountingEntries` on all debit and credit column totals
- [ ] T032 [P] [US3] Modify `lib/src/templates/income_statement_template.dart` — add `validateFinancials`/`validationContext` + `_validate()` calling `validator.validateGrandTotal(subtotal: totalRevenue, discounts: 0, vatAmount: 0, fees: totalExpenses, providedGrandTotal: netIncome)` (expenses treated as fees to make grand total = net income)
- [ ] T033 [P] [US3] Modify `lib/src/templates/cash_flow_template.dart` — add `validateFinancials`/`validationContext` + `_validate()` calling `validator.validateSubtotal` on each cash flow section (operating, investing, financing), then `validator.validateGrandTotal` on net cash flow
- [ ] T034 [P] [US3] Modify `lib/src/templates/budget_report_template.dart` — add `validateFinancials`/`validationContext` + `_validate()` calling `validator.validateBudgetVariance` for each budget line item; `combineResults` across all lines
- [ ] T035 [P] [US3] Modify `lib/src/templates/inventory_report_template.dart` — add `validateFinancials`/`validationContext` + `_validate()` calling `validator.validateGridColumn` on quantity and value columns; combine results
- [ ] T036 [US3] Run `flutter analyze lib/src/templates/` — fix any errors; run `flutter test test/financial/`; manually verify: balanced balance sheet generates PDF, unbalanced sheet returns `GeniusPdfFailure`

**Checkpoint**: US1 + US2 + US3 all independently functional.

---

## Phase 6: User Story 4 — Amount-to-Words Correctness (Priority: P3)

**Goal**: Every call to `AmountToWords.toEnglish` or `AmountToWords.toArabic` in all financial templates receives a pre-rounded amount, never a raw floating-point value.

**Independent Test**: Pass a raw amount of `1499.9999999` to a template configured with the default rounding policy. Verify the generated PDF's written amount corresponds to `1,500.00` and not `1,499` with floating-point noise.

- [ ] T037 [P] [US4] Modify `lib/src/templates/tax_invoice_template.dart` — locate every `AmountToWords.toEnglish(...)` and `AmountToWords.toArabic(...)` call; replace the raw `double` argument with `validator.roundForWords(rawAmount)` using the document validator instance constructed in `generate()`; apply the same fix in `lib/src/templates/credit_note_template.dart`
- [ ] T038 [P] [US4] Apply the same `roundForWords()` pre-rounding pattern to all remaining templates that call `AmountToWords`: `lib/src/templates/purchase_order_template.dart`, `lib/src/templates/quotation_template.dart`, `lib/src/templates/payslip_template.dart`, and any voucher templates in `lib/src/templates/vouchers/templates/` that call `AmountToWords.toEnglish` or `.toArabic` (search with `grep -r "AmountToWords" lib/src/templates/`)
- [ ] T039 [US4] Add two named test cases to `test/financial/edge_cases_test.dart` under a new group `'AmountToWords pre-rounding'`: (a) `roundForWords(1499.9999999)` with 2dp halfUp policy → `1500.00`; (b) `roundForWords(100.004)` with 2dp halfUp policy → `100.00`; run `flutter test test/financial/edge_cases_test.dart` to confirm both pass
- [ ] T040 [US4] Run `flutter analyze lib/src/templates/` — confirm no warnings on modified files; run `flutter test test/financial/` full suite

**Checkpoint**: All four user stories are independently functional.

---

## Phase 7: Polish & Cross-Cutting Concerns

**Purpose**: Close the package contract, update documentation, and confirm release readiness.

- [ ] T041 Update `README.md` — add "Financial Validation" section after existing template documentation; include: overview paragraph, default-behaviour code example (existing call unchanged), error-handling example (switch on GeniusPdfFailure.validationResult), opt-out example (`validateFinancials: false`), custom policy example (KWD 3dp, strict, relative tolerance), `GeniusMoney` arithmetic example; mark all code examples as compilable (no pseudo-code without comment)
- [ ] T042 [P] Audit all existing `README.md` code examples that include financial amounts — for each example, verify that displayed totals equal the sum of their displayed line items; correct any inconsistent example; annotate corrected examples with `// consistent: subtotal + VAT = grand total`
- [ ] T043 Update `CHANGELOG.md` — add `## [3.6.0] - 2026-05-07` entry with `### Added` (GeniusMoney, GeniusRoundingPolicy, GeniusRoundingMode, GeniusFinancialValidator, GeniusFinancialValidationResult, GeniusFinancialValidationError, GeniusFinancialValidationContext, GeniusPdfFailure.fromValidation factory and validationResult getter), `### Changed` (all financial template generate() methods — validateFinancials: true default, migration: pass validateFinancials: false to restore prior behaviour), `### Fixed` (AmountToWords pre-rounding, README example corrections)
- [ ] T044 [P] Create `example/lib/screens/financial_validation_screen.dart` — StatefulWidget with two `ElevatedButton` widgets: "Generate Valid Invoice" (uses consistent sample data, displays generated PDF byte count) and "Generate Invalid Invoice" (uses subtotal deliberately off by 1.00, displays each `error.message` and `error.messageAr` from `validationResult.errors`); import `genius_link_pdf_generator.dart`
- [ ] T045 [P] Update `example/lib/data/sample_data.dart` — add a `validInvoiceData` variable with InvoiceData whose subtotal, VAT (15% on post-discount base), and grand total are internally consistent (e.g., 3 line items totalling 1000.00, VAT=150.00, grand=1150.00); add `invalidInvoiceData` with subtotal deliberately set 50.00 too low for demonstration purposes
- [ ] T046 [P] Register the new screen in `example/lib/screens/home_screen.dart` — add a navigation item "Financial Validation Demo" linking to `FinancialValidationScreen`
- [ ] T047 Run `flutter analyze` on the full project (`lib/` + `example/`) — resolve all errors and warnings introduced by this feature
- [ ] T048 Run `flutter test test/financial/` — confirm all tests pass; record manual verification results: (a) valid invoice → GeniusPdfSuccess with byte count > 0; (b) invalid invoice → GeniusPdfFailure, validationResult.errors non-empty, first error has non-empty messageAr; (c) generate with validateFinancials: false on invalid data → GeniusPdfSuccess (opt-out works)

---

## Dependencies & Execution Order

### Phase Dependencies

- **Phase 1 (Setup)**: No dependencies
- **Phase 2 (Foundational)**: Requires Phase 1 completion. Blocks all user story phases — tests MUST pass (T016) before Phase 3 begins
- **Phase 3 (US1)**: Requires Phase 2 complete (T016 green). T023 depends on T017–T022 being started (voucher base needs the context after individual templates are understood)
- **Phase 4 (US2)**: Requires Phase 2 complete. T025–T027 depend on T023 (voucher base pattern established in US1)
- **Phase 5 (US3)**: Requires Phase 2 complete. T029 depends on T023 (extends same dispatch)
- **Phase 6 (US4)**: Requires Phase 2 complete (uses `roundForWords`). Can run concurrently with Phases 3–5 if desired, but T037–T038 are most naturally applied after T017–T023
- **Phase 7 (Polish)**: Requires all desired user story phases complete. T047 requires T041–T046 all complete

### Within Each User Story

- Core financial file tasks (T004–T009) must complete before validator tests (T012–T015)
- Tests (T012–T016) must pass before template integration (T017+)
- Template modification tasks within each phase are largely parallel (different files)
- Voucher base changes (T023, T025, T026, T027, T029) are sequential across phases since they all modify the same file

### Parallel Opportunities

- T004–T007 (core financial files): all parallel — independent files
- T010–T011 (pdf_result + barrel): parallel with T004–T007 and with each other
- T012–T013 (policy + money tests): parallel — independent test files
- T017–T022 (US1 individual templates): all parallel — different template files
- T025–T027 (US2 voucher dispatch extensions): parallel additions to same method but in different `case` branches — can be written in parallel, merged before commit
- T030–T035 (US3 financial statement templates): all parallel — different template files
- T037–T038 (US4 roundForWords): parallel — different template files
- T041–T046 (Polish): T041, T042, T044, T045, T046 are parallel. T043 sequential after T041

---

## Task Summary

| Phase | Tasks | Story | Parallel |
| ----- | ----- | ----- | -------- |
| Phase 1: Setup | T001–T003 | — | T002, T003 |
| Phase 2: Foundational | T004–T016 | — | T004–T007, T010–T013, T015 |
| Phase 3: US1 | T017–T024 | US1 | T017–T022 |
| Phase 4: US2 | T025–T028 | US2 | T025–T027 |
| Phase 5: US3 | T029–T036 | US3 | T029–T035 |
| Phase 6: US4 | T037–T040 | US4 | T037–T038 |
| Phase 7: Polish | T041–T048 | — | T041–T042, T044–T046 |
| **Total** | **48 tasks** | | |

**MVP Scope** (User Story 1 only): T001–T016 + T017–T024 = 24 tasks. Delivers: complete core financial layer with tests, plus full invoice/purchase-order/payslip/purchase-voucher validation.
