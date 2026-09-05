import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Saudi Style Header**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class SaudiStyleHeaderExampleScreen extends StatelessWidget {
  const SaudiStyleHeaderExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:flutter/material.dart' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Focused document builder for the **Saudi Style Header** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `saudi_style_header_example_screen.dart` and displayed as **Dart usage code**.
class SaudiStyleHeaderDemoBuilder extends GeniusPdfDocumentBuilder {
  SaudiStyleHeaderDemoBuilder(super.config);

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
    _buildSaudiStyleHeader();
  }

  void _buildSaudiStyleHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'النمط السعودي - Saudi Style' : 'Saudi Style Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Commercial License',
        titleAr: 'الرخصة التجارية',
        subtitle: 'Ministry of Commerce',
        subtitleAr: 'وزارة التجارة',
        company: _fullCompanyInfo,
        printDate: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.saudi(
          primaryColor: const Color(0xFF006C35),
        ),
        layout: GeniusPdfReportHeaderLayout.standard,
        showBilingualTitle: true,
        bilingualTitleOrder: GeniusPdfBilingualOrder.arabicFirst,
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Saudi-themed header with green color scheme, top and bottom borders, '
      'and Arabic-first bilingual titles suitable for official Saudi documents.',
      'رأس بالنمط السعودي مع مخطط الألوان الأخضر، حدود علوية وسفلية، '
      'وعناوين ثنائية اللغة بالعربية أولاً مناسبة للمستندات السعودية الرسمية.',
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
      componentId: 'headers_saudi_style',
      category: 'Components / Core PDF Components / Headers',
      title: pdfLocalization.saudiStyleHeader,
      apiName: 'GeniusPdfReportHeader',
      description: pdfLocalization.officialSaudiThemedBilingualHeaderDesc,
      icon: Icons.account_balance_outlined,
      usageCode: dartUsageCode,
    );
  }
}
