
# S18 — Manufacturing & Quality Pack

Version: **4.0.0**

S18 begins the Advanced ERP milestone with Manufacturing and Quality documents
built on the existing ERP families and DataGrid.

## Manufacturing

Public outputs:

- Bill of Materials (BOM)
- Production Order
- Work Order
- Job Card
- Material Requirement
- Material Issue
- Material Return
- Production Receipt
- Routing / Traveler
- Machine Operation Report
- Labor Report
- Scrap Report
- Work in Progress
- Production Variance

`GeniusManufacturingMaterialNode` keeps real hierarchy through `level` and
`parentId`; indentation is presentation only.

`GeniusManufacturingOperation` and
`GeniusManufacturingMaterialRequirement` expose planned/actual hours,
material consumption and remaining requirement without embedding arithmetic
inside PDF drawing.

## Quality

Public outputs:

- Quality Inspection
- Incoming Inspection
- In-process Inspection
- Final Inspection
- Non-Conformance Report (NCR)
- Corrective/Preventive Action (CAPA)
- Certificate of Analysis (COA)
- Quality Checklist
- Audit Form
- Calibration Record

## Shared mechanics

S18 introduces reusable public primitives:

- `GeniusManufacturingNestedTableData`
- `GeniusManufacturingNestedTableSection`
- `GeniusQualityChecklistItem`
- `GeniusQualityStatus`
- `GeniusQualityMeasurement`
- `GeniusQualitySignOff`

Nested operation/material tables reuse `GeniusPdfDataGrid` group headers,
`keepWithNext` and `keepTogether`; no second table or page-flow engine is
introduced.

Measurements expose specification/value/tolerance/status. Pass/fail is
calculated from min/max tolerance unless explicitly overridden.

Batch/serial traceability reuses S06 `ErpBatchInfo` and `ErpSerialInfo`.

## Directionality

Arabic descriptions stay independent from Latin technical codes, item codes,
machine codes, batches and serials. Structured identifiers remain LTR inside
RTL documents through the shared grid directionality policy.

## QA

Tests and semantic matrices cover:

- multi-level BOM;
- long routing;
- mixed units;
- RTL technical terms with Latin codes;
- batch/serial traceability;
- pass/fail tolerance logic;
- nested operation/material tables;
- approval/sign-off;
- 500-item multi-page checklist preparation.

The S18 Dashboard verification page provides real PDF preview/generation for
Manufacturing and Quality scenarios.
