import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Builder Links**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class RichTextBuilderLinksExampleScreen extends StatelessWidget {
  const RichTextBuilderLinksExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Builder Links** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `builder_links_example_screen.dart` and displayed as **Dart usage code**.
class RichTextBuilderLinksDemoBuilder extends GeniusPdfDocumentBuilder {
  RichTextBuilderLinksDemoBuilder(super.config);

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

    // Link line
    addRichText(
      GeniusPdfRichTextBuilder(
        config: config,
      )
          .text(config.isRTL ? 'زر الموقع: ' : 'Visit site: ')
          .link(
            config.isRTL ? 'موقعنا' : 'our website',
            'https://example.com',
            color: const Color(0xFF0D47A1),
          )
          .text(config.isRTL ? ' أو ' : ' or ')
          .link(
            config.isRTL ? 'الدعم' : 'support',
            'https://support.example.com',
            color: const Color(0xFFE65100),
          )
          .build(),
      spacing: 10,
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'rich_text_links',
      category: 'Components / Core PDF Components / Rich Text',
      title: 'Builder Links',
      apiName: 'GeniusPdfRichText',
      description: 'Add styled links to fluent rich text content using the builder link API.',
      icon: Icons.link_outlined,
      usageCode: dartUsageCode,
    );
  }
}
