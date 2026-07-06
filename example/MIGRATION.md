# Example Import Migration

No immediate migration is required. The previous example imports remain
available through compatibility exports.

## Preferred imports

```dart
import 'package:genius_pdf_example/features/components/presentation/pages/components_demo_screen.dart';
import 'package:genius_pdf_example/features/printing/presentation/pages/printing_demo_screen.dart';
import 'package:genius_pdf_example/features/sharing/presentation/pages/sharing_demo_screen.dart';
```

## Existing imports still supported

```dart
import 'package:genius_pdf_example/screens/components_demo_screen.dart';
import 'package:genius_pdf_example/screens/printing_demo_screen.dart';
import 'package:genius_pdf_example/screens/sharing_demo_screen.dart';
```

The root files `dashboard_home.dart`, `dashboard_layout.dart`,
`dashboard_sidebar.dart`, and the former `documents`, `widgets`, `theme`, and
`data` trees are also retained as compatibility exports.
