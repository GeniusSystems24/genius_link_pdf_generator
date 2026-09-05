import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Invoice Header**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class InvoiceHeaderExampleScreen extends StatelessWidget {
  const InvoiceHeaderExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:flutter/material.dart' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Focused document builder for the **Invoice Header** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `invoice_header_example_screen.dart` and displayed as **Dart usage code**.
class InvoiceHeaderDemoBuilder extends GeniusPdfDocumentBuilder {
  InvoiceHeaderDemoBuilder(super.config);

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
    _buildInvoiceHeader();
  }

  void _buildInvoiceHeader() {
    newPage();
    addSectionDivider(
      title: config.isRTL ? 'فاتورة ضريبية - Invoice' : 'Invoice Header',
      spacing: 10,
    );
    addSpace(20);
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Tax Invoice',
        titleAr: 'فاتورة ضريبية',
        subtitle: 'Invoice #INV-2024-001',
        subtitleAr: 'فاتورة رقم #INV-2024-001',
        company: _companyInfo,
        printDate: DateTime.now(),
        documentNumber: 'INV-2024-001',
        documentNumberLabel: 'Invoice No',
        documentNumberLabelAr: 'رقم الفاتورة',
        style: GeniusPdfReportHeaderStyle.invoice(),
      ),
      spacing: 15,
    );
    addSpace(20);
    _addExplanation(
      'Standard invoice header with logo (if provided), company info on one side, and title/document info on the other.',
      'رأس فاتورة قياسي مع شعار (إذا توفر)، معلومات الشركة في جانب، والعنوان/معلومات المستند في الجانب الآخر.',
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
      componentId: 'headers_invoice',
      category: 'Components / Core PDF Components / Headers',
      title: pdfLocalization.invoiceHeader,
      apiName: 'GeniusPdfReportHeader',
      description: pdfLocalization.standardInvoiceReportHeaderCompanyDesc,
      icon: Icons.receipt_long_outlined,
      usageCode: dartUsageCode,
    );
  }
}
