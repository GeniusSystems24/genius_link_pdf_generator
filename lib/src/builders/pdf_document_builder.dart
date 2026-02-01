import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../components/widgets/pdf_data_grid.dart';
import '../components/widgets/pdf_summary.dart';
import '../core/pdf_config.dart';
import '../core/pdf_logger.dart';
import '../models/pdf_image.dart';
import '../extensions/color_extensions.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Enums
// ─────────────────────────────────────────────────────────────────────────────

/// Horizontal alignment for images and blocks within the builder.
enum GeniusPdfImageAlignment {
  /// Align to the start (left in LTR, right in RTL).
  start,

  /// Center horizontally.
  center,

  /// Align to the end (right in LTR, left in RTL).
  end,
}

// ─────────────────────────────────────────────────────────────────────────────
// GeniusPdfDocumentBuilder
// ─────────────────────────────────────────────────────────────────────────────

/// Abstract base class for building PDF documents.
///
/// Provides a fluent API for constructing PDF documents with:
/// - **Precise Y-position tracking** via [currentY]
/// - **Automatic page-breaking** when content exceeds the page
/// - **RTL/LTR support** for text and alignment
/// - **Custom headers/footers** applied to all pages
/// - **Image drawing** with alignment and position advancement
///
/// ## Example
/// ```dart
/// class InvoiceDocument extends GeniusPdfDocumentBuilder {
///   InvoiceDocument(super.config);
///
///   @override
///   void build() {
///     addHeader(title: 'Invoice #123');
///     addLine('Customer: John Doe');
///     addLine('Amount: \$100.00');
///     addHorizontalLine();
///     addImage(logoImage, alignment: GeniusPdfImageAlignment.center);
///     addFooter(showPageNumber: true);
///   }
/// }
///
/// final builder = InvoiceDocument(config);
/// final bytes = builder.generate();
/// builder.dispose();
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

  /// The current layout result for text positioning.
  PdfLayoutResult? _layoutResult;

  /// The current page index (0-based, -1 = no pages yet).
  int _currentIndex = -1;

  /// The string format based on text direction (RTL/LTR).
  late final PdfStringFormat _format;

  /// Independent Y-position tracker.
  ///
  /// This is the **primary** position tracker. All draw methods update this
  /// value after rendering. Use [currentY] to read the current position.
  double _currentY = 0;

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

  /// The string format for this document (RTL/LTR).
  PdfStringFormat get format => _format;

  /// The underlying [PdfDocument] instance.
  PdfDocument get document => _document;

  /// The current page width (client area, accounting for margins).
  double get pageWidth => _currentPage?.getClientSize().width ?? 0;

  /// The current page height (client area, accounting for margins).
  double get pageHeight => _currentPage?.getClientSize().height ?? 0;

  /// The available page width accounting for margins and orientation.
  double get availableWidth {
    // Use client size if a page exists (most accurate).
    if (_currentPage != null) return pageWidth;
    // Fallback: calculate from config.
    final margins = config.margins;
    if (config.orientation == PdfPageOrientation.landscape) {
      return config.pageSize.width - (margins.left + margins.right);
    }
    return config.pageSize.width - (margins.left + margins.right);
  }

  /// The current Y position on the page.
  ///
  /// This is the precise vertical position where the next content will be
  /// drawn. All drawing methods (`addLine`, `addImage`, `addHorizontalLine`,
  /// etc.) automatically advance this value after rendering.
  double get currentY => _currentY;

  /// The remaining vertical space on the current page.
  ///
  /// Returns `0` if no page exists yet.
  double get remainingHeight {
    if (_currentPage == null) return 0;
    return pageHeight - _currentY;
  }

  /// Whether content of the given [height] can fit on the current page.
  bool canFit(double height) => remainingHeight >= height;

  /// The bounds of the available content area on the current page.
  ///
  /// Returns a [Rect] starting at `(0, currentY)` with the full page width
  /// and the remaining height.
  Rect get contentBounds =>
      Rect.fromLTWH(0, _currentY, pageWidth, remainingHeight);

  /// The current page (creates one if none exists).
  PdfPage get currentPage {
    if (_currentIndex < 0) return newPage();
    return _currentPage ?? newPage();
  }

  /// Whether the text direction is left-to-right.
  bool get isLTR => config.isLTR;

  /// Whether the text direction is right-to-left.
  bool get isRTL => config.isRTL;

  /// The total number of pages created so far.
  int get pageCount => _currentIndex + 1;

  // ============================================================
  // POSITION MANAGEMENT
  // ============================================================

  /// Advances the Y position by [height] pixels.
  ///
  /// If the new position exceeds the page height, the position is clamped
  /// to the page bottom. Use [_ensureSpace] to auto-break pages.
  void _advanceY(double height) {
    _currentY += height;
    GeniusPdfLogger.debug(
      'Y advanced by $height → $_currentY (remaining: $remainingHeight)',
      tag: 'Builder',
    );
  }

  /// Ensures at least [needed] pixels of vertical space are available.
  ///
  /// If the remaining height is insufficient, creates a new page and
  /// resets the Y position. Returns the page to draw on.
  PdfPage _ensureSpace(double needed) {
    if (_currentPage == null || remainingHeight < needed) {
      GeniusPdfLogger.debug(
        'Auto page-break: needed=$needed, remaining=$remainingHeight',
        tag: 'Builder',
      );
      return newPage();
    }
    return currentPage;
  }

  /// Resets the Y position to [y] (defaults to 0 — top of content area).
  void resetY([double y = 0]) {
    _currentY = y;
  }

  /// Adds vertical spacing without drawing anything.
  ///
  /// This advances [currentY] by [height] pixels.
  void addSpace(double height) {
    _advanceY(height);
  }

  // ============================================================
  // PAGE MANAGEMENT
  // ============================================================

  /// Creates a new page and sets it as the current page.
  ///
  /// Resets [currentY] to `0`. Optionally draws a border around the page.
  /// Returns the newly created [PdfPage].
  PdfPage newPage({PdfPen? borderPen}) {
    final page = _document.pages.add();
    _currentIndex++;
    _currentPage = page;
    _layoutResult = null;
    _currentY = 0;

    GeniusPdfLogger.debug(
      'New page created: index=$_currentIndex',
      tag: 'Builder',
    );

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
  /// The text is drawn at [currentY] plus [topMargin]. After drawing,
  /// [currentY] advances to the bottom of the rendered text.
  ///
  /// If the text does not fit on the current page, a new page is created
  /// automatically (unless [inNewPage] is true, which forces a new page).
  ///
  /// ## Parameters
  /// - [text]: The text to add (required).
  /// - [font]: Custom font (defaults to [baseFont]).
  /// - [brush]: Text color brush.
  /// - [pen]: Text outline pen.
  /// - [space]: Horizontal spacing/indentation.
  /// - [padding]: Horizontal padding around text.
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
    final effectiveFont = font ?? baseFont;
    // Estimate minimum height needed (one line of text + margin).
    final minHeight = effectiveFont.height + topMargin;
    final page = inNewPage ? newPage() : _ensureSpace(minHeight);

    final textElement = PdfTextElement(
      text: text,
      font: effectiveFont,
      brush: brush ?? PdfBrushes.black,
      pen: pen,
      format: isLTR ? null : _format,
    );

    final adjustedSpace = space * (isLTR ? 1 : -1);
    final drawY = _currentY + topMargin;

    _layoutResult = textElement.draw(
      page: page,
      bounds: Rect.fromLTWH(
        padding + adjustedSpace,
        drawY,
        page.getClientSize().width - (padding * 2),
        page.getClientSize().height - drawY,
      ),
      format: config.layoutFormat,
    );

    // Update _currentY from the layout result.
    if (_layoutResult != null) {
      _currentY = _layoutResult!.bounds.bottom;
    }
  }

  /// Adds text at a specific position on the current page.
  ///
  /// This does **not** affect [currentY] — it is used for absolute
  /// positioning only.
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
  ///
  /// Positions text at the same Y as the previous layout result, offset
  /// horizontally by [horizontalOffset].
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
      format: isLTR ? null : _format,
    );

    final adjustedOffset = horizontalOffset * (isLTR ? 1 : -1);
    final drawY = (_layoutResult?.bounds.top ?? _currentY) + topMargin;

    _layoutResult = textElement.draw(
      page: page,
      bounds: Rect.fromLTWH(
        adjustedOffset,
        drawY,
        page.getClientSize().width - (padding * 2),
        page.getClientSize().height - drawY,
      ),
      format: config.layoutFormat,
    );

    // Update _currentY to the bottom of the inline text.
    if (_layoutResult != null) {
      _currentY = _layoutResult!.bounds.bottom;
    }
  }

  // ============================================================
  // HEADER & FOOTER
  // ============================================================

  /// Adds a header to all pages with optional image and title.
  ///
  /// The header is rendered as a [PdfPageTemplateElement] applied to every
  /// page in the document.
  ///
  /// ## Parameters
  /// - [image]: Header image (logo).
  /// - [title]: Document title text.
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
  /// - [userLabel]: Label text before the username (defaults to `'User: '`).
  /// - [printTime]: Timestamp text.
  /// - [showPageNumber]: Whether to show page numbers.
  /// - [font]: Footer font.
  /// - [pageNumberFormat]: Page number format (defaults to `'{0}/{1}'`).
  PdfPageTemplateElement addFooter({
    String? userName,
    String? userLabel,
    String? printTime,
    bool showPageNumber = false,
    PdfFont? font,
    String pageNumberFormat = '{0}/{1}',
  }) {
    final footerFont = font ?? baseFont;
    final footer = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, availableWidth, 25),
    );

    // User name — dynamic positioning.
    if (userName != null) {
      final label = userLabel ?? (isRTL ? 'المستخدم : ' : 'User: ');
      final userText = '$label$userName';
      final userX = isRTL ? availableWidth - 10 : 5;

      PdfTextElement(
        text: userText,
        font: footerFont,
        brush: PdfBrushes.black,
        format: _format,
      ).draw(
        graphics: footer.graphics,
        bounds: Rect.fromLTWH(userX, 5, 0, 0),
      );
    }

    // Print time — dynamic positioning.
    if (printTime != null) {
      final timeX = availableWidth * 0.35;

      PdfTextElement(
        text: printTime,
        font: footerFont,
        brush: PdfBrushes.black,
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: _format.textDirection,
        ),
      ).draw(
        graphics: footer.graphics,
        bounds: Rect.fromLTWH(timeX, 5, 0, 0),
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

      // Position: RTL → right side, LTR → left side.
      final pnX = isRTL ? availableWidth * 0.05 : availableWidth * 0.85;

      PdfCompositeField(
        font: font ?? PdfTrueTypeFont(config.baseFontBytes, 12),
        brush: PdfBrushes.black,
        text: pageNumberFormat,
        fields: [pageNumber, pageCount],
      ).draw(
        footer.graphics,
        Offset(pnX, 5),
      );
    }

    // Top line (dashed).
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

  /// Draws a horizontal line.
  ///
  /// If [y] is not specified, the line is drawn at the current Y position
  /// plus [spacing]. After drawing, [currentY] is advanced by the line
  /// thickness plus [spacing] (unless [advancePosition] is `false`).
  ///
  /// ## Parameters
  /// - [y]: Explicit Y position (overrides automatic positioning).
  /// - [pen]: Line style (defaults to 1px black solid).
  /// - [padding]: Horizontal padding on both sides.
  /// - [spacing]: Vertical space before and after the line.
  /// - [advancePosition]: Whether to advance [currentY] after drawing.
  void addHorizontalLine({
    double? y,
    PdfPen? pen,
    double padding = 0,
    double spacing = 5,
    bool advancePosition = true,
  }) {
    final linePen = pen ?? PdfPen(PdfColor(0, 0, 0));
    final yPos = y ?? (_currentY + spacing);

    if (advancePosition && y == null) {
      _ensureSpace(spacing * 2 + 1);
    }

    currentPage.graphics.drawLine(
      linePen,
      Offset(padding, yPos),
      Offset(pageWidth - padding, yPos),
    );

    if (advancePosition) {
      _currentY = yPos + spacing;
    }
  }

  /// Draws an image at the specified position.
  ///
  /// By default, the image is drawn at [currentY] and [currentY] is advanced
  /// by the image height. Use [advancePosition] = `false` to draw without
  /// affecting the Y position.
  ///
  /// ## Parameters
  /// - [image]: The image to draw.
  /// - [x]: Explicit X position (overrides [alignment]).
  /// - [y]: Explicit Y position (overrides [currentY]).
  /// - [width]: Override image width.
  /// - [height]: Override image height.
  /// - [alignment]: Horizontal alignment (start/center/end).
  /// - [spacing]: Vertical space before the image.
  /// - [advancePosition]: Whether to advance [currentY] after drawing.
  void addImage(
    GeniusPdfImage image, {
    double? x,
    double? y,
    double? width,
    double? height,
    GeniusPdfImageAlignment alignment = GeniusPdfImageAlignment.start,
    double spacing = 0,
    bool advancePosition = true,
  }) {
    final drawWidth = width ?? image.width;
    final drawHeight = height ?? image.height;
    final drawY = y ?? (_currentY + spacing);

    if (advancePosition && y == null) {
      _ensureSpace(drawHeight + spacing);
    }

    // Calculate X position based on alignment.
    final drawX = x ?? _resolveAlignment(alignment, drawWidth);

    currentPage.graphics.drawImage(
      PdfBitmap(image.data),
      Rect.fromLTWH(drawX, drawY, drawWidth, drawHeight),
    );

    if (advancePosition) {
      _currentY = drawY + drawHeight;
    }
  }

  /// Resolves horizontal alignment to an X coordinate.
  double _resolveAlignment(GeniusPdfImageAlignment alignment, double width) {
    switch (alignment) {
      case GeniusPdfImageAlignment.start:
        return isRTL ? (pageWidth - width) : 0;
      case GeniusPdfImageAlignment.center:
        return (pageWidth - width) / 2;
      case GeniusPdfImageAlignment.end:
        return isRTL ? 0 : (pageWidth - width);
    }
  }

  // ============================================================
  // GRID & SUMMARY METHODS (v2.5.0)
  // ============================================================

  /// Draws a [GeniusPdfDataGrid] at the current Y position.
  ///
  /// The grid is rendered starting at [currentY] + [spacing]. After drawing,
  /// [currentY] advances to the bottom of the grid. The grid uses Syncfusion's
  /// built-in pagination — if the grid overflows the page, continuation pages
  /// are created by the grid itself.
  ///
  /// Returns the [PdfLayoutResult] from the grid draw operation (or `null`
  /// if no rows were drawn).
  ///
  /// ## Example
  /// ```dart
  /// final grid = GeniusPdfDataGrid(
  ///   config: config,
  ///   columns: myColumns,
  ///   rows: myRows,
  /// );
  /// addGrid(grid, spacing: 10);
  /// ```
  PdfLayoutResult? addGrid(
    GeniusPdfDataGrid grid, {
    double spacing = 0,
  }) {
    final page = currentPage;
    final drawY = _currentY + spacing;

    GeniusPdfLogger.debug(
      'Drawing grid at Y=$drawY (${grid.columns.length} cols, ${grid.rows.length} rows)',
      tag: 'Builder',
    );

    final result = grid.drawAt(
      page: page,
      x: 0,
      y: drawY,
      width: pageWidth,
    );

    if (result != null) {
      _currentY = result.bounds.bottom;
      GeniusPdfLogger.debug(
        'Grid drawn → Y=${_currentY.toStringAsFixed(1)}',
        tag: 'Builder',
      );
    }

    return result;
  }

  /// Draws a [GeniusPdfSummarySection] at the current Y position.
  ///
  /// The summary is rendered starting at [currentY] + [spacing]. After drawing,
  /// [currentY] advances to the bottom of the summary box.
  ///
  /// Returns the bounding [Rect] of the drawn summary.
  ///
  /// ## Example
  /// ```dart
  /// final summary = GeniusPdfSummarySection(
  ///   config: config,
  ///   items: [
  ///     GeniusPdfSummaryItem.subtotal(label: 'Subtotal', labelAr: 'المجموع', value: '1,000'),
  ///     GeniusPdfSummaryItem.total(label: 'Total', labelAr: 'الإجمالي', value: '1,150'),
  ///   ],
  /// );
  /// addSummary(summary, spacing: 10);
  /// ```
  Rect addSummary(
    GeniusPdfSummarySection summary, {
    double spacing = 0,
  }) {
    final page = currentPage;
    final drawY = _currentY + spacing;

    GeniusPdfLogger.debug(
      'Drawing summary at Y=$drawY (${summary.items.length} items)',
      tag: 'Builder',
    );

    final bounds = summary.draw(
      page: page,
      bounds: Rect.fromLTWH(0, drawY, pageWidth, remainingHeight),
    );

    _currentY = bounds.bottom;
    GeniusPdfLogger.debug(
      'Summary drawn → Y=${_currentY.toStringAsFixed(1)}',
      tag: 'Builder',
    );

    return bounds;
  }

  /// Draws a grid followed by its summary section.
  ///
  /// This is a convenience method that combines [addGrid] and [addSummary].
  /// The grid is drawn first, then the summary is drawn below it with
  /// [summarySpacing] pixels of gap between them.
  ///
  /// Returns a record containing both results.
  ///
  /// ## Example
  /// ```dart
  /// addGridWithSummary(
  ///   grid: myGrid,
  ///   summary: mySummary,
  ///   gridSpacing: 10,
  ///   summarySpacing: 15,
  /// );
  /// ```
  ({PdfLayoutResult? gridResult, Rect summaryBounds}) addGridWithSummary({
    required GeniusPdfDataGrid grid,
    required GeniusPdfSummarySection summary,
    double gridSpacing = 0,
    double summarySpacing = 10,
  }) {
    final gridResult = addGrid(grid, spacing: gridSpacing);
    final summaryBounds = addSummary(summary, spacing: summarySpacing);
    return (gridResult: gridResult, summaryBounds: summaryBounds);
  }

  /// Draws an overall report summary that aggregates data from multiple grids.
  ///
  /// Use this to add a final summary at the end of a report that totals up
  /// values from all previous grids. An optional [title] is drawn as a bold
  /// heading above the summary.
  ///
  /// ## Example
  /// ```dart
  /// addReportSummary(
  ///   summary: GeniusPdfSummarySection(
  ///     config: config,
  ///     items: [
  ///       GeniusPdfSummaryItem.subtotal(label: 'Total Sales', labelAr: 'إجمالي المبيعات', value: '50,000'),
  ///       GeniusPdfSummaryItem.total(label: 'Grand Total', labelAr: 'الإجمالي الكلي', value: '57,500'),
  ///     ],
  ///   ),
  ///   title: 'Report Summary',
  ///   titleAr: 'ملخص التقرير',
  ///   spacing: 20,
  /// );
  /// ```
  Rect addReportSummary({
    required GeniusPdfSummarySection summary,
    String? title,
    String? titleAr,
    double spacing = 15,
  }) {
    addSpace(spacing);

    // Draw title if provided.
    if (title != null || titleAr != null) {
      final displayTitle = (isRTL && titleAr != null) ? titleAr : title;
      if (displayTitle != null) {
        addSectionDivider(title: displayTitle, spacing: 0);
        addSpace(10);
      }
    }

    return addSummary(summary, spacing: 0);
  }

  /// Draws a section divider — a horizontal line with an optional centered title.
  ///
  /// Useful for separating report sections visually. If [title] is provided,
  /// the text is centered on the divider line with a small gap.
  ///
  /// ## Example
  /// ```dart
  /// addSectionDivider(title: 'Sales Section', spacing: 15);
  /// ```
  void addSectionDivider({
    String? title,
    double spacing = 10,
    PdfPen? pen,
    PdfFont? font,
    PdfBrush? brush,
  }) {
    final dividerPen = pen ?? PdfPen(PdfColor(180, 180, 180));
    final dividerFont = font ?? baseFont;
    final dividerBrush = brush ?? PdfSolidBrush(PdfColor(120, 120, 120));

    _advanceY(spacing);

    if (title != null) {
      // Draw a line-title-line pattern.
      final page = currentPage;
      final textSize = dividerFont.measureString(title);
      final gapWidth = 10.0;
      final textX = (pageWidth - textSize.width) / 2;
      final lineY = _currentY + textSize.height / 2;

      // Left line.
      page.graphics.drawLine(
        dividerPen,
        Offset(0, lineY),
        Offset(textX - gapWidth, lineY),
      );

      // Title text.
      page.graphics.drawString(
        title,
        dividerFont,
        brush: dividerBrush,
        bounds: Rect.fromLTWH(textX, _currentY, textSize.width, 0),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );

      // Right line.
      page.graphics.drawLine(
        dividerPen,
        Offset(textX + textSize.width + gapWidth, lineY),
        Offset(pageWidth, lineY),
      );

      _advanceY(textSize.height + spacing);
    } else {
      // Simple horizontal line.
      addHorizontalLine(pen: dividerPen, spacing: 0);
      _advanceY(spacing);
    }
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
  /// Calls [build] to populate the document, then serializes to bytes.
  List<int> generate() {
    _currentY = 0;
    build();
    final bytes = _document.saveSync();
    return bytes;
  }

  /// Disposes of the PDF document and releases resources.
  void dispose() {
    _document.dispose();
  }
}
