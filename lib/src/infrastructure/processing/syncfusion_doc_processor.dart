import 'dart:typed_data';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart' as sf;

import '../../application/contracts/pdf_document_processor.dart';
import '../../application/contracts/pdf_generation_ports.dart';
import '../../domain/models/pdf_operations.dart';
import '../../domain/models/pdf_result.dart';

class SyncfusionPdfDocumentProcessor implements GeniusPdfDocumentProcessor {
  const SyncfusionPdfDocumentProcessor({
    required this.files,
    required this.logger,
    this.watermarkFontBytes,
  });

  final GeniusPdfFileGateway files;
  final GeniusPdfLogPort logger;

  /// Optional TrueType font bytes used by watermarks, required for reliable
  /// Arabic and other non-Latin text rendering.
  final Uint8List? watermarkFontBytes;

  @override
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

    logger.info(
      'Merging ${pdfBytesList.length} PDFs into "$outputFileName"',
      tag: 'PdfService',
    );

    sf.PdfDocument? mergedDocument;
    try {
      onProgress?.call(0, 'Starting merge...');
      cancellationToken?.throwIfCancelled();
      mergedDocument = sf.PdfDocument();

      var processedCount = 0;
      for (final pdfBytes in pdfBytesList) {
        cancellationToken?.throwIfCancelled();
        final sourceDocument = sf.PdfDocument(inputBytes: pdfBytes);
        try {
          for (var index = 0; index < sourceDocument.pages.count; index++) {
            mergedDocument.pages.add().graphics.drawPdfTemplate(
                  sourceDocument.pages[index].createTemplate(),
                  const Offset(0, 0),
                );
          }
        } finally {
          sourceDocument.dispose();
        }

        processedCount++;
        onProgress?.call(
          processedCount / pdfBytesList.length,
          'Merged $processedCount of ${pdfBytesList.length} PDFs',
        );
      }

      cancellationToken?.throwIfCancelled();
      onProgress?.call(0.95, 'Finalizing...');
      final bytes = Uint8List.fromList(await mergedDocument.save());

      String? filePath;
      if (saveToFile) {
        final directoryPath = await files.documentsDirectoryPath();
        await files.ensureDirectory(directoryPath);
        final effectiveFileName = outputFileName.endsWith('.pdf')
            ? outputFileName
            : '$outputFileName.pdf';
        filePath = '$directoryPath/$effectiveFileName';
        await files.writeBytes(filePath, bytes);
      }

      onProgress?.call(1, 'Merge complete');
      return GeniusPdfMergeResult.success(
        bytes: bytes,
        filePath: filePath,
        mergedCount: pdfBytesList.length,
      );
    } on GeniusPdfCancelledException {
      return GeniusPdfMergeResult.failure('Merge cancelled');
    } catch (error, stackTrace) {
      logger.error(
        'Error merging PDFs',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      return GeniusPdfMergeResult.failure(error.toString());
    } finally {
      mergedDocument?.dispose();
    }
  }

  @override
  Future<GeniusPdfSplitResult> splitPdf({
    required Uint8List pdfBytes,
    required String baseFileName,
    int? pagesPerFile,
    List<List<int>>? pageRanges,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
  }) async {
    sf.PdfDocument? sourceDocument;
    try {
      logger.info('Splitting PDF: "$baseFileName"', tag: 'PdfService');
      onProgress?.call(0, 'Loading PDF...');
      sourceDocument = sf.PdfDocument(inputBytes: pdfBytes);
      final totalPages = sourceDocument.pages.count;
      if (totalPages == 0) {
        return GeniusPdfSplitResult.failure('PDF has no pages');
      }

      String? saveDirectoryPath;
      if (saveToFiles) {
        saveDirectoryPath = await files.documentsDirectoryPath();
        await files.ensureDirectory(saveDirectoryPath);
      }

      final ranges = _resolvePageRanges(
        totalPages: totalPages,
        pagesPerFile: pagesPerFile,
        pageRanges: pageRanges,
      );
      final splitFiles = <GeniusPdfSplitFile>[];

      for (var rangeIndex = 0; rangeIndex < ranges.length; rangeIndex++) {
        final range = ranges[rangeIndex];
        final startPage = range[0].clamp(0, totalPages - 1).toInt();
        final endPage =
            range[1].clamp(startPage, totalPages - 1).toInt();
        onProgress?.call(
          (rangeIndex + 1) / ranges.length * 0.9,
          'Splitting pages ${startPage + 1}-${endPage + 1}...',
        );

        final splitDocument = sf.PdfDocument();
        try {
          for (var pageIndex = startPage;
              pageIndex <= endPage;
              pageIndex++) {
            splitDocument.pages.add().graphics.drawPdfTemplate(
                  sourceDocument.pages[pageIndex].createTemplate(),
                  const Offset(0, 0),
                );
          }

          final bytes = Uint8List.fromList(await splitDocument.save());
          final fileName = '${baseFileName}_${rangeIndex + 1}.pdf';
          String? filePath;
          if (saveDirectoryPath != null) {
            filePath = '$saveDirectoryPath/$fileName';
            await files.writeBytes(filePath, bytes);
          }

          splitFiles.add(
            GeniusPdfSplitFile(
              bytes: bytes,
              fileName: fileName,
              pageStart: startPage + 1,
              pageEnd: endPage + 1,
              filePath: filePath,
            ),
          );
        } finally {
          splitDocument.dispose();
        }
      }

      onProgress?.call(1, 'Split complete');
      return GeniusPdfSplitResult.success(splitFiles);
    } catch (error, stackTrace) {
      logger.error(
        'Error splitting PDF',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      return GeniusPdfSplitResult.failure(error.toString());
    } finally {
      sourceDocument?.dispose();
    }
  }

  @override
  Future<GeniusPdfInfo?> getPdfInfo(Uint8List pdfBytes) async {
    sf.PdfDocument? document;
    try {
      document = sf.PdfDocument(inputBytes: pdfBytes);
      return GeniusPdfInfo(
        pageCount: document.pages.count,
        fileSizeBytes: pdfBytes.length,
        metadata: GeniusPdfMetadata(
          title: document.documentInformation.title,
          author: document.documentInformation.author,
          subject: document.documentInformation.subject,
          keywords: document.documentInformation.keywords,
          creator: document.documentInformation.creator,
          producer: document.documentInformation.producer,
          creationDate: document.documentInformation.creationDate,
          modificationDate: document.documentInformation.modificationDate,
        ),
        isEncrypted: document.security.encryptionOptions !=
            sf.PdfEncryptionOptions.encryptAllContents,
      );
    } catch (error, stackTrace) {
      logger.error(
        'Error getting PDF info',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      return null;
    } finally {
      document?.dispose();
    }
  }

  @override
  Future<GeniusPdfResult> extractPages({
    required Uint8List pdfBytes,
    required List<int> pageNumbers,
    required String outputFileName,
  }) async {
    sf.PdfDocument? sourceDocument;
    sf.PdfDocument? extractedDocument;
    try {
      sourceDocument = sf.PdfDocument(inputBytes: pdfBytes);
      final totalPages = sourceDocument.pages.count;
      final validPages = pageNumbers
          .where((page) => page >= 1 && page <= totalPages)
          .toSet()
          .toList()
        ..sort();
      if (validPages.isEmpty) {
        return const GeniusPdfFailure(
          error: 'No valid pages to extract',
          message: 'No valid pages to extract',
        );
      }

      extractedDocument = sf.PdfDocument();
      for (final pageNumber in validPages) {
        extractedDocument.pages.add().graphics.drawPdfTemplate(
              sourceDocument.pages[pageNumber - 1].createTemplate(),
              const Offset(0, 0),
            );
      }

      return GeniusPdfSuccess(
        bytes: Uint8List.fromList(await extractedDocument.save()),
        fileName: outputFileName,
      );
    } catch (error, stackTrace) {
      logger.error(
        'Error extracting pages',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      return GeniusPdfFailure.fromException(error, stackTrace);
    } finally {
      extractedDocument?.dispose();
      sourceDocument?.dispose();
    }
  }

  @override
  Future<GeniusPdfResult> addWatermark({
    required Uint8List pdfBytes,
    required String watermarkText,
    double opacity = 0.3,
    double rotation = -45,
    double fontSize = 72,
    String outputFileName = 'watermarked',
    GeniusPdfTextFlow textDirection = GeniusPdfTextFlow.ltr,
  }) async {
    sf.PdfDocument? document;
    try {
      logger.info(
        'Adding watermark: "$watermarkText"',
        tag: 'PdfService',
      );
      document = sf.PdfDocument(inputBytes: pdfBytes);
      final effectiveOpacity = opacity.clamp(0.0, 1.0).toDouble();
      final brush = sf.PdfSolidBrush(
        sf.PdfColor(128, 128, 128, (effectiveOpacity * 255).round()),
      );
      final font = _createWatermarkFont(
        fontSize: fontSize,
        textDirection: textDirection,
      );

      for (var index = 0; index < document.pages.count; index++) {
        final page = document.pages[index];
        final graphics = page.graphics;
        graphics.save();
        graphics.translateTransform(
          page.size.width / 2,
          page.size.height / 2,
        );
        graphics.rotateTransform(rotation);
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
          format: sf.PdfStringFormat(
            alignment: sf.PdfTextAlignment.center,
            lineAlignment: sf.PdfVerticalAlignment.middle,
            textDirection: textDirection == GeniusPdfTextFlow.rtl
                ? sf.PdfTextDirection.rightToLeft
                : sf.PdfTextDirection.leftToRight,
          ),
        );
        graphics.restore();
      }

      return GeniusPdfSuccess(
        bytes: Uint8List.fromList(await document.save()),
        fileName: outputFileName,
      );
    } catch (error, stackTrace) {
      logger.error(
        'Error adding watermark',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      return GeniusPdfFailure.fromException(error, stackTrace);
    } finally {
      document?.dispose();
    }
  }

  sf.PdfFont _createWatermarkFont({
    required double fontSize,
    required GeniusPdfTextFlow textDirection,
  }) {
    final fontBytes = watermarkFontBytes;
    if (fontBytes != null && fontBytes.isNotEmpty) {
      return sf.PdfTrueTypeFont(fontBytes, fontSize);
    }
    if (textDirection == GeniusPdfTextFlow.rtl) {
      throw StateError(
        'RTL watermarks require TrueType font bytes. Pass '
        'watermarkFontBytes to GeniusPdfService or inject a configured '
        'GeniusPdfDocumentProcessor.',
      );
    }
    return sf.PdfStandardFont(sf.PdfFontFamily.helvetica, fontSize);
  }

  @override
  Future<GeniusPdfResult> rotatePages({
    required Uint8List pdfBytes,
    required int rotation,
    List<int>? pageNumbers,
    String outputFileName = 'rotated',
  }) async {
    if (rotation % 90 != 0) {
      return const GeniusPdfFailure(
        error: 'Rotation must be a multiple of 90',
        message: 'Rotation must be a multiple of 90',
      );
    }

    sf.PdfDocument? document;
    try {
      logger.info(
        'Rotating pages by $rotation degrees',
        tag: 'PdfService',
      );
      document = sf.PdfDocument(inputBytes: pdfBytes);
      final pagesToRotate = pageNumbers ??
          List<int>.generate(document.pages.count, (index) => index + 1);
      for (final pageNumber in pagesToRotate) {
        if (pageNumber < 1 || pageNumber > document.pages.count) continue;
        final page = document.pages[pageNumber - 1];
        final currentRotation = page.rotation.index * 90;
        final newRotation = (currentRotation + rotation) % 360;
        page.rotation = sf.PdfPageRotateAngle.values[newRotation ~/ 90];
      }

      return GeniusPdfSuccess(
        bytes: Uint8List.fromList(await document.save()),
        fileName: outputFileName,
      );
    } catch (error, stackTrace) {
      logger.error(
        'Error rotating pages',
        tag: 'PdfService',
        error: error,
        stackTrace: stackTrace,
      );
      return GeniusPdfFailure.fromException(error, stackTrace);
    } finally {
      document?.dispose();
    }
  }

  List<List<int>> _resolvePageRanges({
    required int totalPages,
    int? pagesPerFile,
    List<List<int>>? pageRanges,
  }) {
    if (pageRanges != null && pageRanges.isNotEmpty) return pageRanges;
    if (pagesPerFile != null && pagesPerFile > 0) {
      final ranges = <List<int>>[];
      for (var index = 0; index < totalPages; index += pagesPerFile) {
        final end =
            (index + pagesPerFile - 1).clamp(0, totalPages - 1).toInt();
        ranges.add(<int>[index, end]);
      }
      return ranges;
    }
    return List<List<int>>.generate(
      totalPages,
      (index) => <int>[index, index],
    );
  }
}
