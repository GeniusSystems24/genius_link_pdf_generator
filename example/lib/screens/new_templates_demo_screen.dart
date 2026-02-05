import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../documents/financial_templates.dart';
import '../documents/hr_templates.dart';
import '../documents/sales_templates.dart';
import '../documents/shared_build.dart';
import '../theme/app_theme.dart';
// import '../widgets/custom_tab_bar.dart';

/// Demo screen showcasing the new report templates added in v1.3.0.
/// Redesigned with professional dashboard styling.
class NewTemplatesDemoScreen extends StatefulWidget {
  const NewTemplatesDemoScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<NewTemplatesDemoScreen> createState() => _NewTemplatesDemoScreenState();
}

class _NewTemplatesDemoScreenState extends State<NewTemplatesDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;
  bool _isRTL = true;
  String? _generatingTemplate;

  final List<_NewTemplateTab> _tabs = [
    _NewTemplateTab(
      id: 'financial',
      title: 'Financial',
      icon: Icons.account_balance_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _NewTemplateTab(
      id: 'sales',
      title: 'Sales',
      icon: Icons.shopping_cart_rounded,
      gradient: AppColors.successGradient,
    ),
    _NewTemplateTab(
      id: 'hr',
      title: 'HR',
      icon: Icons.people_rounded,
      gradient: AppColors.purpleGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _isDark ? AppColors.darkBg : AppColors.lightBg,
      child: Column(
        children: [
          _buildHeader(),
          _buildTabBar(_isDark),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildFinancialTab(),
                _buildSalesTab(),
                _buildHRTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        padding: const EdgeInsets.all(6),
        indicator: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: _tabs.map((tab) {
          return Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tab.icon, size: 16),
                const SizedBox(width: 6),
                Text(
                  tab.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PDF Templates',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Professional report templates for your business needs',
                  style: TextStyle(
                    fontSize: 14,
                    color: _isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          _buildRTLToggle(),
        ],
      ),
    );
  }

  Widget _buildRTLToggle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'RTL',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: _isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 24,
            child: Switch(
              value: _isRTL,
              onChanged: (value) => setState(() => _isRTL = value),
              activeThumbColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinancialTab() {
    return _buildTabContent(
      icon: Icons.account_balance,
      gradient: AppColors.primaryGradient,
      title: 'Financial Reports',
      titleAr: 'التقارير المالية',
      description:
          'Generate professional financial statements and reports including balance sheets, income statements, and cash flow analysis.',
      templates: [
        _TemplateInfo(
          title: 'Balance Sheet',
          titleAr: 'الميزانية العمومية',
          description:
              'Generate a balance sheet showing assets, liabilities, and equity.',
          icon: Icons.account_balance_wallet,
          gradient: AppColors.primaryGradient,
          onGenerate: _generateBalanceSheet,
        ),
        _TemplateInfo(
          title: 'Income Statement',
          titleAr: 'قائمة الدخل',
          description:
              'Generate a P&L statement with revenue, expenses, and profitability.',
          icon: Icons.trending_up,
          gradient: AppColors.successGradient,
          onGenerate: _generateIncomeStatement,
        ),
        _TemplateInfo(
          title: 'Cash Flow Statement',
          titleAr: 'قائمة التدفقات النقدية',
          description:
              'Generate a cash flow statement with operating, investing, and financing activities.',
          icon: Icons.water_drop,
          gradient: AppColors.cyanGradient,
          onGenerate: _generateCashFlow,
        ),
        _TemplateInfo(
          title: 'Budget Report',
          titleAr: 'تقرير الميزانية',
          description:
              'Generate a budget vs actual comparison with variance analysis.',
          icon: Icons.pie_chart,
          gradient: AppColors.purpleGradient,
          onGenerate: _generateBudgetReport,
        ),
      ],
    );
  }

  Widget _buildSalesTab() {
    return _buildTabContent(
      icon: Icons.shopping_cart,
      gradient: AppColors.successGradient,
      title: 'Sales Documents',
      titleAr: 'مستندات المبيعات',
      description:
          'Create professional sales documents including quotations, purchase orders, delivery notes, and credit notes.',
      templates: [
        _TemplateInfo(
          title: 'Quotation',
          titleAr: 'عرض سعر',
          description: 'Generate a professional price quotation for customers.',
          icon: Icons.request_quote,
          gradient: AppColors.successGradient,
          onGenerate: _generateQuotation,
        ),
        _TemplateInfo(
          title: 'Purchase Order',
          titleAr: 'أمر شراء',
          description: 'Generate a purchase order for vendors.',
          icon: Icons.shopping_bag,
          gradient: AppColors.infoGradient,
          onGenerate: _generatePurchaseOrder,
        ),
        _TemplateInfo(
          title: 'Delivery Note',
          titleAr: 'إشعار تسليم',
          description: 'Generate a delivery note for shipments.',
          icon: Icons.local_shipping,
          gradient: AppColors.orangeGradient,
          onGenerate: _generateDeliveryNote,
        ),
        _TemplateInfo(
          title: 'Credit Note',
          titleAr: 'إشعار دائن',
          description: 'Generate a credit note for returns or adjustments.',
          icon: Icons.money_off,
          gradient: AppColors.warningGradient,
          onGenerate: _generateCreditNote,
        ),
      ],
    );
  }

  Widget _buildHRTab() {
    return _buildTabContent(
      icon: Icons.people,
      gradient: AppColors.purpleGradient,
      title: 'HR Documents',
      titleAr: 'مستندات الموارد البشرية',
      description:
          'Generate comprehensive HR documents including payslips, employee reports, attendance, and leave management.',
      templates: [
        _TemplateInfo(
          title: 'Payslip',
          titleAr: 'كشف راتب',
          description:
              'Generate an employee payslip with earnings and deductions.',
          icon: Icons.payments,
          gradient: AppColors.purpleGradient,
          onGenerate: _generatePayslip,
        ),
        _TemplateInfo(
          title: 'Employee Report',
          titleAr: 'تقرير الموظفين',
          description: 'Generate a comprehensive employee report.',
          icon: Icons.badge,
          gradient: AppColors.tealGradient,
          onGenerate: _generateEmployeeReport,
        ),
        _TemplateInfo(
          title: 'Attendance Report',
          titleAr: 'تقرير الحضور',
          description: 'Generate an attendance tracking report.',
          icon: Icons.access_time,
          gradient: AppColors.pinkGradient,
          onGenerate: _generateAttendanceReport,
        ),
        _TemplateInfo(
          title: 'Leave Report',
          titleAr: 'تقرير الإجازات',
          description: 'Generate a leave balance and requests report.',
          icon: Icons.event_busy,
          gradient: AppColors.cyanGradient,
          onGenerate: _generateLeaveReport,
        ),
      ],
    );
  }

  Widget _buildTabContent({
    required IconData icon,
    required List<Color> gradient,
    required String title,
    required String titleAr,
    required String description,
    required List<_TemplateInfo> templates,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryHeader(
            icon: icon,
            gradient: gradient,
            title: title,
            titleAr: titleAr,
            description: description,
          ),
          const SizedBox(height: 16),
          _buildTemplateGrid(templates),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader({
    required IconData icon,
    required List<Color> gradient,
    required String title,
    required String titleAr,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: gradient,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _isDark
                              ? AppColors.darkText
                              : AppColors.lightText,
                        ),
                      ),
                    ),
                    Text(
                      titleAr,
                      style: TextStyle(
                        fontSize: 14,
                        color: _isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: _isDark
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

  Widget _buildTemplateGrid(List<_TemplateInfo> templates) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 800 ? 2 : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            mainAxisExtent: 140,
          ),
          itemCount: templates.length,
          itemBuilder: (context, index) {
            return _buildTemplateCard(templates[index]);
          },
        );
      },
    );
  }

  Widget _buildTemplateCard(_TemplateInfo template) {
    final isGenerating = _isGenerating && _generatingTemplate == template.title;

    return Container(
      decoration: BoxDecoration(
        color: _isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: _isGenerating ? null : () => _runTemplateGeneration(template),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            template.gradient.first.withValues(alpha: 0.2),
                            template.gradient.last.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: template.gradient.first.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Icon(
                        template.icon,
                        color: template.gradient.first,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            template.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            template.titleAr,
                            style: TextStyle(
                              fontSize: 12,
                              color: _isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Text(
                    template.description,
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      color: _isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 12),
                _buildGenerateButton(template, isGenerating),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGenerateButton(_TemplateInfo template, bool isGenerating) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        gradient: isGenerating
            ? null
            : LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: template.gradient,
              ),
        color: isGenerating
            ? (_isDark ? AppColors.darkBorder : AppColors.lightBorder)
            : null,
        borderRadius: BorderRadius.circular(10),
        boxShadow: isGenerating
            ? null
            : [
                BoxShadow(
                  color: template.gradient.first.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: _isGenerating ? null : () => _runTemplateGeneration(template),
          child: Center(
            child: isGenerating
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.picture_as_pdf_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Generate PDF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _runTemplateGeneration(_TemplateInfo template) async {
    setState(() {
      _generatingTemplate = template.title;
    });
    template.onGenerate();
    if (mounted) {
      setState(() {
        _generatingTemplate = null;
      });
    }
  }

  Future<void> _generateBalanceSheet() async {
    final build = buildBalanceSheetDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateIncomeStatement() async {
    final build = buildIncomeStatementDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateCashFlow() async {
    final build = buildCashFlowDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateBudgetReport() async {
    final build = buildBudgetReportDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateQuotation() async {
    final build = buildQuotationDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generatePurchaseOrder() async {
    final build = buildPurchaseOrderDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateDeliveryNote() async {
    final build = buildDeliveryNoteDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateCreditNote() async {
    final build = buildCreditNoteDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generatePayslip() async {
    final build = buildPayslipDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateEmployeeReport() async {
    final build = buildEmployeeReportDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateAttendanceReport() async {
    final build = buildAttendanceReportDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateLeaveReport() async {
    final build = buildLeaveReportDemo(isRtl: _isRTL);
    await _generateFromBuild(build);
  }

  Future<void> _generateFromBuild(NewTemplatesDemoBuild build) async {
    await _runGeneration(() async {
      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: build.builder,
        fileName: build.fileName,
      );
    });
  }

  Future<void> _runGeneration(
      Future<GeniusPdfResult> Function() generator) async {
    if (_isGenerating) return;

    setState(() => _isGenerating = true);

    try {
      final result = await generator();
      result.when(
        onSuccess: (_) => _showSuccess('PDF generated successfully!'),
        onFailure: (f) => _showError(f.message),
      );
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

/// Internal class to hold template information
class _TemplateInfo {
  final String title;
  final String titleAr;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onGenerate;

  const _TemplateInfo({
    required this.title,
    required this.titleAr,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.onGenerate,
  });
}

class _NewTemplateTab {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  _NewTemplateTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}
