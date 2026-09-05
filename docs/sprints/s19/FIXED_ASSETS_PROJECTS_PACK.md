
# S19 — Fixed Assets & Projects Pack

Version: **4.0.0**

S19 completes the Fixed Assets and Projects slice of the Advanced ERP
milestone. It depends on S18 and composes the existing ERP families, S11 label
profiles and the shared ERP report/DataGrid renderer.

## Fixed assets

Public outputs:

- `GeniusAssetCardDocument`
- `GeniusAssetRegisterDocument`
- `GeniusAssetLabelDocument`
- `GeniusAssetTransferDocument`
- `GeniusAssetAssignmentDocument`
- `GeniusAssetReturnDocument`
- `GeniusAssetDisposalDocument`
- `GeniusAssetDepreciationReportDocument`
- `GeniusAssetMaintenanceReportDocument`
- `GeniusAssetCountDocument`
- `GeniusAssetMovementReportDocument`

`GeniusFixedAsset` keeps localized names independent from structured
`assetTag`/`serialNumber` values. Labels are mapped to `GeniusPdfLabelData` and
rendered by the S11 `GeniusPdfLabelPrintDocument`.

`GeniusAssetLabelProfiles` provides a durable single tag and a compact A4
sheet profile without duplicating label geometry logic.

## Depreciation

`GeniusAssetsProjectsService.calculateDepreciation()` owns depreciation
arithmetic. Rendering classes never calculate book values.

Supported policies:

- straight-line;
- declining-balance with configurable annual rate;
- residual-value floor;
- useful-life month cap;
- pre-service-date zero depreciation.

The reconciliation contract is:

```text
acquisition cost = accumulated depreciation + net book value
```

`GeniusAssetDepreciationResult.reconciles` verifies the result within currency
rounding tolerance.

## Projects

Public outputs:

- Project Summary
- Project Budget
- Project Cost
- Project Profitability
- Project Timesheet
- Project Expense Report
- Milestone Report
- Progress Report
- Completion Certificate
- Project Billing
- Resource Utilization
- Project Purchasing Report
- Multi-period Project Financials

The project code is always a structured value. Arabic/English project names do
not replace or reverse codes.

`projectFinancialsByPeriod()` reconciles Budget, Cost and Billing into
`GeniusProjectFinancialPeriod` values with Profit and Budget Variance before
PDF rendering.

## QA

The sprint includes automated domain/source tests and a semantic QA matrix for:

- asset serial/tag BiDi;
- label profiles;
- depreciation reconciliation;
- multi-period project financials;
- long milestone notes;
- Arabic/English project codes;
- long/multi-page register/report data;
- LTR/RTL verification.

The S19 Dashboard screen exposes every S19 document family, LTR/RTL, short and
large row counts, label profiles, depreciation and project financial scenarios.
