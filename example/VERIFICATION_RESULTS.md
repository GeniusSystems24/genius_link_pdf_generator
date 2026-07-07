# Example Verification Results

Date: 2026-07-07

## Static structural checks

- Dart files inspected: **99**
- Local import/export/part relationships inspected: **170**
- Missing local imports or exports: **0**
- Import/export cycles: **0**
- Feature pages: **17**
- Controllers: **7**
- Test files: **5**
- Export-only legacy directories: **0**
- Remaining top-level compatibility export files: **2**

## Legacy directory removal

The following export-only directories were removed:

- `lib/src/core/financial/`
- `lib/src/widgets/`
- `example/lib/data/`
- `example/lib/documents/`
- `example/lib/screens/`
- `example/lib/theme/`
- `example/lib/widgets/`

Package exports and internal imports now point directly to the canonical domain,
presentation, feature-first, `app`, or `shared` paths. The example architecture
test fails if the removed example directories are reintroduced.

## Architecture checks

- Presentation imports of `path_provider`, `open_file`, or `dart:io`: **0**
- Controller imports of platform plugins: **0**
- Feature/app/shared imports of `main.dart`: **0**
- Shared application contracts importing Flutter or platform plugins: **0**
- Dashboard domain model importing Flutter: **0**

## SDK limitation

`flutter analyze` and `flutter test` could not be executed in the artifact
environment because Flutter and Dart SDK executables are unavailable. Run:

```bash
flutter pub get
flutter analyze
flutter test

cd example
flutter pub get
flutter analyze
flutter test
```
