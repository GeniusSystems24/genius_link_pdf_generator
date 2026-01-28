import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

import '../builders/pdf_document_builder.dart';
import '../models/pdf_result.dart';

/// Callback for progress updates during PDF operations
typedef GeniusPdfProgressCallback = void Function(double progress, String? message);

/// Cancellation token for PDF operations
class GeniusPdfCancellationToken {
  bool _isCancelled = false;
  final _completer = Completer<void>();

  /// Whether cancellation has been requested
  bool get isCancelled => _isCancelled;

  /// Future that completes when cancelled
  Future<void> get whenCancelled => _completer.future;

  /// Request cancellation
  void cancel() {
    if (!_isCancelled) {
      _isCancelled = true;
      _completer.complete();
    }
  }

  /// Throws if cancellation was requested
  void throwIfCancelled() {
    if (_isCancelled) {
      throw GeniusPdfCancelledException();
    }
  }
}

/// Exception thrown when operation is cancelled
class GeniusPdfCancelledException implements Exception {
  @override
  String toString() => 'PDF operation was cancelled';
}

/// Result of a PDF merge operation
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
  }) {
    return GeniusPdfMergeResult(
      success: true,
      bytes: bytes,
      filePath: filePath,
      mergedCount: mergedCount,
    );
  }

  factory GeniusPdfMergeResult.failure(String error) {
    return GeniusPdfMergeResult(success: false, error: error);
  }

  final bool success;
  final Uint8List? bytes;
  final String? filePath;
  final String? error;
  final int mergedCount;
}

/// Result of a PDF split operation
class GeniusPdfSplitResult {
  const GeniusPdfSplitResult({
    required this.success,
    this.files = const [],
    this.error,
  });

  factory GeniusPdfSplitResult.success(List<GeniusPdfSplitFile> files) {
    return GeniusPdfSplitResult(success: true, files: files);
  }

  factory GeniusPdfSplitResult.failure(String error) {
    return GeniusPdfSplitResult(success: false, error: error);
  }

  final bool success;
  final List<GeniusPdfSplitFile> files;
  final String? error;

  int get fileCount => files.length;
}

/// A split PDF file
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

/// PDF metadata information
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

/// PDF information extracted from a document
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
    if (fileSizeBytes < 1024 * 1024) return '${(fileSizeBytes / 1024).toStringAsFixed(1)} KB';
    return '${(fileSizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

/// Service for handling PDF generation, saving, and sharing operations.
///
/// This service provides methods to generate PDFs from builders,
/// save them to disk, open them, and share them. All operations
/// support both foreground and background execution.
///
/// ## Example
/// ```dart
/// final service = PdfService();
///
/// // Generate and open a PDF
/// final result = await service.generateAndOpen(
///   builder: invoiceBuilder,
///   fileName: 'invoice_123',
///   onStart: () => showLoading(),
///   onComplete: (result) => hideLoading(),
/// );
///
/// // Handle result
/// result.when(
///   onSuccess: (success) => print('Saved to: ${success.filePath}'),
///   onFailure: (failure) => print('Error: ${failure.message}'),
/// );
/// ```
class GeniusPdfService {
  /// Creates a new [GeniusPdfService] instance.
  const GeniusPdfService();

  /// Generates a PDF from the given builder and returns the bytes.
  ///
  /// ## Parameters
  /// - [builder]: The document builder to generate from (required).
  /// - [runInBackground]: Run generation in a separate isolate.
  ///
  /// ## Returns
  /// A [GeniusPdfResult] containing the generated bytes or an error.
  Future<GeniusPdfResult> generate({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    bool runInBackground = true,
  }) async {
    try {
      List<int> bytes;

      if (runInBackground) {
        bytes = await compute(_generatePdfBytes, builder);
      } else {
        bytes = builder.generate();
      }

      return GeniusPdfSuccess(
        bytes: Uint8List.fromList(bytes),
        fileName: fileName,
      );
    } catch (e, st) {
      Logger().e('Error generating PDF: $e', stackTrace: st);
      return GeniusPdfFailure.fromException(e, st);
    } finally {
      builder.dispose();
    }
  }

  /// Generates a PDF and saves it to the documents directory.
  ///
  /// ## Parameters
  /// - [builder]: The document builder to generate from (required).
  /// - [fileName]: Name of the file (without extension).
  /// - [runInBackground]: Run generation in a separate isolate.
  ///
  /// ## Returns
  /// A [GeniusPdfResult] with the file path on success.
  Future<GeniusPdfResult> generateAndSave({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    bool runInBackground = true,
  }) async {
    try {
      List<int> bytes;

      if (runInBackground) {
        bytes = await compute(_generatePdfBytes, builder);
      } else {
        bytes = builder.generate();
      }

      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/$fileName.pdf';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      return GeniusPdfSuccess(
        bytes: Uint8List.fromList(bytes),
        fileName: fileName,
        filePath: filePath,
      );
    } catch (e, st) {
      Logger().e('Error generating PDF: $e', stackTrace: st);
      return GeniusPdfFailure.fromException(e, st);
    } finally {
      builder.dispose();
    }
  }

  /// Generates a PDF, saves it, and opens it with the default viewer.
  ///
  /// ## Parameters
  /// - [builder]: The document builder to generate from (required).
  /// - [fileName]: Name of the file (without extension).
  /// - [onStart]: Called when generation starts.
  /// - [onComplete]: Called when generation completes successfully.
  /// - [onError]: Called if an error occurs.
  /// - [runInBackground]: Run generation in a separate isolate.
  ///
  /// ## Returns
  /// A [GeniusPdfResult] with the file path on success.
  Future<GeniusPdfResult> generateAndOpen({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    PdfGenerationCallback? onStart,
    PdfSuccessCallback? onComplete,
    PdfErrorCallback? onError,
    bool runInBackground = true,
  }) async {
    onStart?.call();

    try {
      final result = await generateAndSave(
        builder: builder,
        fileName: fileName,
        runInBackground: runInBackground,
      );

      return result.when(
        onSuccess: (success) async {
          await OpenFile.open(success.filePath!);
          onComplete?.call(success);
          return success;
        },
        onFailure: (failure) {
          onError?.call(failure);
          return failure;
        },
      );
    } catch (e, st) {
      Logger().e('Error generating PDF: $e', stackTrace: st);
      final failure = GeniusPdfFailure.fromException(e, st);
      onError?.call(failure);
      return failure;
    }
  }

  /// Generates a PDF and shares it using the system share dialog.
  ///
  /// ## Parameters
  /// - [builder]: The document builder to generate from (required).
  /// - [fileName]: Name of the file (without extension).
  /// - [onStart]: Called when generation starts.
  /// - [onComplete]: Called when sharing is initiated.
  /// - [onError]: Called if an error occurs.
  /// - [runInBackground]: Run generation in a separate isolate.
  ///
  /// ## Returns
  /// A [GeniusPdfResult] on success.
  Future<GeniusPdfResult> generateAndShare({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    PdfGenerationCallback? onStart,
    PdfSuccessCallback? onComplete,
    PdfErrorCallback? onError,
    bool runInBackground = true,
  }) async {
    onStart?.call();

    try {
      final result = await generate(
        builder: builder,
        fileName: fileName,
        runInBackground: runInBackground,
      );

      return result.when(
        onSuccess: (success) async {
          await Printing.sharePdf(
            bytes: success.bytes,
            filename: '$fileName.pdf',
          );
          onComplete?.call(success);
          return success;
        },
        onFailure: (failure) {
          onError?.call(failure);
          return failure;
        },
      );
    } catch (e, st) {
      Logger().e('Error generating PDF: $e', stackTrace: st);
      final failure = GeniusPdfFailure.fromException(e, st);
      onError?.call(failure);
      return failure;
    }
  }

  /// Prints a PDF using the system print dialog.
  ///
  /// ## Parameters
  /// - [bytes]: The PDF bytes to print (required).
  /// - [documentName]: Name for the print job.
  Future<bool> print({
    required Uint8List bytes,
    required String documentName,
  }) async {
    return Printing.layoutPdf(
      onLayout: (_) => bytes,
      name: documentName,
    );
  }

  /// Saves PDF bytes to a specific path.
  ///
  /// ## Parameters
  /// - [bytes]: The PDF bytes to save (required).
  /// - [path]: Full path including filename (required).
  Future<File> saveToPath({
    required Uint8List bytes,
    required String path,
  }) async {
    final file = File(path);
    await file.writeAsBytes(bytes);
    return file;
  }

  /// Shares PDF with custom options using share_plus.
  ///
  /// ## Parameters
  /// - [bytes]: The PDF bytes to share (required).
  /// - [fileName]: Name of the file (required).
  /// - [subject]: Email subject or share title.
  /// - [text]: Additional text to share with the PDF.
  Future<ShareResult?> shareWithOptions({
    required Uint8List bytes,
    required String fileName,
    String? subject,
    String? text,
  }) async {
    try {
      final dir = await getTemporaryDirectory();
      final effectiveFileName = fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';
      final file = File('${dir.path}/$effectiveFileName');
      await file.writeAsBytes(bytes);

      final result = await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: subject,
          text: text,
        ),
      );

      return result;
    } catch (e) {
      Logger().e('Error sharing PDF: $e');
      return null;
    }
  }

  /// Merges multiple PDF files into one.
  ///
  /// ## Parameters
  /// - [pdfBytesList]: List of PDF bytes to merge.
  /// - [outputFileName]: Name for the merged file.
  /// - [saveToFile]: Whether to save to file.
  /// - [onProgress]: Progress callback.
  /// - [cancellationToken]: Token to cancel the operation.
  Future<GeniusPdfMergeResult> mergePdfs({
    required List<Uint8List> pdfBytesList,
    required String outputFileName,
    bool saveToFile = false,
    GeniusPdfProgressCallback? onProgress,
    GeniusPdfCancellationToken? cancellationToken,
  }) async {
    if (pdfBytesList.isEmpty) {
      return GeniusPdfMergeResult.failure('No PDFs provided to merge');
    }

    if (pdfBytesList.length == 1) {
      return GeniusPdfMergeResult.success(
        bytes: pdfBytesList.first,
        mergedCount: 1,
      );
    }

    try {
      onProgress?.call(0.0, 'Starting merge...');
      cancellationToken?.throwIfCancelled();

      // Create destination document
      final mergedDoc = sf.PdfDocument();

      int processedCount = 0;
      for (final pdfBytes in pdfBytesList) {
        cancellationToken?.throwIfCancelled();

        // Load source document
        final sourceDoc = sf.PdfDocument(inputBytes: pdfBytes);

        // Import all pages
        for (int i = 0; i < sourceDoc.pages.count; i++) {
          mergedDoc.pages.add().graphics.drawPdfTemplate(
            sourceDoc.pages[i].createTemplate(),
            const Offset(0, 0),
          );
        }

        sourceDoc.dispose();
        processedCount++;

        final progress = processedCount / pdfBytesList.length;
        onProgress?.call(progress, 'Merged $processedCount of ${pdfBytesList.length} PDFs');
      }

      cancellationToken?.throwIfCancelled();
      onProgress?.call(0.95, 'Finalizing...');

      // Save merged document
      final bytes = Uint8List.fromList(await mergedDoc.save());
      mergedDoc.dispose();

      String? filePath;
      if (saveToFile) {
        final dir = await getApplicationDocumentsDirectory();
        final effectiveFileName = outputFileName.endsWith('.pdf') ? outputFileName : '$outputFileName.pdf';
        filePath = '${dir.path}/$effectiveFileName';
        await File(filePath).writeAsBytes(bytes);
      }

      onProgress?.call(1.0, 'Merge complete');

      return GeniusPdfMergeResult.success(
        bytes: bytes,
        filePath: filePath,
        mergedCount: pdfBytesList.length,
      );
    } on GeniusPdfCancelledException {
      return GeniusPdfMergeResult.failure('Merge cancelled');
    } catch (e) {
      Logger().e('Error merging PDFs: $e');
      return GeniusPdfMergeResult.failure(e.toString());
    }
  }

  /// Splits a PDF into multiple files.
  ///
  /// ## Parameters
  /// - [pdfBytes]: The PDF bytes to split.
  /// - [baseFileName]: Base name for split files.
  /// - [pagesPerFile]: Number of pages per split file (null = one page per file).
  /// - [pageRanges]: Specific page ranges to extract (e.g., [[1,3], [4,6]]).
  /// - [saveToFiles]: Whether to save split files.
  /// - [onProgress]: Progress callback.
  Future<GeniusPdfSplitResult> splitPdf({
    required Uint8List pdfBytes,
    required String baseFileName,
    int? pagesPerFile,
    List<List<int>>? pageRanges,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
  }) async {
    try {
      onProgress?.call(0.0, 'Loading PDF...');

      final sourceDoc = sf.PdfDocument(inputBytes: pdfBytes);
      final totalPages = sourceDoc.pages.count;

      if (totalPages == 0) {
        sourceDoc.dispose();
        return GeniusPdfSplitResult.failure('PDF has no pages');
      }

      final splitFiles = <GeniusPdfSplitFile>[];
      final Directory? saveDir = saveToFiles ? await getApplicationDocumentsDirectory() : null;

      // Determine page ranges
      List<List<int>> ranges;
      if (pageRanges != null && pageRanges.isNotEmpty) {
        ranges = pageRanges;
      } else if (pagesPerFile != null && pagesPerFile > 0) {
        ranges = [];
        for (int i = 0; i < totalPages; i += pagesPerFile) {
          final end = (i + pagesPerFile - 1).clamp(0, totalPages - 1);
          ranges.add([i, end]);
        }
      } else {
        // One page per file
        ranges = List.generate(totalPages, (i) => [i, i]);
      }

      for (int rangeIndex = 0; rangeIndex < ranges.length; rangeIndex++) {
        final range = ranges[rangeIndex];
        final startPage = range[0].clamp(0, totalPages - 1);
        final endPage = range[1].clamp(startPage, totalPages - 1);

        onProgress?.call(
          (rangeIndex + 1) / ranges.length * 0.9,
          'Splitting pages ${startPage + 1}-${endPage + 1}...',
        );

        // Create new document for this range
        final splitDoc = sf.PdfDocument();

        for (int pageIndex = startPage; pageIndex <= endPage; pageIndex++) {
          splitDoc.pages.add().graphics.drawPdfTemplate(
            sourceDoc.pages[pageIndex].createTemplate(),
            const Offset(0, 0),
          );
        }

        final bytes = Uint8List.fromList(await splitDoc.save());
        splitDoc.dispose();

        final fileName = '${baseFileName}_${rangeIndex + 1}.pdf';
        String? filePath;

        if (saveToFiles && saveDir != null) {
          filePath = '${saveDir.path}/$fileName';
          await File(filePath).writeAsBytes(bytes);
        }

        splitFiles.add(GeniusPdfSplitFile(
          bytes: bytes,
          fileName: fileName,
          pageStart: startPage + 1, // 1-indexed for user display
          pageEnd: endPage + 1,
          filePath: filePath,
        ));
      }

      sourceDoc.dispose();
      onProgress?.call(1.0, 'Split complete');

      return GeniusPdfSplitResult.success(splitFiles);
    } catch (e) {
      Logger().e('Error splitting PDF: $e');
      return GeniusPdfSplitResult.failure(e.toString());
    }
  }

  /// Gets information about a PDF document.
  ///
  /// ## Parameters
  /// - [pdfBytes]: The PDF bytes to analyze.
  Future<GeniusPdfInfo?> getPdfInfo(Uint8List pdfBytes) async {
    try {
      final doc = sf.PdfDocument(inputBytes: pdfBytes);

      final info = GeniusPdfInfo(
        pageCount: doc.pages.count,
        fileSizeBytes: pdfBytes.length,
        metadata: GeniusPdfMetadata(
          title: doc.documentInformation.title,
          author: doc.documentInformation.author,
          subject: doc.documentInformation.subject,
          keywords: doc.documentInformation.keywords,
          creator: doc.documentInformation.creator,
          producer: doc.documentInformation.producer,
          creationDate: doc.documentInformation.creationDate,
          modificationDate: doc.documentInformation.modificationDate,
        ),
        isEncrypted: doc.security.encryptionOptions != sf.PdfEncryptionOptions.encryptAllContents,
      );

      doc.dispose();
      return info;
    } catch (e) {
      Logger().e('Error getting PDF info: $e');
      return null;
    }
  }

  /// Extracts specific pages from a PDF.
  ///
  /// ## Parameters
  /// - [pdfBytes]: Source PDF bytes.
  /// - [pageNumbers]: Page numbers to extract (1-indexed).
  /// - [outputFileName]: Name for the output file.
  Future<GeniusPdfResult> extractPages({
    required Uint8List pdfBytes,
    required List<int> pageNumbers,
    required String outputFileName,
  }) async {
    try {
      final sourceDoc = sf.PdfDocument(inputBytes: pdfBytes);
      final totalPages = sourceDoc.pages.count;

      // Validate page numbers
      final validPages = pageNumbers
          .where((p) => p >= 1 && p <= totalPages)
          .toSet()
          .toList()
        ..sort();

      if (validPages.isEmpty) {
        sourceDoc.dispose();
        return GeniusPdfFailure(message: 'No valid pages to extract');
      }

      final extractedDoc = sf.PdfDocument();

      for (final pageNum in validPages) {
        extractedDoc.pages.add().graphics.drawPdfTemplate(
          sourceDoc.pages[pageNum - 1].createTemplate(),
          const Offset(0, 0),
        );
      }

      final bytes = Uint8List.fromList(await extractedDoc.save());
      extractedDoc.dispose();
      sourceDoc.dispose();

      return GeniusPdfSuccess(
        bytes: bytes,
        fileName: outputFileName,
      );
    } catch (e, st) {
      Logger().e('Error extracting pages: $e', stackTrace: st);
      return GeniusPdfFailure.fromException(e, st);
    }
  }

  /// Adds a watermark to all pages of a PDF.
  ///
  /// ## Parameters
  /// - [pdfBytes]: Source PDF bytes.
  /// - [watermarkText]: Text to use as watermark.
  /// - [opacity]: Watermark opacity (0.0 - 1.0).
  /// - [rotation]: Rotation angle in degrees.
  /// - [fontSize]: Font size for watermark text.
  Future<GeniusPdfResult> addWatermark({
    required Uint8List pdfBytes,
    required String watermarkText,
    double opacity = 0.3,
    double rotation = -45,
    double fontSize = 72,
    String outputFileName = 'watermarked',
  }) async {
    try {
      final doc = sf.PdfDocument(inputBytes: pdfBytes);

      final brush = sf.PdfSolidBrush(
        sf.PdfColor(128, 128, 128, (opacity * 255).toInt()),
      );

      final font = sf.PdfStandardFont(sf.PdfFontFamily.helvetica, fontSize);

      for (int i = 0; i < doc.pages.count; i++) {
        final page = doc.pages[i];
        final graphics = page.graphics;

        // Save graphics state
        graphics.save();

        // Move to center and rotate
        graphics.translateTransform(
          page.size.width / 2,
          page.size.height / 2,
        );
        graphics.rotateTransform(rotation);

        // Draw watermark text centered
        final size = font.measureString(watermarkText);
        graphics.drawString(
          watermarkText,
          font,
          brush: brush,
          bounds: Rect.fromCenter(
            center: Offset.zero,
            width: size.width,
            height: size.height,
          ),
        );

        // Restore graphics state
        graphics.restore();
      }

      final bytes = Uint8List.fromList(await doc.save());
      doc.dispose();

      return GeniusPdfSuccess(
        bytes: bytes,
        fileName: outputFileName,
      );
    } catch (e, st) {
      Logger().e('Error adding watermark: $e', stackTrace: st);
      return GeniusPdfFailure.fromException(e, st);
    }
  }

  /// Rotates pages in a PDF.
  ///
  /// ## Parameters
  /// - [pdfBytes]: Source PDF bytes.
  /// - [rotation]: Rotation angle (90, 180, 270).
  /// - [pageNumbers]: Pages to rotate (null = all pages).
  Future<GeniusPdfResult> rotatePages({
    required Uint8List pdfBytes,
    required int rotation,
    List<int>? pageNumbers,
    String outputFileName = 'rotated',
  }) async {
    if (rotation % 90 != 0) {
      return GeniusPdfFailure(message: 'Rotation must be a multiple of 90');
    }

    try {
      final doc = sf.PdfDocument(inputBytes: pdfBytes);

      final pagesToRotate = pageNumbers ?? List.generate(doc.pages.count, (i) => i + 1);

      for (final pageNum in pagesToRotate) {
        if (pageNum >= 1 && pageNum <= doc.pages.count) {
          final page = doc.pages[pageNum - 1];
          final currentRotation = page.rotation.index * 90;
          final newRotation = (currentRotation + rotation) % 360;

          page.rotation = sf.PdfPageRotateAngle.values[newRotation ~/ 90];
        }
      }

      final bytes = Uint8List.fromList(await doc.save());
      doc.dispose();

      return GeniusPdfSuccess(
        bytes: bytes,
        fileName: outputFileName,
      );
    } catch (e, st) {
      Logger().e('Error rotating pages: $e', stackTrace: st);
      return GeniusPdfFailure.fromException(e, st);
    }
  }

  /// Generates multiple PDFs in batch.
  ///
  /// ## Parameters
  /// - [builders]: List of builders and their file names.
  /// - [saveToFiles]: Whether to save files.
  /// - [onProgress]: Progress callback.
  /// - [onItemComplete]: Callback when each item completes.
  Future<List<GeniusPdfResult>> generateBatch({
    required List<({GeniusPdfDocumentBuilder builder, String fileName})> builders,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
    void Function(int index, GeniusPdfResult result)? onItemComplete,
  }) async {
    final results = <GeniusPdfResult>[];

    for (int i = 0; i < builders.length; i++) {
      final item = builders[i];
      onProgress?.call(i / builders.length, 'Generating ${i + 1} of ${builders.length}...');

      final result = saveToFiles
          ? await generateAndSave(builder: item.builder, fileName: item.fileName)
          : await generate(builder: item.builder, fileName: item.fileName);

      results.add(result);
      onItemComplete?.call(i, result);
    }

    onProgress?.call(1.0, 'Batch complete');
    return results;
  }
}

/// Helper function for compute isolate.
List<int> _generatePdfBytes(GeniusPdfDocumentBuilder builder) {
  return builder.generate();
}
