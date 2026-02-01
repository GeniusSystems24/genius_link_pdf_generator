import 'dart:typed_data';
import 'dart:ui' show Color, Rect;

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

Future<Uint8List> buildComponentDemoBytes({
  required String component,
  required GeniusPdfConfig config,
}) async {
  final GeniusPdfDocumentBuilder builder;
  switch (component) {
    case 'data_grid':
      builder = _DataGridDemoBuilder(config);
      break;
    case 'rich_text':
      builder = _RichTextDemoBuilder(config);
      break;
    case 'info_box':
      builder = _InfoBoxDemoBuilder(config);
      break;
    case 'headers':
      builder = _HeadersDemoBuilder(config);
      break;
    case 'summary':
      builder = _SummaryDemoBuilder(config);
      break;
    default:
      throw ArgumentError('Unsupported component: $component');
  }

  final bytes = builder.generate();
  builder.dispose();
  return Uint8List.fromList(bytes);
}

/// Builds a Data Grid demo PDF document with extended details.
class _DataGridDemoBuilder extends GeniusPdfDocumentBuilder {
  _DataGridDemoBuilder(super.config);

  bool get _isRTL => config.isRTL;

  @override
  void build() {
    newPage();
    final page = currentPage;
    final pageSize = page.getClientSize();
    final bFont = config.boldFont;

    _drawTitle(
      page,
      bFont,
      _isRTL
          ? 'جدول البيانات - GeniusPdfDataGrid'
          : 'Data Grid - GeniusPdfDataGrid',
    );

    final subtitle = _isRTL
        ? 'مثال عملي على جدول فواتير مع إجمالي، وملاحظات، ومراجعة تلقائية.'
        : 'Practical invoice table with totals, notes, and validation hints.';
    page.graphics.drawString(
      subtitle,
      baseFont,
      bounds: Rect.fromLTWH(20, 52, pageSize.width - 40, 18),
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: _isRTL
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    );

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        GeniusPdfGridColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الكود',
          width: 60,
        ),
        GeniusPdfGridColumn(
          id: 'desc',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusPdfGridColumn.numeric(
          id: 'qty',
          title: 'Qty',
          titleAr: 'الكمية',
        ),
        GeniusPdfGridColumn.currency(
          id: 'price',
          title: 'Price',
          titleAr: 'السعر',
          currencySymbol: _isRTL ? 'ر.س' : 'SAR',
        ),
        GeniusPdfGridColumn.currency(
          id: 'total',
          title: 'Total',
          titleAr: 'الإجمالي',
          currencySymbol: _isRTL ? 'ر.س' : 'SAR',
        ),
      ],
      rows: [
        GeniusPdfGridRow(cells: {
          'code': '001',
          'desc': _isRTL ? 'منتج أول' : 'First Product',
          'qty': '10',
          'price': '100.00',
          'total': '1,000.00',
        }),
        GeniusPdfGridRow(cells: {
          'code': '002',
          'desc': _isRTL ? 'منتج ثاني' : 'Second Product',
          'qty': '5',
          'price': '200.00',
          'total': '1,000.00',
        }),
        GeniusPdfGridRow(cells: {
          'code': '003',
          'desc': _isRTL ? 'منتج ثالث' : 'Third Product',
          'qty': '8',
          'price': '150.00',
          'total': '1,200.00',
        }),
        GeniusPdfGridRow(cells: {
          'code': '004',
          'desc': _isRTL ? 'خدمة استشارية' : 'Consulting Service',
          'qty': '3',
          'price': '500.00',
          'total': '1,500.00',
        }),
        GeniusPdfGridRow(cells: {
          'code': '005',
          'desc': _isRTL ? 'دعم فني' : 'Support Package',
          'qty': '1',
          'price': '900.00',
          'total': '900.00',
        }),
        GeniusPdfGridRow.total({
          'desc': _isRTL ? 'الإجمالي قبل الضريبة' : 'Subtotal',
          'total': '5,600.00',
        }),
      ],
      style: GeniusPdfGridStyle.corporate(),
    );

    grid.draw(
      page: page,
      bounds: Rect.fromLTWH(20, 80, pageSize.width - 40, 300),
    );

    final noteBox = GeniusPdfInfoBox(
      config: config,
      title: _isRTL ? 'ملاحظة' : 'Note',
      titleAr: 'ملاحظة',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: _isRTL ? 'المراجعة' : 'Validation',
          labelAr: 'المراجعة',
          value: _isRTL
              ? 'تم التحقق من الأسعار والكميات تلقائياً.'
              : 'Prices and quantities validated automatically.',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.info(),
    );

    noteBox.draw(
      page: page,
      bounds: Rect.fromLTWH(20, 395, pageSize.width - 40, 70),
    );
  }
}

/// Builds a Rich Text demo PDF document with extended examples.
class _RichTextDemoBuilder extends GeniusPdfDocumentBuilder {
  _RichTextDemoBuilder(super.config);

  bool get _isRTL => config.isRTL;

  @override
  void build() {
    newPage();
    final page = currentPage;
    final pageSize = page.getClientSize();
    final bFont = config.boldFont;
    final w = pageSize.width - 40;

    _drawTitle(
      page,
      bFont,
      _isRTL ? 'نص منسق - GeniusPdfRichText' : 'Rich Text - GeniusPdfRichText',
    );

    double yOffset = 70;

    final heading = GeniusPdfRichTextBuilder(
      config: config,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
    )
        .heading(_isRTL ? 'ملخص الفاتورة' : 'Invoice Summary')
        .space()
        .badge(_isRTL ? 'مدفوعة' : 'PAID',
            backgroundColor: const Color(0xFF4CAF50))
        .build();
    heading.draw(page: page, bounds: Rect.fromLTWH(20, yOffset, w, 25));

    final invoiceLine = GeniusPdfRichTextBuilder(
      config: config,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
    )
        .label(_isRTL ? 'رقم الفاتورة' : 'Invoice No')
        .separator(': ')
        .bold('#INV-2024-001', color: const Color(0xFF2196F3))
        .build();
    invoiceLine.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 30, w, 25));

    final totalLine = GeniusPdfRichTextBuilder(
      config: config,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
    )
        .text(_isRTL ? 'الإجمالي: ' : 'Total: ')
        .currency('34,615.00', symbol: _isRTL ? 'ر.س' : 'SAR')
        .space()
        .badge(_isRTL ? 'يشمل الضريبة' : 'VAT Included',
            backgroundColor: const Color(0xFF2196F3))
        .build();
    totalLine.draw(page: page, bounds: Rect.fromLTWH(20, yOffset + 55, w, 25));

    final priceLine = GeniusPdfRichTextBuilder(
      config: config,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
    )
        .text(_isRTL ? 'السعر السابق: ' : 'Previous: ')
        .strikethrough('28,500.00')
        .space()
        .positive('34,615.00')
        .superscript('*')
        .build();
    priceLine.draw(page: page, bounds: Rect.fromLTWH(20, yOffset + 80, w, 25));

    final noteLine = GeniusPdfRichTextBuilder(
      config: config,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
    )
        .highlight(_isRTL ? 'ملاحظة مهمة' : 'Important Note')
        .space()
        .small(_isRTL ? 'شامل الضريبة' : 'Tax inclusive',
            color: const Color(0xFF9E9E9E))
        .build();
    noteLine.draw(page: page, bounds: Rect.fromLTWH(20, yOffset + 105, w, 25));

    final bulletList = GeniusPdfBulletList(
      items: [
        GeniusPdfBulletItem.simple(
            _isRTL ? 'خدمات استشارية' : 'Consulting services'),
        GeniusPdfBulletItem.simple(
            _isRTL ? 'تطوير برمجيات' : 'Software development'),
        GeniusPdfBulletItem(
          text: _isRTL ? 'الصيانة' : 'Maintenance',
          subItems: [
            GeniusPdfBulletItem.simple(
                _isRTL ? 'صيانة شهرية' : 'Monthly maintenance'),
            GeniusPdfBulletItem.simple(
                _isRTL ? 'دعم فني' : 'Technical support'),
          ],
        ),
      ],
      config: config,
      style: GeniusPdfBulletStyle.disc,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
    );
    bulletList.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 135, w, 120));

    final mdSpans = GeniusPdfSimpleMarkdownParser.parse(
      _isRTL
          ? 'هذا **نص عريض** و *مائل* مع `كود` و ~~محذوف~~'
          : 'This is **bold** and *italic* with `code` and ~~deleted~~',
    );
    final mdRichText = GeniusPdfRichText(
      spans: mdSpans,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
      config: config,
    );
    mdRichText.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 265, w, 25));

    final linkLine = GeniusPdfRichTextBuilder(
      config: config,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
    )
        .text(_isRTL ? 'زر الموقع: ' : 'Visit site: ')
        .link(
          _isRTL ? 'موقعنا' : 'our website',
          'https://example.com',
          color: const Color(0xFF0D47A1),
        )
        .text(_isRTL ? ' أو ' : ' or ')
        .link(
          _isRTL ? 'الدعم' : 'support',
          'https://support.example.com',
          color: const Color(0xFFE65100),
        )
        .build();
    linkLine.draw(page: page, bounds: Rect.fromLTWH(20, yOffset + 295, w, 25));

    final autoSpans = GeniusPdfSimpleMarkdownParser.parse(
      _isRTL
          ? 'تواصل عبر info@example.com أو https://example.com'
          : 'Contact info@example.com or visit https://example.com',
      config: const GeniusPdfMarkdownConfig(
        linkColor: Color(0xFF1565C0),
        autoDetectUrls: true,
        autoDetectEmails: true,
        autoLinkColor: Color(0xFF00796B),
      ),
    );
    final autoRichText = GeniusPdfRichText(
      spans: autoSpans,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
      config: config,
    );
    autoRichText.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 325, w, 25));

    final colorSpans = GeniusPdfSimpleMarkdownParser.parse(
      _isRTL
          ? '**رابط ملون:** [الأحمر](https://red.example.com){#E53935} و [الأخضر](https://green.example.com){#43A047}'
          : '**Colored link:** [red link](https://red.example.com){#E53935} and [green link](https://green.example.com){#43A047}',
    );
    final colorRichText = GeniusPdfRichText(
      spans: colorSpans,
      baseFont: baseFont,
      boldFont: bFont,
      isRTL: _isRTL,
      config: config,
    );
    colorRichText.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 355, w, 25));
  }
}

/// Builds an Info Box demo PDF document with extended details.
class _InfoBoxDemoBuilder extends GeniusPdfDocumentBuilder {
  _InfoBoxDemoBuilder(super.config);

  bool get _isRTL => config.isRTL;

  @override
  void build() {
    newPage();
    final page = currentPage;
    final pageSize = page.getClientSize();
    final bFont = config.boldFont;

    _drawTitle(
      page,
      bFont,
      _isRTL
          ? 'صندوق المعلومات - GeniusPdfInfoBox'
          : 'Info Box - GeniusPdfInfoBox',
    );

    double yOffset = 70;

    final customerBox = GeniusPdfInfoBox(
      config: config,
      title: 'Customer Info',
      titleAr: 'بيانات العميل',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Name',
          labelAr: 'الاسم',
          value: _isRTL ? 'أحمد محمد' : 'Ahmed Mohammed',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Phone',
          labelAr: 'الهاتف',
          value: '+966 50 123 4567',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Email',
          labelAr: 'البريد',
          value: 'ahmed@example.com',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Address',
          labelAr: 'العنوان',
          value: _isRTL ? 'الرياض، السعودية' : 'Riyadh, Saudi Arabia',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
    );

    final companyBox = GeniusPdfInfoBox.company(
        companyName: _isRTL ? 'شركة الأمل للتجارة' : 'Al-Amal Trading Co.',
        taxNumber: '300123456789003',
        commercialReg: '1010123456',
        address: _isRTL
            ? 'الرياض، المملكة العربية السعودية'
            : 'Riyadh, Saudi Arabia',
        phone: '+966 11 123 4567',
        email: 'info@alamal.com',
        config: config);

    final dualBox = GeniusPdfDualInfoBox(
      leftBox: _isRTL ? companyBox : customerBox,
      rightBox: _isRTL ? customerBox : companyBox,
      equalHeight: true,
      spacing: 20,
      swapForRTL: false,
    );
    final dualResult = dualBox.draw(
      page: page,
      bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 160),
    );
    yOffset = dualResult.bottom + 15;

    final statusWidth = (pageSize.width - 70) / 2;

    final infoBox = GeniusPdfInfoBox(
      config: config,
      title: _isRTL ? 'معلومة' : 'Info',
      titleAr: 'معلومة',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: _isRTL ? 'ملاحظة' : 'Note',
          labelAr: 'ملاحظة',
          value: _isRTL
              ? 'يرجى الاحتفاظ بهذه الفاتورة'
              : 'Please keep this invoice',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.info(),
    );
    infoBox.draw(
      page: page,
      bounds: Rect.fromLTWH(20, yOffset, statusWidth, 70),
    );

    final warningBox = GeniusPdfInfoBox(
        config: config,
        title: _isRTL ? 'تحذير' : 'Warning',
        titleAr: 'تحذير',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: _isRTL ? 'تنبيه' : 'Alert',
            labelAr: 'تنبيه',
            value: _isRTL ? 'مستند للمعاينة فقط' : 'Preview only document',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.warning());
    warningBox.draw(
      page: page,
      bounds: Rect.fromLTWH(40 + statusWidth, yOffset, statusWidth, 70),
    );
    yOffset += 85;

    final successBox = GeniusPdfInfoBox(
        config: config,
        title: _isRTL ? 'نجاح' : 'Success',
        titleAr: 'نجاح',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: _isRTL ? 'الحالة' : 'Status',
            labelAr: 'الحالة',
            value: _isRTL ? 'تم إتمام العملية بنجاح' : 'Operation completed',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.success());
    successBox.draw(
      page: page,
      bounds: Rect.fromLTWH(20, yOffset, statusWidth, 70),
    );

    final errorBox = GeniusPdfInfoBox(
        config: config,
        title: _isRTL ? 'خطأ' : 'Error',
        titleAr: 'خطأ',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: _isRTL ? 'المشكلة' : 'Issue',
            labelAr: 'المشكلة',
            value: _isRTL ? 'فشل في معالجة الطلب' : 'Failed to process',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.error());
    errorBox.draw(
      page: page,
      bounds: Rect.fromLTWH(40 + statusWidth, yOffset, statusWidth, 70),
    );
  }
}

/// Builds a Headers demo PDF document with extended details.
class _HeadersDemoBuilder extends GeniusPdfDocumentBuilder {
  _HeadersDemoBuilder(super.config);

  bool get _isRTL => config.isRTL;

  @override
  void build() {
    newPage();
    final page = currentPage;
    final pageSize = page.getClientSize();
    final bFont = config.boldFont;

    _drawTitle(
      page,
      bFont,
      _isRTL
          ? 'رأس التقرير - GeniusPdfReportHeader'
          : 'Report Header - GeniusPdfReportHeader',
    );

    double yOffset = 70;

    final companyInfo = GeniusPdfCompanyInfo(
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

    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Tax Invoice',
      titleAr: 'فاتورة ضريبية',
      subtitle: 'Invoice #INV-2024-001',
      subtitleAr: 'فاتورة رقم #INV-2024-001',
      company: companyInfo,
      printDate: DateTime.now(),
      style: GeniusPdfReportHeaderStyle.invoice(),
    );

    final result = header.draw(
      page: page,
      bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 200),
    );
    yOffset = result + 15;

    final bilingualHeader = GeniusPdfReportHeader.bilingualSplit(
      config: config,
      title: 'Trial Balance',
      titleAr: 'ميزان المراجعة',
      subtitle: 'As of December 31, 2025',
      subtitleAr: 'كما في 31 ديسمبر 2025',
      company: companyInfo,
      date: DateTime.now(),
    );

    bilingualHeader.draw(
      page: page,
      bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 200),
    );
  }
}

/// Builds a Summary demo PDF document with extended details.
class _SummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  _SummaryDemoBuilder(super.config);

  bool get _isRTL => config.isRTL;

  @override
  void build() {
    newPage();
    final page = currentPage;
    final pageSize = page.getClientSize();
    final bFont = config.boldFont;

    _drawTitle(
      page,
      bFont,
      _isRTL
          ? 'ملخص المبالغ - GeniusPdfSummary'
          : 'Summary Section - GeniusPdfSummary',
    );

    final summary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem(
          label: 'Subtotal',
          labelAr: 'المجموع الفرعي',
          value: _isRTL ? '30,100.00 ر.س' : 'SAR 30,100.00',
        ),
        GeniusPdfSummaryItem(
          label: 'Discount (3.3%)',
          labelAr: 'الخصم (3.3%)',
          value: _isRTL ? '- 1,000.00 ر.س' : '- SAR 1,000.00',
          valueColor: const Color(0xFFF44336),
        ),
        GeniusPdfSummaryItem(
          label: 'Taxable Amount',
          labelAr: 'المبلغ الخاضع للضريبة',
          value: _isRTL ? '29,100.00 ر.س' : 'SAR 29,100.00',
        ),
        GeniusPdfSummaryItem(
          label: 'VAT (15%)',
          labelAr: 'ضريبة القيمة المضافة (15%)',
          value: _isRTL ? '4,365.00 ر.س' : 'SAR 4,365.00',
        ),
        GeniusPdfSummaryItem.total(
          label: 'Total',
          labelAr: 'الإجمالي',
          value: _isRTL ? '33,465.00 ر.س' : 'SAR 33,465.00',
          valueColor: const Color(0xFF4CAF50),
        ),
      ],
      style: GeniusPdfSummaryStyle.invoice(),
    );

    summary.draw(
      page: page,
      bounds: Rect.fromLTWH(
        pageSize.width / 2 - 20,
        70,
        pageSize.width / 2,
        200,
      ),
    );

    final note = GeniusPdfInfoBox(
      config: config,
      title: _isRTL ? 'توضيح' : 'Note',
      titleAr: 'توضيح',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: _isRTL ? 'الحساب' : 'Calculation',
          labelAr: 'الحساب',
          value: _isRTL
              ? 'يتم احتساب ضريبة القيمة المضافة بعد الخصم.'
              : 'VAT is calculated after discount is applied.',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.highlighted(),
    );

    note.draw(
      page: page,
      bounds: Rect.fromLTWH(20, 290, pageSize.width - 40, 70),
    );
  }
}

void _drawTitle(PdfPage page, PdfFont titleFont, String text) {
  page.graphics.drawString(
    text,
    titleFont,
    bounds: Rect.fromLTWH(20, 20, page.getClientSize().width - 40, 30),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );
}
