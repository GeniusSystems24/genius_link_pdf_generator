import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
}
