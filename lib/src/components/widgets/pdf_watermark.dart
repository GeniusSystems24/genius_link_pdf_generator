// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../core/pdf_config.dart';
import '../models/security_models.dart';

/// مكون العلامة المائية للـ PDF
/// Watermark component for PDF documents
class GeniusPdfWatermark {
  GeniusPdfWatermark({
    required this.settings,
    required this.config,
  });

  /// إنشاء علامة مائية نصية
  factory GeniusPdfWatermark.text(
    GeniusTextWatermarkSettings settings, {
    required GeniusPdfConfig config,
  }) =>
      GeniusPdfWatermark(
        settings: settings,
        config: config,
      );

  /// إنشاء علامة مائية بصورة
  factory GeniusPdfWatermark.image(
    GeniusImageWatermarkSettings settings, {
    required GeniusPdfConfig config,
  }) =>
      GeniusPdfWatermark(
        settings: settings,
        config: config,
      );

  /// إنشاء علامة مائية قطرية
  factory GeniusPdfWatermark.diagonal(
    GeniusDiagonalWatermarkSettings settings, {
    required GeniusPdfConfig config,
  }) =>
      GeniusPdfWatermark(
        settings: settings,
        config: config,
      );

  /// إنشاء علامة مائية متكررة
  factory GeniusPdfWatermark.tiled(
    GeniusTiledWatermarkSettings settings, {
    required GeniusPdfConfig config,
  }) =>
      GeniusPdfWatermark(
        settings: settings,
        config: config,
      );

  /// علامة "سري" جاهزة
  factory GeniusPdfWatermark.confidential({
    String text = 'CONFIDENTIAL',
    double opacity = 0.2,
    required GeniusPdfConfig config,
  }) =>
      GeniusPdfWatermark(
        settings: GeniusTextWatermarkSettings.confidential(
            text: text, opacity: opacity),
        config: config,
      );

  /// علامة "مسودة" جاهزة
  factory GeniusPdfWatermark.draft({
    String text = 'DRAFT',
    double opacity = 0.2,
    required GeniusPdfConfig config,
  }) =>
      GeniusPdfWatermark(
        settings:
            GeniusTextWatermarkSettings.draft(text: text, opacity: opacity),
        config: config,
      );

  /// علامة "نسخة" جاهزة
  factory GeniusPdfWatermark.copy({
    String text = 'COPY',
    double opacity = 0.2,
    required GeniusPdfConfig config,
  }) =>
      GeniusPdfWatermark(
        settings:
            GeniusTextWatermarkSettings.copy(text: text, opacity: opacity),
        config: config,
      );

  /// علامة "ملغي" جاهزة
  factory GeniusPdfWatermark.cancelled({
    String text = 'CANCELLED',
    double opacity = 0.3,
    required GeniusPdfConfig config,
  }) =>
      GeniusPdfWatermark(
        settings:
            GeniusTextWatermarkSettings.cancelled(text: text, opacity: opacity),
        config: config,
      );

  /// إعدادات العلامة المائية
  final GeniusWatermarkSettings settings;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// الخط الأساسي (مطلوب للنصوص العربية)
  PdfFont get baseFont => config.baseFont;

  /// الخط العريض (مطلوب للنصوص العربية)
  PdfFont get boldFont => config.boldFont;

  /// تطبيق العلامة المائية على المستند
  void applyToDocument(PdfDocument document) {
    final pageCount = document.pages.count;

    for (int i = 0; i < pageCount; i++) {
      if (_shouldApplyToPage(i)) {
        final page = document.pages[i];
        _applyToPage(page);
      }
    }
  }

  /// تطبيق العلامة المائية على صفحة محددة
  void applyToPage(PdfPage page) {
    _applyToPage(page);
  }

  bool _shouldApplyToPage(int pageIndex) {
    if (settings.applyToAllPages) return true;
    if (settings.pageNumbers == null) return true;
    return settings.pageNumbers!.contains(pageIndex);
  }

  void _applyToPage(PdfPage page) {
    final graphics = settings.layer == GeniusWatermarkLayer.background
        ? page.graphics
        : page
            .graphics; // In Syncfusion, we use same graphics but draw order matters

    switch (settings.type) {
      case GeniusWatermarkType.text:
        _drawTextWatermark(
            graphics, page, settings as GeniusTextWatermarkSettings);
        break;
      case GeniusWatermarkType.image:
        _drawImageWatermark(
            graphics, page, settings as GeniusImageWatermarkSettings);
        break;
      case GeniusWatermarkType.diagonal:
        _drawDiagonalWatermark(
            graphics, page, settings as GeniusDiagonalWatermarkSettings);
        break;
      case GeniusWatermarkType.tiled:
        _drawTiledWatermark(
            graphics, page, settings as GeniusTiledWatermarkSettings);
        break;
    }
  }

  void _drawTextWatermark(PdfGraphics graphics, PdfPage page,
      GeniusTextWatermarkSettings settings) {
    final pageSize = page.getClientSize();

    // Font
    final font = baseFont;

    // Calculate text size
    final textSize = font.measureString(settings.text);

    // Calculate position
    final position = _calculatePosition(settings.position, pageSize, textSize);

    // Save graphics state
    graphics.save();

    // Apply rotation
    if (settings.rotation != 0) {
      graphics.translateTransform(
          position.dx + textSize.width / 2, position.dy + textSize.height / 2);
      graphics.rotateTransform(settings.rotation);
      graphics.translateTransform(-(position.dx + textSize.width / 2),
          -(position.dy + textSize.height / 2));
    }

    // Create color with opacity
    final color = PdfColor(
      settings.color.red,
      settings.color.green,
      settings.color.blue,
      (settings.opacity * 255).round(),
    );

    // Draw text
    graphics.drawString(
      settings.text,
      font,
      brush: PdfSolidBrush(color),
      bounds: Rect.fromLTWH(
          position.dx, position.dy, textSize.width, textSize.height),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
          textDirection: config.pdfTextDirection),
    );

    // Restore graphics state
    graphics.restore();
  }

  void _drawImageWatermark(PdfGraphics graphics, PdfPage page,
      GeniusImageWatermarkSettings settings) {
    final pageSize = page.getClientSize();

    // Load image
    final image = PdfBitmap(settings.imageBytes);

    // Calculate dimensions
    double width = settings.width ?? image.width.toDouble();
    double height = settings.height ?? image.height.toDouble();

    if (settings.position == GeniusWatermarkPosition.fill &&
        settings.width == null &&
        settings.height == null) {
      width = pageSize.width;
      height = pageSize.height;
    }

    if (settings.maintainAspectRatio &&
        (settings.width != null || settings.height != null)) {
      final aspectRatio = image.width / image.height;
      if (settings.width != null && settings.height == null) {
        height = width / aspectRatio;
      } else if (settings.height != null && settings.width == null) {
        width = height * aspectRatio;
      }
    }

    if (width > pageSize.width || height > pageSize.height) {
      final widthScale = pageSize.width / width;
      final heightScale = pageSize.height / height;
      final scale = widthScale < heightScale ? widthScale : heightScale;
      width *= scale;
      height *= scale;
    }

    // Calculate position
    final rawPosition =
        _calculatePosition(settings.position, pageSize, Size(width, height));
    final maxX = pageSize.width - width;
    final maxY = pageSize.height - height;
    final position = Offset(
      rawPosition.dx.clamp(0.0, maxX < 0 ? 0.0 : maxX),
      rawPosition.dy.clamp(0.0, maxY < 0 ? 0.0 : maxY),
    );

    // Save graphics state
    graphics.save();

    // Set opacity
    graphics.setTransparency(settings.opacity);

    // Apply rotation
    if (settings.rotation != 0) {
      graphics.translateTransform(
          position.dx + width / 2, position.dy + height / 2);
      graphics.rotateTransform(settings.rotation);
      graphics.translateTransform(
          -(position.dx + width / 2), -(position.dy + height / 2));
    }

    // Draw image
    graphics.drawImage(
      image,
      Rect.fromLTWH(position.dx, position.dy, width, height),
    );

    // Restore graphics state
    graphics.restore();
  }

  void _drawDiagonalWatermark(PdfGraphics graphics, PdfPage page,
      GeniusDiagonalWatermarkSettings settings) {
    final pageSize = page.getClientSize();

    // Create font
    final font = PdfTrueTypeFont(
      config.baseFontBytes,
      settings.fontSize,
      style: settings.isBold ? PdfFontStyle.bold : PdfFontStyle.regular,
    );

    // Calculate text size
    final textSize = font.measureString(settings.text);

    // Calculate diagonal length
    // Center position
    final centerX = pageSize.width / 2;
    final centerY = pageSize.height / 2;

    // Save graphics state
    graphics.save();

    // Translate to center and rotate
    graphics.translateTransform(centerX, centerY);
    final angle = settings.topLeftToBottomRight ? -45.0 : 45.0;
    graphics.rotateTransform(angle);

    // Create color with opacity
    final color = PdfColor(
      settings.color.red,
      settings.color.green,
      settings.color.blue,
      (settings.opacity * 255).round(),
    );

    // Draw text at center
    graphics.drawString(
      settings.text,
      font,
      brush: PdfSolidBrush(color),
      bounds: Rect.fromLTWH(-textSize.width / 2, -textSize.height / 2,
          textSize.width, textSize.height),
      format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          lineAlignment: PdfVerticalAlignment.middle,
          textDirection: config.pdfTextDirection),
    );

    // Restore graphics state
    graphics.restore();
  }

  void _drawTiledWatermark(PdfGraphics graphics, PdfPage page,
      GeniusTiledWatermarkSettings settings) {
    final pageSize = page.getClientSize();

    // Create font
    final font = PdfTrueTypeFont(
      config.baseFontBytes,
      settings.fontSize,
      style: settings.isBold ? PdfFontStyle.bold : PdfFontStyle.regular,
    );

    // Calculate text size
    final textSize = font.measureString(settings.text);

    // Create color with opacity
    final color = PdfColor(
      settings.color.red,
      settings.color.green,
      settings.color.blue,
      (settings.opacity * 255).round(),
    );

    // Calculate number of tiles
    final tileWidth = textSize.width + settings.horizontalSpacing;
    final tileHeight = textSize.height + settings.verticalSpacing;

    final cols = (pageSize.width / tileWidth).ceil() + 2;
    final rows = (pageSize.height / tileHeight).ceil() + 2;

    // Start offset for staggered effect
    final startX = -tileWidth;
    final startY = -tileHeight;

    // Save graphics state
    graphics.save();

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        // Stagger odd rows
        final offsetX = (row % 2 == 0) ? 0.0 : tileWidth / 2;

        final x = startX + col * tileWidth + offsetX;
        final y = startY + row * tileHeight;

        // Save state for rotation
        graphics.save();

        // Translate to text center and rotate
        graphics.translateTransform(
            x + textSize.width / 2, y + textSize.height / 2);
        graphics.rotateTransform(settings.rotation);

        // Draw text
        graphics.drawString(
          settings.text,
          font,
          brush: PdfSolidBrush(color),
          bounds: Rect.fromLTWH(-textSize.width / 2, -textSize.height / 2,
              textSize.width, textSize.height),
          format: PdfStringFormat(
              alignment: PdfTextAlignment.center,
              lineAlignment: PdfVerticalAlignment.middle,
              textDirection: config.pdfTextDirection),
        );

        graphics.restore();
      }
    }

    // Restore graphics state
    graphics.restore();
  }

  Offset _calculatePosition(
      GeniusWatermarkPosition position, Size pageSize, Size contentSize) {
    switch (position) {
      case GeniusWatermarkPosition.center:
        return Offset(
          (pageSize.width - contentSize.width) / 2,
          (pageSize.height - contentSize.height) / 2,
        );
      case GeniusWatermarkPosition.topLeft:
        return const Offset(20, 20);
      case GeniusWatermarkPosition.topRight:
        return Offset(pageSize.width - contentSize.width - 20, 20);
      case GeniusWatermarkPosition.bottomLeft:
        return Offset(20, pageSize.height - contentSize.height - 20);
      case GeniusWatermarkPosition.bottomRight:
        return Offset(
          pageSize.width - contentSize.width - 20,
          pageSize.height - contentSize.height - 20,
        );
      case GeniusWatermarkPosition.topCenter:
        return Offset((pageSize.width - contentSize.width) / 2, 20);
      case GeniusWatermarkPosition.bottomCenter:
        return Offset(
          (pageSize.width - contentSize.width) / 2,
          pageSize.height - contentSize.height - 20,
        );
      case GeniusWatermarkPosition.centerLeft:
        return Offset(20, (pageSize.height - contentSize.height) / 2);
      case GeniusWatermarkPosition.centerRight:
        return Offset(
          pageSize.width - contentSize.width - 20,
          (pageSize.height - contentSize.height) / 2,
        );
      case GeniusWatermarkPosition.fill:
        return Offset.zero;
    }
  }
}

/// امتداد لإضافة العلامة المائية للمستند
/// Extension to add watermark to document
extension PdfDocumentWatermarkExtension on PdfDocument {
  /// إضافة علامة مائية للمستند
  void addWatermark(GeniusPdfWatermark watermark) {
    watermark.applyToDocument(this);
  }

  /// إضافة علامة مائية نصية
  void addTextWatermark(GeniusTextWatermarkSettings settings,
      {required GeniusPdfConfig config}) {
    GeniusPdfWatermark.text(
      config: config,
      settings,
    ).applyToDocument(this);
  }

  /// إضافة علامة مائية قطرية
  void addDiagonalWatermark(GeniusDiagonalWatermarkSettings settings,
      {required GeniusPdfConfig config}) {
    GeniusPdfWatermark.diagonal(
      settings,
      config: config,
    ).applyToDocument(this);
  }

  /// إضافة علامة مائية متكررة
  void addTiledWatermark(GeniusTiledWatermarkSettings settings,
      {required GeniusPdfConfig config}) {
    GeniusPdfWatermark.tiled(
      settings,
      config: config,
    ).applyToDocument(this);
  }
}

/// امتداد لإضافة العلامة المائية للصفحة
/// Extension to add watermark to page
extension PdfPageWatermarkExtension on PdfPage {
  /// إضافة علامة مائية للصفحة
  void addWatermark(GeniusPdfWatermark watermark) {
    watermark.applyToPage(this);
  }
}
