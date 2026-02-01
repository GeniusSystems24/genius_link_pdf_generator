import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Demonstrates v2.4.0 position tracking, auto page-break, and image alignment.
///
/// This example showcases:
/// - **Precise Y-position tracking** via [currentY] and [remainingHeight]
/// - **Automatic page-breaking** with [_ensureSpace] when content overflows
/// - **Image alignment** with [GeniusPdfImageAlignment] (start/center/end)
/// - **Helper utilities**: [canFit], [contentBounds], [resetY], [addSpace]
/// - **Enhanced footer** with configurable [userLabel] and [pageNumberFormat]
///
/// ## Example
/// ```dart
/// final doc = PositionTrackingDemoBuilder(
///   config: myConfig,
///   userName: 'Demo User',
/// );
/// final bytes = doc.generate();
/// doc.dispose();
/// ```
class PositionTrackingDemoBuilder extends GeniusPdfDocumentBuilder {
  /// Creates a new [PositionTrackingDemoBuilder].
  PositionTrackingDemoBuilder({
    required GeniusPdfConfig config,
    this.userName = 'Demo User',
    this.headerImage,
    this.sampleImage,
  }) : super(config);

  /// User name for the footer.
  final String userName;

  /// Optional header image.
  final GeniusPdfImage? headerImage;

  /// Optional sample image to demonstrate image alignment.
  final GeniusPdfImage? sampleImage;

  @override
  void build() {
    _buildHeaderSection();
    _buildPositionTrackingDemo();
    _buildAutoPageBreakDemo();
    _buildImageAlignmentDemo();
    _buildHelperUtilitiesDemo();
    _buildFooter();
  }

  // ──────────────────────────────────────────────────────────
  // Section 1: Header
  // ──────────────────────────────────────────────────────────

  void _buildHeaderSection() {
    if (headerImage != null) {
      addHeader(
        image: headerImage,
        title: isRTL
            ? 'عرض تتبع المواقع — الإصدار 2.4.0'
            : 'Position Tracking Demo — v2.4.0',
        backgroundColor: Colors.grey[100],
      );
    } else {
      addHeader(
        title: isRTL
            ? 'عرض تتبع المواقع — الإصدار 2.4.0'
            : 'Position Tracking Demo — v2.4.0',
      );
    }
  }

  // ──────────────────────────────────────────────────────────
  // Section 2: Position Tracking
  // ──────────────────────────────────────────────────────────

  void _buildPositionTrackingDemo() {
    addLine(
      isRTL ? '1. تتبع الموقع الدقيق' : '1. Precise Position Tracking',
      font: config.boldFont,
    );
    addSpace(5);

    addLine(
      isRTL
          ? 'كل عملية رسم تحدّث الموقع العمودي (currentY) تلقائياً.'
          : 'Every draw operation automatically updates the vertical position (currentY).',
    );

    addLine(
      isRTL
          ? 'الموقع الحالي بعد النص أعلاه: currentY = ${currentY.toStringAsFixed(1)}'
          : 'Current position after above text: currentY = ${currentY.toStringAsFixed(1)}',
      topMargin: 5,
    );

    addLine(
      isRTL
          ? 'المساحة المتبقية في الصفحة: ${remainingHeight.toStringAsFixed(1)} بكسل'
          : 'Remaining page space: ${remainingHeight.toStringAsFixed(1)} pixels',
      topMargin: 5,
    );

    addSpace(10);
    addHorizontalLine();
    addSpace(5);

    addLine(
      isRTL
          ? 'الموقع بعد الخط الأفقي (يحدّث الموقع تلقائياً): ${currentY.toStringAsFixed(1)}'
          : 'Position after horizontal line (auto-advances): ${currentY.toStringAsFixed(1)}',
      topMargin: 5,
    );

    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Section 3: Auto Page-Break
  // ──────────────────────────────────────────────────────────

  void _buildAutoPageBreakDemo() {
    addLine(
      isRTL ? '2. كسر الصفحة التلقائي' : '2. Automatic Page Breaking',
      font: config.boldFont,
    );
    addSpace(5);

    addLine(
      isRTL
          ? 'عند عدم كفاية المساحة، يتم إنشاء صفحة جديدة تلقائياً.'
          : 'When there is not enough space, a new page is created automatically.',
    );
    addSpace(10);

    // Generate enough lines to force a page break.
    final totalLines = 35;
    for (var i = 1; i <= totalLines; i++) {
      final text = isRTL
          ? 'السطر $i — هذا نص توضيحي لاختبار كسر الصفحة التلقائي عندما يمتلئ المحتوى'
          : 'Line $i — This is sample text to demonstrate auto page-break when content fills up';
      addLine(text, topMargin: 4);
    }

    addSpace(10);
    addHorizontalLine();
    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Section 4: Image Alignment
  // ──────────────────────────────────────────────────────────

  void _buildImageAlignmentDemo() {
    addLine(
      isRTL ? '3. محاذاة الصور' : '3. Image Alignment',
      font: config.boldFont,
    );
    addSpace(5);

    addLine(
      isRTL
          ? 'الصور الآن تحدّث الموقع العمودي وتدعم المحاذاة (بداية، وسط، نهاية).'
          : 'Images now advance currentY and support alignment (start, center, end).',
    );
    addSpace(10);

    if (sampleImage != null) {
      // Demonstrate each alignment.
      addLine(
        isRTL ? 'محاذاة: بداية (start)' : 'Alignment: start',
        topMargin: 5,
      );
      addImage(
        sampleImage!,
        alignment: GeniusPdfImageAlignment.start,
        spacing: 5,
      );
      addSpace(5);

      addLine(
        isRTL ? 'محاذاة: وسط (center)' : 'Alignment: center',
        topMargin: 5,
      );
      addImage(
        sampleImage!,
        alignment: GeniusPdfImageAlignment.center,
        spacing: 5,
      );
      addSpace(5);

      addLine(
        isRTL ? 'محاذاة: نهاية (end)' : 'Alignment: end',
        topMargin: 5,
      );
      addImage(
        sampleImage!,
        alignment: GeniusPdfImageAlignment.end,
        spacing: 5,
      );
    } else {
      addLine(
        isRTL
            ? '(لم يتم تزويد صورة — يمكنك تمرير sampleImage لمشاهدة العرض)'
            : '(No image provided — pass sampleImage to see the alignment demo)',
      );
    }

    addSpace(10);
    addHorizontalLine();
    addSpace(10);
  }

  // ──────────────────────────────────────────────────────────
  // Section 5: Helper Utilities
  // ──────────────────────────────────────────────────────────

  void _buildHelperUtilitiesDemo() {
    addLine(
      isRTL ? '4. أدوات مساعدة' : '4. Helper Utilities',
      font: config.boldFont,
    );
    addSpace(5);

    // canFit demo
    final fitsLargeBlock = canFit(500);
    addLine(
      isRTL
          ? 'canFit(500): ${fitsLargeBlock ? "نعم" : "لا"} — هل تتسع 500 بكسل؟'
          : 'canFit(500): $fitsLargeBlock — can 500px fit on current page?',
      topMargin: 5,
    );

    // contentBounds demo
    final bounds = contentBounds;
    addLine(
      isRTL
          ? 'contentBounds: (${bounds.left.toStringAsFixed(0)}, ${bounds.top.toStringAsFixed(0)}, ${bounds.width.toStringAsFixed(0)}×${bounds.height.toStringAsFixed(0)})'
          : 'contentBounds: (${bounds.left.toStringAsFixed(0)}, ${bounds.top.toStringAsFixed(0)}, ${bounds.width.toStringAsFixed(0)}x${bounds.height.toStringAsFixed(0)})',
      topMargin: 5,
    );

    // pageCount demo
    addLine(
      isRTL
          ? 'عدد الصفحات حتى الآن: $pageCount'
          : 'Total pages so far: $pageCount',
      topMargin: 5,
    );

    // resetY demo
    addSpace(10);
    addLine(
      isRTL
          ? 'resetY() — يعيد الموقع إلى أعلى الصفحة (لم يتم استدعاؤه هنا لعدم التداخل)'
          : 'resetY() — resets position to page top (not called here to avoid overlap)',
      topMargin: 5,
    );

    addSpace(15);
  }

  // ──────────────────────────────────────────────────────────
  // Footer
  // ──────────────────────────────────────────────────────────

  void _buildFooter() {
    addFooter(
      userName: userName,
      showPageNumber: true,
      printTime: DateTime.now().toString().substring(0, 19),
      pageNumberFormat: isRTL ? '{0} / {1}' : '{0}/{1}',
    );
  }
}
