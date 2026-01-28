import 'dart:convert';
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'export_models.dart';

/// Exports PDF documents to plain text format.
class GeniusPdfToTextExporter {
  /// Creates a text exporter.
  const GeniusPdfToTextExporter();

  /// Exports a PDF document to plain text.
  Future<GeniusExportResult> export(
    PdfDocument document,
    GeniusExportConfiguration config, {
    void Function(GeniusExportProgress)? onProgress,
  }) async {
    try {
      final pageCount = document.pages.count;
      final pagesToExport = config.pageRange?.toList(pageCount) ??
          List.generate(pageCount, (i) => i + 1);

      final textBuffer = StringBuffer();

      // Extract text from each page
      for (var i = 0; i < pagesToExport.length; i++) {
        final pageNumber = pagesToExport[i];

        onProgress?.call(GeniusExportProgress(
          currentPage: i + 1,
          totalPages: pagesToExport.length,
          currentItem: 1,
          totalItems: 1,
          status: 'Extracting text from page $pageNumber...',
          statusAr: 'جاري استخراج النص من الصفحة $pageNumber...',
        ));

        final pageText = await _extractPageText(document, pageNumber);

        if (pagesToExport.length > 1) {
          textBuffer.writeln('--- Page $pageNumber ---');
          textBuffer.writeln();
        }

        textBuffer.writeln(pageText);

        if (i < pagesToExport.length - 1) {
          textBuffer.writeln();
          textBuffer.writeln();
        }
      }

      final textString = textBuffer.toString();
      final textBytes = Uint8List.fromList(utf8.encode(textString));

      return GeniusExportSuccess(
        data: textBytes,
        format: GeniusExportFormat.text,
        pageCount: pagesToExport.length,
      );
    } catch (e, stack) {
      return GeniusExportFailure(error: e, stackTrace: stack);
    }
  }

  /// Extracts text from a single page.
  Future<GeniusExportResult> extractPage(
    PdfDocument document,
    int pageNumber,
  ) async {
    try {
      final text = await _extractPageText(document, pageNumber);
      final textBytes = Uint8List.fromList(utf8.encode(text));

      return GeniusExportSuccess(
        data: textBytes,
        format: GeniusExportFormat.text,
        pageCount: 1,
      );
    } catch (e, stack) {
      return GeniusExportFailure(error: e, stackTrace: stack);
    }
  }

  Future<String> _extractPageText(
    PdfDocument document,
    int pageNumber,
  ) async {
    final pageIndex = pageNumber - 1;

    // Validate page number
    if (pageIndex < 0 || pageIndex >= document.pages.count) {
      throw Exception(
        'Invalid page number: $pageNumber. '
        'Document has ${document.pages.count} pages.',
      );
    }

    try {
      // Use Syncfusion's text extractor
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText(
        startPageIndex: pageIndex,
        endPageIndex: pageIndex,
      );

      return _cleanText(text);
    } catch (e) {
      return ''; // Return empty string if extraction fails
    }
  }

  String _cleanText(String text) {
    // Clean up the extracted text
    var cleaned = text;

    // Normalize line endings
    cleaned = cleaned.replaceAll('\r\n', '\n');
    cleaned = cleaned.replaceAll('\r', '\n');

    // Remove excessive whitespace while preserving paragraph breaks
    cleaned = cleaned.replaceAll(RegExp(r'[ \t]+'), ' ');
    cleaned = cleaned.replaceAll(RegExp(r'\n{3,}'), '\n\n');

    // Trim leading/trailing whitespace
    cleaned = cleaned.trim();

    return cleaned;
  }
}

/// Text extraction options.
class GeniusTextExtractionOptions {
  /// Creates text extraction options.
  const GeniusTextExtractionOptions({
    this.preserveLayout = false,
    this.includePageNumbers = true,
    this.pageSeparator = '\n--- Page {page} ---\n\n',
  });

  /// Whether to preserve the original layout.
  final bool preserveLayout;

  /// Whether to include page numbers in the output.
  final bool includePageNumbers;

  /// Separator between pages. Use {page} as placeholder for page number.
  final String pageSeparator;
}

/// Extension methods for PDF document text export.
extension PdfDocumentTextExport on PdfDocument {
  /// Exports this document to plain text.
  Future<GeniusExportResult> exportToText({
    GeniusPageRange? pageRange,
    void Function(GeniusExportProgress)? onProgress,
  }) {
    const exporter = GeniusPdfToTextExporter();
    return exporter.export(
      this,
      GeniusExportConfiguration.text(pageRange: pageRange),
      onProgress: onProgress,
    );
  }

  /// Extracts text from a specific page.
  Future<GeniusExportResult> extractTextFromPage(int pageNumber) {
    const exporter = GeniusPdfToTextExporter();
    return exporter.extractPage(this, pageNumber);
  }

  /// Extracts all text from the document.
  String extractAllText() {
    final extractor = PdfTextExtractor(this);
    return extractor.extractText();
  }
}
