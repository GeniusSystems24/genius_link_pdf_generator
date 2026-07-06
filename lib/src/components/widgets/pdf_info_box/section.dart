part of '../pdf_info_box.dart';

enum GeniusPdfSectionTitlePosition {
  /// Title above the section box.
  above,

  /// Title inside the section, at the top.
  inside,

  /// Title overlapping the top border.
  overlay,
}

/// Style configuration for [GeniusPdfSection].
class GeniusPdfSectionStyle {
  const GeniusPdfSectionStyle({
    this.backgroundColor,
    this.borderStyle = const GeniusPdfBorderStyle.all(),
    this.padding = const GeniusPdfCellPadding.all(8),
    this.titleStyle = const GeniusPdfTextStyle.header(fontSize: 11),
    this.subtitleStyle,
    this.titlePosition = GeniusPdfSectionTitlePosition.above,
    this.titlePadding = const GeniusPdfCellPadding(bottom: 4),
    this.titleBackgroundColor,
    this.showTitleUnderline = false,
    this.titleUnderlineColor,
    this.titleUnderlineWidth = 1.0,
    this.headerBackgroundColor,
    this.headerPadding,
    this.showDividerAfterTitle = false,
    this.dividerColor,
    this.dividerWidth = 0.5,
    this.collapsible = false,
    this.collapsed = false,
    this.shadowEnabled = false,
    this.shadowColor,
    this.shadowOffset = 2,
  });

  /// Creates a corporate/professional section style.
  factory GeniusPdfSectionStyle.corporate({
    Color primaryColor = const Color(0xFF1565C0),
    Color? backgroundColor,
  }) {
    return GeniusPdfSectionStyle(
      backgroundColor: backgroundColor,
      borderStyle: GeniusPdfBorderStyle.all(color: primaryColor, width: 1),
      padding: const GeniusPdfCellPadding.all(10),
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: 11,
        color: primaryColor,
      ),
      titlePosition: GeniusPdfSectionTitlePosition.above,
      showTitleUnderline: true,
      titleUnderlineColor: primaryColor,
      titleUnderlineWidth: 2,
    );
  }

  /// Creates a minimal section style.
  factory GeniusPdfSectionStyle.minimal({
    Color accentColor = const Color(0xFF424242),
  }) {
    return GeniusPdfSectionStyle(
      backgroundColor: null,
      borderStyle: const GeniusPdfBorderStyle.none(),
      padding: const GeniusPdfCellPadding(left: 8, top: 4, bottom: 4),
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: 10,
        color: accentColor,
      ),
      titlePosition: GeniusPdfSectionTitlePosition.above,
      showDividerAfterTitle: true,
      dividerColor: accentColor,
      dividerWidth: 1,
    );
  }

  /// Creates a card-style section.
  factory GeniusPdfSectionStyle.card({
    Color borderColor = const Color(0xFFE0E0E0),
    Color? backgroundColor = const Color(0xFFFFFFFF),
  }) {
    return GeniusPdfSectionStyle(
      backgroundColor: backgroundColor,
      borderStyle: GeniusPdfBorderStyle.all(color: borderColor),
      padding: const GeniusPdfCellPadding.all(12),
      titleStyle: const GeniusPdfTextStyle.header(
        fontSize: 11,
        color: Color(0xFF424242),
      ),
      titlePosition: GeniusPdfSectionTitlePosition.inside,
      titlePadding: const GeniusPdfCellPadding(bottom: 8),
      showDividerAfterTitle: true,
      dividerColor: borderColor,
    );
  }

  /// Creates a Saudi-themed section style.
  factory GeniusPdfSectionStyle.saudi({
    Color primaryColor = const Color(0xFF006C35),
  }) {
    return GeniusPdfSectionStyle(
      backgroundColor: primaryColor.withValues(alpha: 0.03),
      borderStyle: GeniusPdfBorderStyle.all(color: primaryColor),
      padding: const GeniusPdfCellPadding.all(10),
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: 11,
        color: primaryColor,
      ),
      titlePosition: GeniusPdfSectionTitlePosition.above,
      showTitleUnderline: true,
      titleUnderlineColor: primaryColor,
    );
  }

  /// Background color for section content area.
  final Color? backgroundColor;

  /// Border style for section box.
  final GeniusPdfBorderStyle borderStyle;

  /// Padding inside the section box.
  final GeniusPdfCellPadding padding;

  /// Style for section title.
  final GeniusPdfTextStyle titleStyle;

  /// Style for section subtitle.
  final GeniusPdfTextStyle? subtitleStyle;

  /// Position of the title relative to the section box.
  final GeniusPdfSectionTitlePosition titlePosition;

  /// Padding around the title.
  final GeniusPdfCellPadding titlePadding;

  /// Background color for the title area.
  final Color? titleBackgroundColor;

  /// Whether to show underline under title.
  final bool showTitleUnderline;

  /// Color of title underline.
  final Color? titleUnderlineColor;

  /// Width of title underline.
  final double titleUnderlineWidth;

  /// Background color for header area (when title is inside).
  final Color? headerBackgroundColor;

  /// Padding for header area.
  final GeniusPdfCellPadding? headerPadding;

  /// Whether to show divider after title.
  final bool showDividerAfterTitle;

  /// Color of divider after title.
  final Color? dividerColor;

  /// Width of divider after title.
  final double dividerWidth;

  /// Whether section is collapsible.
  final bool collapsible;

  /// Whether section is collapsed (only shows title).
  final bool collapsed;

  /// Whether to show shadow.
  final bool shadowEnabled;

  /// Shadow color.
  final Color? shadowColor;

  /// Shadow offset.
  final double shadowOffset;

  /// Creates a copy with modified values.
  GeniusPdfSectionStyle copyWith({
    Color? backgroundColor,
    GeniusPdfBorderStyle? borderStyle,
    GeniusPdfCellPadding? padding,
    GeniusPdfTextStyle? titleStyle,
    GeniusPdfTextStyle? subtitleStyle,
    GeniusPdfSectionTitlePosition? titlePosition,
    GeniusPdfCellPadding? titlePadding,
    Color? titleBackgroundColor,
    bool? showTitleUnderline,
    Color? titleUnderlineColor,
    double? titleUnderlineWidth,
    Color? headerBackgroundColor,
    GeniusPdfCellPadding? headerPadding,
    bool? showDividerAfterTitle,
    Color? dividerColor,
    double? dividerWidth,
    bool? collapsible,
    bool? collapsed,
    bool? shadowEnabled,
    Color? shadowColor,
    double? shadowOffset,
  }) {
    return GeniusPdfSectionStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderStyle: borderStyle ?? this.borderStyle,
      padding: padding ?? this.padding,
      titleStyle: titleStyle ?? this.titleStyle,
      subtitleStyle: subtitleStyle ?? this.subtitleStyle,
      titlePosition: titlePosition ?? this.titlePosition,
      titlePadding: titlePadding ?? this.titlePadding,
      titleBackgroundColor: titleBackgroundColor ?? this.titleBackgroundColor,
      showTitleUnderline: showTitleUnderline ?? this.showTitleUnderline,
      titleUnderlineColor: titleUnderlineColor ?? this.titleUnderlineColor,
      titleUnderlineWidth: titleUnderlineWidth ?? this.titleUnderlineWidth,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      headerPadding: headerPadding ?? this.headerPadding,
      showDividerAfterTitle:
          showDividerAfterTitle ?? this.showDividerAfterTitle,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerWidth: dividerWidth ?? this.dividerWidth,
      collapsible: collapsible ?? this.collapsible,
      collapsed: collapsed ?? this.collapsed,
      shadowEnabled: shadowEnabled ?? this.shadowEnabled,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
    );
  }
}

/// A bordered section for grouping content.
///
/// [GeniusPdfSection] provides a container for related content with:
/// - Bilingual title support
/// - Multiple title positions (above, inside, overlay)
/// - Customizable styling
/// - Optional subtitle
/// - Collapsible state
///
/// ## Example
/// ```dart
/// final section = GeniusPdfSection(
///   title: 'Order Details',
///   titleAr: 'تفاصيل الطلب',
///   style: GeniusPdfSectionStyle.corporate(),
/// );
///
/// section.draw(
///   page: page,
///   bounds: bounds,
///   contentBuilder: (contentBounds) {
///     // Draw content inside section
///     return contentHeight;
///   },
/// );
/// ```
class GeniusPdfSection {
  GeniusPdfSection({
    required this.config,
    this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    GeniusPdfSectionStyle? style,
    this.icon,
    this.iconColor,
    this.tag,
    this.keepTogether = false,
    this.pageBreakBefore = false,
    this.minHeight,
    this.maxHeight,
  }) : style = style ?? const GeniusPdfSectionStyle();

  /// Creates a titled section with corporate styling.
  factory GeniusPdfSection.corporate({
    required String title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    Color primaryColor = const Color(0xFF1565C0),
    required GeniusPdfConfig config,
  }) {
    return GeniusPdfSection(
      config: config,
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      style: GeniusPdfSectionStyle.corporate(primaryColor: primaryColor),
    );
  }

  /// Creates a card-style section.
  factory GeniusPdfSection.card({
    required String title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    Color borderColor = const Color(0xFFE0E0E0),
    Color? backgroundColor = const Color(0xFFFFFFFF),
    required GeniusPdfConfig config,
  }) {
    return GeniusPdfSection(
      config: config,
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      style: GeniusPdfSectionStyle.card(
        borderColor: borderColor,
        backgroundColor: backgroundColor,
      ),
    );
  }

  /// Section title (English or default).
  final String? title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Subtitle displayed below title.
  final String? subtitle;

  /// Arabic subtitle.
  final String? subtitleAr;

  /// Section style configuration.
  final GeniusPdfSectionStyle style;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// Base font for text.
  PdfFont get baseFont => config.baseFont;

  /// Bold font for titles.
  PdfFont get boldFont => config.boldFont;

  /// Whether to use RTL layout.
  bool get isRTL => config.isRTL;

  /// Optional icon identifier.
  final String? icon;

  /// Icon color.
  final Color? iconColor;

  /// Custom tag for identification.
  final String? tag;

  /// Whether to keep section content on same page.
  final bool keepTogether;

  /// Whether to insert page break before section.
  final bool pageBreakBefore;

  /// Minimum height for section.
  final double? minHeight;

  /// Maximum height for section.
  final double? maxHeight;

  /// Gets the display title based on locale.
  String? getTitle() {
    if (isRTL && titleAr != null) return titleAr;
    return title;
  }

  /// Gets the subtitle based on locale.
  String? getSubtitle() {
    if (isRTL && subtitleAr != null) return subtitleAr;
    return subtitle;
  }

  /// Draws the section frame and returns the content area bounds.
  ///
  /// [contentBuilder] is called with the inner content bounds and should
  /// return the height of the drawn content.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
    required double Function(Rect contentBounds) contentBuilder,
  }) {
    final graphics = page.graphics;
    double currentY = bounds.top;
    double boxTop = bounds.top;

    // Draw title based on position
    final displayTitle = getTitle();
    final displaySubtitle = getSubtitle();
    final hasTitle = displayTitle != null && displayTitle.isNotEmpty;

    if (hasTitle) {
      final titleFormat = PdfStringFormat(
        alignment: style.titleStyle.alignment.toPdfTextAlignment(config.isRTL),
        textDirection: config.pdfTextDirection
      );

      if (style.titlePosition == GeniusPdfSectionTitlePosition.above) {
        // Title above the box
        currentY += style.titlePadding.top;

        // Draw title background if specified
        if (style.titleBackgroundColor != null) {
          final titleHeight = style.titleStyle.fontSize * 1.2;
          graphics.drawRectangle(
            brush: PdfSolidBrush(style.titleBackgroundColor!.toPdfColor()),
            bounds: Rect.fromLTWH(
              bounds.left,
              currentY,
              bounds.width,
              titleHeight + style.titlePadding.top + style.titlePadding.bottom,
            ),
          );
        }

        graphics.drawString(
          displayTitle,
          boldFont,
          brush: style.titleStyle.toBrush(),
          bounds: Rect.fromLTWH(bounds.left, currentY, bounds.width, 0),
          format: titleFormat,
        );

        currentY += style.titleStyle.fontSize * 1.2;

        // Draw subtitle
        if (displaySubtitle != null && displaySubtitle.isNotEmpty) {
          currentY += 2;
          final subtitleTextStyle = style.subtitleStyle ??
              GeniusPdfTextStyle(
                fontSize: style.titleStyle.fontSize * 0.85,
                color: style.titleStyle.color.withValues(alpha: 0.7),
              );
          graphics.drawString(
            displaySubtitle,
            baseFont,
            brush: subtitleTextStyle.toBrush(),
            bounds: Rect.fromLTWH(bounds.left, currentY, bounds.width, 0),
            format: titleFormat,
          );
          currentY += subtitleTextStyle.fontSize * 1.2;
        }

        // Draw title underline if enabled
        if (style.showTitleUnderline) {
          currentY += 2;
          graphics.drawLine(
            PdfPen(
              (style.titleUnderlineColor ?? style.titleStyle.color)
                  .toPdfColor(),
              width: style.titleUnderlineWidth,
            ),
            Offset(bounds.left, currentY),
            Offset(bounds.right, currentY),
          );
          currentY += 2;
        }

        currentY += style.titlePadding.bottom;
        boxTop = currentY;
      }
    }

    // If collapsed, only draw title area
    if (style.collapsed) {
      return Rect.fromLTWH(
        bounds.left,
        bounds.top,
        bounds.width,
        currentY - bounds.top,
      );
    }

    // Calculate content bounds
    final contentTop =
        style.titlePosition == GeniusPdfSectionTitlePosition.inside
            ? boxTop + style.padding.top + _getTitleAreaHeight()
            : boxTop + style.padding.top;

    final contentBounds = Rect.fromLTWH(
      bounds.left + style.padding.left,
      contentTop,
      bounds.width - style.padding.left - style.padding.right,
      bounds.height - (contentTop - bounds.top) - style.padding.bottom,
    );

    // Build content and get height
    final contentHeight = contentBuilder(contentBounds);

    // Calculate box bounds
    var boxHeight = contentHeight + style.padding.top + style.padding.bottom;
    if (style.titlePosition == GeniusPdfSectionTitlePosition.inside &&
        hasTitle) {
      boxHeight += _getTitleAreaHeight();
    }

    // Apply height constraints
    if (minHeight != null && boxHeight < minHeight!) {
      boxHeight = minHeight!;
    }
    if (maxHeight != null && boxHeight > maxHeight!) {
      boxHeight = maxHeight!;
    }

    final boxBounds = Rect.fromLTWH(
      bounds.left,
      boxTop,
      bounds.width,
      boxHeight,
    );

    // Draw shadow if enabled
    if (style.shadowEnabled && style.shadowColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(style.shadowColor!.toPdfColor()),
        bounds: Rect.fromLTWH(
          boxBounds.left + style.shadowOffset,
          boxBounds.top + style.shadowOffset,
          boxBounds.width,
          boxBounds.height,
        ),
      );
    }

    // Draw background
    if (style.backgroundColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(style.backgroundColor!.toPdfColor()),
        bounds: boxBounds,
      );
    }

    // Draw title inside box if applicable
    if (hasTitle &&
        style.titlePosition == GeniusPdfSectionTitlePosition.inside) {
      final titleFormat = PdfStringFormat(
        alignment: style.titleStyle.alignment.toPdfTextAlignment(config.isRTL),
        textDirection: config.pdfTextDirection
      );

      // Draw header background if specified
      if (style.headerBackgroundColor != null) {
        graphics.drawRectangle(
          brush: PdfSolidBrush(style.headerBackgroundColor!.toPdfColor()),
          bounds: Rect.fromLTWH(
            boxBounds.left,
            boxBounds.top,
            boxBounds.width,
            _getTitleAreaHeight() + style.padding.top,
          ),
        );
      }

      var titleY = boxBounds.top + style.padding.top;
      graphics.drawString(
        displayTitle,
        boldFont,
        brush: style.titleStyle.toBrush(),
        bounds: Rect.fromLTWH(
          boxBounds.left + style.padding.left,
          titleY,
          boxBounds.width - style.padding.left - style.padding.right,
          0,
        ),
        format: titleFormat,
      );
      titleY += style.titleStyle.fontSize * 1.2;

      // Draw subtitle inside
      if (displaySubtitle != null && displaySubtitle.isNotEmpty) {
        titleY += 2;
        final subtitleTextStyle = style.subtitleStyle ??
            GeniusPdfTextStyle(
              fontSize: style.titleStyle.fontSize * 0.85,
              color: style.titleStyle.color.withValues(alpha: 0.7),
            );
        graphics.drawString(
          displaySubtitle,
          baseFont,
          brush: subtitleTextStyle.toBrush(),
          bounds: Rect.fromLTWH(
            boxBounds.left + style.padding.left,
            titleY,
            boxBounds.width - style.padding.left - style.padding.right,
            0,
          ),
          format: titleFormat,
        );
        titleY += subtitleTextStyle.fontSize * 1.2;
      }

      // Draw divider after title
      if (style.showDividerAfterTitle) {
        titleY += 4;
        graphics.drawLine(
          PdfPen(
            (style.dividerColor ?? const Color(0xFFE0E0E0)).toPdfColor(),
            width: style.dividerWidth,
          ),
          Offset(boxBounds.left, titleY),
          Offset(boxBounds.right, titleY),
        );
      }
    }

    // Draw border
    GeniusPdfInfoBox._drawBorder(graphics, boxBounds, style.borderStyle);

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      boxBounds.bottom - bounds.top,
    );
  }

  double _getTitleAreaHeight() {
    double height = 0;
    if (getTitle() != null) {
      height += style.titleStyle.fontSize * 1.2;
      if (getSubtitle() != null) {
        height += 2 +
            (style.subtitleStyle?.fontSize ??
                    style.titleStyle.fontSize * 0.85) *
                1.2;
      }
      if (style.showDividerAfterTitle) {
        height += 8; // 4px spacing + divider + 4px spacing
      }
    }
    return height;
  }
}
