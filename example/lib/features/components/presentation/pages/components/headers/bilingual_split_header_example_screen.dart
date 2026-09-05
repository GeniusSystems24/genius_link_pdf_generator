import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Bilingual Split Header**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class BilingualSplitHeaderExampleScreen extends StatelessWidget {
  const BilingualSplitHeaderExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:flutter/material.dart' show Color;
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
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'headers_bilingual_split',
      category: 'Components / Core PDF Components / Headers',
      title: 'Bilingual Split Header',
      apiName: 'GeniusPdfReportHeader',
      description: 'English/Arabic split header with centered identity and stable positioning in both directions.',
      icon: Icons.translate_outlined,
      usageCode: dartUsageCode,
    );
  }
}
