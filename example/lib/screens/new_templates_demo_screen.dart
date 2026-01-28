import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../data/sample_data.dart';
import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';

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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
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
          _buildTabBar(),
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
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: _isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: _isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            colors: AppColors.primaryGradient,
          ),
        ),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
        dividerColor: Colors.transparent,
        splashBorderRadius: BorderRadius.circular(10),
        padding: const EdgeInsets.all(4),
        tabs: [
          _buildTab(Icons.account_balance, 'Financial'),
          _buildTab(Icons.shopping_cart, 'Sales'),
          _buildTab(Icons.people, 'HR'),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label) {
    return Tab(
      height: 48,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
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
                  color: gradient.first.withOpacity(0.3),
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
                            template.gradient.first.withOpacity(0.2),
                            template.gradient.last.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: template.gradient.first.withOpacity(0.3),
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
                  color: template.gradient.first.withOpacity(0.3),
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

  GeniusPdfConfig _createConfig() {
    return GeniusPdfConfig(
      baseFont:
          PdfTrueTypeFont(geniusPdfConfig.assets.primaryFont.toList(), 10),
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  Future<void> _generateBalanceSheet() async {
    await _runGeneration(() async {
      final data = BalanceSheetData(
        reportDate: DateTime.now(),
        assets: BalanceSheetSection(
          title: 'Assets',
          titleAr: 'الأصول',
          items: [
            const BalanceSheetItem(
              accountCode: '1100',
              accountName: 'Cash and Bank',
              accountNameAr: 'النقد والبنوك',
              amount: 150000,
            ),
            const BalanceSheetItem(
              accountCode: '1200',
              accountName: 'Accounts Receivable',
              accountNameAr: 'المدينون',
              amount: 85000,
            ),
            const BalanceSheetItem(
              accountCode: '1300',
              accountName: 'Inventory',
              accountNameAr: 'المخزون',
              amount: 120000,
            ),
            const BalanceSheetItem(
              accountCode: '1500',
              accountName: 'Fixed Assets',
              accountNameAr: 'الأصول الثابتة',
              amount: 200000,
            ),
          ],
        ),
        liabilities: BalanceSheetSection(
          title: 'Liabilities',
          titleAr: 'الالتزامات',
          items: [
            const BalanceSheetItem(
              accountCode: '2100',
              accountName: 'Accounts Payable',
              accountNameAr: 'الدائنون',
              amount: 65000,
            ),
            const BalanceSheetItem(
              accountCode: '2200',
              accountName: 'Short-term Loans',
              accountNameAr: 'قروض قصيرة الأجل',
              amount: 100000,
            ),
          ],
        ),
        equity: BalanceSheetSection(
          title: 'Equity',
          titleAr: 'حقوق الملكية',
          items: [
            const BalanceSheetItem(
              accountCode: '3100',
              accountName: 'Share Capital',
              accountNameAr: 'رأس المال',
              amount: 300000,
            ),
            const BalanceSheetItem(
              accountCode: '3200',
              accountName: 'Retained Earnings',
              accountNameAr: 'الأرباح المحتجزة',
              amount: 90000,
            ),
          ],
        ),
      );

      final template = BalanceSheetTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        data: data,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'balance_sheet_demo',
      );
    });
  }

  Future<void> _generateIncomeStatement() async {
    await _runGeneration(() async {
      final data = IncomeStatementData(
        periodStart: DateTime(2026, 1, 1),
        periodEnd: DateTime(2026, 1, 31),
        revenue: IncomeStatementSection(
          title: 'Revenue',
          titleAr: 'الإيرادات',
          items: [
            const IncomeStatementItem(
              accountCode: '4100',
              accountName: 'Sales Revenue',
              accountNameAr: 'إيرادات المبيعات',
              amount: 500000,
            ),
            const IncomeStatementItem(
              accountCode: '4200',
              accountName: 'Service Revenue',
              accountNameAr: 'إيرادات الخدمات',
              amount: 150000,
            ),
          ],
        ),
        costOfSales: IncomeStatementSection(
          title: 'Cost of Sales',
          titleAr: 'تكلفة المبيعات',
          items: [
            const IncomeStatementItem(
              accountCode: '5100',
              accountName: 'Cost of Goods Sold',
              accountNameAr: 'تكلفة البضاعة المباعة',
              amount: 280000,
            ),
          ],
        ),
        operatingExpenses: IncomeStatementSection(
          title: 'Operating Expenses',
          titleAr: 'المصروفات التشغيلية',
          items: [
            const IncomeStatementItem(
              accountCode: '6100',
              accountName: 'Salaries & Wages',
              accountNameAr: 'الرواتب والأجور',
              amount: 120000,
            ),
            const IncomeStatementItem(
              accountCode: '6200',
              accountName: 'Rent Expense',
              accountNameAr: 'مصروف الإيجار',
              amount: 25000,
            ),
          ],
        ),
        taxExpense: 25000,
      );

      final template = IncomeStatementTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        data: data,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'income_statement_demo',
      );
    });
  }

  Future<void> _generateCashFlow() async {
    await _runGeneration(() async {
      final data = CashFlowData(
        periodStart: DateTime(2026, 1, 1),
        periodEnd: DateTime(2026, 1, 31),
        operatingActivities: CashFlowSection(
          type: CashFlowActivityType.operating,
          title: '',
          items: [
            const CashFlowItem(
              description: 'Cash received from customers',
              descriptionAr: 'النقد المستلم من العملاء',
              amount: 480000,
            ),
            const CashFlowItem(
              description: 'Cash paid to suppliers',
              descriptionAr: 'النقد المدفوع للموردين',
              amount: -250000,
            ),
            const CashFlowItem(
              description: 'Cash paid to employees',
              descriptionAr: 'النقد المدفوع للموظفين',
              amount: -120000,
            ),
          ],
        ),
        investingActivities: CashFlowSection(
          type: CashFlowActivityType.investing,
          title: '',
          items: [
            const CashFlowItem(
              description: 'Purchase of equipment',
              descriptionAr: 'شراء معدات',
              amount: -50000,
            ),
          ],
        ),
        financingActivities: CashFlowSection(
          type: CashFlowActivityType.financing,
          title: '',
          items: [
            const CashFlowItem(
              description: 'Bank loan received',
              descriptionAr: 'قرض بنكي مستلم',
              amount: 100000,
            ),
          ],
        ),
        beginningCashBalance: 100000,
      );

      final template = CashFlowTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        data: data,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'cash_flow_demo',
      );
    });
  }

  Future<void> _generateBudgetReport() async {
    await _runGeneration(() async {
      final data = BudgetReportData(
        reportTitle: 'Monthly Budget Report',
        reportTitleAr: 'تقرير الميزانية الشهرية',
        periodStart: DateTime(2026, 1, 1),
        periodEnd: DateTime(2026, 1, 31),
        sections: [
          BudgetSection(
            title: 'Revenue',
            titleAr: 'الإيرادات',
            items: [
              const BudgetItem(
                category: 'Product Sales',
                categoryAr: 'مبيعات المنتجات',
                budgetedAmount: 400000,
                actualAmount: 420000,
              ),
              const BudgetItem(
                category: 'Service Revenue',
                categoryAr: 'إيرادات الخدمات',
                budgetedAmount: 100000,
                actualAmount: 95000,
              ),
            ],
          ),
          BudgetSection(
            title: 'Expenses',
            titleAr: 'المصروفات',
            isExpense: true,
            items: [
              const BudgetItem(
                category: 'Salaries',
                categoryAr: 'الرواتب',
                budgetedAmount: 120000,
                actualAmount: 125000,
              ),
              const BudgetItem(
                category: 'Marketing',
                categoryAr: 'التسويق',
                budgetedAmount: 50000,
                actualAmount: 42000,
              ),
            ],
          ),
        ],
      );

      final template = BudgetReportTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        data: data,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'budget_report_demo',
      );
    });
  }

  Future<void> _generateQuotation() async {
    await _runGeneration(() async {
      final customer = const QuotationCustomer(
        name: 'ABC Trading Company',
        nameAr: 'شركة ABC للتجارة',
        company: 'ABC Trading Co. Ltd',
        address: '456 Commercial Street, Jeddah',
        phone: '+966 12 345 6789',
        email: 'purchasing@abctrading.com',
      );

      final quotation = QuotationData(
        quotationNumber: 'QT-2026-0001',
        quotationDate: DateTime.now(),
        validUntil: DateTime.now().add(const Duration(days: 30)),
        paymentTerms: 'Net 30',
        paymentTermsAr: 'صافي 30 يوم',
        items: [
          const QuotationItem(
            itemNumber: 1,
            description: 'Office Desk - Executive Model',
            descriptionAr: 'مكتب تنفيذي',
            quantity: 5,
            unitPrice: 2500,
          ),
          const QuotationItem(
            itemNumber: 2,
            description: 'Executive Chair',
            descriptionAr: 'كرسي تنفيذي',
            quantity: 5,
            unitPrice: 1800,
          ),
        ],
        taxes: [
          (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
        ],
      );

      final template = QuotationTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        customer: customer,
        quotation: quotation,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'quotation_demo',
      );
    });
  }

  Future<void> _generatePurchaseOrder() async {
    await _runGeneration(() async {
      final vendor = const PurchaseOrderVendor(
        name: 'Tech Supplies Co.',
        nameAr: 'شركة مستلزمات التقنية',
        vendorCode: 'VND-001',
        address: '789 Industrial Area, Dammam',
        vatNumber: '300098765400001',
      );

      final po = PurchaseOrderData(
        poNumber: 'PO-2026-0042',
        poDate: DateTime.now(),
        expectedDeliveryDate: DateTime.now().add(const Duration(days: 14)),
        paymentTerms: 'Net 45',
        status: 'Approved',
        items: [
          const PurchaseOrderItem(
            itemNumber: 1,
            productCode: 'LAP-001',
            description: 'Laptop - Business Model',
            descriptionAr: 'لابتوب - موديل الأعمال',
            quantity: 10,
            unitPrice: 4500,
          ),
          const PurchaseOrderItem(
            itemNumber: 2,
            productCode: 'MON-002',
            description: 'Monitor 27" 4K',
            descriptionAr: 'شاشة 27 بوصة 4K',
            quantity: 10,
            unitPrice: 1200,
          ),
        ],
        taxes: [
          (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
        ],
      );

      final template = PurchaseOrderTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        vendor: vendor,
        purchaseOrder: po,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'purchase_order_demo',
      );
    });
  }

  Future<void> _generateDeliveryNote() async {
    await _runGeneration(() async {
      final recipient = const DeliveryRecipient(
        name: 'Ahmed Al-Farsi',
        nameAr: 'أحمد الفارسي',
        company: 'XYZ Corp',
        companyAr: 'شركة XYZ',
        address: '321 Business Park, Riyadh',
        phone: '+966 55 123 4567',
      );

      final delivery = DeliveryNoteData(
        deliveryNumber: 'DN-2026-0089',
        deliveryDate: DateTime.now(),
        salesOrderRef: 'SO-2026-0156',
        driverName: 'Khalid Mohammed',
        vehicleNumber: 'ABC 1234',
        items: [
          const DeliveryItem(
            itemNumber: 1,
            productCode: 'PROD-001',
            description: 'Widget A',
            descriptionAr: 'منتج أ',
            orderedQty: 100,
            deliveredQty: 100,
            unit: 'pcs',
          ),
          const DeliveryItem(
            itemNumber: 2,
            productCode: 'PROD-002',
            description: 'Widget B',
            descriptionAr: 'منتج ب',
            orderedQty: 50,
            deliveredQty: 45,
            unit: 'pcs',
          ),
        ],
      );

      final template = DeliveryNoteTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        recipient: recipient,
        delivery: delivery,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'delivery_note_demo',
      );
    });
  }

  Future<void> _generateCreditNote() async {
    await _runGeneration(() async {
      final party = const NoteParty(
        name: 'Customer ABC',
        nameAr: 'العميل ABC',
        address: '123 Customer Street, Riyadh',
        vatNumber: '300011112200001',
      );

      final note = CreditDebitNoteData(
        noteNumber: 'CN-2026-0015',
        noteDate: DateTime.now(),
        noteType: NoteType.credit,
        originalInvoiceNumber: 'INV-2026-0189',
        reason: 'Goods returned',
        reasonAr: 'إرجاع بضاعة',
        items: [
          const NoteLineItem(
            itemNumber: 1,
            description: 'Defective Product A',
            descriptionAr: 'منتج أ معيب',
            quantity: 5,
            unitPrice: 500,
            reason: 'Quality issue',
            reasonAr: 'مشكلة جودة',
          ),
        ],
        taxes: [
          (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
        ],
      );

      final template = CreditNoteTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        party: party,
        note: note,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'credit_note_demo',
      );
    });
  }

  Future<void> _generatePayslip() async {
    await _runGeneration(() async {
      final employee = PayslipEmployee(
        employeeId: 'EMP-001',
        name: 'Mohammed Al-Ahmed',
        nameAr: 'محمد الأحمد',
        department: 'Engineering',
        departmentAr: 'الهندسة',
        designation: 'Senior Developer',
        designationAr: 'مطور أول',
        joiningDate: DateTime(2022, 3, 15),
        bankName: 'Al Rajhi Bank',
        bankAccount: 'SA12345678901234567890',
      );

      final payslip = PayslipData(
        payPeriod: 'January 2026',
        payDate: DateTime(2026, 1, 28),
        workingDays: 22,
        paidDays: 22,
        earnings: [
          const EarningsItem(
            description: 'Basic Salary',
            descriptionAr: 'الراتب الأساسي',
            amount: 15000,
          ),
          const EarningsItem(
            description: 'Housing Allowance',
            descriptionAr: 'بدل السكن',
            amount: 3750,
          ),
          const EarningsItem(
            description: 'Transportation',
            descriptionAr: 'بدل المواصلات',
            amount: 1500,
          ),
        ],
        deductions: [
          const DeductionsItem(
            description: 'GOSI',
            descriptionAr: 'التأمينات',
            amount: 1462.50,
          ),
        ],
      );

      final template = PayslipTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        employee: employee,
        payslip: payslip,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'payslip_demo',
      );
    });
  }

  Future<void> _generateEmployeeReport() async {
    await _runGeneration(() async {
      final data = EmployeeReportData(
        reportTitle: 'Employee Report',
        reportTitleAr: 'تقرير الموظفين',
        reportDate: DateTime.now(),
        showSalary: true,
        employees: [
          EmployeeRecord(
            employeeId: 'EMP-001',
            name: 'Mohammed Al-Ahmed',
            nameAr: 'محمد الأحمد',
            department: 'Engineering',
            departmentAr: 'الهندسة',
            designation: 'Senior Developer',
            joiningDate: DateTime(2022, 3, 15),
            status: EmployeeStatus.active,
            salary: 21450,
          ),
          EmployeeRecord(
            employeeId: 'EMP-002',
            name: 'Sara Al-Qahtani',
            nameAr: 'سارة القحطاني',
            department: 'HR',
            departmentAr: 'الموارد البشرية',
            designation: 'HR Manager',
            joiningDate: DateTime(2021, 6, 1),
            status: EmployeeStatus.active,
            salary: 25000,
          ),
        ],
      );

      final template = EmployeeReportTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        data: data,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'employee_report_demo',
      );
    });
  }

  Future<void> _generateAttendanceReport() async {
    await _runGeneration(() async {
      final data = AttendanceReportData(
        reportTitle: 'Attendance Report',
        reportTitleAr: 'تقرير الحضور',
        periodStart: DateTime(2026, 1, 1),
        periodEnd: DateTime(2026, 1, 15),
        showDailyDetails: false,
        employees: [
          AttendanceEmployeeSummary(
            employeeId: 'EMP-001',
            employeeName: 'Mohammed Al-Ahmed',
            employeeNameAr: 'محمد الأحمد',
            attendance: List.generate(
              11,
              (i) => DailyAttendance(
                date: DateTime(2026, 1, 1).add(Duration(days: i)),
                status: i % 7 == 5 || i % 7 == 6
                    ? AttendanceStatus.weekend
                    : AttendanceStatus.present,
                workingHours: 8,
              ),
            ),
          ),
        ],
      );

      final template = AttendanceReportTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        data: data,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'attendance_report_demo',
      );
    });
  }

  Future<void> _generateLeaveReport() async {
    await _runGeneration(() async {
      final data = LeaveReportData(
        reportTitle: 'Leave Report',
        reportTitleAr: 'تقرير الإجازات',
        periodStart: DateTime(2026, 1, 1),
        periodEnd: DateTime(2026, 12, 31),
        leaveBalances: [
          const LeaveBalance(
            employeeId: 'EMP-001',
            employeeName: 'Mohammed Al-Ahmed',
            employeeNameAr: 'محمد الأحمد',
            annualEntitlement: 21,
            annualUsed: 5,
            sickUsed: 2,
            carryForward: 3,
          ),
        ],
        leaveRequests: [
          LeaveRecord(
            leaveId: 'LV-001',
            employeeId: 'EMP-001',
            employeeName: 'Mohammed Al-Ahmed',
            leaveType: LeaveType.annual,
            startDate: DateTime(2026, 2, 15),
            endDate: DateTime(2026, 2, 19),
            status: LeaveStatus.approved,
          ),
        ],
      );

      final template = LeaveReportTemplate(
        config: _createConfig(),
        company: SampleData.companyInfo,
        data: data,
      );

      final service = GeniusPdfService();
      return service.generateAndOpen(
        builder: template,
        fileName: 'leave_report_demo',
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
