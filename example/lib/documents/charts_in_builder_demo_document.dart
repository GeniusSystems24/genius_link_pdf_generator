import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide
        PdfTextStyle,
        PdfGridStyle,
        PdfBorderStyle,
        PdfGridColumn,
        PdfGridRow;

/// Demonstrates v2.6.0 chart integration in the document builder.
///
/// This example showcases:
/// - **[addBarChart]** — Bar chart at current position with auto page-break
/// - **[addLineChart]** — Line chart with automatic Y advancement
/// - **[addPieChart]** — Pie chart with auto page-break
/// - **[addAreaChart]** — Area chart at current position
/// - Charts combined with grids, summaries, and section dividers
///
/// ## Example
/// ```dart
/// final doc = ChartsInBuilderDemoBuilder(config: myConfig);
/// final bytes = doc.generate();
/// doc.dispose();
/// ```
class ChartsInBuilderDemoBuilder extends GeniusPdfDocumentBuilder {
  /// Creates a new [ChartsInBuilderDemoBuilder].
  ChartsInBuilderDemoBuilder({
    required GeniusPdfConfig config,
    this.userName = 'Demo User',
  }) : super(config);

  /// User name for the footer.
  final String userName;

  @override
  void build() {
    _buildHeader();
    _buildBarChartSection();
    _buildLineChartSection();
    _buildPieChartSection();
    _buildAreaChartSection();
    _buildFooter();
  }

  // ──────────────────────────────────────────────────────────
  // Header
  // ──────────────────────────────────────────────────────────

  void _buildHeader() {
    addHeader(
      title: isRTL
          ? 'عرض المخططات في البناء — الإصدار 2.6.0'
          : 'Charts in Builder Demo — v2.6.0',
    );
  }

  // ──────────────────────────────────────────────────────────
  // Bar Chart
  // ──────────────────────────────────────────────────────────

  void _buildBarChartSection() {
    addSectionDivider(
      title: isRTL ? 'مخطط أعمدة — المبيعات الربعية' : 'Bar Chart — Quarterly Sales',
      spacing: 10,
    );

    final chart = GeniusPdfBarChart(
      config: config,
      title: isRTL ? 'المبيعات الربعية' : 'Quarterly Sales',
      titleAr: 'المبيعات الربعية',
      series: [
        GeniusChartSeries(
          name: 'Revenue',
          nameAr: 'الإيرادات',
          color: const Color(0xFF4CAF50),
          dataPoints: [
            const GeniusChartDataPoint(label: 'Q1', labelAr: 'ر1', value: 45000),
            const GeniusChartDataPoint(label: 'Q2', labelAr: 'ر2', value: 52000),
            const GeniusChartDataPoint(label: 'Q3', labelAr: 'ر3', value: 38000),
            const GeniusChartDataPoint(label: 'Q4', labelAr: 'ر4', value: 61000),
          ],
        ),
        GeniusChartSeries(
          name: 'Expenses',
          nameAr: 'المصروفات',
          color: const Color(0xFFF44336),
          dataPoints: [
            const GeniusChartDataPoint(label: 'Q1', labelAr: 'ر1', value: 32000),
            const GeniusChartDataPoint(label: 'Q2', labelAr: 'ر2', value: 35000),
            const GeniusChartDataPoint(label: 'Q3', labelAr: 'ر3', value: 28000),
            const GeniusChartDataPoint(label: 'Q4', labelAr: 'ر4', value: 41000),
          ],
        ),
      ],
      height: 200,
    );

    addBarChart(chart, spacing: 5, height: 200);
    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Line Chart
  // ──────────────────────────────────────────────────────────

  void _buildLineChartSection() {
    addSectionDivider(
      title: isRTL ? 'مخطط خطي — اتجاه المبيعات' : 'Line Chart — Sales Trend',
      spacing: 10,
    );

    final chart = GeniusPdfLineChart(
      config: config,
      title: isRTL ? 'اتجاه المبيعات الشهري' : 'Monthly Sales Trend',
      titleAr: 'اتجاه المبيعات الشهري',
      series: [
        GeniusChartSeries(
          name: '2025',
          nameAr: '2025',
          color: const Color(0xFF2196F3),
          dataPoints: [
            const GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 12000),
            const GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 15000),
            const GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 18000),
            const GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 14000),
            const GeniusChartDataPoint(label: 'May', labelAr: 'مايو', value: 22000),
            const GeniusChartDataPoint(label: 'Jun', labelAr: 'يونيو', value: 19000),
          ],
        ),
      ],
      height: 200,
    );

    addLineChart(chart, spacing: 5, height: 200);
    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Pie Chart
  // ──────────────────────────────────────────────────────────

  void _buildPieChartSection() {
    addSectionDivider(
      title: isRTL ? 'مخطط دائري — توزيع المصروفات' : 'Pie Chart — Expense Breakdown',
      spacing: 10,
    );

    final chart = GeniusPdfPieChart(
      config: config,
      title: isRTL ? 'توزيع المصروفات' : 'Expense Breakdown',
      titleAr: 'توزيع المصروفات',
      dataPoints: [
        const GeniusChartDataPoint(label: 'Rent', labelAr: 'إيجار', value: 35),
        const GeniusChartDataPoint(label: 'Salaries', labelAr: 'رواتب', value: 40),
        const GeniusChartDataPoint(label: 'Utilities', labelAr: 'خدمات', value: 10),
        const GeniusChartDataPoint(label: 'Marketing', labelAr: 'تسويق', value: 15),
      ],
      colors: const [
        Color(0xFF4CAF50),
        Color(0xFF2196F3),
        Color(0xFFFF9800),
        Color(0xFF9C27B0),
      ],
      height: 200,
    );

    addPieChart(chart, spacing: 5, height: 200);
    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Area Chart
  // ──────────────────────────────────────────────────────────

  void _buildAreaChartSection() {
    addSectionDivider(
      title: isRTL ? 'مخطط مساحي — النمو التراكمي' : 'Area Chart — Cumulative Growth',
      spacing: 10,
    );

    final chart = GeniusPdfAreaChart(
      config: config,
      title: isRTL ? 'النمو التراكمي' : 'Cumulative Growth',
      titleAr: 'النمو التراكمي',
      series: [
        GeniusChartSeries(
          name: 'Product A',
          nameAr: 'منتج أ',
          color: const Color(0xFF009688),
          dataPoints: [
            const GeniusChartDataPoint(label: 'W1', labelAr: 'أ1', value: 5000),
            const GeniusChartDataPoint(label: 'W2', labelAr: 'أ2', value: 12000),
            const GeniusChartDataPoint(label: 'W3', labelAr: 'أ3', value: 18000),
            const GeniusChartDataPoint(label: 'W4', labelAr: 'أ4', value: 28000),
          ],
        ),
        GeniusChartSeries(
          name: 'Product B',
          nameAr: 'منتج ب',
          color: const Color(0xFFFF5722),
          dataPoints: [
            const GeniusChartDataPoint(label: 'W1', labelAr: 'أ1', value: 3000),
            const GeniusChartDataPoint(label: 'W2', labelAr: 'أ2', value: 8000),
            const GeniusChartDataPoint(label: 'W3', labelAr: 'أ3', value: 15000),
            const GeniusChartDataPoint(label: 'W4', labelAr: 'أ4', value: 22000),
          ],
        ),
      ],
      height: 200,
    );

    addAreaChart(chart, spacing: 5, height: 200);
    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Footer
  // ──────────────────────────────────────────────────────────

  void _buildFooter() {
    addFooter(
      userName: userName,
      showPageNumber: true,
      printTime: DateTime.now().toString().substring(0, 19),
    );
  }
}
