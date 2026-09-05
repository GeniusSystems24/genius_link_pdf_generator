
# S11 — Print Profiles, Thermal & Labels Foundation

Version: **4.0.0**

S11 adds a concrete print-profile layer for ERP output beyond A4.

## GeniusPdfPrintProfile

Built-in factories:

```dart
GeniusPdfPrintProfile.a4Portrait();
GeniusPdfPrintProfile.a4Landscape();
GeniusPdfPrintProfile.a5();
GeniusPdfPrintProfile.letter();
GeniusPdfPrintProfile.legal();
GeniusPdfPrintProfile.thermal58();
GeniusPdfPrintProfile.thermal80();
GeniusPdfPrintProfile.continuous(
  width: 226,
  nominalHeight: 1200,
);
GeniusPdfPrintProfile.customLabel(
  width: 200,
  height: 100,
);
GeniusPdfPrintProfile.labelSheet(
  columns: 3,
  rows: 8,
  labelWidth: 180,
  labelHeight: 80,
);
GeniusPdfPrintProfile.prePrinted();
```

A profile owns page size, margins, safe area, density, font scale,
header/footer policy, cut spacing, label gaps, copies/original-copy metadata,
bleed and calibration.

`apply(config)` creates a new `GeniusPdfConfig`; it does not mutate the source
config.

`toFamilyProfile()` connects the concrete S11 profile to S08's generic
`GeniusErpPrintProfile` hook.

## Thermal receipts

`GeniusPdfThermalReceiptEngine` supports:

- 58mm and 80mm widths;
- variable page height estimated from content;
- compact typography/minimal margins;
- item lines;
- receipt totals;
- payment/cash lines;
- QR and Code128 placement;
- RTL labels with independent LTR money/date/identifier runs;
- cut spacing.

```dart
final receipt = GeniusPdfThermalReceiptEngine(
  config: config,
  profile: GeniusPdfPrintProfile.thermal58(),
  data: GeniusPdfThermalReceiptData(
    merchantName: 'Store',
    merchantNameAr: 'المتجر',
    receiptNumber: 'POS-0001',
    date: DateTime.now(),
    items: [
      GeniusPdfThermalLineItem(
        description: 'Tea',
        descriptionAr: 'شاي',
        quantity: 2,
        unitPrice: 5,
      ),
    ],
    payments: const [
      GeniusPdfThermalPaymentLine(
        label: 'Cash',
        labelAr: 'نقداً',
        amount: 10,
      ),
    ],
  ),
);
```

## Labels

`GeniusPdfLabelPrintDocument` renders either a single custom label or a sheet.

Supported semantic fields include:

- product title;
- SKU;
- batch;
- serial;
- expiry;
- custom structured fields;
- Code128 barcode;
- QR.

Sheet rows/columns and calibration are physical and deterministic. RTL changes
caption/text direction inside a label, not printer calibration geometry.

## Pre-printed forms

Physical placement is **explicit opt-in**:

```dart
final profile = GeniusPdfPrintProfile.prePrinted();

final form = GeniusPdfPreprintedFormDocument(
  config: config,
  profile: profile,
  fields: const [
    GeniusPdfPreprintedField(
      id: 'document-number',
      value: 'INV-2026-0001',
      structuredValue: true,
      anchor: GeniusPdfPreprintedFieldAnchor(
        x: 390,
        y: 85,
        width: 150,
        height: 20,
      ),
    ),
  ],
);
```

In this mode x/y are physical coordinates and are never mirrored in RTL.
Only text direction inside the anchor changes. Structured values remain LTR.

## Calibration

Use `GeniusPdfCalibrationTestDocument`, print at **100% / Actual Size**, measure
the cross/grid drift, then set:

```dart
GeniusPdfPrintCalibration(
  offset: GeniusPdfPrintOffset(dx: 1.5, dy: -2),
  scaleX: 1.001,
  scaleY: 0.999,
);
```

The Dashboard page **S11 Print Profiles** provides A4/A5/Letter/Legal,
58/80mm, continuous, single/sheet label, pre-printed and calibration scenarios.
