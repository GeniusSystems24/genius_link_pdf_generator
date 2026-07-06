
import 'package:flutter/material.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/features/export/presentation/controllers/export_demo_controller.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/theme/app_theme.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/component_page.dart';
// import 'package:genius_pdf_example/shared/presentation/widgets/custom_tab_bar.dart';

/// Demo screen for multi-format export features.
class ExportDemoScreen extends StatefulWidget {
  const ExportDemoScreen({
    super.key,
    this.initialTab = 0,
    this.controller,
  });

  final int initialTab;
  final ExportDemoController? controller;

  @override
  State<ExportDemoScreen> createState() => _ExportDemoScreenState();
}

class _ExportDemoScreenState extends State<ExportDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final ExportDemoController _controller;
  late final bool _ownsController;

  final List<_ExportTab> _tabs = [
    _ExportTab(
      id: 'image_export',
      title: 'Image Export',
      icon: Icons.image_rounded,
      gradient: AppColors.infoGradient,
    ),
    _ExportTab(
      id: 'doc_export',
      title: 'Document Export',
      icon: Icons.description_rounded,
      gradient: AppColors.purpleGradient,
    ),
    _ExportTab(
      id: 'batch_export',
      title: 'Batch Export',
      icon: Icons.dynamic_feed_rounded,
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
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? ExportDemoController(
      config: geniusPdfConfig,
      documents: demoDocuments,
    );
    _controller.addListener(_onControllerChanged);
    _controller.initialize();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
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
                _buildImageExportTab(isDark),
                _buildDocExportTab(isDark),
                _buildBatchExportTab(isDark),
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

  Widget _buildImageExportTab(bool isDark) {
    return ComponentPage(
      title: 'Image Export',
      description:
          'Export PDF pages as high-quality PNG or compressed JPEG images.',
      icon: Icons.image_rounded,
      gradient: AppColors.infoGradient,
      isDark: isDark,
      isRTL: _controller.isRtl,
      onRTLChanged: _controller.setRtl,
      isGenerating: _controller.isLoading,
      onGenerate: null,
      codeExample: '''
final config = GeniusExportConfiguration.image(
  format: GeniusExportFormat.png,
  quality: GeniusImageQuality.high,
);
await service.export(doc, config);
''',
      preview: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ExportCard(
                  isDark: isDark,
                  icon: Icons.image_rounded,
                  label: 'PNG',
                  sublabel: 'High quality',
                  gradient: AppColors.infoGradient,
                  onPressed: _controller.isReady && !_controller.isLoading
                      ? () => _exportTo(GeniusExportFormat.png)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ExportCard(
                  isDark: isDark,
                  icon: Icons.photo_rounded,
                  label: 'JPEG',
                  sublabel: 'Compressed',
                  gradient: AppColors.orangeGradient,
                  onPressed: _controller.isReady && !_controller.isLoading
                      ? () => _exportTo(GeniusExportFormat.jpeg)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusAndResult(isDark),
        ],
      ),
    );
  }

  Widget _buildDocExportTab(bool isDark) {
    return ComponentPage(
      title: 'Document Export',
      description: 'Export to HTML, plain text, or PDF/A archival format.',
      icon: Icons.description_rounded,
      gradient: AppColors.purpleGradient,
      isDark: isDark,
      isRTL: _controller.isRtl,
      onRTLChanged: _controller.setRtl,
      isGenerating: _controller.isLoading,
      onGenerate: null,
      codeExample: '''
// HTML Export
final htmlConfig = GeniusExportConfiguration.html(
  embedImages: true,
  includeStyles: true,
);

// PDF/A Export
final pdfaConfig = GeniusExportConfiguration.pdfA(
  compress: true,
);
''',
      preview: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _ExportCard(
                  isDark: isDark,
                  icon: Icons.html_rounded,
                  label: 'HTML',
                  sublabel: 'Web format',
                  gradient: AppColors.purpleGradient,
                  onPressed: _controller.isReady && !_controller.isLoading
                      ? () => _exportTo(GeniusExportFormat.html)
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ExportCard(
                  isDark: isDark,
                  icon: Icons.text_snippet_rounded,
                  label: 'Text',
                  sublabel: 'Plain text',
                  gradient: AppColors.tealGradient,
                  onPressed: _controller.isReady && !_controller.isLoading
                      ? () => _exportTo(GeniusExportFormat.text)
                      : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ExportCard(
            isDark: isDark,
            icon: Icons.archive_rounded,
            label: 'PDF/A (Archival)',
            sublabel: 'Long-term preservation',
            gradient: AppColors.successGradient,
            onPressed: _controller.isReady && !_controller.isLoading
                ? () => _exportTo(GeniusExportFormat.pdfA)
                : null,
          ),
          const SizedBox(height: 16),
          _buildStatusAndResult(isDark),
        ],
      ),
    );
  }

  Widget _buildBatchExportTab(bool isDark) {
    return ComponentPage(
      title: 'Batch Export',
      description: 'Export to multiple formats simultaneously in background.',
      icon: Icons.dynamic_feed_rounded,
      gradient: AppColors.primaryGradient,
      isDark: isDark,
      isRTL: _controller.isRtl,
      onRTLChanged: _controller.setRtl,
      isGenerating: _controller.isLoading,
      onGenerate: null,
      codeExample: '''
final exporter = GeniusBatchExporter(maxConcurrent: 2);
final results = await exporter.exportToMultipleFormats(
  document,
  [
    GeniusExportFormat.png,
    GeniusExportFormat.html,
    GeniusExportFormat.text
  ],
);
''',
      preview: Column(
        children: [
          _ExportCard(
            isDark: isDark,
            icon: Icons.dynamic_feed_rounded,
            label: 'Export to All Formats',
            sublabel: 'PNG, HTML, Text',
            gradient: AppColors.primaryGradient,
            onPressed:
                _controller.isReady && !_controller.isLoading ? _batchExport : null,
          ),
          const SizedBox(height: 16),
          _buildStatusAndResult(isDark),
        ],
      ),
    );
  }

  Widget _buildStatusAndResult(bool isDark) {
    return Column(
      children: [
        _buildStatusCard(isDark),
        if (_controller.lastResult != null) ...[
          const SizedBox(height: 16),
          _buildResultCard(isDark),
        ],
      ],
    );
  }

  Widget _buildStatusCard(bool isDark) {
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
                _controller.isReady
                    ? Icons.check_circle_rounded
                    : Icons.pending_rounded,
                color: _controller.isReady
                    ? AppColors.success
                    : AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _controller.status.isEmpty ? 'Ready' : _controller.status,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
              if (_controller.isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          if (_controller.isLoading) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _controller.progress,
                backgroundColor:
                    isDark ? AppColors.darkBorder : AppColors.lightBorder,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(_controller.progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildResultCard(bool isDark) {
    if (_controller.lastResult is GeniusExportSuccess) {
      final success = _controller.lastResult as GeniusExportSuccess;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Export Successful',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),
                if (_controller.lastFilePath != null)
                  IconButton(
                    icon: const Icon(Icons.open_in_new_rounded,
                        color: AppColors.primary),
                    onPressed: _openLastFile,
                    tooltip: 'Open File',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(isDark, 'Format', success.format.displayName),
            _buildInfoRow(isDark, 'Pages', '${success.pageCount}'),
            _buildInfoRow(isDark, 'Size', success.fileSizeFormatted),
            if (_controller.lastFilePath != null)
              _buildInfoRow(isDark, 'Path', _controller.lastFilePath!),
          ],
        ),
      );
    } else if (_controller.lastResult is GeniusExportFailure) {
      final failure = _controller.lastResult as GeniusExportFailure;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_rounded, color: AppColors.error),
                const SizedBox(width: 8),
                Text(
                  'Export Failed',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              failure.message,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInfoRow(bool isDark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _exportTo(GeniusExportFormat format) =>
      _controller.exportTo(format);

  Future<void> _batchExport() => _controller.batchExport();

  Future<void> _openLastFile() async {
    try {
      await _controller.openLastFile();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open file: $error'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }
}

class _ExportCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final String sublabel;
  final List<Color> gradient;
  final VoidCallback? onPressed;

  const _ExportCard({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.gradient,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradient[0].withValues(alpha: 0.2),
                        gradient[1].withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: gradient[0], size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: onPressed != null
                        ? (isDark ? AppColors.darkText : AppColors.lightText)
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ExportTab {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  _ExportTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}
