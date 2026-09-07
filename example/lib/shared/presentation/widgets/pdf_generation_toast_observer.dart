// Compact top-end PDF generation SuperToast observer
//
// Uses SuperToast.showRaw so generation feedback can stay compact while still
// retaining SuperToastHost positioning, stacking, animation, timers, swipe
// dismissal, and app-wide lifetime across Navigator route changes.

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart' hide EdgeInsets;
import 'package:super_core/super_core.dart';

/// Observes the app-wide [GeniusPdfGenerationManager] and presents compact
/// generation notifications through [SuperToast].
///
/// Each distinct job id owns at most one terminal notification. Repeated
/// `completed`, `failed`, or `cancelled` stream emissions are ignored, which
/// prevents duplicate completion toasts without suppressing separate jobs that
/// happen to generate the same file name.
class PdfGenerationToastObserver extends StatefulWidget {
  const PdfGenerationToastObserver({
    required this.manager,
    required this.child,
    this.duration = const Duration(seconds: 10),
    super.key,
  });

  /// Shared generation manager observed by the whole example application.
  final GeniusPdfGenerationManager manager;

  /// Routed application content.
  final Widget child;

  /// Automatic lifetime for progress and terminal notifications.
  ///
  /// A user can close or swipe a toast before this duration expires.
  final Duration duration;

  @override
  State<PdfGenerationToastObserver> createState() =>
      _PdfGenerationToastObserverState();
}

class _PdfGenerationToastObserverState
    extends State<PdfGenerationToastObserver> {
  final Map<String, _GenerationToastState> _active =
      <String, _GenerationToastState>{};

  // GeniusPdfGenerationManager may publish the same terminal job more than
  // once as job collections/listeners settle. Terminal UI is edge-triggered:
  // one terminal toast per distinct job id.
  final Set<String> _terminalEventsHandled = <String>{};

  StreamSubscription<GeniusPdfJob>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscribe(widget.manager);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      for (final job in widget.manager.activeJobs) {
        _handleJob(job);
      }
    });
  }

  @override
  void didUpdateWidget(PdfGenerationToastObserver oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.manager == widget.manager) return;

    _subscription?.cancel();
    _clearTrackedProgress();
    _terminalEventsHandled.clear();
    _subscribe(widget.manager);
  }

  void _subscribe(GeniusPdfGenerationManager manager) {
    _subscription = manager.jobUpdates.listen(_handleJob);
  }

  void _handleJob(GeniusPdfJob job) {
    if (!mounted) return;
    if (job.metadata?['showGenerationToast'] == false) return;

    // Once a job reached a terminal state, late/repeated updates for the same
    // id must not recreate progress or terminal toasts.
    if (_terminalEventsHandled.contains(job.id)) return;

    switch (job.status) {
      case GeniusPdfJobStatus.queued:
        return;
      case GeniusPdfJobStatus.processing:
        _showOrUpdateProgress(job);
        return;
      case GeniusPdfJobStatus.completed:
        _terminalEventsHandled.add(job.id);
        _finishProgress(job.id);
        final result = job.result;
        if (result is GeniusPdfSuccess) {
          _showCompleted(job, result);
        }
        return;
      case GeniusPdfJobStatus.failed:
        _terminalEventsHandled.add(job.id);
        _finishProgress(job.id);
        _showFailed(job);
        return;
      case GeniusPdfJobStatus.cancelled:
        _terminalEventsHandled.add(job.id);
        _finishProgress(job.id);
        _showCancelled(job);
        return;
    }
  }

  void _showOrUpdateProgress(GeniusPdfJob job) {
    final existing = _active[job.id];
    if (existing != null) {
      existing.progress.value = job.progress.clamp(0.0, 1.0).toDouble();
      return;
    }

    final tracked = _GenerationToastState(
      progress: ValueNotifier<double>(job.progress.clamp(0.0, 1.0).toDouble()),
    );
    _active[job.id] = tracked;

    tracked.handle = _showCompactToast(
      tone: SuperToastTone.info,
      title: _text(
        context,
        en: 'Starting generate document',
        ar: 'بدء إنشاء المستند',
      ),
      description: job.fileName,
      leading: _GenerationProgressRing(progress: tracked.progress),
      trailing: _GenerationProgressPercent(progress: tracked.progress),
      onDismiss: () {
        tracked.toastDismissed = true;
        _releaseTracked(job.id, tracked);
      },
    );
  }

  void _finishProgress(String jobId) {
    final tracked = _active[jobId];
    if (tracked == null) return;

    tracked.finished = true;
    tracked.progress.value = 1.0;
    if (tracked.handle?.showing ?? false) {
      tracked.handle?.dismiss();
    }
    _releaseTracked(jobId, tracked);
  }

  void _releaseTracked(String jobId, _GenerationToastState tracked) {
    // If a user closes the progress toast before generation finishes, keep the
    // notifier silently tracked so later progress updates cannot recreate it.
    if (!tracked.finished || !tracked.toastDismissed) return;
    if (!identical(_active[jobId], tracked)) return;

    _active.remove(jobId);
    tracked.progress.dispose();
  }

  void _showCompleted(GeniusPdfJob job, GeniusPdfSuccess result) {
    final path = result.filePath;

    _showCompactToast(
      tone: SuperToastTone.success,
      title: _text(
        context,
        en: 'Document generated',
        ar: 'تم إنشاء المستند',
      ),
      description: result.fileName.isEmpty ? job.fileName : result.fileName,
      leading: const _CompactToneIcon(
        tone: SuperToastTone.success,
        icon: Icons.check_circle_outline_rounded,
      ),
      action: path == null
          ? null
          : _CompactToastAction(
              tooltip: _text(
                context,
                en: 'Open document',
                ar: 'فتح المستند',
              ),
              icon: Icons.open_in_new_rounded,
              onPressed: () => unawaited(_openDocument(result)),
            ),
    );
  }

  void _showFailed(GeniusPdfJob job) {
    _showCompactToast(
      tone: SuperToastTone.danger,
      title: _text(
        context,
        en: 'Document generation failed',
        ar: 'فشل إنشاء المستند',
      ),
      description: job.errorMessage ?? job.fileName,
      leading: const _CompactToneIcon(
        tone: SuperToastTone.danger,
        icon: Icons.error_outline_rounded,
      ),
    );
  }

  void _showCancelled(GeniusPdfJob job) {
    _showCompactToast(
      tone: SuperToastTone.warning,
      title: _text(
        context,
        en: 'Document generation cancelled',
        ar: 'تم إلغاء إنشاء المستند',
      ),
      description: job.fileName,
      leading: const _CompactToneIcon(
        tone: SuperToastTone.warning,
        icon: Icons.warning_amber_rounded,
      ),
    );
  }

  SuperToastHandle _showCompactToast({
    required SuperToastTone tone,
    required String title,
    required String description,
    Widget? leading,
    Widget? trailing,
    Widget? action,
    VoidCallback? onDismiss,
  }) {
    final data = SuperToastData(
      title: title,
      description: description,
      tone: tone,
      position: SuperToastPosition.bottomEnd,
      duration: widget.duration,
      dismissible: true,
      showCloseButton: false,
      pauseOnHover: true,
    );

    return SuperToast.showRaw(
      context,
      data: data,
      alignment: SuperToastAlignment.bottomEnd,
      style: const SuperToastStyle(
        constraints: BoxConstraints(minWidth: 260, maxWidth: 360),
        padding: EdgeInsets.zero,
      ),
      onDismiss: onDismiss,
      builder: (toastContext, handle) => _CompactGenerationToast(
        title: title,
        description: description,
        tone: tone,
        handle: handle,
        leading: leading,
        trailing: trailing,
        action: action,
      ),
    );
  }

  Future<void> _openDocument(GeniusPdfSuccess result) async {
    final path = result.filePath;
    if (path == null) return;

    try {
      await const GeniusPdfService().openFile(path);
    } catch (error) {
      if (!mounted) return;
      _showCompactToast(
        tone: SuperToastTone.danger,
        title: _text(
          context,
          en: 'Unable to open document',
          ar: 'تعذر فتح المستند',
        ),
        description: error.toString(),
        leading: const _CompactToneIcon(
          tone: SuperToastTone.danger,
          icon: Icons.error_outline_rounded,
        ),
      );
    }
  }

  static String _text(
    BuildContext context, {
    required String en,
    required String ar,
  }) {
    return Localizations.localeOf(context).languageCode.toLowerCase() == 'ar'
        ? ar
        : en;
  }

  void _clearTrackedProgress() {
    for (final tracked in _active.values) {
      tracked.handle?.dismiss();
      tracked.progress.dispose();
    }
    _active.clear();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _clearTrackedProgress();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _GenerationToastState {
  _GenerationToastState({required this.progress});

  final ValueNotifier<double> progress;
  SuperToastHandle? handle;
  bool toastDismissed = false;
  bool finished = false;
}

class _CompactGenerationToast extends StatelessWidget {
  const _CompactGenerationToast({
    required this.title,
    required this.description,
    required this.tone,
    required this.handle,
    this.leading,
    this.trailing,
    this.action,
  });

  final String title;
  final String description;
  final SuperToastTone tone;
  final SuperToastHandle handle;
  final Widget? leading;
  final Widget? trailing;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final superTheme = context.superTheme;
    final materialTheme = Theme.of(context);
    final semanticsLabel = description.trim().isEmpty
        ? title
        : '$title. $description';

    return Semantics(
      container: true,
      liveRegion: true,
      label: semanticsLabel,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 260, maxWidth: 360),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: superTheme.surface,
            border: Border.all(color: superTheme.border),
            borderRadius: superTheme.spacing.borderRadiusMd,
            boxShadow: SuperThemeData.popShadow,
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 9, 7, 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (leading != null) ...[
                  SizedBox.square(dimension: 20, child: Center(child: leading)),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: materialTheme.textTheme.labelLarge?.copyWith(
                          color: superTheme.fg1,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (description.trim().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: materialTheme.textTheme.bodySmall?.copyWith(
                            color: superTheme.fg3,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...[
                  const SizedBox(width: 8),
                  trailing!,
                ],
                if (action != null) ...[
                  const SizedBox(width: 4),
                  action!,
                ],
                const SizedBox(width: 2),
                _CompactToastAction(
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                  icon: Icons.close_rounded,
                  onPressed: handle.dismiss,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactToneIcon extends StatelessWidget {
  const _CompactToneIcon({required this.tone, required this.icon});

  final SuperToastTone tone;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 19, color: _toneColor(context, tone));
  }
}

class _GenerationProgressRing extends StatelessWidget {
  const _GenerationProgressRing({required this.progress});

  final ValueListenable<double> progress;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(context, SuperToastTone.info);
    return ValueListenableBuilder<double>(
      valueListenable: progress,
      builder: (context, value, _) {
        final normalized = value.clamp(0.0, 1.0).toDouble();
        return SizedBox.square(
          dimension: 18,
          child: CircularProgressIndicator(
            value: normalized > 0 && normalized < 1 ? normalized : null,
            strokeWidth: 2,
            color: color,
            backgroundColor: color.withValues(alpha: 0.14),
          ),
        );
      },
    );
  }
}

class _GenerationProgressPercent extends StatelessWidget {
  const _GenerationProgressPercent({required this.progress});

  final ValueListenable<double> progress;

  @override
  Widget build(BuildContext context) {
    final superTheme = context.superTheme;
    return ValueListenableBuilder<double>(
      valueListenable: progress,
      builder: (context, value, _) {
        final normalized = value.clamp(0.0, 1.0).toDouble();
        return SizedBox(
          width: 34,
          child: Text(
            '${(normalized * 100).round()}%',
            maxLines: 1,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: superTheme.fg2,
              fontWeight: FontWeight.w600,
              fontFeatures: const <FontFeature>[FontFeature.tabularFigures()],
            ),
          ),
        );
      },
    );
  }
}

class _CompactToastAction extends StatelessWidget {
  const _CompactToastAction({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      icon: Icon(icon),
      iconSize: 18,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 30, height: 30),
      onPressed: onPressed,
    );
  }
}

Color _toneColor(BuildContext context, SuperToastTone tone) {
  final semantic = SuperSemanticColors.of(context);
  return switch (tone) {
    SuperToastTone.neutral => semantic.neutral.solid,
    SuperToastTone.info => semantic.info.solid,
    SuperToastTone.success => semantic.success.solid,
    SuperToastTone.warning => semantic.warning.solid,
    SuperToastTone.danger => semantic.danger.solid,
  };
}
