import 'dart:typed_data';

import '../../domain/models/pdf_operations.dart';
import '../../domain/models/pdf_result.dart';
import '../contracts/pdf_generation_ports.dart';

/// Application use cases for generating, persisting and delivering PDFs.
class GeniusPdfGenerationApplicationService {
  const GeniusPdfGenerationApplicationService({
    required this.generator,
    required this.files,
    required this.interactions,
    required this.logger,
  });

  final GeniusPdfDocumentGenerator generator;
  final GeniusPdfFileGateway files;
  final GeniusPdfInteractionGateway interactions;
  final GeniusPdfLogPort logger;

  Future<GeniusPdfResult> generate({
    required GeniusPdfBuildSource builder,
    required String fileName,
    bool runInBackground = true,
  }) async {
    try {
      logger.info('Generating PDF: "$fileName"', tag: 'PdfService');
      final bytes = await generator.generate(
        builder,
        runInBackground: runInBackground,
      );

      if (bytes.isEmpty) {
        logger.error(
          'PDF generation produced empty output',
          tag: 'PdfService',
        );
        return const GeniusPdfFailure(
          error: 'Empty PDF output',
          message: 'PDF generation produced empty output',
        );
      }

      return GeniusPdfSuccess(bytes: bytes, fileName: fileName);
    } catch (error, stackTrace) {
      logger.error(
        'Error generating PDF',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      return GeniusPdfFailure.fromException(error, stackTrace);
    } finally {
      builder.dispose();
    }
  }

  Future<GeniusPdfResult> generateAndSave({
    required GeniusPdfBuildSource builder,
    required String fileName,
    bool runInBackground = true,
  }) async {
    try {
      logger.info(
        'Generating and saving PDF: "$fileName"',
        tag: 'PdfService',
      );
      final bytes = await generator.generate(
        builder,
        runInBackground: runInBackground,
      );
      if (bytes.isEmpty) {
        return const GeniusPdfFailure(
          error: 'Empty PDF output',
          message: 'PDF generation produced empty output',
        );
      }
      final filePath = await _saveGeneratedBytes(
        bytes: bytes,
        builder: builder,
        fileName: fileName,
      );

      return GeniusPdfSuccess(
        bytes: bytes,
        fileName: fileName,
        filePath: filePath,
      );
    } catch (error, stackTrace) {
      logger.error(
        'Error generating PDF',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      return GeniusPdfFailure.fromException(error, stackTrace);
    } finally {
      builder.dispose();
    }
  }

  Future<GeniusPdfResult> generateAndOpen({
    required GeniusPdfBuildSource builder,
    required String fileName,
    PdfGenerationCallback? onStart,
    PdfSuccessCallback? onComplete,
    PdfErrorCallback? onError,
    bool runInBackground = true,
  }) async {
    onStart?.call();
    logger.info(
      'Generating and opening PDF: "$fileName"',
      tag: 'PdfService',
    );

    try {
      final result = await generateAndSave(
        builder: builder,
        fileName: fileName,
        runInBackground: runInBackground,
      );

      if (result is GeniusPdfFailure) {
        onError?.call(result);
        return result;
      }
      final success = result as GeniusPdfSuccess;
      await interactions.openFile(success.filePath!);
      onComplete?.call(success);
      return success;
    } catch (error, stackTrace) {
      logger.error(
        'Error generating PDF',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      final failure = GeniusPdfFailure.fromException(error, stackTrace);
      onError?.call(failure);
      return failure;
    }
  }

  Future<GeniusPdfResult> generateAndShare({
    required GeniusPdfBuildSource builder,
    required String fileName,
    PdfGenerationCallback? onStart,
    PdfSuccessCallback? onComplete,
    PdfErrorCallback? onError,
    bool runInBackground = true,
  }) async {
    onStart?.call();
    logger.info(
      'Generating and sharing PDF: "$fileName"',
      tag: 'PdfService',
    );

    try {
      final result = await generate(
        builder: builder,
        fileName: fileName,
        runInBackground: runInBackground,
      );

      if (result is GeniusPdfFailure) {
        onError?.call(result);
        return result;
      }
      final success = result as GeniusPdfSuccess;
      await interactions.sharePdf(success.bytes, _withPdfExtension(fileName));
      onComplete?.call(success);
      return success;
    } catch (error, stackTrace) {
      logger.error(
        'Error generating PDF',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      final failure = GeniusPdfFailure.fromException(error, stackTrace);
      onError?.call(failure);
      return failure;
    }
  }

  Future<void> openFile(String path) => interactions.openFile(path);

  Future<void> sharePdf(Uint8List bytes, String fileName) =>
      interactions.sharePdf(bytes, fileName);

  Future<bool> print({
    required Uint8List bytes,
    required String documentName,
  }) async {
    if (bytes.isEmpty) {
      logger.error('Print failed: PDF data is empty.', tag: 'PdfService');
      return false;
    }
    return interactions.printPdf(bytes, documentName);
  }

  Future<void> saveToPath({
    required Uint8List bytes,
    required String path,
  }) =>
      files.writeBytes(path, bytes);

  Future<Object?> shareWithOptions({
    required Uint8List bytes,
    required String fileName,
    String? subject,
    String? text,
  }) async {
    try {
      final directoryPath = await files.temporaryDirectoryPath();
      await files.ensureDirectory(directoryPath);
      final effectiveFileName =
          fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';
      final filePath = '$directoryPath/$effectiveFileName';
      await files.writeBytes(filePath, bytes);
      return interactions.shareWithOptions(
        filePath: filePath,
        subject: subject,
        text: text,
      );
    } catch (error, stackTrace) {
      logger.error(
        'Error sharing PDF',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  Future<List<GeniusPdfResult>> generateBatch({
    required List<({GeniusPdfBuildSource builder, String fileName})>
        builders,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
    void Function(int index, GeniusPdfResult result)? onItemComplete,
  }) async {
    final results = <GeniusPdfResult>[];
    if (builders.isEmpty) {
      onProgress?.call(1, 'Batch complete');
      return results;
    }

    for (var index = 0; index < builders.length; index++) {
      final item = builders[index];
      onProgress?.call(
        index / builders.length,
        'Generating ${index + 1} of ${builders.length}...',
      );

      final result = saveToFiles
          ? await generateAndSave(
              builder: item.builder,
              fileName: item.fileName,
            )
          : await generate(
              builder: item.builder,
              fileName: item.fileName,
            );

      results.add(result);
      onItemComplete?.call(index, result);
    }

    onProgress?.call(1, 'Batch complete');
    return results;
  }

  Future<String> _saveGeneratedBytes({
    required Uint8List bytes,
    required GeniusPdfBuildSource builder,
    required String fileName,
  }) async {
    final configuredPath = builder.defaultOutputPath;
    final directoryPath = configuredPath != null && configuredPath.isNotEmpty
        ? configuredPath
        : await files.documentsDirectoryPath();
    await files.ensureDirectory(directoryPath);
    final filePath = '$directoryPath/${_withPdfExtension(fileName)}';
    await files.writeBytes(filePath, bytes);
    return filePath;
  }

  String _withPdfExtension(String fileName) {
    final normalized = fileName.trim();
    if (normalized.toLowerCase().endsWith('.pdf')) return normalized;
    return '$normalized.pdf';
  }
}
