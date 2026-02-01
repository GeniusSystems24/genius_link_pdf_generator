import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../documents/advanced_layout_demo_document.dart';
import '../documents/charts_in_builder_demo_document.dart';
import '../documents/multi_grid_summary_demo_document.dart';
import '../documents/position_tracking_demo_document.dart';
import '../documents/qr_attachments_demo_document.dart';
import '../documents/report_composer_demo_document.dart';
import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';

/// Showcase screen for selected demo examples.
class ExamplesShowcaseScreen extends StatefulWidget {
  const ExamplesShowcaseScreen({super.key});

  @override
  State<ExamplesShowcaseScreen> createState() => _ExamplesShowcaseScreenState();
}

class _ExamplesShowcaseScreenState extends State<ExamplesShowcaseScreen> {
  bool _isGenerating = false;
  bool _isRTL = true;

  List<_ExampleItem> get _examples => [
        _ExampleItem(
          id: 'advanced_layout',
          title: 'Advanced Layout',
          titleAr: 'تخطيط متقدم',
          description:
              'Rich text, info boxes, report headers, and flexible columns.',
          descriptionAr: 'نص منسق، صناديق معلومات، رؤوس وتقسيمات مرنة.',
          icon: Icons.dashboard_customize_rounded,
          gradient: AppColors.primaryGradient,
          onGenerate: _generateAdvancedLayout,
        ),
        _ExampleItem(
          id: 'position_tracking',
          title: 'Position Tracking',
          titleAr: 'تتبع المواقع',
          description:
              'Precise Y tracking, auto page breaks, and image alignment.',
          descriptionAr: 'تتبع عمودي دقيق، كسر تلقائي، ومحاذاة صور.',
          icon: Icons.track_changes_rounded,
          gradient: AppColors.successGradient,
          onGenerate: _generatePositionTracking,
        ),
        _ExampleItem(
          id: 'multi_grid_summary',
          title: 'Multi-Grid Summary',
          titleAr: 'ملخص متعدد الجداول',
          description:
              'Multiple grids with per-section summaries and report totals.',
          descriptionAr: 'جداول متعددة مع ملخصات لكل قسم وإجمالي التقرير.',
          icon: Icons.table_chart_rounded,
          gradient: AppColors.purpleGradient,
          onGenerate: _generateMultiGridSummary,
        ),
        _ExampleItem(
          id: 'charts_in_builder',
          title: 'Charts in Builder',
          titleAr: 'المخططات في البناء',
          description:
              'Bar, line, pie, and area charts rendered inside the builder.',
          descriptionAr: 'مخططات أعمدة وخطية ودائرية ومساحية داخل البناء.',
          icon: Icons.insert_chart_rounded,
          gradient: AppColors.orangeGradient,
          onGenerate: _generateChartsInBuilder,
        ),
        _ExampleItem(
          id: 'qr_attachments',
          title: 'QR & Attachments',
          titleAr: 'رموز QR والمرفقات',
          description:
              'QR codes, inline attachments, and image pages in PDF.',
          descriptionAr: 'رموز QR ومرفقات مضمنة وصفحات صور.',
          icon: Icons.qr_code_rounded,
          gradient: AppColors.cyanGradient,
          onGenerate: _generateQrAttachments,
        ),
        _ExampleItem(
          id: 'report_composer',
          title: 'Report Composer',
          titleAr: 'مُركّب التقارير',
          description:
              'Fluent API for composing a full report without subclassing.',
          descriptionAr: 'واجهة سلسة لبناء تقرير كامل بدون وراثة.',
          icon: Icons.auto_awesome_rounded,
          gradient: AppColors.tealGradient,
          onGenerate: _generateReportComposer,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 1200;
    final isMedium = screenWidth > 800;

    return Container(
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(isDark),
            const SizedBox(height: 24),
            _buildExamplesGrid(isDark, isWide, isMedium),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: AppColors.primaryGradient,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.auto_awesome_mosaic_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isRTL ? 'أمثلة محددة' : 'Selected Examples',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _isRTL
                      ? 'استعرض أمثلة توضيحية للخصائص الحديثة مباشرة.'
                      : 'Preview key feature demos and generate PDFs instantly.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                _buildRtlToggle(isDark),
              ],
            ),
          ),
          if (_isGenerating)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isRTL ? 'جارٍ التوليد...' : 'Generating...',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRtlToggle(bool isDark) {
    return Row(
      children: [
        Text(
          _isRTL ? 'العربية' : 'English',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.darkText : AppColors.lightText,
          ),
        ),
        const SizedBox(width: 8),
        Switch.adaptive(
          value: _isRTL,
          onChanged: (value) => setState(() => _isRTL = value),
          activeColor: AppColors.primary,
        ),
        const SizedBox(width: 8),
        Text(
          _isRTL ? 'RTL' : 'LTR',
          style: TextStyle(
            fontSize: 12,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildExamplesGrid(bool isDark, bool isWide, bool isMedium) {
    final crossAxisCount = isWide ? 2 : 1;
    final childAspectRatio = isWide ? 2.6 : (isMedium ? 2.2 : 1.6);

    return GridView.count(
      crossAxisCount: crossAxisCount,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: childAspectRatio,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: _examples
          .map((example) => _buildExampleCard(isDark, example))
          .toList(),
    );
  }

  Widget _buildExampleCard(bool isDark, _ExampleItem example) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: example.gradient),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(example.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isRTL ? example.titleAr : example.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isRTL ? example.descriptionAr : example.description,
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
            ],
          ),
          const Spacer(),
          _buildGenerateButton(isDark, example),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(bool isDark, _ExampleItem example) {
    final label = _isGenerating
        ? (_isRTL ? 'جارٍ التوليد...' : 'Generating...')
        : (_isRTL ? 'إنشاء ملف PDF' : 'Generate PDF');

    return InkWell(
      onTap: _isGenerating ? null : () => _runExample(example),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isGenerating
                ? [
                    (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  ]
                : example.gradient,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isGenerating)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              const Icon(Icons.picture_as_pdf_rounded,
                  color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
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
    );
  }

  Future<void> _runExample(_ExampleItem example) async {
    if (_isGenerating) return;

    setState(() => _isGenerating = true);
    try {
      await example.onGenerate();
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  GeniusPdfConfig _createConfig() {
    return geniusPdfConfig.copyWith(
      textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
    );
  }

  Future<void> _generateAdvancedLayout() async {
    final builder = AdvancedLayoutDemoBuilder(config: _createConfig());
    await _generateWithBuilder(
      builder,
      'advanced_layout_demo',
      _isRTL ? 'تم إنشاء مثال التخطيط المتقدم.' : 'Advanced layout generated.',
    );
  }

  Future<void> _generatePositionTracking() async {
    final builder = PositionTrackingDemoBuilder(config: _createConfig());
    await _generateWithBuilder(
      builder,
      'position_tracking_demo',
      _isRTL ? 'تم إنشاء مثال تتبع المواقع.' : 'Position tracking generated.',
    );
  }

  Future<void> _generateMultiGridSummary() async {
    final builder = MultiGridSummaryDemoBuilder(config: _createConfig());
    await _generateWithBuilder(
      builder,
      'multi_grid_summary_demo',
      _isRTL
          ? 'تم إنشاء مثال الملخص متعدد الجداول.'
          : 'Multi-grid summary generated.',
    );
  }

  Future<void> _generateChartsInBuilder() async {
    final builder = ChartsInBuilderDemoBuilder(config: _createConfig());
    await _generateWithBuilder(
      builder,
      'charts_in_builder_demo',
      _isRTL ? 'تم إنشاء مثال المخططات.' : 'Charts demo generated.',
    );
  }

  Future<void> _generateQrAttachments() async {
    final builder = QRAttachmentsDemoBuilder(config: _createConfig());
    await _generateWithBuilder(
      builder,
      'qr_attachments_demo',
      _isRTL ? 'تم إنشاء مثال QR والمرفقات.' : 'QR & attachments generated.',
    );
  }

  Future<void> _generateReportComposer() async {
    try {
      final bytes = buildComposerDemoReport(config: _createConfig());
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/report_composer_demo.pdf';
      await GeniusPdfService().saveToPath(
        bytes: Uint8List.fromList(bytes),
        path: filePath,
      );
      await OpenFile.open(filePath);
      _showSuccess(_isRTL
          ? 'تم إنشاء مثال مُركّب التقارير.'
          : 'Report composer generated.');
    } catch (_) {
      _showError(_isRTL
          ? 'تعذر إنشاء مثال مُركّب التقارير.'
          : 'Failed to generate report composer.');
    }
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

class _ExampleItem {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final IconData icon;
  final List<Color> gradient;
  final Future<void> Function() onGenerate;

  const _ExampleItem({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.icon,
    required this.gradient,
    required this.onGenerate,
  });
}
