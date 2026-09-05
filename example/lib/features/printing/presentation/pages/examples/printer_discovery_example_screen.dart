import 'package:flutter/material.dart';
import 'package:genius_pdf_example/features/printing/presentation/controllers/printing_demo_controller.dart';
import 'package:genius_pdf_example/features/printing/presentation/internal/printing_single_example_host.dart';

class PrinterDiscoveryExampleScreen extends StatelessWidget {
  const PrinterDiscoveryExampleScreen({super.key, this.controller});
  final PrintingDemoController? controller;

  static const String dartUsageCode = r'''
Future<void> _discoverPrinters() => _controller.discoverPrinters();

Future<void> _checkPrintingInfo() => _controller.checkPrintingInfo();
''';

  @override
  Widget build(BuildContext context) {
    return PrintingSingleExampleHost(
      section: PrintingDemoSection.printers,
      usageCode: dartUsageCode, controller: controller,
    );
  }
}
