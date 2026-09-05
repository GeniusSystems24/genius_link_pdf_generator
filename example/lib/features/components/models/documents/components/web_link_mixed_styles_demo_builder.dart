import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Mixed Links & Styles** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `web_link_mixed_styles_example_screen.dart` and displayed as **Dart usage code**.
class WebLinkMixedStylesDemoBuilder extends GeniusPdfDocumentBuilder {
  WebLinkMixedStylesDemoBuilder(super.config);

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

    // ── Section 5: Mixed Links and Styles ──────────────────────
    addSectionDivider(
      title: isRTL ? '5. روابط مختلطة مع أنماط' : '5. Mixed Links with Styles',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold(isRTL ? 'هام: ' : 'Important: ')
          .text(isRTL ? 'يرجى مراجعة ' : 'Please review the ')
          .webLink(
            isRTL ? 'الشروط والأحكام' : 'Terms & Conditions',
            'https://example.com/terms',
          )
          .text(isRTL ? ' و ' : ' and ')
          .webLink(
            isRTL ? 'سياسة الخصوصية' : 'Privacy Policy',
            'https://example.com/privacy',
            color: const Color(0xFF00695C),
          )
          .text(isRTL ? ' قبل المتابعة.' : ' before proceeding.')
          .build(),
      spacing: 5,
    );

    addSpace(10);

    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(isRTL ? 'للدعم: ' : 'For support: ')
          .webLink(
            'support@example.com',
            'mailto:support@example.com',
            color: const Color(0xFFD84315),
          )
          .text(isRTL ? ' أو اتصل بـ ' : ' or call ')
          .bold('+966-555-1234')
          .build(),
      spacing: 5,
    );

    addSpace(15);

    addLine(
      isRTL ? 'عدد الصفحات: $pageCount' : 'Total pages: $pageCount',
      font: config.boldFont,
      topMargin: 10,
    );
  }
}
