part of '../pdf_document_builder.dart';

class GeniusPdfReportComposer extends GeniusPdfDocumentBuilder {
  /// Creates a new [GeniusPdfReportComposer].
  GeniusPdfReportComposer({
    required GeniusPdfConfig config,
    GeniusPdfDirectionality? directionality,
  }) : super(config, directionality: directionality);

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

  /// Queues a deterministic S03 flow section.
  ///
  /// The section is measured and paginated only when the composer builds.
  GeniusPdfReportComposer flowSection(
    PdfFlowSection section, {
    PdfFlowPlan? plan,
  }) {
    _actions.add(
      () => addFlowSection(
        section,
        plan: plan,
      ),
    );
    return this;
  }

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
  ///
  /// By default the logical column order follows the document direction.
  /// In RTL, [rightContent] is rendered on the physical left and
  /// [leftContent] on the physical right.
  ///
  /// Set [preservePhysicalOrder] to `true` for legacy/pre-printed layouts
  /// where the physical left/right order must remain unchanged.
  GeniusPdfReportComposer twoColumns({
    required double Function(PdfPage page, Rect bounds) leftContent,
    required double Function(PdfPage page, Rect bounds) rightContent,
    double spacing = 0,
    double gap = 10,
    bool followDirection = true,
    bool preservePhysicalOrder = false,
  }) {
    _actions.add(
      () => addTwoColumns(
        leftContent: leftContent,
        rightContent: rightContent,
        spacing: spacing,
        gap: gap,
        followDirection: followDirection,
        preservePhysicalOrder: preservePhysicalOrder,
      ),
    );
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
