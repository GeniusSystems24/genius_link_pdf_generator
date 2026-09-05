import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/export/models/documents/template_image_export_examples.dart';
import 'package:genius_pdf_example/features/export/presentation/widgets/template_image_export_detail_screen.dart';

/// Exports the Payslip business template to PNG or JPEG images.
class PayslipImageExportExampleScreen extends StatelessWidget {
  const PayslipImageExportExampleScreen({super.key});

  /// Exact source of the generator function executed by this screen.
  static const String dartUsageCode = r'''/// Builds the Payslip template and exports every PDF page as an image.
Future<TemplateImageExportResult> exportPayslipTemplateAsImages({
  required bool isRtl,
  required GeniusExportFormat format,
  required GeniusImageQuality quality,
  required DemoDocumentController documents,
}) async {
  if (format != GeniusExportFormat.png &&
      format != GeniusExportFormat.jpeg) {
    throw ArgumentError.value(format, 'format', 'PNG or JPEG is required.');
  }

  final demo = buildPayslipDemo(isRtl: isRtl);
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
      category: 'HR Templates',
      title: 'Payslip',
      description: 'Generate the Payslip template, rasterize every PDF page, save it as PNG or JPEG, and preview the exported image bytes.',
      icon: Icons.payments_outlined,
      exportTemplate: exportPayslipTemplateAsImages,
      usageCode: dartUsageCode,
    );
  }
}
