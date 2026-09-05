
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S22 schema remains renderer independent', () {
    final files = [
      'lib/src/template_engine_vnext/template_schema.dart',
      'lib/src/template_engine_vnext/template_elements.dart',
      'lib/src/template_engine_vnext/template_registry.dart',
    ];
    for (final path in files) {
      final source = File(path).readAsStringSync();
      for (final forbidden in [
        'syncfusion_flutter_pdf',
        'PdfDocument',
        'PdfPage',
        'PdfGrid',
        'PdfBrush',
      ]) {
        expect(
          source,
          isNot(contains(forbidden)),
          reason: '$path -> $forbidden',
        );
      }
    }
  });

  test('safe engine contains no eval/reflection/code execution', () {
    final source = File(
      'lib/src/template_engine_vnext/safe_expression_engine.dart',
    ).readAsStringSync();

    for (final forbidden in [
      'dart:mirrors',
      'Function.apply',
      'eval(',
      'Process.run',
      'Isolate.spawnUri',
    ]) {
      expect(source, isNot(contains(forbidden)));
    }
    expect(source, contains(r'Function `$name` is not allowed.'));
  });
}
