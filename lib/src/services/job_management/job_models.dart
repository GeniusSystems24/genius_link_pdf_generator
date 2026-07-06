part of '../pdf_generation_manager.dart';

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

/// Creates a fresh builder for retries or repeated scheduled jobs.
typedef GeniusPdfBuilderFactory = GeniusPdfDocumentBuilder Function();

/// Represents a PDF generation job.
class GeniusPdfJob {
  GeniusPdfJob({
    required this.id,
    required GeniusPdfDocumentBuilder builder,
    required this.fileName,
    this.builderFactory,
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
  })  : _builder = builder,
        status = GeniusPdfJobStatus.queued,
        isPaused = false,
        cancelRequested = false,
        createdAt = DateTime.now(),
        progress = 0,
        retryCount = 0;

  /// Unique identifier for this job.
  final String id;

  /// The current document builder to generate.
  GeniusPdfDocumentBuilder _builder;
  GeniusPdfDocumentBuilder get builder => _builder;

  /// Optional factory used to create a fresh builder for retries.
  final GeniusPdfBuilderFactory? builderFactory;

  /// Number of retries already attempted.
  int retryCount;

  void replaceBuilderForRetry() {
    final factory = builderFactory;
    if (factory == null) {
      throw StateError('A builderFactory is required to retry this job.');
    }
    _builder = factory();
  }

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
      status == GeniusPdfJobStatus.queued ||
      status == GeniusPdfJobStatus.processing;

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
  GeniusPdfGenerationManagerConfig({
    this.maxConcurrentJobs = 2,
    this.defaultRunInBackground = true,
    this.retryFailedJobs = false,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
    this.cleanupCompletedJobs = true,
    this.completedJobRetentionDuration = const Duration(minutes: 30),
  })  : assert(maxConcurrentJobs > 0),
        assert(maxRetries >= 0),
        assert(!retryDelay.isNegative),
        assert(!completedJobRetentionDuration.isNegative);

  /// Maximum number of jobs that can run simultaneously.
  final int maxConcurrentJobs;

  /// Default setting for running jobs in background.
  final bool defaultRunInBackground;

  /// Whether to automatically retry failed jobs.
  ///
  /// Retries require a [GeniusPdfBuilderFactory] because builders are disposed
  /// after each generation attempt and cannot be reused safely.
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
/// final manager = GeniusPdfGenerationManager();
///
/// // Add a job to the queue
/// final jobId = await manager.addJob(
///   builder: myDocumentBuilder,
///   fileName: 'report',
///   priority: GeniusPdfJobPriority.high,
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
