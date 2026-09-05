
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('S25 authoring stays above Template Engine vNext', () {
    final source = File(
      'lib/src/template_designer/designer_models.dart',
    ).readAsStringSync();

    expect(source, contains('GeniusPdfTemplateSchema'));
    expect(source, contains('GeniusPdfTemplateElement'));
    for (final forbidden in [
      'syncfusion_flutter_pdf',
      'PdfGraphics',
      'PdfPage',
    ]) {
      expect(source, isNot(contains(forbidden)));
    }
  });

  test('S25 includes planned authoring metadata', () {
    final source = File(
      'lib/src/template_designer/designer_authoring.dart',
    ).readAsStringSync();

    for (final marker in [
      'moveElement(',
      'updateElement(',
      'addSubTemplate(',
      'setNamedComponent(',
      'setStyle(',
      'validate(',
    ]) {
      expect(source, contains(marker), reason: marker);
    }
  });
}
