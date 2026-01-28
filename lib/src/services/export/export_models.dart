import 'dart:typed_data';

/// Supported export formats for PDF documents.
enum GeniusExportFormat {
  /// PDF/A format for long-term archival
  pdfA('PDF/A', 'pdf'),

  /// PNG image format
  png('PNG Image', 'png'),

  /// JPEG image format
  jpeg('JPEG Image', 'jpg'),

  /// HTML format
  html('HTML', 'html'),

  /// Plain text format
  text('Plain Text', 'txt');

  const GeniusExportFormat(this.displayName, this.extension);

  /// Human-readable name for the format
  final String displayName;

  /// File extension for the format
  final String extension;

  /// Arabic display name
  String get displayNameAr {
    switch (this) {
      case GeniusExportFormat.pdfA:
        return 'PDF/A للأرشفة';
      case GeniusExportFormat.png:
        return 'صورة PNG';
      case GeniusExportFormat.jpeg:
        return 'صورة JPEG';
      case GeniusExportFormat.html:
        return 'HTML';
      case GeniusExportFormat.text:
        return 'نص عادي';
    }
  }
}

/// Image quality settings for image exports.
enum GeniusImageQuality {
  /// Low quality (72 DPI)
  low(72, 'Low', 'منخفضة'),

  /// Medium quality (150 DPI)
  medium(150, 'Medium', 'متوسطة'),

  /// High quality (300 DPI)
  high(300, 'High', 'عالية'),

  /// Maximum quality (600 DPI)
  maximum(600, 'Maximum', 'قصوى');

  const GeniusImageQuality(this.dpi, this.displayName, this.displayNameAr);

  /// Dots per inch
  final int dpi;

  /// Human-readable name
  final String displayName;

  /// Arabic display name
  final String displayNameAr;
}

/// Configuration for export operations.
class GeniusExportConfiguration {
  /// Creates an export configuration.
  const GeniusExportConfiguration({
    required this.format,
    this.quality = GeniusImageQuality.high,
    this.pageRange,
    this.compress = true,
    this.includeAnnotations = true,
    this.includeBookmarks = true,
    this.jpegQuality = 85,
    this.htmlEmbedImages = true,
    this.htmlIncludeStyles = true,
    this.outputFileName,
  });

  /// Creates a configuration for image export.
  factory GeniusExportConfiguration.image({
    required GeniusExportFormat format,
    GeniusImageQuality quality = GeniusImageQuality.high,
    GeniusPageRange? pageRange,
    int jpegQuality = 85,
  }) {
    assert(
      format == GeniusExportFormat.png || format == GeniusExportFormat.jpeg,
      'Image export requires PNG or JPEG format',
    );
    return GeniusExportConfiguration(
      format: format,
      quality: quality,
      pageRange: pageRange,
      jpegQuality: jpegQuality,
    );
  }

  /// Creates a configuration for HTML export.
  factory GeniusExportConfiguration.html({
    bool embedImages = true,
    bool includeStyles = true,
    GeniusPageRange? pageRange,
  }) {
    return GeniusExportConfiguration(
      format: GeniusExportFormat.html,
      pageRange: pageRange,
      htmlEmbedImages: embedImages,
      htmlIncludeStyles: includeStyles,
    );
  }

  /// Creates a configuration for PDF/A archival export.
  factory GeniusExportConfiguration.pdfA({
    bool compress = true,
    bool includeAnnotations = true,
    bool includeBookmarks = true,
  }) {
    return GeniusExportConfiguration(
      format: GeniusExportFormat.pdfA,
      compress: compress,
      includeAnnotations: includeAnnotations,
      includeBookmarks: includeBookmarks,
    );
  }

  /// Creates a configuration for text export.
  factory GeniusExportConfiguration.text({
    GeniusPageRange? pageRange,
  }) {
    return GeniusExportConfiguration(
      format: GeniusExportFormat.text,
      pageRange: pageRange,
    );
  }

  /// The export format.
  final GeniusExportFormat format;

  /// Image quality for image exports.
  final GeniusImageQuality quality;

  /// Page range to export. If null, all pages are exported.
  final GeniusPageRange? pageRange;

  /// Whether to compress the output.
  final bool compress;

  /// Whether to include annotations in the export.
  final bool includeAnnotations;

  /// Whether to include bookmarks in the export.
  final bool includeBookmarks;

  /// JPEG quality (1-100) for JPEG exports.
  final int jpegQuality;

  /// Whether to embed images as base64 in HTML exports.
  final bool htmlEmbedImages;

  /// Whether to include inline CSS styles in HTML exports.
  final bool htmlIncludeStyles;

  /// Optional custom output file name.
  final String? outputFileName;

  /// Creates a copy with updated values.
  GeniusExportConfiguration copyWith({
    GeniusExportFormat? format,
    GeniusImageQuality? quality,
    GeniusPageRange? pageRange,
    bool? compress,
    bool? includeAnnotations,
    bool? includeBookmarks,
    int? jpegQuality,
    bool? htmlEmbedImages,
    bool? htmlIncludeStyles,
    String? outputFileName,
  }) {
    return GeniusExportConfiguration(
      format: format ?? this.format,
      quality: quality ?? this.quality,
      pageRange: pageRange ?? this.pageRange,
      compress: compress ?? this.compress,
      includeAnnotations: includeAnnotations ?? this.includeAnnotations,
      includeBookmarks: includeBookmarks ?? this.includeBookmarks,
      jpegQuality: jpegQuality ?? this.jpegQuality,
      htmlEmbedImages: htmlEmbedImages ?? this.htmlEmbedImages,
      htmlIncludeStyles: htmlIncludeStyles ?? this.htmlIncludeStyles,
      outputFileName: outputFileName ?? this.outputFileName,
    );
  }
}

/// Represents a range of pages to export.
class GeniusPageRange {
  /// Creates a page range.
  const GeniusPageRange({
    required this.start,
    required this.end,
  }) : assert(start >= 1 && end >= start, 'Invalid page range');

  /// Creates a range for a single page.
  factory GeniusPageRange.single(int page) => GeniusPageRange(start: page, end: page);

  /// Creates a range from start to end of document.
  factory GeniusPageRange.fromStart(int start) => GeniusPageRange(start: start, end: -1);

  /// Creates a range from beginning to specific page.
  factory GeniusPageRange.toPage(int end) => GeniusPageRange(start: 1, end: end);

  /// Start page (1-indexed).
  final int start;

  /// End page (1-indexed, or -1 for end of document).
  final int end;

  /// Whether this range includes the given page number.
  bool includes(int page) {
    if (page < start) return false;
    if (end == -1) return true;
    return page <= end;
  }

  /// Returns the list of page numbers in this range.
  List<int> toList(int totalPages) {
    final effectiveEnd = end == -1 ? totalPages : end;
    return List.generate(effectiveEnd - start + 1, (i) => start + i);
  }

  @override
  String toString() => end == -1 ? '$start-end' : '$start-$end';
}

/// Result of an export operation.
sealed class GeniusExportResult {
  const GeniusExportResult();
}

/// Successful export result.
class GeniusExportSuccess extends GeniusExportResult {
  /// Creates a successful export result.
  const GeniusExportSuccess({
    required this.data,
    required this.format,
    this.filePath,
    this.pageCount = 1,
  });

  /// The exported data as bytes.
  final Uint8List data;

  /// The export format used.
  final GeniusExportFormat format;

  /// The file path if saved to disk.
  final String? filePath;

  /// Number of pages exported.
  final int pageCount;

  /// Size of the exported data in bytes.
  int? get fileSize => data.length;

  /// Formatted file size string.
  String get fileSizeFormatted {
    final size = data.length;
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Failed export result.
class GeniusExportFailure extends GeniusExportResult {
  /// Creates a failed export result.
  const GeniusExportFailure({
    required this.error,
    this.stackTrace,
  });

  /// The error that occurred.
  final Object error;

  /// The stack trace of the error.
  final StackTrace? stackTrace;

  /// Error message.
  String get message => error.toString();
}

/// Result of a batch export operation.
class GeniusBatchExportResult {
  /// Creates a batch export result.
  const GeniusBatchExportResult({
    required this.results,
    required this.totalCount,
    required this.successCount,
    required this.failureCount,
    required this.duration,
  });

  /// Individual export results.
  final List<GeniusExportResult> results;

  /// Total number of items in the batch.
  final int totalCount;

  /// Number of successful exports.
  final int successCount;

  /// Number of failed exports.
  final int failureCount;

  /// Total duration of the batch operation.
  final Duration duration;

  /// Whether all exports were successful.
  bool get allSuccessful => failureCount == 0;

  /// Whether any exports failed.
  bool get hasFailures => failureCount > 0;

  /// Success rate as a percentage.
  double get successRate =>
      totalCount > 0 ? (successCount / totalCount) * 100 : 0;

  /// Gets all successful results.
  List<GeniusExportSuccess> get successes =>
      results.whereType<GeniusExportSuccess>().toList();

  /// Gets all failed results.
  List<GeniusExportFailure> get failures =>
      results.whereType<GeniusExportFailure>().toList();
}

/// Progress information for export operations.
class GeniusExportProgress {
  /// Creates export progress information.
  const GeniusExportProgress({
    required this.currentPage,
    required this.totalPages,
    required this.currentItem,
    required this.totalItems,
    this.status = '',
    this.statusAr = '',
  });

  /// Current page being exported.
  final int currentPage;

  /// Total pages to export.
  final int totalPages;

  /// Current item in batch (for batch exports).
  final int currentItem;

  /// Total items in batch.
  final int totalItems;

  /// Status message.
  final String status;

  /// Arabic status message.
  final String statusAr;

  /// Overall progress as a fraction (0.0 to 1.0).
  double get progress {
    if (totalItems <= 1) {
      return totalPages > 0 ? currentPage / totalPages : 0;
    }
    final itemProgress = totalItems > 0 ? (currentItem - 1) / totalItems : 0;
    final pageProgress =
        totalPages > 0 ? (currentPage / totalPages) / totalItems : 0;
    return (itemProgress + pageProgress).toDouble();
  }

  /// Progress as a percentage (0-100).
  int get percentage => (progress * 100).round();
}
