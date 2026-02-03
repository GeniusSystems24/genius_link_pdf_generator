import 'dart:ui';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a comprehensive Chart demo PDF document.
///
/// Demonstrates all chart types with various features:
/// 1. Bar charts with groups, stacked, horizontal
/// 2. Line charts with curved, stepped, filled
/// 3. Pie charts with donut, groups
/// 4. Area charts with stacked
/// 5. Layout configurations and styling
class ChartDemoBuilder extends GeniusPdfDocumentBuilder {
  ChartDemoBuilder(super.config);

  @override
  void build() {
    // ================================================================
    // PAGE 1: Bar Charts with Groups
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'المخططات — Charts Demo v2.12.6'
          : 'Charts Demo v2.12.6',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'مثال ١: مخطط أعمدة مع مجموعات'
          : 'Example 1: Bar Chart with Groups',
      topMargin: 5,
    );

    addSpace(15);

    // Bar chart with grouped data
    addBarChart(
      GeniusPdfBarChart(
        config: config,
        title: config.isRTL ? 'المبيعات حسب الفئة والربع' : 'Sales by Category and Quarter',
        titleAr: 'المبيعات حسب الفئة والربع',
        series: const [],
        groups: [
          GeniusChartDataGroup.income(
            name: 'Q1 2026',
            nameAr: 'ر١ ٢٠٢٦',
            dataPoints: [
              GeniusChartDataPoint(
                label: 'Electronics',
                labelAr: 'إلكترونيات',
                value: 125,
                color: Color(0xFF2196F3),
              ),
              GeniusChartDataPoint(
                label: 'Clothing',
                labelAr: 'ملابس',
                value: 85,
                color: Color(0xFF4CAF50),
              ),
              GeniusChartDataPoint(
                label: 'Books',
                labelAr: 'كتب',
                value: 45,
                color: Color(0xFFFF9800),
              ),
            ],
          ),
          GeniusChartDataGroup.expense(
            name: 'Q2 2026',
            nameAr: 'ر٢ ٢٠٢٦',
            dataPoints: [
              GeniusChartDataPoint(
                label: 'Electronics',
                labelAr: 'إلكترونيات',
                value: 145,
                color: Color(0xFF2196F3),
              ),
              GeniusChartDataPoint(
                label: 'Clothing',
                labelAr: 'ملابس',
                value: 95,
                color: Color(0xFF4CAF50),
              ),
              GeniusChartDataPoint(
                label: 'Books',
                labelAr: 'كتب',
                value: 55,
                color: Color(0xFFFF9800),
              ),
            ],
          ),
        ],
        settings: const GeniusBarChartSettings(
          type: GeniusBarChartType.vertical,
          showValues: true,
          cornerRadius: 4,
        ),
        layoutConfig: GeniusChartLayoutConfig.standard(),
      ),
      height: 200,
      spacing: 15,
    );

    addSpace(20);

    addLine(
      config.isRTL
          ? 'مثال ٢: مخطط أعمدة مكدس'
          : 'Example 2: Stacked Bar Chart',
      topMargin: 5,
    );

    addSpace(15);

    // Stacked bar chart
    addBarChart(
      GeniusPdfBarChart(
        config: config,
        title: config.isRTL ? 'توزيع الإيرادات' : 'Revenue Distribution',
        titleAr: 'توزيع الإيرادات',
        series: [
          GeniusChartSeries(
            name: 'Product',
            nameAr: 'المنتجات',
            dataPoints: [
              GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 50),
              GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 60),
              GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 70),
              GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 55),
            ],
            color: const Color(0xFF2196F3),
          ),
          GeniusChartSeries(
            name: 'Service',
            nameAr: 'الخدمات',
            dataPoints: [
              GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 30),
              GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 35),
              GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 40),
              GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 45),
            ],
            color: const Color(0xFF4CAF50),
          ),
          GeniusChartSeries(
            name: 'Support',
            nameAr: 'الدعم',
            dataPoints: [
              GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 20),
              GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 25),
              GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 15),
              GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 30),
            ],
            color: const Color(0xFFFF9800),
          ),
        ],
        settings: const GeniusBarChartSettings(
          type: GeniusBarChartType.stacked,
          showValues: false,
        ),
      ),
      height: 180,
      spacing: 15,
    );

    // ================================================================
    // PAGE 2: Line Charts
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مخططات خطية — Line Charts'
          : 'Line Charts',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'مثال ٣: مخطط خطي منحني مع تعبئة'
          : 'Example 3: Curved Line Chart with Fill',
      topMargin: 5,
    );

    addSpace(15);

    // Curved line chart with fill
    addLineChart(
      GeniusPdfLineChart(
        config: config,
        title: config.isRTL ? 'اتجاه النمو' : 'Growth Trend',
        titleAr: 'اتجاه النمو',
        series: [
          GeniusChartSeries(
            name: 'Revenue',
            nameAr: 'الإيرادات',
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
          GeniusChartSeries(
            name: 'Profit',
            nameAr: 'الربح',
            dataPoints: [
              GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 15),
              GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 22),
              GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 28),
              GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 25),
              GeniusChartDataPoint(label: 'May', labelAr: 'مايو', value: 35),
              GeniusChartDataPoint(label: 'Jun', labelAr: 'يونيو', value: 42),
            ],
            color: const Color(0xFF4CAF50),
          ),
        ],
        settings: const GeniusLineChartSettings(
          type: GeniusLineChartType.curved,
          fillArea: true,
          fillOpacity: 0.2,
          showPoints: true,
          showValues: false,
        ),
        layoutConfig: GeniusChartLayoutConfig.standard(),
      ),
      height: 200,
      spacing: 15,
    );

    addSpace(20);

    addLine(
      config.isRTL
          ? 'مثال ٤: مخطط خطي متدرج'
          : 'Example 4: Stepped Line Chart',
      topMargin: 5,
    );

    addSpace(15);

    // Stepped line chart
    addLineChart(
      GeniusPdfLineChart(
        config: config,
        title: config.isRTL ? 'مستوى المخزون' : 'Stock Levels',
        titleAr: 'مستوى المخزون',
        series: [
          GeniusChartSeries(
            name: 'Warehouse A',
            nameAr: 'مستودع أ',
            dataPoints: [
              GeniusChartDataPoint(label: 'Week 1', labelAr: 'أسبوع ١', value: 100),
              GeniusChartDataPoint(label: 'Week 2', labelAr: 'أسبوع ٢', value: 85),
              GeniusChartDataPoint(label: 'Week 3', labelAr: 'أسبوع ٣', value: 85),
              GeniusChartDataPoint(label: 'Week 4', labelAr: 'أسبوع ٤', value: 120),
              GeniusChartDataPoint(label: 'Week 5', labelAr: 'أسبوع ٥', value: 95),
            ],
            color: const Color(0xFF2196F3),
          ),
        ],
        settings: const GeniusLineChartSettings(
          type: GeniusLineChartType.stepped,
          showPoints: true,
          showValues: true,
        ),
      ),
      height: 180,
      spacing: 15,
    );

    // ================================================================
    // PAGE 3: Pie and Area Charts
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مخططات دائرية ومساحية'
          : 'Pie & Area Charts',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'مثال ٥: مخطط دائري مجوف (Donut)'
          : 'Example 5: Donut Chart',
      topMargin: 5,
    );

    addSpace(15);

    // Donut chart
    addPieChart(
      GeniusPdfPieChart(
        config: config,
        title: config.isRTL ? 'توزيع الميزانية' : 'Budget Distribution',
        titleAr: 'توزيع الميزانية',
        dataPoints: [
          GeniusChartDataPoint(
            label: 'Marketing',
            labelAr: 'تسويق',
            value: 30,
            color: const Color(0xFF2196F3),
          ),
          GeniusChartDataPoint(
            label: 'Development',
            labelAr: 'تطوير',
            value: 35,
            color: const Color(0xFF4CAF50),
          ),
          GeniusChartDataPoint(
            label: 'Operations',
            labelAr: 'عمليات',
            value: 20,
            color: const Color(0xFFFF9800),
          ),
          GeniusChartDataPoint(
            label: 'HR',
            labelAr: 'موارد بشرية',
            value: 15,
            color: const Color(0xFF9C27B0),
          ),
        ],
        settings: GeniusPieChartSettings.donut(),
        legend: const GeniusChartLegend(
          position: GeniusChartLegendPosition.right,
          orientation: GeniusChartLegendOrientation.vertical,
        ),
      ),
      height: 200,
      spacing: 15,
    );

    addSpace(20);

    addLine(
      config.isRTL
          ? 'مثال ٦: مخطط مساحي مكدس'
          : 'Example 6: Stacked Area Chart',
      topMargin: 5,
    );

    addSpace(15);

    // Stacked area chart
    addAreaChart(
      GeniusPdfAreaChart(
        config: config,
        title: config.isRTL ? 'مصادر الزيارات' : 'Traffic Sources',
        titleAr: 'مصادر الزيارات',
        series: [
          GeniusChartSeries(
            name: 'Organic',
            nameAr: 'طبيعي',
            dataPoints: [
              GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 30),
              GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 35),
              GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 40),
              GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 38),
            ],
            color: const Color(0xFF4CAF50),
          ),
          GeniusChartSeries(
            name: 'Paid',
            nameAr: 'مدفوع',
            dataPoints: [
              GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 20),
              GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 25),
              GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 30),
              GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 35),
            ],
            color: const Color(0xFF2196F3),
          ),
          GeniusChartSeries(
            name: 'Direct',
            nameAr: 'مباشر',
            dataPoints: [
              GeniusChartDataPoint(label: 'Jan', labelAr: 'يناير', value: 15),
              GeniusChartDataPoint(label: 'Feb', labelAr: 'فبراير', value: 18),
              GeniusChartDataPoint(label: 'Mar', labelAr: 'مارس', value: 20),
              GeniusChartDataPoint(label: 'Apr', labelAr: 'أبريل', value: 22),
            ],
            color: const Color(0xFFFF9800),
          ),
        ],
        settings: const GeniusAreaChartSettings(
          stacked: true,
          lineType: GeniusLineChartType.curved,
          fillOpacity: 0.6,
        ),
      ),
      height: 180,
      spacing: 15,
    );

    // ================================================================
    // PAGE 4: Compact Layout Charts
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'تخطيطات مختلفة — Layout Configurations'
          : 'Layout Configurations',
      spacing: 10,
    );

    addLine(
      config.isRTL
          ? 'مثال ٧: تخطيط مضغوط'
          : 'Example 7: Compact Layout',
      topMargin: 5,
    );

    addSpace(10);

    // Compact bar chart
    addBarChart(
      GeniusPdfBarChart(
        config: config,
        title: config.isRTL ? 'مقارنة سريعة' : 'Quick Comparison',
        titleAr: 'مقارنة سريعة',
        series: [
          GeniusChartSeries(
            name: 'Value',
            nameAr: 'القيمة',
            dataPoints: [
              GeniusChartDataPoint(label: 'A', value: 45),
              GeniusChartDataPoint(label: 'B', value: 65),
              GeniusChartDataPoint(label: 'C', value: 35),
              GeniusChartDataPoint(label: 'D', value: 80),
            ],
            color: const Color(0xFF2196F3),
          ),
        ],
        settings: const GeniusBarChartSettings(
          showValues: true,
          barWidth: 20,
        ),
        layoutConfig: GeniusChartLayoutConfig.compact(),
      ),
      height: 150,
      spacing: 10,
    );

    addSpace(15);

    addLine(
      config.isRTL
          ? 'مثال ٨: تخطيط واسع'
          : 'Example 8: Spacious Layout',
      topMargin: 5,
    );

    addSpace(10);

    // Spacious line chart
    addLineChart(
      GeniusPdfLineChart(
        config: config,
        title: config.isRTL ? 'تحليل مفصل' : 'Detailed Analysis',
        titleAr: 'تحليل مفصل',
        series: [
          GeniusChartSeries(
            name: 'Actual',
            nameAr: 'الفعلي',
            dataPoints: [
              GeniusChartDataPoint(label: 'Q1', labelAr: 'ر١', value: 100),
              GeniusChartDataPoint(label: 'Q2', labelAr: 'ر٢', value: 120),
              GeniusChartDataPoint(label: 'Q3', labelAr: 'ر٣', value: 115),
              GeniusChartDataPoint(label: 'Q4', labelAr: 'ر٤', value: 140),
            ],
            color: const Color(0xFF4CAF50),
          ),
          GeniusChartSeries(
            name: 'Target',
            nameAr: 'المستهدف',
            dataPoints: [
              GeniusChartDataPoint(label: 'Q1', labelAr: 'ر١', value: 90),
              GeniusChartDataPoint(label: 'Q2', labelAr: 'ر٢', value: 100),
              GeniusChartDataPoint(label: 'Q3', labelAr: 'ر٣', value: 110),
              GeniusChartDataPoint(label: 'Q4', labelAr: 'ر٤', value: 120),
            ],
            color: const Color(0xFF9C27B0),
          ),
        ],
        settings: const GeniusLineChartSettings(
          type: GeniusLineChartType.straight,
          showPoints: true,
          showValues: true,
        ),
        layoutConfig: GeniusChartLayoutConfig.spacious(),
      ),
      height: 220,
      spacing: 15,
    );

    addSpace(15);

    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملخص المخططات' : 'Charts Summary',
        titleAr: 'ملخص المخططات',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'أنواع المخططات' : 'Chart Types',
            labelAr: 'أنواع المخططات',
            value: '4 (Bar, Line, Pie, Area)',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'ميزات جديدة' : 'New Features',
            labelAr: 'ميزات جديدة',
            value: config.isRTL ? 'المجموعات، إعدادات التخطيط' : 'Groups, Layout Config',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'الإصدار' : 'Version',
            labelAr: 'الإصدار',
            value: '2.12.6',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.success(),
      ),
      spacing: 10,
    );
  }
}
