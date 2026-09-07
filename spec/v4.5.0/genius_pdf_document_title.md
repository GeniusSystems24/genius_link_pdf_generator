# `GeniusPdfDocumentTitle`

Create a reusable and highly customizable PDF component named `GeniusPdfDocumentTitle`.

The component is responsible for displaying the document title and related title metadata.

It must be generic and reusable across invoices, reports, account statements, vouchers, receipts, and other PDF documents.

## Typical titles

Examples include:

- Account Report
- Account Statement
- Sales Invoice
- Purchase Invoice
- Trial Balance
- Inventory Report
- Payment Voucher
- Receipt Voucher

Do not couple the component to any specific document type.

## Supported content

Support:

- Main title
- Optional subtitle
- Optional description
- Optional document number or reference
- Optional date or period information

Do not render empty placeholders or reserve unnecessary space for missing optional values.

## Horizontal position

Add a configurable logical horizontal position within the available row.

Support:

```dart
enum PdfDocumentTitlePosition {
  start,
  center,
  end,
}
```

Behavior:

- `start`: place the title block at the beginning of the available row.
- `center`: place the title block in the center of the available row.
- `end`: place the title block at the end of the available row.

Example:

```dart
GeniusPdfDocumentTitle(
  title: 'Account Statement',
  position: PdfDocumentTitlePosition.start,
)
```

```dart
GeniusPdfDocumentTitle(
  title: 'Account Statement',
  position: PdfDocumentTitlePosition.center,
)
```

```dart
GeniusPdfDocumentTitle(
  title: 'Account Statement',
  position: PdfDocumentTitlePosition.end,
)
```

The positioning must be direction-aware.

For LTR:

- `start` → left
- `center` → center
- `end` → right

For RTL:

- `start` → right
- `center` → center
- `end` → left

Do not implement `start` and `end` as fixed `left` and `right` values.

Prefer:

```dart
PdfDocumentTitlePosition.center
```

as the default.

The title block should occupy only the width required by its content unless an explicit width or expansion behavior is requested.

## Page repetition

Add a configurable page repetition option.

Support:

```dart
enum PdfTitleRepeatMode {
  firstPageOnly,
  everyPage,
}
```

Behavior:

- `firstPageOnly`: render `GeniusPdfDocumentTitle` only on the first page.
- `everyPage`: render `GeniusPdfDocumentTitle` on every page.

Prefer:

```dart
PdfTitleRepeatMode.firstPageOnly
```

as the default.

Example:

```dart
GeniusPdfDocumentTitle(
  title: 'Account Statement',
  position: PdfDocumentTitlePosition.center,
  repeatMode: PdfTitleRepeatMode.firstPageOnly,
)
```

The repetition behavior must be handled by the reusable PDF page-layout mechanism rather than requiring callers to duplicate page-index checks.

## Layout and styling

Allow customization of:

- Position
- Typography
- Padding
- Spacing
- Borders
- Background
- Width
- Alignment
- RTL/LTR behavior

## API and architecture requirements

- The public component name must be `GeniusPdfDocumentTitle`.
- Keep required parameters to the minimum actually necessary.
- Prefer optional parameters with sensible defaults.
- Avoid hardcoded text and business terminology.
- Support localization.
- Support RTL and LTR.
- Use logical `start` and `end` concepts instead of fixed `left` and `right`.
- Separate data, styling/configuration, page-repetition logic, and rendering concerns where appropriate.
- Ensure repeated titles preserve consistent layout across pages.
- Ensure repetition works correctly with automatic page breaks.
- Follow the existing architecture and coding conventions of the project.
- Add Flutter/Dart documentation comments for all public APIs according to Flutter documentation conventions.

The exact API may be improved if a cleaner implementation is possible.
