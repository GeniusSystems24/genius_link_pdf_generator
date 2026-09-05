import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Fluent Formatting**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class RichTextFluentFormattingExampleScreen extends StatelessWidget {
  const RichTextFluentFormattingExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Fluent Formatting** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `fluent_formatting_example_screen.dart` and displayed as **Dart usage code**.
class RichTextFluentFormattingDemoBuilder extends GeniusPdfDocumentBuilder {
  RichTextFluentFormattingDemoBuilder(super.config);

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

    // Heading with badge
    addRichText(
      GeniusPdfRichTextBuilder(
        config: config,
      )
          .heading(config.isRTL ? 'ملخص الفاتورة' : 'Invoice Summary')
          .space()
          .badge(
            config.isRTL ? 'مدفوعة' : 'PAID',
            backgroundColor: const Color(0xFF4CAF50),
          )
          .build(),
      spacing: 5,
    );

    // Invoice number line
    addRichText(
      GeniusPdfRichTextBuilder(
        config: config,
      )
          .label(config.isRTL ? 'رقم الفاتورة' : 'Invoice No')
          .separator(': ')
          .bold('#INV-2024-001', color: const Color(0xFF2196F3))
          .build(),
      spacing: 5,
    );

    // Total line with badge
    addRichText(
      GeniusPdfRichTextBuilder(
        config: config,
      )
          .text(config.isRTL ? 'الإجمالي: ' : 'Total: ')
          .currency('34,615.00', symbol: config.isRTL ? 'ر.س' : 'SAR')
          .space()
          .badge(
            config.isRTL ? 'يشمل الضريبة' : 'VAT Included',
            backgroundColor: const Color(0xFF2196F3),
          )
          .build(),
      spacing: 5,
    );

    // Price comparison line
    addRichText(
      GeniusPdfRichTextBuilder(
        config: config,
      )
          .text(config.isRTL ? 'السعر السابق: ' : 'Previous: ')
          .strikethrough('28,500.00')
          .space()
          .positive('34,615.00')
          .superscript('*')
          .build(),
      spacing: 5,
    );

    // Important note line
    addRichText(
      GeniusPdfRichTextBuilder(
        config: config,
      )
          .highlight(config.isRTL ? 'ملاحظة مهمة' : 'Important Note')
          .space()
          .small(
            config.isRTL ? 'شامل الضريبة' : 'Tax inclusive',
            color: const Color(0xFF9E9E9E),
          )
          .build(),
      spacing: 10,
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'rich_text_fluent_formatting',
      category: 'Components / Core PDF Components / Rich Text',
      title: 'Fluent Formatting',
      apiName: 'GeniusPdfRichText',
      description: 'Use GeniusPdfRichTextBuilder for headings, labels, currency, badges, highlights, strike-through, and superscript text.',
      icon: Icons.format_bold_outlined,
      usageCode: dartUsageCode,
    );
  }
}
