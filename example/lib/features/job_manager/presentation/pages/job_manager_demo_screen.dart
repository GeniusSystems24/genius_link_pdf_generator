import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:super_core/super_core.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/features/job_manager/presentation/controllers/job_manager_demo_controller.dart';
import 'package:genius_pdf_example/features/job_manager/presentation/models/job_feature_catalog.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_page_shell.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_panels.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_section.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/responsive_split_layout.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Demonstrates queued/background PDF generation and job lifecycle management.
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
  List<JobFeatureCategory> _categories = const <JobFeatureCategory>[];

  static const _usageCode = r'''// Queue a PDF builder without opening it automatically.
await controller.addJob(
  name: 'Trial Balance',
  builder: builder,
  onError: (message) {
    // Surface the generation failure in your application UI.
  },
);

// Job lifecycle operations.
controller.cancelJob(jobId);
await controller.retryJob(jobId);
controller.removeJob(jobId);

// A completed demo job can be opened from its saved file path.
await controller.openFile(filePath);''';

  @override
  void initState() {
    super.initState();
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? JobManagerDemoController(documents: demoDocuments);
    _controller.addListener(_onControllerChanged);
    _loadFont();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _loadFont() async {
    try {
      final data = await rootBundle.load('assets/fonts/din/din.ttf');
      final bytes = data.buffer.asUint8List();
      final font = PdfTrueTypeFont(bytes, 10);
      if (!mounted) return;
      setState(() {
        _font = font;
        _categories = JobFeatureCatalog(
          config: geniusPdfConfig,
          font: font,
          fontBytes: bytes,
        ).build();
      });
    } catch (error) {
      if (mounted) _message('Unable to load demo font: $error', error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobs = _controller.jobs;
    final queued = jobs.where((j) => j.status == GeniusPdfJobStatus.queued).length;
    final processing = jobs.where((j) => j.status == GeniusPdfJobStatus.processing).length;
    final completed = jobs.where((j) => j.status == GeniusPdfJobStatus.completed).length;
    final failed = jobs.where((j) => j.status == GeniusPdfJobStatus.failed).length;
    final hasQueued = queued > 0;
    final hasFinished = jobs.any((job) => job.isFinished);

    return ExamplePageShell(
      title: pdfLocalization.backgroundGenerationAndJobQueue,
      description:
          pdfLocalization.queueMultiplePdfBuildersObserveDesc,
      leading: const Icon(Icons.work_history_outlined),
      actions: <Widget>[
        if (hasQueued)
          OutlinedButton.icon(
            onPressed: _cancelAllQueued,
            icon: const Icon(Icons.cancel_outlined),
            label:  Text(pdfLocalization.cancelQueued),
          ),
        if (hasFinished)
          OutlinedButton.icon(
            onPressed: _clearFinished,
            icon: const Icon(Icons.cleaning_services_outlined),
            label:  Text(pdfLocalization.clearFinished),
          ),
        FilledButton.icon(
          onPressed: _font == null ? null : _testAllFeatures,
          icon: const Icon(Icons.playlist_add_check_rounded),
          label:  Text(pdfLocalization.queueAll),
        ),
      ],
      children: <Widget>[
        _JobMetrics(
          queued: queued,
          processing: processing,
          completed: completed,
          failed: failed,
        ),
        ResponsiveSplitLayout(
          breakpoint: 1120,
          primaryFlex: 10,
          secondaryFlex: 13,
          primary: ExampleSection(
            title: pdfLocalization.generationCatalog,
            description: _font == null
                ? 'Loading the demo font before builders can be queued…'
                : 'Run one builder or enqueue every implemented builder in a category.',
            leading: const Icon(Icons.widgets_outlined),
            child: _FeatureCatalog(
              categories: _categories,
              enabled: _font != null,
              onFeature: _testFeature,
              onCategory: _testCategory,
            ),
          ),
          secondary: ExampleSection(
            title: pdfLocalization.jobQueue,
            description: pdfLocalization.newestJobsAppearFirstCompletedJobsDesc,
            leading: const Icon(Icons.queue_outlined),
            child: _JobQueue(
              jobs: jobs,
              paths: _controller.jobFilePaths,
              onCancel: _controller.cancelJob,
              onRetry: _controller.retryJob,
              onRemove: _controller.removeJob,
              onOpen: _openFile,
            ),
          ),
        ),
         CodePreviewPanel(
          title: pdfLocalization.dartUsageCode,
          code: _usageCode,
          height: 300,
        ),
      ],
    );
  }

  Future<void> _testFeature(JobFeature feature) async {
    if (_font == null) return;
    final builder = feature.builder();
    if (builder == null) {
      _message('Builder not implemented for ${feature.name}', error: true);
      return;
    }
    await _addJob(feature.name, builder);
  }

  Future<void> _testCategory(JobFeatureCategory category) async {
    if (_font == null) return;
    for (final feature in category.features) {
      final builder = feature.builder();
      if (builder != null) await _addJob('${category.name}_${feature.name}', builder);
    }
  }

  Future<void> _testAllFeatures() async {
    if (_font == null) return;
    for (final category in _categories) {
      for (final feature in category.features) {
        final builder = feature.builder();
        if (builder != null) await _addJob('${category.name}_${feature.name}', builder);
      }
    }
  }

  Future<void> _addJob(String name, GeniusPdfDocumentBuilder builder) {
    return _controller.addJob(
      name: name,
      builder: builder,
      onError: (message) => _message(message, error: true),
    );
  }

  Future<void> _openFile(String path) async {
    try {
      await _controller.openFile(path);
    } catch (error) {
      _message('Failed to open file: $error', error: true);
    }
  }

  void _cancelAllQueued() {
    final count = _controller.cancelAllQueued();
    _message('$count queued job(s) cancelled');
  }

  void _clearFinished() {
    final count = _controller.clearFinished();
    _message('$count finished job(s) cleared');
  }

  void _message(String message, {bool error = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: error ? Theme.of(context).colorScheme.error : null,
      ),
    );
  }
}

class _JobMetrics extends StatelessWidget {
  const _JobMetrics({
    required this.queued,
    required this.processing,
    required this.completed,
    required this.failed,
  });

  final int queued;
  final int processing;
  final int completed;
  final int failed;

  @override
  Widget build(BuildContext context) {
    final gap = context.superTheme.spacing.space3;
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: <Widget>[
        _Metric(label: pdfLocalization.queued, value: queued, icon: Icons.schedule_outlined),
        _Metric(label: pdfLocalization.processing, value: processing, icon: Icons.sync_rounded),
        _Metric(label: pdfLocalization.completed, value: completed, icon: Icons.check_circle_outline),
        _Metric(label: pdfLocalization.failed, value: failed, icon: Icons.error_outline),
      ],
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value, required this.icon});
  final String label;
  final int value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: 190,
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: t.spacing.cardPadding,
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(t.spacing.radiusControl),
                ),
                child: Icon(icon, color: colors.onPrimaryContainer),
              ),
              SizedBox(width: t.spacing.space3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('$value', style: context.superTextTheme.titleMd.copyWith(color: t.fg1)),
                  Text(label, style: context.superTextTheme.bodySm.copyWith(color: t.fg3)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCatalog extends StatelessWidget {
  const _FeatureCatalog({
    required this.categories,
    required this.enabled,
    required this.onFeature,
    required this.onCategory,
  });

  final List<JobFeatureCategory> categories;
  final bool enabled;
  final ValueChanged<JobFeature> onFeature;
  final ValueChanged<JobFeatureCategory> onCategory;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    if (categories.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: <Widget>[
        for (var i = 0; i < categories.length; i++) ...<Widget>[
          _CategoryCard(
            category: categories[i],
            enabled: enabled,
            onFeature: onFeature,
            onRunAll: () => onCategory(categories[i]),
          ),
          if (i != categories.length - 1) SizedBox(height: spacing.space3),
        ],
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.enabled,
    required this.onFeature,
    required this.onRunAll,
  });
  final JobFeatureCategory category;
  final bool enabled;
  final ValueChanged<JobFeature> onFeature;
  final VoidCallback onRunAll;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: t.spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(category.icon, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: t.spacing.space2),
                Expanded(child: Text(category.name, style: context.superTextTheme.titleMd.copyWith(color: t.fg1))),
                TextButton.icon(
                  onPressed: enabled && category.features.isNotEmpty ? onRunAll : null,
                  icon: const Icon(Icons.playlist_add_rounded, size: 18),
                  label:  Text(pdfLocalization.queueGroup),
                ),
              ],
            ),
            SizedBox(height: t.spacing.space3),
            Wrap(
              spacing: t.spacing.space2,
              runSpacing: t.spacing.space2,
              children: <Widget>[
                for (final feature in category.features)
                  ActionChip(
                    avatar: const Icon(Icons.play_arrow_rounded, size: 16),
                    label: Text(feature.name),
                    tooltip: feature.description,
                    onPressed: enabled ? () => onFeature(feature) : null,
                  ),
              ],
            ),
            if (category.features.isEmpty)
              Text(pdfLocalization.noActiveExamplesInThisCategory, style: context.superTextTheme.bodySm.copyWith(color: t.fg3)),
          ],
        ),
      ),
    );
  }
}

class _JobQueue extends StatelessWidget {
  const _JobQueue({
    required this.jobs,
    required this.paths,
    required this.onCancel,
    required this.onRetry,
    required this.onRemove,
    required this.onOpen,
  });

  final List<GeniusPdfJob> jobs;
  final Map<String, String> paths;
  final ValueChanged<String> onCancel;
  final Future<void> Function(String) onRetry;
  final ValueChanged<String> onRemove;
  final Future<void> Function(String) onOpen;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    if (jobs.isEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: spacing.space8),
        child: Column(
          children: <Widget>[
            Icon(Icons.inbox_outlined, size: 42, color: context.superTheme.fg3),
            SizedBox(height: spacing.space3),
            Text(pdfLocalization.noJobsQueued, style: context.superTextTheme.titleMd.copyWith(color: context.superTheme.fg1)),
            SizedBox(height: spacing.space1),
            Text(pdfLocalization.chooseAGenerationExampleFromTheCatalog, style: context.superTextTheme.bodySm.copyWith(color: context.superTheme.fg3)),
          ],
        ),
      );
    }
    final reversed = jobs.reversed.toList(growable: false);
    return Column(
      children: <Widget>[
        for (var i = 0; i < reversed.length; i++) ...<Widget>[
          _JobTile(
            job: reversed[i],
            onCancel: () => onCancel(reversed[i].id),
            onRetry: () => onRetry(reversed[i].id),
            onRemove: () => onRemove(reversed[i].id),
            onOpen: paths[reversed[i].id] == null ? null : () => onOpen(paths[reversed[i].id]!),
          ),
          if (i != reversed.length - 1) SizedBox(height: spacing.space2),
        ],
      ],
    );
  }
}

class _JobTile extends StatelessWidget {
  const _JobTile({
    required this.job,
    required this.onCancel,
    required this.onRetry,
    required this.onRemove,
    this.onOpen,
  });
  final GeniusPdfJob job;
  final VoidCallback onCancel;
  final VoidCallback onRetry;
  final VoidCallback onRemove;
  final VoidCallback? onOpen;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final semantic = _semantic(context);
    return Container(
      padding: t.spacing.cardPadding,
      decoration: BoxDecoration(
        color: semantic.subtle,
        border: Border.all(color: semantic.border),
        borderRadius: t.spacing.cardBorderRadius,
      ),
      child: Row(
        children: <Widget>[
          job.status == GeniusPdfJobStatus.processing
              ? SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(strokeWidth: 2, color: semantic.solid),
                )
              : Icon(_icon, color: semantic.solid),
          SizedBox(width: t.spacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(job.fileName, style: context.superTextTheme.labelMd.copyWith(color: semantic.onSubtle)),
                SizedBox(height: t.spacing.space1),
                Text(_status, style: context.superTextTheme.bodySm.copyWith(color: semantic.onSubtle)),
                if (job.duration != null)
                  Text('${job.duration!.inMilliseconds} ms', style: context.superTextTheme.labelSm.copyWith(color: semantic.onSubtle)),
              ],
            ),
          ),
          _actions,
        ],
      ),
    );
  }

  SuperSemanticColor _semantic(BuildContext context) {
    final s = SuperSemanticColors.of(context);
    return switch (job.status) {
      GeniusPdfJobStatus.queued => s.info,
      GeniusPdfJobStatus.processing => s.warning,
      GeniusPdfJobStatus.completed => s.success,
      GeniusPdfJobStatus.failed => s.danger,
      GeniusPdfJobStatus.cancelled => s.neutral,
    };
  }

  IconData get _icon => switch (job.status) {
    GeniusPdfJobStatus.queued => Icons.schedule_outlined,
    GeniusPdfJobStatus.processing => Icons.sync_rounded,
    GeniusPdfJobStatus.completed => Icons.check_circle_outline,
    GeniusPdfJobStatus.failed => Icons.error_outline,
    GeniusPdfJobStatus.cancelled => Icons.cancel_outlined,
  };

  String get _status => switch (job.status) {
    GeniusPdfJobStatus.queued => 'Waiting in queue',
    GeniusPdfJobStatus.processing => 'Generating…',
    GeniusPdfJobStatus.completed => 'Completed',
    GeniusPdfJobStatus.failed => job.errorMessage ?? 'Failed',
    GeniusPdfJobStatus.cancelled => 'Cancelled',
  };

  Widget get _actions {
    if (job.status == GeniusPdfJobStatus.queued) {
      return IconButton(onPressed: onCancel, tooltip: pdfLocalization.cancel, icon: const Icon(Icons.close_rounded));
    }
    if (job.status == GeniusPdfJobStatus.completed && onOpen != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(onPressed: onOpen, tooltip: pdfLocalization.open, icon: const Icon(Icons.open_in_new_rounded)),
          IconButton(onPressed: onRemove, tooltip: pdfLocalization.remove, icon: const Icon(Icons.delete_outline_rounded)),
        ],
      );
    }
    if (job.status == GeniusPdfJobStatus.failed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(onPressed: onRetry, tooltip: pdfLocalization.retry, icon: const Icon(Icons.refresh_rounded)),
          IconButton(onPressed: onRemove, tooltip: pdfLocalization.remove, icon: const Icon(Icons.delete_outline_rounded)),
        ],
      );
    }
    if (job.isFinished) {
      return IconButton(onPressed: onRemove, tooltip: pdfLocalization.remove, icon: const Icon(Icons.delete_outline_rounded));
    }
    return const SizedBox.shrink();
  }
}
