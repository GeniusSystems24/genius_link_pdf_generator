// ignore_for_file: unused_element_parameter

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../data/sample_data.dart';
import '../documents/advanced_layout_demo_document.dart';
import '../documents/banking_voucher_demo_builder.dart';
import '../documents/multi_grid_summary_demo_document.dart';
import '../documents/position_tracking_demo_document.dart';
import '../documents/qr_attachments_demo_document.dart';
import '../documents/remittance_voucher_demo_builder.dart';
import '../documents/report_composer_demo_document.dart';
import '../documents/smart_space_demo_document.dart';
import '../documents/voucher_demo_builder.dart';
import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';

class JobManagerDemoScreen extends StatefulWidget {
  const JobManagerDemoScreen({super.key});

  @override
  State<JobManagerDemoScreen> createState() => _JobManagerDemoScreenState();
}

class _JobManagerDemoScreenState extends State<JobManagerDemoScreen> {
  late GeniusPdfGenerationManager _manager;
  List<GeniusPdfJob> _jobs = [];
  final Map<String, String> _jobFilePaths = {};
  PdfFont? _font;
  Uint8List? _fontBytes;

  // Feature categories for testing
  final List<_FeatureCategory> _featureCategories = [];

  @override
  void initState() {
    super.initState();
    _manager = GeniusPdfGenerationManager(
      config: const GeniusPdfGenerationManagerConfig(
        maxConcurrentJobs: 2,
        cleanupCompletedJobs: false,
      ),
    );

    _manager.queueUpdates.listen((jobs) {
      setState(() => _jobs = jobs);
    });

    _loadFont();
    _initFeatureCategories();
  }

  void _initFeatureCategories() {
    _featureCategories.addAll([
      _FeatureCategory(
        name: 'Components',
        icon: Icons.widgets_rounded,
        gradient: AppColors.primaryGradient,
        features: [
          _Feature(
            name: 'DataGrid',
            description: 'Tables with RTL support',
            builder: _buildDataGridTest,
          ),
          _Feature(
            name: 'RichText',
            description: 'Styled text with colors',
            builder: _buildRichTextTest,
          ),
          _Feature(
            name: 'InfoBox',
            description: 'Information boxes',
            builder: _buildInfoBoxTest,
          ),
          _Feature(
            name: 'ReportHeader',
            description: 'Professional headers',
            builder: _buildReportHeaderTest,
          ),
          _Feature(
            name: 'SummarySection',
            description: 'Totals & calculations',
            builder: _buildSummarySectionTest,
          ),
        ],
      ),
      _FeatureCategory(
        name: 'Templates',
        icon: Icons.description_rounded,
        gradient: AppColors.purpleGradient,
        features: [
          _Feature(
            name: 'TaxInvoice',
            description: 'ZATCA invoice template',
            builder: _buildTaxInvoiceTest,
          ),
          _Feature(
            name: 'TrialBalance',
            description: 'Trial balance report',
            builder: _buildTrialBalanceTest,
          ),
          _Feature(
            name: 'CustomerStatement',
            description: 'Account statement',
            builder: _buildCustomerStatementTest,
          ),
          _Feature(
            name: 'InventoryReport',
            description: 'Inventory valuation',
            builder: _buildInventoryReportTest,
          ),
        ],
      ),
      _FeatureCategory(
        name: 'Financial',
        icon: Icons.account_balance_wallet_rounded,
        gradient: AppColors.orangeGradient,
        features: [
          _Feature(
            name: 'BalanceSheet',
            description: 'Balance sheet report',
            builder: _buildBalanceSheetTest,
          ),
          _Feature(
            name: 'IncomeStatement',
            description: 'P&L statement',
            builder: _buildIncomeStatementTest,
          ),
          _Feature(
            name: 'CashFlow',
            description: 'Cash flow statement',
            builder: _buildCashFlowTest,
          ),
          _Feature(
            name: 'BudgetReport',
            description: 'Budget vs actual',
            builder: _buildBudgetReportTest,
          ),
        ],
      ),
      _FeatureCategory(
        name: 'Sales & HR',
        icon: Icons.business_center_rounded,
        gradient: AppColors.cyanGradient,
        features: [
          _Feature(
            name: 'Quotation',
            description: 'Price quotation',
            builder: _buildQuotationTest,
          ),
          _Feature(
            name: 'PurchaseOrder',
            description: 'Purchase order',
            builder: _buildPurchaseOrderTest,
          ),
          _Feature(
            name: 'DeliveryNote',
            description: 'Delivery note',
            builder: _buildDeliveryNoteTest,
          ),
          _Feature(
            name: 'Payslip',
            description: 'Employee payslip',
            builder: _buildPayslipTest,
          ),
        ],
      ),
      _FeatureCategory(
        name: 'Security',
        icon: Icons.security_rounded,
        gradient: AppColors.errorGradient,
        features: [
          _Feature(
            name: 'Watermark',
            description: 'Text watermarks',
            builder: _buildWatermarkTest,
          ),
          _Feature(
            name: 'TiledWatermark',
            description: 'Tiled pattern watermark',
            builder: _buildTiledWatermarkTest,
          ),
          _Feature(
            name: 'DigitalSignature',
            description: 'Signature appearance',
            builder: _buildDigitalSignatureTest,
          ),
        ],
      ),
    ]);
    _featureCategories.addAll([
      _FeatureCategory(
        name: 'Vouchers',
        icon: Icons.receipt_rounded,
        gradient: AppColors.successGradient,
        features: [
          // _Feature(
          //   name: 'Service Vouchers',
          //   description: 'Accounting & receipts',
          //   builder: _buildServiceVouchersTest,
          // ),
          // _Feature(
          //   name: 'Banking Vouchers',
          //   description: 'Deposit, withdrawal, transfer',
          //   builder: _buildBankingVouchersTest,
          // ),
          // _Feature(
          //   name: 'Remittance Vouchers',
          //   description: 'Domestic & international',
          //   builder: _buildRemittanceVouchersTest,
          // ),
        ],
      ),
      _FeatureCategory(
        name: 'Advanced Features',
        icon: Icons.auto_awesome_rounded,
        gradient: AppColors.pinkGradient,
        features: [
          _Feature(
            name: 'Advanced Layout',
            description: 'Columns & headers',
            builder: _buildAdvancedLayoutTest,
          ),
          _Feature(
            name: 'Position Tracking',
            description: 'Precise layout control',
            builder: _buildPositionTrackingTest,
          ),
          // _Feature(
          //   name: 'Smart Space',
          //   description: 'Auto page breaks',
          //   builder: _buildSmartSpaceTest,
          // ),
          // _Feature(
          //   name: 'Report Composer',
          //   description: 'Fluent API demo',
          //   builder: _buildReportComposerTest,
          // ),
        ],
      ),
    ]);
    // Add new component features to existing Components category if possible, or just append helpers
    // Since we can't easily modify the existing list in-place with this tool, I'll add a separate category for "More Components"
    _featureCategories.add(
      _FeatureCategory(
        name: 'More Components',
        icon: Icons.extension_rounded,
        gradient: AppColors.infoGradient,
        features: [
          _Feature(
            name: 'Multi-Grid',
            description: 'Multiple grids & summaries',
            builder: _buildMultiGridSummaryTest,
          ),
          _Feature(
            name: 'QR & Attachments',
            description: 'Barcodes & images',
            builder: _buildQRAttachmentsTest,
          ),
        ],
      ),
    );
  }

  Future<void> _loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/din/din.ttf');
    setState(() {
      _fontBytes = fontData.buffer.asUint8List();
      _font = PdfTrueTypeFont(_fontBytes!, 10);
    });
  }

  @override
  void dispose() {
    _manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      child: Column(
        children: [
          _buildStatsBar(isDark),
          Expanded(
            child: Row(
              children: [
                // Features panel
                Container(
                  width: 340,
                  margin: const EdgeInsets.fromLTRB(24, 0, 12, 24),
                  child: _buildFeaturesPanel(isDark),
                ),
                // Jobs list
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(12, 0, 24, 24),
                    child: _buildJobsPanel(isDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBar(bool isDark) {
    final queued =
        _jobs.where((j) => j.status == GeniusPdfJobStatus.queued).length;
    final processing =
        _jobs.where((j) => j.status == GeniusPdfJobStatus.processing).length;
    final completed =
        _jobs.where((j) => j.status == GeniusPdfJobStatus.completed).length;
    final failed =
        _jobs.where((j) => j.status == GeniusPdfJobStatus.failed).length;

    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.analytics_rounded,
                color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Feature Testing Dashboard',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                Text(
                  'Test PDF generation features and monitor job status',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          _buildStatChip(isDark, 'Queued', queued, AppColors.primaryGradient,
              Icons.queue_rounded),
          const SizedBox(width: 12),
          _buildStatChip(isDark, 'Processing', processing,
              AppColors.orangeGradient, Icons.sync_rounded),
          const SizedBox(width: 12),
          _buildStatChip(isDark, 'Completed', completed,
              AppColors.successGradient, Icons.check_circle_rounded),
          const SizedBox(width: 12),
          _buildStatChip(isDark, 'Failed', failed, AppColors.errorGradient,
              Icons.error_rounded),
          const SizedBox(width: 24),
          if (_jobs.any((j) => j.status == GeniusPdfJobStatus.queued))
            _buildHeaderButton(
              isDark: isDark,
              label: 'Cancel All',
              icon: Icons.cancel_rounded,
              gradient: AppColors.errorGradient,
              onPressed: _cancelAllQueued,
            ),
          if (_jobs.any((j) => j.isFinished)) ...[
            const SizedBox(width: 8),
            _buildHeaderButton(
              isDark: isDark,
              label: 'Clear',
              icon: Icons.clear_all_rounded,
              gradient: AppColors.purpleGradient,
              onPressed: _clearFinished,
            ),
          ],
          const SizedBox(width: 8),
          _buildHeaderButton(
            isDark: isDark,
            label: 'Test All',
            icon: Icons.play_arrow_rounded,
            gradient: AppColors.successGradient,
            onPressed: _testAllFeatures,
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(bool isDark, String label, int value,
      List<Color> gradient, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: gradient.first.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: gradient.first, size: 18),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: gradient.first,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required bool isDark,
    required String label,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withValues(alpha: 0.4),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesPanel(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.extension_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Feature Tests',
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _featureCategories.length,
              itemBuilder: (context, index) {
                final category = _featureCategories[index];
                return _buildCategoryCard(category, isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(_FeatureCategory category, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: category.gradient),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    category.icon,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),
                // Test all in category
                InkWell(
                  onTap: () => _testCategory(category),
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: category.gradient),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Test All',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          // Feature buttons
          Padding(
            padding: const EdgeInsets.all(10),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: category.features.map((feature) {
                return _buildFeatureButton(feature, category.gradient, isDark);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureButton(
      _Feature feature, List<Color> gradient, bool isDark) {
    return Tooltip(
      message: feature.description,
      child: InkWell(
        onTap: () => _testFeature(feature),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Text(
            feature.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobsPanel(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.work_history_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Job Queue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const Spacer(),
                if (_jobs.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGradient.first
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_jobs.length} jobs',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryGradient.first,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          Expanded(
            child: _jobs.isEmpty
                ? _buildEmptyState(isDark)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _jobs.length,
                    itemBuilder: (context, index) {
                      final job = _jobs[_jobs.length - 1 - index];
                      final filePath = _jobFilePaths[job.id];
                      return _JobCard(
                        job: job,
                        isDark: isDark,
                        onCancel: () => _cancelJob(job.id),
                        onRetry: () => _retryJob(job.id),
                        onRemove: () => _removeJob(job.id),
                        filePath: filePath,
                        onOpen:
                            filePath != null ? () => _openFile(filePath) : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_rounded,
              size: 48,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No test jobs yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Click on features to test them individually\nor use "Test All" button',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // === Test Methods ===

  Future<void> _testFeature(_Feature feature) async {
    if (_font == null) {
      _showMessage('Font not loaded yet', isError: true);
      return;
    }

    final builder = feature.builder();
    if (builder == null) {
      _showMessage('Builder not implemented for ${feature.name}',
          isError: true);
      return;
    }

    await _addTestJob(feature.name, builder);
  }

  Future<void> _testCategory(_FeatureCategory category) async {
    if (_font == null) {
      _showMessage('Font not loaded yet', isError: true);
      return;
    }

    for (final feature in category.features) {
      final builder = feature.builder();
      if (builder != null) {
        await _addTestJob('${category.name}_${feature.name}', builder);
      }
    }
  }

  Future<void> _testAllFeatures() async {
    if (_font == null) {
      _showMessage('Font not loaded yet', isError: true);
      return;
    }

    for (final category in _featureCategories) {
      for (final feature in category.features) {
        final builder = feature.builder();
        if (builder != null) {
          await _addTestJob('${category.name}_${feature.name}', builder);
        }
      }
    }
  }

  Future<void> _addTestJob(
      String name, GeniusPdfDocumentBuilder builder) async {
    final fileName = name.toLowerCase().replaceAll(' ', '_');
    String jobId = '';

    jobId = await _manager.addJob(
      builder: builder,
      fileName: fileName,
      priority: GeniusPdfJobPriority.normal,
      autoOpen: false,
      onComplete: (result) async {
        try {
          final directory = await getApplicationDocumentsDirectory();
          final filePath = '${directory.path}/$fileName.pdf';
          final file = File(filePath);
          await file.writeAsBytes(result.bytes);
          _jobFilePaths[jobId] = filePath;
          if (mounted) setState(() {});
        } catch (e) {
          // Ignore save errors
        }
      },
      onError: (error) {
        if (mounted) {
          _showMessage('$name failed: ${error.message}', isError: true);
        }
      },
    );
  }

  // === Builder Methods ===

  GeniusPdfDocumentBuilder? _buildDataGridTest() {
    return _ComponentTestBuilder(
      config: geniusPdfConfig,
      testName: 'DataGrid Test',
      buildContent: (builder) {
        final grid = GeniusPdfDataGrid(
          config: geniusPdfConfig,
          columns: [
            GeniusPdfGridColumn(
                id: 'code', title: 'Code', titleAr: 'الرمز', width: 60),
            GeniusPdfGridColumn(
                id: 'name', title: 'Name', titleAr: 'الاسم', flexFactor: 2),
            GeniusPdfGridColumn.currency(
                id: 'amount', title: 'Amount', titleAr: 'المبلغ'),
          ],
          rows: [
            GeniusPdfGridRow(cells: {
              'code': 'P001',
              'name': 'Product 1',
              'amount': 1500.00
            }),
            GeniusPdfGridRow(cells: {
              'code': 'P002',
              'name': 'Product 2',
              'amount': 2500.00
            }),
            GeniusPdfGridRow.total(
                {'code': '', 'name': 'Total', 'amount': 4000.00}),
          ],
          style: GeniusPdfGridStyle.classic(),
        );
        grid.drawAt(
            page: builder.currentPage,
            x: 0,
            y: builder.currentY,
            width: builder.pageWidth);
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildRichTextTest() {
    var geniusPdfConfig = GeniusPdfConfig(baseFontBytes: _fontBytes!);
    return _ComponentTestBuilder(
      config: geniusPdfConfig,
      testName: 'RichText Test',
      buildContent: (builder) {
        final w = builder.pageWidth;
        var y = builder.currentY;

        // 1. Builder with heading, badge, currency, strikethrough
        final heading = GeniusPdfRichTextBuilder(
          config: geniusPdfConfig,
        )
            .heading('Invoice Summary')
            .space()
            .badge('PAID', backgroundColor: const Color(0xFF4CAF50))
            .newLine()
            .label('Invoice No')
            .separator(': ')
            .bold('#INV-2024-001', color: const Color(0xFF1565C0))
            .newLine()
            .text('Total: ')
            .currency('34,615.00', symbol: 'SAR')
            .newLine()
            .text('Previous: ')
            .strikethrough('28,500.00')
            .space()
            .positive('34,615.00')
            .superscript('*')
            .build();
        heading.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, y, w, 100),
        );
        y += 100;

        // 2. Bullet list
        final bulletList = GeniusPdfBulletList(
          items: [
            GeniusPdfBulletItem.simple('Consulting services'),
            GeniusPdfBulletItem.simple('Software development'),
            GeniusPdfBulletItem(text: 'Maintenance', subItems: [
              GeniusPdfBulletItem.simple('Monthly support'),
            ]),
          ],
          config: geniusPdfConfig,
          style: GeniusPdfBulletStyle.disc,
        );
        bulletList.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, y, w, 80),
        );
        y += 80;

        // 3. Markdown parsed text
        final mdSpans = GeniusPdfSimpleMarkdownParser.parse(
          'This is **bold** and *italic* with `code` and ~~deleted~~',
        );
        final mdRichText = GeniusPdfRichText(
          spans: mdSpans,
          config: geniusPdfConfig,
        );
        mdRichText.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, y, w, 25),
        );
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildInfoBoxTest() {
    var geniusPdfConfig = GeniusPdfConfig(baseFontBytes: _fontBytes!);
    return _ComponentTestBuilder(
      config: geniusPdfConfig,
      testName: 'InfoBox Test',
      buildContent: (builder) {
        final box = GeniusPdfInfoBox(
          config: geniusPdfConfig,
          title: 'Customer Details',
          titleAr: 'تفاصيل العميل',
          items: [
            GeniusPdfLabeledValue(
                config: geniusPdfConfig,
                label: 'Name',
                labelAr: 'الاسم',
                value: 'Ahmed Mohammed'),
            GeniusPdfLabeledValue(
                config: geniusPdfConfig,
                label: 'Phone',
                labelAr: 'الهاتف',
                value: '+966 12 345 6789'),
          ],
          style: const GeniusPdfInfoBoxStyle.headerContent(),
        );
        box.draw(
          page: builder.currentPage,
          bounds:
              Rect.fromLTWH(0, builder.currentY, builder.pageWidth / 2, 100),
        );
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildReportHeaderTest() {
    return _ComponentTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes!),
      testName: 'ReportHeader Test',
      buildContent: (builder) {
        final header = GeniusPdfReportHeader(
          config: geniusPdfConfig,
          title: 'Sales Report',
          titleAr: 'تقرير المبيعات',
          subtitle: 'January 2025',
          subtitleAr: 'يناير 2025',
          company: GeniusPdfCompanyInfo(
            name: 'Test Company',
            nameAr: 'شركة تجريبية',
            vatNumber: '300012345678903',
          ),
          printDate: DateTime.now(),
          style: GeniusPdfReportHeaderStyle.modern(),
        );
        header.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, 0, builder.pageWidth, 120),
        );
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildSummarySectionTest() {
    return _ComponentTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes!),
      testName: 'SummarySection Test',
      buildContent: (builder) {
        final summary = GeniusPdfSummarySection(
          config: builder.config,
          items: [
            GeniusPdfSummaryItem(
                label: 'Subtotal',
                labelAr: 'المجموع الفرعي',
                value: '10,000.00 SAR'),
            GeniusPdfSummaryItem(
                label: 'VAT (15%)',
                labelAr: 'ضريبة (15%)',
                value: '1,500.00 SAR'),
            GeniusPdfSummaryItem.total(
                label: 'Grand Total',
                labelAr: 'الإجمالي',
                value: '11,500.00 SAR'),
          ],
          style: GeniusPdfSummaryStyle.bordered(),
          alignment: GeniusPdfSummaryAlignment.right,
          width: builder.pageWidth * 0.45,
        );
        summary.draw(
          page: builder.currentPage,
          bounds: Rect.fromLTWH(0, builder.currentY, builder.pageWidth, 150),
        );
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildTaxInvoiceTest() {
    return TaxInvoiceTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      customer: SampleData.invoiceCustomer,
      invoice: SampleData.invoiceData,
      showQRCode: false,
    );
  }

  GeniusPdfDocumentBuilder? _buildTrialBalanceTest() {
    return TrialBalanceTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: SampleData.trialBalanceData,
    );
  }

  GeniusPdfDocumentBuilder? _buildCustomerStatementTest() {
    return CustomerStatementTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      customer: SampleData.statementCustomer,
      data: SampleData.statementData,
    );
  }

  GeniusPdfDocumentBuilder? _buildInventoryReportTest() {
    return InventoryReportTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: SampleData.inventoryData,
    );
  }

  GeniusPdfDocumentBuilder? _buildBalanceSheetTest() {
    final data = BalanceSheetData(
      reportDate: DateTime.now(),
      assets: BalanceSheetSection(
        title: 'Assets',
        titleAr: 'الأصول',
        items: [
          const BalanceSheetItem(
              accountCode: '1100',
              accountName: 'Cash',
              accountNameAr: 'النقد',
              amount: 150000),
        ],
      ),
      liabilities: BalanceSheetSection(
        title: 'Liabilities',
        titleAr: 'الالتزامات',
        items: [
          const BalanceSheetItem(
              accountCode: '2100',
              accountName: 'Payables',
              accountNameAr: 'الدائنون',
              amount: 50000),
        ],
      ),
      equity: BalanceSheetSection(
        title: 'Equity',
        titleAr: 'حقوق الملكية',
        items: [
          const BalanceSheetItem(
              accountCode: '3100',
              accountName: 'Capital',
              accountNameAr: 'رأس المال',
              amount: 100000),
        ],
      ),
    );
    return BalanceSheetTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: data,
    );
  }

  GeniusPdfDocumentBuilder? _buildIncomeStatementTest() {
    final data = IncomeStatementData(
      periodStart: DateTime(2026, 1, 1),
      periodEnd: DateTime(2026, 1, 31),
      revenue: IncomeStatementSection(
        title: 'Revenue',
        titleAr: 'الإيرادات',
        items: [
          const IncomeStatementItem(
              accountCode: '4100',
              accountName: 'Sales',
              accountNameAr: 'المبيعات',
              amount: 500000)
        ],
      ),
      costOfSales: IncomeStatementSection(
        title: 'Cost of Sales',
        titleAr: 'تكلفة المبيعات',
        items: [
          const IncomeStatementItem(
              accountCode: '5100',
              accountName: 'COGS',
              accountNameAr: 'تكلفة البضاعة',
              amount: 280000)
        ],
      ),
      operatingExpenses: IncomeStatementSection(
        title: 'Operating Expenses',
        titleAr: 'المصروفات التشغيلية',
        items: [
          const IncomeStatementItem(
              accountCode: '6100',
              accountName: 'Salaries',
              accountNameAr: 'الرواتب',
              amount: 120000)
        ],
      ),
      taxExpense: 15000,
    );
    return IncomeStatementTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: data,
    );
  }

  GeniusPdfDocumentBuilder? _buildCashFlowTest() {
    final data = CashFlowData(
      periodStart: DateTime(2026, 1, 1),
      periodEnd: DateTime(2026, 1, 31),
      operatingActivities: CashFlowSection(
          type: CashFlowActivityType.operating,
          title: '',
          items: [
            const CashFlowItem(
                description: 'Cash from customers',
                descriptionAr: 'النقد من العملاء',
                amount: 480000),
          ]),
      investingActivities: CashFlowSection(
          type: CashFlowActivityType.investing,
          title: '',
          items: [
            const CashFlowItem(
                description: 'Equipment purchase',
                descriptionAr: 'شراء معدات',
                amount: -50000),
          ]),
      financingActivities: CashFlowSection(
          type: CashFlowActivityType.financing,
          title: '',
          items: [
            const CashFlowItem(
                description: 'Bank loan',
                descriptionAr: 'قرض بنكي',
                amount: 100000),
          ]),
      beginningCashBalance: 100000,
    );
    return CashFlowTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: data,
    );
  }

  GeniusPdfDocumentBuilder? _buildBudgetReportTest() {
    final data = BudgetReportData(
      reportTitle: 'Budget Report',
      reportTitleAr: 'تقرير الميزانية',
      periodStart: DateTime(2026, 1, 1),
      periodEnd: DateTime(2026, 1, 31),
      sections: [
        BudgetSection(title: 'Revenue', titleAr: 'الإيرادات', items: [
          const BudgetItem(
              category: 'Sales',
              categoryAr: 'المبيعات',
              budgetedAmount: 400000,
              actualAmount: 420000),
        ]),
      ],
    );
    return BudgetReportTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      data: data,
    );
  }

  GeniusPdfDocumentBuilder? _buildQuotationTest() {
    final customer = const QuotationCustomer(
      name: 'Test Customer',
      nameAr: 'عميل تجريبي',
      // company removed
      address: 'Riyadh',
      phone: '+966 12 345 6789',
    );
    final quotation = QuotationData(
      customer: customer,
      quotationNumber: 'QT-2026-001',
      quotationDate: DateTime.now(),
      validUntil: DateTime.now().add(const Duration(days: 30)),
      items: [
        const QuotationItem(
            itemNumber: 1,
            description: 'Product A',
            descriptionAr: 'منتج أ',
            quantity: 5,
            unitPrice: 1000),
      ],
      // taxes removed
    );
    return QuotationTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      // customer removed
      quotation: quotation,
    );
  }

  GeniusPdfDocumentBuilder? _buildPurchaseOrderTest() {
    final vendor = const PurchaseOrderVendor(
      name: 'Test Vendor',
      nameAr: 'مورد تجريبي',
      vendorCode: 'V001',
      address: 'Jeddah',
      vatNumber: '300098765400001',
    );
    final po = PurchaseOrderData(
      poNumber: 'PO-2026-001',
      poDate: DateTime.now(),
      expectedDeliveryDate: DateTime.now().add(const Duration(days: 14)),
      items: [
        const PurchaseOrderItem(
            itemNumber: 1,
            productCode: 'P001',
            description: 'Item A',
            descriptionAr: 'مادة أ',
            quantity: 10,
            unitPrice: 500),
      ],
      taxes: [(name: 'VAT', nameAr: 'ضريبة', rate: 15.0)],
    );
    return PurchaseOrderTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      vendor: vendor,
      purchaseOrder: po,
    );
  }

  GeniusPdfDocumentBuilder? _buildDeliveryNoteTest() {
    final recipient = const DeliveryRecipient(
      name: 'Test Recipient',
      nameAr: 'مستلم تجريبي',
      company: 'Test Co.',
      companyAr: 'شركة تجريبية',
      address: 'Riyadh',
      phone: '+966 55 123 4567',
    );
    final delivery = DeliveryNoteData(
      deliveryNumber: 'DN-2026-001',
      deliveryDate: DateTime.now(),
      items: [
        const DeliveryItem(
            itemNumber: 1,
            productCode: 'P001',
            description: 'Widget',
            descriptionAr: 'منتج',
            orderedQty: 100,
            deliveredQty: 100,
            unit: 'pcs'),
      ],
    );
    return DeliveryNoteTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      recipient: recipient,
      delivery: delivery,
    );
  }

  GeniusPdfDocumentBuilder? _buildPayslipTest() {
    final employee = PayslipEmployee(
      employeeId: 'EMP-001',
      name: 'Mohammed Ahmed',
      nameAr: 'محمد أحمد',
      department: 'IT',
      departmentAr: 'تقنية المعلومات',
      designation: 'Developer',
      designationAr: 'مطور',
      joiningDate: DateTime(2022, 3, 15),
      bankName: 'Al Rajhi',
      bankAccount: 'SA123456789',
    );
    final payslip = PayslipData(
      payPeriod: 'January 2026',
      payDate: DateTime(2026, 1, 28),
      workingDays: 22,
      paidDays: 22,
      earnings: [
        const EarningsItem(
            description: 'Basic', descriptionAr: 'الراتب', amount: 15000)
      ],
      deductions: [
        const DeductionsItem(
            description: 'GOSI', descriptionAr: 'التأمينات', amount: 1462.50)
      ],
    );
    return PayslipTemplate(
      config: GeniusPdfConfig(
          baseFontBytes: _fontBytes!, textDirection: TextDirection.rtl),
      company: SampleData.companyInfo,
      employee: employee,
      payslip: payslip,
    );
  }

  GeniusPdfDocumentBuilder? _buildWatermarkTest() {
    return _SecurityTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes!),
      testName: 'Watermark Test',
      applySecurityFeature: (document) {
        document.addWatermark(GeniusPdfWatermark.confidential(
          config: geniusPdfConfig,
        ));
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildTiledWatermarkTest() {
    return _SecurityTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes!),
      testName: 'TiledWatermark Test',
      applySecurityFeature: (document) {
        GeniusPdfWatermark.tiled(
          config: geniusPdfConfig,
          GeniusTiledWatermarkSettings(
            text: 'SAMPLE',
            fontSize: 20,
            color: const Color(0xFF808080),
            opacity: 0.1,
          ),
        ).applyToDocument(document);
      },
    );
  }

  GeniusPdfDocumentBuilder? _buildDigitalSignatureTest() {
    return _SignatureTestBuilder(
      config: GeniusPdfConfig(baseFontBytes: _fontBytes!),
      testName: 'DigitalSignature Test',
    );
  }
  // ──────────────────────────────────────────────────────────
  // New Test Builders (Added for Completeness)
  // ──────────────────────────────────────────────────────────

  GeniusPdfDocumentBuilder? _buildAdvancedLayoutTest() {
    return AdvancedLayoutDemoBuilder(config: geniusPdfConfig);
  }

  GeniusPdfDocumentBuilder? _buildPositionTrackingTest() {
    return PositionTrackingDemoBuilder(config: geniusPdfConfig);
  }

  GeniusPdfDocumentBuilder? _buildMultiGridSummaryTest() {
    return MultiGridSummaryDemoBuilder(config: geniusPdfConfig);
  }

  GeniusPdfDocumentBuilder? _buildQRAttachmentsTest() {
    return QRAttachmentsDemoBuilder(config: geniusPdfConfig);
  }

  // === Utility Methods ===

  Future<void> _openFile(String filePath) async {
    try {
      await OpenFile.open(filePath);
    } catch (e) {
      _showMessage('Failed to open file: $e', isError: true);
    }
  }

  void _cancelJob(String id) {
    _manager.cancelJob(id);
  }

  Future<void> _retryJob(String id) async {
    await _manager.retryJob(id);
  }

  void _removeJob(String id) {
    _manager.removeJob(id);
  }

  void _cancelAllQueued() {
    final count = _manager.cancelAllQueued();
    _showMessage('$count jobs cancelled');
  }

  void _clearFinished() {
    final count = _manager.clearFinishedJobs();
    _showMessage('$count jobs cleared');
  }

  void _showMessage(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError
              ? AppColors.errorGradient.first
              : AppColors.successGradient.first,
        ),
      );
    }
  }
}

// === Data Classes ===

class _FeatureCategory {
  final String name;
  final IconData icon;
  final List<Color> gradient;
  final List<_Feature> features;

  _FeatureCategory({
    required this.name,
    required this.icon,
    required this.gradient,
    required this.features,
  });
}

class _Feature {
  final String name;
  final String description;
  final GeniusPdfDocumentBuilder? Function() builder;

  _Feature({
    required this.name,
    required this.description,
    required this.builder,
  });
}

// === Job Card Widget ===

class _JobCard extends StatelessWidget {
  const _JobCard({
    required this.job,
    required this.isDark,
    required this.onCancel,
    required this.onRetry,
    required this.onRemove,
    this.filePath,
    this.onOpen,
  });

  final GeniusPdfJob job;
  final bool isDark;
  final VoidCallback onCancel;
  final VoidCallback onRetry;
  final VoidCallback onRemove;
  final String? filePath;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getBorderColor().withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          _buildStatusIcon(),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.fileName,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _getStatusText(),
                  style: TextStyle(
                    fontSize: 12,
                    color: _getStatusColor(),
                  ),
                ),
                if (job.duration != null)
                  Text(
                    'Duration: ${job.duration!.inMilliseconds}ms',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
              ],
            ),
          ),
          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    final gradient = _getStatusGradient();
    final icon = _getStatusIcon();

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(10),
      ),
      child: job.status == GeniusPdfJobStatus.processing
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon, color: Colors.white, size: 18),
    );
  }

  IconData _getStatusIcon() {
    switch (job.status) {
      case GeniusPdfJobStatus.queued:
        return Icons.schedule_rounded;
      case GeniusPdfJobStatus.processing:
        return Icons.sync_rounded;
      case GeniusPdfJobStatus.completed:
        return Icons.check_circle_rounded;
      case GeniusPdfJobStatus.failed:
        return Icons.error_rounded;
      case GeniusPdfJobStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }

  List<Color> _getStatusGradient() {
    switch (job.status) {
      case GeniusPdfJobStatus.queued:
        return AppColors.primaryGradient;
      case GeniusPdfJobStatus.processing:
        return AppColors.orangeGradient;
      case GeniusPdfJobStatus.completed:
        return AppColors.successGradient;
      case GeniusPdfJobStatus.failed:
        return AppColors.errorGradient;
      case GeniusPdfJobStatus.cancelled:
        return [const Color(0xFF64748B), const Color(0xFF475569)];
    }
  }

  Color _getStatusColor() {
    switch (job.status) {
      case GeniusPdfJobStatus.queued:
        return AppColors.primaryGradient.first;
      case GeniusPdfJobStatus.processing:
        return AppColors.orangeGradient.first;
      case GeniusPdfJobStatus.completed:
        return AppColors.successGradient.first;
      case GeniusPdfJobStatus.failed:
        return AppColors.errorGradient.first;
      case GeniusPdfJobStatus.cancelled:
        return const Color(0xFF64748B);
    }
  }

  Color _getBorderColor() {
    switch (job.status) {
      case GeniusPdfJobStatus.completed:
        return AppColors.successGradient.first;
      case GeniusPdfJobStatus.failed:
        return AppColors.errorGradient.first;
      default:
        return isDark ? AppColors.darkBorder : AppColors.lightBorder;
    }
  }

  String _getStatusText() {
    switch (job.status) {
      case GeniusPdfJobStatus.queued:
        return 'Waiting...';
      case GeniusPdfJobStatus.processing:
        return 'Generating...';
      case GeniusPdfJobStatus.completed:
        return 'Success';
      case GeniusPdfJobStatus.failed:
        return job.errorMessage ?? 'Failed';
      case GeniusPdfJobStatus.cancelled:
        return 'Cancelled';
    }
  }

  Widget _buildActions() {
    if (job.status == GeniusPdfJobStatus.queued) {
      return _buildActionButton(
        icon: Icons.close_rounded,
        gradient: AppColors.errorGradient,
        onPressed: onCancel,
      );
    }

    if (job.status == GeniusPdfJobStatus.completed && filePath != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(
            icon: Icons.open_in_new_rounded,
            gradient: AppColors.primaryGradient,
            onPressed: onOpen!,
          ),
          const SizedBox(width: 6),
          _buildActionButton(
            icon: Icons.close_rounded,
            gradient: [const Color(0xFF64748B), const Color(0xFF475569)],
            onPressed: onRemove,
          ),
        ],
      );
    }

    if (job.status == GeniusPdfJobStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildActionButton(
            icon: Icons.refresh_rounded,
            gradient: AppColors.orangeGradient,
            onPressed: onRetry,
          ),
          const SizedBox(width: 6),
          _buildActionButton(
            icon: Icons.close_rounded,
            gradient: [const Color(0xFF64748B), const Color(0xFF475569)],
            onPressed: onRemove,
          ),
        ],
      );
    }

    if (job.isFinished) {
      return _buildActionButton(
        icon: Icons.close_rounded,
        gradient: [const Color(0xFF64748B), const Color(0xFF475569)],
        onPressed: onRemove,
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildActionButton({
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: gradient),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ),
    );
  }
}

// === Test Builders ===

class _ComponentTestBuilder extends GeniusPdfDocumentBuilder {
  _ComponentTestBuilder({
    required GeniusPdfConfig config,
    required this.testName,
    required this.buildContent,
    this.titleFont,
  }) : super(config);

  final String testName;
  final void Function(_ComponentTestBuilder builder) buildContent;
  final PdfFont? titleFont;

  @override
  void build() {
    newPage();
    addLine(testName, font: titleFont ?? baseFont, topMargin: 20);
    addSpace(30);
    buildContent(this);
  }
}

class _SecurityTestBuilder extends GeniusPdfDocumentBuilder {
  _SecurityTestBuilder({
    required GeniusPdfConfig config,
    required this.testName,
    required this.applySecurityFeature,
    this.titleFont,
  }) : super(config);

  final String testName;
  final void Function(PdfDocument document) applySecurityFeature;
  final PdfFont? titleFont;

  @override
  void build() {
    newPage();
    addLine(testName, font: titleFont ?? baseFont, topMargin: 20);
    addSpace(30);
    addLine('This document tests the security feature: $testName',
        topMargin: 10);
    addLine('Generated at: ${DateTime.now()}', topMargin: 10);

    for (int i = 0; i < 10; i++) {
      addLine('Sample content line ${i + 1}', topMargin: 8);
    }

    // Apply security feature to the document
    applySecurityFeature(document);
  }
}

class _SignatureTestBuilder extends GeniusPdfDocumentBuilder {
  _SignatureTestBuilder({
    required GeniusPdfConfig config,
    required this.testName,
    this.titleFont,
  }) : super(config);

  final String testName;
  final PdfFont? titleFont;

  @override
  void build() {
    newPage();
    addLine(testName, font: titleFont ?? baseFont, topMargin: 20);
    addSpace(30);
    addLine('This document tests digital signature appearance.', topMargin: 10);
    addLine('Generated at: ${DateTime.now()}', topMargin: 10);
    addSpace(50);

    final signature = GeniusPdfDigitalSignature(
      config: config,
      settings: GeniusDigitalSignatureSettings(
        signerName: 'Test Signer',
        reason: 'Testing signature feature',
        location: 'Test Location',
        appearance: const GeniusSignatureAppearance(
          showName: true,
          showDate: true,
          showReason: true,
          showLocation: true,
        ),
        pageNumber: 0,
      ),
    );
    signature.drawOnPage(currentPage);
  }
}
