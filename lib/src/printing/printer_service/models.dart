part of '../printer_service.dart';

/// Callback for print job progress
typedef GeniusPrintProgressCallback = void Function(GeniusPrintJob job);

/// Callback for print job completion
typedef GeniusPrintCompleteCallback = void Function(GeniusPrintJob job);

/// Callback for print job error
typedef GeniusPrintErrorCallback = void Function(
    GeniusPrintJob job, String error);

/// Print result
class GeniusPrintResult {

  /// Creates a print result
  const GeniusPrintResult({
    required this.success,
    this.job,
    this.error,
  });

  /// Creates a successful result
  factory GeniusPrintResult.success(GeniusPrintJob job) {
    return GeniusPrintResult(success: true, job: job);
  }

  /// Creates a failed result
  factory GeniusPrintResult.failure(String error, [GeniusPrintJob? job]) {
    return GeniusPrintResult(success: false, error: error, job: job);
  }
  /// Whether printing was successful
  final bool success;

  /// The print job
  final GeniusPrintJob? job;

  /// Error message (if failed)
  final String? error;
}

/// PDF Raster result containing rendered page images
class GeniusPdfRasterResult {
  /// Creates a raster result
  const GeniusPdfRasterResult({
    required this.pages,
    required this.dpi,
    required this.format,
  });

  /// Rendered page images as PNG bytes
  final List<Uint8List> pages;

  /// DPI used for rendering
  final double dpi;

  /// Image format
  final GeniusRasterFormat format;

  /// Number of pages rendered
  int get pageCount => pages.length;

  /// Total size of all images in bytes
  int get totalSize => pages.fold(0, (sum, p) => sum + p.length);
}

/// Raster image format
enum GeniusRasterFormat {
  /// PNG format (lossless)
  png,

  /// JPEG format (lossy)
  jpeg,
}

/// PDF Share result
class GeniusPdfShareResult {
  /// Creates a share result
  const GeniusPdfShareResult({
    required this.success,
    this.shareResult,
    this.error,
    this.filePath,
  });

  /// Creates a successful result
  factory GeniusPdfShareResult.success({
    ShareResult? shareResult,
    String? filePath,
  }) {
    return GeniusPdfShareResult(
      success: true,
      shareResult: shareResult,
      filePath: filePath,
    );
  }

  /// Creates a failed result
  factory GeniusPdfShareResult.failure(String error) {
    return GeniusPdfShareResult(success: false, error: error);
  }

  /// Whether sharing was successful
  final bool success;

  /// The share result from the platform
  final ShareResult? shareResult;

  /// Error message if failed
  final String? error;

  /// Path where the file was saved
  final String? filePath;
}

/// Main printer service for printing PDFs
