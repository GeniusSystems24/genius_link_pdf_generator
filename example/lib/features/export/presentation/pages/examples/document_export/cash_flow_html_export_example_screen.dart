import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/export/models/documents/template_html_export_examples.dart';
import 'package:genius_pdf_example/features/export/presentation/widgets/template_html_export_detail_screen.dart';

/// Exports the Cash Flow business template to HTML.
class CashFlowHtmlExportExampleScreen extends StatelessWidget {
  const CashFlowHtmlExportExampleScreen({super.key});

  /// Exact source of the generator function executed by this screen.
  static const String dartUsageCode = r'''/// Builds the Cash Flow template and exports it as HTML.
Future<TemplateHtmlExportResult> exportCashFlowTemplateAsHtml({
  required bool isRtl,
  required bool embedImages,
  required bool includeStyles,
  required DemoDocumentController documents,
}) async {
  final demo = buildCashFlowDemo(isRtl: isRtl);
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
          fileName: 'cash_flow_${direction}_${styleMode}.html',
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
      category: 'Financial Templates',
      title: 'Cash Flow',
      description: 'Generate the Cash Flow template and export its PDF content to an HTML document using GeniusPdfExportService. Preview the exact HTML source, save it, and open the exported file.',
      icon: Icons.swap_vert_circle_outlined,
      exportTemplate: exportCashFlowTemplateAsHtml,
      usageCode: dartUsageCode,
    );
  }
}
