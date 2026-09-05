import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/components/headers_invoice_header_demo_builder.dart';
import 'package:genius_pdf_example/features/getting_started/presentation/widgets/s00_baseline_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S00 screen for the Report Header Baseline regression example.
///
/// The `Dart usage code` panel contains the exact builder source executed by
/// this screen when **Run example** is pressed.
class S00ReportHeaderBaselineExampleScreen extends StatelessWidget {
  const S00ReportHeaderBaselineExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
  /// Info groups for structured header content
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
    return S00BaselineExampleDetailScreen(
      title: pdfLocalization.reportHeaderBaseline,
      apiName: 'InvoiceHeaderDemoBuilder',
      description: pdfLocalization.verifyHeaderBlocksBilingualTextDesc,
      icon: Icons.view_headline_outlined,
      builderFactory: (config) => InvoiceHeaderDemoBuilder(config),
      usageCode: dartUsageCode,
      expectedLtr: 'Header blocks, bilingual text and metadata must remain visible and unclipped.',
      expectedRtl: 'Header blocks, bilingual text and metadata must remain visible and unclipped.',
      fileName: 's00_report_header.pdf',
    );
  }
}
