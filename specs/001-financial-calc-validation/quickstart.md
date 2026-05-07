# Quickstart: Financial Validation Integration

**Feature**: `001-financial-calc-validation`  
**Audience**: Library consumers integrating v3.6.0+

---

## Default Behaviour (No Code Changes Required)

Financial validation is enabled by default. Existing call sites work unchanged for consistent data:

```dart
// Before v3.6.0
final result = await TaxInvoiceTemplate(
  config: config,
  company: company,
  data: invoiceData,
).generate();

// After v3.6.0 — identical call, validation now runs automatically
final result = await TaxInvoiceTemplate(
  config: config,
  company: company,
  data: invoiceData,
).generate(); // validateFinancials: true (default)
```

---

## Handling Validation Errors

When totals are inconsistent, `generate()` returns a `GeniusPdfFailure` whose `validationResult` carries structured errors:

```dart
final result = await TaxInvoiceTemplate(
  config: config,
  company: company,
  data: invoiceData,
).generate();

switch (result) {
  case GeniusPdfSuccess(:final bytes):
    // Use bytes — totals were consistent
    break;
  case GeniusPdfFailure(:final validationResult):
    if (validationResult != null && !validationResult.isValid) {
      for (final error in validationResult.errors) {
        print('EN: ${error.message}');    // English
        print('AR: ${error.messageAr}'); // Arabic
        print('Field: ${error.fieldId}');
        print('Expected: ${error.expectedValue.toDisplayString()}');
        print('Actual:   ${error.actualValue.toDisplayString()}');
      }
    }
}
```

---

## Opting Out of Validation

Pass `validateFinancials: false` for any call that must not be validated (migration period, legacy data):

```dart
final result = await TaxInvoiceTemplate(
  config: config,
  company: company,
  data: invoiceData,
).generate(validateFinancials: false); // pre-v3.6.0 behaviour restored
```

---

## Custom Rounding Policy

Override the default 2dp / halfUp / absolute-0.01 policy per call:

```dart
// KWD invoice — 3 decimal places
final result = await TaxInvoiceTemplate(
  config: config,
  company: company,
  data: invoiceData,
).generate(
  validationContext: GeniusFinancialValidationContext(
    roundingPolicy: GeniusRoundingPolicy.forCurrency('KWD'),
    documentCurrency: 'KWD',
  ),
);

// Strict mode — zero tolerance, any discrepancy fails
final strictResult = await TaxInvoiceTemplate(
  config: config,
  company: company,
  data: invoiceData,
).generate(
  validationContext: GeniusFinancialValidationContext(
    roundingPolicy: GeniusRoundingPolicy.strict(),
  ),
);

// Relative tolerance — useful for large multi-line documents
final relaxedResult = await TaxInvoiceTemplate(
  config: config,
  company: company,
  data: invoiceData,
).generate(
  validationContext: GeniusFinancialValidationContext(
    roundingPolicy: GeniusRoundingPolicy.withRelative(0.001), // 0.1%
  ),
);
```

---

## Using GeniusMoney for Safe Arithmetic

Use `GeniusMoney` directly when computing amounts in your application before passing them to templates:

```dart
final policy = GeniusRoundingPolicy.defaults();

// Build each named field separately — rounding once per field
final subtotal = GeniusMoney.fromDouble(1000.00, currency: 'SAR', policy: policy);
final discount = subtotal.multiplyByRate(0.10, policy: policy); // 100.00 SAR
final vatBase  = subtotal - discount;                           // 900.00 SAR (exact)
final vat      = vatBase.multiplyByRate(0.15, policy: policy);  // 135.00 SAR
final grand    = vatBase + vat;                                 // 1035.00 SAR (exact)

// Pass the rounded doubles to your template data model
final invoiceData = InvoiceData(
  items: [
    InvoiceLineItem(
      itemNumber: 1,
      description: 'Product',
      quantity: 1,
      unitPrice: subtotal.toDouble(),
    ),
  ],
  taxes: [InvoiceTax(name: 'VAT', rate: 15)],
  // ... other fields
);
```

---

## Standalone Validation

Validate without generating a PDF — useful for pre-flight checks in your UI:

```dart
final validator = GeniusFinancialValidator(GeniusRoundingPolicy.defaults());

// Check if subtotal is consistent with line items
final result = validator.validateSubtotal(
  lineTotals: [500.00, 300.00, 200.00],
  providedSubtotal: 1000.00,
);

if (!result.isValid) {
  for (final e in result.errors) {
    showError(e.message); // or e.messageAr for Arabic UI
  }
}

// Check VAT (post-discount base)
final vatResult = validator.validateVat(
  vatBase: 900.00,    // subtotal − discounts
  vatRate: 15.0,      // percent
  providedVatAmount: 135.00,
);

// Check debit/credit balance
final acctResult = validator.validateAccountingEntries(
  debits:  [5000.00, 3000.00],
  credits: [8000.00],
);
```

---

## Multi-Currency Documents

For remittance vouchers with source and target currencies:

```dart
final result = await RemittanceOutgoingVoucher(
  config: config,
  company: company,
  data: voucherData, // source: 500 USD, target: 1875 SAR, rate: 3.75
).generate(
  validationContext: GeniusFinancialValidationContext(
    roundingPolicy: GeniusRoundingPolicy.forCurrency('SAR'),
    sourceCurrencyPolicy: GeniusRoundingPolicy.forCurrency('USD'),
    documentCurrency: 'SAR',
  ),
);
// Stage 1: validates USD line items sum to USD subtotal
// Stage 2: validates USD subtotal × 3.75 ≈ 1875.00 SAR
```
