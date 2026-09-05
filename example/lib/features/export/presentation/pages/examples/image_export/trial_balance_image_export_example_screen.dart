import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/export/models/documents/template_image_export_examples.dart';
import 'package:genius_pdf_example/features/export/presentation/widgets/template_image_export_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Exports `TrialBalanceTemplate` to PNG or JPEG images.
class TrialBalanceImageExportExampleScreen extends StatelessWidget {
  const TrialBalanceImageExportExampleScreen({super.key});

  /// Exact source of the generator function executed by this screen.
  static const String dartUsageCode = r'''/// Builds the Trial Balance template and exports every PDF page as an image.
Future<TemplateImageExportResult> exportTrialBalanceTemplateAsImages({
  required bool isRtl,
  required GeniusExportFormat format,
  required GeniusImageQuality quality,
  required DemoDocumentController documents,
}) async {
  if (format != GeniusExportFormat.png &&
      format != GeniusExportFormat.jpeg) {
    throw ArgumentError.value(format, 'format', 'PNG or JPEG is required.');
  }

  final template = buildTrialBalanceTemplate(isRtl: isRtl);
  PdfDocument? document;

  try {
    final pdfBytes = Uint8List.fromList(template.generate());
    document = PdfDocument(inputBytes: pdfBytes);

    final results = await document.exportToImages(
      format: format,
      quality: quality,
    );

    final pages = <Uint8List>[];
    final filePaths = <String>[];
    for (var index = 0; index < results.length; index++) {
      final result = results[index];
      switch (result) {
        case GeniusExportSuccess(:final data):
          pages.add(data);
          final direction = isRtl ? 'rtl' : 'ltr';
          final path = await documents.saveBytes(
            bytes: data,
            fileName:
                'trial_balance_${direction}_page_${index + 1}.${format.extension}',
          );
          filePaths.add(path);

        case GeniusExportFailure(:final message):
          throw StateError('Trial Balance image export failed: $message');
      }
    }

    if (pages.isEmpty) {
      throw StateError('The Trial Balance template did not produce image pages.');
    }

    return TemplateImageExportResult(
      pages: pages,
      filePaths: filePaths,
      format: format,
      quality: quality,
    );
  } finally {
    document?.dispose();
    template.dispose();
  }
}''';

  @override
  Widget build(BuildContext context) {
    return TemplateImageExportDetailScreen(
      category: 'Financial Templates',
      title: pdfLocalization.trialBalance,
      description:
          pdfLocalization.trialBalanceImageExportDesc,
      icon: Icons.balance_outlined,
      exportTemplate: exportTrialBalanceTemplateAsImages,
      usageCode: dartUsageCode,
    );
  }
}
