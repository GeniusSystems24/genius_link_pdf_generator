import 'dart:async';
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'export_models.dart';
import 'pdf_export_service.dart';

/// A job item for batch export.
class GeniusBatchExportItem {
  /// Creates a batch export item.
  const GeniusBatchExportItem({
    required this.document,
    required this.config,
    this.outputPath,
    this.id,
  });

  /// Creates a batch export item from PDF bytes.
  factory GeniusBatchExportItem.fromBytes({
    required Uint8List pdfBytes,
    required GeniusExportConfiguration config,
    String? outputPath,
    String? id,
  }) {
    final document = PdfDocument(inputBytes: pdfBytes);
    return GeniusBatchExportItem(
      document: document,
      config: config,
      outputPath: outputPath,
      id: id,
    );
  }

  /// The PDF document to export.
  final PdfDocument document;

  /// Export configuration.
  final GeniusExportConfiguration config;

  /// Optional output path for saving.
  final String? outputPath;

  /// Optional identifier for tracking.
  final String? id;
}

/// Exports multiple PDF documents in batch.
///
/// ## Example
/// ```dart
/// final exporter = BatchExporter();
///
/// final items = [
///   BatchExportItem(document: doc1, config: config),
///   BatchExportItem(document: doc2, config: config),
///   BatchExportItem(document: doc3, config: config),
/// ];
///
/// final result = await exporter.exportBatch(
///   items,
///   onProgress: (progress) {
///     print('${progress.percentage}% complete');
///   },
/// );
///
/// print('Exported ${result.successCount}/${result.totalCount} documents');
/// ```
class GeniusBatchExporter {
  /// Creates a batch exporter.
  GeniusBatchExporter({
    this.maxConcurrent = 3,
  });

  /// Maximum number of concurrent export operations.
  final int maxConcurrent;

  final _exportService = GeniusPdfExportService();

  /// Exports a batch of PDF documents.
  ///
  /// Returns a [GeniusBatchExportResult] with all individual results.
  Future<GeniusBatchExportResult> exportBatch(
    List<GeniusBatchExportItem> items, {
    void Function(GeniusExportProgress)? onProgress,
    bool stopOnError = false,
  }) async {
    final startTime = DateTime.now();
    final results = <GeniusExportResult>[];
    var successCount = 0;
    var failureCount = 0;

    // Process items with concurrency limit
    final completer = Completer<void>();
    var currentIndex = 0;
    var activeCount = 0;

    Future<void> processNext() async {
      if (currentIndex >= items.length) {
        if (activeCount == 0 && !completer.isCompleted) {
          completer.complete();
        }
        return;
      }

      if (stopOnError && failureCount > 0) {
        if (activeCount == 0 && !completer.isCompleted) {
          completer.complete();
        }
        return;
      }

      final index = currentIndex++;
      final item = items[index];
      activeCount++;

      // Report progress
      onProgress?.call(GeniusExportProgress(
        currentPage: 1,
        totalPages: 1,
        currentItem: index + 1,
        totalItems: items.length,
        status: 'Exporting document ${index + 1} of ${items.length}...',
        statusAr: 'جاري تصدير المستند ${index + 1} من ${items.length}...',
      ));

      try {
        GeniusExportResult result;

        if (item.outputPath != null) {
          result = await _exportService.exportAndSave(
            item.document,
            item.config,
            item.outputPath!,
          );
        } else {
          result = await _exportService.export(item.document, item.config);
        }

        results.add(result);

        if (result is GeniusExportSuccess) {
          successCount++;
        } else {
          failureCount++;
        }
      } catch (e, stack) {
        results.add(GeniusExportFailure(error: e, stackTrace: stack));
        failureCount++;
      }

      activeCount--;
      processNext();
    }

    // Start initial batch of concurrent operations
    for (var i = 0; i < maxConcurrent && i < items.length; i++) {
      processNext();
    }

    // Wait for all to complete
    if (items.isNotEmpty) {
      await completer.future;
    }

    final duration = DateTime.now().difference(startTime);

    // Final progress update
    onProgress?.call(GeniusExportProgress(
      currentPage: 1,
      totalPages: 1,
      currentItem: items.length,
      totalItems: items.length,
      status: 'Batch export complete',
      statusAr: 'اكتمل تصدير الدفعة',
    ));

    return GeniusBatchExportResult(
      results: results,
      totalCount: items.length,
      successCount: successCount,
      failureCount: failureCount,
      duration: duration,
    );
  }

  /// Exports multiple PDF documents to the same format.
  Future<GeniusBatchExportResult> exportAllToFormat(
    List<PdfDocument> documents,
    GeniusExportConfiguration config, {
    void Function(GeniusExportProgress)? onProgress,
    String? outputDirectory,
    String? baseFileName,
  }) async {
    final items = <GeniusBatchExportItem>[];

    for (var i = 0; i < documents.length; i++) {
      String? outputPath;
      if (outputDirectory != null) {
        final name = baseFileName ?? 'export';
        final extension = config.format.extension;
        outputPath = '$outputDirectory/${name}_${i + 1}.$extension';
      }

      items.add(GeniusBatchExportItem(
        document: documents[i],
        config: config,
        outputPath: outputPath,
        id: 'doc_${i + 1}',
      ));
    }

    return exportBatch(items, onProgress: onProgress);
  }

  /// Exports a single document to multiple formats.
  Future<GeniusBatchExportResult> exportToMultipleFormats(
    PdfDocument document,
    List<GeniusExportFormat> formats, {
    void Function(GeniusExportProgress)? onProgress,
    String? outputDirectory,
    String? baseFileName,
  }) async {
    final items = <GeniusBatchExportItem>[];

    for (final format in formats) {
      String? outputPath;
      if (outputDirectory != null) {
        final name = baseFileName ?? 'export';
        outputPath = '$outputDirectory/${name}_${format.name}.${format.extension}';
      }

      items.add(GeniusBatchExportItem(
        document: document,
        config: GeniusExportConfiguration(format: format),
        outputPath: outputPath,
        id: format.name,
      ));
    }

    return exportBatch(items, onProgress: onProgress);
  }
}

/// Callback for batch export progress.
typedef BatchProgressCallback = void Function(
  int currentItem,
  int totalItems,
  GeniusExportResult? lastResult,
);

/// Extension for convenient batch operations.
extension BatchExportExtension on List<PdfDocument> {
  /// Exports all documents in this list to the specified format.
  Future<GeniusBatchExportResult> exportAllTo(
    GeniusExportFormat format, {
    GeniusImageQuality quality = GeniusImageQuality.high,
    void Function(GeniusExportProgress)? onProgress,
    String? outputDirectory,
    String? baseFileName,
    int maxConcurrent = 3,
  }) {
    final exporter = GeniusBatchExporter(maxConcurrent: maxConcurrent);
    return exporter.exportAllToFormat(
      this,
      GeniusExportConfiguration(format: format, quality: quality),
      onProgress: onProgress,
      outputDirectory: outputDirectory,
      baseFileName: baseFileName,
    );
  }
}
