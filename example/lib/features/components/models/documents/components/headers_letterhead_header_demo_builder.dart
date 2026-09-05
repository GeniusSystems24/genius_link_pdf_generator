import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Letterhead Header** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `letterhead_header_example_screen.dart` and displayed as **Dart usage code**.
class LetterheadHeaderDemoBuilder extends GeniusPdfDocumentBuilder {
  LetterheadHeaderDemoBuilder(super.config);

  late final _companyInfo = GeniusPdfCompanyInfo(
    name: 'Al-Amal Trading Company',
    nameAr: 'شركة الأمل للتجارة',
    vatNumber: '300123456789003',
    crNumber: '1010123456',
    address: 'King Fahd Road',
    addressAr: 'طريق الملك فهد',
    city: 'Riyadh',
    cityAr: 'الرياض',
    country: 'Saudi Arabia',
    countryAr: 'المملكة العربية السعودية',
    phone: '+966 11 123 4567',
    email: 'info@alamal.com',
  );

  /// Extended company info with more details
  /// Info groups for structured header content
  @override
  void build() {
    _buildLetterheadHeader();
  }

  void _buildLetterheadHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'ورق رسمي - Letterhead' : 'Letterhead Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Official Letter',
        titleAr: 'خطاب رسمي',
        subtitle: 'Reference: REF-2025-001',
        subtitleAr: 'المرجع: REF-2025-001',
        company: _companyInfo,
        printDate: DateTime.now(),
        referenceNumber: 'REF-2025-001',
        referenceLabel: 'Reference',
        referenceLabelAr: 'المرجع',
        layout: GeniusPdfReportHeaderLayout.letterhead,
        style: GeniusPdfReportHeaderStyle.classic(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Classic letterhead style layout suitable for official correspondence '
      'with reference numbers and formal styling.',
      'نمط الورق الرسمي الكلاسيكي مناسب للمراسلات الرسمية '
      'مع أرقام المراجع والتنسيق الرسمي.',
    );
  }

  void _addExplanation(String en, String ar) {
    addLine(
      config.isRTL ? ar : en,
      font: baseFont,
      brush: PdfBrushes.darkGray,
    );
  }
}
