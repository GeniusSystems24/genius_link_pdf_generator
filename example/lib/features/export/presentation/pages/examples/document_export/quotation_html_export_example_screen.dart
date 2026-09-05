import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/export/models/documents/template_html_export_examples.dart';
import 'package:genius_pdf_example/features/export/presentation/widgets/template_html_export_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Exports the Quotation business template to HTML.
class QuotationHtmlExportExampleScreen extends StatelessWidget {
  const QuotationHtmlExportExampleScreen({super.key});

  /// Exact source of the generator function executed by this screen.
  static const String dartUsageCode = r'''/// Builds the Quotation template and exports it as HTML.
Future<TemplateHtmlExportResult> exportQuotationTemplateAsHtml({
  required bool isRtl,
  required bool embedImages,
  required bool includeStyles,
  required DemoDocumentController documents,
}) async {
  final demo = buildQuotationDemo(isRtl: isRtl);
  PdfDocument? document;

  try {
    final pdfBytes = Uint8List.fromList(demo.builder.generate());
    document = PdfDocument(inputBytes: pdfBytes);

    final result = await GeniusPdfExportService().export(
      document,
      GeniusExportConfiguration.html(
        embedImages: embedImages,
        includeStyles: includeStyles,
      ),
    );

    switch (result) {
      case GeniusExportSuccess(:final data, :final pageCount):
        final direction = isRtl ? 'rtl' : 'ltr';
        final styleMode = includeStyles ? 'styled' : 'plain';
        final path = await documents.saveBytes(
          bytes: data,
          fileName: 'quotation_${direction}_${styleMode}.html',
        );

        return TemplateHtmlExportResult(
          data: data,
          html: utf8.decode(data, allowMalformed: true),
          filePath: path,
          pageCount: pageCount,
          embedImages: embedImages,
          includeStyles: includeStyles,
        );

      case GeniusExportFailure(:final message):
        throw StateError('HTML export failed: $message');
    }
  } finally {
    document?.dispose();
    demo.builder.dispose();
  }
}''';

  @override
  Widget build(BuildContext context) {
    return TemplateHtmlExportDetailScreen(
      category: 'Sales Templates',
      title: pdfLocalization.quotation,
      description: pdfLocalization.quotationHtmlExportDesc,
      icon: Icons.request_quote_outlined,
      exportTemplate: exportQuotationTemplateAsHtml,
      usageCode: dartUsageCode,
    );
  }
}
