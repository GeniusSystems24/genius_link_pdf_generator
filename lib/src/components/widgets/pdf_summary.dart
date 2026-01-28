import 'dart:ui';

import 'package:flutter/material.dart' show FontWeight;
import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfTextStyle, PdfBorderStyle;

import '../../extensions/color_extensions.dart';
import '../../models/pdf_image.dart';
import '../models/pdf_styles.dart';

/// A summary item for [GeniusPdfSummarySection].
///
/// Enhanced summary item with support for:
/// - Bilingual labels (English/Arabic)
/// - Custom colors for labels and values
/// - Font size and weight customization
/// - Prefix and suffix text
/// - Indent levels for hierarchical display
///
/// ## Example
/// ```dart
/// GeniusPdfSummaryItem(
///   label: 'Subtotal',
///   labelAr: 'المجموع الفرعي',
///   value: '1,000.00',
///   valueSuffix: ' SAR',
///   indent: 0,
/// )
/// ```
class GeniusPdfSummaryItem {
  const GeniusPdfSummaryItem({
    required this.label,
    required this.value,
    this.labelAr,
    this.style,
    this.labelColor,
    this.valueColor,
    this.labelFontSize,
    this.valueFontSize,
    this.isBold = false,
    this.isHighlighted = false,
    this.valuePrefix,
    this.valueSuffix,
    this.indent = 0,
    this.showSeparator = true,
    this.customHeight,
  });

  /// Creates a total item (highlighted and bold).
  const GeniusPdfSummaryItem.total({
    required this.label,
    required this.value,
    this.labelAr,
    this.labelColor,
    this.valueColor,
    this.valuePrefix,
    this.valueSuffix,
    this.customHeight,
  })  : style = null,
        labelFontSize = null,
        valueFontSize = null,
        isBold = true,
        isHighlighted = true,
        indent = 0,
        showSeparator = true;

  /// Creates a subtotal item.
  const GeniusPdfSummaryItem.subtotal({
    required this.label,
    required this.value,
    this.labelAr,
    this.labelColor,
    this.valueColor,
    this.valuePrefix,
    this.valueSuffix,
    this.customHeight,
  })  : style = null,
        labelFontSize = null,
        valueFontSize = null,
        isBold = true,
        isHighlighted = false,
        indent = 0,
        showSeparator = true;

  /// Creates a positive value item (green).
  const GeniusPdfSummaryItem.positive({
    required this.label,
    required this.value,
    this.labelAr,
    this.labelColor,
    this.valuePrefix,
    this.valueSuffix,
    this.customHeight,
  })  : style = null,
        labelFontSize = null,
        valueFontSize = null,
        valueColor = const Color(0xFF2E7D32),
        isBold = false,
        isHighlighted = false,
        indent = 0,
        showSeparator = true;

  /// Creates a negative value item (red).
  const GeniusPdfSummaryItem.negative({
    required this.label,
    required this.value,
    this.labelAr,
    this.labelColor,
    this.valuePrefix,
    this.valueSuffix,
    this.customHeight,
  })  : style = null,
        labelFontSize = null,
        valueFontSize = null,
        valueColor = const Color(0xFFC62828),
        isBold = false,
        isHighlighted = false,
        indent = 0,
        showSeparator = true;

  /// Creates an indented sub-item.
  const GeniusPdfSummaryItem.indented({
    required this.label,
    required this.value,
    this.labelAr,
    this.labelColor,
    this.valueColor,
    this.valuePrefix,
    this.valueSuffix,
    int level = 1,
    this.customHeight,
  })  : style = null,
        labelFontSize = null,
        valueFontSize = null,
        isBold = false,
        isHighlighted = false,
        indent = level,
        showSeparator = true;

  /// Creates a spacer/separator item (no value).
  const GeniusPdfSummaryItem.separator({
    this.label = '',
    this.labelAr,
    double height = 8,
  })  : value = '',
        style = null,
        labelColor = null,
        valueColor = null,
        labelFontSize = null,
        valueFontSize = null,
        isBold = false,
        isHighlighted = false,
        valuePrefix = null,
        valueSuffix = null,
        indent = 0,
        showSeparator = false,
        customHeight = height;

  /// Display label (English).
  final String label;

  /// Arabic label (optional).
  final String? labelAr;

  /// Display value.
  final String value;

  /// Custom text style (overrides other style properties).
  final GeniusPdfTextStyle? style;

  /// Custom label color.
  final Color? labelColor;

  /// Custom value color.
  final Color? valueColor;

  /// Custom label font size.
  final double? labelFontSize;

  /// Custom value font size.
  final double? valueFontSize;

  /// Whether text is bold.
  final bool isBold;

  /// Whether this item is highlighted (e.g., total row).
  final bool isHighlighted;

  /// Prefix text before the value.
  final String? valuePrefix;

  /// Suffix text after the value.
  final String? valueSuffix;

  /// Indentation level for hierarchical display.
  final int indent;

  /// Whether to show separator (colon) between label and value.
  final bool showSeparator;

  /// Custom height for this item.
  final double? customHeight;

  /// Gets the display label based on locale.
  String getLabel({bool isArabic = false}) {
    if (isArabic && labelAr != null) return labelAr!;
    return label;
  }

  /// Gets the formatted value with prefix and suffix.
  String getFormattedValue() {
    final prefix = valuePrefix ?? '';
    final suffix = valueSuffix ?? '';
    return '$prefix$value$suffix';
  }

  /// Creates a copy with the given fields replaced.
  GeniusPdfSummaryItem copyWith({
    String? label,
    String? labelAr,
    String? value,
    GeniusPdfTextStyle? style,
    Color? labelColor,
    Color? valueColor,
    double? labelFontSize,
    double? valueFontSize,
    bool? isBold,
    bool? isHighlighted,
    String? valuePrefix,
    String? valueSuffix,
    int? indent,
    bool? showSeparator,
    double? customHeight,
  }) {
    return GeniusPdfSummaryItem(
      label: label ?? this.label,
      labelAr: labelAr ?? this.labelAr,
      value: value ?? this.value,
      style: style ?? this.style,
      labelColor: labelColor ?? this.labelColor,
      valueColor: valueColor ?? this.valueColor,
      labelFontSize: labelFontSize ?? this.labelFontSize,
      valueFontSize: valueFontSize ?? this.valueFontSize,
      isBold: isBold ?? this.isBold,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      valuePrefix: valuePrefix ?? this.valuePrefix,
      valueSuffix: valueSuffix ?? this.valueSuffix,
      indent: indent ?? this.indent,
      showSeparator: showSeparator ?? this.showSeparator,
      customHeight: customHeight ?? this.customHeight,
    );
  }
}

/// Style configuration for summary sections.
///
/// Enhanced style with support for:
/// - Background colors and gradients
/// - Border customization
/// - Typography settings for labels, values, and totals
/// - Highlight styling for total rows
/// - Indent styling for hierarchical items
/// - Separator line styling
///
/// ## Example
/// ```dart
/// GeniusPdfSummaryStyle(
///   backgroundColor: Colors.white,
///   borderStyle: GeniusPdfBorderStyle.all(color: Colors.grey),
///   padding: GeniusPdfCellPadding.all(12),
///   highlightBackgroundColor: Colors.blue.withOpacity(0.1),
///   showSeparatorLine: true,
/// )
/// ```
class GeniusPdfSummaryStyle {
  const GeniusPdfSummaryStyle({
    this.backgroundColor,
    this.borderStyle = const GeniusPdfBorderStyle.all(),
    this.borderRadius = 0,
    this.padding = const GeniusPdfCellPadding.all(8),
    this.labelStyle = const GeniusPdfTextStyle.body(),
    this.valueStyle = const GeniusPdfTextStyle(
      fontSize: 10,
      alignment: GeniusPdfTextAlign.right,
    ),
    this.totalLabelStyle,
    this.totalValueStyle,
    this.highlightBackgroundColor = const Color(0xFFE8E8E8),
    this.highlightTextColor,
    this.itemSpacing = 8,
    this.labelWidth = 0.3,
    this.indentWidth = 12,
    this.showSeparatorLine = false,
    this.separatorLineColor = const Color(0xFFE0E0E0),
    this.separatorLineWidth = 0.5,
    this.labelValueGap = 8,
    this.titleStyle,
    this.titleSpacing = 8,
  });

  /// Creates a card-style summary.
  const GeniusPdfSummaryStyle.card()
      : backgroundColor = const Color(0xFFFAFAFA),
        borderStyle = const GeniusPdfBorderStyle.all(color: Color(0xFFE0E0E0)),
        borderRadius = 4,
        padding = const GeniusPdfCellPadding.all(12),
        labelStyle = const GeniusPdfTextStyle.body(),
        valueStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          alignment: GeniusPdfTextAlign.right,
        ),
        totalLabelStyle = null,
        totalValueStyle = null,
        highlightBackgroundColor = const Color(0xFFE3F2FD),
        highlightTextColor = const Color(0xFF1565C0),
        itemSpacing = 6,
        labelWidth = 0.3,
        indentWidth = 12,
        showSeparatorLine = false,
        separatorLineColor = const Color(0xFFE0E0E0),
        separatorLineWidth = 0.5,
        labelValueGap = 8,
        titleStyle = null,
        titleSpacing = 10;

  /// Creates a bordered summary style.
  const GeniusPdfSummaryStyle.bordered()
      : backgroundColor = null,
        borderStyle = const GeniusPdfBorderStyle.all(width: 1),
        borderRadius = 0,
        padding = const GeniusPdfCellPadding.all(8),
        labelStyle = const GeniusPdfTextStyle.body(),
        valueStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          alignment: GeniusPdfTextAlign.right,
        ),
        totalLabelStyle = null,
        totalValueStyle = null,
        highlightBackgroundColor = const Color(0xFFE8E8E8),
        highlightTextColor = null,
        itemSpacing = 4,
        labelWidth = 0.3,
        indentWidth = 12,
        showSeparatorLine = true,
        separatorLineColor = const Color(0xFFBDBDBD),
        separatorLineWidth = 0.5,
        labelValueGap = 8,
        titleStyle = null,
        titleSpacing = 8;

  /// Creates a minimal/modern summary style.
  const GeniusPdfSummaryStyle.minimal()
      : backgroundColor = null,
        borderStyle = const GeniusPdfBorderStyle.none(),
        borderRadius = 0,
        padding =
            const GeniusPdfCellPadding.symmetric(horizontal: 0, vertical: 6),
        labelStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          color: Color(0xFF757575),
        ),
        valueStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          alignment: GeniusPdfTextAlign.right,
        ),
        totalLabelStyle = const GeniusPdfTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212121),
        ),
        totalValueStyle = const GeniusPdfTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          alignment: GeniusPdfTextAlign.right,
        ),
        highlightBackgroundColor = const Color(0xFFF5F5F5),
        highlightTextColor = null,
        itemSpacing = 4,
        labelWidth = 0.35,
        indentWidth = 10,
        showSeparatorLine = false,
        separatorLineColor = const Color(0xFFEEEEEE),
        separatorLineWidth = 0.25,
        labelValueGap = 6,
        titleStyle = null,
        titleSpacing = 6;

  /// Creates a compact summary style for invoices.
  const GeniusPdfSummaryStyle.invoice()
      : backgroundColor = const Color(0xFFF8F9FA),
        borderStyle = const GeniusPdfBorderStyle(
          width: 1,
          color: Color(0xFFDEE2E6),
          left: true,
          right: true,
          top: true,
          bottom: true,
        ),
        borderRadius = 0,
        padding =
            const GeniusPdfCellPadding.symmetric(horizontal: 10, vertical: 8),
        labelStyle = const GeniusPdfTextStyle(
          fontSize: 9,
          color: Color(0xFF495057),
        ),
        valueStyle = const GeniusPdfTextStyle(
          fontSize: 9,
          alignment: GeniusPdfTextAlign.right,
        ),
        totalLabelStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212529),
        ),
        totalValueStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          alignment: GeniusPdfTextAlign.right,
          color: Color(0xFF212529),
        ),
        highlightBackgroundColor = const Color(0xFFE9ECEF),
        highlightTextColor = const Color(0xFF212529),
        itemSpacing = 4,
        labelWidth = 0.4,
        indentWidth = 10,
        showSeparatorLine = true,
        separatorLineColor = const Color(0xFFDEE2E6),
        separatorLineWidth = 0.5,
        labelValueGap = 6,
        titleStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212529),
        ),
        titleSpacing = 8;

  /// Background color for the summary box.
  final Color? backgroundColor;

  /// Border style for the summary box.
  final GeniusPdfBorderStyle borderStyle;

  /// Border radius (approximated in PDF).
  final double borderRadius;

  /// Padding inside the summary box.
  final GeniusPdfCellPadding padding;

  /// Default style for labels.
  final GeniusPdfTextStyle labelStyle;

  /// Default style for values.
  final GeniusPdfTextStyle valueStyle;

  /// Style for total row labels (optional, falls back to labelStyle with bold).
  final GeniusPdfTextStyle? totalLabelStyle;

  /// Style for total row values (optional, falls back to valueStyle with bold).
  final GeniusPdfTextStyle? totalValueStyle;

  /// Background color for highlighted items (totals).
  final Color highlightBackgroundColor;

  /// Text color for highlighted items.
  final Color? highlightTextColor;

  /// Vertical spacing between items.
  final double itemSpacing;

  /// Ratio of label width (0.0 - 1.0).
  final double labelWidth;

  /// Width of each indent level.
  final double indentWidth;

  /// Whether to show separator lines between items.
  final bool showSeparatorLine;

  /// Color of separator lines.
  final Color separatorLineColor;

  /// Width of separator lines.
  final double separatorLineWidth;

  /// Horizontal gap between label and value.
  final double labelValueGap;

  /// Style for the section title.
  final GeniusPdfTextStyle? titleStyle;

  /// Spacing between title and items.
  final double titleSpacing;

  /// Creates a copy with the given fields replaced.
  GeniusPdfSummaryStyle copyWith({
    Color? backgroundColor,
    GeniusPdfBorderStyle? borderStyle,
    double? borderRadius,
    GeniusPdfCellPadding? padding,
    GeniusPdfTextStyle? labelStyle,
    GeniusPdfTextStyle? valueStyle,
    GeniusPdfTextStyle? totalLabelStyle,
    GeniusPdfTextStyle? totalValueStyle,
    Color? highlightBackgroundColor,
    Color? highlightTextColor,
    double? itemSpacing,
    double? labelWidth,
    double? indentWidth,
    bool? showSeparatorLine,
    Color? separatorLineColor,
    double? separatorLineWidth,
    double? labelValueGap,
    GeniusPdfTextStyle? titleStyle,
    double? titleSpacing,
  }) {
    return GeniusPdfSummaryStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderStyle: borderStyle ?? this.borderStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      labelStyle: labelStyle ?? this.labelStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      totalLabelStyle: totalLabelStyle ?? this.totalLabelStyle,
      totalValueStyle: totalValueStyle ?? this.totalValueStyle,
      highlightBackgroundColor:
          highlightBackgroundColor ?? this.highlightBackgroundColor,
      highlightTextColor: highlightTextColor ?? this.highlightTextColor,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      labelWidth: labelWidth ?? this.labelWidth,
      indentWidth: indentWidth ?? this.indentWidth,
      showSeparatorLine: showSeparatorLine ?? this.showSeparatorLine,
      separatorLineColor: separatorLineColor ?? this.separatorLineColor,
      separatorLineWidth: separatorLineWidth ?? this.separatorLineWidth,
      labelValueGap: labelValueGap ?? this.labelValueGap,
      titleStyle: titleStyle ?? this.titleStyle,
      titleSpacing: titleSpacing ?? this.titleSpacing,
    );
  }
}

/// A summary section component for displaying totals and calculations.
///
/// [GeniusPdfSummarySection] is commonly used at the bottom of invoices
/// for subtotals, taxes, and grand totals.
///
/// ## Example
/// ```dart
/// final summary = PdfSummarySection(
///   items: [
///     PdfSummaryItem.subtotal(
///       label: 'Subtotal',
///       labelAr: 'المجموع الفرعي',
///       value: '30,100.00 SAR',
///     ),
///     PdfSummaryItem(
///       label: 'VAT (15%)',
///       labelAr: 'ضريبة القيمة المضافة (15%)',
///       value: '4,515.00 SAR',
///     ),
///     PdfSummaryItem.total(
///       label: 'Total Amount',
///       labelAr: 'الإجمالي',
///       value: '34,615.00 SAR',
///     ),
///   ],
/// );
///
/// summary.draw(page: page, bounds: bounds);
/// ```
class GeniusPdfSummarySection {
  GeniusPdfSummarySection({
    required this.items,
    this.title,
    this.titleAr,
    this.style = const GeniusPdfSummaryStyle(),
    required this.baseFont,
    required this.boldFont,
    this.isRTL = true,
    this.alignment = GeniusPdfSummaryAlignment.right,
    this.width,
  });

  /// Summary items to display.
  final List<GeniusPdfSummaryItem> items;

  /// Section title (optional).
  final String? title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Style configuration.
  final GeniusPdfSummaryStyle style;

  /// Base font for text.
  final PdfFont baseFont;

  /// Bold font for highlighted items.
  final PdfFont boldFont;

  /// Whether to use RTL layout.
  final bool isRTL;

  /// Horizontal alignment of the summary box.
  final GeniusPdfSummaryAlignment alignment;

  /// Fixed width (optional, uses default proportion if null).
  final double? width;

  /// Draws the summary section on a PDF page.
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
    final contentHeight = _calculateContentHeight();
    final boxHeight = contentHeight + style.padding.top + style.padding.bottom;

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
        // Font
        final titleFont = boldFont;

        graphics.drawString(
          displayTitle,
          titleFont,
          brush: style.labelStyle.toBrush(),
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
        currentY += style.labelStyle.fontSize * 1.5 + style.itemSpacing;
      }
    }

    // Draw items
    final contentLeft = boxLeft + style.padding.left;
    final contentWidth = actualWidth - style.padding.left - style.padding.right;
    final labelWidth = contentWidth * style.labelWidth;
    final valueWidth = contentWidth - labelWidth;

    for (final item in items) {
      // Draw highlight background if needed
      if (item.isHighlighted) {
        graphics.drawRectangle(
          brush: PdfSolidBrush(style.highlightBackgroundColor.toPdfColor()),
          bounds: Rect.fromLTWH(
            boxLeft,
            currentY - 2,
            actualWidth,
            style.labelStyle.fontSize * 1.4 + 4,
          ),
        );
      }

      // Determine fonts
      final labelFont = item.isBold ? boldFont : baseFont;
      final valueFont = item.isBold ? boldFont : baseFont;

      // Draw label
      final labelX = isRTL ? contentLeft + valueWidth : contentLeft;
      graphics.drawString(
        item.getLabel(isArabic: isRTL),
        labelFont,
        brush: style.labelStyle.toBrush(),
        bounds: Rect.fromLTWH(labelX, currentY, labelWidth, 0),
        format: PdfStringFormat(
          alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );

      // Draw value
      final valueX = isRTL ? contentLeft : contentLeft + labelWidth;
      final valueBrush = item.valueColor != null
          ? PdfSolidBrush(item.valueColor!.toPdfColor())
          : style.valueStyle.toBrush();

      graphics.drawString(
        item.value,
        valueFont,
        brush: valueBrush,
        bounds: Rect.fromLTWH(valueX, currentY, valueWidth, 0),
        format: PdfStringFormat(
          alignment: isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
          textDirection: PdfTextDirection.leftToRight,
        ),
      );

      currentY += style.labelStyle.fontSize * 1.4 + style.itemSpacing;
    }

    return boxBounds;
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

  double _calculateContentHeight() {
    double height = 0;

    if (title != null || titleAr != null) {
      height += style.labelStyle.fontSize * 1.5 + style.itemSpacing;
    }

    height +=
        items.length * (style.labelStyle.fontSize * 1.4 + style.itemSpacing);

    return height;
  }
}

/// Horizontal alignment options for summary sections.
enum GeniusPdfSummaryAlignment {
  left,
  center,
  right,
}

/// A horizontal total bar for displaying a single total prominently.
///
/// Useful for displaying grand totals at the bottom of reports.
class GeniusPdfTotalBar {
  GeniusPdfTotalBar({
    required this.label,
    required this.value,
    this.labelAr,
    this.backgroundColor = const Color(0xFF1565C0),
    this.textColor = const Color(0xFFFFFFFF),
    this.borderStyle = const GeniusPdfBorderStyle.none(),
    this.padding =
        const GeniusPdfCellPadding.symmetric(horizontal: 12, vertical: 8),
    this.baseFont,
    this.boldFont,
    this.isRTL = true,
    this.fontSize = 12,
  });

  final String label;
  final String? labelAr;
  final String value;
  final Color backgroundColor;
  final Color textColor;
  final GeniusPdfBorderStyle borderStyle;
  final GeniusPdfCellPadding padding;
  final PdfFont? baseFont;
  final PdfFont? boldFont;
  final bool isRTL;
  final double fontSize;

  /// Gets the display label based on locale.
  String getLabel() {
    if (isRTL && labelAr != null) return labelAr!;
    return label;
  }

  /// Draws the total bar on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;
    final barHeight = fontSize * 1.5 + padding.top + padding.bottom;

    final barBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      barHeight,
    );

    // Draw background
    graphics.drawRectangle(
      brush: PdfSolidBrush(backgroundColor.toPdfColor()),
      bounds: barBounds,
    );

    // Draw border
    if (borderStyle.width > 0) {
      final pen = borderStyle.toPen();
      if (borderStyle.top) {
        graphics.drawLine(pen, barBounds.topLeft, barBounds.topRight);
      }
      if (borderStyle.bottom) {
        graphics.drawLine(pen, barBounds.bottomLeft, barBounds.bottomRight);
      }
      if (borderStyle.left) {
        graphics.drawLine(pen, barBounds.topLeft, barBounds.bottomLeft);
      }
      if (borderStyle.right) {
        graphics.drawLine(pen, barBounds.topRight, barBounds.bottomRight);
      }
    }

    // Draw label and value
    final textY = bounds.top + padding.top;
    final textBrush = PdfSolidBrush(textColor.toPdfColor());
    // Font - baseFont and boldFont are required, no fallback to Helvetica
    final font = boldFont ?? baseFont!;

    final contentWidth = bounds.width - padding.left - padding.right;
    final halfWidth = contentWidth / 2;

    // Label
    graphics.drawString(
      getLabel(),
      font,
      brush: textBrush,
      bounds: Rect.fromLTWH(
        isRTL
            ? bounds.left + padding.left + halfWidth
            : bounds.left + padding.left,
        textY,
        halfWidth,
        0,
      ),
      format: PdfStringFormat(
        alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection:
            isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
      ),
    );

    // Value
    graphics.drawString(
      value,
      font,
      brush: textBrush,
      bounds: Rect.fromLTWH(
        isRTL
            ? bounds.left + padding.left
            : bounds.left + padding.left + halfWidth,
        textY,
        halfWidth,
        0,
      ),
      format: PdfStringFormat(
        alignment: isRTL ? PdfTextAlignment.left : PdfTextAlignment.right,
        textDirection: PdfTextDirection.leftToRight,
      ),
    );

    return barBounds;
  }
}

/// A signature area component for documents requiring signatures.
class GeniusPdfSignatureArea {
  GeniusPdfSignatureArea({
    this.title,
    this.titleAr,
    this.lineWidth = 150,
    this.lineY,
    this.showDate = true,
    this.dateLabel = 'Date',
    this.dateLabelAr = 'التاريخ',
    this.baseFont,
    this.isRTL = true,
  });

  final String? title;
  final String? titleAr;
  final double lineWidth;
  final double? lineY;
  final bool showDate;
  final String dateLabel;
  final String dateLabelAr;
  final PdfFont? baseFont;
  final bool isRTL;

  /// Gets the display title based on locale.
  String? getTitle() {
    if (isRTL && titleAr != null) return titleAr;
    return title;
  }

  /// Gets the date label based on locale.
  String getDateLabel() {
    return isRTL ? dateLabelAr : dateLabel;
  }

  /// Draws the signature area on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;
    double currentY = bounds.top;

    final displayTitle = getTitle();
    // Font - baseFont is required, no fallback to Helvetica
    final font = baseFont!;

    // Draw title
    if (displayTitle != null) {
      graphics.drawString(
        displayTitle,
        font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(bounds.left, currentY, bounds.width, 0),
        format: PdfStringFormat(
          alignment: isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          textDirection: isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );
      currentY += 20;
    }

    // Draw signature line
    final signatureY = lineY ?? currentY + 30;
    final lineX = isRTL ? bounds.right - lineWidth : bounds.left;

    graphics.drawLine(
      PdfPen(const Color(0xFF000000).toPdfColor(), width: 0.5),
      Offset(lineX, signatureY),
      Offset(lineX + lineWidth, signatureY),
    );

    // Draw date line if needed
    if (showDate) {
      final dateLineX = isRTL ? bounds.left : bounds.right - 100;
      graphics.drawLine(
        PdfPen(const Color(0xFF000000).toPdfColor(), width: 0.5),
        Offset(dateLineX, signatureY),
        Offset(dateLineX + 100, signatureY),
      );

      graphics.drawString(
        getDateLabel(),
        font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(dateLineX, signatureY + 2, 100, 0),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
        ),
      );
    }

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      signatureY + 20 - bounds.top,
    );
  }
}

/// A QR code component for invoices and documents.
///
/// Note: This component requires QR code data to be pre-generated as an image.
class GeniusPdfQRCode {
  GeniusPdfQRCode({
    required this.image,
    this.size = 80,
    this.caption,
    this.captionAr,
    this.baseFont,
    this.isRTL = true,
  });

  final GeniusPdfImage image;
  final double size;
  final String? caption;
  final String? captionAr;
  final PdfFont? baseFont;
  final bool isRTL;

  /// Gets the display caption based on locale.
  String? getCaption() {
    if (isRTL && captionAr != null) return captionAr;
    return caption;
  }

  /// Draws the QR code on a PDF page.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    final graphics = page.graphics;

    // Scale image to size
    final scaledImage = image.scaledToFit(maxWidth: size, maxHeight: size);

    // Center QR code in bounds
    final qrX = bounds.left + (bounds.width - scaledImage.width) / 2;
    final qrY = bounds.top;

    graphics.drawImage(
      PdfBitmap(scaledImage.data),
      Rect.fromLTWH(qrX, qrY, scaledImage.width, scaledImage.height),
    );

    double totalHeight = scaledImage.height;

    // Draw caption
    final displayCaption = getCaption();
    if (displayCaption != null) {
      // Font - baseFont is required, no fallback to Helvetica
      final font = baseFont!;
      graphics.drawString(
        displayCaption,
        font,
        brush: PdfBrushes.black,
        bounds: Rect.fromLTWH(
          bounds.left,
          qrY + scaledImage.height + 4,
          bounds.width,
          0,
        ),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );
      totalHeight += 16;
    }

    return Rect.fromLTWH(bounds.left, bounds.top, bounds.width, totalHeight);
  }
}
