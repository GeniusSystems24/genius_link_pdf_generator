part of '../generation/pdf_generation_manager.dart';

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
  final int _currentIndex = 0;
  final bool _isRunning = false;
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
