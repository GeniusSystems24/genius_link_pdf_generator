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
}
