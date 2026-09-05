import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Markdown Parsing** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `markdown_text_example_screen.dart` and displayed as **Dart usage code**.
class RichTextMarkdownDemoBuilder extends GeniusPdfDocumentBuilder {
  RichTextMarkdownDemoBuilder(super.config);

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

    // Markdown parsed text
    addRichText(
      GeniusPdfRichText(
        spans: GeniusPdfSimpleMarkdownParser.parse(
          config.isRTL
              ? 'هذا **نص عريض** و *مائل* مع `كود` و ~~محذوف~~'
              : 'This is **bold** and *italic* with `code` and ~~deleted~~',
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
