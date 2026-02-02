import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Grid + InfoBox demo PDF document.
///
/// Demonstrates combining data grids with info boxes:
/// 1. Dual info boxes: Customer info + Order summary
/// 2. Order items grid with grouped products
/// 3. Shipping and payment info boxes
/// 4. Order status and notes
class GridInfoboxDemoBuilder extends GeniusPdfDocumentBuilder {
  GridInfoboxDemoBuilder(super.config);

  @override
  void build() {
    // ================================================================
    // PAGE 1: Order Document with Info Boxes
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'جدول البيانات مع صناديق المعلومات — Grid + InfoBox'
          : 'Data Grid with Info Boxes — Grid + InfoBox',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'مثال ١: طلب مع معلومات العميل والمنتجات'
          : 'Example 1: Order with Customer and Product Info',
      topMargin: 5,
    );

    addSpace(15);

    // Customer and Order info boxes
    final customerBox = GeniusPdfInfoBox(
      config: config,
      title: 'Customer Information',
      titleAr: 'بيانات العميل',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Name',
          labelAr: 'الاسم',
          value: config.isRTL
              ? 'خالد عبدالرحمن المنصور'
              : 'Khalid Abdulrahman Al-Mansour',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Customer ID',
          labelAr: 'رقم العميل',
          value: 'CUS-2026-0158',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Phone',
          labelAr: 'الهاتف',
          value: '+966 55 987 6543',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Email',
          labelAr: 'البريد الإلكتروني',
          value: 'khalid.mansour@email.com',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Membership',
          labelAr: 'العضوية',
          value: config.isRTL ? 'ذهبي' : 'Gold Member',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
    );

    final orderBox = GeniusPdfInfoBox(
      config: config,
      title: 'Order Summary',
      titleAr: 'ملخص الطلب',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Order #',
          labelAr: 'رقم الطلب',
          value: 'ORD-2026-00891',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Date',
          labelAr: 'التاريخ',
          value: '2026-02-02',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Status',
          labelAr: 'الحالة',
          value: config.isRTL ? 'قيد التجهيز' : 'Processing',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Priority',
          labelAr: 'الأولوية',
          value: config.isRTL ? 'عاجل' : 'Urgent',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Est. Delivery',
          labelAr: 'التسليم المتوقع',
          value: '2026-02-05',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
    );

    addDualInfoBox(
      leftBox: config.isRTL ? orderBox : customerBox,
      rightBox: config.isRTL ? customerBox : orderBox,
      equalHeight: true,
      boxSpacing: 20,
      spacing: 10,
    );

    addSpace(15);

    // Order items grid with groups
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'item',
            title: 'Item',
            titleAr: 'الصنف',
            flexFactor: 2,
          ),
          GeniusPdfGridColumn(
            id: 'sku',
            title: 'SKU',
            titleAr: 'الرمز',
            width: 80,
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
            titleAr: 'المجموع',
            widthPercent: 0.18,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
        ],
        rows: [],
        groups: [
          GeniusPdfGridGroup.withSummary(
            title: 'Electronics',
            titleAr: 'إلكترونيات',
            rows: [
              GeniusPdfGridRow(cells: {
                'item': config.isRTL
                    ? 'سماعات بلوتوث Sony'
                    : 'Sony Bluetooth Headphones',
                'sku': 'ELC-001',
                'qty': 1,
                'price': 850.0,
                'total': 850.0,
              }),
              GeniusPdfGridRow(cells: {
                'item': config.isRTL
                    ? 'شاحن لاسلكي Samsung'
                    : 'Samsung Wireless Charger',
                'sku': 'ELC-002',
                'qty': 2,
                'price': 120.0,
                'total': 240.0,
              }),
            ],
            sumColumns: ['total'],
            labelColumnId: 'item',
            summaryLabel: 'Electronics Subtotal',
            summaryLabelAr: 'مجموع الإلكترونيات',
          ),
          GeniusPdfGridGroup.withSummary(
            title: 'Office Supplies',
            titleAr: 'مستلزمات مكتبية',
            rows: [
              GeniusPdfGridRow(cells: {
                'item': config.isRTL ? 'دفتر ملاحظات A4' : 'A4 Notebook Set',
                'sku': 'OFF-001',
                'qty': 5,
                'price': 25.0,
                'total': 125.0,
              }),
              GeniusPdfGridRow(cells: {
                'item': config.isRTL ? 'أقلام حبر - طقم' : 'Pen Set - Premium',
                'sku': 'OFF-002',
                'qty': 3,
                'price': 45.0,
                'total': 135.0,
              }),
              GeniusPdfGridRow(cells: {
                'item': config.isRTL ? 'منظم مكتب' : 'Desk Organizer',
                'sku': 'OFF-003',
                'qty': 1,
                'price': 180.0,
                'total': 180.0,
              }),
            ],
            sumColumns: ['total'],
            labelColumnId: 'item',
            summaryLabel: 'Office Subtotal',
            summaryLabelAr: 'مجموع المستلزمات',
          ),
        ],
        footerRows: [
          GeniusPdfGridRow.subtotal({
            'item': config.isRTL ? 'المجموع الفرعي' : 'Subtotal',
            'total': 1530.0,
          }),
          GeniusPdfGridRow(
            cells: {
              'item': config.isRTL
                  ? 'خصم العضوية الذهبية (10%)'
                  : 'Gold Member Discount (10%)',
              'total': -153.0,
            },
            isSubtotal: true,
          ),
          GeniusPdfGridRow(
            cells: {
              'item': config.isRTL ? 'ضريبة القيمة المضافة (15%)' : 'VAT (15%)',
              'total': 206.55,
            },
            isSubtotal: true,
          ),
          GeniusPdfGridRow.total({
            'item': config.isRTL ? 'الإجمالي' : 'Grand Total',
            'total': 1583.55,
          }),
        ],
        style: GeniusPdfGridStyle.invoice(),
      ),
      spacing: 10,
    );

    // ================================================================
    // PAGE 2: Shipping and Payment Info
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٢: معلومات الشحن والدفع'
          : 'Example 2: Shipping and Payment Info',
      spacing: 10,
    );

    addSpace(15);

    // Shipping info box
    final shippingBox = GeniusPdfInfoBox(
      config: config,
      title: 'Shipping Address',
      titleAr: 'عنوان الشحن',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Recipient',
          labelAr: 'المستلم',
          value: config.isRTL
              ? 'خالد عبدالرحمن المنصور'
              : 'Khalid Abdulrahman Al-Mansour',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Street',
          labelAr: 'الشارع',
          value: config.isRTL
              ? 'شارع الملك عبدالله، حي الياسمين'
              : 'King Abdullah St., Al-Yasmin District',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'City',
          labelAr: 'المدينة',
          value: config.isRTL ? 'الرياض' : 'Riyadh',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Postal Code',
          labelAr: 'الرمز البريدي',
          value: '13326',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Country',
          labelAr: 'الدولة',
          value: config.isRTL ? 'المملكة العربية السعودية' : 'Saudi Arabia',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
    );

    // Payment info box
    final paymentBox = GeniusPdfInfoBox(
      config: config,
      title: 'Payment Details',
      titleAr: 'تفاصيل الدفع',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Method',
          labelAr: 'طريقة الدفع',
          value: config.isRTL ? 'بطاقة ائتمان' : 'Credit Card',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Card',
          labelAr: 'البطاقة',
          value: '**** **** **** 4532',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Status',
          labelAr: 'الحالة',
          value: config.isRTL ? 'تم الدفع' : 'Paid',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Transaction',
          labelAr: 'رقم العملية',
          value: 'TXN-8829176354',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Date',
          labelAr: 'التاريخ',
          value: '2026-02-02 14:35',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
    );

    addDualInfoBox(
      leftBox: config.isRTL ? paymentBox : shippingBox,
      rightBox: config.isRTL ? shippingBox : paymentBox,
      equalHeight: true,
      boxSpacing: 20,
      spacing: 10,
    );

    addSpace(20);

    // Delivery tracking grid
    addLine(
      config.isRTL ? 'تتبع الشحنة' : 'Delivery Tracking',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(10);

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'date',
            title: 'Date',
            titleAr: 'التاريخ',
            width: 100,
          ),
          GeniusPdfGridColumn(
            id: 'time',
            title: 'Time',
            titleAr: 'الوقت',
            width: 70,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn(
            id: 'status',
            title: 'Status',
            titleAr: 'الحالة',
            flexFactor: 1,
          ),
          GeniusPdfGridColumn(
            id: 'location',
            title: 'Location',
            titleAr: 'الموقع',
            flexFactor: 1,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'date': '2026-02-02',
            'time': '14:35',
            'status': config.isRTL ? 'تم استلام الطلب' : 'Order Received',
            'location': config.isRTL ? 'النظام' : 'System',
          }),
          GeniusPdfGridRow(cells: {
            'date': '2026-02-02',
            'time': '15:20',
            'status': config.isRTL ? 'تم تأكيد الدفع' : 'Payment Confirmed',
            'location': config.isRTL ? 'البنك' : 'Bank',
          }),
          GeniusPdfGridRow(cells: {
            'date': '2026-02-02',
            'time': '16:45',
            'status': config.isRTL ? 'قيد التجهيز' : 'Processing',
            'location':
                config.isRTL ? 'المستودع - الرياض' : 'Warehouse - Riyadh',
          }),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    addSpace(20);

    // Status info boxes
    final successBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'تأكيد الطلب' : 'Order Confirmation',
      titleAr: 'تأكيد الطلب',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: '',
          value: config.isRTL
              ? 'تم تأكيد طلبك بنجاح. سيتم إرسال إشعار عند الشحن.'
              : 'Your order has been confirmed. You will receive a notification when shipped.',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.success(),
    );

    final noteBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'ملاحظات' : 'Notes',
      titleAr: 'ملاحظات',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: '',
          value: config.isRTL
              ? 'يرجى التواصل مع خدمة العملاء في حال تأخر التسليم'
              : 'Please contact customer service if delivery is delayed',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.info(),
    );

    addDualInfoBox(
      leftBox: successBox,
      rightBox: noteBox,
      equalHeight: true,
      boxSpacing: 20,
      spacing: 10,
    );
  }
}
