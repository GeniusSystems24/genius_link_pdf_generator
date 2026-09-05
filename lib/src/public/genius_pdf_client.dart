import 'dart:typed_data';
import 'dart:ui';

import '../app/contracts/pdf_generation_ports.dart';
import '../builders/pdf_document_builder.dart';
import '../compose/pdf_composition_root.dart';
import '../domain/models/pdf_delivery.dart';
import '../domain/models/pdf_operations.dart';
import '../domain/models/pdf_result.dart';

/// Stable package-owned facade that does not expose plugin result types.
///
/// `GeniusPdfService` remains available through the legacy entrypoint for full
/// backward compatibility. New integrations can prefer this facade and the
/// stable `genius_link_pdf_generator_api.dart` entrypoint.
class GeniusPdfClient {
  const GeniusPdfClient({GeniusPdfRuntime? runtime}) : _providedRuntime = runtime;

  final GeniusPdfRuntime? _providedRuntime;

  GeniusPdfRuntime get _runtime =>
      _providedRuntime ?? GeniusPdfCompositionRoot.defaults;

  Future<GeniusPdfResult> generate({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    bool runInBackground = true,
  }) =>
      _runtime.controller.generate(
        builder: builder,
        fileName: fileName,
        runInBackground: runInBackground,
      );

  Future<GeniusPdfResult> generateAndSave({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    bool runInBackground = true,
  }) =>
      _runtime.controller.generateAndSave(
        builder: builder,
        fileName: fileName,
        runInBackground: runInBackground,
      );

  Future<GeniusPdfResult> generateAndOpen({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    PdfGenerationCallback? onStart,
    PdfSuccessCallback? onComplete,
    PdfErrorCallback? onError,
    bool runInBackground = true,
  }) =>
      _runtime.controller.generateAndOpen(
        builder: builder,
        fileName: fileName,
        onStart: onStart,
        onComplete: onComplete,
        onError: onError,
        runInBackground: runInBackground,
      );

  Future<GeniusPdfResult> generateAndShare({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    PdfGenerationCallback? onStart,
    PdfSuccessCallback? onComplete,
    PdfErrorCallback? onError,
    bool runInBackground = true,
  }) =>
      _runtime.controller.generateAndShare(
        builder: builder,
        fileName: fileName,
        onStart: onStart,
        onComplete: onComplete,
        onError: onError,
        runInBackground: runInBackground,
      );

  Future<void> openFile(String path) => _runtime.controller.openFile(path);

  Future<void> sharePdf({
    required Uint8List bytes,
    required String fileName,
  }) =>
      _runtime.controller.sharePdf(bytes, fileName);

  Future<bool> print({
    required Uint8List bytes,
    required String documentName,
  }) =>
      _runtime.controller.print(bytes: bytes, documentName: documentName);

  Future<void> saveToPath({
    required Uint8List bytes,
    required String path,
  }) =>
      _runtime.controller.saveToPath(bytes: bytes, path: path);

  Future<GeniusPdfDeliveryResult> shareWithOptions({
    required Uint8List bytes,
    required String fileName,
    String? subject,
    String? text,
  }) async {
    try {
      final result = await _runtime.controller.shareWithOptions(
        bytes: bytes,
        fileName: fileName,
        subject: subject,
        text: text,
      );
      return result == null
          ? const GeniusPdfDeliveryResult.failure(
              'Sharing did not return a result.',
            )
          : const GeniusPdfDeliveryResult.success();
    } catch (error) {
      return GeniusPdfDeliveryResult.failure(error, error.toString());
    }
  }

  Future<GeniusPdfMergeResult> mergePdfs({
    required List<Uint8List> pdfBytesList,
    required String outputFileName,
    bool saveToFile = false,
    GeniusPdfProgressCallback? onProgress,
    GeniusPdfCancellationToken? cancellationToken,
  }) =>
      _runtime.controller.mergePdfs(
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
      _runtime.controller.splitPdf(
        pdfBytes: pdfBytes,
        baseFileName: baseFileName,
        pagesPerFile: pagesPerFile,
        pageRanges: pageRanges,
        saveToFiles: saveToFiles,
        onProgress: onProgress,
      );

  Future<GeniusPdfInfo?> getPdfInfo(Uint8List pdfBytes) =>
      _runtime.controller.getPdfInfo(pdfBytes);

  Future<GeniusPdfResult> extractPages({
    required Uint8List pdfBytes,
    required List<int> pageNumbers,
    required String outputFileName,
  }) =>
      _runtime.controller.extractPages(
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
      _runtime.controller.addWatermark(
        pdfBytes: pdfBytes,
        watermarkText: watermarkText,
        opacity: opacity,
        rotation: rotation,
        fontSize: fontSize,
        outputFileName: outputFileName,
        textDirection: textDirection,
      );

  Future<GeniusPdfResult> rotatePages({
    required Uint8List pdfBytes,
    required int rotation,
    List<int>? pageNumbers,
    String outputFileName = 'rotated',
  }) =>
      _runtime.controller.rotatePages(
        pdfBytes: pdfBytes,
        rotation: rotation,
        pageNumbers: pageNumbers,
        outputFileName: outputFileName,
      );

  Future<List<GeniusPdfResult>> generateBatch({
    required List<({GeniusPdfDocumentBuilder builder, String fileName})>
        builders,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
    void Function(int index, GeniusPdfResult result)? onItemComplete,
  }) =>
      _runtime.controller.generateBatch(
        builders: builders
            .map<({GeniusPdfBuildSource builder, String fileName})>(
              (item) => (builder: item.builder, fileName: item.fileName),
            )
            .toList(growable: false),
        saveToFiles: saveToFiles,
        onProgress: onProgress,
        onItemComplete: onItemComplete,
      );
}
