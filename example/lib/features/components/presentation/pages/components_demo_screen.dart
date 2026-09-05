import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/pages/components/data_grid_example_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components/rich_text_example_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components/info_box_example_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components/headers_example_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components/summary_example_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components/grid_qrcode_example_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components/grid_infobox_example_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components/grid_watermark_example_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components/grid_richtext_example_screen.dart';

/// Legacy compatibility wrapper for the former tabbed Components Demo screen.
///
/// Every component example is now a dedicated navigation destination. This
/// wrapper exists only for old source references and does not render a list,
/// tabs, [TabBar], [TabBarView], or multiple examples.
@Deprecated(
  'Use the dedicated component example screens, such as '
  'DataGridExampleScreen or RichTextExampleScreen.',
)
class ComponentsDemoScreen extends StatelessWidget {
  const ComponentsDemoScreen({super.key, this.initialTab = 0});

  /// Compatibility mapping for callers that selected one of the former tabs.
  final int initialTab;

  @override
  Widget build(BuildContext context) {
    return switch (initialTab) {
      1 => const RichTextExampleScreen(),
      2 => const InfoBoxExampleScreen(),
      3 => const HeadersExampleScreen(),
      4 => const SummaryExampleScreen(),
      5 => const GridQrcodeExampleScreen(),
      6 => const GridInfoboxExampleScreen(),
      7 => const GridWatermarkExampleScreen(),
      8 => const GridRichtextExampleScreen(),
      _ => const DataGridExampleScreen(),
    };
  }
}
