import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
}
