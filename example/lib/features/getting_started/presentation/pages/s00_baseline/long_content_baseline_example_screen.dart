import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/getting_started/models/documents/s00_baseline/s00_long_content_demo_builder.dart';
import 'package:genius_pdf_example/features/getting_started/presentation/widgets/s00_baseline_example_detail_screen.dart';

/// Dedicated S00 screen for the Long / Multi-page Baseline regression example.
///
/// The `Dart usage code` panel contains the exact builder source executed by
/// this screen when **Run example** is pressed.
class S00LongContentBaselineExampleScreen extends StatelessWidget {
  const S00LongContentBaselineExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused Long / Multi-page Baseline S00 regression example.
class S00LongContentDemoBuilder extends GeniusPdfDocumentBuilder {
  S00LongContentDemoBuilder(super.config);

  @override
  void build() {
    newPage();
    for (var i = 0; i < 90; i++) {
      addLine(
        config.isRTL
            ? '${i + 1}. هذا نص عربي طويل للتحقق من تدفق الصفحات — '
                'SKU-AR-ENG-001 — INV-2026-000123'
            : '${i + 1}. Long baseline content for page-flow verification — '
                'SKU-AR-ENG-001 — INV-2026-000123',
        topMargin: i == 0 ? 0 : 5,
      );
    }
  }
}''';

  @override
  Widget build(BuildContext context) {
    return S00BaselineExampleDetailScreen(
      title: 'Long / Multi-page Baseline',
      apiName: 'S00LongContentDemoBuilder',
      description: 'Verify long-content page flow and transitions across multiple pages in both LTR and RTL modes.',
      icon: Icons.article_outlined,
      builderFactory: (config) => S00LongContentDemoBuilder(config),
      usageCode: dartUsageCode,
      expectedLtr: 'Output must span multiple pages without clipping/overlap; inspect transitions.',
      expectedRtl: 'Output must span multiple pages without clipping/overlap; inspect transitions.',
      fileName: 's00_long_content.pdf',
    );
  }
}
