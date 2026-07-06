// ignore_for_file: unused_element_parameter

import 'package:flutter/material.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/features/job_manager/presentation/controllers/job_manager_demo_controller.dart';
import 'package:genius_pdf_example/features/job_manager/presentation/models/job_feature_catalog.dart';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;


import 'package:genius_pdf_example/app/theme/app_theme.dart';

class JobManagerDemoScreen extends StatefulWidget {
  const JobManagerDemoScreen({super.key, this.controller});

  final JobManagerDemoController? controller;

  @override
  State<JobManagerDemoScreen> createState() => _JobManagerDemoScreenState();
}

class _JobManagerDemoScreenState extends State<JobManagerDemoScreen> {
  late final JobManagerDemoController _controller;
  late final bool _ownsController;
  PdfFont? _font;
  // Feature categories for testing.
  List<JobFeatureCategory> _featureCategories = const [];

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? JobManagerDemoController(
      documents: demoDocuments,
    );
    _controller.addListener(_onControllerChanged);

    _loadFont();
  }


  void _onControllerChanged() {
    if (mounted) setState(() {});
  }



  Future<void> _loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/din/din.ttf');
    final fontBytes = fontData.buffer.asUint8List();
    final font = PdfTrueTypeFont(fontBytes, 10);
    if (!mounted) return;
    setState(() {
      _font = font;
      _featureCategories = JobFeatureCatalog(
        config: geniusPdfConfig,
        font: font,
        fontBytes: fontBytes,
      ).build();
    });
  }

  @override
  void dispose() {
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
        _controller.jobs.where((j) => j.status == GeniusPdfJobStatus.queued).length;
    final processing =
        _controller.jobs.where((j) => j.status == GeniusPdfJobStatus.processing).length;
    final completed =
        _controller.jobs.where((j) => j.status == GeniusPdfJobStatus.completed).length;
    final failed =
        _controller.jobs.where((j) => j.status == GeniusPdfJobStatus.failed).length;

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
          if (_controller.jobs.any((j) => j.status == GeniusPdfJobStatus.queued))
            _buildHeaderButton(
              isDark: isDark,
              label: 'Cancel All',
              icon: Icons.cancel_rounded,
              gradient: AppColors.errorGradient,
              onPressed: _cancelAllQueued,
            ),
          if (_controller.jobs.any((j) => j.isFinished)) ...[
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

  Widget _buildCategoryCard(JobFeatureCategory category, bool isDark) {
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
      JobFeature feature, List<Color> gradient, bool isDark) {
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
                if (_controller.jobs.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGradient.first
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_controller.jobs.length} jobs',
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
            child: _controller.jobs.isEmpty
                ? _buildEmptyState(isDark)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _controller.jobs.length,
                    itemBuilder: (context, index) {
                      final job = _controller.jobs[_controller.jobs.length - 1 - index];
                      final filePath = _controller.jobFilePaths[job.id];
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

  Future<void> _testFeature(JobFeature feature) async {
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

  Future<void> _testCategory(JobFeatureCategory category) async {
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
    String name,
    GeniusPdfDocumentBuilder builder,
  ) =>
      _controller.addJob(
        name: name,
        builder: builder,
        onError: (message) => _showMessage(message, isError: true),
      );

  // === Utility Methods ===

  Future<void> _openFile(String filePath) async {
    try {
      await _controller.openFile(filePath);
    } catch (error) {
      _showMessage('Failed to open file: $error', isError: true);
    }
  }

  void _cancelJob(String id) => _controller.cancelJob(id);

  Future<void> _retryJob(String id) => _controller.retryJob(id);

  void _removeJob(String id) => _controller.removeJob(id);

  void _cancelAllQueued() {
    final count = _controller.cancelAllQueued();
    _showMessage('$count jobs cancelled');
  }

  void _clearFinished() {
    final count = _controller.clearFinished();
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






