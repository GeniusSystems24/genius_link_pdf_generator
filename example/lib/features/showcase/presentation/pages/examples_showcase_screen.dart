import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/showcase/models/documents/advanced_layout_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/banking_voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/multi_grid_summary_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/position_tracking_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/qr_attachments_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/remittance_voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/report_composer_demo_document.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/trade_voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/auxiliary_voucher_demo_builder.dart';
import 'package:genius_pdf_example/features/showcase/models/documents/complete_voucher_demo_builder.dart';
import 'package:genius_pdf_example/app/theme/app_theme.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/component_page.dart';
// import 'package:genius_pdf_example/shared/presentation/widgets/custom_tab_bar.dart';

/// Showcase screen for selected demo examples.
class ExamplesShowcaseScreen extends StatefulWidget {
  const ExamplesShowcaseScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<ExamplesShowcaseScreen> createState() => _ExamplesShowcaseScreenState();
}

class _ExamplesShowcaseScreenState extends State<ExamplesShowcaseScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;
  bool _isRTL = true;

  final List<_ExampleTab> _tabs = [
    _ExampleTab(
      id: 'advanced_layout',
      title: 'Advanced Layout',
      icon: Icons.dashboard_customize_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _ExampleTab(
      id: 'position_tracking',
      title: 'Position Tracking',
      icon: Icons.track_changes_rounded,
      gradient: AppColors.successGradient,
    ),
    _ExampleTab(
      id: 'multi_grid_summary',
      title: 'Multi-Grid Summary',
      icon: Icons.table_chart_rounded,
      gradient: AppColors.purpleGradient,
    ),
    _ExampleTab(
      id: 'qr_attachments',
      title: 'QR & Attachments',
      icon: Icons.qr_code_rounded,
      gradient: AppColors.cyanGradient,
    ),
    _ExampleTab(
      id: 'report_composer',
      title: 'Report Composer',
      icon: Icons.auto_awesome_rounded,
      gradient: AppColors.tealGradient,
    ),
    _ExampleTab(
      id: 'service_vouchers',
      title: 'Service Vouchers',
      icon: Icons.receipt_long_rounded,
      gradient: AppColors.warningGradient,
    ),
    _ExampleTab(
      id: 'banking_vouchers',
      title: 'Banking Vouchers',
      icon: Icons.account_balance_rounded,
      gradient: AppColors.cyanGradient,
    ),
    _ExampleTab(
      id: 'remittance_vouchers',
      title: 'Remittance Vouchers',
      icon: Icons.send_rounded,
      gradient: AppColors.purpleGradient,
    ),
    _ExampleTab(
      id: 'trade_vouchers',
      title: 'Trade Vouchers',
      icon: Icons.storefront_rounded,
      gradient: AppColors.successGradient,
    ),
    _ExampleTab(
      id: 'auxiliary_vouchers',
      title: 'Auxiliary Vouchers',
      icon: Icons.card_giftcard_rounded,
      gradient: AppColors.warningGradient,
    ),
    _ExampleTab(
      id: 'complete_demo',
      title: 'Complete Demo',
      icon: Icons.library_books_rounded,
      gradient: AppColors.primaryGradient,
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
          _buildTabBar(isDark),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAdvancedLayoutTab(isDark),
                _buildPositionTrackingTab(isDark),
                _buildMultiGridSummaryTab(isDark),
                _buildQrAttachmentsTab(isDark),
                _buildReportComposerTab(isDark),
                _buildServiceVouchersTab(isDark),
                _buildBankingVouchersTab(isDark),
                _buildRemittanceVouchersTab(isDark),
                _buildTradeVouchersTab(isDark),
                _buildAuxiliaryVouchersTab(isDark),
                _buildCompleteDemoTab(isDark),
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
        isScrollable: true,
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

  Widget _buildAdvancedLayoutTab(bool isDark) {
    return ComponentPage(
      title: 'Advanced Layout',
      description:
          'Rich text, info boxes, report headers, and flexible columns.',
      icon: Icons.dashboard_customize_rounded,
      gradient: AppColors.primaryGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateAdvancedLayout,
      codeExample: '''
final builder = AdvancedLayoutDemoBuilder(config: config);
await builder.build();
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.dashboard_customize_rounded,
        'Advanced Layout',
        _isRTL ? 'تخطيط متقدم' : null,
      ),
    );
  }

  Widget _buildPositionTrackingTab(bool isDark) {
    return ComponentPage(
      title: 'Position Tracking',
      description: 'Precise Y tracking, auto page breaks, and image alignment.',
      icon: Icons.track_changes_rounded,
      gradient: AppColors.successGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generatePositionTracking,
      codeExample: '''
final builder = PositionTrackingDemoBuilder(config: config);
await builder.build();
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.track_changes_rounded,
        'Position Tracking',
        _isRTL ? 'تتبع المواقع' : null,
      ),
    );
  }

  Widget _buildMultiGridSummaryTab(bool isDark) {
    return ComponentPage(
      title: 'Multi-Grid Summary',
      description:
          'Multiple grids with per-section summaries and report totals.',
      icon: Icons.table_chart_rounded,
      gradient: AppColors.purpleGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateMultiGridSummary,
      codeExample: '''
final builder = MultiGridSummaryDemoBuilder(config: config);
await builder.build();
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.table_chart_rounded,
        'Multi-Grid Summary',
        _isRTL ? 'ملخص متعدد الجداول' : null,
      ),
    );
  }

  Widget _buildQrAttachmentsTab(bool isDark) {
    return ComponentPage(
      title: 'QR & Attachments',
      description: 'QR codes, inline attachments, and image pages in PDF.',
      icon: Icons.qr_code_rounded,
      gradient: AppColors.cyanGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateQrAttachments,
      codeExample: '''
final builder = QRAttachmentsDemoBuilder(config: config);
await builder.build();
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.qr_code_rounded,
        'QR & Attachments',
        _isRTL ? 'رموز QR والمرفقات' : null,
      ),
    );
  }

  Widget _buildReportComposerTab(bool isDark) {
    return ComponentPage(
      title: 'Report Composer',
      description:
          'Fluent API for composing a full report without subclassing.',
      icon: Icons.auto_awesome_rounded,
      gradient: AppColors.tealGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateReportComposer,
      codeExample: '''
final bytes = buildComposerDemoReport(config: config);
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.auto_awesome_rounded,
        'Report Composer',
        _isRTL ? 'مُركّب التقارير' : null,
      ),
    );
  }

  Widget _buildServiceVouchersTab(bool isDark) {
    return ComponentPage(
      title: 'Service Vouchers',
      description:
          'Accounting entries, receipts, payments, and tax vouchers in one PDF.',
      icon: Icons.receipt_long_rounded,
      gradient: AppColors.warningGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateVoucherDemo,
      codeExample: '''
final bytes = buildVoucherDemoReport(config: config);
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.receipt_long_rounded,
        'Service Vouchers',
        _isRTL ? 'سندات الخدمات' : null,
      ),
    );
  }

  Widget _buildBankingVouchersTab(bool isDark) {
    return ComponentPage(
      title: 'Banking Vouchers',
      description:
          'Bank deposits, withdrawals, transfers, and bill payments in one PDF.',
      icon: Icons.account_balance_rounded,
      gradient: AppColors.cyanGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateBankingVoucherDemo,
      codeExample: '''
final bytes = buildBankingVoucherDemoReport(config: config);
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.account_balance_rounded,
        'Banking Vouchers',
        _isRTL ? 'السندات البنكية' : null,
      ),
    );
  }

  Widget _buildRemittanceVouchersTab(bool isDark) {
    return ComponentPage(
      title: 'Remittance Vouchers',
      description:
          'Domestic and international outgoing/incoming remittance vouchers.',
      icon: Icons.send_rounded,
      gradient: AppColors.purpleGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateRemittanceVoucherDemo,
      codeExample: '''
final bytes = buildRemittanceVoucherDemoReport(config: config);
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.send_rounded,
        'Remittance Vouchers',
        _isRTL ? 'سندات الحوالات' : null,
      ),
    );
  }

  Widget _buildTradeVouchersTab(bool isDark) {
    return ComponentPage(
      title: 'Trade Vouchers',
      description:
          'Purchase, sales, purchase returns, and sales returns in one PDF.',
      icon: Icons.storefront_rounded,
      gradient: AppColors.successGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateTradeVoucherDemo,
      codeExample: '''
final bytes = buildTradeVoucherDemoReport(config: config);
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.storefront_rounded,
        'Trade Vouchers',
        _isRTL ? 'سندات التجارة' : null,
      ),
    );
  }

  Widget _buildAuxiliaryVouchersTab(bool isDark) {
    return ComponentPage(
      title: 'Auxiliary Vouchers',
      description:
          'Gift/grant vouchers and inventory operations in one PDF.',
      icon: Icons.card_giftcard_rounded,
      gradient: AppColors.warningGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateAuxiliaryVoucherDemo,
      codeExample: '''
final bytes = buildAuxiliaryVoucherDemoReport(config: config);
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.card_giftcard_rounded,
        'Auxiliary Vouchers',
        _isRTL ? 'السندات المساعدة' : null,
      ),
    );
  }

  Widget _buildCompleteDemoTab(bool isDark) {
    return ComponentPage(
      title: 'Complete Demo',
      description:
          'All 16 voucher template classes (64 subtypes) in one comprehensive PDF.',
      icon: Icons.library_books_rounded,
      gradient: AppColors.primaryGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: _generateCompleteDemo,
      codeExample: '''
final bytes = buildCompleteVoucherDemoReport(config: config);
''',
      preview: _buildGenericPreview(
        isDark,
        Icons.library_books_rounded,
        'Complete Demo',
        _isRTL ? 'عرض شامل' : null,
      ),
    );
  }

  Widget _buildGenericPreview(
      bool isDark, IconData icon, String label, String? subLabel) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.1),
            AppColors.secondary.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.primary),
            const SizedBox(height: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
            if (subLabel != null) ...[
              const SizedBox(height: 4),
              Text(
                subLabel,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ],
            const SizedBox(height: 12),
            Text(
              'Click "Generate PDF" to preview',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  GeniusPdfConfig _createConfig() {
    return geniusPdfConfig.copyWith(
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  Future<void> _generateWithBuilder(
    GeniusPdfDocumentBuilder builder,
    String fileName,
    String successMessage,
  ) async {
    try {
      final service = GeniusPdfService();
      final result = await service.generateAndOpen(
        builder: builder,
        fileName: fileName,
      );

      result.when(
        onSuccess: (_) => _showSuccess(successMessage),
        onFailure: (f) => _showError(f.message),
      );
    } catch (_) {
      _showError(_isRTL ? 'حدث خطأ أثناء التوليد.' : 'Generation failed.');
    }
  }

  Future<void> _generateAdvancedLayout() async {
    setState(() => _isGenerating = true);
    await _generateWithBuilder(
      AdvancedLayoutDemoBuilder(config: _createConfig()),
      'advanced_layout_demo',
      _isRTL ? 'تم إنشاء مثال التخطيط المتقدم.' : 'Advanced layout generated.',
    ).whenComplete(() {
      if (mounted) setState(() => _isGenerating = false);
    });
  }

  Future<void> _generatePositionTracking() async {
    setState(() => _isGenerating = true);
    await _generateWithBuilder(
      PositionTrackingDemoBuilder(config: _createConfig()),
      'position_tracking_demo',
      _isRTL ? 'تم إنشاء مثال تتبع المواقع.' : 'Position tracking generated.',
    ).whenComplete(() {
      if (mounted) setState(() => _isGenerating = false);
    });
  }

  Future<void> _generateMultiGridSummary() async {
    setState(() => _isGenerating = true);
    await _generateWithBuilder(
      MultiGridSummaryDemoBuilder(config: _createConfig()),
      'multi_grid_summary_demo',
      _isRTL
          ? 'تم إنشاء مثال الملخص متعدد الجداول.'
          : 'Multi-grid summary generated.',
    ).whenComplete(() {
      if (mounted) setState(() => _isGenerating = false);
    });
  }

  Future<void> _generateQrAttachments() async {
    setState(() => _isGenerating = true);
    await _generateWithBuilder(
      QRAttachmentsDemoBuilder(config: _createConfig()),
      'qr_attachments_demo',
      _isRTL ? 'تم إنشاء مثال QR والمرفقات.' : 'QR & attachments generated.',
    ).whenComplete(() {
      if (mounted) setState(() => _isGenerating = false);
    });
  }

  Future<void> _generateReportComposer() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = buildComposerDemoReport(config: _createConfig());
      await demoDocuments.saveAndOpen(
        bytes: Uint8List.fromList(bytes),
        fileName: 'report_composer_demo.pdf',
      );
      _showSuccess(_isRTL
          ? 'تم إنشاء مثال مُركّب التقارير.'
          : 'Report composer generated.');
    } catch (_) {
      _showError(_isRTL
          ? 'تعذر إنشاء مثال مُركّب التقارير.'
          : 'Failed to generate report composer.');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateVoucherDemo() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = buildVoucherDemoReport(config: _createConfig());
      await demoDocuments.saveAndOpen(
        bytes: Uint8List.fromList(bytes),
        fileName: 'voucher_demo.pdf',
      );
      _showSuccess(_isRTL
          ? 'تم إنشاء عرض سندات الخدمات.'
          : 'Service vouchers demo generated.');
    } catch (_) {
      _showError(_isRTL
          ? 'تعذر إنشاء عرض سندات الخدمات.'
          : 'Failed to generate vouchers demo.');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateBankingVoucherDemo() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = buildBankingVoucherDemoReport(config: _createConfig());
      await demoDocuments.saveAndOpen(
        bytes: Uint8List.fromList(bytes),
        fileName: 'banking_voucher_demo.pdf',
      );
      _showSuccess(_isRTL
          ? 'تم إنشاء عرض السندات البنكية.'
          : 'Banking vouchers demo generated.');
    } catch (_) {
      _showError(_isRTL
          ? 'تعذر إنشاء عرض السندات البنكية.'
          : 'Failed to generate banking vouchers demo.');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateRemittanceVoucherDemo() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = buildRemittanceVoucherDemoReport(config: _createConfig());
      await demoDocuments.saveAndOpen(
        bytes: Uint8List.fromList(bytes),
        fileName: 'remittance_voucher_demo.pdf',
      );
      _showSuccess(_isRTL
          ? 'تم إنشاء عرض سندات الحوالات.'
          : 'Remittance vouchers demo generated.');
    } catch (_) {
      _showError(_isRTL
          ? 'تعذر إنشاء عرض سندات الحوالات.'
          : 'Failed to generate remittance vouchers demo.');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateTradeVoucherDemo() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = buildTradeVoucherDemoReport(config: _createConfig());
      await demoDocuments.saveAndOpen(
        bytes: Uint8List.fromList(bytes),
        fileName: 'trade_voucher_demo.pdf',
      );
      _showSuccess(_isRTL
          ? 'تم إنشاء عرض سندات التجارة.'
          : 'Trade vouchers demo generated.');
    } catch (_) {
      _showError(_isRTL
          ? 'تعذر إنشاء عرض سندات التجارة.'
          : 'Failed to generate trade vouchers demo.');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateAuxiliaryVoucherDemo() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = buildAuxiliaryVoucherDemoReport(config: _createConfig());
      await demoDocuments.saveAndOpen(
        bytes: Uint8List.fromList(bytes),
        fileName: 'auxiliary_voucher_demo.pdf',
      );
      _showSuccess(_isRTL
          ? 'تم إنشاء عرض السندات المساعدة.'
          : 'Auxiliary vouchers demo generated.');
    } catch (_) {
      _showError(_isRTL
          ? 'تعذر إنشاء عرض السندات المساعدة.'
          : 'Failed to generate auxiliary vouchers demo.');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateCompleteDemo() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = buildCompleteVoucherDemoReport(config: _createConfig());
      await demoDocuments.saveAndOpen(
        bytes: Uint8List.fromList(bytes),
        fileName: 'complete_voucher_demo.pdf',
      );
      _showSuccess(_isRTL
          ? 'تم إنشاء العرض الشامل.'
          : 'Complete vouchers demo generated.');
    } catch (_) {
      _showError(_isRTL
          ? 'تعذر إنشاء العرض الشامل.'
          : 'Failed to generate complete vouchers demo.');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

class _ExampleTab {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  _ExampleTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}
