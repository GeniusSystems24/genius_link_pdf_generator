import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Auto-Detected Links**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class RichTextAutoDetectedLinksExampleScreen extends StatelessWidget {
  const RichTextAutoDetectedLinksExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Focused document builder for the **Auto-Detected Links** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `auto_detected_links_example_screen.dart` and displayed as **Dart usage code**.
class RichTextAutoDetectedLinksDemoBuilder extends GeniusPdfDocumentBuilder {
  RichTextAutoDetectedLinksDemoBuilder(super.config);

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

    // Auto-detected URLs and emails
    addRichText(
      GeniusPdfRichText(
        spans: GeniusPdfSimpleMarkdownParser.parse(
          config.isRTL
              ? 'تواصل عبر info@example.com أو https://example.com'
              : 'Contact info@example.com or visit https://example.com',
          config: const GeniusPdfMarkdownConfig(
            linkColor: Color(0xFF1565C0),
            autoDetectUrls: true,
            autoDetectEmails: true,
            autoLinkColor: Color(0xFF00796B),
          ),
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
      componentId: 'rich_text_auto_links',
      category: 'Components / Core PDF Components / Rich Text',
      title: pdfLocalization.autoDetectedLinks,
      apiName: 'GeniusPdfRichText',
      description: pdfLocalization.automaticallyDetectUrlsEmailDesc,
      icon: Icons.alternate_email_outlined,
      usageCode: dartUsageCode,
    );
  }
}
