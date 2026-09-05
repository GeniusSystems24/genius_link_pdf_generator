import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
}
