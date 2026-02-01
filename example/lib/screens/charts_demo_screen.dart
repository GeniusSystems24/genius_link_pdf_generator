import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../documents/charts_demo_documents.dart';
import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';
import '../widgets/code_viewer.dart';
import '../widgets/custom_tab_bar.dart';

class ChartsDemoScreen extends StatefulWidget {
  final int initialTab;

  const ChartsDemoScreen({super.key, this.initialTab = 0});

  @override
  State<ChartsDemoScreen> createState() => _ChartsDemoScreenState();
}

class _ChartsDemoScreenState extends State<ChartsDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;

  // Chart Selections
  GeniusBarChartType _barType = GeniusBarChartType.vertical;
  GeniusLineChartType _lineType = GeniusLineChartType.straight;
  bool _lineFillArea = false;
  _PieChartType _pieType = _PieChartType.standard;
  _AreaChartType _areaType = _AreaChartType.overlapping;

  final List<CustomTabItem> _tabs = [
    CustomTabItem(
      id: 'bar',
      title: 'Bar Chart',
      icon: Icons.bar_chart_rounded,
      gradient: AppColors.primaryGradient,
    ),
    CustomTabItem(
      id: 'line',
      title: 'Line Chart',
      icon: Icons.show_chart_rounded,
      gradient: AppColors.purpleGradient,
    ),
    CustomTabItem(
      id: 'pie',
      title: 'Pie Chart',
      icon: Icons.pie_chart_rounded,
      gradient: AppColors.cyanGradient,
    ),
    CustomTabItem(
      id: 'area',
      title: 'Area Chart',
      icon: Icons.area_chart_rounded,
      gradient: AppColors.successGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, _tabs.length - 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      child: Column(
        children: [
          CustomTabBar(
            controller: _tabController,
            tabs: _tabs,
            isDark: isDark,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBarChartTab(isDark),
                _buildLineChartTab(isDark),
                _buildPieChartTab(isDark),
                _buildAreaChartTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Bar Chart Tab ---
  Widget _buildBarChartTab(bool isDark) {
    return _ChartPage(
      title: 'GeniusPdfBarChart',
      description:
          'Professional bar charts with support for multiple grouping and stacking modes.',
      icon: Icons.bar_chart_rounded,
      gradient: AppColors.primaryGradient,
      isDark: isDark,
      isGenerating: _isGenerating,
      onGenerate: () => _generateBarChart(_barType),
      codeExample: _getBarChartCode(),
      preview: _buildBarChartPreview(isDark),
      options: _buildBarChartOptions(isDark),
    );
  }

  Widget _buildBarChartOptions(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildChip('Vertical', _barType == GeniusBarChartType.vertical, isDark,
            () => setState(() => _barType = GeniusBarChartType.vertical)),
        _buildChip(
            'Horizontal',
            _barType == GeniusBarChartType.horizontal,
            isDark,
            () => setState(() => _barType = GeniusBarChartType.horizontal)),
        _buildChip('Grouped', _barType == GeniusBarChartType.grouped, isDark,
            () => setState(() => _barType = GeniusBarChartType.grouped)),
        _buildChip('Stacked', _barType == GeniusBarChartType.stacked, isDark,
            () => setState(() => _barType = GeniusBarChartType.stacked)),
      ],
    );
  }

  Widget _buildBarChartPreview(bool isDark) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: _barType == GeniusBarChartType.horizontal
          ? _buildHorizontalBarPreview(isDark)
          : _buildVerticalBarPreview(isDark),
    );
  }

  Widget _buildVerticalBarPreview(bool isDark) {
    final isGrouped = _barType == GeniusBarChartType.grouped;
    final isStacked = _barType == GeniusBarChartType.stacked;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (i) {
        final h1 = [120.0, 150.0, 100.0, 170.0, 130.0, 160.0][i];
        final h2 = [80.0, 100.0, 70.0, 110.0, 90.0, 105.0][i];
        final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];

        if (isStacked) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 28,
                height: h2 * 0.8,
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.8),
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ),
              Container(
                width: 28,
                height: h1 * 0.8,
                decoration: BoxDecoration(
                  gradient:
                      const LinearGradient(colors: AppColors.primaryGradient),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(4)),
                ),
              ),
              const SizedBox(height: 8),
              Text(months[i],
                  style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)),
            ],
          );
        }

        if (isGrouped) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 14,
                    height: h1 * 0.8,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  const SizedBox(width: 2),
                  Container(
                    width: 14,
                    height: h2 * 0.8,
                    decoration: BoxDecoration(
                      color: AppColors.error.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(months[i],
                  style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)),
            ],
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: 28,
              height: h1 * 0.9,
              decoration: BoxDecoration(
                gradient:
                    const LinearGradient(colors: AppColors.primaryGradient),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 8),
            Text(months[i],
                style: TextStyle(
                    fontSize: 10,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary)),
          ],
        );
      }),
    );
  }

  Widget _buildHorizontalBarPreview(bool isDark) {
    final values = [85.0, 72.0, 68.0, 55.0, 45.0];
    final labels = ['Sales', 'Marketing', 'Development', 'Support', 'HR'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(5, (i) {
        return Row(
          children: [
            SizedBox(
              width: 80,
              child: Text(labels[i],
                  textAlign: TextAlign.right,
                  style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 20,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkBorder.withOpacity(0.3)
                      : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: values[i] / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: AppColors.primaryGradient),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 35,
              child: Text('${values[i].toInt()}%',
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppColors.darkText : AppColors.lightText)),
            ),
          ],
        );
      }),
    );
  }

  // --- Line Chart Tab ---
  Widget _buildLineChartTab(bool isDark) {
    return _ChartPage(
      title: 'GeniusPdfLineChart',
      description:
          'Versatile line charts for trend analysis with customizable curvature and fill options.',
      icon: Icons.show_chart_rounded,
      gradient: AppColors.purpleGradient,
      isDark: isDark,
      isGenerating: _isGenerating,
      onGenerate: () => _generateLineChart(_lineType, fillArea: _lineFillArea),
      codeExample: _getLineChartCode(),
      preview: _buildLineChartPreview(isDark),
      options: _buildLineChartOptions(isDark),
    );
  }

  Widget _buildLineChartOptions(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildChip(
            'Straight',
            _lineType == GeniusLineChartType.straight && !_lineFillArea,
            isDark, () {
          setState(() {
            _lineType = GeniusLineChartType.straight;
            _lineFillArea = false;
          });
        }),
        _buildChip(
            'Curved',
            _lineType == GeniusLineChartType.curved && !_lineFillArea,
            isDark, () {
          setState(() {
            _lineType = GeniusLineChartType.curved;
            _lineFillArea = false;
          });
        }),
        _buildChip(
            'Stepped',
            _lineType == GeniusLineChartType.stepped && !_lineFillArea,
            isDark, () {
          setState(() {
            _lineType = GeniusLineChartType.stepped;
            _lineFillArea = false;
          });
        }),
        _buildChip('Area Fill', _lineFillArea, isDark, () {
          setState(() {
            _lineType = GeniusLineChartType.curved;
            _lineFillArea = true;
          });
        }),
      ],
    );
  }

  Widget _buildLineChartPreview(bool isDark) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 168),
        painter: _LineChartPainter(
          lineType: _lineType,
          fillArea: _lineFillArea,
          isDark: isDark,
        ),
      ),
    );
  }

  // --- Pie Chart Tab ---
  Widget _buildPieChartTab(bool isDark) {
    return _ChartPage(
      title: 'GeniusPdfPieChart',
      description:
          'Circular charts for proportional data visualization including donut and legend support.',
      icon: Icons.pie_chart_rounded,
      gradient: AppColors.cyanGradient,
      isDark: isDark,
      isGenerating: _isGenerating,
      onGenerate: () => _generatePieChartFromState(),
      codeExample: _getPieChartCode(),
      preview: _buildPieChartPreview(isDark),
      options: _buildPieChartOptions(isDark),
    );
  }

  Widget _buildPieChartOptions(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildChip('Standard', _pieType == _PieChartType.standard, isDark,
            () => setState(() => _pieType = _PieChartType.standard)),
        _buildChip('Donut', _pieType == _PieChartType.donut, isDark,
            () => setState(() => _pieType = _PieChartType.donut)),
        _buildChip('Percentages', _pieType == _PieChartType.percentages, isDark,
            () => setState(() => _pieType = _PieChartType.percentages)),
        _buildChip('With Legend', _pieType == _PieChartType.legend, isDark,
            () => setState(() => _pieType = _PieChartType.legend)),
      ],
    );
  }

  Widget _buildPieChartPreview(bool isDark) {
    final isDonut = _pieType == _PieChartType.donut;
    final showLegend = _pieType == _PieChartType.legend;
    final showPercentages = _pieType == _PieChartType.percentages;

    final data = [
      _PieSlice('Rent', 5000, AppColors.primary),
      _PieSlice('Salaries', 8000, AppColors.secondary),
      _PieSlice('Utilities', 1200, AppColors.accent),
      _PieSlice('Marketing', 3000, AppColors.success),
      _PieSlice('Operations', 2500, AppColors.warning),
    ];

    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: showLegend ? 2 : 1,
            child: Center(
              child: SizedBox(
                width: 140,
                height: 140,
                child: CustomPaint(
                  painter: _PieChartPainter(
                    data: data,
                    isDonut: isDonut,
                    showPercentages: showPercentages,
                    isDark: isDark,
                  ),
                ),
              ),
            ),
          ),
          if (showLegend) ...[
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: data.map((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  // --- Area Chart Tab ---
  Widget _buildAreaChartTab(bool isDark) {
    return _ChartPage(
      title: 'GeniusPdfAreaChart',
      description:
          'Area charts emphasizing magnitude of change over time with stacking support.',
      icon: Icons.area_chart_rounded,
      gradient: AppColors.successGradient,
      isDark: isDark,
      isGenerating: _isGenerating,
      onGenerate: () => _generateAreaChartFromState(),
      codeExample: _getAreaChartCode(),
      preview: _buildAreaChartPreview(isDark),
      options: _buildAreaChartOptions(isDark),
    );
  }

  Widget _buildAreaChartOptions(bool isDark) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildChip(
            'Overlapping',
            _areaType == _AreaChartType.overlapping,
            isDark,
            () => setState(() => _areaType = _AreaChartType.overlapping)),
        _buildChip('Stacked', _areaType == _AreaChartType.stacked, isDark,
            () => setState(() => _areaType = _AreaChartType.stacked)),
        _buildChip('Curved', _areaType == _AreaChartType.curved, isDark,
            () => setState(() => _areaType = _AreaChartType.curved)),
        _buildChip('With Points', _areaType == _AreaChartType.points, isDark,
            () => setState(() => _areaType = _AreaChartType.points)),
      ],
    );
  }

  Widget _buildAreaChartPreview(bool isDark) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: CustomPaint(
        size: const Size(double.infinity, 168),
        painter: _AreaChartPainter(
          areaType: _areaType,
          isDark: isDark,
        ),
      ),
    );
  }

  // --- Shared UI Components ---
  Widget _buildChip(
      String label, bool selected, bool isDark, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: selected
              ? const LinearGradient(colors: AppColors.primaryGradient)
              : null,
          color: selected
              ? null
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected
                ? Colors.transparent
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected
                ? Colors.white
                : (isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
          ),
        ),
      ),
    );
  }

  // --- Code Snippet Generators ---
  String _getBarChartCode() {
    final typeStr = _barType.toString().split('.')[1];
    return '''
final barChart = GeniusPdfBarChart(
  config: config,
  title: 'Monthly Performance',
  titleAr: 'الأداء الشهري',
  series: [
    GeniusChartSeries(
      name: 'Sales',
      color: const Color(0xFF2196F3),
      dataPoints: salesData,
    ),
    ${_barType == GeniusBarChartType.grouped || _barType == GeniusBarChartType.stacked ? "GeniusChartSeries(\n      name: 'Expenses',\n      color: const Color(0xFFF44336),\n      dataPoints: expensesData,\n    )," : "// ..."}
  ],
  settings: GeniusBarChartSettings(
    type: GeniusBarChartType.$typeStr,
    barWidth: ${_barType == GeniusBarChartType.horizontal ? 20 : 30},
    showValues: true,
  ),
);''';
  }

  String _getLineChartCode() {
    final typeStr = _lineType.toString().split('.')[1];
    return '''
final lineChart = GeniusPdfLineChart(
  config: config,
  title: 'Revenue Trend',
  series: [
    GeniusChartSeries(
      name: '2024',
      color: const Color(0xFF2196F3),
      dataPoints: data2024,
    ),
    GeniusChartSeries(
      name: '2025',
      color: const Color(0xFF4CAF50),
      dataPoints: data2025,
    ),
  ],
  settings: GeniusLineChartSettings(
    type: GeniusLineChartType.$typeStr,
    showPoints: true,
    fillArea: $_lineFillArea,
    fillOpacity: 0.2,
  ),
);''';
  }

  String _getPieChartCode() {
    String settings = '';
    String legend = '';

    switch (_pieType) {
      case _PieChartType.standard:
        settings = 'GeniusPieChartSettings(showLabels: true)';
        break;
      case _PieChartType.donut:
        settings = 'GeniusPieChartSettings.donut()';
        break;
      case _PieChartType.percentages:
        settings = 'GeniusPieChartSettings(showPercentages: true)';
        break;
      case _PieChartType.legend:
        settings = 'GeniusPieChartSettings(showLabels: false)';
        legend =
            '\n  legend: GeniusChartLegend(show: true, position: GeniusChartLegendPosition.right),';
        break;
    }

    return '''
final pieChart = GeniusPdfPieChart(
  config: config,
  title: 'Expense Distribution',
  dataPoints: [
    GeniusChartDataPoint(label: 'Rent', value: 5000),
    GeniusChartDataPoint(label: 'Salaries', value: 8000),
    GeniusChartDataPoint(label: 'Utilities', value: 1200),
    GeniusChartDataPoint(label: 'Marketing', value: 3000),
  ],
  settings: $settings,$legend
);''';
  }

  String _getAreaChartCode() {
    bool stacked = _areaType == _AreaChartType.stacked;
    bool curved = _areaType == _AreaChartType.curved;
    bool points = _areaType == _AreaChartType.points;

    return '''
final areaChart = GeniusPdfAreaChart(
  config: config,
  title: 'Website Traffic',
  series: [
    GeniusChartSeries(name: 'Desktop', dataPoints: desktopData),
    GeniusChartSeries(name: 'Mobile', dataPoints: mobileData),
    GeniusChartSeries(name: 'Tablet', dataPoints: tabletData),
  ],
  settings: GeniusAreaChartSettings(
    stacked: $stacked,
    lineType: ${curved ? 'GeniusLineChartType.curved' : 'GeniusLineChartType.straight'},
    showPoints: $points,
    fillOpacity: 0.4,
  ),
);''';
  }

  // --- Generation Methods ---
  Future<void> _generateBarChart(GeniusBarChartType type) async {
    setState(() => _isGenerating = true);
    try {
      final bytes = await buildBarChartPdf(
        config: geniusPdfConfig,
        type: type,
      );
      await _saveAndOpenPdf(bytes, 'bar_chart_${type.name}');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateLineChart(GeniusLineChartType type,
      {bool fillArea = false}) async {
    setState(() => _isGenerating = true);
    try {
      final bytes = await buildLineChartPdf(
        config: geniusPdfConfig,
        type: type,
        fillArea: fillArea,
      );
      await _saveAndOpenPdf(
        bytes,
        'line_chart_${type.name}${fillArea ? '_filled' : ''}',
      );
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generatePieChartFromState() async {
    return _generatePieChart(
      isDonut: _pieType == _PieChartType.donut,
      showPercentages: _pieType == _PieChartType.percentages,
      showLegend: _pieType == _PieChartType.legend,
    );
  }

  Future<void> _generatePieChart({
    bool isDonut = false,
    bool showPercentages = false,
    bool showLegend = false,
  }) async {
    setState(() => _isGenerating = true);
    try {
      final bytes = await buildPieChartPdf(
        config: geniusPdfConfig,
        isDonut: isDonut,
        showPercentages: showPercentages,
        showLegend: showLegend,
      );
      await _saveAndOpenPdf(bytes, 'pie_chart');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateAreaChartFromState() async {
    return _generateAreaChart(
      stacked: _areaType == _AreaChartType.stacked,
      curved: _areaType == _AreaChartType.curved,
      showPoints: _areaType == _AreaChartType.points,
    );
  }

  Future<void> _generateAreaChart({
    bool stacked = false,
    bool curved = false,
    bool showPoints = false,
  }) async {
    setState(() => _isGenerating = true);
    try {
      final bytes = await buildAreaChartPdf(
        config: geniusPdfConfig,
        stacked: stacked,
        curved: curved,
        showPoints: showPoints,
      );
      await _saveAndOpenPdf(bytes, 'area_chart');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  // --- Helper Methods ---
  Future<void> _saveAndOpenPdf(Uint8List bytes, String fileName) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);

    await OpenFile.open(file.path);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('PDF generated successfully'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// --- Enums ---
enum _PieChartType { standard, donut, percentages, legend }

enum _AreaChartType { overlapping, stacked, curved, points }

// --- Data Classes ---

class _PieSlice {
  final String label;
  final double value;
  final Color color;

  const _PieSlice(this.label, this.value, this.color);
}

// --- Chart Page Widget ---
class _ChartPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final bool isDark;
  final bool isGenerating;
  final VoidCallback onGenerate;
  final String codeExample;
  final Widget preview;
  final Widget options;

  const _ChartPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.isDark,
    required this.isGenerating,
    required this.onGenerate,
    required this.codeExample,
    required this.preview,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildOptions(),
          const SizedBox(height: 16),
          _buildPreview(),
          const SizedBox(height: 16),
          _buildCode(),
          const SizedBox(height: 16),
          _buildGenerateButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          gradient.first.withOpacity(isDark ? 0.2 : 0.1),
          gradient.last.withOpacity(isDark ? 0.1 : 0.05),
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradient.first.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tune_rounded,
                size: 18,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Chart Type',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          options,
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.preview_rounded,
                size: 18,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                'Preview',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          preview,
        ],
      ),
    );
  }

  Widget _buildCode() {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.code_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Code Example',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
          CodeViewer(code: codeExample, height: 220),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isGenerating ? null : LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(14),
        boxShadow: isGenerating
            ? null
            : [
                BoxShadow(
                  color: gradient.first.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton.icon(
        onPressed: isGenerating ? null : onGenerate,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: AppColors.darkBorder.withOpacity(0.5),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: isGenerating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.picture_as_pdf_rounded, size: 22),
        label: Text(
          isGenerating ? 'Generating...' : 'Generate PDF',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// --- Custom Painters for Chart Previews ---
class _LineChartPainter extends CustomPainter {
  final GeniusLineChartType lineType;
  final bool fillArea;
  final bool isDark;

  _LineChartPainter({
    required this.lineType,
    required this.fillArea,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final paint2 = Paint()
      ..color = AppColors.success
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    final fillPaint1 = Paint()
      ..color = AppColors.primary.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final fillPaint2 = Paint()
      ..color = AppColors.success.withOpacity(0.2)
      ..style = PaintingStyle.fill;

    final points1 = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.4, size.height * 0.5),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.35),
      Offset(size.width, size.height * 0.2),
    ];

    final points2 = [
      Offset(0, size.height * 0.8),
      Offset(size.width * 0.2, size.height * 0.7),
      Offset(size.width * 0.4, size.height * 0.75),
      Offset(size.width * 0.6, size.height * 0.55),
      Offset(size.width * 0.8, size.height * 0.5),
      Offset(size.width, size.height * 0.4),
    ];

    final path1 = _createPath(points1, size);
    final path2 = _createPath(points2, size);

    if (fillArea) {
      final fillPath1 = Path.from(path1)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      final fillPath2 = Path.from(path2)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();

      canvas.drawPath(fillPath1, fillPaint1);
      canvas.drawPath(fillPath2, fillPaint2);
    }

    canvas.drawPath(path1, paint1);
    canvas.drawPath(path2, paint2);

    // Draw points
    final pointPaint1 = Paint()..color = AppColors.primary;
    final pointPaint2 = Paint()..color = AppColors.success;

    for (final p in points1) {
      canvas.drawCircle(p, 4, pointPaint1);
    }
    for (final p in points2) {
      canvas.drawCircle(p, 4, pointPaint2);
    }
  }

  Path _createPath(List<Offset> points, Size size) {
    final path = Path();

    if (lineType == GeniusLineChartType.stepped) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i - 1].dy);
        path.lineTo(points[i].dx, points[i].dy);
      }
    } else if (lineType == GeniusLineChartType.curved) {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlX = (p0.dx + p1.dx) / 2;
        path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
      }
    } else {
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) =>
      lineType != oldDelegate.lineType ||
      fillArea != oldDelegate.fillArea ||
      isDark != oldDelegate.isDark;
}

class _PieChartPainter extends CustomPainter {
  final List<_PieSlice> data;
  final bool isDonut;
  final bool showPercentages;
  final bool isDark;

  _PieChartPainter({
    required this.data,
    required this.isDonut,
    required this.showPercentages,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    final total = data.fold<double>(0, (sum, item) => sum + item.value);

    double startAngle = -1.5708; // -90 degrees in radians

    for (final slice in data) {
      final sweepAngle = (slice.value / total) * 6.2832; // 2*PI
      final paint = Paint()
        ..color = slice.color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      if (showPercentages) {
        final percentage = (slice.value / total * 100).toStringAsFixed(0);
        final midAngle = startAngle + sweepAngle / 2;
        final labelRadius = radius * 0.65;
        final labelX = center.dx + labelRadius * (midAngle).cos();
        final labelY = center.dy + labelRadius * (midAngle).sin();

        final textPainter = TextPainter(
          text: TextSpan(
            text: '$percentage%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(
              labelX - textPainter.width / 2, labelY - textPainter.height / 2),
        );
      }

      startAngle += sweepAngle;
    }

    if (isDonut) {
      final innerRadius = radius * 0.55;
      final innerPaint = Paint()
        ..color = isDark ? AppColors.darkBg : Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(center, innerRadius, innerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _PieChartPainter oldDelegate) =>
      isDonut != oldDelegate.isDonut ||
      showPercentages != oldDelegate.showPercentages ||
      isDark != oldDelegate.isDark;
}

class _AreaChartPainter extends CustomPainter {
  final _AreaChartType areaType;
  final bool isDark;

  _AreaChartPainter({required this.areaType, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
    ];

    final stacked = areaType == _AreaChartType.stacked;
    final curved = areaType == _AreaChartType.curved;
    final showPoints = areaType == _AreaChartType.points;

    // Data sets (normalized to chart height)
    final dataSets = [
      [0.3, 0.35, 0.32, 0.38, 0.28, 0.22, 0.25],
      [0.2, 0.25, 0.26, 0.28, 0.30, 0.38, 0.40],
      [0.1, 0.12, 0.11, 0.14, 0.15, 0.20, 0.22],
    ];

    if (stacked) {
      // Draw stacked areas (bottom to top)
      List<double> baseValues = List.filled(7, 0);

      for (int s = dataSets.length - 1; s >= 0; s--) {
        final points = <Offset>[];
        for (int i = 0; i < 7; i++) {
          final x = i * size.width / 6;
          final y = size.height * (1 - baseValues[i] - dataSets[s][i]);
          points.add(Offset(x, y));
        }

        final path = _createPath(points, curved);
        final fillPath = Path.from(path)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

        canvas.drawPath(
          fillPath,
          Paint()
            ..color = colors[s].withOpacity(0.5)
            ..style = PaintingStyle.fill,
        );
        canvas.drawPath(
          path,
          Paint()
            ..color = colors[s]
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke,
        );

        // Update base for next layer
        for (int i = 0; i < 7; i++) {
          baseValues[i] += dataSets[s][i];
        }
      }
    } else {
      // Draw overlapping areas
      for (int s = 0; s < dataSets.length; s++) {
        final points = <Offset>[];
        for (int i = 0; i < 7; i++) {
          final x = i * size.width / 6;
          final y = size.height * (1 - dataSets[s][i]);
          points.add(Offset(x, y));
        }

        final path = _createPath(points, curved);
        final fillPath = Path.from(path)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height)
          ..close();

        canvas.drawPath(
          fillPath,
          Paint()
            ..color = colors[s].withOpacity(0.3)
            ..style = PaintingStyle.fill,
        );
        canvas.drawPath(
          path,
          Paint()
            ..color = colors[s]
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke,
        );

        if (showPoints) {
          for (final p in points) {
            canvas.drawCircle(
              p,
              4,
              Paint()..color = colors[s],
            );
          }
        }
      }
    }
  }

  Path _createPath(List<Offset> points, bool curved) {
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    if (curved) {
      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];
        final controlX = (p0.dx + p1.dx) / 2;
        path.cubicTo(controlX, p0.dy, controlX, p1.dy, p1.dx, p1.dy);
      }
    } else {
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    return path;
  }

  @override
  bool shouldRepaint(covariant _AreaChartPainter oldDelegate) =>
      areaType != oldDelegate.areaType || isDark != oldDelegate.isDark;
}

// Math extension for cos/sin
extension on double {
  double cos() => _cos(this);
  double sin() => _sin(this);
}

double _cos(double x) {
  return 1.0 -
      (x * x) / 2 +
      (x * x * x * x) / 24 -
      (x * x * x * x * x * x) / 720;
}

double _sin(double x) {
  return x -
      (x * x * x) / 6 +
      (x * x * x * x * x) / 120 -
      (x * x * x * x * x * x * x) / 5040;
}
