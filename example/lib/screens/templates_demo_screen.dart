import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../data/sample_data.dart';
import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';

class TemplatesDemoScreen extends StatefulWidget {
  const TemplatesDemoScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<TemplatesDemoScreen> createState() => _TemplatesDemoScreenState();
}

class _TemplatesDemoScreenState extends State<TemplatesDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;
  bool _isRTL = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab,
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
          // Header with tabs and RTL toggle
          _buildHeader(isDark),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTemplateContent(
                  isDark: isDark,
                  title: 'Tax Invoice',
                  titleAr: 'فاتورة ضريبية',
                  description:
                      'ZATCA-compliant tax invoice with QR code, line items, VAT calculations, and bilingual support.',
                  icon: Icons.receipt_long_rounded,
                  gradient: AppColors.primaryGradient,
                  features: const [
                    'Customer & company information',
                    'Line items table with totals',
                    'VAT calculation and breakdown',
                    'Amount in words (Arabic/English)',
                    'QR code and signature area',
                  ],
                  previewSections: const [
                    'Header with Company Logo',
                    'Customer Details Section',
                    'Invoice Items Table',
                    'VAT Summary & Totals',
                    'QR Code & Signature',
                  ],
                  onGenerate: _generateInvoice,
                ),
                _buildTemplateContent(
                  isDark: isDark,
                  title: 'Trial Balance',
                  titleAr: 'ميزان المراجعة',
                  description:
                      'Financial trial balance report with categorized accounts, debit/credit columns, and subtotals.',
                  icon: Icons.balance_rounded,
                  gradient: AppColors.successGradient,
                  features: const [
                    'Categorized account listings',
                    'Debit and credit columns',
                    'Category subtotals',
                    'Grand total row',
                    'Professional header',
                  ],
                  previewSections: const [
                    'Report Header',
                    'Account Categories',
                    'Debit/Credit Columns',
                    'Category Subtotals',
                    'Grand Total',
                  ],
                  onGenerate: _generateTrialBalance,
                ),
                _buildTemplateContent(
                  isDark: isDark,
                  title: 'Customer Statement',
                  titleAr: 'كشف حساب عميل',
                  description:
                      'Detailed customer account statement with transaction history and aging analysis.',
                  icon: Icons.account_balance_wallet_rounded,
                  gradient: AppColors.purpleGradient,
                  features: const [
                    'Customer information',
                    'Transaction history',
                    'Running balance',
                    'Opening/closing balances',
                    'Aging analysis table',
                  ],
                  previewSections: const [
                    'Statement Header',
                    'Customer Info Block',
                    'Transaction List',
                    'Balance Summary',
                    'Aging Analysis',
                  ],
                  onGenerate: _generateStatement,
                ),
                _buildTemplateContent(
                  isDark: isDark,
                  title: 'Inventory Report',
                  titleAr: 'تقرير المخزون',
                  description:
                      'Inventory valuation report with items grouped by category, quantities, and total values.',
                  icon: Icons.inventory_2_rounded,
                  gradient: AppColors.orangeGradient,
                  features: const [
                    'Items grouped by category',
                    'Quantity and average cost',
                    'Total value calculation',
                    'Category subtotals',
                    'Grand total',
                  ],
                  previewSections: const [
                    'Report Header',
                    'Category Groups',
                    'Item Details Table',
                    'Category Totals',
                    'Grand Total',
                  ],
                  onGenerate: _generateInventory,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with RTL toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Report Templates',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              // RTL Toggle
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
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
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
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
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Custom Tab Bar
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              labelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              tabs: const [
                Tab(text: 'Tax Invoice'),
                Tab(text: 'Trial Balance'),
                Tab(text: 'Statement'),
                Tab(text: 'Inventory'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateContent({
    required bool isDark,
    required String title,
    required String titleAr,
    required String description,
    required IconData icon,
    required List<Color> gradient,
    required List<String> features,
    required List<String> previewSections,
    required VoidCallback onGenerate,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card with gradient icon
          _buildHeaderCard(
            isDark: isDark,
            title: title,
            titleAr: titleAr,
            description: description,
            icon: icon,
            gradient: gradient,
          ),
          const SizedBox(height: 16),
          // Features and Preview in row for larger screens
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 600) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _buildFeaturesSection(isDark, features),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildPreviewSection(isDark, previewSections),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _buildFeaturesSection(isDark, features),
                    const SizedBox(height: 16),
                    _buildPreviewSection(isDark, previewSections),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 16),
          // Generate Button
          _buildGenerateButton(
            isDark: isDark,
            title: title,
            gradient: gradient,
            onGenerate: onGenerate,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard({
    required bool isDark,
    required String title,
    required String titleAr,
    required String description,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          // Gradient Icon Container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
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
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          // Title and Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: gradient.first.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        titleAr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: gradient.first,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(bool isDark, List<String> features) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    size: 18,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Features',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          // Feature List
          ...features.asMap().entries.map((entry) {
            final index = entry.key;
            final feature = entry.value;
            final isLast = index == features.length - 1;

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: AppColors.success,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          feature,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.darkText
                                : AppColors.lightText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 16,
                    endIndent: 16,
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPreviewSection(bool isDark, List<String> sections) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.preview_rounded,
                    size: 18,
                    color: AppColors.info,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Template Layout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          // Preview Layout Visualization
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 2,
                ),
              ),
              child: Column(
                children: sections.asMap().entries.map((entry) {
                  final index = entry.key;
                  final section = entry.value;
                  final isFirst = index == 0;
                  final isLast = index == sections.length - 1;

                  return Container(
                    margin: EdgeInsets.only(
                      top: isFirst ? 0 : 8,
                      bottom: isLast ? 0 : 8,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: AppColors.primaryGradient,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            section,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
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
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton({
    required bool isDark,
    required String title,
    required List<Color> gradient,
    required VoidCallback onGenerate,
  }) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: _isGenerating
            ? null
            : LinearGradient(colors: gradient),
        color: _isGenerating
            ? (isDark ? AppColors.darkCard : AppColors.lightBorder)
            : null,
        boxShadow: _isGenerating
            ? null
            : [
                BoxShadow(
                  color: gradient.first.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isGenerating ? null : onGenerate,
          borderRadius: BorderRadius.circular(14),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isGenerating)
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  )
                else
                  const Icon(
                    Icons.picture_as_pdf_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                const SizedBox(width: 12),
                Text(
                  _isGenerating ? 'Generating...' : 'Generate $title',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _isGenerating
                        ? (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary)
                        : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _generateInvoice() async {
    setState(() => _isGenerating = true);

    try {
      final config = _createConfig();
      final invoice = TaxInvoiceTemplate(
        config: config,
        company: SampleData.companyInfo,
        customer: SampleData.invoiceCustomer,
        invoice: SampleData.invoiceData,
        showQRCode: false,
      );

      final service = GeniusPdfService();
      final result = await service.generateAndOpen(
        builder: invoice,
        fileName: 'tax_invoice_demo',
      );

      result.when(
        onSuccess: (_) => _showSuccess('Tax Invoice generated!'),
        onFailure: (f) => _showError(f.message),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateTrialBalance() async {
    setState(() => _isGenerating = true);

    try {
      final config = _createConfig();
      final report = TrialBalanceTemplate(
        config: config,
        company: SampleData.companyInfo,
        data: SampleData.trialBalanceData,
      );

      final service = GeniusPdfService();
      final result = await service.generateAndOpen(
        builder: report,
        fileName: 'trial_balance_demo',
      );

      result.when(
        onSuccess: (_) => _showSuccess('Trial Balance generated!'),
        onFailure: (f) => _showError(f.message),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateStatement() async {
    setState(() => _isGenerating = true);

    try {
      final config = _createConfig();
      final statement = CustomerStatementTemplate(
        config: config,
        company: SampleData.companyInfo,
        customer: SampleData.statementCustomer,
        data: SampleData.statementData,
      );

      final service = GeniusPdfService();
      final result = await service.generateAndOpen(
        builder: statement,
        fileName: 'customer_statement_demo',
      );

      result.when(
        onSuccess: (_) => _showSuccess('Customer Statement generated!'),
        onFailure: (f) => _showError(f.message),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateInventory() async {
    setState(() => _isGenerating = true);

    try {
      final config = _createConfig();
      final report = InventoryReportTemplate(
        config: config,
        company: SampleData.companyInfo,
        data: SampleData.inventoryData,
      );

      final service = GeniusPdfService();
      final result = await service.generateAndOpen(
        builder: report,
        fileName: 'inventory_report_demo',
      );

      result.when(
        onSuccess: (_) => _showSuccess('Inventory Report generated!'),
        onFailure: (f) => _showError(f.message),
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  GeniusPdfConfig _createConfig() {
    return GeniusPdfConfig(
      baseFont:
          PdfTrueTypeFont(geniusPdfConfig.assets.primaryFont.toList(), 10),
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
