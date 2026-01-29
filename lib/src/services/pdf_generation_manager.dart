import 'dart:async';
import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import '../builders/pdf_document_builder.dart';
import '../models/pdf_result.dart';
import '../core/pdf_logger.dart';

/// Status of a PDF generation job.
enum GeniusPdfJobStatus {
  /// Job is waiting in queue.
  queued,

  /// Job is currently being processed.
  processing,

  /// Job completed successfully.
  completed,

  /// Job failed with an error.
  failed,

  /// Job was cancelled.
  cancelled,
}

/// Priority levels for PDF generation jobs.
enum GeniusPdfJobPriority {
  /// Low priority - processed last.
  low,

  /// Normal priority - default.
  normal,

  /// High priority - processed first.
  high,

  /// Urgent priority - immediate processing.
  urgent,
}

/// Represents a PDF generation job.
class GeniusPdfJob {
  GeniusPdfJob({
    required this.id,
    required this.builder,
    required this.fileName,
    this.priority = GeniusPdfJobPriority.normal,
    this.runInBackground = true,
    this.autoOpen = false,
    this.autoShare = false,
    this.autoPrint = false,
    this.onStart,
    this.onProgress,
    this.onComplete,
    this.onError,
    this.metadata,
  })  : status = GeniusPdfJobStatus.queued,
        isPaused = false,
        cancelRequested = false,
        createdAt = DateTime.now(),
        progress = 0;

  /// Unique identifier for this job.
  final String id;

  /// The document builder to generate.
  final GeniusPdfDocumentBuilder builder;

  /// Output file name (without extension).
  final String fileName;

  /// Job priority level.
  final GeniusPdfJobPriority priority;

  /// Whether to run in a background isolate.
  final bool runInBackground;

  /// Automatically open the PDF after generation.
  final bool autoOpen;

  /// Automatically share the PDF after generation.
  final bool autoShare;

  /// Automatically print the PDF after generation.
  final bool autoPrint;

  /// Called when the job starts processing.
  final VoidCallback? onStart;

  /// Called with progress updates (0.0 - 1.0).
  final void Function(double progress)? onProgress;

  /// Called when the job completes successfully.
  final void Function(GeniusPdfSuccess result)? onComplete;

  /// Called when the job fails.
  final void Function(GeniusPdfFailure error)? onError;

  /// Optional metadata for the job.
  final Map<String, dynamic>? metadata;

  /// Current status of the job.
  GeniusPdfJobStatus status;

  /// Whether this job is paused in the queue.
  bool isPaused;

  /// Whether a cancel was requested while processing.
  bool cancelRequested;

  /// When the job was created.
  final DateTime createdAt;

  /// When the job started processing.
  DateTime? startedAt;

  /// When the job completed.
  DateTime? completedAt;

  /// Current progress (0.0 - 1.0).
  double progress;

  /// Result of the job (if completed).
  GeniusPdfResult? result;

  /// Error message (if failed).
  String? errorMessage;

  /// Duration of the job processing.
  Duration? get duration {
    if (startedAt == null) return null;
    final end = completedAt ?? DateTime.now();
    return end.difference(startedAt!);
  }

  /// Whether the job is still active (queued or processing).
  bool get isActive =>
      status == GeniusPdfJobStatus.queued || status == GeniusPdfJobStatus.processing;

  /// Whether the job has finished (completed, failed, or cancelled).
  bool get isFinished =>
      status == GeniusPdfJobStatus.completed ||
      status == GeniusPdfJobStatus.failed ||
      status == GeniusPdfJobStatus.cancelled;

  @override
  String toString() => 'PdfJob($id, status: $status, fileName: $fileName)';
}

/// Configuration for the PDF Generation Manager.
class GeniusPdfGenerationManagerConfig {
  const GeniusPdfGenerationManagerConfig({
    this.maxConcurrentJobs = 2,
    this.defaultRunInBackground = true,
    this.retryFailedJobs = false,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.cleanupCompletedJobs = true,
    this.completedJobRetentionDuration = const Duration(minutes: 30),
  });

  /// Maximum number of jobs that can run simultaneously.
  final int maxConcurrentJobs;

  /// Default setting for running jobs in background.
  final bool defaultRunInBackground;

  /// Whether to automatically retry failed jobs.
  final bool retryFailedJobs;

  /// Maximum number of retry attempts.
  final int maxRetries;

  /// Delay between retry attempts.
  final Duration retryDelay;

  /// Whether to automatically clean up completed jobs.
  final bool cleanupCompletedJobs;

  /// How long to keep completed jobs before cleanup.
  final Duration completedJobRetentionDuration;
}

/// Manages PDF generation jobs with queue support and background processing.
///
/// [GeniusPdfGenerationManager] provides:
/// - Job queue management with priorities
/// - Concurrent job processing
/// - Background/foreground execution
/// - Progress tracking and callbacks
/// - Job cancellation and retry
/// - Automatic cleanup of completed jobs
///
/// ## Example
/// ```dart
/// final manager = PdfGenerationManager();
///
/// // Add a job to the queue
/// final jobId = await manager.addJob(
///   builder: myDocumentBuilder,
///   fileName: 'report',
///   priority: PdfJobPriority.high,
///   onComplete: (result) => print('Done: ${result.filePath}'),
/// );
///
/// // Check job status
/// final job = manager.getJob(jobId);
/// print('Status: ${job?.status}');
///
/// // Cancel a job
/// manager.cancelJob(jobId);
///
/// // Get all active jobs
/// final activeJobs = manager.activeJobs;
/// ```
class GeniusPdfGenerationManager {
  /// Creates a new [GeniusPdfGenerationManager] with optional configuration.
  GeniusPdfGenerationManager({
    GeniusPdfGenerationManagerConfig? config,
  }) : _config = config ?? const GeniusPdfGenerationManagerConfig();

  final GeniusPdfGenerationManagerConfig _config;

  /// Queue of pending jobs.
  final Queue<GeniusPdfJob> _queue = Queue();

  /// Map of all jobs by ID.
  final Map<String, GeniusPdfJob> _jobs = {};

  /// Currently processing jobs.
  final Set<String> _processing = {};

  /// Stream controller for job updates.
  final _jobUpdatesController = StreamController<GeniusPdfJob>.broadcast();

  /// Stream controller for queue updates.
  final _queueUpdatesController = StreamController<List<GeniusPdfJob>>.broadcast();

  /// Counter for generating unique job IDs.
  int _jobCounter = 0;

  /// Timer for cleanup of completed jobs.
  Timer? _cleanupTimer;

  /// Whether the manager is currently processing jobs.
  bool _isProcessing = false;

  // ============================================================
  // GETTERS
  // ============================================================

  /// Stream of job updates.
  Stream<GeniusPdfJob> get jobUpdates => _jobUpdatesController.stream;

  /// Stream of queue updates.
  Stream<List<GeniusPdfJob>> get queueUpdates => _queueUpdatesController.stream;

  /// All jobs in the manager.
  List<GeniusPdfJob> get allJobs => _jobs.values.toList();

  /// Jobs currently in the queue (not yet started).
  List<GeniusPdfJob> get queuedJobs =>
      _jobs.values
          .where(
            (j) => j.status == GeniusPdfJobStatus.queued && j.isPaused != true,
          )
          .toList();

  /// Jobs currently paused in the queue.
  List<GeniusPdfJob> get pausedJobs =>
      _jobs.values.where((j) => j.isPaused == true).toList();

  /// Jobs in the queue in their current processing order.
  List<GeniusPdfJob> get queuedJobsInOrder => List.unmodifiable(_queue);

  /// Jobs currently being processed.
  List<GeniusPdfJob> get processingJobs =>
      _jobs.values.where((j) => j.status == GeniusPdfJobStatus.processing).toList();

  /// Jobs that are active (queued or processing).
  List<GeniusPdfJob> get activeJobs => _jobs.values.where((j) => j.isActive).toList();

  /// Jobs that have completed successfully.
  List<GeniusPdfJob> get completedJobs =>
      _jobs.values.where((j) => j.status == GeniusPdfJobStatus.completed).toList();

  /// Jobs that have failed.
  List<GeniusPdfJob> get failedJobs =>
      _jobs.values.where((j) => j.status == GeniusPdfJobStatus.failed).toList();

  /// Number of jobs in the queue.
  int get queueLength => _queue.length;

  /// Number of jobs currently processing.
  int get processingCount => _processing.length;

  /// Whether there are any active jobs.
  bool get hasActiveJobs => activeJobs.isNotEmpty;

  /// Configuration for this manager.
  GeniusPdfGenerationManagerConfig get config => _config;

  // ============================================================
  // JOB MANAGEMENT
  // ============================================================

  /// Adds a new PDF generation job to the queue.
  ///
  /// Returns the unique job ID.
  Future<String> addJob({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    GeniusPdfJobPriority priority = GeniusPdfJobPriority.normal,
    bool? runInBackground,
    bool autoOpen = false,
    bool autoShare = false,
    bool autoPrint = false,
    VoidCallback? onStart,
    void Function(double progress)? onProgress,
    void Function(GeniusPdfSuccess result)? onComplete,
    void Function(GeniusPdfFailure error)? onError,
    Map<String, dynamic>? metadata,
  }) async {
    final id = _generateJobId();

    final job = GeniusPdfJob(
      id: id,
      builder: builder,
      fileName: fileName,
      priority: priority,
      runInBackground: runInBackground ?? _config.defaultRunInBackground,
      autoOpen: autoOpen,
      autoShare: autoShare,
      autoPrint: autoPrint,
      onStart: onStart,
      onProgress: onProgress,
      onComplete: onComplete,
      onError: onError,
      metadata: metadata,
    );

    _jobs[id] = job;
    GeniusPdfLogger.info('Job added: "$fileName" (priority: ${priority.name})', tag: 'JobManager', data: {'jobId': id});
    _addToQueue(job);

    _notifyQueueUpdate();
    _processQueue();

    return id;
  }

  /// Adds a job and waits for it to complete.
  ///
  /// Returns the result of the job.
  Future<GeniusPdfResult> addJobAndWait({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    GeniusPdfJobPriority priority = GeniusPdfJobPriority.normal,
    bool? runInBackground,
    bool autoOpen = false,
    bool autoShare = false,
    bool autoPrint = false,
    void Function(double progress)? onProgress,
    Map<String, dynamic>? metadata,
  }) async {
    final completer = Completer<GeniusPdfResult>();

    await addJob(
      builder: builder,
      fileName: fileName,
      priority: priority,
      runInBackground: runInBackground,
      autoOpen: autoOpen,
      autoShare: autoShare,
      autoPrint: autoPrint,
      onProgress: onProgress,
      onComplete: (result) => completer.complete(result),
      onError: (error) => completer.complete(error),
      metadata: metadata,
    );

    return completer.future;
  }

  /// Gets a job by its ID.
  GeniusPdfJob? getJob(String id) => _jobs[id];

  /// Cancels a job by its ID.
  ///
  /// Returns true if the job was cancelled, false if it couldn't be cancelled.
  bool cancelJob(String id) {
    final job = _jobs[id];
    if (job == null) return false;

    if (job.status == GeniusPdfJobStatus.queued) {
      job.isPaused = false;
      _queue.removeWhere((j) => j.id == id);
      _markCancelled(job);
      GeniusPdfLogger.info('Job cancelled (queued): "${job.fileName}"', tag: 'JobManager', data: {'jobId': id});
      return true;
    }

    if (job.status == GeniusPdfJobStatus.processing) {
      job.cancelRequested = true;
      GeniusPdfLogger.info('Job cancel requested (processing): "${job.fileName}"', tag: 'JobManager', data: {'jobId': id});
      _notifyJobUpdate(job);
      return true;
    }

    return false;
  }

  /// Pauses a queued job by its ID.
  ///
  /// Returns true if paused.
  bool pauseJob(String id) {
    final job = _jobs[id];
    if (job == null) return false;
    if (job.status != GeniusPdfJobStatus.queued || job.isPaused == true) {
      return false;
    }

    job.isPaused = true;
    GeniusPdfLogger.info('Job paused: "${job.fileName}"', tag: 'JobManager', data: {'jobId': id});
    _queue.removeWhere((j) => j.id == id);
    _notifyJobUpdate(job);
    _notifyQueueUpdate();
    return true;
  }

  /// Resumes a paused job by its ID.
  ///
  /// Returns true if resumed.
  bool resumeJob(String id) {
    final job = _jobs[id];
    if (job == null || job.isPaused != true) return false;

    job.isPaused = false;
    GeniusPdfLogger.info('Job resumed: "${job.fileName}"', tag: 'JobManager', data: {'jobId': id});
    _addToQueue(job);
    _notifyJobUpdate(job);
    _notifyQueueUpdate();
    _processQueue();
    return true;
  }

  /// Moves a queued job up or down in the queue.
  ///
  /// Returns true if the job was moved.
  bool moveQueuedJob(String id, int offset) {
    if (offset == 0) return false;
    final list = _queue.toList();
    final index = list.indexWhere((j) => j.id == id);
    if (index == -1) return false;

    final nextIndex = (index + offset).clamp(0, list.length - 1);
    if (nextIndex == index) return false;

    final job = list.removeAt(index);
    list.insert(nextIndex, job);
    _queue
      ..clear()
      ..addAll(list);
    _notifyQueueUpdate();
    return true;
  }

  /// Reorders queued jobs based on the given job IDs.
  ///
  /// Jobs not included in [orderedIds] keep their relative order.
  bool reorderQueue(List<String> orderedIds) {
    if (orderedIds.isEmpty || _queue.isEmpty) return false;

    final current = _queue.toList();
    final remaining = <GeniusPdfJob>[];
    final ordered = <GeniusPdfJob>[];

    for (final job in current) {
      if (orderedIds.contains(job.id)) {
        ordered.add(job);
      } else {
        remaining.add(job);
      }
    }

    if (ordered.isEmpty) return false;

    ordered.sort(
      (a, b) => orderedIds.indexOf(a.id).compareTo(orderedIds.indexOf(b.id)),
    );

    _queue
      ..clear()
      ..addAll([...ordered, ...remaining]);
    _notifyQueueUpdate();
    return true;
  }

  /// Cancels all queued jobs.
  ///
  /// Returns the number of jobs cancelled.
  int cancelAllQueued() {
    int count = 0;
    final queuedIds = queuedJobs.map((j) => j.id).toList();

    for (final id in queuedIds) {
      if (cancelJob(id)) count++;
    }

    return count;
  }

  /// Retries a failed job.
  ///
  /// Returns the new job ID, or null if the job couldn't be retried.
  Future<String?> retryJob(String id) async {
    final job = _jobs[id];
    if (job == null || job.status != GeniusPdfJobStatus.failed) return null;

    return addJob(
      builder: job.builder,
      fileName: job.fileName,
      priority: job.priority,
      runInBackground: job.runInBackground,
      autoOpen: job.autoOpen,
      autoShare: job.autoShare,
      autoPrint: job.autoPrint,
      onStart: job.onStart,
      onProgress: job.onProgress,
      onComplete: job.onComplete,
      onError: job.onError,
      metadata: job.metadata,
    );
  }

  /// Removes a completed or failed job from the manager.
  bool removeJob(String id) {
    final job = _jobs[id];
    if (job == null || job.isActive) return false;

    _jobs.remove(id);
    _notifyQueueUpdate();
    return true;
  }

  /// Clears all completed and failed jobs.
  int clearFinishedJobs() {
    final toRemove = _jobs.values.where((j) => j.isFinished).map((j) => j.id).toList();

    for (final id in toRemove) {
      _jobs.remove(id);
    }

    _notifyQueueUpdate();
    return toRemove.length;
  }

  // ============================================================
  // BATCH OPERATIONS
  // ============================================================

  /// Adds multiple jobs at once.
  ///
  /// Returns a list of job IDs.
  Future<List<String>> addBatch({
    required List<GeniusPdfDocumentBuilder> builders,
    required String Function(int index) fileNameGenerator,
    GeniusPdfJobPriority priority = GeniusPdfJobPriority.normal,
    bool? runInBackground,
    void Function(int index, GeniusPdfSuccess result)? onJobComplete,
    void Function(int index, GeniusPdfFailure error)? onJobError,
    void Function(List<GeniusPdfResult> results)? onBatchComplete,
  }) async {
    final ids = <String>[];
    final results = <GeniusPdfResult>[];
    int completedCount = 0;

    for (int i = 0; i < builders.length; i++) {
      final index = i;
      final id = await addJob(
        builder: builders[i],
        fileName: fileNameGenerator(i),
        priority: priority,
        runInBackground: runInBackground,
        onComplete: (result) {
          results.add(result);
          completedCount++;
          onJobComplete?.call(index, result);

          if (completedCount == builders.length) {
            onBatchComplete?.call(results);
          }
        },
        onError: (error) {
          results.add(error);
          completedCount++;
          onJobError?.call(index, error);

          if (completedCount == builders.length) {
            onBatchComplete?.call(results);
          }
        },
      );
      ids.add(id);
    }

    return ids;
  }

  // ============================================================
  // PRIVATE METHODS
  // ============================================================

  String _generateJobId() {
    _jobCounter++;
    return 'pdf_job_${DateTime.now().millisecondsSinceEpoch}_$_jobCounter';
  }

  void _addToQueue(GeniusPdfJob job) {
    // Insert based on priority
    if (job.priority == GeniusPdfJobPriority.urgent) {
      _queue.addFirst(job);
    } else if (job.priority == GeniusPdfJobPriority.high) {
      // Find first non-urgent job and insert before it
      final urgentCount =
          _queue.where((j) => j.priority == GeniusPdfJobPriority.urgent).length;
      final list = _queue.toList();
      list.insert(urgentCount, job);
      _queue.clear();
      _queue.addAll(list);
    } else if (job.priority == GeniusPdfJobPriority.normal) {
      // Insert before low priority jobs
      final lowPriorityStart =
          _queue.toList().indexWhere((j) => j.priority == GeniusPdfJobPriority.low);
      if (lowPriorityStart == -1) {
        _queue.add(job);
      } else {
        final list = _queue.toList();
        list.insert(lowPriorityStart, job);
        _queue.clear();
        _queue.addAll(list);
      }
    } else {
      _queue.add(job);
    }
  }

  void _markCancelled(GeniusPdfJob job) {
    if (job.status == GeniusPdfJobStatus.cancelled) {
      job.cancelRequested = false;
      _notifyJobUpdate(job);
      _notifyQueueUpdate();
      return;
    }

    job.status = GeniusPdfJobStatus.cancelled;
    job.completedAt = DateTime.now();
    job.cancelRequested = false;
    job.errorMessage = 'Cancelled';
    job.result = GeniusPdfFailure(
      error: StateError('Cancelled'),
      message: 'Cancelled',
    );
    _notifyJobUpdate(job);
    _notifyQueueUpdate();
  }

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_queue.isNotEmpty &&
        _processing.length < _config.maxConcurrentJobs) {
      final job = _queue.removeFirst();
      _processing.add(job.id);
      _processJob(job);
    }

    _isProcessing = false;
  }

  Future<void> _processJob(GeniusPdfJob job) async {
    job.status = GeniusPdfJobStatus.processing;
    GeniusPdfLogger.info('Processing job: "${job.fileName}"', tag: 'JobManager', data: {'jobId': job.id});
    GeniusPdfLogger.startTimer('job_${job.id}');
    job.startedAt = DateTime.now();
    job.onStart?.call();
    _notifyJobUpdate(job);

    try {
      List<int> bytes;

      // Update progress
      job.progress = 0.1;
      job.onProgress?.call(job.progress);
      _notifyJobUpdate(job);

      if (job.runInBackground) {
        bytes = await compute(_generatePdfInIsolate, job.builder);
      } else {
        bytes = job.builder.generate();
      }

      if (job.cancelRequested == true) {
        _markCancelled(job);
        return;
      }

      job.progress = 0.5;
      job.onProgress?.call(job.progress);
      _notifyJobUpdate(job);

      // Save to file
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/${job.fileName}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      if (job.cancelRequested == true) {
        try {
          if (await file.exists()) {
            await file.delete();
          }
        } catch (_) {}
        _markCancelled(job);
        return;
      }

      job.progress = 0.8;
      job.onProgress?.call(job.progress);
      _notifyJobUpdate(job);

      final success = GeniusPdfSuccess(
        bytes: Uint8List.fromList(bytes),
        fileName: job.fileName,
        filePath: filePath,
      );

      // Auto actions
      if (job.autoOpen) {
        await OpenFile.open(filePath);
      }

      if (job.autoShare) {
        await Printing.sharePdf(
          bytes: success.bytes,
          filename: '${job.fileName}.pdf',
        );
      }

      if (job.autoPrint) {
        await Printing.layoutPdf(
          onLayout: (_) => success.bytes,
          name: job.fileName,
        );
      }

      if (job.cancelRequested == true) {
        _markCancelled(job);
        return;
      }

      job.progress = 1.0;
      job.onProgress?.call(job.progress);
      job.status = GeniusPdfJobStatus.completed;
      GeniusPdfLogger.stopTimer('job_${job.id}', tag: 'JobManager');
      GeniusPdfLogger.info('Job completed: "${job.fileName}"', tag: 'JobManager', data: {'jobId': job.id});
      job.completedAt = DateTime.now();
      job.result = success;
      job.onComplete?.call(success);
    } catch (e, st) {
      final failure = GeniusPdfFailure.fromException(e, st);
      job.status = GeniusPdfJobStatus.failed;
      GeniusPdfLogger.stopTimer('job_${job.id}', tag: 'JobManager');
      GeniusPdfLogger.error('Job failed: "${job.fileName}"', tag: 'JobManager', error: e, data: {'jobId': job.id});
      job.completedAt = DateTime.now();
      job.result = failure;
      job.errorMessage = failure.message;
      job.onError?.call(failure);
    } finally {
      job.builder.dispose();
      _processing.remove(job.id);
      _notifyJobUpdate(job);
      _notifyQueueUpdate();

      // Start cleanup timer if needed
      if (_config.cleanupCompletedJobs) {
        _scheduleCleanup();
      }

      // Process next jobs
      _processQueue();
    }
  }

  void _notifyJobUpdate(GeniusPdfJob job) {
    if (!_jobUpdatesController.isClosed) {
      _jobUpdatesController.add(job);
    }
  }

  void _notifyQueueUpdate() {
    if (!_queueUpdatesController.isClosed) {
      _queueUpdatesController.add(allJobs);
    }
  }

  void _scheduleCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer(_config.completedJobRetentionDuration, () {
      final now = DateTime.now();
      final toRemove = _jobs.values
          .where((j) =>
              j.isFinished &&
              j.completedAt != null &&
              now.difference(j.completedAt!) >=
                  _config.completedJobRetentionDuration)
          .map((j) => j.id)
          .toList();

      for (final id in toRemove) {
        _jobs.remove(id);
      }

      if (toRemove.isNotEmpty) {
        _notifyQueueUpdate();
      }
    });
  }

  // ============================================================
  // LIFECYCLE
  // ============================================================

  /// Disposes of the manager and cancels all pending jobs.
  void dispose() {
    cancelAllQueued();
    _cleanupTimer?.cancel();
    _jobUpdatesController.close();
    _queueUpdatesController.close();
  }
}

/// Helper function for isolate computation.
List<int> _generatePdfInIsolate(GeniusPdfDocumentBuilder builder) {
  return builder.generate();
}

/// Extension for easy access to singleton manager.
extension PdfGenerationManagerExtension on GeniusPdfGenerationManager {
  /// Creates a quick job and returns the result.
  ///
  /// This is a convenience method for simple use cases.
  static Future<GeniusPdfResult> quickGenerate({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    bool openAfterGenerate = false,
    bool shareAfterGenerate = false,
  }) async {
    final manager = GeniusPdfGenerationManager();

    try {
      return await manager.addJobAndWait(
        builder: builder,
        fileName: fileName,
        autoOpen: openAfterGenerate,
        autoShare: shareAfterGenerate,
      );
    } finally {
      manager.dispose();
    }
  }
}

// ============================================================================
// Job Scheduling Support
// ============================================================================

/// A scheduled PDF job that will be processed at a specific time.
class GeniusPdfScheduledJob {
  GeniusPdfScheduledJob({
    required this.id,
    required this.builder,
    required this.fileName,
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
        priority: job.priority,
        autoOpen: job.autoOpen,
        autoShare: job.autoShare,
        autoPrint: job.autoPrint,
        onComplete: job.onComplete,
        onError: job.onError,
        metadata: job.metadata,
      );

      // Handle repeating jobs
      if (job.repeatInterval != null && !job.isCancelled) {
        final nextTime = DateTime.now().add(job.repeatInterval!);
        scheduleJob(
          builder: job.builder,
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
class GeniusPdfJobStatistics {
  const GeniusPdfJobStatistics({
    required this.totalJobs,
    required this.completedJobs,
    required this.failedJobs,
    required this.cancelledJobs,
    required this.averageDuration,
    required this.totalBytesGenerated,
    required this.fastestJob,
    required this.slowestJob,
    required this.successRate,
  });

  final int totalJobs;
  final int completedJobs;
  final int failedJobs;
  final int cancelledJobs;
  final Duration averageDuration;
  final int totalBytesGenerated;
  final Duration? fastestJob;
  final Duration? slowestJob;
  final double successRate;

  String get formattedAverageDuration {
    final seconds = averageDuration.inSeconds;
    if (seconds < 60) return '${seconds}s';
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes}m ${remainingSeconds}s';
  }

  String get formattedTotalBytes {
    if (totalBytesGenerated < 1024) return '$totalBytesGenerated B';
    if (totalBytesGenerated < 1024 * 1024) {
      return '${(totalBytesGenerated / 1024).toStringAsFixed(1)} KB';
    }
    return '${(totalBytesGenerated / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Extension for job statistics.
extension GeniusPdfStatisticsExtension on GeniusPdfGenerationManager {
  /// Calculates statistics for all jobs.
  GeniusPdfJobStatistics getStatistics() {
    final jobs = allJobs;
    final completed = jobs.where((j) => j.status == GeniusPdfJobStatus.completed).toList();
    final failed = jobs.where((j) => j.status == GeniusPdfJobStatus.failed).length;
    final cancelled = jobs.where((j) => j.status == GeniusPdfJobStatus.cancelled).length;

    // Calculate durations
    final durations = completed
        .where((j) => j.duration != null)
        .map((j) => j.duration!)
        .toList();

    Duration avgDuration = Duration.zero;
    Duration? fastest;
    Duration? slowest;

    if (durations.isNotEmpty) {
      final totalMs = durations.fold<int>(0, (sum, d) => sum + d.inMilliseconds);
      avgDuration = Duration(milliseconds: totalMs ~/ durations.length);
      durations.sort((a, b) => a.compareTo(b));
      fastest = durations.first;
      slowest = durations.last;
    }

    // Calculate total bytes
    int totalBytes = 0;
    for (final job in completed) {
      if (job.result is GeniusPdfSuccess) {
        totalBytes += (job.result as GeniusPdfSuccess).bytes.length;
      }
    }

    final successRate = jobs.isEmpty ? 0.0 : completed.length / jobs.length;

    return GeniusPdfJobStatistics(
      totalJobs: jobs.length,
      completedJobs: completed.length,
      failedJobs: failed,
      cancelledJobs: cancelled,
      averageDuration: avgDuration,
      totalBytesGenerated: totalBytes,
      fastestJob: fastest,
      slowestJob: slowest,
      successRate: successRate,
    );
  }

  /// Gets jobs grouped by status.
  Map<GeniusPdfJobStatus, List<GeniusPdfJob>> getJobsByStatus() {
    final result = <GeniusPdfJobStatus, List<GeniusPdfJob>>{};
    for (final status in GeniusPdfJobStatus.values) {
      result[status] = allJobs.where((j) => j.status == status).toList();
    }
    return result;
  }

  /// Gets jobs grouped by priority.
  Map<GeniusPdfJobPriority, List<GeniusPdfJob>> getJobsByPriority() {
    final result = <GeniusPdfJobPriority, List<GeniusPdfJob>>{};
    for (final priority in GeniusPdfJobPriority.values) {
      result[priority] = allJobs.where((j) => j.priority == priority).toList();
    }
    return result;
  }
}

// ============================================================================
// Job Dependencies / Chains
// ============================================================================

/// A chain of PDF jobs that execute in sequence.
class GeniusPdfJobChain {
  GeniusPdfJobChain({
    required this.id,
    required this.jobs,
    this.stopOnError = true,
    this.onChainComplete,
    this.onChainError,
  });

  final String id;
  final List<GeniusPdfJob> jobs;
  final bool stopOnError;
  final void Function(List<GeniusPdfResult> results)? onChainComplete;
  final void Function(int failedIndex, GeniusPdfFailure error)? onChainError;

  final List<GeniusPdfResult> _results = [];
  int _currentIndex = 0;
  bool _isRunning = false;
  bool _isCancelled = false;

  bool get isRunning => _isRunning;
  bool get isCancelled => _isCancelled;
  bool get isComplete => _currentIndex >= jobs.length;
  int get progress => _currentIndex;
  int get totalJobs => jobs.length;
  double get progressPercent => jobs.isEmpty ? 0 : _currentIndex / jobs.length;

  void cancel() {
    _isCancelled = true;
  }
}

/// Extension for job chains.
extension GeniusPdfJobChainExtension on GeniusPdfGenerationManager {
  /// Creates and executes a chain of jobs.
  Future<List<GeniusPdfResult>> executeChain({
    required List<({GeniusPdfDocumentBuilder builder, String fileName})> jobs,
    GeniusPdfJobPriority priority = GeniusPdfJobPriority.normal,
    bool stopOnError = true,
    void Function(int index, int total)? onProgress,
    void Function(int index, GeniusPdfResult result)? onJobComplete,
  }) async {
    final results = <GeniusPdfResult>[];

    for (int i = 0; i < jobs.length; i++) {
      onProgress?.call(i, jobs.length);

      final job = jobs[i];
      final result = await addJobAndWait(
        builder: job.builder,
        fileName: job.fileName,
        priority: priority,
      );

      results.add(result);
      onJobComplete?.call(i, result);

      if (stopOnError && result is GeniusPdfFailure) {
        break;
      }
    }

    onProgress?.call(jobs.length, jobs.length);
    return results;
  }
}
