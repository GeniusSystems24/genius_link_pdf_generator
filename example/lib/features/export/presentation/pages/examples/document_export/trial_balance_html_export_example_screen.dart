import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/export/models/documents/template_html_export_examples.dart';
import 'package:genius_pdf_example/features/export/presentation/widgets/template_html_export_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Exports `TrialBalanceTemplate` to HTML.
class TrialBalanceHtmlExportExampleScreen extends StatelessWidget {
  const TrialBalanceHtmlExportExampleScreen({super.key});

  /// Exact source of the generator function executed by this screen.
  static const String dartUsageCode = r'''/// Builds the Trial Balance template and exports it as HTML.
Future<TemplateHtmlExportResult> exportTrialBalanceTemplateAsHtml({
  required bool isRtl,
  required bool embedImages,
  required bool includeStyles,
  required DemoDocumentController documents,
}) async {
  final template = buildTrialBalanceTemplate(isRtl: isRtl);
  PdfDocument? document;

  try {
    final pdfBytes = Uint8List.fromList(template.generate());
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
          fileName: 'trial_balance_${direction}_${styleMode}.html',
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
        throw StateError('Trial Balance HTML export failed: $message');
    }
  } finally {
    document?.dispose();
    template.dispose();
  }
}''';

  @override
  Widget build(BuildContext context) {
    return TemplateHtmlExportDetailScreen(
      category: 'Financial Templates',
      title: pdfLocalization.trialBalance,
      description:
          pdfLocalization.trialBalanceHtmlExportDesc,
      icon: Icons.balance_outlined,
      exportTemplate: exportTrialBalanceTemplateAsHtml,
      usageCode: dartUsageCode,
    );
  }
}
