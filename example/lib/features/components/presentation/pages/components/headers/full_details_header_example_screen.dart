import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Full Company Details**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class FullDetailsHeaderExampleScreen extends StatelessWidget {
  const FullDetailsHeaderExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:flutter/material.dart' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Focused document builder for the **Full Company Details** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `full_details_header_example_screen.dart` and displayed as **Dart usage code**.
class FullDetailsHeaderDemoBuilder extends GeniusPdfDocumentBuilder {
  FullDetailsHeaderDemoBuilder(super.config);

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
    _buildFullDetailsHeader();
  }

  void _buildFullDetailsHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL
          ? 'تفاصيل كاملة - Full Details'
          : 'Full Company Details Header',
      spacing: 10,
    );
    addSpace(20);

    // Custom info groups with titles
    final customGroups = [
      GeniusPdfHeaderInfoGroup.custom(
        title: 'Registration Info',
        titleAr: 'معلومات التسجيل',
        items: [
          GeniusPdfHeaderInfoItem(
            label: 'VAT No',
            labelAr: 'الرقم الضريبي',
            value: '300123456789003',
          ),
          GeniusPdfHeaderInfoItem(
            label: 'CR No',
            labelAr: 'السجل التجاري',
            value: '1010123456',
          ),
          GeniusPdfHeaderInfoItem(
            label: 'License',
            labelAr: 'الترخيص',
            value: 'LIC-2025-00123',
          ),
        ],
        showTitle: true,
      ),
      GeniusPdfHeaderInfoGroup.custom(
        title: 'Contact',
        titleAr: 'التواصل',
        items: [
          GeniusPdfHeaderInfoItem(
            label: 'Phone',
            labelAr: 'الهاتف',
            value: '+966 11 123 4567',
          ),
          GeniusPdfHeaderInfoItem(
            label: 'Email',
            labelAr: 'البريد',
            value: 'info@alamal.com',
          ),
          GeniusPdfHeaderInfoItem(
            label: 'Website',
            labelAr: 'الموقع',
            value: 'www.alamal.com',
          ),
        ],
        showTitle: true,
      ),
    ];

    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Comprehensive Report',
        titleAr: 'تقرير شامل',
        subtitle: 'With All Company Details',
        subtitleAr: 'مع جميع تفاصيل الشركة',
        company: _fullCompanyInfo,
        printDate: DateTime.now(),
        documentNumber: 'DOC-2025-001',
        documentNumberLabel: 'Document No',
        documentNumberLabelAr: 'رقم المستند',
        style: GeniusPdfReportHeaderStyle.modern(),
        infoGroups: customGroups,
        showPageNumber: true,
        pageNumber: 1,
        totalPages: 10,
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Header with full company details, custom info groups with section titles, '
      'document number, page numbers, and modern styling. '
      'Demonstrates all available header customization options.',
      'رأس مع تفاصيل الشركة الكاملة، مجموعات معلومات مخصصة مع عناوين الأقسام، '
      'رقم المستند، أرقام الصفحات، والتنسيق الحديث. '
      'يوضح جميع خيارات تخصيص الرأس المتاحة.',
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
      componentId: 'headers_full_details',
      category: 'Components / Core PDF Components / Headers',
      title: pdfLocalization.fullCompanyDetails,
      apiName: 'GeniusPdfReportHeader',
      description: pdfLocalization.fullDetailCompanyHeaderCustomDesc,
      icon: Icons.domain_outlined,
      usageCode: dartUsageCode,
    );
  }
}
