import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Shipping & Payment** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `shipping_payment_example_screen.dart` and displayed as **Dart usage code**.
class GridInfoboxShippingPaymentDemoBuilder extends GeniusPdfDocumentBuilder {
  GridInfoboxShippingPaymentDemoBuilder(super.config);

  @override
  void build() {
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
