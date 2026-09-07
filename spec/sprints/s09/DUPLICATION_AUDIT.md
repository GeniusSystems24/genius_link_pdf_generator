# S09 Duplication Audit

Version: **4.0.0**

**Baseline captured before first S09 migration.**

This report measures the three template source files immediately before the
script replaces their local rendering implementations, then compares them with
the migrated source emitted by this script.

The metric is intentionally simple and reproducible. It is not a semantic
clone detector; it counts the most relevant local duplication markers.

| Template | Lines before | Lines after | `_draw*` before | `_draw*` after | `_format*` before | `_format*` after |
|---|---:|---:|---:|---:|---:|---:|
| QuotationTemplate | 636 | 433 | 10 | 0 | 3 | 0 |
| PurchaseOrderTemplate | 672 | 490 | 9 | 0 | 2 | 0 |
| TaxInvoiceTemplate | 916 | 419 | 13 | 0 | 2 | 0 |

## Aggregate markers

- `lines`: **2224 → 1342**
- `private_draw_helpers`: **32 → 0**
- `local_format_helpers`: **7 → 0**
- `local_number_to_words_helpers`: **4 → 0**
- `direct_grid_constructions`: **3 → 0**
- `direct_info_box_constructions`: **6 → 0**
- `direct_summary_constructions`: **3 → 0**

## Result

After S09:

- all three template classes extend `GeniusErpTransactionDocument`;
- template files no longer construct `GeniusPdfDataGrid`,
  `GeniusPdfInfoBox`, or `GeniusPdfSummarySection` directly;
- aggregate calculations are delegated to S06 adapters/service;
- shared company/currency/address mapping and amount-in-words compatibility
  live outside individual template renderers;
- line-level compatibility getters remain only where public source behavior
  requires them.

The family implementation intentionally owns the shared rendering construction
once; therefore some complexity moved from the three templates into
`lib/src/presentation/document/families/erp/family_document.dart` instead of being deleted.
