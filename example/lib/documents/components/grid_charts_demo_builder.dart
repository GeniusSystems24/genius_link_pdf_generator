import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Grid + Charts demo PDF document.
///
/// Demonstrates combining data grids with various chart types:
/// 1. Sales summary grid with Bar chart visualization
/// 2. Monthly performance grid with Line chart trends
/// 3. Category distribution grid with Pie chart breakdown
class GridChartsDemoBuilder extends GeniusPdfDocumentBuilder {
  GridChartsDemoBuilder(super.config);

  @override
  void build() {
    // ================================================================
    // PAGE 1: Sales Summary with Bar Chart
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'جدول البيانات مع الرسوم البيانية — Grid + Charts'
          : 'Data Grid with Charts — Grid + Charts',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'مثال ١: ملخص المبيعات مع مخطط أعمدة'
          : 'Example 1: Sales Summary with Bar Chart',
      topMargin: 5,
    );

    addSpace(15);

    // Sales summary grid
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'region',
            title: 'Region',
            titleAr: 'المنطقة',
            flexFactor: 2,
          ),
          GeniusPdfGridColumn.currency(
            id: 'q1',
            title: 'Q1 Sales',
            titleAr: 'مبيعات ر١',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.currency(
            id: 'q2',
            title: 'Q2 Sales',
            titleAr: 'مبيعات ر٢',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.currency(
            id: 'total',
            title: 'Total',
            titleAr: 'الإجمالي',
            widthPercent: 0.25,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'region': config.isRTL ? 'الرياض' : 'Riyadh',
            'q1': 125000.0,
            'q2': 145000.0,
            'total': 270000.0,
          }),
          GeniusPdfGridRow(cells: {
            'region': config.isRTL ? 'جدة' : 'Jeddah',
            'q1': 98000.0,
            'q2': 112000.0,
            'total': 210000.0,
          }),
          GeniusPdfGridRow(cells: {
            'region': config.isRTL ? 'الدمام' : 'Dammam',
            'q1': 75000.0,
            'q2': 88000.0,
            'total': 163000.0,
          }),
          GeniusPdfGridRow(cells: {
            'region': config.isRTL ? 'مكة' : 'Makkah',
            'q1': 65000.0,
            'q2': 72000.0,
            'total': 137000.0,
          }),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Grand Total',
            labelAr: 'الإجمالي الكلي',
            labelColumnId: 'region',
            columnIds: ['q1', 'q2', 'total'],
          ),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    addSpace(20);

    // Bar chart for regional sales
    addBarChart(
      GeniusPdfBarChart(
        config: config,
        title: config.isRTL ? 'مبيعات المناطق' : 'Regional Sales',
        titleAr: 'مبيعات المناطق',
        series: [
          GeniusChartSeries(
            name: 'Q1',
            nameAr: 'ر١',
            dataPoints: [
              GeniusChartDataPoint(
                  label: 'Riyadh', labelAr: 'الرياض', value: 125),
              GeniusChartDataPoint(label: 'Jeddah', labelAr: 'جدة', value: 98),
              GeniusChartDataPoint(
                  label: 'Dammam', labelAr: 'الدمام', value: 75),
              GeniusChartDataPoint(label: 'Makkah', labelAr: 'مكة', value: 65),
            ],
            color: const Color(0xFF2196F3),
          ),
          GeniusChartSeries(
            name: 'Q2',
            nameAr: 'ر٢',
            dataPoints: [
              GeniusChartDataPoint(
                  label: 'Riyadh', labelAr: 'الرياض', value: 145),
              GeniusChartDataPoint(label: 'Jeddah', labelAr: 'جدة', value: 112),
              GeniusChartDataPoint(
                  label: 'Dammam', labelAr: 'الدمام', value: 88),
              GeniusChartDataPoint(label: 'Makkah', labelAr: 'مكة', value: 72),
            ],
            color: const Color(0xFF4CAF50),
          ),
        ],
        settings:
            const GeniusBarChartSettings(type: GeniusBarChartType.grouped),
      ),
      height: 180,
      spacing: 15,
    );

    // ================================================================
    // PAGE 2: Monthly Performance with Line Chart
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٢: الأداء الشهري مع مخطط خطي'
          : 'Example 2: Monthly Performance with Line Chart',
      spacing: 10,
    );

    addSpace(15);

    // Monthly performance grid
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'month',
            title: 'Month',
            titleAr: 'الشهر',
            width: 80,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'orders',
            title: 'Orders',
            titleAr: 'الطلبات',
            width: 70,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn.currency(
            id: 'revenue',
            title: 'Revenue',
            titleAr: 'الإيرادات',
            widthPercent: 0.25,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.numeric(
            id: 'growth',
            title: 'Growth %',
            titleAr: 'النمو %',
            width: 80,
            alignment: GeniusPdfTextAlign.center,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'month': config.isRTL ? 'يناير' : 'January',
            'orders': 120,
            'revenue': 45000.0,
            'growth': 0.0
          }),
          GeniusPdfGridRow(cells: {
            'month': config.isRTL ? 'فبراير' : 'February',
            'orders': 145,
            'revenue': 52000.0,
            'growth': 15.6
          }),
          GeniusPdfGridRow(cells: {
            'month': config.isRTL ? 'مارس' : 'March',
            'orders': 168,
            'revenue': 61000.0,
            'growth': 17.3
          }),
          GeniusPdfGridRow(cells: {
            'month': config.isRTL ? 'أبريل' : 'April',
            'orders': 152,
            'revenue': 55000.0,
            'growth': -9.8
          }),
          GeniusPdfGridRow(cells: {
            'month': config.isRTL ? 'مايو' : 'May',
            'orders': 188,
            'revenue': 68000.0,
            'growth': 23.6
          }),
          GeniusPdfGridRow(cells: {
            'month': config.isRTL ? 'يونيو' : 'June',
            'orders': 210,
            'revenue': 78000.0,
            'growth': 14.7
          }),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total',
            labelAr: 'الإجمالي',
            labelColumnId: 'month',
            columnIds: ['orders', 'revenue'],
          ),
          GeniusPdfAutoTotal.average(
            label: 'Average',
            labelAr: 'المتوسط',
            labelColumnId: 'month',
            columnIds: ['orders', 'revenue', 'growth'],
          ),
        ],
        style: GeniusPdfGridStyle.invoice(),
      ),
      spacing: 10,
    );

    addSpace(20);

    // Line chart for revenue trend
    addLineChart(
      GeniusPdfLineChart(
        config: config,
        title: config.isRTL ? 'اتجاه الإيرادات' : 'Revenue Trend',
        titleAr: 'اتجاه الإيرادات',
        series: [
          GeniusChartSeries(
            name: 'Revenue (K)',
            nameAr: 'الإيرادات (ألف)',
            dataPoints: [
              GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 45),
              GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 52),
              GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 61),
              GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 55),
              GeniusChartDataPoint(label: 'May', labelAr: 'مايو', value: 68),
              GeniusChartDataPoint(label: 'Jun', labelAr: 'يونيو', value: 78),
            ],
            color: const Color(0xFF9C27B0),
          ),
        ],
        settings:
            const GeniusLineChartSettings(type: GeniusLineChartType.curved),
      ),
      height: 180,
      spacing: 15,
    );

    // ================================================================
    // PAGE 3: Category Distribution with Pie Chart
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٣: توزيع الفئات مع مخطط دائري'
          : 'Example 3: Category Distribution with Pie Chart',
      spacing: 10,
    );

    addSpace(15);

    // Category distribution grid
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'category',
            title: 'Category',
            titleAr: 'الفئة',
            flexFactor: 2,
          ),
          GeniusPdfGridColumn.numeric(
            id: 'items',
            title: 'Items',
            titleAr: 'العناصر',
            width: 70,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn.currency(
            id: 'sales',
            title: 'Sales',
            titleAr: 'المبيعات',
            widthPercent: 0.25,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.numeric(
            id: 'percent',
            title: 'Share %',
            titleAr: 'الحصة %',
            width: 80,
            alignment: GeniusPdfTextAlign.center,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'إلكترونيات' : 'Electronics',
            'items': 245,
            'sales': 185000.0,
            'percent': 35.0,
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'ملابس' : 'Clothing',
            'items': 520,
            'sales': 135000.0,
            'percent': 26.0,
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'أثاث' : 'Furniture',
            'items': 78,
            'sales': 98000.0,
            'percent': 19.0,
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'كتب' : 'Books',
            'items': 890,
            'sales': 52000.0,
            'percent': 10.0,
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'أخرى' : 'Others',
            'items': 312,
            'sales': 52000.0,
            'percent': 10.0,
          }),
        ],
        footerRows: [
          GeniusPdfGridRow.total({
            'category': config.isRTL ? 'الإجمالي' : 'Total',
            'items': 2045,
            'sales': 522000.0,
            'percent': 100.0,
          }),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    addSpace(20);

    // Pie chart for category distribution
    addPieChart(
      GeniusPdfPieChart(
        config: config,
        title: config.isRTL ? 'توزيع المبيعات' : 'Sales Distribution',
        titleAr: 'توزيع المبيعات',
        dataPoints: [
          GeniusChartDataPoint(
            label: 'Electronics',
            labelAr: 'إلكترونيات',
            value: 35,
            color: const Color(0xFF2196F3),
          ),
          GeniusChartDataPoint(
            label: 'Clothing',
            labelAr: 'ملابس',
            value: 26,
            color: const Color(0xFF4CAF50),
          ),
          GeniusChartDataPoint(
            label: 'Furniture',
            labelAr: 'أثاث',
            value: 19,
            color: const Color(0xFFFF9800),
          ),
          GeniusChartDataPoint(
            label: 'Books',
            labelAr: 'كتب',
            value: 10,
            color: const Color(0xFF9C27B0),
          ),
          GeniusChartDataPoint(
            label: 'Others',
            labelAr: 'أخرى',
            value: 10,
            color: const Color(0xFF607D8B),
          ),
        ],
        settings: const GeniusPieChartSettings(),
      ),
      height: 200,
      spacing: 15,
    );

    addSpace(15);

    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملخص التقرير' : 'Report Summary',
        titleAr: 'ملخص التقرير',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'إجمالي المبيعات' : 'Total Sales',
            labelAr: 'إجمالي المبيعات',
            value: config.isRTL ? '٥٢٢,٠٠٠ ر.س' : 'SAR 522,000',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'أعلى فئة' : 'Top Category',
            labelAr: 'أعلى فئة',
            value: config.isRTL ? 'إلكترونيات (٣٥%)' : 'Electronics (35%)',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'إجمالي العناصر' : 'Total Items',
            labelAr: 'إجمالي العناصر',
            value: '2,045',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.success(),
      ),
      spacing: 10,
    );
  }
}
