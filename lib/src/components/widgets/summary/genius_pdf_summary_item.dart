part of '../pdf_summary.dart';

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

  /// Creates an item from a raw value through the shared S05 formatter.
  factory GeniusPdfSummaryItem.formatted({
    required String label,
    required Object? rawValue,
    required GeniusPdfFormatter formatter,
    required GeniusPdfFormatSpec formatSpec,
    String? labelAr,
    GeniusPdfTextStyle? style,
    Color? labelColor,
    Color? valueColor,
    double? labelFontSize,
    double? valueFontSize,
    bool isBold = false,
    bool isHighlighted = false,
    String? valuePrefix,
    String? valueSuffix,
    int indent = 0,
    bool showSeparator = true,
    double? customHeight,
    bool isRtl = false,
  }) {
    return GeniusPdfSummaryItem(
      label: label,
      labelAr: labelAr,
      value: formatter.format(rawValue, formatSpec, isRtl: isRtl),
      style: style,
      labelColor: labelColor,
      valueColor: valueColor,
      labelFontSize: labelFontSize,
      valueFontSize: valueFontSize,
      isBold: isBold,
      isHighlighted: isHighlighted,
      valuePrefix: valuePrefix,
      valueSuffix: valueSuffix,
      indent: indent,
      showSeparator: showSeparator,
      customHeight: customHeight,
    );
  }

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



/// Horizontal alignment options for summary sections.
enum GeniusPdfSummaryAlignment {
  left,
  center,
  right,
}
