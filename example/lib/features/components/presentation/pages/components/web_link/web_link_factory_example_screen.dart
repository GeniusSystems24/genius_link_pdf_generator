import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **TextSpan Web Link Factory**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class WebLinkFactoryExampleScreen extends StatelessWidget {
  const WebLinkFactoryExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Focused document builder for the **TextSpan Web Link Factory** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `web_link_factory_example_screen.dart` and displayed as **Dart usage code**.
class WebLinkFactoryDemoBuilder extends GeniusPdfDocumentBuilder {
  WebLinkFactoryDemoBuilder(super.config);

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

    // ── Section 2: Factory Constructor ─────────────────────────
    addSectionDivider(
      title: isRTL ? '2. المُنشئ المباشر' : '2. Factory Constructor',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichText(
        config: config,
        spans: [
          GeniusPdfTextSpan(
            text: isRTL ? 'التقرير متاح على ' : 'Report available at ',
          ),
          GeniusPdfTextSpan.webLink(
            isRTL ? 'بوابة التقارير' : 'Reports Portal',
            url: 'https://reports.example.com',
            color: const Color(0xFF1565C0),
          ),
          GeniusPdfTextSpan(text: '.'),
        ],
      ),
      spacing: 5,
    );

    addSpace(15);
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'web_link_factory',
      category: 'Components / Core PDF Components / Web Links',
      title: pdfLocalization.textSpanWebLinkFactory,
      apiName: 'GeniusPdfTextSpan.webLink',
      description: pdfLocalization.clickableHyperlinkDirectlyGeniusPdfDesc,
      icon: Icons.open_in_new_outlined,
      usageCode: dartUsageCode,
    );
  }
}
