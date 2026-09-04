
# S07 Composition Do / Don't

## Do

```dart
final components = GeniusPdfErpComponentGroup(
  components: [
    GeniusPdfDocumentIdentity(
      config: config,
      data: context.identity,
    ),
    GeniusPdfPartyBlock(
      config: config,
      party: context.recipient,
    ),
    GeniusPdfTaxSummary(
      config: config,
      result: calculation,
    ),
    GeniusPdfTermsSection(
      config: config,
      text: context.terms,
      textAr: arabicTerms,
    ),
  ],
);
```

- feed components S06 domain objects;
- feed financial components an `ErpCalculationResult`;
- use `config.formatter`;
- use logical start/end;
- keep identifiers/money/contact values direction-independent from prose;
- let null components collapse.

## Don't

```dart
// Don't rebuild the same party/tax/terms layout in every template.
addLine('Customer: ${customer.name}');
addLine('VAT: ${tax.toStringAsFixed(2)}');
addLine('Terms: $terms');
```

Do not:

- recalculate taxes in a PDF component;
- reverse Arabic/Latin strings manually;
- add placeholder/dummy tax/contact/payment values just to keep layout stable;
- add padding before testing whether an optional section is visible;
- expose physical left/right as new semantic component configuration;
- duplicate identity/party/address/tax/terms blocks in Quotation/PO/Invoice.
