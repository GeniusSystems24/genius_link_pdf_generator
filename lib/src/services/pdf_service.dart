import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:share_plus/share_plus.dart';

import '../application/contracts/pdf_document_processor.dart';
import '../application/contracts/pdf_generation_ports.dart';
import '../builders/pdf_document_builder.dart';
import '../composition/genius_pdf_composition_root.dart';
import '../domain/models/pdf_operations.dart';
import '../domain/models/pdf_result.dart';
import '../presentation/controllers/genius_pdf_controller.dart';

export '../application/contracts/pdf_document_processor.dart';
export '../application/contracts/pdf_generation_ports.dart';
export '../domain/models/pdf_operations.dart';

/// Backward-compatible callback for resolving a platform directory.
typedef GeniusPdfDirectoryProvider = GeniusPdfDirectoryResolver;

/// Backward-compatible callback for opening a generated file.
typedef GeniusPdfOpenFileAction = GeniusPdfOpenFileHandler;

/// Backward-compatible callback for sharing PDF bytes.
typedef GeniusPdfSharePdfAction = GeniusPdfShareHandler;

/// Backward-compatible callback for printing PDF bytes.
typedef GeniusPdfPrintPdfAction = GeniusPdfPrintHandler;

/// Stable public facade for PDF generation and document operations.
///
/// Existing method names, parameters and return types are preserved. Internally,
/// the facade composes application use cases, infrastructure adapters and an MVC
/// controller. Advanced consumers may replace the ports through the optional
/// constructor parameters without changing normal usage.
class GeniusPdfService {
  const GeniusPdfService({
    GeniusPdfDirectoryProvider? documentsDirectoryProvider,
    GeniusPdfDirectoryProvider? temporaryDirectoryProvider,
    GeniusPdfOpenFileAction? openFileAction,
    GeniusPdfSharePdfAction? sharePdfAction,
    GeniusPdfPrintPdfAction? printPdfAction,
    GeniusPdfDocumentGenerator? documentGenerator,
    GeniusPdfFileGateway? fileGateway,
    GeniusPdfInteractionGateway? interactionGateway,
    GeniusPdfDocumentProcessor? documentProcessor,
    GeniusPdfLogPort? logger,
    Uint8List? watermarkFontBytes,
    GeniusPdfRuntime? runtime,
  })  : _documentsDirectoryProvider = documentsDirectoryProvider,
        _temporaryDirectoryProvider = temporaryDirectoryProvider,
        _openFileAction = openFileAction,
        _sharePdfAction = sharePdfAction,
        _printPdfAction = printPdfAction,
        _documentGenerator = documentGenerator,
        _fileGateway = fileGateway,
        _interactionGateway = interactionGateway,
        _documentProcessor = documentProcessor,
        _logger = logger,
        _watermarkFontBytes = watermarkFontBytes,
        _providedRuntime = runtime;

  final GeniusPdfDirectoryProvider? _documentsDirectoryProvider;
  final GeniusPdfDirectoryProvider? _temporaryDirectoryProvider;
  final GeniusPdfOpenFileAction? _openFileAction;
  final GeniusPdfSharePdfAction? _sharePdfAction;
  final GeniusPdfPrintPdfAction? _printPdfAction;
  final GeniusPdfDocumentGenerator? _documentGenerator;
  final GeniusPdfFileGateway? _fileGateway;
  final GeniusPdfInteractionGateway? _interactionGateway;
  final GeniusPdfDocumentProcessor? _documentProcessor;
  final GeniusPdfLogPort? _logger;
  final Uint8List? _watermarkFontBytes;
  final GeniusPdfRuntime? _providedRuntime;

  static final Expando<GeniusPdfRuntime> _runtimeCache =
      Expando<GeniusPdfRuntime>('GeniusPdfService.runtime');

  GeniusPdfRuntime get _runtime {
    final provided = _providedRuntime;
    if (provided != null) return provided;
    final cached = _runtimeCache[this];
    if (cached != null) return cached;
    final runtime = GeniusPdfCompositionRoot.create(
      documentsDirectoryProvider: _documentsDirectoryProvider,
      temporaryDirectoryProvider: _temporaryDirectoryProvider,
      openFileAction: _openFileAction,
      sharePdfAction: _sharePdfAction,
      printPdfAction: _printPdfAction,
      documentGenerator: _documentGenerator,
      fileGateway: _fileGateway,
      interactionGateway: _interactionGateway,
      documentProcessor: _documentProcessor,
      logger: _logger,
      watermarkFontBytes: _watermarkFontBytes,
    );
    _runtimeCache[this] = runtime;
    return runtime;
  }

  GeniusPdfController get _controller => _runtime.controller;

  Future<GeniusPdfResult> generate({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    bool runInBackground = true,
  }) =>
      _controller.generate(
        builder: builder,
        fileName: fileName,
        runInBackground: runInBackground,
      );

  Future<GeniusPdfResult> generateAndSave({
    required GeniusPdfDocumentBuilder builder,
    required String fileName,
    bool runInBackground = true,
  }) =>
      _controller.generateAndSave(
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
      _controller.generateAndOpen(
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
      _controller.generateAndShare(
        builder: builder,
        fileName: fileName,
        onStart: onStart,
        onComplete: onComplete,
        onError: onError,
        runInBackground: runInBackground,
      );

  Future<void> openFile(String path) => _controller.openFile(path);

  Future<void> sharePdf({
    required Uint8List bytes,
    required String fileName,
  }) =>
      _controller.sharePdf(bytes, fileName);

  Future<bool> print({
    required Uint8List bytes,
    required String documentName,
  }) =>
      _controller.print(bytes: bytes, documentName: documentName);

  Future<File> saveToPath({
    required Uint8List bytes,
    required String path,
  }) async {
    await _controller.saveToPath(bytes: bytes, path: path);
    return File(path);
  }

  Future<ShareResult?> shareWithOptions({
    required Uint8List bytes,
    required String fileName,
    String? subject,
    String? text,
  }) async {
    final result = await _controller.shareWithOptions(
      bytes: bytes,
      fileName: fileName,
      subject: subject,
      text: text,
    );
    return result is ShareResult ? result : null;
  }

  Future<GeniusPdfMergeResult> mergePdfs({
    required List<Uint8List> pdfBytesList,
    required String outputFileName,
    bool saveToFile = false,
    GeniusPdfProgressCallback? onProgress,
    GeniusPdfCancellationToken? cancellationToken,
  }) =>
      _controller.mergePdfs(
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
      _controller.splitPdf(
        pdfBytes: pdfBytes,
        baseFileName: baseFileName,
        pagesPerFile: pagesPerFile,
        pageRanges: pageRanges,
        saveToFiles: saveToFiles,
        onProgress: onProgress,
      );

  Future<GeniusPdfInfo?> getPdfInfo(Uint8List pdfBytes) =>
      _controller.getPdfInfo(pdfBytes);

  Future<GeniusPdfResult> extractPages({
    required Uint8List pdfBytes,
    required List<int> pageNumbers,
    required String outputFileName,
  }) =>
      _controller.extractPages(
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
      _controller.addWatermark(
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
      _controller.rotatePages(
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
      _controller.generateBatch(
        builders: builders,
        saveToFiles: saveToFiles,
        onProgress: onProgress,
        onItemComplete: onItemComplete,
      );
}
