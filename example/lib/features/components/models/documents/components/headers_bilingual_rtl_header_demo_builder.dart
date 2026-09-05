import 'package:flutter/material.dart' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Bilingual RTL Header** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `bilingual_rtl_header_example_screen.dart` and displayed as **Dart usage code**.
class BilingualRtlHeaderDemoBuilder extends GeniusPdfDocumentBuilder {
  BilingualRtlHeaderDemoBuilder(super.config);
  /// Extended company info with more details
  late final _fullCompanyInfo = GeniusPdfCompanyInfo(
    name: 'Al-Amal Trading Company',
    nameAr: 'شركة الأمل للتجارة',
    vatNumber: '300123456789003',
    crNumber: '1010123456',
    licenseNumber: 'LIC-2025-00123',
    address: 'King Fahd Road, Building 45',
    addressAr: 'طريق الملك فهد، مبنى 45',
    addressLine2: 'Floor 3, Office 301',
    addressLine2Ar: 'الطابق 3، مكتب 301',
    city: 'Riyadh',
    cityAr: 'الرياض',
    postalCode: '12345',
    country: 'Saudi Arabia',
    countryAr: 'المملكة العربية السعودية',
    phone: '+966 11 123 4567',
    phone2: '+966 11 765 4321',
    fax: '+966 11 123 4568',
    email: 'info@alamal.com',
    email2: 'support@alamal.com',
    website: 'www.alamal.com',
    slogan: 'Excellence in Trading',
    sloganAr: 'التميز في التجارة',
  );

  /// Info groups for structured header content
  @override
  void build() {
    _buildBilingualSplitRTLHeader();
  }

  void _buildBilingualSplitRTLHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL
          ? 'ثنائي اللغة (RTL) - Bilingual RTL'
          : 'Bilingual Header (RTL Config)',
      spacing: 10,
    );
    addSpace(20);

    // Create RTL config for this header specifically
    addReportHeader(
      GeniusPdfReportHeader.bilingualSplit(
        config: config,
        title: 'Financial Statement',
        titleAr: 'القوائم المالية',
        subtitle: 'For the Year Ended December 31, 2025',
        subtitleAr: 'للسنة المنتهية في 31 ديسمبر 2025',
        company: _fullCompanyInfo,
        date: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.bilingualSplit(
          primaryColor: const Color(0xFF006C35),
          accentColor: const Color(0xFF004D26),
        ),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Bilingual split header with full company details and Saudi green theme. '
      'The layout maintains correct positioning regardless of global RTL setting.',
      'رأس ثنائي اللغة مع تفاصيل الشركة الكاملة والنمط السعودي الأخضر. '
      'يحافظ التخطيط على الموضع الصحيح بغض النظر عن إعداد RTL العام.',
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
