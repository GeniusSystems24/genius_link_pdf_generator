import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Minimal Header**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class MinimalHeaderExampleScreen extends StatelessWidget {
  const MinimalHeaderExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:flutter/material.dart' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Minimal Header** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `minimal_header_example_screen.dart` and displayed as **Dart usage code**.
class MinimalHeaderDemoBuilder extends GeniusPdfDocumentBuilder {
  MinimalHeaderDemoBuilder(super.config);

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
    _buildMinimalHeader();
  }

  void _buildMinimalHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'بسيط - Minimal' : 'Minimal Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader.simple(
        config: config,
        title: 'Quick Summary',
        titleAr: 'ملخص سريع',
        subtitle: 'Generated Report',
        subtitleAr: 'تقرير مولد',
        date: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.minimal(
          accentColor: const Color(0xFF424242),
        ),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Simple header with just title, subtitle, and date. No company details. '
      'Ideal for internal reports or quick summaries.',
      'رأس بسيط يحتوي فقط على العنوان والعنوان الفرعي والتاريخ. بدون تفاصيل الشركة. '
      'مثالي للتقارير الداخلية أو الملخصات السريعة.',
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
      componentId: 'headers_minimal',
      category: 'Components / Core PDF Components / Headers',
      title: 'Minimal Header',
      apiName: 'GeniusPdfReportHeader',
      description: 'Minimal report header containing only title, subtitle, and date for lightweight internal reports.',
      icon: Icons.horizontal_rule_outlined,
      usageCode: dartUsageCode,
    );
  }
}
