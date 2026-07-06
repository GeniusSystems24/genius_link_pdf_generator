# Example Architecture

The example application uses a feature-first structure with explicit MVC and
Clean Architecture boundaries while keeping the previous import paths working.

## Dependency direction

```text
Views -> Feature Controllers -> Package APIs / Application Contracts
                         Shared Contracts <- Infrastructure Adapters
App Bootstrap / Dependencies -> composes concrete implementations
```

The example consumes `genius_link_pdf_generator` as the product under
demonstration. Platform-specific file access is the only example-owned
infrastructure adapter.

## Structure

```text
lib/
├── main.dart
├── genius_pdf_example.dart
├── app/
│   ├── bootstrap/
│   ├── controllers/
│   ├── dependencies/
│   ├── presentation/
│   ├── routing/
│   └── theme/
├── features/
│   └── <feature>/
│       ├── domain/                 # When the feature has domain metadata
│       ├── models/documents/       # Demo document models/builders
│       └── presentation/
│           ├── controllers/
│           ├── models/
│           ├── pages/
│           └── widgets/
├── shared/
│   ├── application/contracts/
│   ├── infrastructure/platform/
│   ├── presentation/controllers/
│   └── presentation/widgets/
└── screens/, documents/, widgets/, theme/, data/
    └── Compatibility exports only
```

## MVC mapping

- **Model:** demo document builders, feature metadata, dashboard destinations,
  sample data and package-owned PDF models.
- **View:** Flutter pages and widgets under each feature's `presentation` tree.
- **Controller:** dashboard, theme, export, printing, sharing, job manager and
  document persistence controllers.

## Composition root

`ExampleBootstrap` creates the package configuration. `ExampleDependencies`
owns the shared runtime dependencies, including `DemoFileGateway` and
`DemoDocumentController`. Views do not instantiate `path_provider`,
`open_file`, or `dart:io` services.

## Compatibility

The original paths remain available as export shims. For example:

```dart
import 'package:genius_pdf_example/screens/printing_demo_screen.dart';
```

The preferred feature path is:

```dart
import 'package:genius_pdf_example/features/printing/presentation/pages/printing_demo_screen.dart';
```
