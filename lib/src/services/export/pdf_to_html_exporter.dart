import 'dart:convert';
import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'export_models.dart';

/// Exports PDF documents to HTML format.
class GeniusPdfToHtmlExporter {
  /// Creates an HTML exporter.
  const GeniusPdfToHtmlExporter();

  /// Exports a PDF document to HTML.
  Future<GeniusExportResult> export(
    PdfDocument document,
    GeniusExportConfiguration config, {
    void Function(GeniusExportProgress)? onProgress,
  }) async {
    try {
      final pageCount = document.pages.count;
      final pagesToExport = config.pageRange?.toList(pageCount) ??
          List.generate(pageCount, (i) => i + 1);

      final htmlBuffer = StringBuffer();

      // Write HTML header
      htmlBuffer.writeln(_generateHtmlHeader(config));

      // Write body start
      htmlBuffer.writeln('<body>');
      htmlBuffer.writeln('<div class="pdf-document">');

      // Extract content from each page
      for (var i = 0; i < pagesToExport.length; i++) {
        final pageNumber = pagesToExport[i];

        onProgress?.call(GeniusExportProgress(
          currentPage: i + 1,
          totalPages: pagesToExport.length,
          currentItem: 1,
          totalItems: 1,
          status: 'Converting page $pageNumber to HTML...',
          statusAr: 'جاري تحويل الصفحة $pageNumber إلى HTML...',
        ));

        final pageHtml = await _convertPageToHtml(
          document,
          pageNumber,
          config,
        );
        htmlBuffer.writeln(pageHtml);
      }

      // Write body end
      htmlBuffer.writeln('</div>');
      htmlBuffer.writeln('</body>');
      htmlBuffer.writeln('</html>');

      final htmlString = htmlBuffer.toString();
      final htmlBytes = Uint8List.fromList(utf8.encode(htmlString));

      return GeniusExportSuccess(
        data: htmlBytes,
        format: GeniusExportFormat.html,
        pageCount: pagesToExport.length,
      );
    } catch (e, stack) {
      return GeniusExportFailure(error: e, stackTrace: stack);
    }
  }

  String _generateHtmlHeader(GeniusExportConfiguration config) {
    final styles = config.htmlIncludeStyles ? _generateStyles() : '';

    return '''
<!DOCTYPE html>
<html lang="en" dir="auto">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="generator" content="Genius Link PDF Generator">
    <title>Exported PDF Document</title>
    $styles
</head>''';
  }

  String _generateStyles() {
    return '''
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f5f5f5;
            padding: 20px;
        }

        .pdf-document {
            max-width: 900px;
            margin: 0 auto;
        }

        .pdf-page {
            background: white;
            padding: 40px;
            margin-bottom: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            border-radius: 4px;
            position: relative;
        }

        .pdf-page::before {
            content: attr(data-page);
            position: absolute;
            top: 10px;
            right: 10px;
            font-size: 12px;
            color: #999;
        }

        .page-break {
            page-break-after: always;
        }

        .text-block {
            margin-bottom: 10px;
        }

        .text-line {
            margin: 2px 0;
        }

        .rtl {
            direction: rtl;
            text-align: right;
        }

        .ltr {
            direction: ltr;
            text-align: left;
        }

        h1, h2, h3, h4, h5, h6 {
            margin: 20px 0 10px 0;
            color: #1a1a1a;
        }

        p {
            margin: 10px 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 20px 0;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }

        th {
            background-color: #f8f9fa;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background-color: #f8f9fa;
        }

        .image-container {
            text-align: center;
            margin: 20px 0;
        }

        .image-container img {
            max-width: 100%;
            height: auto;
        }

        @media print {
            body {
                background: white;
                padding: 0;
            }

            .pdf-page {
                box-shadow: none;
                margin: 0;
                padding: 20px;
            }

            .pdf-page::before {
                display: none;
            }
        }

        @media (max-width: 768px) {
            body {
                padding: 10px;
            }

            .pdf-page {
                padding: 20px;
            }
        }
    </style>''';
  }

  Future<String> _convertPageToHtml(
    PdfDocument document,
    int pageNumber,
    GeniusExportConfiguration config,
  ) async {
    final buffer = StringBuffer();
    final pageIndex = pageNumber - 1;

    buffer.writeln(
        '<div class="pdf-page" data-page="Page $pageNumber">');

    try {
      // Extract text from the page
      final extractor = PdfTextExtractor(document);
      final text = extractor.extractText(startPageIndex: pageIndex, endPageIndex: pageIndex);

      if (text.isNotEmpty) {
        // Detect text direction
        final isRtl = _containsRtlText(text);
        final dirClass = isRtl ? 'rtl' : 'ltr';

        buffer.writeln('<div class="text-block $dirClass">');

        // Split text into paragraphs
        final paragraphs = text.split(RegExp(r'\n\s*\n'));
        for (final paragraph in paragraphs) {
          if (paragraph.trim().isNotEmpty) {
            final escapedText = _escapeHtml(paragraph.trim());
            // Check if it looks like a heading (short, possibly all caps)
            if (_looksLikeHeading(paragraph)) {
              buffer.writeln('<h2>$escapedText</h2>');
            } else {
              buffer.writeln('<p>$escapedText</p>');
            }
          }
        }

        buffer.writeln('</div>');
      } else {
        buffer.writeln('<div class="text-block">');
        buffer.writeln('<p><em>No extractable text content</em></p>');
        buffer.writeln('</div>');
      }
    } catch (e) {
      buffer.writeln('<div class="text-block">');
      buffer.writeln('<p><em>Could not extract text from this page</em></p>');
      buffer.writeln('</div>');
    }

    buffer.writeln('</div>');

    return buffer.toString();
  }

  bool _containsRtlText(String text) {
    // Check for Arabic, Hebrew, or other RTL characters
    final rtlPattern = RegExp(r'[\u0591-\u07FF\uFB1D-\uFDFD\uFE70-\uFEFC]');
    return rtlPattern.hasMatch(text);
  }

  bool _looksLikeHeading(String text) {
    final trimmed = text.trim();
    // Consider it a heading if it's short and doesn't end with typical sentence punctuation
    if (trimmed.length > 100) return false;
    if (trimmed.endsWith('.') || trimmed.endsWith('؟') || trimmed.endsWith('?')) {
      return false;
    }
    // Check if it's mostly uppercase (for English)
    final upperCount = trimmed.replaceAll(RegExp(r'[^A-Z]'), '').length;
    final letterCount = trimmed.replaceAll(RegExp(r'[^a-zA-Z]'), '').length;
    if (letterCount > 0 && upperCount / letterCount > 0.7) return true;
    // Short lines without sentence punctuation might be headings
    return trimmed.length < 50 && !trimmed.contains('\n');
  }

  String _escapeHtml(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#39;')
        .replaceAll('\n', '<br>');
  }
}

/// Extension methods for PDF document HTML export.
extension PdfDocumentHtmlExport on PdfDocument {
  /// Exports this document to HTML.
  Future<GeniusExportResult> exportToHtml({
    bool embedImages = true,
    bool includeStyles = true,
    GeniusPageRange? pageRange,
    void Function(GeniusExportProgress)? onProgress,
  }) {
    const exporter = GeniusPdfToHtmlExporter();
    return exporter.export(
      this,
      GeniusExportConfiguration.html(
        embedImages: embedImages,
        includeStyles: includeStyles,
        pageRange: pageRange,
      ),
      onProgress: onProgress,
    );
  }
}
