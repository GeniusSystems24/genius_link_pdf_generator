import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DocumentBuilder owns and exposes S01 directionality', () {
    final source = File(
      'lib/src/builders/pdf_document_builder/document_builder.dart',
    ).readAsStringSync();
    expect(source, contains('GeniusPdfDirectionality? directionality'));
    expect(source, contains('final GeniusPdfDirectionality _directionality;'));
    expect(source, contains('GeniusPdfDirectionality get directionality'));
    expect(source, contains('directionalityForComponent'));
    expect(source, contains('directionalityForElement'));
    expect(source, contains('withDirectionality<T>'));
  });

  test('ReportComposer forwards directionality and custom overrides', () {
    final source = File(
      'lib/src/builders/pdf_document_builder/report_composer.dart',
    ).readAsStringSync();
    expect(source, contains('GeniusPdfDirectionality? directionality'));
    expect(source, contains('super(config, directionality: directionality)'));
    expect(source, contains('customDirectional'));
  });

  test('TemplateContext preserves directionality in nested loops', () {
    final source = File(
      'lib/templates/engine/template_models.dart',
    ).readAsStringSync();
    expect(source, contains('final GeniusPdfDirectionality directionality;'));
    expect(source, contains('directionality: directionality'));
  });

  test('S01-owned files do not read Flutter locale directly', () {
    const paths = <String>[
      'lib/src/core/directionality.dart',
      'lib/src/builders/pdf_document_builder/document_builder.dart',
      'lib/src/builders/pdf_document_builder/report_composer.dart',
      'lib/templates/engine/template_definition.dart',
      'lib/templates/engine/template_models.dart',
      'lib/templates/engine/pdf_template_engine.dart',
    ];
    const forbidden = <String>[
      'Localizations.localeOf',
      'Directionality.of',
      'PlatformDispatcher.instance.locale',
      'WidgetsBinding.instance.platformDispatcher.locale',
    ];
    for (final path in paths) {
      final source = File(path).readAsStringSync();
      for (final token in forbidden) {
        expect(source, isNot(contains(token)), reason: '$path contains $token');
      }
    }
  });
}
