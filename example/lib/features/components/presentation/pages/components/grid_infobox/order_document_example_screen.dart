import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated screen for **Order Document**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class GridInfoboxOrderDocumentExampleScreen extends StatelessWidget {
  const GridInfoboxOrderDocumentExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Order Document** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `order_document_example_screen.dart` and displayed as **Dart usage code**.
class GridInfoboxOrderDocumentDemoBuilder extends GeniusPdfDocumentBuilder {
  GridInfoboxOrderDocumentDemoBuilder(super.config);

  @override
  void build() {
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
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'grid_infobox_order_document',
      category: 'Components / Component Compositions / Grid + Info Box',
      title: pdfLocalization.orderDocument,
      apiName: 'GeniusPdfDataGrid + GeniusPdfInfoBox',
      description: pdfLocalization.customerOrderInfoBoxesGroupedInvoiceDesc,
      icon: Icons.receipt_long_outlined,
      usageCode: dartUsageCode,
    );
  }
}
