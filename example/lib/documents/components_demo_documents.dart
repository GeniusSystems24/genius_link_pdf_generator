import 'dart:typed_data';
import 'dart:ui' show Rect;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/documents/components/data_grid_demo_builder.dart';
import 'package:genius_pdf_example/documents/components/grid_infobox_demo_builder.dart';
import 'package:genius_pdf_example/documents/components/grid_qrcode_demo_builder.dart';
import 'package:genius_pdf_example/documents/components/grid_richtext_demo_builder.dart';
import 'package:genius_pdf_example/documents/components/grid_watermark_demo_builder.dart';
import 'package:genius_pdf_example/documents/components/headers_demo_builder.dart';
import 'package:genius_pdf_example/documents/components/info_box_demo_builder.dart';
import 'package:genius_pdf_example/documents/components/rich_text_demo_builder.dart';
import 'package:genius_pdf_example/documents/components/summary_demo_builder.dart';

Future<Uint8List> buildComponentDemoBytes({
  required String component,
  required GeniusPdfConfig config,
}) async {
  final GeniusPdfDocumentBuilder builder;
  switch (component) {
    case 'data_grid':
      builder = DataGridDemoBuilder(config);
      break;
    case 'rich_text':
      builder = RichTextDemoBuilder(config);
      break;
    case 'info_box':
      builder = InfoBoxDemoBuilder(config);
      break;
    case 'headers':
      builder = HeadersDemoBuilder(config);
      break;
    case 'summary':
      builder = SummaryDemoBuilder(config);
      break;
    case 'grid_qrcode':
      builder = GridQrcodeDemoBuilder(config);
      break;
    case 'grid_infobox':
      builder = GridInfoboxDemoBuilder(config);
      break;
    case 'grid_watermark':
      builder = GridWatermarkDemoBuilder(config);
      break;
    case 'grid_richtext':
      builder = GridRichtextDemoBuilder(config);
      break;
    default:
      throw ArgumentError('Unsupported component: $component');
  }

  final bytes = builder.generate();
  builder.dispose();
  return Uint8List.fromList(bytes);
}

void drawTitle(
  PdfPage page,
  PdfFont titleFont,
  String text, {
  GeniusPdfConfig? config,
}) {
  final textDirection = config?.pdfTextDirection ?? PdfTextDirection.leftToRight;
  page.graphics.drawString(
    text,
    titleFont,
    bounds: Rect.fromLTWH(20, 20, page.getClientSize().width - 40, 30),
    format: PdfStringFormat(
      alignment: PdfTextAlignment.center,
      textDirection: textDirection,
    ),
  );
}
