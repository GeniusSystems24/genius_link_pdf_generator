import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Demonstrates v2.11.0 PdfTextWebLink integration and rich text improvements.
///
/// This example showcases:
/// - **PdfTextWebLink** — Proper clickable hyperlinks in PDF
/// - **`GeniusPdfTextSpan.webLink`** — Factory constructor for web links
/// - **`GeniusPdfRichTextBuilder.webLink()`** — Fluent builder method
/// - **`String.toWebLinkSpan()`** — Extension method for quick link creation
/// - **Font sizing** — `span.fontSize` now renders at the correct size
/// - **Superscript/subscript sizing** — Correct font scaling
///
/// ## Example
/// ```dart
/// final doc = WebLinkDemoBuilder(config);
/// final bytes = doc.generate();
/// doc.dispose();
/// ```
class WebLinkDemoBuilder extends GeniusPdfDocumentBuilder {
  WebLinkDemoBuilder(super.config);

  @override
  void build() {
    addHeader(
      title: isRTL
          ? 'عرض الروابط والنص المنسق — الإصدار 2.11.0'
          : 'Web Links & Rich Text Demo — v2.11.0',
    );
    addFooter(
      showPageNumber: true,
      printTime: DateTime.now().toString().substring(0, 19),
    );

    newPage();

    // ── Section 1: PdfTextWebLink via Builder ──────────────────
    addSectionDivider(
      title: isRTL
          ? '1. روابط الويب عبر الباني'
          : '1. Web Links via Builder',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(isRTL ? 'زر ' : 'Visit ')
          .webLink('Google', 'https://www.google.com')
          .text(isRTL ? ' أو ' : ' or ')
          .webLink(
            'GitHub',
            'https://github.com',
            color: const Color(0xFF6E5494),
          )
          .text(isRTL ? ' لمزيد من المعلومات.' : ' for more info.')
          .build(),
      spacing: 5,
    );

    addSpace(5);

    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(isRTL ? 'قراءة ' : 'Read the ')
          .webLink(
            isRTL ? 'التوثيق' : 'documentation',
            'https://help.syncfusion.com',
            color: const Color(0xFF0D47A1),
          )
          .text(isRTL ? ' للتفاصيل.' : ' for details.')
          .build(),
      spacing: 5,
    );

    addSpace(15);

    // ── Section 2: Factory Constructor ─────────────────────────
    addSectionDivider(
      title: isRTL
          ? '2. المُنشئ المباشر'
          : '2. Factory Constructor',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichText(
        config: config,
        spans: [
          GeniusPdfTextSpan(
            isRTL ? 'التقرير متاح على ' : 'Report available at ',
          ),
          GeniusPdfTextSpan.webLink(
            isRTL ? 'بوابة التقارير' : 'Reports Portal',
            url: 'https://reports.example.com',
            color: const Color(0xFF1565C0),
          ),
          GeniusPdfTextSpan('.'),
        ],
      ),
      spacing: 5,
    );

    addSpace(15);

    // ── Section 3: String Extension ────────────────────────────
    addSectionDivider(
      title: isRTL
          ? '3. امتداد النص'
          : '3. String Extension',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichText(
        config: config,
        spans: [
          GeniusPdfTextSpan(isRTL ? 'انقر ' : 'Click '),
          (isRTL ? 'هنا' : 'here')
              .toWebLinkSpan('https://example.com'),
          GeniusPdfTextSpan(
            isRTL ? ' للتحميل.' : ' to download.',
          ),
        ],
      ),
      spacing: 5,
    );

    addSpace(15);

    // ── Section 4: Font Sizing Fix ─────────────────────────────
    addSectionDivider(
      title: isRTL
          ? '4. إصلاح حجم الخط'
          : '4. Font Size Fix',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichText(
        config: config,
        spans: [
          GeniusPdfTextSpan(
            isRTL ? 'حجم عادي، ' : 'Normal size, ',
          ),
          GeniusPdfTextSpan(
            isRTL ? 'حجم كبير، ' : 'Large size, ',
            fontSize: 18,
            color: const Color(0xFFE65100),
          ),
          GeniusPdfTextSpan(
            isRTL ? 'حجم صغير، ' : 'Small size, ',
            fontSize: 8,
            color: const Color(0xFF1B5E20),
          ),
          GeniusPdfTextSpan(
            isRTL ? 'حجم عادي مرة أخرى.' : 'Normal again.',
          ),
        ],
      ),
      spacing: 5,
    );

    addSpace(10);

    // Superscript / subscript demo
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(isRTL ? 'الماء: ' : 'Water: ')
          .text('H')
          .subscript('2')
          .text('O')
          .text(isRTL ? '  |  الطاقة: ' : '  |  Energy: ')
          .text('E = mc')
          .superscript('2')
          .build(),
      spacing: 5,
    );

    addSpace(15);

    // ── Section 5: Mixed Links and Styles ──────────────────────
    addSectionDivider(
      title: isRTL
          ? '5. روابط مختلطة مع أنماط'
          : '5. Mixed Links with Styles',
      spacing: 10,
    );
    addSpace(10);

    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold(isRTL ? 'هام: ' : 'Important: ')
          .text(isRTL ? 'يرجى مراجعة ' : 'Please review the ')
          .webLink(
            isRTL ? 'الشروط والأحكام' : 'Terms & Conditions',
            'https://example.com/terms',
          )
          .text(isRTL ? ' و ' : ' and ')
          .webLink(
            isRTL ? 'سياسة الخصوصية' : 'Privacy Policy',
            'https://example.com/privacy',
            color: const Color(0xFF00695C),
          )
          .text(isRTL ? ' قبل المتابعة.' : ' before proceeding.')
          .build(),
      spacing: 5,
    );

    addSpace(10);

    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(isRTL ? 'للدعم: ' : 'For support: ')
          .webLink(
            'support@example.com',
            'mailto:support@example.com',
            color: const Color(0xFFD84315),
          )
          .text(isRTL ? ' أو اتصل بـ ' : ' or call ')
          .bold('+966-555-1234')
          .build(),
      spacing: 5,
    );

    addSpace(15);

    addLine(
      isRTL
          ? 'عدد الصفحات: $pageCount'
          : 'Total pages: $pageCount',
      font: config.boldFont,
      topMargin: 10,
    );
  }
}
