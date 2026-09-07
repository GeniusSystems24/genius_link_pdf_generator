# `GeniusPdfSignatureSection`

Create a reusable and highly customizable PDF component named `GeniusPdfSignatureSection`.

The component represents the signatures/approvals area of a PDF document.

It must be generic and reusable for approval, verification, acknowledgment, authorization, receipt, preparation, review, and similar workflows.

The section contains multiple `GeniusPdfSignatureBlock` items.

## Typical roles

Examples include:

- Prepared By
- Reviewed By
- Approved By
- Accountant
- Finance Manager
- Storekeeper
- Customer
- Receiver
- Authorized Signature

Do not hardcode these values into the component.

## Configurable columns

The layout must support a configurable number of signature blocks per row.

Examples:

- 1 signature per row
- 2 signatures per row
- 3 signatures per row
- 4 signatures per row
- Any reasonable configurable number

For example:

```dart
GeniusPdfSignatureSection(
  columns: 3,
  signatures: [
    GeniusPdfSignatureBlock(...),
    GeniusPdfSignatureBlock(...),
    GeniusPdfSignatureBlock(...),
    GeniusPdfSignatureBlock(...),
    GeniusPdfSignatureBlock(...),
  ],
)
```

With `columns: 3`, the expected layout is conceptually:

```text
[ Signature 1 ] [ Signature 2 ] [ Signature 3 ]

[ Signature 4 ] [ Signature 5 ]
```

When the number of signatures exceeds the configured columns, automatically continue on the next row.

Distribute the available horizontal width consistently.

Support RTL and LTR layout behavior.

## Page repetition

Add a configurable page repetition/placement option.

Support:

```dart
enum PdfSignatureRepeatMode {
  lastPageOnly,
  everyPage,
}
```

Behavior:

- `lastPageOnly`: render `GeniusPdfSignatureSection` only on the final page.
- `everyPage`: render `GeniusPdfSignatureSection` on every page.

Prefer:

```dart
PdfSignatureRepeatMode.lastPageOnly
```

as the default.

Example:

```dart
GeniusPdfSignatureSection(
  columns: 3,
  repeatMode: PdfSignatureRepeatMode.lastPageOnly,
  signatures: [
    GeniusPdfSignatureBlock(...),
    GeniusPdfSignatureBlock(...),
    GeniusPdfSignatureBlock(...),
  ],
)
```

The PDF layout system must determine the final generated page automatically.

Do not require the caller to manually calculate the total page count or final page index.

## Page-break behavior

When `lastPageOnly` is used:

- Keep the signature section together whenever possible.
- Avoid splitting individual signature blocks in undesirable ways.
- If insufficient vertical space remains on the final content page, move the signature section to the next page.
- The page-placement logic must continue to work correctly when document content causes automatic page breaks.

When `everyPage` is used:

- Preserve consistent section dimensions and spacing across pages.

## Styling

Allow customization of:

- Number of columns
- Horizontal spacing
- Vertical spacing
- Section padding
- Alignment
- Borders
- Background
- Minimum signature-block width
- Row spacing

## API and architecture requirements

- The public component name must be `GeniusPdfSignatureSection`.
- Its items must use `GeniusPdfSignatureBlock`.
- Keep required parameters to the minimum actually necessary.
- Prefer sensible defaults.
- Avoid hardcoded approval terminology.
- Support localization.
- Support RTL and LTR.
- Keep page-placement logic reusable and centralized.
- Do not duplicate `lastPageOnly` / `everyPage` page checks across every PDF template.
- Separate section data, layout configuration, page-placement logic, and rendering concerns where appropriate.
- Follow the architecture and coding conventions already used by the project.
- Add Flutter/Dart documentation comments for all public APIs according to Flutter documentation conventions.

The exact API may be improved if there is a cleaner implementation.
