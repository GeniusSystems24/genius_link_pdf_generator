import 'dart:typed_data';
import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

class TestPdfDocumentBuilder extends GeniusPdfDocumentBuilder {
  TestPdfDocumentBuilder(
    super.config, {
    this.onBuild,
  });

  final void Function(TestPdfDocumentBuilder builder)? onBuild;

  @override
  void build() {
    onBuild?.call(this);
  }
}

GeniusPdfConfig createTestConfig({
  Size pageSize = const Size(180, 220),
  TextDirection textDirection = TextDirection.ltr,
  PdfPageOrientation orientation = PdfPageOrientation.portrait,
  double margin = 0,
}) {
  final regularFont = PdfStandardFont(PdfFontFamily.helvetica, 10);
  final boldFont = PdfStandardFont(PdfFontFamily.helvetica, 10,
      style: PdfFontStyle.bold);

  return GeniusPdfConfig(
    baseFontBytes: Uint8List.fromList(const [0]),
    boldFontBytes: Uint8List.fromList(const [0]),
    headerFontBytes: Uint8List.fromList(const [0]),
    smallFontBytes: Uint8List.fromList(const [0]),
    baseFont: regularFont,
    boldFont: boldFont,
    headerFont: boldFont,
    smallFont: regularFont,
    pageSize: pageSize,
    orientation: orientation,
    textDirection: textDirection,
    margins: PdfMargins()..all = margin,
  );
}

String createLongParagraph({
  int repeat = 120,
  String seed = 'Long flowing PDF content for pagination verification.',
}) {
  return List.generate(repeat, (_) => seed).join(' ');
}

GeniusPdfDataGrid createPagedGrid(
  GeniusPdfConfig config, {
  int rowCount = 48,
}) {
  return GeniusPdfDataGrid(
    config: config,
    columns: const [
      GeniusPdfGridColumn(
        id: 'item',
        title: 'Item',
      ),
      GeniusPdfGridColumn(
        id: 'amount',
        title: 'Amount',
        alignment: GeniusPdfTextAlign.end,
      ),
    ],
    rows: List.generate(
      rowCount,
      (index) => GeniusPdfGridRow(
        cells: {
          'item': 'Row ${index + 1}',
          'amount': '${(index + 1) * 10}',
        },
      ),
    ),
  );
}

GeniusPdfSummarySection createSummary(
  GeniusPdfConfig config, {
  int itemCount = 3,
}) {
  return GeniusPdfSummarySection(
    config: config,
    items: List.generate(
      itemCount,
      (index) => GeniusPdfSummaryItem(
        label: 'Metric ${index + 1}',
        value: '${(index + 1) * 100}',
      ),
    ),
  );
}

GeniusPdfInfoBox createInfoBox(
  GeniusPdfConfig config, {
  int itemCount = 3,
}) {
  return GeniusPdfInfoBox(
    config: config,
    title: 'Info',
    items: List.generate(
      itemCount,
      (index) => GeniusPdfLabeledValue(
        config: config,
        label: 'Field ${index + 1}',
        value: 'Value ${index + 1}',
      ),
    ),
  );
}

GeniusPdfReportHeader createReportHeader(GeniusPdfConfig config) {
  return GeniusPdfReportHeader.simple(
    title: 'Monthly Report',
    subtitle: 'Stability fixture',
    config: config,
  );
}

GeniusPdfRichText createLongRichText(
  GeniusPdfConfig config, {
  int repeat = 80,
}) {
  final builder = GeniusPdfRichTextBuilder(config: config);
  for (var i = 0; i < repeat; i++) {
    builder.text('Rich text segment ${i + 1} ');
  }
  return builder.build();
}
