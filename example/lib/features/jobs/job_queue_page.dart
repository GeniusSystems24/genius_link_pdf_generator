import 'dart:async';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets;
import 'package:super_core/super_core.dart';

import '../../app/dependencies/example_dependencies.dart';
import '../../app/localization/showcase_localizations.dart';
import '../../app/navigation/showcase_catalog.dart';
import '../../shared/presentation/widgets/full_screen_pdf_viewer.dart';
import '../../shared/presentation/widgets/showcase_page.dart';
import '../job_template_registry.dart';

class JobQueuePage extends StatefulWidget {
  const JobQueuePage({super.key, required this.destination});
  final ShowcaseDestination destination;

  @override
  State<JobQueuePage> createState() => _JobQueuePageState();
}

class _JobQueuePageState extends State<JobQueuePage> {
  late final GeniusPdfGenerationManager _manager;
  StreamSubscription<GeniusPdfJob>? _subscription;
  int _counter = 0;
  String _templateId = JobTemplateRegistry.templates.first.id;
  GeniusPdfJobPriority _priority = GeniusPdfJobPriority.normal;
  bool _rtl = false;

  @override
  void initState() {
    super.initState();
    _manager = GeniusPdfGenerationManager(
      config: GeniusPdfGenerationManagerConfig(maxConcurrentJobs: 2),
    );
    _subscription = _manager.jobUpdates.listen((_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _manager.dispose();
    super.dispose();
  }

  Future<void> _add([GeniusPdfJobPriority? explicitPriority]) async {
    _counter++;
    final template = JobTemplateRegistry.byId(_templateId);
    final priority = explicitPriority ?? _priority;
    GeniusPdfDocumentBuilder factory() => template.builder(_rtl);

    await _manager.addJob(
      builder: factory(),
      builderFactory: factory,
      fileName: '${template.fileName}_$_counter',
      priority: priority,
      runInBackground: true,
      metadata: <String, dynamic>{
        'templateId': template.id,
        'templateLabel': template.label,
        'templateLabelAr': template.labelAr,
        'rtl': _rtl,
      },
    );
    if (mounted) setState(() {});
  }

  Future<void> _openCompleted(GeniusPdfJob job) async {
    final result = job.result;
    if (result is! GeniusPdfSuccess) return;
    final path = result.filePath;
    if (path != null && path.isNotEmpty) {
      await geniusPdfClient.openFile(path);
      return;
    }
    if (!mounted) return;
    await showFullScreenPdfViewer(
      context,
      bytes: result.bytes,
      title: job.fileName,
    );
  }

  Future<void> _previewCompleted(GeniusPdfJob job) async {
    final result = job.result;
    if (result is! GeniusPdfSuccess || !mounted) return;
    await showFullScreenPdfViewer(
      context,
      bytes: result.bytes,
      title: job.fileName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final t = context.superTheme;
    final jobs = _manager.allJobs.reversed.toList();
    final selectedTemplate = JobTemplateRegistry.byId(_templateId);

    return ShowcasePage(
      title: l10n.destinationTitle(
        widget.destination.id,
        widget.destination.title,
      ),
      description: l10n.destinationDescription(
        widget.destination.id,
        widget.destination.description,
      ),
      icon: widget.destination.icon,
      api: widget.destination.api,
      children: [
        ShowcaseSection(
          title: l10n.tr('Queue controls'),
          subtitle: l10n.tr(
            'Choose any template, direction and priority before adding it to the queue.',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: t.spacing.space3,
                runSpacing: t.spacing.space2,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 310,
                    child: DropdownButtonFormField<String>(
                      value: _templateId,
                      decoration: InputDecoration(
                        labelText: l10n.tr('Template'),
                      ),
                      items: [
                        for (final template in JobTemplateRegistry.templates)
                          DropdownMenuItem<String>(
                            value: template.id,
                            child: Text(
                              l10n.exampleTitle(
                                template.label,
                                template.labelAr,
                              ),
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => _templateId = value);
                      },
                    ),
                  ),
                  SizedBox(
                    width: 190,
                    child: DropdownButtonFormField<GeniusPdfJobPriority>(
                      value: _priority,
                      decoration: InputDecoration(
                        labelText: l10n.tr('Priority'),
                      ),
                      items: [
                        for (final priority in GeniusPdfJobPriority.values)
                          DropdownMenuItem(
                            value: priority,
                            child: Text(l10n.tr(priority.name)),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) setState(() => _priority = value);
                      },
                    ),
                  ),
                  FilterChip(
                    label: Text(_rtl ? 'RTL' : 'LTR'),
                    selected: _rtl,
                    onSelected: (value) => setState(() => _rtl = value),
                  ),
                ],
              ),
              SizedBox(height: t.spacing.space3),
              Wrap(
                spacing: t.spacing.space2,
                runSpacing: t.spacing.space2,
                children: [
                  SuperButton(
                    label: l10n.tr('Add selected template'),
                    icon: const Icon(Icons.add_task_outlined),
                    onPressed: _add,
                  ),
                  SuperButton(
                    label: l10n.tr('Add high priority'),
                    variant: SuperButtonVariant.secondary,
                    onPressed: () => _add(GeniusPdfJobPriority.high),
                  ),
                  SuperButton(
                    label: l10n.tr('Add urgent job'),
                    variant: SuperButtonVariant.secondary,
                    onPressed: () => _add(GeniusPdfJobPriority.urgent),
                  ),
                ],
              ),
              SizedBox(height: t.spacing.space2),
              Text(
                '${l10n.tr('Selected template')}: ${l10n.exampleTitle(selectedTemplate.label, selectedTemplate.labelAr)}',
                style: context.superTextTheme.caption.copyWith(color: t.fg2),
              ),
            ],
          ),
        ),
        ShowcaseSection(
          title: l10n.tr('Jobs'),
          subtitle:
              '${_manager.activeJobs.length} ${l10n.tr('active')} • ${_manager.completedJobs.length} ${l10n.tr('completed')}',
          child: jobs.isEmpty
              ? Text(
                  l10n.tr('No jobs yet.'),
                  style: context.superTextTheme.body.copyWith(color: t.fg2),
                )
              : Column(
                  children: [
                    for (final job in jobs)
                      _JobRow(
                        job: job,
                        onCancel: job.isActive
                            ? () {
                                _manager.cancelJob(job.id);
                                setState(() {});
                              }
                            : null,
                        onOpen:
                            job.status == GeniusPdfJobStatus.completed &&
                                job.result is GeniusPdfSuccess
                            ? () => _openCompleted(job)
                            : null,
                        onPreview:
                            job.status == GeniusPdfJobStatus.completed &&
                                job.result is GeniusPdfSuccess
                            ? () => _previewCompleted(job)
                            : null,
                      ),
                  ],
                ),
        ),
      ],
    );
  }
}

class _JobRow extends StatelessWidget {
  const _JobRow({
    required this.job,
    required this.onCancel,
    required this.onOpen,
    required this.onPreview,
  });

  final GeniusPdfJob job;
  final VoidCallback? onCancel;
  final VoidCallback? onOpen;
  final VoidCallback? onPreview;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final t = context.superTheme;
    final metadata = job.metadata;
    final String? templateName = metadata == null
        ? null
        : l10n.isArabic
        ? metadata['templateLabelAr']
        : metadata['templateLabel'];

    return Padding(
      padding: EdgeInsets.only(bottom: t.spacing.space2),
      child: Container(
        padding: t.spacing.cardPadding,
        decoration: BoxDecoration(
          color: t.inputBg,
          border: Border.all(color: t.border),
          borderRadius: t.spacing.borderRadiusCard,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    templateName ?? job.fileName,
                    style: context.superTextTheme.label,
                  ),
                  SizedBox(height: t.spacing.space1),
                  Text(
                    job.fileName,
                    style: context.superTextTheme.caption.copyWith(
                      color: t.fg3,
                    ),
                  ),
                  SizedBox(height: t.spacing.space1),
                  Text(
                    '${l10n.tr(job.priority.name)} • ${l10n.tr(job.status.name)}',
                    style: context.superTextTheme.caption.copyWith(
                      color: t.fg2,
                    ),
                  ),
                ],
              ),
            ),
            if (job.status == GeniusPdfJobStatus.processing)
              SizedBox(
                width: 80,
                child: LinearProgressIndicator(
                  value: job.progress == 0 ? null : job.progress,
                ),
              ),
            if (onPreview != null) ...[
              SizedBox(width: t.spacing.space1),
              IconButton(
                onPressed: onPreview,
                tooltip: l10n.tr('Preview full screen'),
                icon: const Icon(Icons.fullscreen_outlined),
              ),
            ],
            if (onOpen != null) ...[
              SizedBox(width: t.spacing.space1),
              IconButton(
                onPressed: onOpen,
                tooltip: l10n.tr('Open completed file'),
                icon: const Icon(Icons.open_in_new),
              ),
            ],
            if (onCancel != null) ...[
              SizedBox(width: t.spacing.space1),
              IconButton(
                onPressed: onCancel,
                tooltip: l10n.tr('Cancel'),
                icon: const Icon(Icons.close),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
