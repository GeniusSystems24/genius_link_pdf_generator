part of '../pdf_info_box.dart';

/// Vertical alignment options for InfoBox content.
enum GeniusPdfInfoBoxAlignment {
  /// Align content to the top.
  top,

  /// Center content vertically.
  center,

  /// Align content to the bottom.
  bottom,
}

/// Layout options for labeled values in InfoBox.
enum GeniusPdfLabelValueLayout {
  /// Label and value side by side (horizontal).
  horizontal,

  /// Label above value (stacked).
  stacked,

  /// Value first, then label.
  valueFirst,
}

/// Style configuration for [GeniusPdfInfoBox].
///
/// Enhanced style with comprehensive theming options for:
/// - Background and border configuration
/// - Header styling with icons
/// - Label-value pair formatting
/// - Spacing and alignment control
/// - Shadow and decoration effects
/// - Status-themed presets (info, warning, success, error)
///
/// ## Example
/// ```dart
/// GeniusPdfInfoBoxStyle.corporate(
///   primaryColor: Color(0xFF1565C0),
///   accentColor: Color(0xFF0D47A1),
/// )
/// ```
class GeniusPdfInfoBoxStyle {
  const GeniusPdfInfoBoxStyle({
    this.backgroundColor,
    this.borderStyle = const GeniusPdfBorderStyle.all(),
    this.borderRadius = 0,
    this.padding = const GeniusPdfCellPadding.all(8),
    this.titleStyle = const GeniusPdfTextStyle.header(),
    this.contentStyle = const GeniusPdfTextStyle.body(),
    this.labelStyle,
    this.valueStyle,
    this.headerBackgroundColor,
    this.headerPadding,
    this.showDivider = false,
    this.dividerColor = const Color(0xFFE0E0E0),
    this.dividerWidth = 0.5,
    this.dividerMargin = 4,
    this.itemSpacing = 2,
    this.labelValueGap = 4,
    this.labelValueLayout = GeniusPdfLabelValueLayout.horizontal,
    this.labelWidth,
    this.labelAlign = GeniusPdfTextAlign.start,
    this.valueAlign = GeniusPdfTextAlign.end,
    this.contentAlignment = GeniusPdfInfoBoxAlignment.top,
    this.iconSize = 16,
    this.iconSpacing = 6,
    this.iconColor,
    this.shadowEnabled = false,
    this.shadowColor,
    this.shadowOffset = 2,
    this.shadowBlur = 4,
    this.minHeight,
    this.maxHeight,
    this.showItemSeparators = false,
    this.itemSeparatorColor,
    this.itemSeparatorWidth = 0.25,
  });

  /// Creates a style from [GeniusPdfPrintTheme].
  factory GeniusPdfInfoBoxStyle.fromTheme(GeniusPdfPrintTheme theme) {
    final infoTheme =
        theme.infoBoxTheme ?? const GeniusPdfInfoBoxTheme.defaults();
    final typography = theme.typography;

    return GeniusPdfInfoBoxStyle(
      backgroundColor: infoTheme.backgroundColor,
      borderStyle: GeniusPdfBorderStyle.all(
        width: infoTheme.borderWidth,
        color: infoTheme.borderColor,
      ),
      borderRadius: infoTheme.borderRadius,
      padding: infoTheme.padding,
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: typography.headingSize,
        color: infoTheme.titleColor,
      ),
      contentStyle: GeniusPdfTextStyle(
        fontSize: typography.bodySize,
        color: infoTheme.valueColor,
      ),
      labelStyle: GeniusPdfTextStyle(
        fontSize: typography.captionSize,
        color: infoTheme.labelColor,
      ),
      valueStyle: GeniusPdfTextStyle(
        fontSize: typography.bodySize,
        color: infoTheme.valueColor,
      ),
      headerBackgroundColor: infoTheme.headerBackgroundColor,
      showDivider: infoTheme.showDivider,
      dividerColor: infoTheme.dividerColor,
      dividerWidth: infoTheme.borderWidth,
    );
  }

  /// Creates a bordered card style.
  const GeniusPdfInfoBoxStyle.card({
    this.backgroundColor = const Color(0xFFFFFFFF),
    this.borderStyle = const GeniusPdfBorderStyle.all(color: Color(0xFFE0E0E0)),
    this.borderRadius = 4,
    this.padding = const GeniusPdfCellPadding.all(12),
    this.titleStyle = const GeniusPdfTextStyle.header(
      fontSize: 12,
      color: Color(0xFF424242),
    ),
    this.contentStyle = const GeniusPdfTextStyle.body(),
    this.itemSpacing = 4,
  })  : labelStyle = null,
        valueStyle = null,
        headerBackgroundColor = null,
        headerPadding = null,
        showDivider = false,
        dividerColor = const Color(0xFFE0E0E0),
        dividerWidth = 0.5,
        dividerMargin = 4,
        labelValueGap = 4,
        labelValueLayout = GeniusPdfLabelValueLayout.horizontal,
        labelWidth = null,
        labelAlign = GeniusPdfTextAlign.start,
        valueAlign = GeniusPdfTextAlign.end,
        contentAlignment = GeniusPdfInfoBoxAlignment.top,
        iconSize = 16,
        iconSpacing = 6,
        iconColor = null,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        shadowBlur = 4,
        minHeight = null,
        maxHeight = null,
        showItemSeparators = false,
        itemSeparatorColor = null,
        itemSeparatorWidth = 0.25;

  /// Creates a highlighted box style with left border accent.
  const GeniusPdfInfoBoxStyle.highlighted({
    this.backgroundColor = const Color(0xFFF5F5F5),
    this.borderStyle = const GeniusPdfBorderStyle(
      width: 2,
      color: Color(0xFF1565C0),
      left: true,
      right: false,
      top: false,
      bottom: false,
    ),
    this.padding = const GeniusPdfCellPadding.all(10),
    this.titleStyle = const GeniusPdfTextStyle.header(
      fontSize: 11,
      color: Color(0xFF1565C0),
    ),
    this.contentStyle = const GeniusPdfTextStyle.body(),
    this.itemSpacing = 3,
  })  : borderRadius = 0,
        labelStyle = null,
        valueStyle = null,
        headerBackgroundColor = null,
        headerPadding = null,
        showDivider = false,
        dividerColor = const Color(0xFFE0E0E0),
        dividerWidth = 0.5,
        dividerMargin = 4,
        labelValueGap = 4,
        labelValueLayout = GeniusPdfLabelValueLayout.horizontal,
        labelWidth = null,
        labelAlign = GeniusPdfTextAlign.start,
        valueAlign = GeniusPdfTextAlign.end,
        contentAlignment = GeniusPdfInfoBoxAlignment.top,
        iconSize = 16,
        iconSpacing = 6,
        iconColor = null,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        shadowBlur = 4,
        minHeight = null,
        maxHeight = null,
        showItemSeparators = false,
        itemSeparatorColor = null,
        itemSeparatorWidth = 0.25;

  /// Creates a header-content style with divider.
  const GeniusPdfInfoBoxStyle.headerContent({
    this.backgroundColor,
    this.borderStyle = const GeniusPdfBorderStyle.all(),
    this.borderRadius = 0,
    this.padding = const GeniusPdfCellPadding.all(0),
    this.titleStyle = const GeniusPdfTextStyle.header(fontSize: 11),
    this.contentStyle = const GeniusPdfTextStyle.body(),
    this.headerBackgroundColor = const Color(0xFFE8E8E8),
    this.headerPadding =
        const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
    this.showDivider = true,
    this.dividerColor = const Color(0xFF000000),
    this.dividerWidth = 0.5,
    this.itemSpacing = 2,
  })  : labelStyle = null,
        valueStyle = null,
        dividerMargin = 0,
        labelValueGap = 4,
        labelValueLayout = GeniusPdfLabelValueLayout.horizontal,
        labelWidth = null,
        labelAlign = GeniusPdfTextAlign.start,
        valueAlign = GeniusPdfTextAlign.end,
        contentAlignment = GeniusPdfInfoBoxAlignment.top,
        iconSize = 16,
        iconSpacing = 6,
        iconColor = null,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        shadowBlur = 4,
        minHeight = null,
        maxHeight = null,
        showItemSeparators = false,
        itemSeparatorColor = null,
        itemSeparatorWidth = 0.25;

  /// Creates a corporate/professional style.
  factory GeniusPdfInfoBoxStyle.corporate({
    Color primaryColor = const Color(0xFF1565C0),
    Color? accentColor,
    Color backgroundColor = const Color(0xFFFFFFFF),
    bool showShadow = false,
  }) {
    final effectiveAccent = accentColor ?? primaryColor;
    return GeniusPdfInfoBoxStyle(
      backgroundColor: backgroundColor,
      borderStyle: GeniusPdfBorderStyle.all(color: primaryColor, width: 1),
      borderRadius: 0,
      padding: const GeniusPdfCellPadding.all(0),
      titleStyle: const GeniusPdfTextStyle.header(
        fontSize: 10,
        color: Color(0xFFFFFFFF),
      ),
      contentStyle: const GeniusPdfTextStyle.body(fontSize: 9),
      labelStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
      ),
      valueStyle: const GeniusPdfTextStyle(fontSize: 9),
      headerBackgroundColor: effectiveAccent,
      headerPadding:
          const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      showDivider: true,
      dividerColor: primaryColor,
      dividerWidth: 1,
      dividerMargin: 0,
      itemSpacing: 3,
      labelValueLayout: GeniusPdfLabelValueLayout.horizontal,
      shadowEnabled: showShadow,
      shadowColor: const Color(0x33000000),
    );
  }

  /// Creates a minimal/clean style.
  factory GeniusPdfInfoBoxStyle.minimal({
    Color accentColor = const Color(0xFF424242),
    double borderWidth = 1.0,
  }) {
    return GeniusPdfInfoBoxStyle(
      backgroundColor: null,
      borderStyle: GeniusPdfBorderStyle.bottom(
        color: accentColor,
        width: borderWidth,
      ),
      borderRadius: 0,
      padding: const GeniusPdfCellPadding(bottom: 8),
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: 10,
        color: accentColor,
      ),
      contentStyle: const GeniusPdfTextStyle.body(fontSize: 9),
      showDivider: false,
      itemSpacing: 2,
      labelValueLayout: GeniusPdfLabelValueLayout.horizontal,
    );
  }

  /// Creates a Saudi-themed style with green colors.
  factory GeniusPdfInfoBoxStyle.saudi({
    Color primaryColor = const Color(0xFF006C35),
    Color? accentColor,
  }) {
    final effectiveAccent = accentColor ?? primaryColor;
    return GeniusPdfInfoBoxStyle(
      backgroundColor: primaryColor.withValues(alpha: 0.05),
      borderStyle: GeniusPdfBorderStyle.all(color: primaryColor, width: 1),
      borderRadius: 0,
      padding: const GeniusPdfCellPadding.all(0),
      titleStyle: const GeniusPdfTextStyle.header(
        fontSize: 10,
        color: Color(0xFFFFFFFF),
      ),
      contentStyle: const GeniusPdfTextStyle.body(fontSize: 9),
      labelStyle: GeniusPdfTextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: effectiveAccent,
      ),
      valueStyle: const GeniusPdfTextStyle(fontSize: 9),
      headerBackgroundColor: primaryColor,
      headerPadding:
          const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      showDivider: true,
      dividerColor: primaryColor,
      itemSpacing: 3,
    );
  }

  /// Creates an invoice-style info box.
  factory GeniusPdfInfoBoxStyle.invoice({
    bool stacked = false,
  }) {
    return GeniusPdfInfoBoxStyle(
      backgroundColor: const Color(0xFFFAFAFA),
      borderStyle: const GeniusPdfBorderStyle.all(color: Color(0xFFCCCCCC)),
      padding: const GeniusPdfCellPadding.all(8),
      titleStyle: const GeniusPdfTextStyle.header(
        fontSize: 10,
        color: Color(0xFF333333),
      ),
      contentStyle: const GeniusPdfTextStyle.body(fontSize: 9),
      labelStyle: const GeniusPdfTextStyle(
        fontSize: 8,
        color: Color(0xFF666666),
      ),
      valueStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
      ),
      headerBackgroundColor: const Color(0xFFE8E8E8),
      headerPadding:
          const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      showDivider: true,
      dividerColor: const Color(0xFFCCCCCC),
      itemSpacing: 4,
      labelValueLayout: stacked
          ? GeniusPdfLabelValueLayout.stacked
          : GeniusPdfLabelValueLayout.horizontal,
      showItemSeparators: true,
      itemSeparatorColor: const Color(0xFFEEEEEE),
    );
  }

  /// Creates an information/neutral status style (blue accent).
  factory GeniusPdfInfoBoxStyle.info({
    Color accentColor = const Color(0xFF1976D2),
  }) {
    return GeniusPdfInfoBoxStyle(
      backgroundColor: const Color(0xFFE3F2FD),
      borderStyle: GeniusPdfBorderStyle(
        width: 2,
        color: accentColor,
        left: true,
        right: false,
        top: false,
        bottom: false,
      ),
      padding: const GeniusPdfCellPadding.all(10),
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: 11,
        color: accentColor,
      ),
      contentStyle: const GeniusPdfTextStyle.body(fontSize: 9),
      labelStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      ),
      valueStyle: const GeniusPdfTextStyle(fontSize: 9),
      itemSpacing: 3,
      iconColor: accentColor,
    );
  }

  /// Creates a warning status style (amber/orange accent).
  factory GeniusPdfInfoBoxStyle.warning({
    Color accentColor = const Color(0xFFF57F17),
  }) {
    return GeniusPdfInfoBoxStyle(
      backgroundColor: const Color(0xFFFFF8E1),
      borderStyle: GeniusPdfBorderStyle(
        width: 2,
        color: accentColor,
        left: true,
        right: false,
        top: false,
        bottom: false,
      ),
      padding: const GeniusPdfCellPadding.all(10),
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: 11,
        color: accentColor,
      ),
      contentStyle: const GeniusPdfTextStyle.body(fontSize: 9),
      labelStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      ),
      valueStyle: const GeniusPdfTextStyle(fontSize: 9),
      itemSpacing: 3,
      iconColor: accentColor,
    );
  }

  /// Creates a success status style (green accent).
  factory GeniusPdfInfoBoxStyle.success({
    Color accentColor = const Color(0xFF2E7D32),
  }) {
    return GeniusPdfInfoBoxStyle(
      backgroundColor: const Color(0xFFE8F5E9),
      borderStyle: GeniusPdfBorderStyle(
        width: 2,
        color: accentColor,
        left: true,
        right: false,
        top: false,
        bottom: false,
      ),
      padding: const GeniusPdfCellPadding.all(10),
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: 11,
        color: accentColor,
      ),
      contentStyle: const GeniusPdfTextStyle.body(fontSize: 9),
      labelStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      ),
      valueStyle: const GeniusPdfTextStyle(fontSize: 9),
      itemSpacing: 3,
      iconColor: accentColor,
    );
  }

  /// Creates an error status style (red accent).
  factory GeniusPdfInfoBoxStyle.error({
    Color accentColor = const Color(0xFFC62828),
  }) {
    return GeniusPdfInfoBoxStyle(
      backgroundColor: const Color(0xFFFFEBEE),
      borderStyle: GeniusPdfBorderStyle(
        width: 2,
        color: accentColor,
        left: true,
        right: false,
        top: false,
        bottom: false,
      ),
      padding: const GeniusPdfCellPadding.all(10),
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: 11,
        color: accentColor,
      ),
      contentStyle: const GeniusPdfTextStyle.body(fontSize: 9),
      labelStyle: const GeniusPdfTextStyle(
        fontSize: 9,
        fontWeight: FontWeight.w600,
        color: Color(0xFF424242),
      ),
      valueStyle: const GeniusPdfTextStyle(fontSize: 9),
      itemSpacing: 3,
      iconColor: accentColor,
    );
  }

  /// Box background color.
  final Color? backgroundColor;

  /// Border style configuration.
  final GeniusPdfBorderStyle borderStyle;

  /// Corner radius (visual only, not actual rounded corners in PDF).
  final double borderRadius;

  /// Content padding.
  final GeniusPdfCellPadding padding;

  /// Title text style.
  final GeniusPdfTextStyle titleStyle;

  /// Default content text style.
  final GeniusPdfTextStyle contentStyle;

  /// Style for labels in key-value pairs.
  final GeniusPdfTextStyle? labelStyle;

  /// Style for values in key-value pairs.
  final GeniusPdfTextStyle? valueStyle;

  /// Header section background color.
  final Color? headerBackgroundColor;

  /// Header section padding.
  final GeniusPdfCellPadding? headerPadding;

  /// Whether to show divider between header and content.
  final bool showDivider;

  /// Divider line color.
  final Color dividerColor;

  /// Divider line width.
  final double dividerWidth;

  /// Margin above and below divider.
  final double dividerMargin;

  /// Vertical spacing between items.
  final double itemSpacing;

  /// Horizontal gap between label and value.
  final double labelValueGap;

  /// Layout mode for label-value pairs.
  final GeniusPdfLabelValueLayout labelValueLayout;

  /// Fixed width for labels (null for auto).
  final double? labelWidth;

  /// Alignment for labels.
  final GeniusPdfTextAlign labelAlign;

  /// Alignment for values.
  final GeniusPdfTextAlign valueAlign;

  /// Vertical content alignment.
  final GeniusPdfInfoBoxAlignment contentAlignment;

  /// Icon size in header.
  final double iconSize;

  /// Spacing between icon and title.
  final double iconSpacing;

  /// Icon color (null uses title color).
  final Color? iconColor;

  /// Whether to show shadow.
  final bool shadowEnabled;

  /// Shadow color.
  final Color? shadowColor;

  /// Shadow offset.
  final double shadowOffset;

  /// Shadow blur radius.
  final double shadowBlur;

  /// Minimum box height.
  final double? minHeight;

  /// Maximum box height.
  final double? maxHeight;

  /// Whether to show separators between items.
  final bool showItemSeparators;

  /// Color for item separators.
  final Color? itemSeparatorColor;

  /// Width of item separators.
  final double itemSeparatorWidth;

  /// Returns RTL-aware label alignment.
  ///
  /// When [isRTL] is true, swaps left↔right for proper bidirectional layout.
  GeniusPdfTextAlign effectiveLabelAlign({bool isRTL = false}) {
    if (!isRTL) return labelAlign;
    if (labelAlign == GeniusPdfTextAlign.start) return GeniusPdfTextAlign.end;
    if (labelAlign == GeniusPdfTextAlign.end) return GeniusPdfTextAlign.start;
    return labelAlign;
  }

  /// Returns RTL-aware value alignment.
  GeniusPdfTextAlign effectiveValueAlign({bool isRTL = false}) {
    if (!isRTL) return valueAlign;
    if (valueAlign == GeniusPdfTextAlign.start) return GeniusPdfTextAlign.end;
    if (valueAlign == GeniusPdfTextAlign.end) return GeniusPdfTextAlign.start;
    return valueAlign;
  }

  /// Creates a copy with modified values.
  GeniusPdfInfoBoxStyle copyWith({
    Color? backgroundColor,
    GeniusPdfBorderStyle? borderStyle,
    double? borderRadius,
    GeniusPdfCellPadding? padding,
    GeniusPdfTextStyle? titleStyle,
    GeniusPdfTextStyle? contentStyle,
    GeniusPdfTextStyle? labelStyle,
    GeniusPdfTextStyle? valueStyle,
    Color? headerBackgroundColor,
    GeniusPdfCellPadding? headerPadding,
    bool? showDivider,
    Color? dividerColor,
    double? dividerWidth,
    double? dividerMargin,
    double? itemSpacing,
    double? labelValueGap,
    GeniusPdfLabelValueLayout? labelValueLayout,
    double? labelWidth,
    GeniusPdfTextAlign? labelAlign,
    GeniusPdfTextAlign? valueAlign,
    GeniusPdfInfoBoxAlignment? contentAlignment,
    double? iconSize,
    double? iconSpacing,
    Color? iconColor,
    bool? shadowEnabled,
    Color? shadowColor,
    double? shadowOffset,
    double? shadowBlur,
    double? minHeight,
    double? maxHeight,
    bool? showItemSeparators,
    Color? itemSeparatorColor,
    double? itemSeparatorWidth,
  }) {
    return GeniusPdfInfoBoxStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      borderStyle: borderStyle ?? this.borderStyle,
      borderRadius: borderRadius ?? this.borderRadius,
      padding: padding ?? this.padding,
      titleStyle: titleStyle ?? this.titleStyle,
      contentStyle: contentStyle ?? this.contentStyle,
      labelStyle: labelStyle ?? this.labelStyle,
      valueStyle: valueStyle ?? this.valueStyle,
      headerBackgroundColor:
          headerBackgroundColor ?? this.headerBackgroundColor,
      headerPadding: headerPadding ?? this.headerPadding,
      showDivider: showDivider ?? this.showDivider,
      dividerColor: dividerColor ?? this.dividerColor,
      dividerWidth: dividerWidth ?? this.dividerWidth,
      dividerMargin: dividerMargin ?? this.dividerMargin,
      itemSpacing: itemSpacing ?? this.itemSpacing,
      labelValueGap: labelValueGap ?? this.labelValueGap,
      labelValueLayout: labelValueLayout ?? this.labelValueLayout,
      labelWidth: labelWidth ?? this.labelWidth,
      labelAlign: labelAlign ?? this.labelAlign,
      valueAlign: valueAlign ?? this.valueAlign,
      contentAlignment: contentAlignment ?? this.contentAlignment,
      iconSize: iconSize ?? this.iconSize,
      iconSpacing: iconSpacing ?? this.iconSpacing,
      iconColor: iconColor ?? this.iconColor,
      shadowEnabled: shadowEnabled ?? this.shadowEnabled,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      showItemSeparators: showItemSeparators ?? this.showItemSeparators,
      itemSeparatorColor: itemSeparatorColor ?? this.itemSeparatorColor,
      itemSeparatorWidth: itemSeparatorWidth ?? this.itemSeparatorWidth,
    );
  }
}

/// An information box component for displaying grouped information.
///
/// [GeniusPdfInfoBox] is useful for creating sections like customer details,
/// invoice information, or any grouped key-value content.
///
/// Enhanced features:
/// - Bilingual support (English/Arabic)
/// - Customizable styling and layout
/// - Icon support in header (draws from [GeniusPdfImage])
/// - Subtitle support
/// - Footer content
/// - Multiple layout modes for label-value pairs
/// - RTL-aware alignment
/// - Status-themed presets (info, warning, success, error)
///
/// ## Example
/// ```dart
/// final box = GeniusPdfInfoBox(
///   title: 'Customer Details',
///   titleAr: 'تفاصيل العميل',
///   items: [
///     GeniusPdfLabeledValue(label: 'Name', labelAr: 'الاسم', value: 'John Doe'),
///     GeniusPdfLabeledValue(label: 'Phone', labelAr: 'الهاتف', value: '+966 12 345 6789'),
///   ],
///   style: GeniusPdfInfoBoxStyle.corporate(),
/// );
///
/// box.draw(page: page, bounds: bounds);
/// ```
