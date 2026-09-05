import 'dart:typed_data';
import 'dart:ui';

import '../../app/services/pdf_document_service.dart';
import '../../app/services/pdf_generation_service.dart';
import '../../app/contracts/pdf_generation_ports.dart';
import '../../domain/models/pdf_operations.dart';
import '../../domain/models/pdf_result.dart';

/// MVC controller coordinating PDF use cases for public facades and views.
class GeniusPdfController {
  const GeniusPdfController({
    required this.generation,
    required this.documents,
  });

  final GeniusPdfGenerationApplicationService generation;
  final GeniusPdfDocumentApplicationService documents;

  Future<GeniusPdfResult> generate({
    required GeniusPdfBuildSource builder,
    required String fileName,
    bool runInBackground = true,
  }) =>
      generation.generate(
        builder: builder,
        fileName: fileName,
        runInBackground: runInBackground,
      );

  Future<GeniusPdfResult> generateAndSave({
    required GeniusPdfBuildSource builder,
    required String fileName,
    bool runInBackground = true,
  }) =>
      generation.generateAndSave(
        builder: builder,
        fileName: fileName,
        runInBackground: runInBackground,
      );

  Future<GeniusPdfResult> generateAndOpen({
    required GeniusPdfBuildSource builder,
    required String fileName,
    PdfGenerationCallback? onStart,
    PdfSuccessCallback? onComplete,
    PdfErrorCallback? onError,
    bool runInBackground = true,
  }) =>
      generation.generateAndOpen(
        builder: builder,
        fileName: fileName,
        onStart: onStart,
        onComplete: onComplete,
        onError: onError,
        runInBackground: runInBackground,
      );

  Future<GeniusPdfResult> generateAndShare({
    required GeniusPdfBuildSource builder,
    required String fileName,
    PdfGenerationCallback? onStart,
    PdfSuccessCallback? onComplete,
    PdfErrorCallback? onError,
    bool runInBackground = true,
  }) =>
      generation.generateAndShare(
        builder: builder,
        fileName: fileName,
        onStart: onStart,
        onComplete: onComplete,
        onError: onError,
        runInBackground: runInBackground,
      );

  Future<void> openFile(String path) => generation.openFile(path);

  Future<void> sharePdf(Uint8List bytes, String fileName) =>
      generation.sharePdf(bytes, fileName);

  Future<bool> print({
    required Uint8List bytes,
    required String documentName,
  }) =>
      generation.print(bytes: bytes, documentName: documentName);

  Future<void> saveToPath({
    required Uint8List bytes,
    required String path,
  }) =>
      generation.saveToPath(bytes: bytes, path: path);

  Future<Object?> shareWithOptions({
    required Uint8List bytes,
    required String fileName,
    String? subject,
    String? text,
  }) =>
      generation.shareWithOptions(
        bytes: bytes,
        fileName: fileName,
        subject: subject,
        text: text,
      );

  Future<GeniusPdfMergeResult> mergePdfs({
    required List<Uint8List> pdfBytesList,
    required String outputFileName,
    bool saveToFile = false,
    GeniusPdfProgressCallback? onProgress,
    GeniusPdfCancellationToken? cancellationToken,
  }) =>
      documents.mergePdfs(
        pdfBytesList: pdfBytesList,
        outputFileName: outputFileName,
        saveToFile: saveToFile,
        onProgress: onProgress,
        cancellationToken: cancellationToken,
      );

  Future<GeniusPdfSplitResult> splitPdf({
    required Uint8List pdfBytes,
    required String baseFileName,
    int? pagesPerFile,
    List<List<int>>? pageRanges,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
  }) =>
      documents.splitPdf(
        pdfBytes: pdfBytes,
        baseFileName: baseFileName,
        pagesPerFile: pagesPerFile,
        pageRanges: pageRanges,
        saveToFiles: saveToFiles,
        onProgress: onProgress,
      );

  Future<GeniusPdfInfo?> getPdfInfo(Uint8List pdfBytes) =>
      documents.getPdfInfo(pdfBytes);

  Future<GeniusPdfResult> extractPages({
    required Uint8List pdfBytes,
    required List<int> pageNumbers,
    required String outputFileName,
  }) =>
      documents.extractPages(
        pdfBytes: pdfBytes,
        pageNumbers: pageNumbers,
        outputFileName: outputFileName,
      );

  Future<GeniusPdfResult> addWatermark({
    required Uint8List pdfBytes,
    required String watermarkText,
    double opacity = 0.3,
    double rotation = -45,
    double fontSize = 72,
    String outputFileName = 'watermarked',
    TextDirection textDirection = TextDirection.ltr,
  }) =>
      documents.addWatermark(
        pdfBytes: pdfBytes,
        watermarkText: watermarkText,
        opacity: opacity,
        rotation: rotation,
        fontSize: fontSize,
        outputFileName: outputFileName,
        textDirection: textDirection == TextDirection.rtl
            ? GeniusPdfTextFlow.rtl
            : GeniusPdfTextFlow.ltr,
      );

  Future<GeniusPdfResult> rotatePages({
    required Uint8List pdfBytes,
    required int rotation,
    List<int>? pageNumbers,
    String outputFileName = 'rotated',
  }) =>
      documents.rotatePages(
        pdfBytes: pdfBytes,
        rotation: rotation,
        pageNumbers: pageNumbers,
        outputFileName: outputFileName,
      );

  Future<List<GeniusPdfResult>> generateBatch({
    required List<({GeniusPdfBuildSource builder, String fileName})> builders,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
    void Function(int index, GeniusPdfResult result)? onItemComplete,
  }) =>
      generation.generateBatch(
        builders: builders,
        saveToFiles: saveToFiles,
        onProgress: onProgress,
        onItemComplete: onItemComplete,
      );
}
