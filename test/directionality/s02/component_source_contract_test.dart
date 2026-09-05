
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  String source(String path) => File(path).readAsStringSync();

  test('Summary and InfoBox use logical geometry and value direction', () {
    final summary = source(
      'lib/src/components/widgets/summary/genius_pdf_summary_section.dart',
    );
    final info = source(
      'lib/src/components/widgets/pdf_info_box/info_box.dart',
    );
    expect(summary, contains('GeniusPdfComponentDirectionality.startX'));
    expect(summary, contains('GeniusPdfComponentDirectionality.endX'));
    expect(summary, contains('valuePdfDirection'));
    expect(summary, contains('hideEmptyValues'));
    // Summary rows use the PDF font metrics rather than a character-count
    // approximation, and preserve natural-height bounds for single-line text.
    expect(summary, contains('.measureString('));
    expect(summary, contains('labelHeight > valueHeight'));
    expect(summary, contains('rowHeight > singleLineHeight ? rowHeight : 0'));
    expect(summary, isNot(contains('value.runes.length * fontSize')));
    expect(info, contains('GeniusPdfLogicalPosition iconPosition'));
    expect(info, contains('followDirection'));
    expect(info, contains('item.valueDirection'));
  });

  test('Header, RichText and two-column contracts are direction-aware', () {
    final header = source(
      'lib/src/components/widgets/pdf_report_header/renderer.dart',
    );
    final rich = source(
      'lib/src/components/widgets/pdf_rich_text/renderer.dart',
    );
    final builder = source(
      'lib/src/builders/pdf_document_builder/document_builder.dart',
    );
    expect(header, contains('preservePhysicalOrder'));
    expect(header, contains('isolateLtr(documentNumber'));
    expect(rich, contains('switch (span.direction)'));
    expect(builder, contains('mirrorColumns'));
    expect(builder, contains('preservePhysicalOrder = false'));
  });

  test('DataGrid S02 scope is directionality only', () {
    final grid = source(
      'lib/src/components/widgets/pdf_data_grid/data_grid.dart',
    );
    final column = source(
      'lib/src/components/models/grid_models/column.dart',
    );
    expect(grid, contains('followDirection'));
    expect(grid, contains('preserveDefinitionOrder'));
    expect(column, contains('headerDirection'));
    expect(column, contains('contentDirection'));
    expect(column, contains('directionalPadding'));
    expect(grid, isNot(contains('lazyRowPreparation')));
  });

  test('media is never mirrored as an RTL implementation technique', () {
    final files = <String>[
      'lib/src/components/widgets/summary/genius_pdf_signature_area.dart',
      'lib/src/components/widgets/summary/genius_pdf_q_r_code.dart',
      'lib/src/components/widgets/pdf_barcode.dart',
    ];
    for (final path in files) {
      final text = source(path);
      expect(text, isNot(contains('scaleTransform(-1')));
      expect(text, isNot(contains('flipHorizontal')));
      expect(text, isNot(contains("split('').reversed")));
    }
    expect(
      source('lib/src/components/widgets/pdf_watermark.dart'),
      contains('GeniusPdfWatermark.directional'),
    );
  });
}
