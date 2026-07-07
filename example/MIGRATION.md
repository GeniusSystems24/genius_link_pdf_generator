# Example Import Migration

The export-only legacy folders were removed. Update imports to their canonical
feature-first or shared paths.

## Screen imports

```dart
import 'package:genius_pdf_example/features/components/presentation/pages/components_demo_screen.dart';
import 'package:genius_pdf_example/features/printing/presentation/pages/printing_demo_screen.dart';
import 'package:genius_pdf_example/features/sharing/presentation/pages/sharing_demo_screen.dart';
```

## Other canonical roots

- Documents: `features/<feature>/models/documents/`
- Shared widgets: `shared/presentation/widgets/`
- Dashboard widgets: `features/dashboard/presentation/widgets/`
- Theme: `app/theme/`
- Sample data: `shared/data/`

Imports under `screens/`, `documents/`, `widgets/`, `theme/`, and `data/` are no
longer available.
