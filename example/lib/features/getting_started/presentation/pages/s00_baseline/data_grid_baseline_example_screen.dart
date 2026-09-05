import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/components/data_grid_invoice_footer_rows_demo_builder.dart';
import 'package:genius_pdf_example/features/getting_started/presentation/widgets/s00_baseline_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated S00 screen for the DataGrid Baseline regression example.
///
/// The `Dart usage code` panel contains the exact builder source executed by
/// this screen when **Run example** is pressed.
class S00DataGridBaselineExampleScreen extends StatelessWidget {
  const S00DataGridBaselineExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds the focused invoice/footer-row DataGrid example.
class DataGridInvoiceFooterRowsDemoBuilder extends GeniusPdfDocumentBuilder {
  DataGridInvoiceFooterRowsDemoBuilder(super.config);

  @override
  void build() {
    // Standalone DataGrid example.
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'جدول البيانات v2.12.0 — GeniusPdfDataGrid'
          : 'Data Grid v2.12.0 — GeniusPdfDataGrid',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'مثال ١: فاتورة مع صفوف إجمالية متعددة (مجموع فرعي، ضريبة، خصم، إجمالي كلي)'
          : 'Example 1: Invoice with multiple total rows (subtotal, tax, discount, grand total)',
      topMargin: 5,
    );

    addSpace(12);

    // Invoice grid with multiple footer rows
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'code',
            title: 'Code',
            titleAr: 'الكود',
            width: 55,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn(
            id: 'desc',
            title: 'Description',
            titleAr: 'الوصف',
            flexFactor: 3,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'qty',
            title: 'Qty',
            titleAr: 'الكمية',
            width: 45,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn.currency(
            id: 'price',
            title: 'Unit Price',
            titleAr: 'سعر الوحدة',
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
            widthPercent: 0.18,
          ),
          GeniusPdfGridColumn.currency(
            id: 'total',
            title: 'Total',
            titleAr: 'الإجمالي',
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
            widthPercent: 0.20,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'code': 'PRD-001',
            'desc': config.isRTL ? 'حاسوب محمول - Dell Latitude' : 'Laptop - Dell Latitude',
            'qty': 3,
            'price': 4500.00,
            'total': 13500.00,
          }),
          GeniusPdfGridRow(cells: {
            'code': 'PRD-002',
            'desc': config.isRTL ? 'شاشة عرض 27 بوصة' : 'Monitor 27" 4K Display',
            'qty': 5,
            'price': 1200.00,
            'total': 6000.00,
          }),
          GeniusPdfGridRow(cells: {
            'code': 'PRD-003',
            'desc': config.isRTL ? 'طابعة ليزرية' : 'Laser Printer',
            'qty': 2,
            'price': 2800.00,
            'total': 5600.00,
          }),
          GeniusPdfGridRow(cells: {
            'code': 'SRV-001',
            'desc': config.isRTL ? 'خدمة التركيب والتشغيل' : 'Installation & Setup Service',
            'qty': 1,
            'price': 1500.00,
            'total': 1500.00,
          }),
          GeniusPdfGridRow(cells: {
            'code': 'SRV-002',
            'desc': config.isRTL ? 'ضمان ممتد - سنتان' : 'Extended Warranty - 2 Years',
            'qty': 10,
            'price': 350.00,
            'total': 3500.00,
          }),
        ],
        // Multiple explicit footer rows with different styles
        footerRows: [
          GeniusPdfGridRow.subtotal({
            'desc': config.isRTL ? 'المجموع الفرعي' : 'Subtotal',
            'total': 30100.00,
          }),
          GeniusPdfGridRow(
            cells: {
              'desc': config.isRTL ? 'خصم (5%)' : 'Discount (5%)',
              'total': -1505.00,
            },
            isSubtotal: true,
          ),
          GeniusPdfGridRow(
            cells: {
              'desc': config.isRTL ? 'ضريبة القيمة المضافة (15%)' : 'VAT (15%)',
              'total': 4289.25,
            },
            isSubtotal: true,
          ),
          GeniusPdfGridRow.total({
            'desc': config.isRTL ? 'الإجمالي المستحق' : 'Total Due',
            'total': 32884.25,
          }),
        ],
        style: GeniusPdfGridStyle.invoice(),
      ),
      spacing: 12,
    );

    // ================================================================
  }
}''';

  @override
  Widget build(BuildContext context) {
    return S00BaselineExampleDetailScreen(
      title: pdfLocalization.dataGridBaseline,
      apiName: 'DataGridInvoiceFooterRowsDemoBuilder',
      description: pdfLocalization.verifyHeadersRowsNumericCellsFooterDesc,
      icon: Icons.table_chart_outlined,
      builderFactory: (config) => DataGridInvoiceFooterRowsDemoBuilder(config),
      usageCode: dartUsageCode,
      expectedLtr: 'Headers, rows, numeric cells and page flow must remain stable.',
      expectedRtl: 'Headers, rows, numeric cells and page flow must remain stable.',
      fileName: 's00_data_grid.pdf',
    );
  }
}
