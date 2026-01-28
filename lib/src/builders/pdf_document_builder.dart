import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../core/pdf_config.dart';
import '../models/pdf_image.dart';
import '../extensions/color_extensions.dart';

/// Abstract base class for building PDF documents.
///
/// This class provides a fluent API for constructing PDF documents
/// with support for RTL/LTR text, custom headers/footers, and
/// automatic page management.
///
/// ## Example
/// ```dart
/// class InvoiceDocument extends PdfDocumentBuilder {
///   InvoiceDocument(super.config);
///
///   @override
///   void build() {
///     addHeader(title: 'Invoice #123');
///     addLine('Customer: John Doe');
///     addLine('Amount: \$100.00');
///     addFooter(showPageNumber: true);
///   }
/// }
///
/// // Generate the PDF
/// final builder = InvoiceDocument(config);
/// final bytes = builder.generate();
/// ```
abstract class GeniusPdfDocumentBuilder {

  /// Creates a new [GeniusPdfDocumentBuilder] with the given configuration.
  GeniusPdfDocumentBuilder(this.config) {
    _document = PdfDocument();
    _applySettings();
    _setupFormat();
  }
  /// Configuration for this PDF document.
  final GeniusPdfConfig config;

  /// The underlying PDF document.
  late final PdfDocument _document;

  /// The current page being written to.
  PdfPage? _currentPage;

  /// The current layout result for positioning.
  PdfLayoutResult? _layoutResult;

  /// The current page index (0-based).
  int _currentIndex = -1;

  /// The string format based on text direction.
  late final PdfStringFormat _format;

  // Track additional spacing
  double _spaceOffset = 0;

  void _applySettings() {
    _document.pageSettings.orientation = config.orientation;
    _document.pageSettings.size = config.pageSize;
    _document.pageSettings.margins = config.margins;
    _document.compressionLevel = config.compressionLevel;
  }

  void _setupFormat() {
    _format = PdfStringFormat();
    if (config.isLTR) {
      _format
        ..textDirection = PdfTextDirection.leftToRight
        ..alignment = PdfTextAlignment.left;
    } else {
      _format
        ..textDirection = PdfTextDirection.rightToLeft
        ..alignment = PdfTextAlignment.right;
    }
  }

  // ============================================================
  // GETTERS
  // ============================================================

  /// The base font for this document.
  PdfFont get baseFont => config.baseFont;

  /// The string format for this document.
  PdfStringFormat get format => _format;

  /// The underlying PDF document.
  PdfDocument get document => _document;

  /// The current page width (client area).
  double get pageWidth => _currentPage?.getClientSize().width ?? 0;

  /// The current page height (client area).
  double get pageHeight => _currentPage?.getClientSize().height ?? 0;

  /// The available page width accounting for margins.
  double get availableWidth => config.orientation ==
          PdfPageOrientation.landscape
      ? config.pageSize.width - (config.margins.left + config.margins.right)
      : config.pageSize.height - (config.margins.top + config.margins.bottom);

  /// The current Y position on the page.
  double get currentY => (_layoutResult?.bounds.bottom ?? 0) + _spaceOffset;

  /// The current page (creates one if none exists).
  PdfPage get currentPage {
    if (_currentIndex < 0) return newPage();
    return _currentPage ?? newPage();
  }

  // ============================================================
  // PAGE MANAGEMENT
  // ============================================================

  /// Creates a new page and sets it as the current page.
  ///
  /// Returns the newly created page.
  PdfPage newPage({PdfPen? borderPen}) {
    final page = _document.pages.add();
    _currentIndex++;
    _currentPage = page;
    _layoutResult = null;
    _spaceOffset = 0;

    if (borderPen != null) {
      page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(
          0,
          0,
          page.getClientSize().width,
          page.getClientSize().height,
        ),
        pen: borderPen,
      );
    }

    return page;
  }

  // ============================================================
  // TEXT METHODS
  // ============================================================

  /// Adds a line of text to the document.
  ///
  /// ## Parameters
  /// - [text]: The text to add (required).
  /// - [font]: Custom font (defaults to baseFont).
  /// - [brush]: Text color brush.
  /// - [pen]: Text outline pen.
  /// - [space]: Horizontal spacing/indentation.
  /// - [padding]: Padding around text.
  /// - [topMargin]: Space above the text.
  /// - [inNewPage]: Force text to start on a new page.
  void addLine(
    String text, {
    PdfFont? font,
    PdfBrush? brush,
    PdfPen? pen,
    double space = 0,
    double padding = 5,
    double topMargin = 10,
    bool inNewPage = false,
  }) {
    final page = inNewPage ? newPage() : currentPage;
    final textElement = PdfTextElement(
      text: text,
      font: font ?? baseFont,
      brush: brush ?? PdfBrushes.black,
      pen: pen,
      format: config.isLTR ? null : _format,
    );

    final adjustedSpace = space * (config.isLTR ? 1 : -1);
    _layoutResult = textElement.draw(
      page: page,
      bounds: Rect.fromLTWH(
        padding + adjustedSpace,
        currentY + topMargin,
        page.getClientSize().width - (padding * 2),
        page.getClientSize().height,
      ),
      format: config.layoutFormat,
    );
    _spaceOffset = 0; // Reset after drawing
  }

  /// Adds text at a specific position on the current page.
  void addTextAt(
    String text, {
    required double x,
    required double y,
    PdfFont? font,
    PdfBrush? brush,
    PdfStringFormat? format,
  }) {
    currentPage.graphics.drawString(
      text,
      font ?? baseFont,
      bounds: Rect.fromLTWH(x, y, 0, 0),
      brush: brush ?? PdfBrushes.black,
      format: format ?? _format,
    );
  }

  /// Adds text that flows after the previous content on the same line.
  void addInlineText(
    String text, {
    required double horizontalOffset,
    PdfFont? font,
    PdfBrush? brush,
    PdfPen? pen,
    double padding = 5,
    double topMargin = 0,
  }) {
    final page = currentPage;
    final textElement = PdfTextElement(
      text: text,
      font: font ?? baseFont,
      brush: brush ?? PdfBrushes.black,
      pen: pen,
      format: config.isLTR ? null : _format,
    );

    final adjustedOffset = horizontalOffset * (config.isLTR ? 1 : -1);
    _layoutResult = textElement.draw(
      page: page,
      bounds: Rect.fromLTWH(
        adjustedOffset,
        (_layoutResult?.bounds.top ?? 0) + topMargin,
        page.getClientSize().width - (padding * 2),
        page.getClientSize().height,
      ),
      format: config.layoutFormat,
    );
  }

  // ============================================================
  // HEADER & FOOTER
  // ============================================================

  /// Adds a header to all pages with optional image and title.
  ///
  /// ## Parameters
  /// - [image]: Header image.
  /// - [title]: Document title.
  /// - [font]: Title font.
  /// - [backgroundColor]: Header background color.
  PdfPageTemplateElement addHeader({
    GeniusPdfImage? image,
    String? title,
    PdfFont? font,
    Color? backgroundColor,
  }) {
    final headerFont = font ?? baseFont;
    double headerHeight = 25;

    if (image != null) {
      final ratio = availableWidth / image.width;
      final scaledHeight = ratio >= 1 ? image.height : (image.height * ratio);
      headerHeight =
          scaledHeight + 10 + (title != null ? headerFont.height : 0);
    }

    final header = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, availableWidth, headerHeight),
    );

    // Background
    if (backgroundColor != null) {
      header.graphics.drawRectangle(
        brush: PdfSolidBrush(backgroundColor.toPdfColor()),
        bounds: Rect.fromLTWH(0, 0, availableWidth, headerHeight),
      );
    }

    // Image
    if (image != null) {
      final ratio = availableWidth / image.width;
      final scaledWidth = ratio >= 1 ? image.width : availableWidth;
      final scaledHeight = ratio >= 1 ? image.height : (image.height * ratio);

      header.graphics.drawImage(
        PdfBitmap(image.data),
        Rect.fromCenter(
          center: Offset(availableWidth / 2, scaledHeight / 2 + 4),
          width: scaledWidth * 0.95,
          height: scaledHeight * 0.95,
        ),
      );
    }

    // Title
    if (title != null) {
      final titleY = headerHeight - (4 + headerFont.height);
      header.graphics.drawString(
        title,
        headerFont,
        bounds: Rect.fromLTWH(0, titleY, availableWidth, 0),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: _format.textDirection,
        ),
      );
    }

    // Bottom line
    header.graphics.drawLine(
      PdfPen(PdfColor(0, 0, 0)),
      Offset(0, header.height),
      Offset(availableWidth, header.height),
    );

    _document.template.top = header;
    return header;
  }

  /// Adds a footer to all pages with optional user name and page numbers.
  ///
  /// ## Parameters
  /// - [userName]: Name of the user who generated the document.
  /// - [printTime]: Timestamp text.
  /// - [showPageNumber]: Whether to show page numbers.
  /// - [font]: Footer font.
  PdfPageTemplateElement addFooter({
    String? userName,
    String? printTime,
    bool showPageNumber = false,
    PdfFont? font,
  }) {
    final footerFont = font ?? baseFont;
    final footer = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, availableWidth, 25),
    );

    // User name
    if (userName != null) {
      final userText = 'المستخدم : $userName';
      PdfTextElement(
        text: userText,
        font: footerFont,
        brush: PdfBrushes.black,
        format: _format,
      ).draw(
        graphics: footer.graphics,
        bounds: Rect.fromLTWH(availableWidth - 10, 5, 0, 0),
      );
    }

    // Print time
    if (printTime != null) {
      PdfTextElement(
        text: printTime,
        font: footerFont,
        brush: PdfBrushes.black,
        format: _format,
      ).draw(
        graphics: footer.graphics,
        bounds: const Rect.fromLTWH(200, 5, 0, 0),
      );
    }

    // Page numbers
    if (showPageNumber) {
      final pageNumber = PdfPageNumberField(
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      )..numberStyle = PdfNumberStyle.numeric;

      final pageCount = PdfPageCountField(
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
      )..numberStyle = PdfNumberStyle.numeric;

      PdfCompositeField(
        font: font ?? PdfStandardFont(PdfFontFamily.timesRoman, 12),
        brush: PdfBrushes.black,
        text: '{0}/{1}',
        fields: [pageNumber, pageCount],
      ).draw(
        footer.graphics,
        Offset(footer.width * 0.35, 5),
      );
    }

    // Top line
    final linePen = PdfPen(PdfColor(0, 0, 0), dashStyle: PdfDashStyle.custom)
      ..dashPattern = [2, 2];
    footer.graphics.drawLine(
      linePen,
      const Offset(0, 0),
      Offset(availableWidth, 0),
    );

    _document.template.bottom = footer;
    return footer;
  }

  // ============================================================
  // DRAWING METHODS
  // ============================================================

  /// Draws a horizontal line at the current Y position.
  void addHorizontalLine({
    double? y,
    PdfPen? pen,
    double padding = 0,
  }) {
    final yPos = y ?? currentY + 5;
    final linePen = pen ?? PdfPen(PdfColor(0, 0, 0));
    currentPage.graphics.drawLine(
      linePen,
      Offset(padding, yPos),
      Offset(pageWidth - padding, yPos),
    );
  }

  /// Draws an image at the specified position.
  void addImage(
    GeniusPdfImage image, {
    double? x,
    double? y,
    double? width,
    double? height,
  }) {
    currentPage.graphics.drawImage(
      PdfBitmap(image.data),
      Rect.fromLTWH(
        x ?? 0,
        y ?? currentY,
        width ?? image.width,
        height ?? image.height,
      ),
    );
  }

  /// Adds vertical spacing.
  void addSpace(double height) {
    _spaceOffset += height;
  }

  // ============================================================
  // ABSTRACT METHODS
  // ============================================================

  /// Override this method to build the document content.
  ///
  /// This is called by [generate] before saving the PDF.
  void build();

  // ============================================================
  // GENERATION
  // ============================================================

  /// Builds and returns the PDF document bytes.
  ///
  /// This calls [build] to populate the document, then saves it.
  List<int> generate() {
    _spaceOffset = 0;
    build();
    final bytes = _document.saveSync();
    return bytes;
  }

  /// Disposes of the PDF document and releases resources.
  void dispose() {
    _document.dispose();
  }
}
