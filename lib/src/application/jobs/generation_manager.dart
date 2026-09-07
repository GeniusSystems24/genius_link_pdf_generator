part of '../generation/pdf_generation_manager.dart';

class GeniusPdfGenerationManager {
  /// Creates a new [GeniusPdfGenerationManager] with optional configuration.
  GeniusPdfGenerationManager({
    GeniusPdfGenerationManagerConfig? config,
    GeniusPdfService? pdfService,
  })  : _config = config ??  GeniusPdfGenerationManagerConfig(),
        _pdfService = pdfService;

  final GeniusPdfGenerationManagerConfig _config;
  final GeniusPdfService? _pdfService;

  GeniusPdfService get _service => _pdfService ?? const GeniusPdfService();

  /// Queue of pending jobs.
  final _GeniusPdfPriorityQueue _queue = _GeniusPdfPriorityQueue();

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
    GeniusPdfBuilderFactory? builderFactory,
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
      builderFactory: builderFactory,
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
    _queue.addByPriority(job);

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
    GeniusPdfBuilderFactory? builderFactory,
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
      builderFactory: builderFactory,
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
      _queue.removeById(id);
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
    _queue.removeById(id);
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
    _queue.addByPriority(job);
    _notifyJobUpdate(job);
    _notifyQueueUpdate();
    _processQueue();
    return true;
  }

  /// Moves a queued job up or down in the queue.
  ///
  /// Returns true if the job was moved.
  bool moveQueuedJob(String id, int offset) {
    final moved = _queue.move(id, offset);
    if (moved) _notifyQueueUpdate();
    return moved;
  }

  /// Reorders queued jobs based on the given job IDs.
  ///
  /// Jobs not included in [orderedIds] keep their relative order.
  bool reorderQueue(List<String> orderedIds) {
    final reordered = _queue.reorder(orderedIds);
    if (reordered) _notifyQueueUpdate();
    return reordered;
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

    final factory = job.builderFactory;
    if (factory == null) return null;
    return addJob(
      builder: factory(),
      builderFactory: factory,
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
    final failure = GeniusPdfFailure(
      error: StateError('Cancelled'),
      message: 'Cancelled',
    );
    job.result = failure;
    job.onError?.call(failure);
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
    try {
      await _GeniusPdfJobExecutor(
        _service,
        retryFailedJobs: _config.retryFailedJobs,
        maxRetries: _config.maxRetries,
        retryDelay: _config.retryDelay,
      ).execute(
        job,
        notify: _notifyJobUpdate,
      );
    } finally {
      _processing.remove(job.id);
      _notifyJobUpdate(job);
      _notifyQueueUpdate();
      if (_config.cleanupCompletedJobs) _scheduleCleanup();
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


