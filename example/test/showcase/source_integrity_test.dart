import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final lib = Directory('lib');

  test('showcase local package imports resolve to files', () {
    final missing = <String>[];
    const singlePrefix = "import 'package:genius_pdf_example/";
    const doublePrefix = 'import \"package:genius_pdf_example/';

    for (final file in _dartFiles(lib)) {
      final source = file.readAsStringSync();
      for (final rawLine in source.split('\n')) {
        final line = rawLine.trimLeft();
        String? relative;
        if (line.startsWith(singlePrefix)) {
          relative = line.substring(singlePrefix.length).split("'").first;
        } else if (line.startsWith(doublePrefix)) {
          relative = line.substring(doublePrefix.length).split('\"').first;
        }
        if (relative != null && !File('lib/$relative').existsSync()) {
          missing.add('${file.path} -> package:genius_pdf_example/$relative');
        }
      }
    }

    expect(missing, isEmpty, reason: missing.join('\n'));
  });

  test('rebuilt lib does not depend on removed application architecture', () {
    const removedReferences = <String>[
      'DashboardController',
      'ThemeController',
      'DemoDocumentController',
      'DashboardDestinationRegistry',
      'CreateSaveOpenPdfButton',
      'ComponentPage',
      'demo_file_gateway.dart',
      'genius_pdf_example_app.dart',
    ];

    final violations = <String>[];
    for (final file in _dartFiles(lib)) {
      final source = file.readAsStringSync();
      for (final reference in removedReferences) {
        if (source.contains(reference)) {
          violations.add('${file.path}: $reference');
        }
      }
    }

    expect(violations, isEmpty, reason: violations.join('\n'));
  });

  test('feature source does not import main.dart', () {
    final violations = <String>[];
    for (final file in _dartFiles(Directory('lib/features'))) {
      final importsMain = file
          .readAsLinesSync()
          .map((line) => line.trimLeft())
          .any((line) => line.startsWith('import ') && line.contains('main.dart'));
      if (importsMain) {
        violations.add(file.path);
      }
    }
    expect(violations, isEmpty, reason: violations.join('\n'));
  });
}

Iterable<File> _dartFiles(Directory directory) sync* {
  if (!directory.existsSync()) return;
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is File && entity.path.endsWith('.dart')) {
      yield entity;
    }
  }
}
