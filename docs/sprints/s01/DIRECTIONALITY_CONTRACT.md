
# Sprint S01 — Directionality Contract

Version: **4.0.0**

S01 introduces one package-owned source of truth for direction and logical
horizontal geometry.

## Precedence

Direction is resolved in this exact order:

```text
element > component > template > document > locale > fallback
```

`GeniusPdfDirection.auto` means inherit. The default fallback is LTR.

## Independent concerns

The architecture treats these as separate concerns:

- layout direction;
- text/run direction;
- text alignment;
- value direction;
- logical geometry;
- media mirroring.

A component must not infer all of them from one `isRTL` flag.

## ERP value policy

The default `GeniusPdfValueDirectionPolicy.erp()` keeps these runs LTR inside
RTL documents:

- numbers, money, percentages and quantities;
- dates and times;
- document numbers, SKUs, serials, batches, IBAN, SWIFT and tax IDs;
- phone numbers, email addresses and URLs.

Plain prose inherits the resolved direction. Every run can be overridden.

The policy never reverses strings and never modifies the stored text.

## Logical geometry

New layout APIs use:

- `GeniusPdfLogicalAlignment.start/end/center`;
- `GeniusPdfDirectionalInsets(start/end/top/bottom)`;
- `GeniusPdfLogicalPosition.leading/trailing`.

Physical `left/right` values are produced only by
`GeniusPdfLogicalGeometry` at the renderer boundary.

## Media

`GeniusPdfMediaMirroringPolicy.preserve` is the default. RTL does not mirror
images, signature images, QR graphics or barcode graphics.

## Propagation

`GeniusPdfDocumentBuilder` now owns a `GeniusPdfDirectionality` context.
`GeniusPdfReportComposer` accepts the same context and provides
`customDirectional()` for custom blocks.

The template engine supports package-owned direction values while preserving
legacy JSON that omits direction fields.

## S01 boundary

S01 does not migrate Summary, InfoBox, ReportHeader, RichText or DataGrid.
Those production components are migrated to this contract in S02.
