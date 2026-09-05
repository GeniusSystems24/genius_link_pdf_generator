import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/printing/presentation/controllers/printing_demo_controller.dart';
import 'package:genius_pdf_example/features/printing/presentation/pages/examples/printer_discovery_example_screen.dart';

/// Compatibility entry point. New navigation should use the focused screens.
@Deprecated('Use a dedicated printing example screen.')
class PrintingDemoScreen extends StatelessWidget {
  const PrintingDemoScreen({super.key, this.controller});
  final PrintingDemoController? controller;

  @override
  Widget build(BuildContext context) =>
      PrinterDiscoveryExampleScreen(controller: controller);
}
