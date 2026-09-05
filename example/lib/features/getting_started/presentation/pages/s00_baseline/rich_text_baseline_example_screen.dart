import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/components/rich_text_fluent_formatting_demo_builder.dart';
import 'package:genius_pdf_example/features/getting_started/presentation/widgets/s00_baseline_example_detail_screen.dart';

/// Dedicated S00 screen for the RichText Baseline regression example.
///
/// The `Dart usage code` panel contains the exact builder source executed by
/// this screen when **Run example** is pressed.
class S00RichTextBaselineExampleScreen extends StatelessWidget {
  const S00RichTextBaselineExampleScreen({super.key});

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
    return S00BaselineExampleDetailScreen(
      title: 'RichText Baseline',
      apiName: 'RichTextFluentFormattingDemoBuilder',
      description: 'Verify rich-text wrapping, inline formatting, and layout stability using the focused fluent-formatting builder.',
      icon: Icons.text_fields_outlined,
      builderFactory: (config) => RichTextFluentFormattingDemoBuilder(config),
      usageCode: dartUsageCode,
      expectedLtr: 'Rich text must wrap without clipping or overlap.',
      expectedRtl: 'Rich text must wrap without clipping or overlap.',
      fileName: 's00_rich_text.pdf',
    );
  }
}
