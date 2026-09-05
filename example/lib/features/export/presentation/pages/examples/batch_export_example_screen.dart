import 'package:flutter/widgets.dart';
import 'package:genius_pdf_example/features/export/presentation/internal/export_single_example_host.dart';

/// Dedicated single-example screen for **Batch Export**.
///
/// This screen deliberately contains no tabs and no sibling examples. It keeps
/// the original Export implementation and behavior through the
/// shared internal host while selecting only this example.
class BatchExportExampleScreen extends StatelessWidget {
  const BatchExportExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ExportSingleExampleHost(initialTab: 2);
  }
}
