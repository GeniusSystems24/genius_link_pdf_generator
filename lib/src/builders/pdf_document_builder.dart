import 'dart:typed_data';
import 'dart:ui';

import 'package:barcode/barcode.dart' as bc;
import 'package:image/image.dart' as img;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../components/widgets/pdf_barcode.dart';
import '../components/widgets/pdf_data_grid.dart';
import '../components/widgets/pdf_info_box.dart';
import '../components/widgets/pdf_report_header.dart';
import '../components/widgets/pdf_rich_text.dart';
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

  /// Default page border pen applied to newly created pages.
  PdfPen? _defaultPageBorderPen;

  /// The string format based on text direction (RTL/LTR).
  late final PdfStringFormat _format;

  /// Independent Y-position tracker.
  ///
  /// This is the **primary** position tracker. All draw methods update this
  /// value after rendering. Use [currentY] to read the current position.
  double _currentY = 0;

  /// Height reserved by the page header template.
  ///
  /// When a header is added via [addHeader], this value is set to the
  /// header's height. All new pages start with [currentY] offset by this
  /// amount, and [remainingHeight] accounts for it automatically.
  double _headerHeight = 0;

  /// Height reserved by the page footer template.
  ///
  /// When a footer is added via [addFooter], this value is set to the
  /// footer's height. [remainingHeight] subtracts this to prevent content
  /// from overlapping the footer area.
  double _footerHeight = 0;

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

  /// The height reserved by the page header template.
  double get headerHeight => _headerHeight;

  /// The height reserved by the page footer template.
  double get footerHeight => _footerHeight;

  /// The effective page height available for content (excluding header and footer).
  double get effectivePageHeight => pageHeight - _headerHeight - _footerHeight;

  /// The remaining vertical space on the current page.
  ///
  /// Accounts for both the current Y position and the footer reserved area.
  /// Returns `0` if no page exists yet.
  double get remainingHeight {
    if (_currentPage == null) return 0;
    return pageHeight - _currentY - _footerHeight;
  }

  /// Whether content of the given [height] can fit on the current page.
  bool canFit(double height) => remainingHeight >= height;

  /// The bounds of the available content area on the current page.
  ///
  /// Returns a [Rect] starting at `(0, currentY)` with the full page width
  /// and the remaining height (accounting for footer).
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
    final requiredHeight = needed < 0 ? 0 : needed;
    if (_currentPage == null || remainingHeight < requiredHeight) {
      GeniusPdfLogger.debug(
        'Auto page-break: needed=$requiredHeight, remaining=$remainingHeight',
        tag: 'Builder',
      );
      return newPage();
    }
    return currentPage;
  }

  /// Resets the Y position to [y] (defaults to the header height —
  /// top of the content area below the header).
  void resetY([double? y]) {
    _currentY = y ?? _headerHeight;
  }

  /// Manually reserves header space without adding a visual header.
  ///
  /// Use this when you draw your own custom header and need the builder
  /// to account for the occupied space on new pages.
  void reserveHeaderSpace(double height) {
    _headerHeight = height;
    GeniusPdfLogger.debug(
      'Header space reserved: $height',
      tag: 'Builder',
    );
  }

  /// Manually reserves footer space without adding a visual footer.
  ///
  /// Use this when you draw your own custom footer and need the builder
  /// to prevent content from overlapping the footer area.
  void reserveFooterSpace(double height) {
    _footerHeight = height;
    GeniusPdfLogger.debug(
      'Footer space reserved: $height',
      tag: 'Builder',
    );
  }

  /// Sets a default border pen to apply on every new page.
  ///
  /// Pass `null` to disable the default border.
  void setDefaultPageBorder(PdfPen? pen) {
    _defaultPageBorderPen = pen;
  }

  /// Sets the current page to [page] and optionally updates the Y position.
  ///
  /// This is useful when a component (like a grid) creates new pages during
  /// rendering and you need to synchronize the builder's state with the
  /// component's final page.
  void setCurrentPage(PdfPage page, {double? y}) {
    _currentPage = page;
    // Find the index of this page in the document
    for (int i = 0; i < _document.pages.count; i++) {
      if (_document.pages[i] == page) {
        _currentIndex = i;
        break;
      }
    }
    if (y != null) {
      _currentY = y < _headerHeight ? _headerHeight : y;
    }
    GeniusPdfLogger.debug(
      'Page set to index=$_currentIndex, Y=$_currentY',
      tag: 'Builder',
    );
  }

  /// Updates the current page and Y position from a [PdfLayoutResult].
  ///
  /// This is essential for handling multi-page content like grids that may
  /// span multiple pages. The result's [page] becomes the current page,
  /// and [currentY] is set to the bottom of the result's bounds plus
  /// optional [spacing].
  void updateFromLayoutResult(PdfLayoutResult result, {double spacing = 0}) {
    _layoutResult = result;
    setCurrentPage(result.page, y: result.bounds.bottom + spacing);
  }

  /// Adds vertical spacing without drawing anything.
  ///
  /// This advances [currentY] by [height] pixels.
  void addSpace(double height) {
    if (height <= 0) return;

    currentPage;
    var remainingSpacing = height;

    while (remainingSpacing > 0) {
      final available = remainingHeight;
      if (available <= 0) {
        newPage();
        continue;
      }

      if (remainingSpacing <= available) {
        _advanceY(remainingSpacing);
        break;
      }

      _advanceY(available);
      remainingSpacing -= available;
      newPage();
    }
  }

  // ============================================================
  // PAGE MANAGEMENT
  // ============================================================

  /// Creates a new page and sets it as the current page.
  ///
  /// Resets [currentY] to [headerHeight] (the top of the content area below
  /// the header template). Optionally draws a border around the page.
  /// Returns the newly created [PdfPage].
  PdfPage newPage({PdfPen? borderPen}) {
    final page = _document.pages.add();
    _currentIndex = _document.pages.count - 1;
    _currentPage = page;
    _layoutResult = null;
    _currentY = _headerHeight;

    GeniusPdfLogger.debug(
      'New page created: index=$_currentIndex, startY=$_headerHeight',
      tag: 'Builder',
    );

    final effectiveBorderPen = borderPen ?? _defaultPageBorderPen;
    if (effectiveBorderPen != null) {
      page.graphics.drawRectangle(
        bounds: Rect.fromLTWH(
          0,
          0,
          page.getClientSize().width,
          page.getClientSize().height,
        ),
        pen: effectiveBorderPen,
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
      format: _format,
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
      updateFromLayoutResult(_layoutResult!);
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
      format: _format,
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
      updateFromLayoutResult(_layoutResult!);
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

    // Store header height for space calculations.
    _headerHeight = headerHeight;

    // Adjust current page Y if we're on the first page and still at 0.
    if (_currentPage != null && _currentY < _headerHeight) {
      _currentY = _headerHeight;
    }

    GeniusPdfLogger.debug(
      'Header added: height=$headerHeight, _currentY=$_currentY',
      tag: 'Builder',
    );

    return header;
  }

  /// Adds a footer to all pages with optional user name, QR code, and page numbers.
  ///
  /// ## Parameters
  /// - [userName]: Name of the user who generated the document.
  /// - [userLabel]: Label text before the username (defaults to `'User: '`).
  /// - [printTime]: Timestamp text.
  /// - [showPageNumber]: Whether to show page numbers.
  /// - [font]: Footer font.
  /// - [pageNumberFormat]: Page number format (defaults to `'{0}/{1}'`).
  /// - [qrCodeUrl]: URL for QR code to display in footer.
  /// - [qrCodeSize]: Size of QR code (defaults to 50).
  PdfPageTemplateElement addFooter({
    String? userName,
    String? userLabel,
    String? printTime,
    bool showPageNumber = false,
    PdfFont? font,
    String pageNumberFormat = '{0}/{1}',
    String? qrCodeUrl,
    double qrCodeSize = 50,
  }) {
    final footerFont = font ?? baseFont;
    final hasQrCode = qrCodeUrl != null && qrCodeUrl.isNotEmpty;
    final footerHeight = hasQrCode ? qrCodeSize + 15 : 25.0;

    final footer = PdfPageTemplateElement(
      Rect.fromLTWH(0, 0, availableWidth, footerHeight),
    );

    // QR Code - left side (RTL: right side)
    if (hasQrCode) {
      try {
        final qrSize = (qrCodeSize - 10).toInt();
        final qrCode = bc.Barcode.qrCode();
        final qrData = qrCode.make(qrCodeUrl,
            width: qrSize.toDouble(), height: qrSize.toDouble());

        // Create QR image
        final image = img.Image(width: qrSize, height: qrSize);
        img.fill(image, color: img.ColorRgba8(255, 255, 255, 255));

        final fgColor = img.ColorRgba8(0, 0, 0, 255);
        for (final element in qrData) {
          if ((element is bc.BarcodeBar) && element.black) {
            final x1 = element.left.clamp(0, qrSize - 1).toInt();
            final y1 = element.top.clamp(0, qrSize - 1).toInt();
            final x2 = (element.left + element.width).clamp(0, qrSize).toInt();
            final y2 = (element.top + element.height).clamp(0, qrSize).toInt();
            for (int y = y1; y < y2; y++) {
              for (int x = x1; x < x2; x++) {
                image.setPixel(x, y, fgColor);
              }
            }
          }
        }

        final qrImage = Uint8List.fromList(img.encodePng(image));
        final qrX = isRTL ? availableWidth - qrCodeSize : 5.0;

        footer.graphics.drawImage(
          PdfBitmap(qrImage),
          Rect.fromLTWH(qrX, 8, qrCodeSize - 10, qrCodeSize - 10),
        );
      } catch (e) {
        GeniusPdfLogger.warning('Failed to draw QR code in footer: $e',
            tag: 'Footer');
      }
    }

    // Calculate text offset based on QR code presence
    final textOffsetX = hasQrCode ? qrCodeSize + 5 : 0.0;
    final textY = hasQrCode ? (footerHeight - footerFont.height) / 2 : 5.0;

    // User name — dynamic positioning.
    if (userName != null) {
      final label = userLabel ?? (isRTL ? 'المستخدم : ' : 'User: ');
      final userText = '$label$userName';
      final userX = isRTL ? availableWidth - textOffsetX - 10 : textOffsetX + 5;

      PdfTextElement(
        text: userText,
        font: footerFont,
        brush: PdfBrushes.black,
        format: _format,
      ).draw(
        graphics: footer.graphics,
        bounds: Rect.fromLTWH(userX, textY, 0, 0),
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
        bounds: Rect.fromLTWH(timeX, textY, 0, 0),
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

      // Position: RTL → left side (after QR), LTR → right side (before QR)
      final pnX = isRTL
          ? (hasQrCode ? textOffsetX + 5 : availableWidth * 0.05)
          : (hasQrCode
              ? availableWidth - qrCodeSize - 60
              : availableWidth * 0.85);

      PdfCompositeField(
        font: font ?? PdfTrueTypeFont(config.baseFontBytes, 12),
        brush: PdfBrushes.black,
        text: pageNumberFormat,
        fields: [pageNumber, pageCount],
      ).draw(
        footer.graphics,
        Offset(pnX, textY),
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

    // Store footer height for space calculations.
    _footerHeight = footerHeight;

    GeniusPdfLogger.debug(
      'Footer added: height=$footerHeight',
      tag: 'Builder',
    );

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
    if (advancePosition && y == null) {
      _ensureSpace(spacing * 2 + 1);
    }

    final yPos = y ?? (_currentY + spacing);

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
    var drawableImage = image.copyWith(
      width: width ?? image.width,
      height: height ?? image.height,
    );
    if (drawableImage.width <= 0 || drawableImage.height <= 0) {
      throw StateError(
        'Image bounds must be positive: '
        '${drawableImage.width}x${drawableImage.height}',
      );
    }

    if (advancePosition && y == null) {
      currentPage;
      final requiredHeight = drawableImage.height + spacing;
      final fullPageAvailableHeight = effectivePageHeight - spacing;
      final currentAvailableHeight = remainingHeight - spacing;

      if (currentAvailableHeight <= 0) {
        newPage();
      } else if (requiredHeight > currentAvailableHeight &&
          fullPageAvailableHeight > currentAvailableHeight) {
        newPage();
      }

      drawableImage = _scaleImageToFitContent(
        drawableImage,
        maxWidth: pageWidth,
        maxHeight: remainingHeight - spacing,
        context: 'image',
      );
    }

    final drawWidth = drawableImage.width;
    final drawHeight = drawableImage.height;
    final drawY = y ?? (_currentY + spacing);

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

  GeniusPdfImage _scaleImageToFitContent(
    GeniusPdfImage image, {
    required double maxWidth,
    required double maxHeight,
    required String context,
  }) {
    if (maxWidth <= 0 || maxHeight <= 0) {
      throw StateError(
        'Not enough content space to place $context '
        '(${maxWidth.toStringAsFixed(1)}x${maxHeight.toStringAsFixed(1)})',
      );
    }

    if (image.width <= maxWidth && image.height <= maxHeight) {
      return image;
    }

    final scaled = image.scaledToFit(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
    );
    if (scaled.width <= 0 || scaled.height <= 0) {
      throw StateError('Failed to scale $context into the available bounds');
    }

    return scaled;
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
      updateFromLayoutResult(result);
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
    final estimatedHeight = summary.estimateHeight() + spacing;
    final page = _ensureSpace(estimatedHeight);
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

    // Ensure space for divider line + text + spacing.
    final neededHeight =
        (title != null ? dividerFont.height : 1.0) + spacing * 2;
    _ensureSpace(neededHeight);

    _advanceY(spacing);

    if (title != null) {
      // Draw a line-title-line pattern.
      final page = currentPage;
      final textSize = dividerFont.measureString(title);
      const gapWidth = 10.0;
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
        format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            textDirection: config.pdfTextDirection),
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
  // QR CODE & IMAGE ATTACHMENTS (v2.7.0)
  // ============================================================

  /// Draws a [GeniusPdfQRCodeGenerator] at the current Y position.
  ///
  /// The QR code is rendered at [currentY] + [spacing]. After drawing,
  /// [currentY] advances to the bottom of the QR code area.
  ///
  /// The [size] parameter controls the QR code dimensions (default: 120px).
  /// Use [alignment] to position the QR code horizontally.
  ///
  /// ## Example
  /// ```dart
  /// final qr = GeniusPdfQRCodeGenerator.url(
  ///   url: 'https://example.com',
  ///   config: config,
  /// );
  /// addQRCode(qr, alignment: GeniusPdfImageAlignment.center, spacing: 10);
  /// ```
  Rect addQRCode(
    GeniusPdfQRCodeGenerator qrCode, {
    double size = 120,
    GeniusPdfImageAlignment alignment = GeniusPdfImageAlignment.start,
    double spacing = 0,
  }) {
    currentPage;
    const captionAllowance = 30.0;
    final maxDrawableSize =
        pageWidth < (effectivePageHeight - captionAllowance)
            ? pageWidth
            : (effectivePageHeight - captionAllowance);
    if (maxDrawableSize <= 0) {
      throw StateError('Not enough content space to place QR code');
    }

    final drawSize = size < maxDrawableSize ? size : maxDrawableSize;
    final currentAvailableHeight = remainingHeight - spacing - captionAllowance;
    final fullPageAvailableHeight =
        effectivePageHeight - spacing - captionAllowance;
    if (currentAvailableHeight <= 0) {
      newPage();
    } else if (drawSize > currentAvailableHeight &&
        fullPageAvailableHeight > currentAvailableHeight) {
      newPage();
    }

    final page = _ensureSpace(drawSize + spacing + captionAllowance);
    final drawY = _currentY + spacing;

    final x = _resolveAlignment(alignment, drawSize);

    GeniusPdfLogger.debug(
      'Drawing QR code at Y=$drawY, X=$x (size=$drawSize)',
      tag: 'Builder',
    );

    final bounds = qrCode.draw(
      page: page,
      bounds: Rect.fromLTWH(x, drawY, drawSize, drawSize),
    );

    _currentY = bounds.bottom;
    GeniusPdfLogger.debug(
      'QR code drawn → Y=${_currentY.toStringAsFixed(1)}',
      tag: 'Builder',
    );

    return bounds;
  }

  /// Draws an image as a labeled attachment at the current Y position.
  ///
  /// This renders a title label above the image, then the image itself.
  /// The image is scaled to fit within the page width while preserving
  /// the aspect ratio. After drawing, [currentY] advances past the image.
  ///
  /// ## Example
  /// ```dart
  /// addImageAttachment(
  ///   invoiceImage,
  ///   title: 'Supplier Invoice',
  ///   titleAr: 'فاتورة المورد',
  ///   spacing: 15,
  /// );
  /// ```
  void addImageAttachment(
    GeniusPdfImage image, {
    String? title,
    String? titleAr,
    double spacing = 10,
    double maxWidth = double.infinity,
    GeniusPdfImageAlignment alignment = GeniusPdfImageAlignment.center,
  }) {
    addSpace(spacing);

    // Draw title if provided.
    if (title != null || titleAr != null) {
      final displayTitle = (isRTL && titleAr != null) ? titleAr : title;
      if (displayTitle != null) {
        addLine(displayTitle, font: config.boldFont, topMargin: 0);
        addSpace(5);
      }
    }

    // Scale image to fit available width.
    final targetWidth = maxWidth == double.infinity
        ? (image.width > pageWidth ? pageWidth : image.width)
        : (maxWidth > pageWidth ? pageWidth : maxWidth);

    final scaled =
        image.width > targetWidth ? image.scaledToWidth(targetWidth) : image;

    addImage(scaled, alignment: alignment, spacing: 0);
  }

  /// Adds an image on a dedicated new page.
  ///
  /// Creates a new page, optionally draws a title, then renders the image
  /// scaled to fit the full page content area. This is ideal for scanned
  /// documents, supplier invoices, receipts, etc.
  ///
  /// ## Example
  /// ```dart
  /// addImagePage(
  ///   scannedInvoice,
  ///   title: 'Attachment: Supplier Invoice',
  ///   titleAr: 'مرفق: فاتورة المورد',
  /// );
  /// ```
  void addImagePage(
    GeniusPdfImage image, {
    String? title,
    String? titleAr,
  }) {
    newPage();

    GeniusPdfLogger.debug(
      'Adding image page (${image.width}x${image.height})',
      tag: 'Builder',
    );

    // Draw title if provided.
    if (title != null || titleAr != null) {
      final displayTitle = (isRTL && titleAr != null) ? titleAr : title;
      if (displayTitle != null) {
        addLine(displayTitle, font: config.boldFont, topMargin: 5);
        addSpace(10);
      }
    }

    // Scale image to fit page content area.
    final maxWidth = pageWidth;
    final maxHeight = remainingHeight - 10;
    final scaled = _scaleImageToFitContent(
      image,
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      context: 'image attachment',
    );

    addImage(
      scaled,
      alignment: GeniusPdfImageAlignment.center,
      spacing: 0,
    );
  }

  /// Adds multiple images, each on its own page.
  ///
  /// Iterates through [images] and calls [addImagePage] for each one.
  /// Optional [titles] and [titlesAr] lists provide per-image headings.
  ///
  /// ## Example
  /// ```dart
  /// addAttachments(
  ///   [receipt1, receipt2, receipt3],
  ///   titles: ['Receipt #1', 'Receipt #2', 'Receipt #3'],
  ///   titlesAr: ['إيصال #1', 'إيصال #2', 'إيصال #3'],
  /// );
  /// ```
  void addAttachments(
    List<GeniusPdfImage> images, {
    List<String>? titles,
    List<String>? titlesAr,
  }) {
    for (var i = 0; i < images.length; i++) {
      addImagePage(
        images[i],
        title: titles != null && i < titles.length ? titles[i] : null,
        titleAr: titlesAr != null && i < titlesAr.length ? titlesAr[i] : null,
      );
    }
  }

  // ============================================================
  // ADVANCED LAYOUT METHODS (v2.8.0)
  // ============================================================

  /// Draws a [GeniusPdfRichText] at the current Y position.
  ///
  /// After drawing, [currentY] advances to the bottom of the rendered text.
  /// Returns the [PdfLayoutResult] from the rich text draw operation.
  ///
  /// ## Example
  /// ```dart
  /// final richText = GeniusPdfRichTextBuilder(config: config)
  ///     .bold('Total: ')
  ///     .text('SAR 1,500.00')
  ///     .build();
  /// addRichText(richText, spacing: 10);
  /// ```
  PdfLayoutResult? addRichText(
    GeniusPdfRichText richText, {
    double spacing = 0,
  }) {
    // Estimate minimum height: at least one line of text.
    final minHeight = baseFont.height + spacing + 10;
    final page = _ensureSpace(minHeight);
    final drawY = _currentY + spacing;

    GeniusPdfLogger.debug(
      'Drawing rich text at Y=$drawY',
      tag: 'Builder',
    );

    final result = richText.draw(
      page: page,
      bounds: Rect.fromLTWH(0, drawY, pageWidth, remainingHeight - spacing),
    );

    if (result != null) {
      updateFromLayoutResult(result);
    }

    return result;
  }

  /// Draws a [GeniusPdfInfoBox] at the current Y position.
  ///
  /// After drawing, [currentY] advances to the bottom of the info box.
  /// Returns the bounding [Rect] of the drawn info box.
  ///
  /// ## Example
  /// ```dart
  /// final infoBox = GeniusPdfInfoBox(
  ///   config: config,
  ///   title: 'Company Info',
  ///   titleAr: 'معلومات الشركة',
  ///   items: [
  ///     GeniusPdfLabeledValue(label: 'Name', labelAr: 'الاسم', value: 'Genius Systems'),
  ///   ],
  /// );
  /// addInfoBox(infoBox, spacing: 10);
  /// ```
  Rect addInfoBox(
    GeniusPdfInfoBox infoBox, {
    double spacing = 0,
    double? height,
  }) {
    final estimatedHeight = (height ?? infoBox.estimateHeight(pageWidth)) + spacing;
    final page = _ensureSpace(estimatedHeight);
    final drawY = _currentY + spacing;

    GeniusPdfLogger.debug(
      'Drawing info box at Y=$drawY',
      tag: 'Builder',
    );

    final bounds = infoBox.draw(
      page: page,
      bounds: Rect.fromLTWH(
        0,
        drawY,
        pageWidth,
        height ?? (remainingHeight - spacing),
      ),
    );

    _currentY = bounds.bottom;
    GeniusPdfLogger.debug(
      'Info box drawn → Y=${_currentY.toStringAsFixed(1)}',
      tag: 'Builder',
    );

    return bounds;
  }

  /// Draws a [GeniusPdfReportHeader] at the current Y position.
  ///
  /// After drawing, [currentY] advances by the header height.
  /// Returns the height of the drawn header.
  ///
  /// ## Example
  /// ```dart
  /// final header = GeniusPdfReportHeader(
  ///   config: config,
  ///   title: 'Sales Report',
  ///   titleAr: 'تقرير المبيعات',
  ///   company: myCompanyInfo,
  /// );
  /// addReportHeader(header);
  /// ```
  double addReportHeader(
    GeniusPdfReportHeader reportHeader, {
    double spacing = 0,
    double height = 100,
  }) {
    final estimatedHeight = reportHeader.estimateHeight(availableWidth: pageWidth);
    final page = _ensureSpace(
      (estimatedHeight > height ? estimatedHeight : height) + spacing,
    );
    final drawY = _currentY + spacing;

    GeniusPdfLogger.debug(
      'Drawing report header at Y=$drawY',
      tag: 'Builder',
    );

    final headerHeight = reportHeader.draw(
      page: page,
      bounds: Rect.fromLTWH(0, drawY, pageWidth, height),
    );

    _currentY = drawY + headerHeight;
    GeniusPdfLogger.debug(
      'Report header drawn → Y=${_currentY.toStringAsFixed(1)} (height=$headerHeight)',
      tag: 'Builder',
    );

    return headerHeight;
  }

  /// Draws two content blocks side by side.
  ///
  /// This creates a two-column layout by calling [leftContent] and
  /// [rightContent] callbacks with the appropriate bounds. After both
  /// columns are drawn, [currentY] advances to the bottom of the
  /// tallest column.
  ///
  /// ## Example
  /// ```dart
  /// addTwoColumns(
  ///   leftContent: (page, bounds) {
  ///     final box = GeniusPdfInfoBox(config: config, title: 'From', items: [...]);
  ///     return box.draw(page: page, bounds: bounds).height;
  ///   },
  ///   rightContent: (page, bounds) {
  ///     final box = GeniusPdfInfoBox(config: config, title: 'To', items: [...]);
  ///     return box.draw(page: page, bounds: bounds).height;
  ///   },
  ///   spacing: 10,
  ///   gap: 15,
  /// );
  /// ```
  void addTwoColumns({
    required double Function(PdfPage page, Rect bounds) leftContent,
    required double Function(PdfPage page, Rect bounds) rightContent,
    double spacing = 0,
    double gap = 10,
    double leftFlex = 1,
    double rightFlex = 1,
  }) {
    final drawY = _currentY + spacing;
    final page = currentPage;
    final totalFlex = leftFlex + rightFlex;
    final leftWidth = (pageWidth - gap) * (leftFlex / totalFlex);
    final rightWidth = (pageWidth - gap) * (rightFlex / totalFlex);
    final availHeight = remainingHeight - spacing;

    GeniusPdfLogger.debug(
      'Drawing two columns at Y=$drawY (left=${leftWidth.toStringAsFixed(0)}, right=${rightWidth.toStringAsFixed(0)})',
      tag: 'Builder',
    );

    final leftBounds = Rect.fromLTWH(0, drawY, leftWidth, availHeight);
    final rightBounds = Rect.fromLTWH(
      leftWidth + gap,
      drawY,
      rightWidth,
      availHeight,
    );

    final leftHeight = leftContent(page, leftBounds);
    final rightHeight = rightContent(page, rightBounds);

    final maxHeight = leftHeight > rightHeight ? leftHeight : rightHeight;
    _currentY = drawY + maxHeight;

    GeniusPdfLogger.debug(
      'Two columns drawn → Y=${_currentY.toStringAsFixed(1)} (left=$leftHeight, right=$rightHeight)',
      tag: 'Builder',
    );
  }

  /// Sets a page template element at the specified position.
  ///
  /// The template is applied to all pages (current and future) in the document.
  /// Supported positions: `top`, `bottom`, `left`, `right`, `background`,
  /// `stamp`. Uses [PdfDocumentTemplate] for rendering.
  ///
  /// ## Example
  /// ```dart
  /// final watermark = PdfPageTemplateElement(Rect.fromLTWH(0, 0, 500, 50));
  /// watermark.graphics.drawString('CONFIDENTIAL', font, brush: greyBrush);
  /// setPageTemplate(watermark, position: 'stamp');
  /// ```
  void setPageTemplate(
    PdfPageTemplateElement element, {
    String position = 'stamp',
  }) {
    switch (position) {
      case 'top':
        _document.template.top = element;
        break;
      case 'bottom':
        _document.template.bottom = element;
        break;
      case 'left':
        _document.template.left = element;
        break;
      case 'right':
        _document.template.right = element;
        break;
      case 'stamp':
        _document.template.stamps.add(element);
        break;
    }

    GeniusPdfLogger.debug(
      'Page template set at position=$position',
      tag: 'Builder',
    );
  }

  /// Draws two [GeniusPdfInfoBox] components side by side.
  ///
  /// The boxes are rendered at [currentY] + [spacing] with equal widths
  /// (minus the [boxSpacing] gap between them). After drawing, [currentY]
  /// advances to the bottom of the taller box.
  ///
  /// ## Example
  /// ```dart
  /// addDualInfoBox(
  ///   leftBox: customerBox,
  ///   rightBox: companyBox,
  ///   equalHeight: true,
  ///   boxSpacing: 20,
  ///   spacing: 10,
  /// );
  /// ```
  void addDualInfoBox({
    required GeniusPdfInfoBox leftBox,
    required GeniusPdfInfoBox rightBox,
    bool equalHeight = true,
    double boxSpacing = 20,
    bool swapForRTL = true,
    double spacing = 0,
  }) {
    // Estimate: max of both boxes' item counts * 18px + title + padding.
    final maxItems = leftBox.items.length > rightBox.items.length
        ? leftBox.items.length
        : rightBox.items.length;
    final estimatedHeight = 20.0 + maxItems * 18.0 + 10.0 + spacing;
    final page = _ensureSpace(estimatedHeight);
    final drawY = _currentY + spacing;

    GeniusPdfLogger.debug(
      'Drawing dual info box at Y=$drawY',
      tag: 'Builder',
    );

    final dualBox = GeniusPdfDualInfoBox(
      leftBox: leftBox,
      rightBox: rightBox,
      equalHeight: equalHeight,
      spacing: boxSpacing,
      swapForRTL: swapForRTL,
    );

    final result = dualBox.draw(
      page: page,
      bounds: Rect.fromLTWH(0, drawY, pageWidth, remainingHeight),
    );

    _currentY = result.bottom;
    GeniusPdfLogger.debug(
      'Dual info box drawn → Y=${_currentY.toStringAsFixed(1)}',
      tag: 'Builder',
    );
  }

  /// Draws a [GeniusPdfBulletList] at the current Y position.
  ///
  /// The bullet list is rendered starting at [currentY] + [spacing]. After drawing,
  /// [currentY] advances by an estimated height based on item count.
  ///
  /// ## Example
  /// ```dart
  /// addBulletList(
  ///   GeniusPdfBulletList(
  ///     items: [
  ///       GeniusPdfBulletItem.simple('First item'),
  ///       GeniusPdfBulletItem.simple('Second item'),
  ///     ],
  ///     config: config,
  ///     baseFont: baseFont,
  ///     boldFont: boldFont,
  ///     isRTL: false,
  ///   ),
  ///   spacing: 10,
  /// );
  /// ```
  void addBulletList(
    GeniusPdfBulletList bulletList, {
    double spacing = 0,
    double estimatedHeight = 100,
  }) {
    _ensureSpace(estimatedHeight + spacing);
    final page = currentPage;
    final drawY = _currentY + spacing;

    GeniusPdfLogger.debug(
      'Drawing bullet list at Y=$drawY (${bulletList.items.length} items)',
      tag: 'Builder',
    );

    bulletList.draw(
      page: page,
      bounds: Rect.fromLTWH(0, drawY, pageWidth, estimatedHeight),
    );

    _currentY = drawY + estimatedHeight;
    GeniusPdfLogger.debug(
      'Bullet list drawn → Y=${_currentY.toStringAsFixed(1)}',
      tag: 'Builder',
    );
  }

  /// Draws a [GeniusPdfInfoBox] at the current Y position.
  ///
  /// The info box is rendered starting at [currentY] + [spacing]. After drawing,
  /// [currentY] advances to the bottom of the info box.
  ///
  /// ## Example
  /// ```dart
  /// addInfoBox(
  ///   GeniusPdfInfoBox(
  ///     config: config,
  ///     title: 'Note',
  ///     titleAr: 'ملاحظة',
  ///     items: [...],
  ///     style: GeniusPdfInfoBoxStyle.info(),
  ///   ),
  ///   spacing: 10,
  /// );
  /// ```

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
    _layoutResult = null;
    _currentY = _headerHeight;
    build();
    final bytes = _document.saveSync();
    return bytes;
  }

  /// Disposes of the PDF document and releases resources.
  void dispose() {
    _document.dispose();
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// GeniusPdfReportComposer (v2.9.0)
// ═══════════════════════════════════════════════════════════════════════════════

/// A fluent API for composing PDF reports without subclassing.
///
/// [GeniusPdfReportComposer] provides a chainable interface for building
/// PDF documents. Instead of creating a subclass of [GeniusPdfDocumentBuilder]
/// and overriding [build], you compose the report by chaining method calls.
///
/// ## Example
/// ```dart
/// final composer = GeniusPdfReportComposer(config: myConfig);
/// final bytes = composer
///     .withHeader(title: 'Sales Report', titleAr: 'تقرير المبيعات')
///     .withFooter(userName: 'Admin', showPageNumber: true)
///     .section('Overview', sectionAr: 'نظرة عامة')
///     .text('This report covers Q1 2026 sales data.')
///     .space(10)
///     .grid(salesGrid)
///     .summary(salesSummary)
///     .page()
///     .section('Attachments')
///     .qrCode(qr)
///     .build();
/// composer.dispose();
/// ```
class GeniusPdfReportComposer extends GeniusPdfDocumentBuilder {
  /// Creates a new [GeniusPdfReportComposer].
  GeniusPdfReportComposer({required GeniusPdfConfig config}) : super(config);

  /// Build actions queued by the fluent API.
  final List<void Function()> _actions = [];

  // Header settings (applied before actions for correct space calculations).
  GeniusPdfImage? _headerImage;
  String? _headerTitle;
  PdfFont? _headerFont;
  Color? _headerBackgroundColor;
  bool _hasHeader = false;

  // Footer settings (applied before actions for correct space calculations).
  String? _footerUserName;
  String? _footerUserLabel;
  String? _footerPrintTime;
  bool _footerShowPageNumber = false;
  PdfFont? _footerFont;
  String _footerPageNumberFormat = '{0}/{1}';
  String? _footerQrCodeUrl;
  double _footerQrCodeSize = 50;
  bool _hasFooter = false;

  @override
  void build() {
    // Apply header and footer BEFORE actions so that _headerHeight and
    // _footerHeight are set correctly for all space calculations.
    if (_hasHeader) {
      addHeader(
        image: _headerImage,
        title: _headerTitle,
        font: _headerFont,
        backgroundColor: _headerBackgroundColor,
      );
    }
    if (_hasFooter) {
      addFooter(
        userName: _footerUserName,
        userLabel: _footerUserLabel,
        printTime: _footerPrintTime,
        showPageNumber: _footerShowPageNumber,
        font: _footerFont,
        pageNumberFormat: _footerPageNumberFormat,
        qrCodeUrl: _footerQrCodeUrl,
        qrCodeSize: _footerQrCodeSize,
      );
    }

    for (final action in _actions) {
      action();
    }
  }

  /// Generates the PDF bytes from all queued actions.
  ///
  /// This is a convenience method that calls [generate] on the parent.
  /// Returns the PDF bytes ready for saving or sharing.
  List<int> buildPdf() => generate();

  // ────────────────────────────────────────────────────────
  // Header & Footer
  // ────────────────────────────────────────────────────────

  /// Configures a header for all pages.
  ///
  /// The header is applied before all actions in [build] so that
  /// [headerHeight] is available for space calculations.
  GeniusPdfReportComposer withHeader({
    GeniusPdfImage? image,
    String? title,
    PdfFont? font,
    Color? backgroundColor,
  }) {
    _hasHeader = true;
    _headerImage = image;
    _headerTitle = title;
    _headerFont = font;
    _headerBackgroundColor = backgroundColor;
    return this;
  }

  /// Configures a report header (v2.8.0 style).
  GeniusPdfReportComposer withReportHeader(
    GeniusPdfReportHeader reportHeader, {
    double spacing = 0,
    double height = 100,
  }) {
    _actions.add(() => addReportHeader(
          reportHeader,
          spacing: spacing,
          height: height,
        ));
    return this;
  }

  /// Configures a footer for all pages.
  ///
  /// The footer is applied before all actions in [build] so that
  /// [footerHeight] is available for space calculations.
  GeniusPdfReportComposer withFooter({
    String? userName,
    String? userLabel,
    String? printTime,
    bool showPageNumber = false,
    PdfFont? font,
    String pageNumberFormat = '{0}/{1}',
    String? qrCodeUrl,
    double qrCodeSize = 50,
  }) {
    _hasFooter = true;
    _footerUserName = userName;
    _footerUserLabel = userLabel;
    _footerPrintTime = printTime;
    _footerShowPageNumber = showPageNumber;
    _footerFont = font;
    _footerPageNumberFormat = pageNumberFormat;
    _footerQrCodeUrl = qrCodeUrl;
    _footerQrCodeSize = qrCodeSize;
    return this;
  }

  // ────────────────────────────────────────────────────────
  // Text
  // ────────────────────────────────────────────────────────

  /// Adds a text line.
  GeniusPdfReportComposer text(
    String content, {
    PdfFont? font,
    PdfBrush? brush,
    double topMargin = 10,
  }) {
    _actions.add(() => addLine(
          content,
          font: font,
          brush: brush,
          topMargin: topMargin,
        ));
    return this;
  }

  /// Adds a bold text line.
  GeniusPdfReportComposer boldText(String content, {double topMargin = 10}) {
    _actions.add(() => addLine(
          content,
          font: config.boldFont,
          topMargin: topMargin,
        ));
    return this;
  }

  /// Adds rich text.
  GeniusPdfReportComposer richText(
    GeniusPdfRichText content, {
    double spacing = 0,
  }) {
    _actions.add(() => addRichText(content, spacing: spacing));
    return this;
  }

  // ────────────────────────────────────────────────────────
  // Layout
  // ────────────────────────────────────────────────────────

  /// Adds vertical spacing.
  GeniusPdfReportComposer space(double height) {
    _actions.add(() => addSpace(height));
    return this;
  }

  /// Adds a horizontal line.
  GeniusPdfReportComposer line({double spacing = 5}) {
    _actions.add(() => addHorizontalLine(spacing: spacing));
    return this;
  }

  /// Adds a section divider with optional title.
  GeniusPdfReportComposer section(
    String? title, {
    String? sectionAr,
    double spacing = 10,
  }) {
    _actions.add(() {
      final displayTitle = (isRTL && sectionAr != null) ? sectionAr : title;
      addSectionDivider(title: displayTitle, spacing: spacing);
    });
    return this;
  }

  /// Creates a new page.
  GeniusPdfReportComposer page({PdfPen? borderPen}) {
    _actions.add(() => newPage(borderPen: borderPen));
    return this;
  }

  // ────────────────────────────────────────────────────────
  // Components
  // ────────────────────────────────────────────────────────

  /// Adds a data grid.
  GeniusPdfReportComposer grid(
    GeniusPdfDataGrid dataGrid, {
    double spacing = 0,
  }) {
    _actions.add(() => addGrid(dataGrid, spacing: spacing));
    return this;
  }

  /// Adds a summary section.
  GeniusPdfReportComposer summary(
    GeniusPdfSummarySection summarySection, {
    double spacing = 0,
  }) {
    _actions.add(() => addSummary(summarySection, spacing: spacing));
    return this;
  }

  /// Adds a grid with its summary.
  GeniusPdfReportComposer gridWithSummary({
    required GeniusPdfDataGrid dataGrid,
    required GeniusPdfSummarySection summarySection,
    double gridSpacing = 0,
    double summarySpacing = 10,
  }) {
    _actions.add(() => addGridWithSummary(
          grid: dataGrid,
          summary: summarySection,
          gridSpacing: gridSpacing,
          summarySpacing: summarySpacing,
        ));
    return this;
  }

  /// Adds an overall report summary.
  GeniusPdfReportComposer reportSummary({
    required GeniusPdfSummarySection summarySection,
    String? title,
    String? titleAr,
    double spacing = 15,
  }) {
    _actions.add(() => addReportSummary(
          summary: summarySection,
          title: title,
          titleAr: titleAr,
          spacing: spacing,
        ));
    return this;
  }

  /// Adds an info box.
  GeniusPdfReportComposer infoBox(
    GeniusPdfInfoBox box, {
    double spacing = 0,
  }) {
    _actions.add(() => addInfoBox(box, spacing: spacing));
    return this;
  }

  /// Adds a two-column layout.
  GeniusPdfReportComposer twoColumns({
    required double Function(PdfPage page, Rect bounds) leftContent,
    required double Function(PdfPage page, Rect bounds) rightContent,
    double spacing = 0,
    double gap = 10,
  }) {
    _actions.add(() => addTwoColumns(
          leftContent: leftContent,
          rightContent: rightContent,
          spacing: spacing,
          gap: gap,
        ));
    return this;
  }

  // ────────────────────────────────────────────────────────
  // QR & Images
  // ────────────────────────────────────────────────────────

  /// Adds a QR code.
  GeniusPdfReportComposer qrCode(
    GeniusPdfQRCodeGenerator qr, {
    double size = 120,
    GeniusPdfImageAlignment alignment = GeniusPdfImageAlignment.start,
    double spacing = 0,
  }) {
    _actions.add(() => addQRCode(
          qr,
          size: size,
          alignment: alignment,
          spacing: spacing,
        ));
    return this;
  }

  /// Adds an image.
  GeniusPdfReportComposer image(
    GeniusPdfImage img, {
    GeniusPdfImageAlignment alignment = GeniusPdfImageAlignment.start,
    double spacing = 0,
  }) {
    _actions.add(() => addImage(img, alignment: alignment, spacing: spacing));
    return this;
  }

  /// Adds a labeled image attachment.
  GeniusPdfReportComposer imageAttachment(
    GeniusPdfImage img, {
    String? title,
    String? titleAr,
    double spacing = 10,
  }) {
    _actions.add(() => addImageAttachment(
          img,
          title: title,
          titleAr: titleAr,
          spacing: spacing,
        ));
    return this;
  }

  /// Adds an image on a dedicated new page.
  GeniusPdfReportComposer imagePage(
    GeniusPdfImage img, {
    String? title,
    String? titleAr,
  }) {
    _actions.add(() => addImagePage(img, title: title, titleAr: titleAr));
    return this;
  }

  /// Adds multiple image pages.
  GeniusPdfReportComposer attachments(
    List<GeniusPdfImage> images, {
    List<String>? titles,
    List<String>? titlesAr,
  }) {
    _actions.add(() => addAttachments(
          images,
          titles: titles,
          titlesAr: titlesAr,
        ));
    return this;
  }

  // ────────────────────────────────────────────────────────
  // Custom
  // ────────────────────────────────────────────────────────

  /// Executes a custom action within the build chain.
  ///
  /// Use this for any operation not covered by the fluent API.
  /// The callback receives the composer itself for access to all builder methods.
  ///
  /// ## Example
  /// ```dart
  /// composer
  ///   .text('Hello')
  ///   .custom((c) {
  ///     // Direct access to all builder methods
  ///     c.addTextAt('Custom positioned text', x: 100, y: 200);
  ///   })
  ///   .text('World');
  /// ```
  GeniusPdfReportComposer custom(
    void Function(GeniusPdfReportComposer composer) action,
  ) {
    _actions.add(() => action(this));
    return this;
  }
}
