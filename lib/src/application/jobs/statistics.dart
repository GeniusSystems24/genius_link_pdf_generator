part of '../generation/pdf_generation_manager.dart';

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
