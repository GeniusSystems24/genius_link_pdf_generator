# Feature Specification: Financial Calculation Correctness and Validation

**Feature Branch**: `001-financial-calc-validation`  
**Created**: 2026-05-07  
**Status**: Draft  
**Input**: User description: "Financial Calculation Correctness and Validation"

## Clarifications

### Session 2026-05-07

- Q: Is VAT calculated on the post-discount amount or the pre-discount subtotal? → A: Post-discount amount (subtotal − all discounts) × VAT rate, matching ZATCA rules.
- Q: When should rounding be applied in multi-step calculations? → A: Once per named field — discount amount, VAT amount, and grand total are each rounded separately; their rounded values are then summed.
- Q: Should validation tolerance be absolute (fixed minor unit) or relative (percentage of calculated value)? → A: Both — caller selects per document; default is absolute at one minor currency unit (e.g., 0.01 for 2-decimal currencies); caller may switch to relative (percentage) or combine both.
- Q: For multi-currency documents, at which level are amounts validated? → A: Two-stage — first validate source-currency subtotal (sum of source-currency line items), then validate the converted document-currency total (source subtotal × exchange rate); each stage uses its own currency's rounding policy.
- Q: How should existing callers opt out of validation? → A: Per-call boolean — each template's generate method gains an optional `validateFinancials: false` named parameter; callers who omit it get validation enabled by default.

---

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Invoice and Voucher Validation (Priority: P1)

A developer generates a tax invoice, purchase voucher, or sales voucher that includes line items, a subtotal, VAT, discounts, and a grand total. Before producing any PDF bytes, the library verifies that every total field is mathematically consistent with its inputs under the configured rounding policy. If any amount is off, the library returns a structured validation error in the caller's preferred language instead of silently producing a wrong document.

**Why this priority**: Incorrect invoice totals are a legal and financial risk. This is the most common document type and the first place errors surface.

**Independent Test**: Supply a voucher where the subtotal differs from the sum of line item amounts by 0.01 or more. Verify the library returns a validation error naming the subtotal field, expected value, actual value, and a bilingual message — and does not return any PDF bytes.

**Acceptance Scenarios**:

1. **Given** a purchase voucher with three line items summing to 1,500.00 and a provided subtotal of 1,450.00, **When** the document is generated with validation enabled, **Then** the library returns a validation error indicating the subtotal is incorrect and no PDF is produced.
2. **Given** a tax invoice with a correct subtotal of 1,000.00, a VAT rate of 15%, and a provided VAT amount of 150.00, **When** the document is generated, **Then** the library produces a valid PDF with no validation errors.
3. **Given** a tax invoice with subtotal 1,000.00, discount 100.00, VAT rate 15% (VAT base = 900.00, VAT = 135.00), and grand total 1,035.00, **When** generated, **Then** validation passes and a PDF is returned.
4. **Given** the same invoice with a grand total of 1,085.00 (wrong — uses pre-discount VAT base), **When** generated, **Then** the library returns a validation error for the grand total field.

---

### User Story 2 - Transfer and Remittance Validation (Priority: P2)

A developer produces a bank transfer, remittance, or banking voucher that includes a source amount, a transfer fee, a commission, an exchange rate, and a net or target amount. The library validates all derived amounts against their inputs using the configured rounding policy before generating the document.

**Why this priority**: Currency conversion and fee deductions involve compounding rounding risk. Errors here directly affect payments made to customers or counterparties.

**Independent Test**: Supply a remittance voucher where the target amount differs from `(source − fee − commission) × exchange_rate` by more than the allowed tolerance. Verify a structured validation error is returned without a PDF.

**Acceptance Scenarios**:

1. **Given** a transfer voucher with source 1,000.00 SAR, fee 15.00, commission 5.00, and a provided net amount of 975.00, **When** generated, **Then** validation passes (1,000 − 15 − 5 = 980 is not 975 — actually this would fail). *Correction: net = 980.00; if provided 975.00, library returns validation error.*
2. **Given** a remittance with source 500.00 USD, exchange rate 3.75 SAR/USD, no fees, and target 1,875.00 SAR, **When** generated, **Then** validation passes.
3. **Given** the same remittance with target 1,870.00 SAR, **When** generated, **Then** library returns a validation error for the target amount field with both English and Arabic messages.
4. **Given** a VAT voucher with output VAT 200.00 and input VAT 50.00, and net VAT 150.00, **When** generated, **Then** validation passes.

---

### User Story 3 - Grid Totals and Accounting Entry Validation (Priority: P2)

A developer generates a financial report that includes a data grid with grouped rows and total rows at the group and report levels, or an accounting voucher with debit and credit columns. The library validates that aggregated values in total rows match the sum of their source rows, and that debits equal credits for accounting entries.

**Why this priority**: Silent rounding errors in group totals can make auditors and accountants unable to reconcile reports.

**Independent Test**: Supply a grid with two groups, each having a total row. Alter one group's total to be 0.01 higher than the sum of its rows. Verify the library returns a validation error identifying the group, the column, and the discrepancy.

**Acceptance Scenarios**:

1. **Given** a grid with two row groups and correct group-level and report-level totals, **When** generated, **Then** validation passes and a PDF is produced.
2. **Given** a grid where the report-level total for an "Amount" column is 1.00 more than the sum of group totals, **When** generated, **Then** the library returns a validation error for the report total of that column.
3. **Given** an accounting entry with debits 5,000.00 and credits 5,000.00, **When** generated, **Then** validation passes.
4. **Given** an accounting entry with debits 5,000.00 and credits 4,999.99, **When** generated, **Then** the library returns a validation error stating debits and credits do not balance.

---

### User Story 4 - Amount-to-Words Correctness (Priority: P3)

Whenever the library converts a monetary amount to words (e.g., "One Thousand Five Hundred Riyals"), it first applies the configured rounding policy so the input to the conversion is always the exact rounded value, never a raw floating-point number with potential trailing noise.

**Why this priority**: Mismatched numeric and textual amounts on a legal document can invalidate it.

**Independent Test**: Provide a raw floating-point amount such as 1499.999999 and a 2-decimal rounding policy. Verify the words produced are "One Thousand Five Hundred" (i.e., 1,500.00 after rounding), not a representation of the unrounded value.

**Acceptance Scenarios**:

1. **Given** a raw amount of 1499.999999 and a 2-decimal round-half-up policy, **When** converted to words, **Then** the result corresponds to 1,500.00.
2. **Given** a raw amount of 100.004 and a 2-decimal round-half-down policy, **When** converted to words, **Then** the result corresponds to 100.00.

---

### Edge Cases

- **RTL and LTR modes**: The validation layer is calculation-only and produces no rendered output, so layout direction does not affect correctness. Error messages are returned in both Arabic and English regardless of direction.
- **Arabic and English text divergence**: English and Arabic error messages are independent strings; they may differ in length without affecting functionality.
- **Existing public API consumers**: Validation is opt-out. All existing calls that do not pass inconsistent data continue to work without modification. Callers who previously passed inconsistent data will now receive a validation error rather than a wrong PDF — this is an intentional, documented behavioral change.
- **Partial generation failure**: If validation fails at any point, no PDF bytes are produced. The library returns only the structured validation result.
- **Zero, negative, and large amounts**: Zero line items are valid. Negative amounts (credit notes, refunds) must validate the same rules with sign taken into account. Amounts beyond typical currency ranges must not overflow.
- **Multi-currency documents**: Validation is two-stage. Stage 1 validates the source-currency subtotal against its line items using the source currency's rounding policy. Stage 2 validates the document-currency total against the converted source subtotal using the document currency's rounding policy. Errors from each stage are reported independently so callers can distinguish a data error (wrong source subtotal) from an arithmetic error (wrong exchange rate application).

---

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The library MUST use a calculation approach that eliminates rounding errors inherent in binary floating-point representation for all financial calculations.
- **FR-002**: Rounding rules MUST be explicit, configurable per document, and default to 2 decimal places with round-half-up. Rounding is applied once per named financial field (e.g., discount amount, VAT amount, grand total are each rounded independently; their rounded values are then summed — no intermediate rounding within a single field's formula).
- **FR-003**: The rounding configuration MUST support currency minor units (e.g., 0 decimals for JPY, 3 for KWD).
- **FR-004**: All financial templates MUST either derive totals from their line-item inputs internally or validate any externally supplied totals against internally calculated values.
- **FR-005**: When a provided total differs from the calculated total by more than the configured tolerance, the library MUST return a structured validation error and MUST NOT produce any PDF bytes. Tolerance MUST support two modes: (a) absolute — a fixed monetary amount (default: one minor currency unit, e.g., 0.01 for SAR); (b) relative — a percentage of the calculated value (e.g., 0.1%). The caller may configure either or both per document; when both are set, the looser bound applies. Default is absolute at one minor unit.
- **FR-006**: Validation MUST be enabled by default for all financial templates. Each template's generate method MUST accept an optional `validateFinancials` boolean parameter (default: `true`). Passing `validateFinancials: false` fully disables validation for that call, restoring pre-feature behavior. No global or static flag is provided.
- **FR-007**: Every validation error MUST carry both an English message and an Arabic message.
- **FR-008**: The library MUST validate that the document subtotal equals the sum of all line item amounts (respecting the rounding policy).
- **FR-009**: The library MUST validate VAT as: (subtotal − total discounts) × VAT rate, rounded per the rounding policy. VAT is always calculated on the post-discount base.
- **FR-010**: The library MUST validate the grand total as: subtotal − discounts + VAT (on post-discount base) + applicable fees and charges, rounded per the rounding policy.
- **FR-011**: For transfer and banking documents, the library MUST validate transfer fees, commissions, and their deduction from the source amount.
- **FR-012**: For currency conversion documents, the library MUST apply two-stage validation: (1) validate the source-currency subtotal equals the sum of source-currency line items, using the source currency's rounding policy; (2) validate the document-currency total equals the rounded source-currency subtotal multiplied by the exchange rate, using the document currency's rounding policy. Each stage reports errors independently.
- **FR-013**: For accounting entry documents, the library MUST validate that the sum of debit amounts equals the sum of credit amounts.
- **FR-014**: The library MUST validate payment deduction amounts against source and remaining balance.
- **FR-015**: The library MUST validate budget variance as actual minus budget, and variance percentage as variance divided by budget (guarding against division by zero).
- **FR-016**: For data grids, the library MUST validate total rows (sum, average, min, max, count) against the values of their constituent rows at both group and report levels.
- **FR-017**: Amount-to-words conversion MUST always receive a rounded amount, never a raw floating-point value.
- **FR-018**: All existing public APIs MUST remain backward compatible. Any unavoidable breaking change MUST be documented in the CHANGELOG with a migration guide.
- **FR-019**: All README code examples involving financial amounts MUST be reviewed and corrected so that supplied totals are consistent with their line items.

### Key Entities *(include if feature involves data)*

- **MoneyAmount**: A safe representation of a monetary value — holds a precise amount and a currency code with its minor-unit precision. Supports addition, subtraction, multiplication by a rate, and rounding to minor units.
- **RoundingPolicy**: Configuration for how amounts are rounded — decimal places, rounding mode (half-up, half-even, truncate), and the tolerance used for equality comparisons. Tolerance has two independent sub-settings: an absolute floor (fixed monetary amount) and a relative ceiling (percentage of the calculated value); the looser of whichever are configured applies.
- **FinancialValidationContext**: Supplied to a template at generation time — holds the document-currency rounding policy, an optional source-currency rounding policy (for multi-currency documents), the document currency code, and an opt-out flag.
- **FinancialValidationResult**: The outcome of validating a document — a success flag and a list of zero or more `FinancialValidationError` items.
- **FinancialValidationError**: A single validation failure — identifies the document field or rule that failed, the expected value, the actual value, and bilingual error messages.

---

## Contract Impact *(mandatory)*

### Public Surface

- **Exports/barrels affected**: `lib/pdf_generator.dart` — new validation types will be exported.
- **Constructors/factories/enums/models affected**: All financial template `generate()` methods gain an optional `validateFinancials` boolean parameter (default: `true`); existing calls without it are unaffected and receive validation enabled. New classes `MoneyAmount`, `RoundingPolicy`, `FinancialValidationContext`, `FinancialValidationResult`, and `FinancialValidationError` are added for callers who want fine-grained control.
- **Backward compatibility impact**: Additive for callers with consistent data. Behaviorally breaking for callers that previously supplied inconsistent totals (they now receive a validation error rather than a wrong PDF). This is intentional and documented.

### Direction & Language

- **Arabic/English text affected**: Validation error messages are new bilingual strings — both `message` (English) and `messageAr` (Arabic) fields on every error.
- **RTL/LTR layout impact**: None — this feature operates entirely in the calculation layer before rendering begins.

### Documentation & Examples

- **README impact**: Add "Financial Validation" section covering `FinancialValidationContext`, opt-out usage, and error handling. Review and fix all code examples with financial amounts.
- **CHANGELOG impact**: `Added` entry for the validation layer; `Changed` entry for default validation behavior on financial templates; `Fixed` entry for any corrected README examples.
- **Example impact**: Add an example screen demonstrating a valid invoice generation and a deliberately invalid invoice that surfaces a validation error. Update `sample_data.dart` with consistent financial sample data.

---

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A purchase voucher with a subtotal inconsistent with its line items is rejected with a structured bilingual error before any PDF bytes are produced, in 100% of cases.
- **SC-002**: A VAT voucher where net VAT ≠ output VAT − input VAT is rejected with a structured error identifying the net VAT field, expected value, and actual value.
- **SC-003**: A remittance voucher where the target amount is inconsistent with the source, fee, and exchange rate under the configured rounding policy is rejected before PDF generation.
- **SC-004**: Every validation error object contains a non-empty English message and a non-empty Arabic message.
- **SC-005**: All existing financial template callers that supply internally consistent data continue to receive correct PDFs without any code changes.
- **SC-006**: A regression test suite exists covering zero amounts, negative amounts (credit notes), amounts requiring rounding, amounts exceeding typical financial ranges, multi-currency scenarios, and grid total validation — and all tests pass.
- **SC-007**: Amount-to-words conversion produces output matching the correctly rounded value in all tested cases; no raw floating-point noise appears in word output.
- **SC-008**: Passing `validateFinancials: false` to any financial template's generate method produces a PDF identical to pre-feature behavior, with no validation errors returned and no performance overhead from validation logic.

---

## Assumptions

- The library runs in a Dart/Flutter environment; safe money arithmetic is implemented using integer-scaled values or a Decimal library compatible with Dart, without relying on `double` for intermediate financial calculations.
- The default tolerance mode is absolute, fixed at one minor currency unit (e.g., 0.01 for SAR/USD with 2 decimal places). Callers may switch to relative tolerance (percentage of calculated value) or configure both simultaneously, in which case the looser bound applies.
- Validation is applied synchronously at the start of the generate call, before any PDF rendering work begins.
- Templates that do not involve financial amounts (e.g., purely informational documents) are out of scope and are not affected.
- The exchange rate is provided as a pre-negotiated value by the caller; the library validates the arithmetic but does not fetch or validate the rate itself.
- Negative amounts are valid inputs (representing refunds, credit notes, or adjustments); the same validation rules apply with sign considered.
- If a caller provides no `validationContext`, the library uses a default context with 2-decimal SAR-compatible rounding and validation enabled.
- Breaking changes to existing public constructors will be avoided; the `validateFinancials` parameter is optional with a default of `true`, so existing call sites compile and run unchanged. Callers with previously inconsistent totals will start receiving validation errors — this is intentional and documented as a behavioral change, not an API break.
