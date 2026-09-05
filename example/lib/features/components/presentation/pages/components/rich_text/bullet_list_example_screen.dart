import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Nested Bullet List**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class RichTextBulletListExampleScreen extends StatelessWidget {
  const RichTextBulletListExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Focused document builder for the **Nested Bullet List** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `bullet_list_example_screen.dart` and displayed as **Dart usage code**.
class RichTextBulletListDemoBuilder extends GeniusPdfDocumentBuilder {
  RichTextBulletListDemoBuilder(super.config);

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

    // Bullet list
    addBulletList(
      GeniusPdfBulletList(
        items: [
          GeniusPdfBulletItem.simple(
            config.isRTL ? 'خدمات استشارية' : 'Consulting services',
          ),
          GeniusPdfBulletItem.simple(
            config.isRTL ? 'تطوير برمجيات' : 'Software development',
          ),
          GeniusPdfBulletItem(
            text: config.isRTL ? 'الصيانة' : 'Maintenance',
            subItems: [
              GeniusPdfBulletItem.simple(
                config.isRTL ? 'صيانة شهرية' : 'Monthly maintenance',
              ),
              GeniusPdfBulletItem.simple(
                config.isRTL ? 'دعم فني' : 'Technical support',
              ),
            ],
          ),
        ],
        config: config,
        style: GeniusPdfBulletStyle.disc,
        baseFont: baseFont,
        boldFont: config.boldFont,
        isRTL: config.isRTL,
      ),
      spacing: 15,
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'rich_text_bullet_list',
      category: 'Components / Core PDF Components / Rich Text',
      title: pdfLocalization.nestedBulletList,
      apiName: 'GeniusPdfRichText',
      description: pdfLocalization.nestedBulletContentGeniusPdfBulletDesc,
      icon: Icons.format_list_bulleted_outlined,
      usageCode: dartUsageCode,
    );
  }
}
