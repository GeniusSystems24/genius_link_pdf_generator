import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Builder Web Links**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class WebLinkBuilderExampleScreen extends StatelessWidget {
  const WebLinkBuilderExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Builder Web Links** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `web_link_builder_example_screen.dart` and displayed as **Dart usage code**.
class WebLinkBuilderDemoBuilder extends GeniusPdfDocumentBuilder {
  WebLinkBuilderDemoBuilder(super.config);

  @override
  void build() {
    addHeader(
      title: isRTL
          ? 'عرض الروابط والنص المنسق — الإصدار 2.11.0'
          : 'Web Links & Rich Text Demo — v2.11.0',
    );
    addFooter(
      showPageNumber: true,
      printTime: DateTime.now().toString().substring(0, 19),
    );

    newPage();

    // ── Section 1: PdfTextWebLink via Builder ──────────────────
    addSectionDivider(
      title: isRTL ? '1. روابط الويب عبر الباني' : '1. Web Links via Builder',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(isRTL ? 'زر ' : 'Visit ')
          .webLink('Google', 'https://www.google.com')
          .text(isRTL ? ' أو ' : ' or ')
          .webLink(
            'GitHub',
            'https://github.com',
            color: const Color(0xFF6E5494),
          )
          .text(isRTL ? ' لمزيد من المعلومات.' : ' for more info.')
          .build(),
      spacing: 5,
    );

    addSpace(5);

    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(isRTL ? 'قراءة ' : 'Read the ')
          .webLink(
            isRTL ? 'التوثيق' : 'documentation',
            'https://help.syncfusion.com',
            color: const Color(0xFF0D47A1),
          )
          .text(isRTL ? ' للتفاصيل.' : ' for details.')
          .build(),
      spacing: 5,
    );

    addSpace(15);
  }
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'web_link_builder',
      category: 'Components / Core PDF Components / Web Links',
      title: 'Builder Web Links',
      apiName: 'GeniusPdfTextSpan.webLink',
      description: 'Create clickable links through GeniusPdfRichTextBuilder.webLink(), including custom link colors.',
      icon: Icons.link_outlined,
      usageCode: dartUsageCode,
    );
  }
}
