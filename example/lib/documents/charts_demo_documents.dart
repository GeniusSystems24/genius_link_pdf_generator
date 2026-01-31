import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfTextStyle, PdfGridStyle, PdfBorderStyle, PdfGridColumn, PdfGridRow;

Future<Uint8List> buildBarChartPdf({
  required GeniusPdfConfig config,
  required GeniusBarChartType type,
}) async {
  final document = PdfDocument();
  final page = document.pages.add();
  final pageSize = page.getClientSize();

  _drawTitle(
    page,
    config.headerFont,
    'Bar Chart - ${type.name.toUpperCase()}',
  );

  final series = (type == GeniusBarChartType.grouped ||
          type == GeniusBarChartType.stacked)
      ? [
          GeniusChartSeries(
            name: 'Sales',
            nameAr: 'المبيعات',
            color: const Color(0xFF2196F3),
            dataPoints: _getMonthlySalesData(),
          ),
          GeniusChartSeries(
            name: 'Expenses',
            nameAr: 'المصروفات',
            color: const Color(0xFFF44336),
            dataPoints: _getMonthlyExpensesData(),
          ),
        ]
      : [
          GeniusChartSeries(
            name: 'Revenue',
            nameAr: 'الإيرادات',
            color: const Color(0xFF4CAF50),
            dataPoints: _getMonthlySalesData(),
          ),
        ];

  final chart = GeniusPdfBarChart(
    title: 'Monthly Performance',
    titleAr: 'الأداء الشهري',
    series: series,
    settings: GeniusBarChartSettings(
      type: type,
      barWidth: type == GeniusBarChartType.horizontal ? 20 : 30,
      showValues: true,
      cornerRadius: 4,
    ),
    style: GeniusChartStyle.modern(),
    height: 300,
    baseFont: config.baseFont,
    boldFont: config.boldFont,
  );

  chart.draw(page, Rect.fromLTWH(20, 80, pageSize.width - 40, 300));

  final bytes = await document.save();
  document.dispose();
  return Uint8List.fromList(bytes);
}

Future<Uint8List> buildLineChartPdf({
  required GeniusPdfConfig config,
  required GeniusLineChartType type,
  required bool fillArea,
}) async {
  final document = PdfDocument();
  final page = document.pages.add();
  final pageSize = page.getClientSize();

  _drawTitle(
    page,
    config.headerFont,
    'Line Chart - ${type.name.toUpperCase()}${fillArea ? ' (Filled)' : ''}',
  );

  final chart = GeniusPdfLineChart(
    title: 'Revenue Trend',
    titleAr: 'اتجاه الإيرادات',
    series: [
      GeniusChartSeries(
        name: '2024',
        color: const Color(0xFF2196F3),
        dataPoints: _getQuarterlyData2024(),
      ),
      GeniusChartSeries(
        name: '2025',
        color: const Color(0xFF4CAF50),
        dataPoints: _getQuarterlyData2025(),
      ),
    ],
    settings: GeniusLineChartSettings(
      type: type,
      showPoints: true,
      pointSize: 6,
      fillArea: fillArea,
      fillOpacity: 0.2,
    ),
    style: GeniusChartStyle.modern(),
    height: 300,
    baseFont: config.baseFont,
    boldFont: config.boldFont,
  );

  chart.draw(page, Rect.fromLTWH(20, 80, pageSize.width - 40, 300));

  final bytes = await document.save();
  document.dispose();
  return Uint8List.fromList(bytes);
}

Future<Uint8List> buildPieChartPdf({
  required GeniusPdfConfig config,
  required bool isDonut,
  required bool showPercentages,
  required bool showLegend,
}) async {
  final document = PdfDocument();
  final page = document.pages.add();
  final pageSize = page.getClientSize();

  _drawTitle(page, config.headerFont, isDonut ? 'Donut Chart' : 'Pie Chart');

  final chart = GeniusPdfPieChart(
    title: 'Expense Distribution',
    titleAr: 'توزيع المصروفات',
    dataPoints: _getExpenseDistributionData(),
    settings: isDonut
        ? GeniusPieChartSettings.donut()
        : GeniusPieChartSettings(
            showLabels: true,
            showPercentages: showPercentages,
            labelPosition: GeniusPieLabelPosition.outside,
          ),
    legend: GeniusChartLegend(
      show: showLegend,
      position: showLegend
          ? GeniusChartLegendPosition.right
          : GeniusChartLegendPosition.bottom,
    ),
    style: GeniusChartStyle.modern(),
    height: 350,
    baseFont: config.baseFont,
    boldFont: config.boldFont,
  );

  chart.draw(page, Rect.fromLTWH(20, 80, pageSize.width - 40, 350));

  final bytes = await document.save();
  document.dispose();
  return Uint8List.fromList(bytes);
}

Future<Uint8List> buildAreaChartPdf({
  required GeniusPdfConfig config,
  required bool stacked,
  required bool curved,
  required bool showPoints,
}) async {
  final document = PdfDocument();
  final page = document.pages.add();
  final pageSize = page.getClientSize();

  _drawTitle(page, config.headerFont, 'Area Chart');

  final chart = GeniusPdfAreaChart(
    title: 'Website Traffic',
    titleAr: 'حركة الموقع',
    series: [
      GeniusChartSeries(
        name: 'Desktop',
        color: const Color(0xFF2196F3),
        dataPoints: _getWeeklyDesktopTraffic(),
      ),
      GeniusChartSeries(
        name: 'Mobile',
        color: const Color(0xFF4CAF50),
        dataPoints: _getWeeklyMobileTraffic(),
      ),
      GeniusChartSeries(
        name: 'Tablet',
        color: const Color(0xFFFF9800),
        dataPoints: _getWeeklyTabletTraffic(),
      ),
    ],
    settings: GeniusAreaChartSettings(
      stacked: stacked,
      lineType: curved
          ? GeniusLineChartType.curved
          : GeniusLineChartType.straight,
      fillOpacity: 0.4,
      showPoints: showPoints,
    ),
    style: GeniusChartStyle.modern(),
    height: 300,
    baseFont: config.baseFont,
    boldFont: config.boldFont,
  );

  chart.draw(page, Rect.fromLTWH(20, 80, pageSize.width - 40, 300));

  final bytes = await document.save();
  document.dispose();
  return Uint8List.fromList(bytes);
}

void _drawTitle(PdfPage page, PdfFont titleFont, String text) {
  page.graphics.drawString(
    text,
    titleFont,
    bounds: Rect.fromLTWH(20, 20, page.getClientSize().width - 40, 30),
    format: PdfStringFormat(alignment: PdfTextAlignment.center),
  );
}

List<GeniusChartDataPoint> _getMonthlySalesData() {
  return [
    GeniusChartDataPoint(label: 'Jan', value: 15000),
    GeniusChartDataPoint(label: 'Feb', value: 18000),
    GeniusChartDataPoint(label: 'Mar', value: 16500),
    GeniusChartDataPoint(label: 'Apr', value: 20000),
    GeniusChartDataPoint(label: 'May', value: 22000),
    GeniusChartDataPoint(label: 'Jun', value: 25000),
    GeniusChartDataPoint(label: 'Jul', value: 24000),
    GeniusChartDataPoint(label: 'Aug', value: 21000),
    GeniusChartDataPoint(label: 'Sep', value: 19000),
    GeniusChartDataPoint(label: 'Oct', value: 23000),
    GeniusChartDataPoint(label: 'Nov', value: 26000),
    GeniusChartDataPoint(label: 'Dec', value: 30000),
  ];
}

List<GeniusChartDataPoint> _getMonthlyExpensesData() {
  return [
    GeniusChartDataPoint(label: 'Jan', value: 10000),
    GeniusChartDataPoint(label: 'Feb', value: 11000),
    GeniusChartDataPoint(label: 'Mar', value: 10500),
    GeniusChartDataPoint(label: 'Apr', value: 12000),
    GeniusChartDataPoint(label: 'May', value: 13000),
    GeniusChartDataPoint(label: 'Jun', value: 14000),
    GeniusChartDataPoint(label: 'Jul', value: 13500),
    GeniusChartDataPoint(label: 'Aug', value: 12000),
    GeniusChartDataPoint(label: 'Sep', value: 11000),
    GeniusChartDataPoint(label: 'Oct', value: 12500),
    GeniusChartDataPoint(label: 'Nov', value: 14000),
    GeniusChartDataPoint(label: 'Dec', value: 16000),
  ];
}

List<GeniusChartDataPoint> _getQuarterlyData2024() {
  return [
    GeniusChartDataPoint(label: 'Q1', value: 50000),
    GeniusChartDataPoint(label: 'Q2', value: 55000),
    GeniusChartDataPoint(label: 'Q3', value: 52000),
    GeniusChartDataPoint(label: 'Q4', value: 60000),
  ];
}

List<GeniusChartDataPoint> _getQuarterlyData2025() {
  return [
    GeniusChartDataPoint(label: 'Q1', value: 60000),
    GeniusChartDataPoint(label: 'Q2', value: 40000),
    GeniusChartDataPoint(label: 'Q3', value: 75000),
    GeniusChartDataPoint(label: 'Q4', value: 85000),
  ];
}

List<GeniusChartDataPoint> _getExpenseDistributionData() {
  return [
    GeniusChartDataPoint(label: 'Rent', value: 5000),
    GeniusChartDataPoint(label: 'Salaries', value: 8000),
    GeniusChartDataPoint(label: 'Utilities', value: 1200),
    GeniusChartDataPoint(label: 'Marketing', value: 3000),
    GeniusChartDataPoint(label: 'Operations', value: 2500),
  ];
}

List<GeniusChartDataPoint> _getWeeklyDesktopTraffic() {
  return [
    GeniusChartDataPoint(label: 'Mon', value: 1200),
    GeniusChartDataPoint(label: 'Tue', value: 1350),
    GeniusChartDataPoint(label: 'Wed', value: 1250),
    GeniusChartDataPoint(label: 'Thu', value: 1400),
    GeniusChartDataPoint(label: 'Fri', value: 1100),
    GeniusChartDataPoint(label: 'Sat', value: 800),
    GeniusChartDataPoint(label: 'Sun', value: 950),
  ];
}

List<GeniusChartDataPoint> _getWeeklyMobileTraffic() {
  return [
    GeniusChartDataPoint(label: 'Mon', value: 800),
    GeniusChartDataPoint(label: 'Tue', value: 900),
    GeniusChartDataPoint(label: 'Wed', value: 950),
    GeniusChartDataPoint(label: 'Thu', value: 1000),
    GeniusChartDataPoint(label: 'Fri', value: 1100),
    GeniusChartDataPoint(label: 'Sat', value: 1400),
    GeniusChartDataPoint(label: 'Sun', value: 1500),
  ];
}

List<GeniusChartDataPoint> _getWeeklyTabletTraffic() {
  return [
    GeniusChartDataPoint(label: 'Mon', value: 200),
    GeniusChartDataPoint(label: 'Tue', value: 250),
    GeniusChartDataPoint(label: 'Wed', value: 220),
    GeniusChartDataPoint(label: 'Thu', value: 280),
    GeniusChartDataPoint(label: 'Fri', value: 300),
    GeniusChartDataPoint(label: 'Sat', value: 400),
    GeniusChartDataPoint(label: 'Sun', value: 450),
  ];
}
