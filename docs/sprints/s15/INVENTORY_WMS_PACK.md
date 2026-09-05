
# S15 — Inventory & WMS Pack

Version: **4.0.0**

S15 adds inventory/WMS movement, count, report, traceability and label outputs.

## Movement documents

- Stock Receipt
- Stock Issue
- Stock Transfer
- Warehouse Transfer
- Stock Adjustment

`GeniusInventoryMovementLine` contains transaction quantity/unit plus optional
base quantity/unit so multi-unit and fractional quantities remain explicit.

Movement lines also carry source/destination warehouse/location and
batch/serial/expiry metadata.

## Count documents

- Stock Count
- Cycle Count
- Count Variance/Reconciliation

Variance is `countedQuantity - systemQuantity` and is computed before rendering.

## Reports

- Item Card
- Stock Ledger
- Stock Valuation
- Stock Availability
- Reorder Report
- Min/Max Report
- Slow/Dead Stock
- Batch Report
- Serial Report
- Expiry Report

`GeniusInventoryService` owns movement signs, running balance, stock value,
available quantity, reorder/min-max predicates and stock-age classification.

## Traceability

`GeniusInventoryTraceabilityRecord` keeps item, batch, serial, expiry,
warehouse/location and optional quantity/unit in one typed record.

Arabic item names and Latin SKU/serial/batch identifiers remain separate
semantic values.

## Labels

S15 reuses S11 `GeniusPdfLabelPrintDocument`; there is no separate label
renderer.

Public wrappers:

- `GeniusInventoryItemLabelDocument`
- `GeniusShelfLabelDocument`
- `GeniusBatchLabelDocument`
- `GeniusSerialLabelDocument`
- `GeniusLocationLabelDocument`

They support custom S11 profiles/calibration.

## QA

The S15 semantic matrix covers multi-unit quantities, fractional quantities,
large item counts, long names, Arabic names with Latin SKU, and mixed
batch/serial/expiry values.

The Dashboard verification page provides LTR/RTL, 1/100/1000-row scenarios,
movement/report/label cases and actual PDF preview.
