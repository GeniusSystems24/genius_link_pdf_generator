import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/export/presentation/controllers/export_demo_controller.dart';
import 'package:genius_pdf_example/features/export/presentation/internal/export_single_example_host.dart';

/// Compatibility entry point for the former multi-example Export screen.
///
/// The example application now exposes every example as a dedicated navigation
/// destination. [initialTab] is retained only for existing callers and selects
/// one focused example; no tab bar or multi-example page is rendered.
@Deprecated('Use one of the dedicated Export example screens.')
class ExportDemoScreen extends StatelessWidget {
  const ExportDemoScreen({
    super.key,
    this.initialTab = 0,
    this.controller,
  });

  final int initialTab;
  final ExportDemoController? controller;

  @override
  Widget build(BuildContext context) {
    return ExportSingleExampleHost(initialTab: initialTab, controller: controller);
  }
}
