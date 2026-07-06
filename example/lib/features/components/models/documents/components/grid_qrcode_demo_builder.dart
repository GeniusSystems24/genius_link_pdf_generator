import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Grid + QRCode/Barcode demo PDF document.
///
/// Demonstrates combining data grids with QR codes:
/// 1. Invoice header with company info
/// 2. Product items grid with prices and totals
/// 3. ZATCA-compliant QR code for e-invoice
class GridQrcodeDemoBuilder extends GeniusPdfDocumentBuilder {
  GridQrcodeDemoBuilder(super.config);

  late final _companyInfo = GeniusPdfCompanyInfo(
    name: 'Genius Systems Co.',
    nameAr: 'شركة جينيس سيستمز',
    vatNumber: '300123456789003',
    crNumber: '1010123456',
    address: 'King Fahd Road',
    addressAr: 'طريق الملك فهد',
    city: 'Riyadh',
    cityAr: 'الرياض',
    country: 'Saudi Arabia',
    countryAr: 'المملكة العربية السعودية',
    phone: '+967-774717166',
    email: 'info@geniussystems.co',
  );

  @override
  void build() {
    // ================================================================
    // PAGE 1: E-Invoice with QR Code
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'جدول البيانات مع رموز QR — Grid + QR Code'
          : 'Data Grid with QR Code — Grid + QR Code',
      spacing: 10,
    );

    // Report header
    addReportHeader(
      GeniusPdfReportHeader(
        config: config,
        title: 'Tax Invoice',
        titleAr: 'فاتورة ضريبية',
        subtitle: 'Invoice #INV-2026-0042',
        subtitleAr: 'فاتورة رقم #INV-2026-0042',
        company: _companyInfo,
        printDate: DateTime.now(),
        style: GeniusPdfReportHeaderStyle.invoice(),
      ),
      spacing: 15,
    );

    addSpace(15);

    // Customer and Invoice info boxes
    final customerBox = GeniusPdfInfoBox(
      config: config,
      title: 'Customer',
      titleAr: 'العميل',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Name',
          labelAr: 'الاسم',
          value: config.isRTL ? 'أحمد محمد العلي' : 'Ahmed Mohammed Al-Ali',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Phone',
          labelAr: 'الهاتف',
          value: '+966 50 123 4567',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Address',
          labelAr: 'العنوان',
          value:
              config.isRTL ? 'الرياض، حي النخيل' : 'Riyadh, Al-Nakhil District',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
    );

    final invoiceBox = GeniusPdfInfoBox(
      config: config,
      title: 'Invoice Details',
      titleAr: 'تفاصيل الفاتورة',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Date',
          labelAr: 'التاريخ',
          value: '2026-02-02',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Due Date',
          labelAr: 'تاريخ الاستحقاق',
          value: '2026-02-16',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Payment',
          labelAr: 'طريقة الدفع',
          value: config.isRTL ? 'تحويل بنكي' : 'Bank Transfer',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
    );

    addDualInfoBox(
      leftBox: config.isRTL ? invoiceBox : customerBox,
      rightBox: config.isRTL ? customerBox : invoiceBox,
      equalHeight: true,
      boxSpacing: 20,
      spacing: 10,
    );

    addSpace(15);

    // Invoice items grid
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'code',
            title: '#',
            titleAr: '#',
            width: 40,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn(
            id: 'barcode',
            title: 'Barcode',
            titleAr: 'الباركود',
            width: 90,
          ),
          GeniusPdfGridColumn(
            id: 'desc',
            title: 'Description',
            titleAr: 'الوصف',
            width: 150,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'qty',
            title: 'Qty',
            titleAr: 'الكمية',
            width: 50,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn.currency(
            id: 'price',
            title: 'Price',
            titleAr: 'السعر',
            widthPercent: 0.15,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.currency(
            id: 'total',
            title: 'Total',
            titleAr: 'الإجمالي',
            widthPercent: 0.18,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'code': 1,
            'barcode': '5901234123457',
            'desc': config.isRTL
                ? 'لابتوب HP ProBook 450'
                : 'HP ProBook 450 Laptop',
            'qty': 2,
            'price': 4500.0,
            'total': 9000.0,
          }),
          GeniusPdfGridRow(cells: {
            'code': 2,
            'barcode': '5901234123458',
            'desc': config.isRTL ? 'شاشة Dell 27"' : 'Dell Monitor 27"',
            'qty': 2,
            'price': 1200.0,
            'total': 2400.0,
          }),
          GeniusPdfGridRow(cells: {
            'code': 3,
            'barcode': '5901234123459',
            'desc': config.isRTL ? 'لوحة مفاتيح لاسلكية' : 'Wireless Keyboard',
            'qty': 3,
            'price': 180.0,
            'total': 540.0,
          }),
          GeniusPdfGridRow(cells: {
            'code': 4,
            'barcode': '5901234123460',
            'desc': config.isRTL ? 'ماوس لاسلكي' : 'Wireless Mouse',
            'qty': 3,
            'price': 95.0,
            'total': 285.0,
          }),
        ],
        footerRows: [
          GeniusPdfGridRow.subtotal({
            'desc': config.isRTL ? 'المجموع الفرعي' : 'Subtotal',
            'total': 12225.0,
          }),
          GeniusPdfGridRow(
            cells: {
              'desc': config.isRTL ? 'ضريبة القيمة المضافة (15%)' : 'VAT (15%)',
              'total': 1833.75,
            },
            isSubtotal: true,
          ),
          GeniusPdfGridRow.total({
            'desc': config.isRTL ? 'الإجمالي المستحق' : 'Total Due',
            'total': 14058.75,
          }),
        ],
        style: GeniusPdfGridStyle.invoice(),
      ),
      spacing: 10,
    );

    addSpace(20);

    // ZATCA QR Code section
    addLine(
      config.isRTL
          ? 'رمز الفاتورة الإلكترونية (ZATCA)'
          : 'E-Invoice QR Code (ZATCA)',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(10);

    addQRCode(
      GeniusPdfQRCodeGenerator.zatca(
        sellerName: config.isRTL ? 'شركة جينيس سيستمز' : 'Genius Systems Co.',
        vatNumber: '300123456789003',
        timestamp: DateTime.now(),
        total: 14058.75,
        vatAmount: 1833.75,
        config: config,
        style: GeniusPdfQRCodeStyle.invoice(),
      ),
      size: 120,
      alignment: GeniusPdfImageAlignment.center,
      spacing: 5,
    );

    // ================================================================
    // PAGE 2: Inventory with Tracking QR
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٢: جرد المخزون مع رمز التتبع'
          : 'Example 2: Inventory with Tracking QR',
      spacing: 10,
    );

    addSpace(15);

    // Inventory grid
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'sku',
            title: 'SKU',
            titleAr: 'رمز المنتج',
            width: 80,
          ),
          GeniusPdfGridColumn(
            id: 'product',
            title: 'Product',
            titleAr: 'المنتج',
            width: 180,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'stock',
            title: 'Stock',
            titleAr: 'المخزون',
            width: 60,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'minStock',
            title: 'Min',
            titleAr: 'الحد الأدنى',
            width: 60,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn(
            id: 'status',
            title: 'Status',
            titleAr: 'الحالة',
            width: 80,
            alignment: GeniusPdfTextAlign.center,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'sku': 'PRD-001',
            'product':
                config.isRTL ? 'قهوة عربية ٢٥٠ جم' : 'Arabic Coffee 250g',
            'stock': 150,
            'minStock': 50,
            'status': config.isRTL ? 'متوفر' : 'In Stock',
          }),
          GeniusPdfGridRow(cells: {
            'sku': 'PRD-002',
            'product': config.isRTL ? 'تمر سكري ١ كجم' : 'Sukari Dates 1kg',
            'stock': 45,
            'minStock': 30,
            'status': config.isRTL ? 'متوفر' : 'In Stock',
          }),
          GeniusPdfGridRow(cells: {
            'sku': 'PRD-003',
            'product':
                config.isRTL ? 'عسل طبيعي ٥٠٠ مل' : 'Natural Honey 500ml',
            'stock': 12,
            'minStock': 20,
            'status': config.isRTL ? 'منخفض' : 'Low Stock',
          }),
          GeniusPdfGridRow(cells: {
            'sku': 'PRD-004',
            'product': config.isRTL ? 'زيت زيتون ١ لتر' : 'Olive Oil 1L',
            'stock': 0,
            'minStock': 25,
            'status': config.isRTL ? 'نفذ' : 'Out of Stock',
          }),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total Items',
            labelAr: 'إجمالي المنتجات',
            labelColumnId: 'product',
            columnIds: ['stock'],
          ),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    addSpace(25);

    // Tracking QR Code
    addLine(
      config.isRTL ? 'رمز تتبع الشحنة' : 'Shipment Tracking QR',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(10);

    addQRCode(
      GeniusPdfQRCodeGenerator.url(
        url: 'https://track.geniussystems.co/shipment/SHP-2026-0042',
        config: config,
      ),
      size: 100,
      alignment: GeniusPdfImageAlignment.center,
      spacing: 5,
    );

    addSpace(15);

    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملاحظة' : 'Note',
        titleAr: 'ملاحظة',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: '',
            value: config.isRTL
                ? 'جميع رموز QR متوافقة مع معايير ZATCA للفوترة الإلكترونية'
                : 'All QR codes are ZATCA e-invoicing compliant',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.info(),
      ),
      spacing: 10,
    );
  }
}
