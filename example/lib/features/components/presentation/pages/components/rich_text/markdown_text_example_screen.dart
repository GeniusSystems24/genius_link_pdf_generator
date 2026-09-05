import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Markdown Parsing**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class RichTextMarkdownExampleScreen extends StatelessWidget {
  const RichTextMarkdownExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
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
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'rich_text_markdown',
      category: 'Components / Core PDF Components / Rich Text',
      title: pdfLocalization.markdownParsing,
      apiName: 'GeniusPdfRichText',
      description: pdfLocalization.parseLightweightMarkdownFormattedDesc,
      icon: Icons.code_outlined,
      usageCode: dartUsageCode,
    );
  }
}
