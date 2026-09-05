
# S25 — Visual Template Designer Model & Authoring Layer

Version: **4.0.0**

S25 builds designer state directly on Template Engine vNext instead of adding a
parallel layout format.

## Designer model

- document state over `GeniusPdfTemplateSchema`
- drag/drop component metadata
- property-panel schema
- style-editor schema
- binding metadata

## Preview

`GeniusPdfDesignerPreviewService` resolves sample data through the real S22
template engine. The state tracks EN/LTR, AR/RTL and bilingual preview modes,
page-profile selection, multi-page sample data and validation messages.

## Authoring

`GeniusPdfDesignerAuthoringController` supports section/table-like composition,
conditions, expressions, subtemplates, named components and inherited styles.
The authoring layer never stores renderer objects.

## Manual verification

The S25 Dashboard page edits a real schema, switches direction/page profile,
changes sample-data cardinality, validates the result and previews the resolved
template using the real diagnostics PDF document.
