import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
}
