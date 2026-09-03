
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final flow = File(
    'lib/src/builders/pdf_document_builder/flow_layout.dart',
  ).readAsStringSync();

  test('S03 core abstractions exist', () {
    for (final token in <String>[
      'abstract class PdfBlock',
      'abstract class PdfBand',
      'class PdfFlowSection',
      'class PdfKeepTogether',
      'class PdfRepeatableBand',
      'class PdfPageBreakPolicy',
    ]) {
      expect(flow, contains(token), reason: token);
    }
  });

  test('pagination policies are represented explicitly', () {
    for (final token in <String>[
      'keepTogether',
      'keepWithNext',
      'pageBreakBefore',
      'pageBreakAfter',
      'breakBeforeWhen',
      'minOrphanLines',
      'minWidowLines',
    ]) {
      expect(flow, contains(token), reason: token);
    }
  });

  test('measurement and rendering are separate passes', () {
    expect(flow, contains('PdfBlockMeasurement measure('));
    expect(flow, contains('PdfBlockRenderResult render('));
    expect(flow, contains('measurementCount'));
    expect(flow, contains('Measurement is authoritative'));
  });

  test('page metadata/chrome features exist', () {
    for (final token in <String>[
      'PdfPageNumberBand',
      'firstPageHeader',
      'lastPageFooter',
      'PdfDocumentMarkerBand',
      'documentStatus',
      'copyLabel',
    ]) {
      expect(flow, contains(token), reason: token);
    }
  });

  test('legacy builder APIs are not deprecated by S03', () {
    final builder = File(
      'lib/src/builders/pdf_document_builder/document_builder.dart',
    ).readAsStringSync();

    expect(builder, contains('void addLine('));
    expect(builder, contains('void addTwoColumns({'));
    expect(builder, contains('PdfPageTemplateElement addHeader({'));
    expect(builder, contains('PdfPageTemplateElement addFooter({'));

    expect(
      flow,
      isNot(contains('@Deprecated(')),
      reason: 'S03-T28: no deprecation until replacement is proven stable.',
    );
  });

  test('legacy custom callbacks are adapted, not removed', () {
    expect(flow, contains('typedef PdfLegacyFlowCallback'));
    expect(flow, contains('class PdfLegacyCallbackBlock'));
  });
}
