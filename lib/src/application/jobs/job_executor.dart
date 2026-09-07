part of '../generation/pdf_generation_manager.dart';

/// Executes one job and owns generation/post-action state transitions.
class _GeniusPdfJobExecutor {
  const _GeniusPdfJobExecutor(
    this.service, {
    required this.retryFailedJobs,
    required this.maxRetries,
    required this.retryDelay,
  });

  final GeniusPdfService service;
  final bool retryFailedJobs;
  final int maxRetries;
  final Duration retryDelay;

  Future<void> execute(
    GeniusPdfJob job, {
    required void Function(GeniusPdfJob job) notify,
  }) async {
    job.status = GeniusPdfJobStatus.processing;
    GeniusPdfLogger.info(
      'Processing job: "${job.fileName}"',
      tag: 'JobManager',
      data: {'jobId': job.id},
    );
    GeniusPdfLogger.startTimer('job_${job.id}');
    job.startedAt = DateTime.now();
    job.onStart?.call();
    notify(job);

    try {
      final result = await _generateWithRetry(job, notify);
      if (job.cancelRequested) {
        await _deleteGeneratedFile(result);
        _markCancelled(job);
        return;
      }
      if (result is GeniusPdfFailure) {
        _markFailed(job, result);
        return;
      }

      final success = result as GeniusPdfSuccess;
      _updateProgress(job, 0.8, notify);
      await _runPostActions(job, success);
      if (job.cancelRequested) {
        _markCancelled(job);
        return;
      }

      _updateProgress(job, 1, notify);
      job.status = GeniusPdfJobStatus.completed;
      GeniusPdfLogger.stopTimer('job_${job.id}', tag: 'JobManager');
      GeniusPdfLogger.info(
        'Job completed: "${job.fileName}"',
        tag: 'JobManager',
        data: {'jobId': job.id},
      );
      job.completedAt = DateTime.now();
      job.result = success;
      job.onComplete?.call(success);
    } catch (error, stackTrace) {
      _markFailed(job, GeniusPdfFailure.fromException(error, stackTrace));
    }
  }


  Future<GeniusPdfResult> _generateWithRetry(
    GeniusPdfJob job,
    void Function(GeniusPdfJob job) notify,
  ) async {
    while (true) {
      _updateProgress(job, 0.1, notify);
      final result = await service.generateAndSave(
        builder: job.builder,
        fileName: job.fileName,
        runInBackground: job.runInBackground,
      );
      if (result is! GeniusPdfFailure || !_canRetry(job)) return result;

      job.retryCount++;
      GeniusPdfLogger.info(
        'Retrying job "${job.fileName}" '
        '(${job.retryCount}/$maxRetries)',
        tag: 'JobManager',
        data: {'jobId': job.id},
      );
      notify(job);
      if (retryDelay > Duration.zero) await Future<void>.delayed(retryDelay);
      if (job.cancelRequested) return result;
      job.replaceBuilderForRetry();
    }
  }

  bool _canRetry(GeniusPdfJob job) =>
      retryFailedJobs &&
      job.builderFactory != null &&
      job.retryCount < maxRetries &&
      !job.cancelRequested;

  void _updateProgress(
    GeniusPdfJob job,
    double progress,
    void Function(GeniusPdfJob job) notify,
  ) {
    job.progress = progress;
    job.onProgress?.call(progress);
    notify(job);
  }

  Future<void> _runPostActions(
    GeniusPdfJob job,
    GeniusPdfSuccess success,
  ) async {
    if (job.autoOpen && success.filePath != null) {
      await _guardAction('autoOpen', () => service.openFile(success.filePath!));
    }
    if (job.autoShare) {
      await _guardAction(
        'autoShare',
        () => service.sharePdf(
          bytes: success.bytes,
          fileName: '${job.fileName}.pdf',
        ),
      );
    }
    if (job.autoPrint) {
      await _guardAction(
        'autoPrint',
        () => service.print(
          bytes: success.bytes,
          documentName: job.fileName,
        ),
      );
    }
  }

  Future<void> _guardAction(
    String action,
    Future<Object?> Function() callback,
  ) async {
    try {
      await callback();
    } catch (error, stackTrace) {
      GeniusPdfLogger.error(
        '$action failed',
        tag: 'JobManager',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  Future<void> _deleteGeneratedFile(GeniusPdfResult result) async {
    if (result is! GeniusPdfSuccess || result.filePath == null) return;
    try {
      final file = File(result.filePath!);
      if (await file.exists()) await file.delete();
    } catch (_) {
      // Cancellation cleanup must not replace the cancellation result.
    }
  }

  void _markCancelled(GeniusPdfJob job) {
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
  }

  void _markFailed(GeniusPdfJob job, GeniusPdfFailure failure) {
    job.status = GeniusPdfJobStatus.failed;
    GeniusPdfLogger.stopTimer('job_${job.id}', tag: 'JobManager');
    GeniusPdfLogger.error(
      'Job failed: "${job.fileName}"',
      tag: 'JobManager',
      error: failure.error,
      stackTrace: failure.stackTrace,
      data: {'jobId': job.id},
    );
    job.completedAt = DateTime.now();
    job.result = failure;
    job.errorMessage = failure.message;
    job.onError?.call(failure);
  }
}
