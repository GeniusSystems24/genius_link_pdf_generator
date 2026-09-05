import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/custom_report/presentation/internal/custom_report_single_example_host.dart';

/// Compatibility entry point for the Custom Report example.
///
/// Custom Report was already a single example, so no artificial sub-screens are
/// created for its configurable report components. The implementation is kept
/// in a single focused host with its existing explicit Generate PDF workflow.
class CustomReportScreen extends StatelessWidget {
  const CustomReportScreen({super.key});

  @override
  Widget build(BuildContext context) => const CustomReportSingleExampleHost();
}
