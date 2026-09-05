import 'dart:ui' show Color;
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
}
