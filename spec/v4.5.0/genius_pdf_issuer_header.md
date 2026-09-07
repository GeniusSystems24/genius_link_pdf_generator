# `GeniusPdfIssuerHeader`

Create a reusable and highly customizable PDF component named `GeniusPdfIssuerHeader`.

The component represents the header area that displays information about the organization, company, institution, branch, or other entity that issued the document.

It must be generic and reusable across different document types, including invoices, account statements, financial reports, vouchers, receipts, and administrative reports.

## Supported data

Support optional information such as:

- Logo
- Organization name
- Trade name
- Address
- Phone numbers
- Email
- Website
- Tax number
- Registration number
- Branch name
- Additional issuer information

All fields should be optional where appropriate.

Do not reserve empty space for values that are not provided.

## Page repetition

Add a configurable page repetition option.

Support at least:

```dart
enum PdfHeaderRepeatMode {
  firstPageOnly,
  everyPage,
}
```

Behavior:

- `firstPageOnly`: render `GeniusPdfIssuerHeader` only on the first page.
- `everyPage`: render `GeniusPdfIssuerHeader` on every page.

Prefer:

```dart
PdfHeaderRepeatMode.firstPageOnly
```

as the default.

Example:

```dart
GeniusPdfIssuerHeader(
  repeatMode: PdfHeaderRepeatMode.firstPageOnly,
)
```

The repetition behavior must be handled by the reusable PDF layout/page-generation system.

Do not require every PDF template to manually check the page index or duplicate the header implementation.

## Layout and styling

Allow customization of:

- Typography
- Spacing
- Padding
- Alignment
- Borders
- Background
- Logo dimensions
- Internal layout
- Width constraints

The component must:

- Support RTL and LTR layouts.
- Adapt correctly to small or large amounts of issuer information.
- Avoid unnecessary empty space.
- Remain suitable for professional business documents.
- Preserve consistent dimensions and spacing when repeated across pages.

## API and architecture requirements

- The public component name must be `GeniusPdfIssuerHeader`.
- Keep required parameters to the minimum actually necessary.
- Prefer optional parameters with sensible defaults.
- Avoid hardcoded business terminology.
- Support localization.
- Separate data, styling/configuration, repetition logic, and rendering concerns where appropriate.
- Follow the architecture and coding conventions already used by the existing PDF components and templates in the project.
- Add Flutter/Dart documentation comments for public classes, constructors, fields, enums, and important methods according to Flutter documentation conventions.

The exact API may be improved if there is a cleaner design, but it must remain simple and reusable.
