import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/showcase/presentation/widgets/showcase_example_detail_screen.dart';

/// Dedicated screen for the Complete Demo Showcase example.
///
/// No PDF is generated until **Run example** is pressed. The `Dart usage code`
/// panel contains the exact generator declaration executed for this preview.
class CompleteDemoExampleScreen extends StatelessWidget {
  const CompleteDemoExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a comprehensive demo PDF containing one representative voucher
/// from each of the 16 template classes.
List<int> buildCompleteVoucherDemoReport({
  required GeniusPdfConfig config,
}''';

  @override
  Widget build(BuildContext context) {
    return const ShowcaseExampleDetailScreen(
      showcaseId: 'showcase_complete_demo',
      category: 'Showcase',
      title: 'Complete Demo',
      apiName: 'buildCompleteVoucherDemoReport',
      description: 'Generate the comprehensive voucher showcase covering the complete voucher template set.',
      icon: Icons.library_books_outlined,
      usageCode: dartUsageCode,
    );
  }
}
