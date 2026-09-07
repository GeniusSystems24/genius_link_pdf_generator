part of '../pdf_summary.dart';

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
///   highlightBackgroundColor: Colors.blue.withValues(alpha:0.1),
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
      alignment: GeniusPdfTextAlign.end,
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

  /// Creates a summary style from [GeniusPdfPrintTheme].
  factory GeniusPdfSummaryStyle.fromTheme(GeniusPdfPrintTheme theme) {
    final summaryTheme =
        theme.summaryTheme ?? const GeniusPdfSummaryTheme.defaults();
    final typography = theme.typography;

    return GeniusPdfSummaryStyle(
      backgroundColor: summaryTheme.backgroundColor,
      borderStyle: summaryTheme.showBorder
          ? GeniusPdfBorderStyle.all(
              width: summaryTheme.borderWidth,
              color: summaryTheme.borderColor,
            )
          : const GeniusPdfBorderStyle.none(),
      padding: summaryTheme.padding,
      labelStyle: GeniusPdfTextStyle(
        fontSize: typography.bodySize,
        color: summaryTheme.labelColor,
        alignment: GeniusPdfTextAlign.start,
      ),
      valueStyle: GeniusPdfTextStyle(
        fontSize: typography.bodySize,
        color: summaryTheme.valueColor,
        alignment: GeniusPdfTextAlign.end,
      ),
      totalLabelStyle: GeniusPdfTextStyle(
        fontSize: typography.bodySize,
        fontWeight: FontWeight.bold,
        color: summaryTheme.labelColor,
        alignment: GeniusPdfTextAlign.start,
      ),
      totalValueStyle: GeniusPdfTextStyle(
        fontSize: typography.bodySize,
        fontWeight: FontWeight.bold,
        color: summaryTheme.valueColor,
        alignment: GeniusPdfTextAlign.end,
      ),
      highlightBackgroundColor: summaryTheme.highlightBackgroundColor,
      itemSpacing: summaryTheme.itemSpacing,
      labelWidth: summaryTheme.labelWidthRatio,
      showSeparatorLine: summaryTheme.showBorder,
      separatorLineColor: summaryTheme.borderColor,
      separatorLineWidth: summaryTheme.borderWidth,
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: typography.headingSize,
        color: summaryTheme.labelColor,
      ),
      titleSpacing: theme.spacing.sm,
    );
  }

  /// Creates a card-style summary.
  const GeniusPdfSummaryStyle.card()
      : backgroundColor = const Color(0xFFFAFAFA),
        borderStyle = const GeniusPdfBorderStyle.all(color: Color(0xFFE0E0E0)),
        borderRadius = 4,
        padding = const GeniusPdfCellPadding.all(12),
        labelStyle = const GeniusPdfTextStyle.body(),
        valueStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          alignment: GeniusPdfTextAlign.end,
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
          alignment: GeniusPdfTextAlign.end,
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
          alignment: GeniusPdfTextAlign.end,
        ),
        totalLabelStyle = const GeniusPdfTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212121),
        ),
        totalValueStyle = const GeniusPdfTextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          alignment: GeniusPdfTextAlign.end,
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
          alignment: GeniusPdfTextAlign.end,
        ),
        totalLabelStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFF212529),
        ),
        totalValueStyle = const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          alignment: GeniusPdfTextAlign.end,
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
