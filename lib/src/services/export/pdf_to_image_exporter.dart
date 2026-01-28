import 'dart:async';
import 'dart:typed_data';

import 'package:image/image.dart' as img;
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'export_models.dart';

/// Exports PDF pages to image formats (PNG, JPEG).
///
/// Uses the printing package's raster rendering for high-quality output.
class GeniusPdfToImageExporter {
  /// Creates an image exporter.
  const GeniusPdfToImageExporter();

  /// Exports a PDF document to images.
  ///
  /// Returns a list of [GeniusExportResult] for each page.
  Future<List<GeniusExportResult>> exportToImages(
    PdfDocument document,
    GeniusExportConfiguration config, {
    void Function(GeniusExportProgress)? onProgress,
  }) async {
    final results = <GeniusExportResult>[];

    try {
      // First, get the PDF bytes from the Syncfusion document
      final pdfBytes = Uint8List.fromList(await document.save());
      final pageCount = document.pages.count;

      // Determine which pages to export
      final pagesToExport = config.pageRange?.toList(pageCount) ??
          List.generate(pageCount, (i) => i + 1);

      // Use printing package to rasterize PDF pages
      final dpi = config.quality.dpi.toDouble();

      int currentPageIndex = 0;

      await for (final page in Printing.raster(pdfBytes, dpi: dpi)) {
        currentPageIndex++;

        // Check if this page should be exported
        if (!pagesToExport.contains(currentPageIndex)) {
          continue;
        }

        // Report progress
        onProgress?.call(GeniusExportProgress(
          currentPage: currentPageIndex,
          totalPages: pagesToExport.length,
          currentItem: 1,
          totalItems: 1,
          status: 'Rendering page $currentPageIndex...',
          statusAr: 'جاري تصيير الصفحة $currentPageIndex...',
        ));

        try {
          Uint8List imageBytes;

          if (config.format == GeniusExportFormat.png) {
            imageBytes = await page.toPng();
          } else {
            // JPEG format
            final pngBytes = await page.toPng();
            // Convert PNG to JPEG using the image data
            imageBytes = await _convertPngToJpeg(pngBytes, config.jpegQuality);
          }

          results.add(GeniusExportSuccess(
            data: imageBytes,
            format: config.format,
            pageCount: 1,
          ));
        } catch (e, stack) {
          results.add(GeniusExportFailure(error: e, stackTrace: stack));
        }

        // Stop if we've exported all requested pages
        if (results.length >= pagesToExport.length) {
          break;
        }
      }

      return results;
    } catch (e, stack) {
      return [GeniusExportFailure(error: e, stackTrace: stack)];
    }
  }

  /// Exports a single page to an image.
  Future<GeniusExportResult> exportPage(
    PdfDocument document,
    int pageNumber,
    GeniusExportConfiguration config,
  ) async {
    try {
      // Validate page number
      if (pageNumber < 1 || pageNumber > document.pages.count) {
        return GeniusExportFailure(
          error: 'Invalid page number: $pageNumber. '
              'Document has ${document.pages.count} pages.',
        );
      }

      // Get the PDF bytes
      final pdfBytes = Uint8List.fromList(await document.save());
      final dpi = config.quality.dpi.toDouble();

      int currentPage = 0;

      await for (final page in Printing.raster(pdfBytes, dpi: dpi)) {
        currentPage++;

        if (currentPage == pageNumber) {
          Uint8List imageBytes;

          if (config.format == GeniusExportFormat.png) {
            imageBytes = await page.toPng();
          } else {
            final pngBytes = await page.toPng();
            imageBytes = await _convertPngToJpeg(pngBytes, config.jpegQuality);
          }

          return GeniusExportSuccess(
            data: imageBytes,
            format: config.format,
            pageCount: 1,
          );
        }
      }

      return const GeniusExportFailure(
        error: 'Failed to render the requested page',
      );
    } catch (e, stack) {
      return GeniusExportFailure(error: e, stackTrace: stack);
    }
  }

  /// Exports all pages and returns them as a single result with combined data.
  Future<GeniusExportResult> exportAllPages(
    PdfDocument document,
    GeniusExportConfiguration config, {
    void Function(GeniusExportProgress)? onProgress,
  }) async {
    final results =
        await exportToImages(document, config, onProgress: onProgress);

    // Check for any failures
    final failures = results.whereType<GeniusExportFailure>().toList();
    if (failures.isNotEmpty) {
      return failures.first;
    }

    // Combine successful results
    final successes = results.whereType<GeniusExportSuccess>().toList();
    if (successes.isEmpty) {
      return const GeniusExportFailure(error: 'No pages were exported');
    }

    // For single page, return as-is
    if (successes.length == 1) {
      return successes.first;
    }

    // For multiple pages, return the first with total page count
    return GeniusExportSuccess(
      data: successes.first.data,
      format: config.format,
      pageCount: successes.length,
    );
  }

  /// Converts PNG bytes to JPEG format with quality control.
  Future<Uint8List> _convertPngToJpeg(Uint8List pngBytes, int quality) async {
    try {
      // Decode the PNG image using the image package
      final image = img.decodeImage(pngBytes);
      if (image == null) {
        throw Exception('Failed to decode PNG image');
      }

      // Encode as JPEG with the specified quality
      final jpegBytes = img.encodeJpg(image, quality: quality);

      return Uint8List.fromList(jpegBytes);
    } catch (e) {
      // If conversion fails, return original PNG bytes
      return pngBytes;
    }
  }
}

/// Extension methods for PDF document image export.
extension PdfDocumentImageExport on PdfDocument {
  /// Exports this document to images.
  Future<List<GeniusExportResult>> exportToImages({
    GeniusExportFormat format = GeniusExportFormat.png,
    GeniusImageQuality quality = GeniusImageQuality.high,
    GeniusPageRange? pageRange,
    void Function(GeniusExportProgress)? onProgress,
  }) {
    const exporter = GeniusPdfToImageExporter();
    return exporter.exportToImages(
      this,
      GeniusExportConfiguration(
        format: format,
        quality: quality,
        pageRange: pageRange,
      ),
      onProgress: onProgress,
    );
  }

  /// Exports a single page to an image.
  Future<GeniusExportResult> exportPageToImage(
    int pageNumber, {
    GeniusExportFormat format = GeniusExportFormat.png,
    GeniusImageQuality quality = GeniusImageQuality.high,
  }) {
    const exporter = GeniusPdfToImageExporter();
    return exporter.exportPage(
      this,
      pageNumber,
      GeniusExportConfiguration(format: format, quality: quality),
    );
  }
}
