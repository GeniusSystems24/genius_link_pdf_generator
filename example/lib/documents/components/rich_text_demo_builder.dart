import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Rich Text demo PDF document with extended examples.
class RichTextDemoBuilder extends GeniusPdfDocumentBuilder {
  RichTextDemoBuilder(super.config);

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

    // Link line
    addRichText(
      GeniusPdfRichTextBuilder(
        config: config,
      )
          .text(config.isRTL ? 'زر الموقع: ' : 'Visit site: ')
          .link(
            config.isRTL ? 'موقعنا' : 'our website',
            'https://example.com',
            color: const Color(0xFF0D47A1),
          )
          .text(config.isRTL ? ' أو ' : ' or ')
          .link(
            config.isRTL ? 'الدعم' : 'support',
            'https://support.example.com',
            color: const Color(0xFFE65100),
          )
          .build(),
      spacing: 10,
    );

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
