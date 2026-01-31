import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfBorderStyle, PdfTextStyle;

import '../../core/pdf_logger.dart';
import '../../extensions/color_extensions.dart';
import '../../models/pdf_image.dart';
import '../models/pdf_styles.dart';
import 'pdf_rich_text.dart';

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
    this.labelAlign = GeniusPdfTextAlign.left,
    this.valueAlign = GeniusPdfTextAlign.right,
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
        labelAlign = GeniusPdfTextAlign.left,
        valueAlign = GeniusPdfTextAlign.right,
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
        labelAlign = GeniusPdfTextAlign.left,
        valueAlign = GeniusPdfTextAlign.right,
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
        labelAlign = GeniusPdfTextAlign.left,
        valueAlign = GeniusPdfTextAlign.right,
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
      titleStyle: GeniusPdfTextStyle.header(
        fontSize: 10,
        color: const Color(0xFFFFFFFF),
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
    if (labelAlign == GeniusPdfTextAlign.left) return GeniusPdfTextAlign.right;
    if (labelAlign == GeniusPdfTextAlign.right) return GeniusPdfTextAlign.left;
    return labelAlign;
  }

  /// Returns RTL-aware value alignment.
  GeniusPdfTextAlign effectiveValueAlign({bool isRTL = false}) {
    if (!isRTL) return valueAlign;
    if (valueAlign == GeniusPdfTextAlign.left) return GeniusPdfTextAlign.right;
    if (valueAlign == GeniusPdfTextAlign.right) return GeniusPdfTextAlign.left;
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
class GeniusPdfInfoBox {
  GeniusPdfInfoBox({
    this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.items = const [],
    this.style = const GeniusPdfInfoBoxStyle(),
    required this.baseFont,
    required this.boldFont,
    this.isRTL = true,
    this.icon,
    this.footer,
    this.footerAr,
    this.footerStyle,
    this.showEmptyItems = false,
    this.emptyItemPlaceholder = '-',
    this.columns = 1,
    this.columnSpacing = 16,
    this.tag,
  });

  /// Creates an info box from a map of key-value pairs.
  factory GeniusPdfInfoBox.fromMap({
    required Map<String, dynamic> data,
    Map<String, String>? labelTranslations,
    String? title,
    String? titleAr,
    GeniusPdfInfoBoxStyle style = const GeniusPdfInfoBoxStyle(),
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    final items = <GeniusPdfLabeledValue>[];
    for (final entry in data.entries) {
      items.add(GeniusPdfLabeledValue(
        label: entry.key,
        labelAr: labelTranslations?[entry.key],
        value: entry.value?.toString() ?? '',
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }
    return GeniusPdfInfoBox(
      title: title,
      titleAr: titleAr,
      items: items,
      style: style,
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
    );
  }

  /// Creates an info box for displaying an address.
  factory GeniusPdfInfoBox.address({
    required String name,
    String? nameAr,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? postalCode,
    String? country,
    String? phone,
    String? email,
    String title = 'Address',
    String titleAr = 'العنوان',
    GeniusPdfInfoBoxStyle? style,
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    final items = <GeniusPdfLabeledValue>[];

    items.add(GeniusPdfLabeledValue(
      label: 'Name',
      labelAr: 'الاسم',
      value: name,
      baseFont: baseFont,
      boldFont: boldFont,
    ));

    if (line1 != null && line1.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Address',
        labelAr: 'العنوان',
        value: line1,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (line2 != null && line2.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: '',
        value: line2,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    final cityLine = [city, state, postalCode]
        .where((s) => s != null && s.isNotEmpty)
        .join(', ');
    if (cityLine.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'City',
        labelAr: 'المدينة',
        value: cityLine,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (country != null && country.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Country',
        labelAr: 'الدولة',
        value: country,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (phone != null && phone.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Phone',
        labelAr: 'الهاتف',
        value: phone,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (email != null && email.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Email',
        labelAr: 'البريد',
        value: email,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    return GeniusPdfInfoBox(
      title: title,
      titleAr: titleAr,
      items: items,
      style: style ?? const GeniusPdfInfoBoxStyle.card(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
    );
  }

  /// Creates a company info box with common fields.
  factory GeniusPdfInfoBox.company({
    required String companyName,
    String? companyNameAr,
    String? taxNumber,
    String? commercialReg,
    String? phone,
    String? email,
    String? website,
    String? address,
    String title = 'Company Information',
    String titleAr = 'معلومات الشركة',
    GeniusPdfInfoBoxStyle? style,
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    final items = <GeniusPdfLabeledValue>[];

    items.add(GeniusPdfLabeledValue(
      label: 'Company',
      labelAr: 'الشركة',
      value: companyName,
      baseFont: baseFont,
      boldFont: boldFont,
    ));

    if (taxNumber != null && taxNumber.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Tax Number',
        labelAr: 'الرقم الضريبي',
        value: taxNumber,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (commercialReg != null && commercialReg.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Commercial Reg.',
        labelAr: 'السجل التجاري',
        value: commercialReg,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (phone != null && phone.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Phone',
        labelAr: 'الهاتف',
        value: phone,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (email != null && email.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Email',
        labelAr: 'البريد',
        value: email,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (website != null && website.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Website',
        labelAr: 'الموقع',
        value: website,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (address != null && address.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Address',
        labelAr: 'العنوان',
        value: address,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    return GeniusPdfInfoBox(
      title: title,
      titleAr: titleAr,
      items: items,
      style: style ?? GeniusPdfInfoBoxStyle.corporate(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
    );
  }

  /// Creates a contact info box.
  factory GeniusPdfInfoBox.contact({
    required String name,
    String? nameAr,
    String? phone,
    String? mobile,
    String? email,
    String? department,
    String? position,
    String title = 'Contact',
    String titleAr = 'جهة الاتصال',
    GeniusPdfInfoBoxStyle? style,
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    final items = <GeniusPdfLabeledValue>[];

    items.add(GeniusPdfLabeledValue(
      label: 'Name',
      labelAr: 'الاسم',
      value: name,
      baseFont: baseFont,
      boldFont: boldFont,
    ));

    if (position != null && position.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Position',
        labelAr: 'المنصب',
        value: position,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (department != null && department.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Department',
        labelAr: 'القسم',
        value: department,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (phone != null && phone.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Phone',
        labelAr: 'الهاتف',
        value: phone,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (mobile != null && mobile.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Mobile',
        labelAr: 'الجوال',
        value: mobile,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    if (email != null && email.isNotEmpty) {
      items.add(GeniusPdfLabeledValue(
        label: 'Email',
        labelAr: 'البريد',
        value: email,
        baseFont: baseFont,
        boldFont: boldFont,
      ));
    }

    return GeniusPdfInfoBox(
      title: title,
      titleAr: titleAr,
      items: items,
      style: style ?? const GeniusPdfInfoBoxStyle.card(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
    );
  }

  /// Box title (English or default).
  final String? title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Subtitle displayed below title.
  final String? subtitle;

  /// Arabic subtitle.
  final String? subtitleAr;

  /// Key-value items to display.
  final List<GeniusPdfLabeledValue> items;

  /// Box style configuration.
  final GeniusPdfInfoBoxStyle style;

  /// Base font for text.
  final PdfFont baseFont;

  /// Bold font for titles and labels.
  final PdfFont boldFont;

  /// Whether to use RTL layout.
  final bool isRTL;

  /// Optional icon to display in header.
  final GeniusPdfImage? icon;

  /// Footer text (English).
  final String? footer;

  /// Footer text (Arabic).
  final String? footerAr;

  /// Custom footer style.
  final GeniusPdfTextStyle? footerStyle;

  /// Whether to show items with empty values.
  final bool showEmptyItems;

  /// Placeholder for empty item values.
  final String emptyItemPlaceholder;

  /// Number of columns for items layout.
  final int columns;

  /// Spacing between columns.
  final double columnSpacing;

  /// Custom tag for identification.
  final String? tag;

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

  /// Gets the footer text based on locale.
  String? getFooter() {
    if (isRTL && footerAr != null) return footerAr;
    return footer;
  }

  /// Gets items filtered by visibility.
  List<GeniusPdfLabeledValue> get visibleItems {
    if (showEmptyItems) return items;
    return items.where((item) => item.value.isNotEmpty).toList();
  }

  /// Creates a copy of this info box with optional overrides.
  GeniusPdfInfoBox copyWith({
    String? title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    List<GeniusPdfLabeledValue>? items,
    GeniusPdfInfoBoxStyle? style,
    PdfFont? baseFont,
    PdfFont? boldFont,
    bool? isRTL,
    GeniusPdfImage? icon,
    String? footer,
    String? footerAr,
    GeniusPdfTextStyle? footerStyle,
    bool? showEmptyItems,
    String? emptyItemPlaceholder,
    int? columns,
    double? columnSpacing,
    String? tag,
  }) {
    return GeniusPdfInfoBox(
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      subtitle: subtitle ?? this.subtitle,
      subtitleAr: subtitleAr ?? this.subtitleAr,
      items: items ?? this.items,
      style: style ?? this.style,
      baseFont: baseFont ?? this.baseFont,
      boldFont: boldFont ?? this.boldFont,
      isRTL: isRTL ?? this.isRTL,
      icon: icon ?? this.icon,
      footer: footer ?? this.footer,
      footerAr: footerAr ?? this.footerAr,
      footerStyle: footerStyle ?? this.footerStyle,
      showEmptyItems: showEmptyItems ?? this.showEmptyItems,
      emptyItemPlaceholder: emptyItemPlaceholder ?? this.emptyItemPlaceholder,
      columns: columns ?? this.columns,
      columnSpacing: columnSpacing ?? this.columnSpacing,
      tag: tag ?? this.tag,
    );
  }

  /// Draws the info box on a PDF page.
  ///
  /// Returns the actual bounds of the drawn content.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    GeniusPdfLogger.debug(
      'Drawing InfoBox: "${getTitle() ?? 'untitled'}" with ${visibleItems.length} items',
      tag: 'InfoBox',
    );
    final graphics = page.graphics;
    double currentY = bounds.top;

    // Calculate content height for background
    final contentHeight = _calculateHeight(bounds.width);
    var boxHeight = contentHeight + style.padding.top + style.padding.bottom;

    // Apply height constraints
    if (style.minHeight != null && boxHeight < style.minHeight!) {
      boxHeight = style.minHeight!;
    }
    if (style.maxHeight != null && boxHeight > style.maxHeight!) {
      boxHeight = style.maxHeight!;
    }

    final boxBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
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

    // Draw border
    _drawBorder(graphics, boxBounds, style.borderStyle);

    // Draw title and header
    final displayTitle = getTitle();
    if (displayTitle != null && displayTitle.isNotEmpty) {
      final headerPadding = style.headerPadding ?? style.padding;
      final headerHeight = _getHeaderHeight();

      // Draw header background if specified
      if (style.headerBackgroundColor != null) {
        graphics.drawRectangle(
          brush: PdfSolidBrush(style.headerBackgroundColor!.toPdfColor()),
          bounds: Rect.fromLTWH(
            bounds.left,
            currentY,
            bounds.width,
            headerHeight,
          ),
        );
      }

      currentY += headerPadding.top;
      var titleLeft = bounds.left + headerPadding.left;
      var titleWidth = bounds.width - headerPadding.left - headerPadding.right;

      // Draw icon if present
      if (icon != null) {
        final iconY = currentY + (_getTitleHeight() - style.iconSize) / 2;
        final iconX = isRTL
            ? (titleLeft + titleWidth - style.iconSize)
            : titleLeft;

        graphics.drawImage(
          PdfBitmap(icon!.data),
          Rect.fromLTWH(iconX, iconY, style.iconSize, style.iconSize),
        );

        if (isRTL) {
          titleWidth -= style.iconSize + style.iconSpacing;
        } else {
          titleLeft += style.iconSize + style.iconSpacing;
          titleWidth -= style.iconSize + style.iconSpacing;
        }
      }

      final titleFormat = PdfStringFormat(
        alignment: style.titleStyle.alignment.toPdfTextAlignment(),
        textDirection:
            isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
      );

      graphics.drawString(
        displayTitle,
        boldFont,
        brush: style.titleStyle.toBrush(),
        bounds: Rect.fromLTWH(
          titleLeft,
          currentY,
          titleWidth,
          0,
        ),
        format: titleFormat,
      );

      currentY += _getTitleHeight();

      // Draw subtitle
      final displaySubtitle = getSubtitle();
      if (displaySubtitle != null && displaySubtitle.isNotEmpty) {
        currentY += 2;
        final subtitleColor =
            style.titleStyle.color.withValues(alpha: 0.7);
        graphics.drawString(
          displaySubtitle,
          baseFont,
          brush: PdfSolidBrush(subtitleColor.toPdfColor()),
          bounds: Rect.fromLTWH(titleLeft, currentY, titleWidth, 0),
          format: titleFormat,
        );
        currentY += style.titleStyle.fontSize * 0.9;
      }

      currentY += headerPadding.bottom;

      // Draw divider
      if (style.showDivider) {
        currentY += style.dividerMargin;
        graphics.drawLine(
          PdfPen(style.dividerColor.toPdfColor(), width: style.dividerWidth),
          Offset(bounds.left, currentY),
          Offset(bounds.right, currentY),
        );
        currentY += style.dividerMargin;
      }
    } else {
      currentY += style.padding.top;
    }

    final contentLeft = bounds.left + style.padding.left;
    final contentWidth =
        bounds.width - style.padding.left - style.padding.right;

    // Draw items
    final filteredItems = visibleItems;
    if (columns > 1) {
      // Multi-column layout
      final columnWidth =
          (contentWidth - (columns - 1) * columnSpacing) / columns;
      int itemIndex = 0;
      double rowY = currentY;
      double maxRowHeight = 0;

      while (itemIndex < filteredItems.length) {
        for (int col = 0;
            col < columns && itemIndex < filteredItems.length;
            col++) {
          final item = filteredItems[itemIndex];
          final itemLeft = contentLeft + col * (columnWidth + columnSpacing);

          final labeledValue = _createLabeledValue(item);
          labeledValue.draw(
            page: page,
            bounds: Rect.fromLTWH(itemLeft, rowY, columnWidth, 20),
          );

          maxRowHeight = _getItemHeight() + style.itemSpacing;
          itemIndex++;
        }
        rowY += maxRowHeight;
        currentY = rowY;
      }
    } else {
      // Single column layout
      for (int i = 0; i < filteredItems.length; i++) {
        final item = filteredItems[i];
        final labeledValue = _createLabeledValue(item);

        labeledValue.draw(
          page: page,
          bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 20),
        );

        currentY += _getItemHeight() + style.itemSpacing;

        // Draw item separator
        if (style.showItemSeparators && i < filteredItems.length - 1) {
          final separatorColor = style.itemSeparatorColor ??
              style.dividerColor.withValues(alpha: 0.3);
          graphics.drawLine(
            PdfPen(separatorColor.toPdfColor(),
                width: style.itemSeparatorWidth),
            Offset(contentLeft, currentY - style.itemSpacing / 2),
            Offset(
                contentLeft + contentWidth, currentY - style.itemSpacing / 2),
          );
        }
      }
    }

    // Draw footer
    final displayFooter = getFooter();
    if (displayFooter != null && displayFooter.isNotEmpty) {
      currentY += style.itemSpacing;
      final defaultFooterColor =
        style.contentStyle.color.withValues(alpha: 0.7);
      final effectiveFooterStyle = footerStyle ??
          GeniusPdfTextStyle(
            fontSize: style.contentStyle.fontSize * 0.9,
            color: defaultFooterColor,
          );

      final footerFormat = PdfStringFormat(
        alignment: effectiveFooterStyle.alignment.toPdfTextAlignment(),
        textDirection:
            isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
      );

      graphics.drawString(
        displayFooter,
        baseFont,
        brush: effectiveFooterStyle.toBrush(),
        bounds: Rect.fromLTWH(contentLeft, currentY, contentWidth, 0),
        format: footerFormat,
      );
      currentY += effectiveFooterStyle.fontSize * 1.2;
    }

    // Return actual drawn bounds
    final actualHeight = currentY - bounds.top + style.padding.bottom;
    final finalHeight = boxHeight > actualHeight ? boxHeight : actualHeight;
    return Rect.fromLTWH(bounds.left, bounds.top, bounds.width, finalHeight);
  }

  GeniusPdfLabeledValue _createLabeledValue(GeniusPdfLabeledValue item) {
    return GeniusPdfLabeledValue(
      label: item.label,
      labelAr: item.labelAr,
      value: item.value.isEmpty ? emptyItemPlaceholder : item.value,
      labelStyle: style.labelStyle ?? item.labelStyle,
      valueStyle: style.valueStyle ?? item.valueStyle,
      separator: item.separator,
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
    );
  }

  double _calculateHeight([double? availableWidth]) {
    double height = 0;

    // Header height
    if (getTitle() != null) {
      height += _getHeaderHeight();
      if (style.showDivider) {
        height += style.dividerMargin * 2;
      }
    }

    // Items height
    final filteredItems = visibleItems;
    if (columns > 1) {
      final rows = (filteredItems.length / columns).ceil();
      height += rows * (_getItemHeight() + style.itemSpacing);
    } else {
      height += filteredItems.length * (_getItemHeight() + style.itemSpacing);
    }

    // Footer height
    if (getFooter() != null) {
      height += style.itemSpacing + (style.contentStyle.fontSize * 0.9) * 1.2;
    }

    return height;
  }

  double _getHeaderHeight() {
    final headerPadding = style.headerPadding ?? style.padding;
    double height =
        headerPadding.top + _getTitleHeight() + headerPadding.bottom;

    if (getSubtitle() != null) {
      height += 2 + style.titleStyle.fontSize * 0.9;
    }

    return height;
  }

  double _getTitleHeight() {
    return style.titleStyle.fontSize * 1.2;
  }

  double _getItemHeight() {
    if (style.labelValueLayout == GeniusPdfLabelValueLayout.stacked) {
      return style.contentStyle.fontSize * 2.4;
    }
    return style.contentStyle.fontSize * 1.4;
  }

  /// Draws border lines around a rectangle based on [GeniusPdfBorderStyle].
  static void _drawBorder(
    PdfGraphics graphics,
    Rect bounds,
    GeniusPdfBorderStyle borderStyle,
  ) {
    if (borderStyle.width <= 0) return;
    final pen = borderStyle.toPen();
    if (borderStyle.top) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.top),
        Offset(bounds.right, bounds.top),
      );
    }
    if (borderStyle.bottom) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.bottom),
        Offset(bounds.right, bounds.bottom),
      );
    }
    if (borderStyle.left) {
      graphics.drawLine(
        pen,
        Offset(bounds.left, bounds.top),
        Offset(bounds.left, bounds.bottom),
      );
    }
    if (borderStyle.right) {
      graphics.drawLine(
        pen,
        Offset(bounds.right, bounds.top),
        Offset(bounds.right, bounds.bottom),
      );
    }
  }
}

/// Layout modes for dual info box.
enum GeniusPdfDualInfoBoxLayout {
  /// Boxes side by side (horizontal).
  horizontal,

  /// Boxes stacked (vertical).
  vertical,

  /// Left box on top left, right box on bottom right (diagonal).
  diagonal,
}

/// A two-column info section for displaying parallel information.
///
/// Useful for invoice headers with customer and invoice details side by side.
///
/// Enhanced features:
/// - Multiple layout modes (horizontal, vertical, diagonal)
/// - RTL support (boxes swap positions)
/// - Equal height synchronization (draws both boxes at the taller height)
/// - Customizable proportions
/// - Connecting line between boxes
///
/// ## Example
/// ```dart
/// GeniusPdfDualInfoBox(
///   leftBox: customerInfo,
///   rightBox: invoiceInfo,
///   layout: GeniusPdfDualInfoBoxLayout.horizontal,
///   equalHeight: true,
/// )
/// ```
class GeniusPdfDualInfoBox {
  GeniusPdfDualInfoBox({
    required this.leftBox,
    required this.rightBox,
    this.spacing = 20,
    this.leftWidth,
    this.rightWidth,
    this.leftFlex = 1,
    this.rightFlex = 1,
    this.layout = GeniusPdfDualInfoBoxLayout.horizontal,
    this.equalHeight = false,
    this.verticalSpacing = 12,
    this.swapForRTL = true,
    this.showConnectingLine = false,
    this.connectingLineColor,
    this.connectingLineWidth = 0.5,
    this.backgroundColor,
    this.borderStyle,
    this.padding = const GeniusPdfCellPadding.all(0),
    this.alignment = GeniusPdfInfoBoxAlignment.top,
  });

  /// Creates a dual box from customer and invoice info.
  factory GeniusPdfDualInfoBox.customerInvoice({
    required GeniusPdfInfoBox customerBox,
    required GeniusPdfInfoBox invoiceBox,
    double spacing = 20,
    bool isRTL = false,
  }) {
    return GeniusPdfDualInfoBox(
      leftBox: isRTL ? invoiceBox : customerBox,
      rightBox: isRTL ? customerBox : invoiceBox,
      spacing: spacing,
      leftFlex: 1,
      rightFlex: 1,
      equalHeight: true,
      swapForRTL: false,
    );
  }

  /// Creates a dual box from shipping and billing info.
  factory GeniusPdfDualInfoBox.shippingBilling({
    required GeniusPdfInfoBox shippingBox,
    required GeniusPdfInfoBox billingBox,
    double spacing = 20,
  }) {
    return GeniusPdfDualInfoBox(
      leftBox: shippingBox,
      rightBox: billingBox,
      spacing: spacing,
      equalHeight: true,
    );
  }

  /// Left (or top in vertical layout) info box.
  final GeniusPdfInfoBox leftBox;

  /// Right (or bottom in vertical layout) info box.
  final GeniusPdfInfoBox rightBox;

  /// Horizontal spacing between boxes.
  final double spacing;

  /// Fixed width for left box (null for flex-based).
  final double? leftWidth;

  /// Fixed width for right box (null for flex-based).
  final double? rightWidth;

  /// Flex factor for left box width.
  final int leftFlex;

  /// Flex factor for right box width.
  final int rightFlex;

  /// Layout mode for the boxes.
  final GeniusPdfDualInfoBoxLayout layout;

  /// Whether both boxes should have equal height.
  final bool equalHeight;

  /// Vertical spacing when in vertical layout.
  final double verticalSpacing;

  /// Whether to swap boxes for RTL layout.
  final bool swapForRTL;

  /// Whether to show a connecting line between boxes.
  final bool showConnectingLine;

  /// Color for connecting line.
  final Color? connectingLineColor;

  /// Width of connecting line.
  final double connectingLineWidth;

  /// Background color for the combined area.
  final Color? backgroundColor;

  /// Border style for the combined area.
  final GeniusPdfBorderStyle? borderStyle;

  /// Padding around both boxes.
  final GeniusPdfCellPadding padding;

  /// Vertical alignment of boxes.
  final GeniusPdfInfoBoxAlignment alignment;

  /// Gets the effective left box based on RTL.
  GeniusPdfInfoBox _getLeftBox() {
    if (swapForRTL && leftBox.isRTL) {
      return rightBox;
    }
    return leftBox;
  }

  /// Gets the effective right box based on RTL.
  GeniusPdfInfoBox _getRightBox() {
    if (swapForRTL && leftBox.isRTL) {
      return leftBox;
    }
    return rightBox;
  }

  /// Draws both info boxes.
  Rect draw({
    required PdfPage page,
    required Rect bounds,
  }) {
    GeniusPdfLogger.debug('Drawing DualInfoBox: layout=${layout.name}', tag: 'InfoBox');
    final graphics = page.graphics;
    final contentBounds = Rect.fromLTWH(
      bounds.left + padding.left,
      bounds.top + padding.top,
      bounds.width - padding.left - padding.right,
      bounds.height - padding.top - padding.bottom,
    );

    // Draw background if specified
    if (backgroundColor != null) {
      graphics.drawRectangle(
        brush: PdfSolidBrush(backgroundColor!.toPdfColor()),
        bounds: bounds,
      );
    }

    Rect resultBounds;

    switch (layout) {
      case GeniusPdfDualInfoBoxLayout.horizontal:
        resultBounds = _drawHorizontal(page, contentBounds);
        break;
      case GeniusPdfDualInfoBoxLayout.vertical:
        resultBounds = _drawVertical(page, contentBounds);
        break;
      case GeniusPdfDualInfoBoxLayout.diagonal:
        resultBounds = _drawDiagonal(page, contentBounds);
        break;
    }

    // Draw border if specified
    if (borderStyle != null && borderStyle!.width > 0) {
      final finalBounds = Rect.fromLTWH(
        bounds.left,
        bounds.top,
        bounds.width,
        resultBounds.height + padding.top + padding.bottom,
      );
      GeniusPdfInfoBox._drawBorder(graphics, finalBounds, borderStyle!);
    }

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      resultBounds.height + padding.top + padding.bottom,
    );
  }

  Rect _drawHorizontal(PdfPage page, Rect bounds) {
    final graphics = page.graphics;
    final totalWidth = bounds.width;
    final effectiveLeft = _getLeftBox();
    final effectiveRight = _getRightBox();

    // Calculate widths
    double leftW;
    double rightW;
    if (leftWidth != null) {
      leftW = leftWidth!;
      rightW = rightWidth ?? (totalWidth - leftW - spacing);
    } else if (rightWidth != null) {
      rightW = rightWidth!;
      leftW = totalWidth - rightW - spacing;
    } else {
      final totalFlex = leftFlex + rightFlex;
      final availableWidth = totalWidth - spacing;
      leftW = availableWidth * leftFlex / totalFlex;
      rightW = availableWidth * rightFlex / totalFlex;
    }

    // When equalHeight is enabled, pre-calculate heights and use the max
    double? forcedHeight;
    if (equalHeight) {
      final leftH = effectiveLeft._calculateHeight(leftW) +
          effectiveLeft.style.padding.top +
          effectiveLeft.style.padding.bottom;
      final rightH = effectiveRight._calculateHeight(rightW) +
          effectiveRight.style.padding.top +
          effectiveRight.style.padding.bottom;
      forcedHeight = leftH > rightH ? leftH : rightH;

      // Apply minHeight from styles
      if (effectiveLeft.style.minHeight != null &&
          forcedHeight < effectiveLeft.style.minHeight!) {
        forcedHeight = effectiveLeft.style.minHeight!;
      }
      if (effectiveRight.style.minHeight != null &&
          forcedHeight < effectiveRight.style.minHeight!) {
        forcedHeight = effectiveRight.style.minHeight!;
      }
    }

    final leftBoxWithHeight = equalHeight && forcedHeight != null
        ? effectiveLeft.copyWith(
            style: effectiveLeft.style.copyWith(minHeight: forcedHeight))
        : effectiveLeft;
    final rightBoxWithHeight = equalHeight && forcedHeight != null
        ? effectiveRight.copyWith(
            style: effectiveRight.style.copyWith(minHeight: forcedHeight))
        : effectiveRight;

    final leftBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      leftW,
      bounds.height,
    );

    final rightBounds = Rect.fromLTWH(
      bounds.left + leftW + spacing,
      bounds.top,
      rightW,
      bounds.height,
    );

    final leftResult = leftBoxWithHeight.draw(page: page, bounds: leftBounds);
    final rightResult =
        rightBoxWithHeight.draw(page: page, bounds: rightBounds);

    // Draw connecting line if enabled
    if (showConnectingLine) {
      final lineX = bounds.left + leftW + spacing / 2;
      final lineColor = connectingLineColor ?? const Color(0xFFE0E0E0);
      final maxH = leftResult.height > rightResult.height
          ? leftResult.height
          : rightResult.height;
      graphics.drawLine(
        PdfPen(lineColor.toPdfColor(), width: connectingLineWidth),
        Offset(lineX, bounds.top),
        Offset(lineX, bounds.top + maxH),
      );
    }

    // Return combined bounds
    final maxHeight = leftResult.height > rightResult.height
        ? leftResult.height
        : rightResult.height;

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      maxHeight,
    );
  }

  Rect _drawVertical(PdfPage page, Rect bounds) {
    final effectiveLeft = _getLeftBox();
    final effectiveRight = _getRightBox();

    final topBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      bounds.height / 2,
    );

    final topResult = effectiveLeft.draw(page: page, bounds: topBounds);

    final bottomBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top + topResult.height + verticalSpacing,
      bounds.width,
      bounds.height - topResult.height - verticalSpacing,
    );

    final bottomResult = effectiveRight.draw(page: page, bounds: bottomBounds);

    // Draw connecting line if enabled
    if (showConnectingLine) {
      final lineY = bounds.top + topResult.height + verticalSpacing / 2;
      final lineColor = connectingLineColor ?? const Color(0xFFE0E0E0);
      page.graphics.drawLine(
        PdfPen(lineColor.toPdfColor(), width: connectingLineWidth),
        Offset(bounds.left, lineY),
        Offset(bounds.right, lineY),
      );
    }

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      topResult.height + verticalSpacing + bottomResult.height,
    );
  }

  Rect _drawDiagonal(PdfPage page, Rect bounds) {
    // Diagonal layout: left on top-left area, right on bottom-right area
    final effectiveLeft = _getLeftBox();
    final effectiveRight = _getRightBox();

    final halfWidth = (bounds.width - spacing) / 2;

    final topLeftBounds = Rect.fromLTWH(
      bounds.left,
      bounds.top,
      halfWidth,
      bounds.height / 2,
    );

    final topLeftResult = effectiveLeft.draw(page: page, bounds: topLeftBounds);

    final bottomRightBounds = Rect.fromLTWH(
      bounds.left + halfWidth + spacing,
      bounds.top + topLeftResult.height + verticalSpacing,
      halfWidth,
      bounds.height / 2,
    );

    final bottomRightResult =
        effectiveRight.draw(page: page, bounds: bottomRightBounds);

    return Rect.fromLTWH(
      bounds.left,
      bounds.top,
      bounds.width,
      topLeftResult.height + verticalSpacing + bottomRightResult.height,
    );
  }
}

/// Title position options for section.
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
    this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    @Deprecated('Use style.backgroundColor instead') Color? backgroundColor,
    @Deprecated('Use style.borderStyle instead')
    GeniusPdfBorderStyle borderStyle = const GeniusPdfBorderStyle.all(),
    @Deprecated('Use style.padding instead')
    GeniusPdfCellPadding padding = const GeniusPdfCellPadding.all(8),
    @Deprecated('Use style.titleStyle instead') GeniusPdfTextStyle titleStyle =
        const GeniusPdfTextStyle.header(fontSize: 11),
    GeniusPdfSectionStyle? style,
    required this.baseFont,
    required this.boldFont,
    this.isRTL = true,
    this.icon,
    this.iconColor,
    this.tag,
    this.keepTogether = false,
    this.pageBreakBefore = false,
    this.minHeight,
    this.maxHeight,
  }) : style = style ??
            GeniusPdfSectionStyle(
              backgroundColor: backgroundColor,
              borderStyle: borderStyle,
              padding: padding,
              titleStyle: titleStyle,
            );

  /// Creates a titled section with corporate styling.
  factory GeniusPdfSection.corporate({
    required String title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    Color primaryColor = const Color(0xFF1565C0),
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    return GeniusPdfSection(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      style: GeniusPdfSectionStyle.corporate(primaryColor: primaryColor),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
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
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    return GeniusPdfSection(
      title: title,
      titleAr: titleAr,
      subtitle: subtitle,
      subtitleAr: subtitleAr,
      style: GeniusPdfSectionStyle.card(
        borderColor: borderColor,
        backgroundColor: backgroundColor,
      ),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
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

  /// Base font for text.
  final PdfFont baseFont;

  /// Bold font for titles.
  final PdfFont boldFont;

  /// Whether to use RTL layout.
  final bool isRTL;

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
        alignment: style.titleStyle.alignment.toPdfTextAlignment(),
        textDirection:
            isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
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
        alignment: style.titleStyle.alignment.toPdfTextAlignment(),
        textDirection:
            isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
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
