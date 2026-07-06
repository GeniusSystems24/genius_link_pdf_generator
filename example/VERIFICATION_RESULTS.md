# Example Verification Results

Date: 2026-07-06

## Static structural checks

- Dart files inspected: **167**
- Local import/export relationships inspected: **240**
- Missing local imports or exports: **0**
- Import/export cycles: **0**
- Feature pages: **17**
- Controllers: **7**
- Architecture and compatibility test files: **6**
- Compatibility export files: **75**
- Invalid compatibility files containing implementation logic: **0**

## Compatibility checks

- Original public declarations: **56**
- Current public declarations: **72**
- Missing original public declarations: **0**
- Existing dashboard destination identifiers retained.
- Legacy `screens`, `documents`, `widgets`, `theme`, and `data` imports retained
  through export shims.

## Architecture checks

- Presentation imports of `path_provider`, `open_file`, or `dart:io`: **0**
- Controller imports of platform plugins: **0**
- Feature/app/shared imports of `main.dart`: **0**
- Shared application contracts importing Flutter or platform plugins: **0**
- Dashboard domain model importing Flutter: **0**

## Syntax-oriented checks

- Balanced Dart delimiters across library and tests: passed.
- Controller members referenced by the refactored Views: all resolved by static
  source comparison.
- ZIP integrity: recorded after packaging.

## SDK limitation

`flutter analyze` and `flutter test` could not be executed in the artifact
environment because Flutter and Dart SDK executables are unavailable. The
commands to run in the consumer environment are:

```bash
cd example
flutter pub get
flutter analyze
flutter test
```
