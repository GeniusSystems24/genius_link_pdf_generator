part of '../pdf_generation_manager.dart';

class GeniusPdfScheduledJob {
  GeniusPdfScheduledJob({
    required this.id,
    required this.builder,
    required this.fileName,
    this.builderFactory,
    required this.scheduledTime,
    this.priority = GeniusPdfJobPriority.normal,
    this.autoOpen = false,
    this.autoShare = false,
    this.autoPrint = false,
    this.onComplete,
    this.onError,
    this.metadata,
    this.repeatInterval,
  }) : createdAt = DateTime.now();

  final String id;
  final GeniusPdfDocumentBuilder builder;
  final GeniusPdfBuilderFactory? builderFactory;
  final String fileName;
  final DateTime scheduledTime;
  final GeniusPdfJobPriority priority;
  final bool autoOpen;
  final bool autoShare;
  final bool autoPrint;
  final void Function(GeniusPdfSuccess result)? onComplete;
  final void Function(GeniusPdfFailure error)? onError;
  final Map<String, dynamic>? metadata;
  final Duration? repeatInterval;
  final DateTime createdAt;

  Timer? _timer;
  bool _isCancelled = false;

  bool get isCancelled => _isCancelled;
  bool get isPending => !_isCancelled && _timer != null;

  Duration get timeUntilExecution {
    final diff = scheduledTime.difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }

  void cancel() {
    _isCancelled = true;
    _timer?.cancel();
    _timer = null;
  }
}

/// Manages scheduled PDF jobs.
class GeniusPdfScheduler {
  GeniusPdfScheduler({
    required this.manager,
  });

  final GeniusPdfGenerationManager manager;
  final Map<String, GeniusPdfScheduledJob> _scheduledJobs = {};
  int _scheduledCounter = 0;

  /// All scheduled jobs.
  List<GeniusPdfScheduledJob> get scheduledJobs => _scheduledJobs.values.toList();

  /// Pending scheduled jobs (not yet executed or cancelled).
  List<GeniusPdfScheduledJob> get pendingJobs =>
      _scheduledJobs.values.where((j) => j.isPending).toList();

  /// Schedules a job for later execution.
  String scheduleJob({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    required DateTime scheduledTime,
    GeniusPdfBuilderFactory? builderFactory,
    GeniusPdfJobPriority priority = GeniusPdfJobPriority.normal,
    bool autoOpen = false,
    bool autoShare = false,
    bool autoPrint = false,
    void Function(GeniusPdfSuccess result)? onComplete,
    void Function(GeniusPdfFailure error)? onError,
    Map<String, dynamic>? metadata,
    Duration? repeatInterval,
  }) {
    _scheduledCounter++;
    final id = 'scheduled_${DateTime.now().millisecondsSinceEpoch}_$_scheduledCounter';

    final job = GeniusPdfScheduledJob(
      id: id,
      builder: builder,
      fileName: fileName,
      builderFactory: builderFactory,
      scheduledTime: scheduledTime,
      priority: priority,
      autoOpen: autoOpen,
      autoShare: autoShare,
      autoPrint: autoPrint,
      onComplete: onComplete,
      onError: onError,
      metadata: metadata,
      repeatInterval: repeatInterval,
    );

    _scheduledJobs[id] = job;
    _scheduleExecution(job);

    GeniusPdfLogger.info('Job scheduled: "$fileName" at $scheduledTime', tag: 'Scheduler', data: {'jobId': id});
    return id;
  }

  /// Schedules a job to run after a delay.
  String scheduleAfter({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    required Duration delay,
    GeniusPdfBuilderFactory? builderFactory,
    GeniusPdfJobPriority priority = GeniusPdfJobPriority.normal,
    bool autoOpen = false,
    bool autoShare = false,
    bool autoPrint = false,
    void Function(GeniusPdfSuccess result)? onComplete,
    void Function(GeniusPdfFailure error)? onError,
  }) {
    return scheduleJob(
      builder: builder,
      fileName: fileName,
      builderFactory: builderFactory,
      scheduledTime: DateTime.now().add(delay),
      priority: priority,
      autoOpen: autoOpen,
      autoShare: autoShare,
      autoPrint: autoPrint,
      onComplete: onComplete,
      onError: onError,
    );
  }

  void _scheduleExecution(GeniusPdfScheduledJob job) {
    final delay = job.timeUntilExecution;

    job._timer = Timer(delay, () async {
      if (job.isCancelled) return;

      await manager.addJob(
        builder: job.builder,
        fileName: job.fileName,
        builderFactory: job.builderFactory,
        priority: job.priority,
        autoOpen: job.autoOpen,
        autoShare: job.autoShare,
        autoPrint: job.autoPrint,
        onComplete: job.onComplete,
        onError: job.onError,
        metadata: job.metadata,
      );

      // Repeating jobs require a factory because the current builder is
      // disposed after generation and cannot be reused safely.
      if (job.repeatInterval != null && !job.isCancelled) {
        final factory = job.builderFactory;
        if (factory == null) {
          GeniusPdfLogger.error(
            'Repeating scheduled jobs require builderFactory.',
            tag: 'Scheduler',
            data: {'jobId': job.id},
          );
        } else {
          final nextTime = DateTime.now().add(job.repeatInterval!);
          scheduleJob(
            builder: factory(),
            builderFactory: factory,
            fileName: '${job.fileName}_${DateTime.now().millisecondsSinceEpoch}',
            scheduledTime: nextTime,
            priority: job.priority,
            autoOpen: job.autoOpen,
            autoShare: job.autoShare,
            autoPrint: job.autoPrint,
            onComplete: job.onComplete,
            onError: job.onError,
            metadata: job.metadata,
            repeatInterval: job.repeatInterval,
          );
        }
      }

      _scheduledJobs.remove(job.id);
    });
  }

  /// Cancels a scheduled job.
  bool cancelScheduledJob(String id) {
    final job = _scheduledJobs[id];
    if (job == null) return false;

    job.cancel();
    _scheduledJobs.remove(id);
    return true;
  }

  /// Cancels all scheduled jobs.
  int cancelAllScheduled() {
    int count = 0;
    for (final job in _scheduledJobs.values) {
      job.cancel();
      count++;
    }
    _scheduledJobs.clear();
    return count;
  }

  /// Gets a scheduled job by ID.
  GeniusPdfScheduledJob? getScheduledJob(String id) => _scheduledJobs[id];

  /// Disposes the scheduler.
  void dispose() {
    cancelAllScheduled();
  }
}

// ============================================================================
// Job Statistics and Metrics
// ============================================================================

/// Statistics about PDF generation jobs.
