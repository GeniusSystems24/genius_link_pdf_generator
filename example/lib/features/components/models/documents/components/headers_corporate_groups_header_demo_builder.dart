import 'package:flutter/material.dart' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Corporate Header & Info Groups** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `corporate_groups_header_example_screen.dart` and displayed as **Dart usage code**.
class CorporateGroupsHeaderDemoBuilder extends GeniusPdfDocumentBuilder {
  CorporateGroupsHeaderDemoBuilder(super.config);

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
  late final _registrationGroup = GeniusPdfHeaderInfoGroup.registration(
    vatNumber: '300123456789003',
    crNumber: '1010123456',
    licenseNumber: 'LIC-2025-00123',
  );

  late final _contactGroup = GeniusPdfHeaderInfoGroup.contact(
    phone: '+966 11 123 4567',
    email: 'info@alamal.com',
    website: 'www.alamal.com',
  );

  @override
  void build() {
    _buildCorporateWithGroupsHeader();
  }

  void _buildCorporateWithGroupsHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL
          ? 'رأس مؤسسي مع مجموعات - Corporate with Groups'
          : 'Corporate Header with Info Groups',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Annual Report',
        titleAr: 'التقرير السنوي',
        subtitle: 'Fiscal Year 2025',
        subtitleAr: 'السنة المالية 2025',
        company: _companyInfo,
        printDate: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.corporate(
          primaryColor: const Color(0xFF1565C0),
          showAccentLine: true,
        ),
        infoGroups: [_registrationGroup, _contactGroup],
        layout: GeniusPdfReportHeaderLayout.standard,
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Corporate header using info groups for structured display of registration '
      'and contact information. Groups can be customized with titles and styling.',
      'رأس مؤسسي يستخدم مجموعات المعلومات للعرض المنظم لمعلومات التسجيل '
      'والتواصل. يمكن تخصيص المجموعات بالعناوين والتنسيق.',
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
