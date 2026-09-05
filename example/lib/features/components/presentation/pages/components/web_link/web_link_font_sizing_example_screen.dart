import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Font Sizing & Scripts**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class WebLinkFontSizingExampleScreen extends StatelessWidget {
  const WebLinkFontSizingExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Focused document builder for the **Font Sizing & Scripts** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `web_link_font_sizing_example_screen.dart` and displayed as **Dart usage code**.
class WebLinkFontSizingDemoBuilder extends GeniusPdfDocumentBuilder {
  WebLinkFontSizingDemoBuilder(super.config);

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

    // ── Section 4: Font Sizing Fix ─────────────────────────────
    addSectionDivider(
      title: isRTL ? '4. إصلاح حجم الخط' : '4. Font Size Fix',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichText(
        config: config,
        spans: [
          GeniusPdfTextSpan(
            text: isRTL ? 'حجم عادي، ' : 'Normal size, ',
          ),
          GeniusPdfTextSpan(
            text: isRTL ? 'حجم كبير، ' : 'Large size, ',
            fontSize: 18,
            color: const Color(0xFFE65100),
          ),
          GeniusPdfTextSpan(
            text: isRTL ? 'حجم صغير، ' : 'Small size, ',
            fontSize: 8,
            color: const Color(0xFF1B5E20),
          ),
          GeniusPdfTextSpan(
            text: isRTL ? 'حجم عادي مرة أخرى.' : 'Normal again.',
          ),
        ],
      ),
      spacing: 5,
    );

    addSpace(10);

    // Superscript / subscript demo
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(isRTL ? 'الماء: ' : 'Water: ')
          .text('H')
          .subscript('2')
          .text('O')
          .text(isRTL ? '  |  الطاقة: ' : '  |  Energy: ')
          .text('E = mc')
          .superscript('2')
          .build(),
      spacing: 5,
    );

    addSpace(15);
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'web_link_font_sizing',
      category: 'Components / Core PDF Components / Web Links',
      title: pdfLocalization.fontSizingAndScripts,
      apiName: 'GeniusPdfTextSpan.webLink',
      description: pdfLocalization.mixedRichTextFontSizesTogetherDesc,
      icon: Icons.format_size_outlined,
      usageCode: dartUsageCode,
    );
  }
}
