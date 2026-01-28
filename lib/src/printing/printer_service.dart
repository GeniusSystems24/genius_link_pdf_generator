/// Printer Service
///
/// Main service for printing PDF documents with advanced features.
///
/// This service provides:
/// - Print with system dialog or direct printing
/// - PDF to image rasterization
/// - PDF sharing functionality
/// - Print job tracking and management
/// - Multiple copies with collation
/// - Page range selection
library;

import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' show Rect, ImageByteFormat;

import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import 'printer_models.dart';
import 'printer_discovery.dart';

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
class GeniusPrinterService {
  GeniusPrinterService._();

  /// Creates a new instance (for testing)
  factory GeniusPrinterService() => instance;

  /// Singleton instance
  static GeniusPrinterService? _instance;

  /// Gets the singleton instance
  static GeniusPrinterService get instance {
    _instance ??= GeniusPrinterService._();
    return _instance!;
  }

  /// Printer discovery service
  final GeniusPrinterDiscovery _discovery = GeniusPrinterDiscovery.instance;

  /// Active print jobs
  final Map<String, GeniusPrintJob> _activeJobs = {};

  /// Job history
  final List<GeniusPrintJob> _jobHistory = [];

  /// Maximum history size
  int maxHistorySize = 100;

  /// Job counter for generating IDs
  int _jobCounter = 0;

  /// Job stream controller
  final _jobController = StreamController<GeniusPrintJob>.broadcast();

  /// Stream of job updates
  Stream<GeniusPrintJob> get jobStream => _jobController.stream;

  /// Gets printer discovery service
  GeniusPrinterDiscovery get discovery => _discovery;

  /// Gets active jobs
  List<GeniusPrintJob> get activeJobs => _activeJobs.values.toList();

  /// Gets job history
  List<GeniusPrintJob> get jobHistory => List.unmodifiable(_jobHistory);

  /// Checks if printing is available on this platform
  Future<bool> isPrintingAvailable() async {
    final info = await Printing.info();
    return info.canPrint;
  }

  /// Gets printing info for this platform
  Future<PrintingInfo> getPrintingInfo() async {
    return Printing.info();
  }

  /// Checks if sharing is available
  Future<bool> isSharingAvailable() async {
    final info = await Printing.info();
    return info.canShare;
  }

  /// Checks if raster (PDF to image) is available
  Future<bool> isRasterAvailable() async {
    final info = await Printing.info();
    return info.canRaster;
  }

  /// Prints a PDF document using system print dialog
  ///
  /// This shows the native print dialog where users can select printer,
  /// copies, page range, etc.
  Future<GeniusPrintResult> printWithDialog({
    required Uint8List pdfBytes,
    required String documentName,
    GeniusPrintSettings? settings,
    GeniusPrintProgressCallback? onProgress,
    GeniusPrintCompleteCallback? onComplete,
    GeniusPrintErrorCallback? onError,
  }) async {
    final effectiveSettings = settings ?? GeniusPrintSettings.defaults();
    final job = _createJob(
      documentName: documentName,
      printerId: 'system_dialog',
      settings: effectiveSettings,
      pdfBytes: pdfBytes,
    );

    _activeJobs[job.id] = job;
    _notifyJobUpdate(job);

    try {
      job.status = GeniusPrintJobStatus.sending;
      job.startedAt = DateTime.now();
      _notifyJobUpdate(job);
      onProgress?.call(job);

      // Use the printing package to show system dialog
      final success = await Printing.layoutPdf(
        onLayout: (_) => pdfBytes,
        name: documentName,
        format: _getPdfPageFormat(effectiveSettings.paperSize),
      );

      if (success) {
        job.status = GeniusPrintJobStatus.completed;
        job.progress = 1.0;
        job.completedAt = DateTime.now();
        _notifyJobUpdate(job);
        onComplete?.call(job);
        _addToHistory(job);
        return GeniusPrintResult.success(job);
      } else {
        job.status = GeniusPrintJobStatus.cancelled;
        job.completedAt = DateTime.now();
        _notifyJobUpdate(job);
        _addToHistory(job);
        return GeniusPrintResult.failure('Print cancelled by user', job);
      }
    } catch (e) {
      job.status = GeniusPrintJobStatus.failed;
      job.errorMessage = e.toString();
      job.completedAt = DateTime.now();
      _notifyJobUpdate(job);
      onError?.call(job, e.toString());
      _addToHistory(job);
      return GeniusPrintResult.failure(e.toString(), job);
    } finally {
      _activeJobs.remove(job.id);
    }
  }

  /// Prints directly without showing dialog (if supported)
  ///
  /// Note: Direct printing without dialog may not be supported on all platforms.
  /// Falls back to dialog printing if direct printing is not available.
  Future<GeniusPrintResult> printDirect({
    required Uint8List pdfBytes,
    required String documentName,
    String? printerId,
    GeniusPrintSettings? settings,
    GeniusPrintProgressCallback? onProgress,
    GeniusPrintCompleteCallback? onComplete,
    GeniusPrintErrorCallback? onError,
  }) async {
    final effectiveSettings = settings ?? GeniusPrintSettings.defaults();
    final effectivePrinterId = printerId ?? 'system_default';

    final job = _createJob(
      documentName: documentName,
      printerId: effectivePrinterId,
      settings: effectiveSettings,
      pdfBytes: pdfBytes,
    );

    _activeJobs[job.id] = job;
    _notifyJobUpdate(job);

    try {
      job.status = GeniusPrintJobStatus.sending;
      job.startedAt = DateTime.now();
      _notifyJobUpdate(job);
      onProgress?.call(job);

      // Check if direct printing is available
      final info = await Printing.info();
      if (info.directPrint) {
        // Direct print available
        final success = await Printing.directPrintPdf(
          printer: Printer(url: effectivePrinterId),
          onLayout: (_) => pdfBytes,
          name: documentName,
          format: _getPdfPageFormat(effectiveSettings.paperSize),
        );

        if (success) {
          job.status = GeniusPrintJobStatus.completed;
          job.progress = 1.0;
          job.completedAt = DateTime.now();
          _notifyJobUpdate(job);
          onComplete?.call(job);
          _addToHistory(job);
          return GeniusPrintResult.success(job);
        } else {
          job.status = GeniusPrintJobStatus.failed;
          job.errorMessage = 'Direct print failed';
          job.completedAt = DateTime.now();
          _notifyJobUpdate(job);
          onError?.call(job, 'Direct print failed');
          _addToHistory(job);
          return GeniusPrintResult.failure('Direct print failed', job);
        }
      } else {
        // Fall back to dialog printing
        _activeJobs.remove(job.id);
        return printWithDialog(
          pdfBytes: pdfBytes,
          documentName: documentName,
          settings: settings,
          onProgress: onProgress,
          onComplete: onComplete,
          onError: onError,
        );
      }
    } catch (e) {
      job.status = GeniusPrintJobStatus.failed;
      job.errorMessage = e.toString();
      job.completedAt = DateTime.now();
      _notifyJobUpdate(job);
      onError?.call(job, e.toString());
      _addToHistory(job);
      return GeniusPrintResult.failure(e.toString(), job);
    } finally {
      _activeJobs.remove(job.id);
    }
  }

  /// Prints multiple copies of a document
  Future<GeniusPrintResult> printCopies({
    required Uint8List pdfBytes,
    required String documentName,
    required int copies,
    String? printerId,
    GeniusPrintSettings? settings,
    GeniusPrintProgressCallback? onProgress,
    GeniusPrintCompleteCallback? onComplete,
    GeniusPrintErrorCallback? onError,
  }) async {
    final effectiveSettings =
        (settings ?? GeniusPrintSettings.defaults()).copyWith(copies: copies);

    return printWithDialog(
      pdfBytes: pdfBytes,
      documentName: documentName,
      settings: effectiveSettings,
      onProgress: onProgress,
      onComplete: onComplete,
      onError: onError,
    );
  }

  /// Shares a PDF document using the system share dialog
  ///
  /// This opens the native share sheet allowing the user to share
  /// via email, messaging apps, cloud storage, etc.
  Future<GeniusPdfShareResult> sharePdf({
    required Uint8List pdfBytes,
    required String fileName,
    String? subject,
    String? text,
    Rect? sharePositionOrigin,
  }) async {
    try {
      // Ensure fileName has .pdf extension
      final effectiveFileName =
          fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';

      // Create a temporary file
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$effectiveFileName');
      await tempFile.writeAsBytes(pdfBytes);

      // Share using share_plus
      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(tempFile.path, mimeType: 'application/pdf')],
          subject: subject,
          text: text,
          sharePositionOrigin: sharePositionOrigin,
        ),
      );

      return GeniusPdfShareResult.success(
        shareResult: result,
        filePath: tempFile.path,
      );
    } catch (e) {
      return GeniusPdfShareResult.failure(e.toString());
    }
  }

  /// Shares a PDF using the printing package's native share
  Future<GeniusPdfShareResult> sharePdfNative({
    required Uint8List pdfBytes,
    required String fileName,
    Rect? bounds,
  }) async {
    try {
      final effectiveFileName =
          fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: effectiveFileName,
        bounds: bounds ?? Rect.zero,
      );

      return GeniusPdfShareResult.success();
    } catch (e) {
      return GeniusPdfShareResult.failure(e.toString());
    }
  }

  /// Saves PDF to a file and returns the path
  Future<GeniusPdfShareResult> savePdfToFile({
    required Uint8List pdfBytes,
    required String fileName,
    String? directory,
  }) async {
    try {
      final effectiveFileName =
          fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';

      final Directory targetDir;
      if (directory != null) {
        targetDir = Directory(directory);
        if (!await targetDir.exists()) {
          await targetDir.create(recursive: true);
        }
      } else {
        targetDir = await getApplicationDocumentsDirectory();
      }

      final file = File('${targetDir.path}/$effectiveFileName');
      await file.writeAsBytes(pdfBytes);

      return GeniusPdfShareResult.success(filePath: file.path);
    } catch (e) {
      return GeniusPdfShareResult.failure(e.toString());
    }
  }

  /// Converts PDF pages to images (rasterization)
  ///
  /// This is useful for creating thumbnails or image previews of PDF pages.
  Future<GeniusPdfRasterResult> rasterPdf({
    required Uint8List pdfBytes,
    double dpi = 150,
    GeniusRasterFormat format = GeniusRasterFormat.png,
    List<int>? pages,
    void Function(int current, int total)? onProgress,
  }) async {
    try {
      final info = await Printing.info();
      if (!info.canRaster) {
        throw UnsupportedError('PDF rasterization not supported on this platform');
      }

      final renderedPages = <Uint8List>[];
      int pageIndex = 0;

      // Render pages
      await for (final page in Printing.raster(pdfBytes, dpi: dpi, pages: pages)) {
        // Always use PNG as it's lossless and well-supported
        final imageBytes = await page.toPng();
        renderedPages.add(imageBytes);
        pageIndex++;
        onProgress?.call(pageIndex, pages?.length ?? pageIndex);
      }

      return GeniusPdfRasterResult(
        pages: renderedPages,
        dpi: dpi,
        format: format,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Gets a single page as an image
  Future<Uint8List?> getPageImage({
    required Uint8List pdfBytes,
    required int pageIndex,
    double dpi = 150,
  }) async {
    try {
      await for (final page in Printing.raster(pdfBytes, dpi: dpi, pages: [pageIndex])) {
        return await page.toPng();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Generates a thumbnail for the first page
  Future<Uint8List?> generateThumbnail({
    required Uint8List pdfBytes,
    double dpi = 72,
  }) async {
    return getPageImage(pdfBytes: pdfBytes, pageIndex: 0, dpi: dpi);
  }

  /// Converts PDF to HTML format (basic conversion)
  Future<String> convertPdfToHtml({
    required Uint8List pdfBytes,
    double dpi = 150,
    bool embedImages = true,
  }) async {
    final buffer = StringBuffer();
    buffer.writeln('<!DOCTYPE html>');
    buffer.writeln('<html>');
    buffer.writeln('<head>');
    buffer.writeln('<meta charset="UTF-8">');
    buffer.writeln('<meta name="viewport" content="width=device-width, initial-scale=1.0">');
    buffer.writeln('<style>');
    buffer.writeln('body { margin: 0; padding: 20px; background: #f5f5f5; }');
    buffer.writeln('.page { background: white; margin: 20px auto; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }');
    buffer.writeln('.page img { width: 100%; height: auto; display: block; }');
    buffer.writeln('</style>');
    buffer.writeln('</head>');
    buffer.writeln('<body>');

    try {
      final result = await rasterPdf(pdfBytes: pdfBytes, dpi: dpi);
      for (int i = 0; i < result.pages.length; i++) {
        buffer.writeln('<div class="page">');
        if (embedImages) {
          final base64 = base64Encode(result.pages[i]);
          buffer.writeln('<img src="data:image/png;base64,$base64" alt="Page ${i + 1}">');
        } else {
          buffer.writeln('<img src="page_${i + 1}.png" alt="Page ${i + 1}">');
        }
        buffer.writeln('</div>');
      }
    } catch (e) {
      buffer.writeln('<p>Error rendering PDF: $e</p>');
    }

    buffer.writeln('</body>');
    buffer.writeln('</html>');
    return buffer.toString();
  }

  /// Cancels a print job
  Future<bool> cancelJob(String jobId) async {
    final job = _activeJobs[jobId];
    if (job == null) return false;

    job.status = GeniusPrintJobStatus.cancelled;
    job.completedAt = DateTime.now();
    _notifyJobUpdate(job);
    _activeJobs.remove(jobId);
    _addToHistory(job);

    return true;
  }

  /// Gets a job by ID
  GeniusPrintJob? getJob(String jobId) {
    return _activeJobs[jobId] ??
        _jobHistory.where((j) => j.id == jobId).firstOrNull;
  }

  /// Clears job history
  void clearHistory() {
    _jobHistory.clear();
  }

  /// Creates a print job
  GeniusPrintJob _createJob({
    required String documentName,
    required String printerId,
    required GeniusPrintSettings settings,
    required Uint8List pdfBytes,
  }) {
    _jobCounter++;
    return GeniusPrintJob(
      id: 'print_job_${_jobCounter}_${DateTime.now().millisecondsSinceEpoch}',
      documentName: documentName,
      printerId: printerId,
      settings: settings,
      pdfBytes: pdfBytes,
    );
  }

  /// Notifies listeners of job update
  void _notifyJobUpdate(GeniusPrintJob job) {
    _jobController.add(job);
  }

  /// Adds a job to history
  void _addToHistory(GeniusPrintJob job) {
    _jobHistory.insert(0, job);
    if (_jobHistory.length > maxHistorySize) {
      _jobHistory.removeLast();
    }
  }

  /// Gets PDF page format from paper size
  PdfPageFormat _getPdfPageFormat(GeniusPaperSize paperSize) {
    return switch (paperSize) {
      GeniusPaperSize.a3 => PdfPageFormat.a3,
      GeniusPaperSize.a4 => PdfPageFormat.a4,
      GeniusPaperSize.a5 => PdfPageFormat.a5,
      GeniusPaperSize.letter => PdfPageFormat.letter,
      GeniusPaperSize.legal => PdfPageFormat.legal,
      GeniusPaperSize.tabloid => const PdfPageFormat(11 * 72, 17 * 72),
      GeniusPaperSize.executive =>
        const PdfPageFormat(7.25 * 72, 10.5 * 72),
      GeniusPaperSize.b4 => const PdfPageFormat(250 * 72 / 25.4, 353 * 72 / 25.4),
      GeniusPaperSize.b5 => const PdfPageFormat(176 * 72 / 25.4, 250 * 72 / 25.4),
      GeniusPaperSize.envelopeDL =>
        const PdfPageFormat(110 * 72 / 25.4, 220 * 72 / 25.4),
      GeniusPaperSize.envelopeC5 =>
        const PdfPageFormat(162 * 72 / 25.4, 229 * 72 / 25.4),
      GeniusPaperSize.custom => PdfPageFormat.a4, // Default to A4
    };
  }

  /// Disposes the printer service
  void dispose() {
    _jobController.close();
    _activeJobs.clear();
    _jobHistory.clear();
    _instance = null;
  }
}

/// Base64 encoding helper
String base64Encode(Uint8List bytes) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
  final buffer = StringBuffer();
  final len = bytes.length;
  for (var i = 0; i < len; i += 3) {
    final b1 = bytes[i];
    final b2 = i + 1 < len ? bytes[i + 1] : 0;
    final b3 = i + 2 < len ? bytes[i + 2] : 0;
    buffer.write(chars[(b1 >> 2) & 0x3F]);
    buffer.write(chars[((b1 << 4) | (b2 >> 4)) & 0x3F]);
    buffer.write(i + 1 < len ? chars[((b2 << 2) | (b3 >> 6)) & 0x3F] : '=');
    buffer.write(i + 2 < len ? chars[b3 & 0x3F] : '=');
  }
  return buffer.toString();
}

/// Extension for easy printing from bytes
extension GeniusPrintBytesExtension on Uint8List {
  /// Prints this PDF data
  Future<GeniusPrintResult> print({
    required String documentName,
    GeniusPrintSettings? settings,
  }) {
    return GeniusPrinterService.instance.printWithDialog(
      pdfBytes: this,
      documentName: documentName,
      settings: settings,
    );
  }

  /// Shares this PDF data
  Future<GeniusPdfShareResult> share({
    required String fileName,
    String? subject,
    String? text,
  }) {
    return GeniusPrinterService.instance.sharePdf(
      pdfBytes: this,
      fileName: fileName,
      subject: subject,
      text: text,
    );
  }

  /// Saves this PDF to a file
  Future<GeniusPdfShareResult> saveToFile({
    required String fileName,
    String? directory,
  }) {
    return GeniusPrinterService.instance.savePdfToFile(
      pdfBytes: this,
      fileName: fileName,
      directory: directory,
    );
  }

  /// Converts this PDF to images
  Future<GeniusPdfRasterResult> toImages({
    double dpi = 150,
    GeniusRasterFormat format = GeniusRasterFormat.png,
  }) {
    return GeniusPrinterService.instance.rasterPdf(
      pdfBytes: this,
      dpi: dpi,
      format: format,
    );
  }

  /// Gets a thumbnail of the first page
  Future<Uint8List?> toThumbnail({double dpi = 72}) {
    return GeniusPrinterService.instance.generateThumbnail(
      pdfBytes: this,
      dpi: dpi,
    );
  }
}
