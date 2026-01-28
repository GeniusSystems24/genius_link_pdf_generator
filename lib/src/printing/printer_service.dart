/// Printer Service
///
/// Main service for printing PDF documents.
library;

import 'dart:async';
import 'dart:typed_data';

import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

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
}
