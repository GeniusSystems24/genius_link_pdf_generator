part of '../pdf_summary.dart';

/// A summary section component for displaying totals and calculations (v2.12.5).
///
/// [GeniusPdfSummarySection] is commonly used at the bottom of invoices
/// for subtotals, taxes, and grand totals.
///
/// ## Key Improvements (v2.12.5)
/// - **Accurate row height**: Uses per-item `customHeight`, font sizes, and
///   title style for precise layout.
/// - **Group support**: Optional [groups] for sectioned summaries with
///   group headers and per-group styling.
/// - **Separator lines**: `showSeparatorLine` actually renders between items.
/// - **Highlight text color**: `highlightTextColor` applied to total rows.
/// - **Indent support**: `indent` levels affect label positioning.
/// - **Label-value gap**: `labelValueGap` respected in layout.
/// - **Total-specific styles**: `totalLabelStyle` / `totalValueStyle` applied.
///
/// ## Example — Simple
/// ```dart
/// final summary = GeniusPdfSummarySection(
///   config: config,
///   items: [
///     GeniusPdfSummaryItem.subtotal(label: 'Subtotal', value: '30,100'),
///     GeniusPdfSummaryItem(label: 'VAT (15%)', value: '4,515'),
///     GeniusPdfSummaryItem.total(label: 'Total', value: '34,615'),
///   ],
///   style: GeniusPdfSummaryStyle.invoice(),
/// );
/// summary.draw(page: page, bounds: bounds);
/// ```
///
/// ## Example — Grouped
/// ```dart
/// final summary = GeniusPdfSummarySection(
///   config: config,
///   groups: [
///     GeniusPdfSummaryGroup(
///       title: 'Sales', titleAr: 'المبيعات',
///       items: [
///         GeniusPdfSummaryItem(label: 'Products', value: '20,000'),
///         GeniusPdfSummaryItem(label: 'Services', value: '10,000'),
///       ],
///     ),
///     GeniusPdfSummaryGroup(
///       title: 'Deductions', titleAr: 'الخصومات',
///       items: [
///         GeniusPdfSummaryItem.negative(label: 'Discount', value: '-1,500'),
///       ],
///     ),
///   ],
///   items: [
///     GeniusPdfSummaryItem.total(label: 'Net Total', value: '28,500'),
///   ],
///   style: GeniusPdfSummaryStyle.invoice(),
/// );
/// ```
class GeniusPdfSummarySection {
  GeniusPdfSummarySection({
    this.items = const [],
    this.groups,
    this.title,
    this.titleAr,
    required this.config,
    GeniusPdfSummaryStyle? style,
    this.alignment = GeniusPdfSummaryAlignment.right,
    this.width,
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
    this.hideEmptyValues = false,
  }) : style = _resolveSummaryStyle(style, config);

  /// Summary items to display (rendered after all groups).
  final List<GeniusPdfSummaryItem> items;

  /// Optional grouped items (v2.12.5). Rendered before [items].
  final List<GeniusPdfSummaryGroup>? groups;

  /// Section title (optional).
  final String? title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Style configuration.
  final GeniusPdfSummaryStyle style;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// Inherited S01 context.
  final GeniusPdfDirectionality? directionality;

  /// Summary-level direction override.
  final GeniusPdfDirection direction;

  /// Collapse empty optional rows without layout gaps.
  final bool hideEmptyValues;

  GeniusPdfDirectionality get _effectiveDirectionality =>
      GeniusPdfComponentDirectionality.context(
        config: config,
        inherited: directionality,
        componentDirection: direction,
      );

  GeniusPdfResolvedDirection get _layoutDirection =>
      _effectiveDirectionality.resolve().direction;

  /// Base font for text.
  PdfFont get baseFont => config.baseFont;

  /// Bold font for highlighted items.
  PdfFont get boldFont => config.boldFont;

  /// Whether to use RTL layout.
  bool get isRTL => _layoutDirection == GeniusPdfResolvedDirection.rtl;

  /// Horizontal alignment of the summary box.
  final GeniusPdfSummaryAlignment alignment;

  /// Fixed width (optional, uses default proportion if null).
  final double? width;

  /// Estimates the rendered height of the summary box.
  ///
  /// This is used by the document builder to decide whether the summary
  /// should stay on the current page or move to the next one intact.
  double estimateHeight([double? availableWidth]) {
    final contentHeight = _calculateContentHeight(availableWidth);
    return contentHeight + style.padding.top + style.padding.bottom;
  }

  static GeniusPdfSummaryStyle _resolveSummaryStyle(
    GeniusPdfSummaryStyle? style,
    GeniusPdfConfig config,
  ) {
    if (style != null) return style;
    return GeniusPdfSummaryStyle.fromTheme(config.theme.printTheme);
  }

  bool _shouldRenderItem(GeniusPdfSummaryItem item) {
    if (!hideEmptyValues) return true;
    if (item.customHeight != null && item.label.isEmpty && item.value.isEmpty) {
      return true;
    }
    return item.value.trim().isNotEmpty;
  }

  /// Collects all items in order: groups first, then top-level items.
  List<_RenderableItem> get _allRenderItems {
    final result = <_RenderableItem>[];

    if (groups != null) {
      for (int gi = 0; gi < groups!.length; gi++) {
        final group = groups![gi];
        // Group header
        result.add(_RenderableItem.groupHeader(group));
        // Group items
        for (final item in group.items) {
          if (_shouldRenderItem(item)) result.add(_RenderableItem.item(item));
        }
        // Group separator (space after group, except the last one before items)
        if (gi < groups!.length - 1 || items.isNotEmpty) {
          result.add(_RenderableItem.groupSeparator());
        }
      }
    }

    for (final item in items) {
      if (_shouldRenderItem(item)) result.add(_RenderableItem.item(item));
    }

    return result;
  }

  /// Draws the summary section on a PDF page.
  ///
  /// Returns the bounding [Rect] of the drawn summary.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;

    // Calculate actual width and position
    final actualWidth = width ?? bounds.width * 0.4;
    double boxLeft;

    switch (alignment) {
      case GeniusPdfSummaryAlignment.left:
        boxLeft = bounds.left;
        break;
      case GeniusPdfSummaryAlignment.center:
        boxLeft = bounds.left + (bounds.width - actualWidth) / 2;
        break;
      case GeniusPdfSummaryAlignment.right:
        boxLeft = bounds.right - actualWidth;
        break;
    }

    final boxTop = bounds.top;
    double currentY = boxTop + style.padding.top;

    // Calculate total height
    final boxHeight = estimateHeight(bounds.width);

    final boxBounds = Rect.fromLTWH(boxLeft, boxTop, actualWidth, boxHeight);

    // Draw background
    if (style.backgroundColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(style.backgroundColor!.toPdfColor()),
        bounds: boxBounds,
      );
    }

    // Draw border
    _drawBorder(graphics, boxBounds);

    // Draw title if present
    if (title != null || titleAr != null) {
      final displayTitle = isRTL && titleAr != null ? titleAr : title;
      if (displayTitle != null) {
        final titleFont = boldFont;
        final effectiveTitleStyle = style.titleStyle ?? style.labelStyle;

        graphics.drawString(
          displayTitle,
          titleFont,
          brush: effectiveTitleStyle.toBrush(),
          bounds: Rect.fromLTWH(
            boxLeft + style.padding.left,
            currentY,
            actualWidth - style.padding.left - style.padding.right,
            0,
          ),
          format: PdfStringFormat(
            alignment: PdfTextAlignment.center,
            textDirection: isRTL
                ? PdfTextDirection.rightToLeft
                : PdfTextDirection.leftToRight,
          ),
        );
        currentY +=
            _titleHeight(effectiveTitleStyle) + style.titleSpacing;
      }
    }

    // Draw render items (groups + items)
    final contentLeft = boxLeft + style.padding.left;
    final contentWidth =
        actualWidth - style.padding.left - style.padding.right;

    final renderItems = _allRenderItems;
    for (int ri = 0; ri < renderItems.length; ri++) {
      final rItem = renderItems[ri];

      if (rItem.type == _RenderItemType.groupHeader) {
        currentY = _drawGroupHeader(
          graphics,
          rItem.group!,
          contentLeft,
          contentWidth,
          currentY,
          boxLeft,
          actualWidth,
        );
      } else if (rItem.type == _RenderItemType.groupSeparator) {
        currentY += style.itemSpacing;
      } else {
        final item = rItem.item!;
        currentY = _drawItem(
          graphics,
          item,
          contentLeft,
          contentWidth,
          currentY,
          boxLeft,
          actualWidth,
        );

        // Draw separator line between items
        if (style.showSeparatorLine &&
            ri < renderItems.length - 1 &&
            renderItems[ri + 1].type == _RenderItemType.item) {
          graphics.drawLine(
            PdfPen(
              style.separatorLineColor.toPdfColor(),
              width: style.separatorLineWidth,
            ),
            Offset(contentLeft, currentY - style.itemSpacing / 2),
            Offset(contentLeft + contentWidth,
                currentY - style.itemSpacing / 2),
          );
        }
      }
    }

    return boxBounds;
  }

  /// Draws a single summary item and returns the new Y position.
  double _drawItem(
    PdfGraphics graphics,
    GeniusPdfSummaryItem item,
    double contentLeft,
    double contentWidth,
    double currentY,
    double boxLeft,
    double actualWidth,
  ) {
    // Handle separator items
    if (item.customHeight != null && item.label.isEmpty && item.value.isEmpty) {
      return currentY + item.customHeight!;
    }

    final itemH = _itemHeight(item, contentWidth: contentWidth);
    final indentOffset = item.indent * style.indentWidth;

    // Draw highlight background if needed
    if (item.isHighlighted) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(style.highlightBackgroundColor.toPdfColor()),
        bounds: Rect.fromLTWH(
          boxLeft,
          currentY - 2,
          actualWidth,
          itemH + 4,
        ),
      );
    }

    // Determine fonts
    final labelFont = item.isBold ? boldFont : baseFont;
    final valueFont = item.isBold ? boldFont : baseFont;
    final effectiveLabelStyle = item.style ??
        (item.isBold
            ? (style.totalLabelStyle ?? style.labelStyle)
            : style.labelStyle);
    final effectiveValueStyle = item.style ??
        (item.isBold
            ? (style.totalValueStyle ?? style.valueStyle)
            : style.valueStyle);

    // Determine brushes — use total styles for highlighted, item colors override
    PdfBrush labelBrush;
    PdfBrush valueBrush;

    if (item.isHighlighted && style.highlightTextColor != null) {
      labelBrush = item.labelColor != null
          ? PdfSolidBrush(item.labelColor!.toPdfColor())
          : PdfSolidBrush(style.highlightTextColor!.toPdfColor());
      valueBrush = item.valueColor != null
          ? PdfSolidBrush(item.valueColor!.toPdfColor())
          : PdfSolidBrush(style.highlightTextColor!.toPdfColor());
    } else if (item.isBold) {
      final totalLabel = style.totalLabelStyle ?? style.labelStyle;
      final totalValue = style.totalValueStyle ?? style.valueStyle;
      labelBrush = item.labelColor != null
          ? PdfSolidBrush(item.labelColor!.toPdfColor())
          : totalLabel.toBrush();
      valueBrush = item.valueColor != null
          ? PdfSolidBrush(item.valueColor!.toPdfColor())
          : totalValue.toBrush();
    } else {
      labelBrush = item.labelColor != null
          ? PdfSolidBrush(item.labelColor!.toPdfColor())
          : style.labelStyle.toBrush();
      valueBrush = item.valueColor != null
          ? PdfSolidBrush(item.valueColor!.toPdfColor())
          : style.valueStyle.toBrush();
    }

    // Calculate widths with indent and gap
    final effectiveContentWidth = contentWidth - indentOffset - style.labelValueGap;
    final labelWidth = effectiveContentWidth * style.labelWidth;
    final valueWidth = effectiveContentWidth - labelWidth;

    // Draw label
    final labelX = GeniusPdfComponentDirectionality.startX(
      left: contentLeft,
      width: contentWidth,
      itemWidth: labelWidth,
      direction: _layoutDirection,
      inset: indentOffset,
    );
    graphics.drawString(
      item.getLabel(isArabic: isRTL),
      labelFont,
      brush: labelBrush,
      bounds: Rect.fromLTWH(labelX, currentY, labelWidth, itemH),
      format: PdfStringFormat(
        alignment: effectiveLabelStyle.alignment.toPdfTextAlignment(isRTL),
        textDirection: isRTL
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    );

    // Draw value
    final valueX = GeniusPdfComponentDirectionality.endX(
      left: contentLeft,
      width: contentWidth,
      itemWidth: valueWidth,
      direction: _layoutDirection,
    );
    graphics.drawString(
      item.getFormattedValue(),
      valueFont,
      brush: valueBrush,
      bounds: Rect.fromLTWH(valueX, currentY, valueWidth, itemH),
      format: PdfStringFormat(
        alignment: effectiveValueStyle.alignment.toPdfTextAlignment(isRTL),
        textDirection: GeniusPdfComponentDirectionality.valuePdfDirection(
          context: _effectiveDirectionality,
          text: item.getFormattedValue(),
        ),
      ),
    );

    return currentY + itemH + style.itemSpacing;
  }

  /// Draws a group header and returns the new Y position.
  double _drawGroupHeader(
    PdfGraphics graphics,
    GeniusPdfSummaryGroup group,
    double contentLeft,
    double contentWidth,
    double currentY,
    double boxLeft,
    double actualWidth,
  ) {
    final displayTitle =
        isRTL && group.titleAr != null ? group.titleAr : group.title;
    if (displayTitle == null) return currentY;

    final groupStyle = group.headerStyle ?? style.titleStyle ?? style.labelStyle;
    final headerFont = boldFont;

    // Draw group header background if provided
    if (group.headerBackgroundColor != null) {
      final hHeight = _groupHeaderHeight(group);
      graphics.drawRectangle(
        brush: PdfSolidBrush(group.headerBackgroundColor!.toPdfColor()),
        bounds: Rect.fromLTWH(
          boxLeft,
          currentY - 1,
          actualWidth,
          hHeight + 2,
        ),
      );
    }

    graphics.drawString(
      displayTitle,
      headerFont,
      brush: groupStyle.toBrush(),
      bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
      format: PdfStringFormat(
        alignment: groupStyle.alignment.toPdfTextAlignment(isRTL),
        textDirection: isRTL
            ? PdfTextDirection.rightToLeft
            : PdfTextDirection.leftToRight,
      ),
    );

    // Draw underline for group header if separatorLine is enabled
    final hHeight = _groupHeaderHeight(group);
    if (style.showSeparatorLine) {
      graphics.drawLine(
        PdfPen(
          style.separatorLineColor.toPdfColor(),
          width: style.separatorLineWidth,
        ),
        Offset(contentLeft, currentY + hHeight),
        Offset(contentLeft + contentWidth, currentY + hHeight),
      );
    }

    return currentY + hHeight + style.itemSpacing;
  }

  void _drawBorder(PdfGraphics graphics, Rect bounds) {
    final pen = style.borderStyle.toPen();
    if (style.borderStyle.top) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.top),
        Offset(bounds.right, bounds.top),
      );
    }
    if (style.borderStyle.bottom) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.bottom),
        Offset(bounds.right, bounds.bottom),
      );
    }
    if (style.borderStyle.left) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.top),
        Offset(bounds.left, bounds.bottom),
      );
    }
    if (style.borderStyle.right) {
      graphics.drawLine(
        pen,
        Offset(bounds.right, bounds.top),
        Offset(bounds.right, bounds.bottom),
      );
    }
  }

  /// Calculates the total content height with per-item accuracy (v2.12.5).
  double _calculateContentHeight([double? availableWidth]) {
    double height = 0;
    final boxWidth = width ?? ((availableWidth ?? 600) * 0.4);
    final estimatedContentWidth = boxWidth - style.padding.left - style.padding.right;

    // Title height
    if (title != null || titleAr != null) {
      final effectiveTitleStyle = style.titleStyle ?? style.labelStyle;
      height += _titleHeight(effectiveTitleStyle) + style.titleSpacing;
    }

    // Group heights
    if (groups != null) {
      for (int gi = 0; gi < groups!.length; gi++) {
        final group = groups![gi];
        // Group header
        height += _groupHeaderHeight(group) + style.itemSpacing;
        // Group items
        for (final item in group.items) {
          height += _itemHeight(item) + style.itemSpacing;
        }
        // Separator between groups
        if (gi < groups!.length - 1 || items.isNotEmpty) {
          height += style.itemSpacing;
        }
      }
    }

    // Top-level items
    for (final item in items) {
      height += _itemHeight(item) + style.itemSpacing;
    }

    return height;
  }

  /// Height for the section title.
  double _titleHeight(GeniusPdfTextStyle titleStyle) {
    return titleStyle.fontSize * 1.5;
  }

  /// Height for a group header.
  double _groupHeaderHeight(GeniusPdfSummaryGroup group) {
    final headerStyle =
        group.headerStyle ?? style.titleStyle ?? style.labelStyle;
    return headerStyle.fontSize * 1.4;
  }

  /// Height for a single item, respecting customHeight and per-item fontSize.
  double _itemHeight(
    GeniusPdfSummaryItem item, {
    double? contentWidth,
  }) {
    if (item.customHeight != null) return item.customHeight!;
    final labelSize = item.labelFontSize ?? style.labelStyle.fontSize;
    final valueSize = item.valueFontSize ?? style.valueStyle.fontSize;
    final effectiveSize = labelSize > valueSize ? labelSize : valueSize;
    final lineHeight = effectiveSize * 1.4;
    if (contentWidth == null || contentWidth <= 0) return lineHeight;

    final indent = item.indent * style.indentWidth;
    final usable = contentWidth - indent - style.labelValueGap;
    if (usable <= 0) return lineHeight;
    final labelWidth = usable * style.labelWidth;
    final valueWidth = usable - labelWidth;

    int lines(String value, double width, double fontSize) {
      if (value.isEmpty || width <= 0) return 1;
      final result = ((value.runes.length * fontSize * 0.55) / width).ceil();
      return result < 1 ? 1 : result;
    }

    final labelLines = lines(
      item.getLabel(isArabic: isRTL),
      labelWidth,
      labelSize,
    );
    final valueLines = lines(item.getFormattedValue(), valueWidth, valueSize);
    return lineHeight * (labelLines > valueLines ? labelLines : valueLines);
  }
}

// ---------------------------------------------------------------------------
// Internal helpers
// ---------------------------------------------------------------------------

enum _RenderItemType { item, groupHeader, groupSeparator }

class _RenderableItem {
  const _RenderableItem._(this.type, this.item, this.group);

  factory _RenderableItem.item(GeniusPdfSummaryItem item) =>
      _RenderableItem._(_RenderItemType.item, item, null);

  factory _RenderableItem.groupHeader(GeniusPdfSummaryGroup group) =>
      _RenderableItem._(_RenderItemType.groupHeader, null, group);

  factory _RenderableItem.groupSeparator() =>
      const _RenderableItem._(_RenderItemType.groupSeparator, null, null);

  final _RenderItemType type;
  final GeniusPdfSummaryItem? item;
  final GeniusPdfSummaryGroup? group;
}
