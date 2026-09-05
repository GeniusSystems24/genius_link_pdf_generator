import 'package:flutter/material.dart';
import 'package:genius_pdf_example/features/printing/presentation/controllers/printing_demo_controller.dart';
import 'package:genius_pdf_example/features/printing/presentation/internal/printing_single_example_host.dart';

class PrintPreviewExampleScreen extends StatelessWidget {
  const PrintPreviewExampleScreen({super.key, this.controller});
  final PrintingDemoController? controller;

  static const String dartUsageCode = r'''
Future<void> _generateSamplePdf() => _controller.generateSamplePdf();

Future<void> _printWithDialog() => _controller.printWithDialog();

Future<void> _showPrintPreview() async {
    if (_controller.samplePdfBytes == null) return;

    final result = await GeniusPrintPreviewDialog.show(
      config: geniusPdfConfig,
      context: context,
      pdfBytes: _controller.samplePdfBytes!,
      documentName: 'Sample_Document',
      initialSettings: _controller.currentSettings,
      showSettings: true,
    );

    _controller.updateStatus(
      result == true ? 'Document printed from preview!' : 'Print preview closed',
    );
  }
''';

  @override
  Widget build(BuildContext context) {
    return PrintingSingleExampleHost(
      section: PrintingDemoSection.print,
      usageCode: dartUsageCode, controller: controller,
    );
  }
}
