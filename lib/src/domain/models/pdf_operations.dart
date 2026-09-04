import 'dart:async';
import 'dart:typed_data';

enum GeniusPdfTextFlow { ltr, rtl }

/// Callback for progress updates during PDF operations.
typedef GeniusPdfProgressCallback = void Function(
  double progress,
  String? message,
);

/// Cancellation token for long-running PDF operations.
class GeniusPdfCancellationToken {
  bool _isCancelled = false;
  final Completer<void> _completer = Completer<void>();

  bool get isCancelled => _isCancelled;
  Future<void> get whenCancelled => _completer.future;

  void cancel() {
    if (_isCancelled) return;
    _isCancelled = true;
    _completer.complete();
  }

  void throwIfCancelled() {
    if (_isCancelled) throw const GeniusPdfCancelledException();
  }
}

class GeniusPdfCancelledException implements Exception {
  const GeniusPdfCancelledException();

  @override
  String toString() => 'PDF operation was cancelled';
}

class GeniusPdfMergeResult {
  const GeniusPdfMergeResult({
    required this.success,
    this.bytes,
    this.filePath,
    this.error,
    this.mergedCount = 0,
  });

  factory GeniusPdfMergeResult.success({
    required Uint8List bytes,
    String? filePath,
    required int mergedCount,
  }) => GeniusPdfMergeResult(
        success: true,
        bytes: bytes,
        filePath: filePath,
        mergedCount: mergedCount,
      );

  factory GeniusPdfMergeResult.failure(String error) =>
      GeniusPdfMergeResult(success: false, error: error);

  final bool success;
  final Uint8List? bytes;
  final String? filePath;
  final String? error;
  final int mergedCount;
}

class GeniusPdfSplitResult {
  const GeniusPdfSplitResult({
    required this.success,
    this.files = const <GeniusPdfSplitFile>[],
    this.error,
  });

  factory GeniusPdfSplitResult.success(List<GeniusPdfSplitFile> files) =>
      GeniusPdfSplitResult(success: true, files: files);

  factory GeniusPdfSplitResult.failure(String error) =>
      GeniusPdfSplitResult(success: false, error: error);

  final bool success;
  final List<GeniusPdfSplitFile> files;
  final String? error;

  int get fileCount => files.length;
}

class GeniusPdfSplitFile {
  const GeniusPdfSplitFile({
    required this.bytes,
    required this.fileName,
    required this.pageStart,
    required this.pageEnd,
    this.filePath,
  });

  final Uint8List bytes;
  final String fileName;
  final int pageStart;
  final int pageEnd;
  final String? filePath;

  int get pageCount => pageEnd - pageStart + 1;
}

class GeniusPdfMetadata {
  const GeniusPdfMetadata({
    this.title,
    this.author,
    this.subject,
    this.keywords,
    this.creator,
    this.producer,
    this.creationDate,
    this.modificationDate,
  });

  final String? title;
  final String? author;
  final String? subject;
  final String? keywords;
  final String? creator;
  final String? producer;
  final DateTime? creationDate;
  final DateTime? modificationDate;
}

class GeniusPdfInfo {
  const GeniusPdfInfo({
    required this.pageCount,
    required this.fileSizeBytes,
    this.metadata,
    this.isEncrypted = false,
    this.hasSignatures = false,
  });

  final int pageCount;
  final int fileSizeBytes;
  final GeniusPdfMetadata? metadata;
  final bool isEncrypted;
  final bool hasSignatures;

  String get fileSizeFormatted {
    if (fileSizeBytes < 1024) return '$fileSizeBytes B';
    if (fileSizeBytes < 1024 * 1024) {
      return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
