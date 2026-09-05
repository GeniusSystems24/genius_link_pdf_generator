import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Colored Markdown Links**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class RichTextColoredLinksExampleScreen extends StatelessWidget {
  const RichTextColoredLinksExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Colored Markdown Links** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `colored_links_example_screen.dart` and displayed as **Dart usage code**.
class RichTextColoredLinksDemoBuilder extends GeniusPdfDocumentBuilder {
  RichTextColoredLinksDemoBuilder(super.config);

  @override
  void build() {
    newPage();

    // Title using builder method
    addSectionDivider(
      title: config.isRTL
          ? 'نص منسق - GeniusPdfRichText'
          : 'Rich Text - GeniusPdfRichText',
      spacing: 10,
    );

    addSpace(15);

    // Colored links
    addRichText(
      GeniusPdfRichText(
        spans: GeniusPdfSimpleMarkdownParser.parse(
          config.isRTL
              ? '**رابط ملون:** [الأحمر](https://red.example.com){#E53935} و [الأخضر](https://green.example.com){#43A047}'
              : '**Colored link:** [red link](https://red.example.com){#E53935} and [green link](https://green.example.com){#43A047}',
        ),
        baseFont: baseFont,
        boldFont: config.boldFont,
        isRTL: config.isRTL,
        config: config,
      ),
      spacing: 10,
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'rich_text_colored_links',
      category: 'Components / Core PDF Components / Rich Text',
      title: 'Colored Markdown Links',
      apiName: 'GeniusPdfRichText',
      description: 'Apply per-link colors through the markdown link-color syntax.',
      icon: Icons.palette_outlined,
      usageCode: dartUsageCode,
    );
  }
}
