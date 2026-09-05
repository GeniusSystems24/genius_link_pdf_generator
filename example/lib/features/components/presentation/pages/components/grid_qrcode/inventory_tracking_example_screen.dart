import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Inventory Tracking QR**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class GridQrcodeInventoryTrackingExampleScreen extends StatelessWidget {
  const GridQrcodeInventoryTrackingExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Inventory Tracking QR** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `inventory_tracking_example_screen.dart` and displayed as **Dart usage code**.
class GridQrcodeInventoryTrackingDemoBuilder extends GeniusPdfDocumentBuilder {
  GridQrcodeInventoryTrackingDemoBuilder(super.config);

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
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'grid_qrcode_inventory_tracking',
      category: 'Components / Component Compositions / Grid + QR Code',
      title: 'Inventory Tracking QR',
      apiName: 'GeniusPdfDataGrid + GeniusPdfQRCodeGenerator',
      description: 'Build an inventory grid with automatic totals and a URL QR code for shipment or stock tracking.',
      icon: Icons.inventory_2_outlined,
      usageCode: dartUsageCode,
    );
  }
}
