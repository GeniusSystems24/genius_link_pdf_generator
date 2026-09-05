import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/export/models/documents/template_image_export_examples.dart';
import 'package:genius_pdf_example/features/export/presentation/widgets/template_image_export_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Exports the Balance Sheet business template to PNG or JPEG images.
class BalanceSheetImageExportExampleScreen extends StatelessWidget {
  const BalanceSheetImageExportExampleScreen({super.key});

  /// Exact source of the generator function executed by this screen.
  static const String dartUsageCode = r'''/// Builds the Balance Sheet template and exports every PDF page as an image.
Future<TemplateImageExportResult> exportBalanceSheetTemplateAsImages({
  required bool isRtl,
  required GeniusExportFormat format,
  required GeniusImageQuality quality,
  required DemoDocumentController documents,
}) async {
  if (format != GeniusExportFormat.png &&
      format != GeniusExportFormat.jpeg) {
    throw ArgumentError.value(format, 'format', 'PNG or JPEG is required.');
  }

  final demo = buildBalanceSheetDemo(isRtl: isRtl);
  PdfDocument? document;
  try {
    final pdfBytes = Uint8List.fromList(demo.builder.generate());
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
          final path = await documents.saveBytes(
            bytes: data,
            fileName:
                '${demo.fileName}_page_${index + 1}.${format.extension}',
          );
          filePaths.add(path);
        case GeniusExportFailure(:final message):
          throw StateError(message);
      }
    }

    if (pages.isEmpty) {
      throw StateError('The template did not produce any image pages.');
    }

    return TemplateImageExportResult(
      pages: pages,
      filePaths: filePaths,
      format: format,
      quality: quality,
    );
  } finally {
    document?.dispose();
    demo.builder.dispose();
  }
}''';

  @override
  Widget build(BuildContext context) {
    return TemplateImageExportDetailScreen(
      category: 'Financial Templates',
      title: pdfLocalization.balanceSheet,
      description: pdfLocalization.balanceSheetImageExportDesc,
      icon: Icons.account_balance_wallet_outlined,
      exportTemplate: exportBalanceSheetTemplateAsImages,
      usageCode: dartUsageCode,
    );
  }
}
