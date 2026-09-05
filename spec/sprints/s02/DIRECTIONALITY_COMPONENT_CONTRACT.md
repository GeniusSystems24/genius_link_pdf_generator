
# S02 — Existing Components Directionality Contract

Version: **4.0.0**

S02 migrates existing components to the S01 directionality source of truth.

- `layoutDirection`, text direction and text alignment are independent.
- structured ERP values can remain LTR inside RTL.
- logical `start/end` and `leading/trailing` are used before physical drawing.
- strings are never reversed to implement RTL.
- images, QR and barcode payload/pixels are never mirrored by direction.
- every migrated component inherits `GeniusPdfDirectionality` and accepts an
  additive component override.
- physical/pre-printed order remains available through explicit preserve modes.

## Summary

Labels render at logical start and values at logical end. Structured amounts,
percentages and identifiers use LTR value direction. Long labels receive
wrapping-aware height and `hideEmptyValues` collapses optional empty rows.

## InfoBox

Key/value rows follow direction, header icons use logical leading/trailing,
multi-column order follows `followDirection`, and every
`GeniusPdfLabeledValue` can set an independent `valueDirection`.

## ReportHeader / two-column

Header block/logo/metadata placement follows direction. Document/reference/date
runs are LTR-isolated inside RTL labels. `addTwoColumns()` follows direction
and exposes `preservePhysicalOrder`.

## RichText

`GeniusPdfTextSpan.direction` is the package-owned run override. The old
`textDirectionOverride` remains valid for compatibility.

## DataGrid

S02 adds only directionality policy:
`followDirection`, `preserveDefinitionOrder`, `headerDirection`,
`contentDirection`, and `directionalPadding`. Numeric content defaults to LTR
with stable right alignment. Advanced S04 grid work is intentionally excluded.

## Signature / QR / Barcode / Watermark

Signature geometry follows direction; signature image pixels are untouched.
QR/barcode captions follow direction while graphics and payload remain
unchanged. Watermarks remain physically positioned by default; use
`GeniusPdfWatermark.directional(...)` for opt-in logical placement.
