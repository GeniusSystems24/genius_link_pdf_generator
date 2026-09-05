
# S23 — Compliance, Signing, Audit & Archival Profiles

Version: **4.0.0**

S23 adds enterprise integration contracts without embedding jurisdiction law,
private keys, HSM behavior or archival claims in base templates.

## Compliance abstraction

`GeniusPdfComplianceProfile` provides country/tenant plugin contracts,
required-field validation hooks, structured QR-payload hooks and
original/copy/reprint policy.

Every jurisdiction profile has its own version, effective dates and explicit
`sourceReferences`. Legal/regulatory requirements must be reviewed against
official sources when a country plugin is implemented or updated.

The base package intentionally contains **no hard-coded country law**.

## Approval, signing and integrity

Business approval and cryptographic signing are separate models:

- `GeniusPdfBusinessApproval`
- `GeniusPdfSigningMetadata`

External integrations implement:

- `GeniusPdfCertificateSignatureProvider`
- `GeniusPdfTimestampProvider`
- `GeniusPdfDocumentHashProvider`
- `GeniusPdfFingerprintProvider`

The package does not manufacture a fake cryptographic hash/signature when no
provider exists.

## Archive and audit metadata

S23 adds XMP abstraction, embedded-attachment hooks, archive capability flags,
source transaction/audit metadata and document generation timestamp/version.
`GeniusPdfEnterpriseDocumentMetadata` combines these values without requiring
one specific archival standard.

## Existing security

`GeniusPdfEnterpriseSecurityPolicy` is a higher-level adapter over the existing
`GeniusPdfSecuritySettings` and delegates execution to
`GeniusPdfSecurityService`. The current password/encryption/permissions service
is preserved.

## QA

Tests cover protected/unprotected policy mapping, compliance profile
resolution, copy/reprint rules, business-approval/signature separation,
archive capabilities, version/effective dates and source references.

The S23 Dashboard verification page uses the public compliance APIs and a real
PDF diagnostics document for LTR/RTL, validation, copy and reprint scenarios.
