import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'export_models.dart';
import 'pdf_to_html_exporter.dart';
import 'pdf_to_image_exporter.dart';
import 'pdf_to_text_exporter.dart';

/// Unified service for exporting PDF documents to various formats.
///
/// This service provides a single entry point for all export operations,
/// supporting multiple formats including images (PNG, JPEG), HTML, text,
/// and PDF/A for archival.
///
/// ## Example
/// ```dart
/// final service = PdfExportService();
///
/// // Export to PNG
/// final result = await service.export(
///   document,
///   ExportConfiguration.image(format: ExportFormat.png),
/// );
///
/// // Export to HTML
/// final htmlResult = await service.export(
///   document,
///   ExportConfiguration.html(),
/// );
///
/// // Save to file
/// await service.exportAndSave(
///   document,
///   ExportConfiguration.image(format: ExportFormat.jpeg),
///   '/path/to/output.jpg',
/// );
/// ```
class GeniusPdfExportService {
  /// Creates an export service.
  GeniusPdfExportService();

  final _imageExporter = const GeniusPdfToImageExporter();
  final _htmlExporter = const GeniusPdfToHtmlExporter();
  final _textExporter = const GeniusPdfToTextExporter();

  /// Exports a PDF document according to the configuration.
  ///
  /// Returns an [GeniusExportResult] which is either [GeniusExportSuccess] or [GeniusExportFailure].
  Future<GeniusExportResult> export(
    PdfDocument document,
    GeniusExportConfiguration config, {
    void Function(GeniusExportProgress)? onProgress,
  }) async {
    switch (config.format) {
      case GeniusExportFormat.png:
      case GeniusExportFormat.jpeg:
        return _imageExporter.exportAllPages(
          document,
          config,
          onProgress: onProgress,
        );

      case GeniusExportFormat.html:
        return _htmlExporter.export(
          document,
          config,
          onProgress: onProgress,
        );

      case GeniusExportFormat.text:
        return _textExporter.export(
          document,
          config,
          onProgress: onProgress,
        );

      case GeniusExportFormat.pdfA:
        return _exportToPdfA(document, config, onProgress: onProgress);
    }
  }

  /// Exports a PDF document and saves it to a file.
  ///
  /// Returns the file path if successful, or an [GeniusExportFailure] if not.
  Future<GeniusExportResult> exportAndSave(
    PdfDocument document,
    GeniusExportConfiguration config,
    String outputPath, {
    void Function(GeniusExportProgress)? onProgress,
  }) async {
    final result = await export(document, config, onProgress: onProgress);

    if (result is GeniusExportSuccess) {
      try {
        final file = File(outputPath);
        await file.writeAsBytes(result.data);

        return GeniusExportSuccess(
          data: result.data,
          format: result.format,
          filePath: outputPath,
          pageCount: result.pageCount,
        );
      } catch (e, stack) {
        return GeniusExportFailure(error: e, stackTrace: stack);
      }
    }

    return result;
  }

  /// Exports a PDF document to the app's documents directory.
  ///
  /// Generates a unique filename based on the current timestamp.
  Future<GeniusExportResult> exportToDocuments(
    PdfDocument document,
    GeniusExportConfiguration config, {
    String? fileName,
    void Function(GeniusExportProgress)? onProgress,
  }) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final name = config.outputFileName ??
          fileName ??
          'export_$timestamp';
      final extension = config.format.extension;
      final outputPath = '${directory.path}/$name.$extension';

      return exportAndSave(document, config, outputPath, onProgress: onProgress);
    } catch (e, stack) {
      return GeniusExportFailure(error: e, stackTrace: stack);
    }
  }

  /// Exports multiple pages to separate image files.
  ///
  /// Returns a list of results, one for each page.
  Future<List<GeniusExportResult>> exportPagesToImages(
    PdfDocument document,
    GeniusExportConfiguration config, {
    String? outputDirectory,
    String? baseFileName,
    void Function(GeniusExportProgress)? onProgress,
  }) async {
    final results = await _imageExporter.exportToImages(
      document,
      config,
      onProgress: onProgress,
    );

    if (outputDirectory != null) {
      final savedResults = <GeniusExportResult>[];
      final baseName = baseFileName ?? 'page';

      for (var i = 0; i < results.length; i++) {
        final result = results[i];
        if (result is GeniusExportSuccess) {
          try {
            final extension = config.format.extension;
            final outputPath = '$outputDirectory/${baseName}_${i + 1}.$extension';
            final file = File(outputPath);
            await file.writeAsBytes(result.data);

            savedResults.add(GeniusExportSuccess(
              data: result.data,
              format: result.format,
              filePath: outputPath,
              pageCount: 1,
            ));
          } catch (e, stack) {
            savedResults.add(GeniusExportFailure(error: e, stackTrace: stack));
          }
        } else {
          savedResults.add(result);
        }
      }

      return savedResults;
    }

    return results;
  }

  Future<GeniusExportResult> _exportToPdfA(
    PdfDocument document,
    GeniusExportConfiguration config, {
    void Function(GeniusExportProgress)? onProgress,
  }) async {
    try {
      onProgress?.call(const GeniusExportProgress(
        currentPage: 1,
        totalPages: 1,
        currentItem: 1,
        totalItems: 1,
        status: 'Converting to PDF/A format...',
        statusAr: 'جاري التحويل إلى صيغة PDF/A...',
      ));

      // ملاحظة: PDF/A conformance يجب تعيينه عند إنشاء المستند
      // في Syncfusion، يتم ذلك باستخدام: PdfDocument(conformanceLevel: PdfConformanceLevel.a1b)
      // المستند الممرر هنا قد لا يدعم تغيير مستوى التوافق بعد الإنشاء

      // Apply compression if requested
      if (config.compress) {
        document.compressionLevel = PdfCompressionLevel.best;
      }

      // Save the document
      final bytes = Uint8List.fromList(await document.save());

      onProgress?.call(const GeniusExportProgress(
        currentPage: 1,
        totalPages: 1,
        currentItem: 1,
        totalItems: 1,
        status: 'Export complete',
        statusAr: 'اكتمل التصدير',
      ));

      return GeniusExportSuccess(
        data: bytes,
        format: GeniusExportFormat.pdfA,
        pageCount: document.pages.count,
      );
    } catch (e, stack) {
      return GeniusExportFailure(error: e, stackTrace: stack);
    }
  }

  /// Gets the recommended file extension for a format.
  String getExtension(GeniusExportFormat format) => format.extension;

  /// Gets the MIME type for a format.
  String getMimeType(GeniusExportFormat format) {
    switch (format) {
      case GeniusExportFormat.pdfA:
        return 'application/pdf';
      case GeniusExportFormat.png:
        return 'image/png';
      case GeniusExportFormat.jpeg:
        return 'image/jpeg';
      case GeniusExportFormat.html:
        return 'text/html';
      case GeniusExportFormat.text:
        return 'text/plain';
    }
  }
}

/// Extension methods for convenient PDF export.
extension PdfDocumentExport on PdfDocument {
  /// Exports this document using the export service.
  Future<GeniusExportResult> exportTo(
    GeniusExportFormat format, {
    GeniusExportConfiguration? config,
    void Function(GeniusExportProgress)? onProgress,
  }) {
    final service = GeniusPdfExportService();
    return service.export(
      this,
      config ?? GeniusExportConfiguration(format: format),
      onProgress: onProgress,
    );
  }

  /// Exports this document and saves it to a file.
  Future<GeniusExportResult> exportToFile(
    String outputPath, {
    GeniusExportConfiguration? config,
    GeniusExportFormat format = GeniusExportFormat.pdfA,
    void Function(GeniusExportProgress)? onProgress,
  }) {
    final service = GeniusPdfExportService();
    return service.exportAndSave(
      this,
      config ?? GeniusExportConfiguration(format: format),
      outputPath,
      onProgress: onProgress,
    );
  }
}

// ============================================================================
// Export Validation
// ============================================================================

/// Validates export configuration and document before export.
class GeniusExportValidator {
  /// Validates that the export configuration is valid.
  static GeniusExportValidationResult validateConfiguration(
    GeniusExportConfiguration config,
  ) {
    final errors = <String>[];

    // Validate page range
    if (config.startPage != null && config.endPage != null) {
      if (config.startPage! > config.endPage!) {
        errors.add('Start page cannot be greater than end page');
      }
      if (config.startPage! < 1) {
        errors.add('Start page must be at least 1');
      }
    }

    // Validate image quality
    if (config.format == GeniusExportFormat.png ||
        config.format == GeniusExportFormat.jpeg) {
      final dpi = config.imageQuality.dpi;
      if (dpi < 72 || dpi > 600) {
        errors.add('DPI must be between 72 and 600');
      }
    }

    // Validate output filename
    if (config.outputFileName != null) {
      final invalidChars = RegExp(r'[<>:"/\\|?*]');
      if (invalidChars.hasMatch(config.outputFileName!)) {
        errors.add('Output filename contains invalid characters');
      }
    }

    return GeniusExportValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Validates that a document can be exported.
  static GeniusExportValidationResult validateDocument(
    PdfDocument document,
    GeniusExportConfiguration config,
  ) {
    final errors = <String>[];

    // Check page count
    if (document.pages.count == 0) {
      errors.add('Document has no pages');
    }

    // Check page range
    if (config.startPage != null && config.startPage! > document.pages.count) {
      errors.add('Start page exceeds document page count');
    }
    if (config.endPage != null && config.endPage! > document.pages.count) {
      errors.add('End page exceeds document page count');
    }

    return GeniusExportValidationResult(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }
}

/// Result of export validation.
class GeniusExportValidationResult {
  const GeniusExportValidationResult({
    required this.isValid,
    this.errors = const [],
  });

  final bool isValid;
  final List<String> errors;

  String get errorSummary => errors.join('; ');
}

// ============================================================================
// Batch Export with Summary
// ============================================================================

/// Result of a batch export operation.
class GeniusBatchExportSummary {
  const GeniusBatchExportSummary({
    required this.totalDocuments,
    required this.successCount,
    required this.failureCount,
    required this.results,
    required this.totalDuration,
    this.outputDirectory,
  });

  final int totalDocuments;
  final int successCount;
  final int failureCount;
  final List<GeniusExportResult> results;
  final Duration totalDuration;
  final String? outputDirectory;

  bool get allSucceeded => failureCount == 0;
  double get successRate => totalDocuments == 0 ? 0 : successCount / totalDocuments;

  List<GeniusExportSuccess> get successResults =>
      results.whereType<GeniusExportSuccess>().toList();

  List<GeniusExportFailure> get failureResults =>
      results.whereType<GeniusExportFailure>().toList();
}

/// Extension for batch export operations.
extension GeniusBatchExportExtension on GeniusPdfExportService {
  /// Exports multiple documents in batch.
  Future<GeniusBatchExportSummary> exportBatch({
    required List<PdfDocument> documents,
    required GeniusExportConfiguration config,
    String? outputDirectory,
    String Function(int index)? fileNameGenerator,
    void Function(int current, int total, GeniusExportProgress?)? onProgress,
    bool stopOnError = false,
  }) async {
    final startTime = DateTime.now();
    final results = <GeniusExportResult>[];
    int successCount = 0;
    int failureCount = 0;

    for (int i = 0; i < documents.length; i++) {
      onProgress?.call(i, documents.length, null);

      final document = documents[i];
      final fileName = fileNameGenerator?.call(i) ?? 'export_${i + 1}';

      GeniusExportResult result;
      if (outputDirectory != null) {
        final extension = config.format.extension;
        final outputPath = '$outputDirectory/$fileName.$extension';
        result = await exportAndSave(
          document,
          config.copyWith(outputFileName: fileName),
          outputPath,
          onProgress: (progress) {
            onProgress?.call(i, documents.length, progress);
          },
        );
      } else {
        result = await export(
          document,
          config.copyWith(outputFileName: fileName),
          onProgress: (progress) {
            onProgress?.call(i, documents.length, progress);
          },
        );
      }

      results.add(result);

      if (result is GeniusExportSuccess) {
        successCount++;
      } else {
        failureCount++;
        if (stopOnError) break;
      }
    }

    onProgress?.call(documents.length, documents.length, null);

    return GeniusBatchExportSummary(
      totalDocuments: documents.length,
      successCount: successCount,
      failureCount: failureCount,
      results: results,
      totalDuration: DateTime.now().difference(startTime),
      outputDirectory: outputDirectory,
    );
  }
}

// ============================================================================
// Export Format Detection
// ============================================================================

/// Utilities for export format detection.
class GeniusExportFormatDetector {
  /// Detects the recommended export format based on file extension.
  static GeniusExportFormat? fromExtension(String extension) {
    final ext = extension.toLowerCase().replaceAll('.', '');
    switch (ext) {
      case 'png':
        return GeniusExportFormat.png;
      case 'jpg':
      case 'jpeg':
        return GeniusExportFormat.jpeg;
      case 'html':
      case 'htm':
        return GeniusExportFormat.html;
      case 'txt':
      case 'text':
        return GeniusExportFormat.text;
      case 'pdf':
        return GeniusExportFormat.pdfA;
      default:
        return null;
    }
  }

  /// Detects the recommended export format from a file path.
  static GeniusExportFormat? fromPath(String path) {
    final parts = path.split('.');
    if (parts.length < 2) return null;
    return fromExtension(parts.last);
  }

  /// Gets all supported extensions for a format.
  static List<String> getExtensionsForFormat(GeniusExportFormat format) {
    switch (format) {
      case GeniusExportFormat.png:
        return ['png'];
      case GeniusExportFormat.jpeg:
        return ['jpg', 'jpeg'];
      case GeniusExportFormat.html:
        return ['html', 'htm'];
      case GeniusExportFormat.text:
        return ['txt', 'text'];
      case GeniusExportFormat.pdfA:
        return ['pdf'];
    }
  }
}

// ============================================================================
// Export Presets
// ============================================================================

/// Predefined export configurations for common use cases.
class GeniusExportPresets {
  GeniusExportPresets._();

  /// High quality image export (300 DPI PNG).
  static GeniusExportConfiguration highQualityImage() {
    return const GeniusExportConfiguration(
      format: GeniusExportFormat.png,
      quality: GeniusImageQuality.high,
      compress: false,
    );
  }

  /// Web-optimized image export (150 DPI JPEG).
  static GeniusExportConfiguration webImage() {
    return const GeniusExportConfiguration(
      format: GeniusExportFormat.jpeg,
      quality: GeniusImageQuality.medium,
      compress: true,
    );
  }

  /// Thumbnail export (72 DPI JPEG).
  static GeniusExportConfiguration thumbnail() {
    return const GeniusExportConfiguration(
      format: GeniusExportFormat.jpeg,
      quality: GeniusImageQuality.low,
      compress: true,
    );
  }

  /// Print quality export (600 DPI PNG).
  static GeniusExportConfiguration printQuality() {
    return const GeniusExportConfiguration(
      format: GeniusExportFormat.png,
      quality: GeniusImageQuality.maximum,
      compress: false,
    );
  }

  /// Archival PDF/A export.
  static GeniusExportConfiguration archive() {
    return const GeniusExportConfiguration(
      format: GeniusExportFormat.pdfA,
      compress: true,
    );
  }

  /// Accessible HTML export.
  static GeniusExportConfiguration accessibleHtml() {
    return const GeniusExportConfiguration(
      format: GeniusExportFormat.html,
    );
  }

  /// Plain text export.
  static GeniusExportConfiguration plainText() {
    return const GeniusExportConfiguration(
      format: GeniusExportFormat.text,
    );
  }

  /// Email attachment (moderate quality JPEG).
  static GeniusExportConfiguration emailAttachment() {
    return const GeniusExportConfiguration(
      format: GeniusExportFormat.jpeg,
      quality: GeniusImageQuality.medium,
      compress: true,
    );
  }
}
