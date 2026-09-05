import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/showcase/presentation/widgets/showcase_example_detail_screen.dart';

/// Dedicated screen for the Report Composer Showcase example.
///
/// No PDF is generated until **Run example** is pressed. The `Dart usage code`
/// panel contains the exact generator declaration executed for this preview.
class ReportComposerExampleScreen extends StatelessWidget {
  const ReportComposerExampleScreen({super.key});

  static const String dartUsageCode = r'''/// Demonstrates the fluent report composer with a paginated grid + summary.
///
/// The data set is intentionally large enough to exercise the composer path
/// for grid continuation and post-grid summary placement near page breaks.
List<int> buildComposerDemoReport({
  required GeniusPdfConfig config,
  String userName = 'Demo User',
}''';

  @override
  Widget build(BuildContext context) {
    return const ShowcaseExampleDetailScreen(
      showcaseId: 'showcase_report_composer',
      category: 'Showcase',
      title: 'Report Composer',
      apiName: 'buildComposerDemoReport',
      description: 'Build a complete PDF report through the fluent report-composer API.',
      icon: Icons.auto_awesome_outlined,
      usageCode: dartUsageCode,
    );
  }
}
