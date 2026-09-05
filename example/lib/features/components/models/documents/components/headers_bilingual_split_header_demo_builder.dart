import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Bilingual Split Header** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `bilingual_split_header_example_screen.dart` and displayed as **Dart usage code**.
class BilingualSplitHeaderDemoBuilder extends GeniusPdfDocumentBuilder {
  BilingualSplitHeaderDemoBuilder(super.config);

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
    _buildBilingualSplitHeader();
  }

  void _buildBilingualSplitHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'مزدوج اللغة - Bilingual' : 'Bilingual Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader.bilingualSplit(
        config: config,
        title: 'Trial Balance',
        titleAr: 'ميزان المراجعة',
        subtitle: 'As of December 31, 2025',
        subtitleAr: 'كما في 31 ديسمبر 2025',
        company: _companyInfo,
        date: DateTime.now(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Split layout: English info on left, Arabic info on right, logo centered. '
      'Fixed in v2.12.7 to work correctly with both RTL and LTR configurations.',
      'تخطيط مقسم: المعلومات الإنجليزية يساراً، العربية يميناً، والشعار في المنتصف. '
      'تم إصلاحه في v2.12.7 ليعمل بشكل صحيح مع كل من إعدادات RTL و LTR.',
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
