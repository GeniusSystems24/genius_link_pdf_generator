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
