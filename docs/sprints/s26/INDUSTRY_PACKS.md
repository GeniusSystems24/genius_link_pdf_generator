
# S26 — Industry / Plugin Template Packs

Version: **4.0.0**

## Pack contract

`GeniusPdfIndustryPack` and `GeniusPdfIndustryPackManifest` define plugin
boundaries, template manifests, required domain extensions, optional compliance
hooks and semantic-version compatibility rules.

## Built-in industry extension packs

- Retail: promotional receipt/labels/shelf labels layered over the POS pack.
- Restaurant: KOT, table/order ticket, kitchen-section ticket and delivery
  receipt variants.
- Construction/Real Estate: progress certificate, BOQ/measurement report,
  property/unit/customer document and project-billing extension.
- Healthcare/Education: generic report shells only. Regulated models remain in
  external plugin namespaces and are not added to core.
- Automotive/Distribution/Hospitality: vehicle service, route/distribution and
  guest/folio variants that reuse service/logistics/transaction families.

## Compliance

The built-in shells do not hard-code jurisdiction law. Country/tenant
compliance profiles are supplied by external plugins through the S23 compliance
contracts.

## Manual verification

The S26 Dashboard page registers all built-in manifests, chooses industry
variants, resolves real S22 schemas and previews them with sample data.
