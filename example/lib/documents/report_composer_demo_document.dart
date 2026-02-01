import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Demonstrates v2.9.0 [GeniusPdfReportComposer] fluent API.
///
/// The report composer lets you build PDFs without subclassing by chaining
/// method calls. This example builds a complete sales report using the
/// fluent API.
///
/// ## Example
/// ```dart
/// final bytes = buildComposerDemoReport(config: myConfig);
/// ```
List<int> buildComposerDemoReport({
  required GeniusPdfConfig config,
  String userName = 'Demo User',
}) {
  final isRTL = config.isRTL;

  // ── Sales Data ──────────────────────────────────────────

  final salesGrid = GeniusPdfDataGrid(
    config: config,
    columns: [
      const GeniusPdfGridColumn(
        id: 'no',
        title: '#',
        titleAr: '#',
        width: 30,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'product',
        title: 'Product',
        titleAr: 'المنتج',
        flexFactor: 3,
      ),
      GeniusPdfGridColumn.currency(
        id: 'amount',
        title: 'Amount',
        titleAr: 'المبلغ',
        width: 90,
        currencySymbol: '',
      ),
    ],
    rows: [
      GeniusPdfGridRow(cells: {
        'no': 1,
        'product': isRTL ? 'خدمات استشارية' : 'Consulting Services',
        'amount': 25000.00,
      }),
      GeniusPdfGridRow(cells: {
        'no': 2,
        'product': isRTL ? 'تراخيص برمجيات' : 'Software Licenses',
        'amount': 18000.00,
      }),
      GeniusPdfGridRow(cells: {
        'no': 3,
        'product': isRTL ? 'دعم فني' : 'Technical Support',
        'amount': 7500.00,
      }),
    ],
    style: const GeniusPdfGridStyle.classic(),
  );

  final salesSummary = GeniusPdfSummarySection(
    config: config,
    items: [
      GeniusPdfSummaryItem.subtotal(
        label: 'Subtotal',
        labelAr: 'المجموع الفرعي',
        value: '50,500.00',
      ),
      GeniusPdfSummaryItem(
        label: 'VAT (15%)',
        labelAr: 'ضريبة (15%)',
        value: '7,575.00',
      ),
      GeniusPdfSummaryItem.total(
        label: 'Grand Total',
        labelAr: 'الإجمالي',
        value: '58,075.00',
      ),
    ],
    style: const GeniusPdfSummaryStyle.bordered(),
    alignment: GeniusPdfSummaryAlignment.right,
    width: 220,
  );

  // ── Bar Chart ───────────────────────────────────────────

  final barChart = GeniusPdfBarChart(
    config: config,
    title: isRTL ? 'المبيعات حسب الفئة' : 'Sales by Category',
    titleAr: 'المبيعات حسب الفئة',
    series: [
      GeniusChartSeries(
        name: 'Revenue',
        nameAr: 'الإيرادات',
        color: const Color(0xFF4CAF50),
        dataPoints: [
          const GeniusChartDataPoint(
              label: 'Consulting', labelAr: 'استشارات', value: 25000),
          const GeniusChartDataPoint(
              label: 'Software', labelAr: 'برمجيات', value: 18000),
          const GeniusChartDataPoint(
              label: 'Support', labelAr: 'دعم', value: 7500),
        ],
      ),
    ],
    height: 180,
  );

  // ── Compose the Report ──────────────────────────────────

  final composer = GeniusPdfReportComposer(config: config);
  final bytes = composer
      .withHeader(title: isRTL ? 'تقرير مبيعات — v2.9.0' : 'Sales Report — v2.9.0')
      .withFooter(
        userName: userName,
        showPageNumber: true,
        printTime: DateTime.now().toString().substring(0, 19),
      )
      .section(
        isRTL ? 'ملخص المبيعات' : 'Sales Overview',
        sectionAr: 'ملخص المبيعات',
      )
      .text(
        isRTL
            ? 'فيما يلي ملخص لإيرادات المبيعات للربع الأول من 2026.'
            : 'Below is a summary of Q1 2026 sales revenue.',
      )
      .space(5)
      .gridWithSummary(
        dataGrid: salesGrid,
        summarySection: salesSummary,
        gridSpacing: 5,
        summarySpacing: 10,
      )
      .space(15)
      .section(
        isRTL ? 'مخطط المبيعات' : 'Sales Chart',
        sectionAr: 'مخطط المبيعات',
      )
      .barChart(barChart, spacing: 5, height: 180)
      .space(15)
      .section(
        isRTL ? 'ملاحظات' : 'Notes',
        sectionAr: 'ملاحظات',
      )
      .text(
        isRTL
            ? 'تم إنشاء هذا التقرير باستخدام واجهة GeniusPdfReportComposer الجديدة.'
            : 'This report was generated using the new GeniusPdfReportComposer fluent API.',
      )
      .boldText(
        isRTL ? 'الحالة: مكتمل' : 'Status: Complete',
        topMargin: 5,
      )
      .buildPdf();

  composer.dispose();
  return bytes;
}
