# Genius Link PDF Generator Example

A feature-rich Flutter example for `genius_link_pdf_generator`, organized with
feature-first Clean Architecture and MVC.

## Run

```bash
flutter pub get
flutter run
```

## Validate

```bash
flutter analyze
flutter test
```

## Architecture

- `app`: bootstrap, dependency composition, theme and routing.
- `features`: feature-owned models, controllers, pages and widgets.
- `shared`: contracts, platform adapters and reusable UI.
- legacy folders: compatibility exports for existing imports.

See [ARCHITECTURE.md](ARCHITECTURE.md) and [MIGRATION.md](MIGRATION.md).
