import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Colored Markdown Links** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `colored_links_example_screen.dart` and displayed as **Dart usage code**.
class RichTextColoredLinksDemoBuilder extends GeniusPdfDocumentBuilder {
  RichTextColoredLinksDemoBuilder(super.config);

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

    // Colored links
    addRichText(
      GeniusPdfRichText(
        spans: GeniusPdfSimpleMarkdownParser.parse(
          config.isRTL
              ? '**رابط ملون:** [الأحمر](https://red.example.com){#E53935} و [الأخضر](https://green.example.com){#43A047}'
              : '**Colored link:** [red link](https://red.example.com){#E53935} and [green link](https://green.example.com){#43A047}',
        ),
        baseFont: baseFont,
        boldFont: config.boldFont,
        isRTL: config.isRTL,
        config: config,
      ),
      spacing: 10,
    );
  }
}
