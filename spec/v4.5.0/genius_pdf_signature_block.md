# `GeniusPdfSignatureBlock`

Create a reusable and highly customizable PDF component named `GeniusPdfSignatureBlock`.

The component represents one individual signature, approval, acknowledgment, or authorization entry inside `GeniusPdfSignatureSection`.

It must remain generic and must not be coupled to a specific business workflow.

## Basic structure

The typical structure is:

1. Position / role
2. Person name
3. Signature area

Example:

```text
Finance Manager
Mohammed Ahmed
________________________
```

The person name must be optional.

When the name is not available, support a blank writable/signature line:

```text
Finance Manager
________________________
```

The line represents an area where the name or signature may be written manually after printing.

## Supported optional values

Support optional values such as:

- Role / position
- Person name
- Signature label
- Signature line
- Date
- Stamp area
- Additional text

Do not require all fields.

Do not render empty placeholders or reserve space for values that are not provided unless explicitly configured.

## Signature-line behavior

Allow customization of:

- Whether the signature line is shown
- Signature line width
- Signature line thickness
- Signature line style
- Space above/below the line
- Whether the name is displayed above or below the line

When the name is absent, the component should be able to display the configurable line as the writable name/signature area.

## Styling and layout

Allow customization of:

- Text styles
- Alignment
- Vertical spacing
- Horizontal spacing
- Minimum block width
- Padding
- Borders
- Background
- Role style
- Name style
- Date style
- Additional text style
- Stamp-area dimensions

Support RTL and LTR layouts.

Use logical alignment concepts where appropriate.

## Integration

`GeniusPdfSignatureBlock` must be designed to work cleanly inside:

```dart
GeniusPdfSignatureSection(
  columns: 3,
  signatures: [
    GeniusPdfSignatureBlock(
      role: 'Prepared By',
      name: 'Ahmed Ali',
    ),
    GeniusPdfSignatureBlock(
      role: 'Reviewed By',
    ),
    GeniusPdfSignatureBlock(
      role: 'Approved By',
      name: 'Mohammed Ahmed',
    ),
  ],
)
```

The block must adapt to the width assigned to it by `GeniusPdfSignatureSection`.

It should not contain page-placement or repetition logic itself; that responsibility belongs to `GeniusPdfSignatureSection`.

## API and architecture requirements

- The public component name must be `GeniusPdfSignatureBlock`.
- Keep required parameters to the minimum actually necessary.
- Prefer optional parameters with sensible defaults.
- Avoid hardcoded text.
- Avoid hardcoded business terminology.
- Support localization.
- Support RTL and LTR.
- Separate data, style/configuration, and rendering concerns where useful.
- Keep the component reusable independently of specific invoice/report templates.
- Follow the existing PDF architecture and coding conventions of the project.
- Add Flutter/Dart documentation comments for all public classes, constructors, fields, enums, and important methods according to Flutter documentation conventions.

The exact API may be improved if a cleaner design is possible.
