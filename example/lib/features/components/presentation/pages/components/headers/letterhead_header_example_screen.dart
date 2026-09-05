import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Letterhead Header**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class LetterheadHeaderExampleScreen extends StatelessWidget {
  const LetterheadHeaderExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:flutter/material.dart' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
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
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'headers_letterhead',
      category: 'Components / Core PDF Components / Headers',
      title: pdfLocalization.letterheadHeader,
      apiName: 'GeniusPdfReportHeader',
      description: pdfLocalization.classicLetterheadLayoutFormalDesc,
      icon: Icons.description_outlined,
      usageCode: dartUsageCode,
    );
  }
}
