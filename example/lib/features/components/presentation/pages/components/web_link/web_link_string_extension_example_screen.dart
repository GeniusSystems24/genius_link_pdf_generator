import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **String Web-Link Extension**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class WebLinkStringExtensionExampleScreen extends StatelessWidget {
  const WebLinkStringExtensionExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **String Web-Link Extension** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `web_link_string_extension_example_screen.dart` and displayed as **Dart usage code**.
class WebLinkStringExtensionDemoBuilder extends GeniusPdfDocumentBuilder {
  WebLinkStringExtensionDemoBuilder(super.config);

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

    // ── Section 3: String Extension ────────────────────────────
    addSectionDivider(
      title: isRTL ? '3. امتداد النص' : '3. String Extension',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichText(
        config: config,
        spans: [
          GeniusPdfTextSpan(text: isRTL ? 'انقر ' : 'Click '),
          (isRTL ? 'هنا' : 'here').toWebLinkSpan('https://example.com'),
          GeniusPdfTextSpan(
            text: isRTL ? ' للتحميل.' : ' to download.',
          ),
        ],
      ),
      spacing: 5,
    );

    addSpace(15);
  }
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'web_link_string_extension',
      category: 'Components / Core PDF Components / Web Links',
      title: 'String Web-Link Extension',
      apiName: 'GeniusPdfTextSpan.webLink',
      description: 'Convert ordinary strings to clickable link spans with toWebLinkSpan().',
      icon: Icons.extension_outlined,
      usageCode: dartUsageCode,
    );
  }
}
