
# S06 — ERP Shared Domain & Calculation Layer

Version: **4.0.0**

S06 adds a package-owned ERP domain layer under `lib/src/domain/erp`.

## Shared document context

`ErpDocumentContext` is shared by Quotation, Purchase Order, Invoice and future
families. `ErpDocumentIdentity.kind` carries the document type, avoiding
duplicated organization/party/identity/money/line models.

The context composes organization, optional branch, issuer/recipient,
billing/shipping addresses, references, lines, approvals, signatures,
attachments, print metadata, document/base currency and exchange rate.

Optional metadata stays null/empty; the domain creates no dummy render values.

## Money and currencies

`ErpMoney` stores integer minor units with an explicit `ErpCurrency`.
`ErpCurrency.precision` owns decimal precision.
`ErpRoundingStrategy` makes rounding deterministic.
`ErpExchangeRate` explicitly converts document currency to base currency.

## Transaction detail

`ErpLineItem` composes `ErpQuantity`, `ErpUnit`, price, discounts, charges,
taxes, batch information and serial information.

## Typed calculation

```dart
final result = const ErpCalculationService().calculate(
  ErpCalculationRequest.fromContext(
    context,
    documentDiscounts: [
      ErpDiscount.percentage(percentage: 10),
    ],
    config: const ErpCalculationConfig(
      documentDiscountTaxPolicy:
          ErpDocumentDiscountTaxPolicy.beforeTax,
    ),
  ),
);
```

The result contains subtotal, line/document discounts, charges, taxable amount,
grouped taxes, tax total, rounding adjustment, grand total, optional paid/due,
and optional base-currency values.

`beforeTax` reduces allocated line taxable bases. `afterTax` leaves tax bases
unchanged and applies the document discount after tax.

Multiple taxes are supported. `compound: true` makes a tax include previously
calculated taxes in its base.

`roundingIncrementMinorUnits` controls explicit final rounding; the difference
is exposed as `roundingAdjustment`.

## Validation

`ErpDomainValidator` checks input before calculation: currency consistency,
zero/negative quantity policy, adjustment validity, tax rates and exchange-rate
pairing. Invalid input throws `ErpDomainValidationException` from the
calculation service.

## Serialization

Serialization is intentionally isolated in `ErpDomainSerialization`.
Core domain/value classes do not implement `toJson`/`fromJson` automatically.
