import 'dart:typed_data';

import '../../domain/models/pdf_operations.dart';
import '../../domain/models/pdf_result.dart';
import '../contracts/pdf_document_processor.dart';

/// Application use cases for transformations on existing PDF documents.
class GeniusPdfDocumentApplicationService {
  const GeniusPdfDocumentApplicationService({required this.processor});

  final GeniusPdfDocumentProcessor processor;

  Future<GeniusPdfMergeResult> mergePdfs({
    required List<Uint8List> pdfBytesList,
    required String outputFileName,
    bool saveToFile = false,
    GeniusPdfProgressCallback? onProgress,
    GeniusPdfCancellationToken? cancellationToken,
  }) {
    if (pdfBytesList.isEmpty || pdfBytesList.any((bytes) => bytes.isEmpty)) {
      return Future<GeniusPdfMergeResult>.value(
        GeniusPdfMergeResult.failure('All PDF inputs must contain data.'),
      );
    }
    return processor.mergePdfs(
      pdfBytesList: pdfBytesList,
      outputFileName: outputFileName,
      saveToFile: saveToFile,
      onProgress: onProgress,
      cancellationToken: cancellationToken,
    );
  }

  Future<GeniusPdfSplitResult> splitPdf({
    required Uint8List pdfBytes,
    required String baseFileName,
    int? pagesPerFile,
    List<List<int>>? pageRanges,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
  }) {
    if (pdfBytes.isEmpty) {
      return Future<GeniusPdfSplitResult>.value(
        GeniusPdfSplitResult.failure('PDF data must not be empty.'),
      );
    }
    if (pagesPerFile != null && pagesPerFile <= 0) {
      return Future<GeniusPdfSplitResult>.value(
        GeniusPdfSplitResult.failure('pagesPerFile must be greater than zero.'),
      );
    }
    if (pageRanges != null &&
        pageRanges.any(
          (range) => range.length < 2 || range[0] < 0 || range[1] < range[0],
        )) {
      return Future<GeniusPdfSplitResult>.value(
        GeniusPdfSplitResult.failure('One or more page ranges are invalid.'),
      );
    }
    return processor.splitPdf(
      pdfBytes: pdfBytes,
      baseFileName: baseFileName,
      pagesPerFile: pagesPerFile,
      pageRanges: pageRanges,
      saveToFiles: saveToFiles,
      onProgress: onProgress,
    );
  }

  Future<GeniusPdfInfo?> getPdfInfo(Uint8List pdfBytes) {
    if (pdfBytes.isEmpty) return Future<GeniusPdfInfo?>.value();
    return processor.getPdfInfo(pdfBytes);
  }

  Future<GeniusPdfResult> extractPages({
    required Uint8List pdfBytes,
    required List<int> pageNumbers,
    required String outputFileName,
  }) {
    if (pdfBytes.isEmpty) {
      return Future<GeniusPdfResult>.value(
        const GeniusPdfFailure(
          error: 'Empty PDF input',
          message: 'PDF data must not be empty.',
        ),
      );
    }
    if (pageNumbers.isEmpty) {
      return Future<GeniusPdfResult>.value(
        const GeniusPdfFailure(
          error: 'No pages selected',
          message: 'At least one page number is required.',
        ),
      );
    }
    return processor.extractPages(
      pdfBytes: pdfBytes,
      pageNumbers: pageNumbers,
      outputFileName: outputFileName,
    );
  }

  Future<GeniusPdfResult> addWatermark({
    required Uint8List pdfBytes,
    required String watermarkText,
    double opacity = 0.3,
    double rotation = -45,
    double fontSize = 72,
    String outputFileName = 'watermarked',
    GeniusPdfTextFlow textDirection = GeniusPdfTextFlow.ltr,
  }) {
    if (pdfBytes.isEmpty) {
      return Future<GeniusPdfResult>.value(
        const GeniusPdfFailure(
          error: 'Empty PDF input',
          message: 'PDF data must not be empty.',
        ),
      );
    }
    if (watermarkText.trim().isEmpty) {
      return Future<GeniusPdfResult>.value(
        const GeniusPdfFailure(
          error: 'Empty watermark',
          message: 'Watermark text must not be empty.',
        ),
      );
    }
    if (fontSize <= 0) {
      return Future<GeniusPdfResult>.value(
        const GeniusPdfFailure(
          error: 'Invalid watermark font size',
          message: 'Watermark font size must be greater than zero.',
        ),
      );
    }
    return processor.addWatermark(
      pdfBytes: pdfBytes,
      watermarkText: watermarkText,
      opacity: opacity.clamp(0.0, 1.0).toDouble(),
      rotation: rotation,
      fontSize: fontSize,
      outputFileName: outputFileName,
      textDirection: textDirection,
    );
  }

  Future<GeniusPdfResult> rotatePages({
    required Uint8List pdfBytes,
    required int rotation,
    List<int>? pageNumbers,
    String outputFileName = 'rotated',
  }) {
    if (pdfBytes.isEmpty) {
      return Future<GeniusPdfResult>.value(
        const GeniusPdfFailure(
          error: 'Empty PDF input',
          message: 'PDF data must not be empty.',
        ),
      );
    }
    if (rotation % 90 != 0) {
      return Future<GeniusPdfResult>.value(
        const GeniusPdfFailure(
          error: 'Invalid rotation',
          message: 'Rotation must be a multiple of 90 degrees.',
        ),
      );
    }
    return processor.rotatePages(
      pdfBytes: pdfBytes,
      rotation: rotation,
      pageNumbers: pageNumbers,
      outputFileName: outputFileName,
    );
  }
}
