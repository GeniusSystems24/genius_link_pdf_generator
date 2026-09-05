import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Footer-Edge Continuation**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class RichTextKeepTogetherExampleScreen extends StatelessWidget {
  const RichTextKeepTogetherExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Focused document builder for the **Footer-Edge Continuation** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `rich_text_keep_together_example_screen.dart` and displayed as **Dart usage code**.
class RichTextKeepTogetherDemoBuilder extends GeniusPdfDocumentBuilder {
  RichTextKeepTogetherDemoBuilder(super.config);

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

    addSpace(remainingHeight - 12);
    addRichText(
      GeniusPdfRichTextBuilder(
        config: config,
      )
          .highlight(
            config.isRTL
                ? 'اختبار الاستمرار بعد أسفل الصفحة'
                : 'Footer-edge continuation check',
          )
          .space()
          .text(
            config.isRTL
                ? 'يجب أن ينتقل هذا السطر إلى صفحة جديدة بأمان عندما لا تتبقى مساحة كافية.'
                : 'This line should move to a new page safely when the footer area is too close.',
          )
          .build(),
      spacing: 6,
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'rich_text_keep_together',
      category: 'Components / Core PDF Components / Rich Text',
      title: pdfLocalization.footerEdgeContinuation,
      apiName: 'GeniusPdfRichText',
      description: pdfLocalization.verifyRichTextSafelyContinuesNewPageDesc,
      icon: Icons.vertical_align_bottom_outlined,
      usageCode: dartUsageCode,
    );
  }
}
