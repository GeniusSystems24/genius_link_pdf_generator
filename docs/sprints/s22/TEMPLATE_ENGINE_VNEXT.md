
# S22 — Template Engine vNext, Schema Versioning & Registry

Version: **4.0.0**

S22 starts the Enterprise milestone with a safe, versioned and
renderer-independent template definition system.

## Schema and migration

`GeniusPdfTemplateSchema` has an explicit `schemaVersion`; current schema is
version 2. Maps without a schema version are treated as v1 and migrated by
`GeniusPdfTemplateSchemaMigrator`. Existing template classes are not removed or
rewritten; `GeniusPdfLegacyTemplateAdapter` converts current map definitions
into vNext.

Validation returns path/code/message issues and rejects unknown elements,
duplicate IDs, invalid effective ranges and non-JSON/renderer objects.

## Elements

The serialized schema supports Component, Section, PageBreak, Barcode, QRCode,
Signature, Summary, Metric, Chart, Attachment, Stamp, Label, Group and
SubTemplate. Elements support visibility, bounded repeat paths, named styles,
direction override and independent value direction.

## Safe expressions

`GeniusPdfSafeExpressionEngine` is a restricted parser. It supports null-safe
nested map access, arithmetic, comparisons, boolean conditions, `??`,
aggregates, group aggregates, formatters and localization keys.

The engine has no eval/reflection/process APIs and rejects unknown function
names. Token, nesting and repeat limits protect large inputs.

## Composition and registry

Composition supports subtemplates, inheritance, named components, style
inheritance and logical document-family binding.

The registry exposes `TemplateId`, `TemplateVersion`, `TemplatePack`, Variant,
Locale, Country, Organization, Branch, EffectiveFrom/To, draft/published state,
fallback hierarchy, history, checksum and rollback.

Fallback specificity is:

```text
Branch > Organization > Country > Locale > Variant > generic
```

## Directionality

Schema direction, element overrides, component inheritance and nested
bilingual sections are explicit. Value direction is independent so structured
identifiers can remain LTR inside RTL templates.

## Security tests

Tests cover invalid expressions, schema migration, unknown elements, bounded
large loops and confirmation that serialized schema contains no renderer
objects.

The S22 Dashboard page resolves a real schema, safe expressions, direction and
registry selection and previews the resolved result with the public
diagnostics document.
