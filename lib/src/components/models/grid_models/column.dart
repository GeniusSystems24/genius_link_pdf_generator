part of '../grid_models.dart';

/// Represents a column definition for [GeniusPdfDataGrid].
///
/// Enhanced column with support for:
/// - Bilingual titles (English/Arabic)
/// - Multiple alignment options
/// - Custom styling for header and cells
/// - Value formatting functions
/// - Width constraints
/// - Sorting indicators
///
/// ## Example
/// ```dart
/// GeniusPdfGridColumn(
///   id: 'total',
///   title: 'Total',
///   titleAr: 'الإجمالي',
///   alignment: GeniusPdfTextAlign.end,
///   isNumeric: true,
///   valueFormatter: (v) => '\$${v.toStringAsFixed(2)}',
/// )
/// ```
class GeniusPdfGridColumn {
  const GeniusPdfGridColumn({
    required this.id,
    required this.title,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.width,
    this.widthPercent,
    this.minWidth,
    this.maxWidth,
    this.flexFactor,
    this.alignment = GeniusPdfTextAlign.start,
    this.verticalAlignment = GeniusPdfVerticalAlign.top,
    this.headerAlignment,
    this.headerStyle,
    this.cellStyle,
    this.cellStyleBuilder,
    this.valueFormatter,
    this.formatSpec,
    this.isNumeric = false,
    this.isVisible = true,
    this.isSortable = false,
    this.sortDirection,
    this.wrapText = false,
    this.maxLines,
    this.ellipsis = '...',
    this.tooltip,
    this.tooltipAr,
    this.headerDirection = GeniusPdfDirection.auto,
    this.contentDirection = GeniusPdfDirection.auto,
    this.directionalPadding,
  });

  /// Creates a numeric column with right alignment.
  factory GeniusPdfGridColumn.numeric(
      {required String id,
      required String title,
      String? titleAr,
      double? width,
      double? widthPercent,
      double? minWidth,
      bool isNumeric = true,
      GeniusPdfCellStyle? headerStyle,
      GeniusPdfCellStyle? cellStyle,
      String Function(dynamic value)? valueFormatter,
      int decimalPlaces = 2,
      bool showThousandSeparator = true,
      GeniusPdfTextAlign alignment = GeniusPdfTextAlign.start}) {
    return GeniusPdfGridColumn(
      id: id,
      title: title,
      titleAr: titleAr,
      width: width,
      widthPercent: widthPercent,
      minWidth: minWidth ?? 60,
      alignment: alignment,
      headerStyle: headerStyle,
      cellStyle: cellStyle,
      isNumeric: isNumeric,
      valueFormatter: valueFormatter,
      formatSpec: valueFormatter == null
          ? GeniusPdfFormatSpec.number(
              decimalPlaces: decimalPlaces,
              useGrouping: showThousandSeparator,
            )
          : null,
    );
  }

  /// Creates a currency column with formatting.
  factory GeniusPdfGridColumn.currency({
    required String id,
    required String title,
    String? titleAr,
    double? width,
    double? widthPercent,
    double? minWidth,
    String currencySymbol = 'SAR',
    int decimalPlaces = 2,
    bool currencyBefore = false,
    bool showThousandSeparator = true,
    bool isNumeric = true,
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? cellStyle,
    GeniusPdfCellStyle? Function(dynamic value)? cellStyleBuilder,
    GeniusPdfTextAlign alignment = GeniusPdfTextAlign.end,
  }) {
    return GeniusPdfGridColumn(
      id: id,
      title: title,
      titleAr: titleAr,
      width: width,
      widthPercent: widthPercent,
      minWidth: minWidth ?? 80,
      alignment: alignment,
      headerStyle: headerStyle,
      cellStyle: cellStyle,
      cellStyleBuilder: cellStyleBuilder,
      isNumeric: isNumeric,
      formatSpec: GeniusPdfFormatSpec.money(
        currencyCode: currencySymbol,
        decimalPlaces: decimalPlaces,
        currencyDisplay: GeniusPdfCurrencyDisplay.code,
        currencyPosition: currencyBefore
            ? GeniusPdfCurrencyPosition.before
            : GeniusPdfCurrencyPosition.after,
        useGrouping: showThousandSeparator,
      ),
    );
  }

  /// Creates a percentage column.
  factory GeniusPdfGridColumn.percentage({
    required String id,
    required String title,
    String? titleAr,
    double? width,
    int decimalPlaces = 1,
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? cellStyle,
  }) {
    return GeniusPdfGridColumn(
      id: id,
      title: title,
      titleAr: titleAr,
      width: width,
      minWidth: 50,
      alignment: GeniusPdfTextAlign.center,
      headerStyle: headerStyle,
      cellStyle: cellStyle,
      isNumeric: true,
      formatSpec: GeniusPdfFormatSpec.percentage(
        decimalPlaces: decimalPlaces,
      ),
    );
  }

  /// Creates a date column.
  factory GeniusPdfGridColumn.date({
    required String id,
    required String title,
    String? titleAr,
    double? width,
    String dateFormat = 'dd/MM/yyyy',
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? cellStyle,
    GeniusPdfTextAlign alignment = GeniusPdfTextAlign.start,
  }) {
    return GeniusPdfGridColumn(
      id: id,
      title: title,
      titleAr: titleAr,
      width: width ?? 80,
      alignment: alignment,
      headerStyle: headerStyle,
      cellStyle: cellStyle,
      formatSpec: GeniusPdfFormatSpec.date(
        pattern: dateFormat,
      ),
    );
  }

  /// Creates a status/badge column with conditional formatting.
  factory GeniusPdfGridColumn.status(
      {required String id,
      required String title,
      String? titleAr,
      double? width,
      Map<String, Color>? statusColors,
      GeniusPdfCellStyle? headerStyle,
      GeniusPdfTextAlign alignment = GeniusPdfTextAlign.center}) {
    return GeniusPdfGridColumn(
      id: id,
      title: title,
      titleAr: titleAr,
      width: width ?? 80,
      alignment: alignment,
      headerStyle: headerStyle,
      cellStyle: statusColors != null
          ? GeniusPdfCellStyle(
              textStyle: GeniusPdfTextStyle(
                fontSize: 9,
                alignment: alignment,
              ),
            )
          : null,
    );
  }

  /// Unique identifier for this column.
  final String id;

  /// Display title (English or default).
  final String title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Subtitle under the main title.
  final String? subtitle;

  /// Arabic subtitle.
  final String? subtitleAr;

  /// Fixed width for this column.
  final double? width;

  /// Percentage-based width (0.0 to 1.0). Takes priority over flexFactor.
  /// Example: 0.3 means 30% of available width.
  final double? widthPercent;

  /// Minimum width constraint.
  final double? minWidth;

  /// Maximum width constraint.
  final double? maxWidth;

  /// Flex factor for proportional sizing.
  final int? flexFactor;

  /// Text alignment for cell content.
  final GeniusPdfTextAlign alignment;

  /// Vertical alignment for cell content.
  final GeniusPdfVerticalAlign verticalAlignment;

  /// Header-specific alignment (falls back to alignment if null).
  final GeniusPdfTextAlign? headerAlignment;

  /// Custom header style.
  final GeniusPdfCellStyle? headerStyle;

  /// Custom cell style for data rows.
  final GeniusPdfCellStyle? cellStyle;

  /// Function to dynamically determine cell style based on value.
  final GeniusPdfCellStyle? Function(dynamic value)? cellStyleBuilder;

  /// Function to format cell values.
  ///
  /// Legacy/custom callbacks have precedence over [formatSpec].
  final String Function(dynamic value)? valueFormatter;

  /// Shared S05 format specification.
  final GeniusPdfFormatSpec? formatSpec;

  /// Whether this column contains numeric data.
  final bool isNumeric;

  /// Whether this column is visible.
  final bool isVisible;

  /// Whether this column is sortable.
  final bool isSortable;

  /// Current sort direction (null = not sorted, true = ascending, false = descending).
  final bool? sortDirection;

  /// Whether to wrap text in cells.
  final bool wrapText;

  /// Maximum number of lines when wrapping.
  final int? maxLines;

  /// Ellipsis text for truncated content.
  final String ellipsis;

  /// Tooltip for header (English).
  final String? tooltip;

  /// Tooltip for header (Arabic).
  final String? tooltipAr;

  /// Header run direction.
  final GeniusPdfDirection headerDirection;
  /// Cell content run direction.
  final GeniusPdfDirection contentDirection;
  /// Logical start/end cell padding override.
  final GeniusPdfDirectionalInsets? directionalPadding;

  /// Gets the display title based on locale.
  String getTitle({bool isArabic = false}) {
    if (isArabic && titleAr != null) return titleAr!;
    return title;
  }

  /// Gets the subtitle based on locale.
  String? getSubtitle({bool isArabic = false}) {
    if (isArabic && subtitleAr != null) return subtitleAr;
    return subtitle;
  }

  /// Gets the effective header alignment.
  GeniusPdfTextAlign get effectiveHeaderAlignment =>
      headerAlignment ?? alignment;

  GeniusPdfGridColumn copyWith({
    String? id,
    String? title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    double? width,
    double? widthPercent,
    double? minWidth,
    double? maxWidth,
    int? flexFactor,
    GeniusPdfTextAlign? alignment,
    GeniusPdfVerticalAlign? verticalAlignment,
    GeniusPdfTextAlign? headerAlignment,
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? cellStyle,
    GeniusPdfCellStyle? Function(dynamic value)? cellStyleBuilder,
    String Function(dynamic value)? valueFormatter,
    GeniusPdfFormatSpec? formatSpec,
    bool? isNumeric,
    bool? isVisible,
    bool? isSortable,
    bool? sortDirection,
    bool? wrapText,
    int? maxLines,
    String? ellipsis,
    String? tooltip,
    String? tooltipAr,
    GeniusPdfDirection? headerDirection,
    GeniusPdfDirection? contentDirection,
    GeniusPdfDirectionalInsets? directionalPadding,
  }) {
    return GeniusPdfGridColumn(
      id: id ?? this.id,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      subtitle: subtitle ?? this.subtitle,
      subtitleAr: subtitleAr ?? this.subtitleAr,
      width: width ?? this.width,
      widthPercent: widthPercent ?? this.widthPercent,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      flexFactor: flexFactor ?? this.flexFactor,
      alignment: alignment ?? this.alignment,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      headerAlignment: headerAlignment ?? this.headerAlignment,
      headerStyle: headerStyle ?? this.headerStyle,
      cellStyle: cellStyle ?? this.cellStyle,
      cellStyleBuilder: cellStyleBuilder ?? this.cellStyleBuilder,
      valueFormatter: valueFormatter ?? this.valueFormatter,
      formatSpec: formatSpec ?? this.formatSpec,
      isNumeric: isNumeric ?? this.isNumeric,
      isVisible: isVisible ?? this.isVisible,
      isSortable: isSortable ?? this.isSortable,
      sortDirection: sortDirection ?? this.sortDirection,
      wrapText: wrapText ?? this.wrapText,
      maxLines: maxLines ?? this.maxLines,
      ellipsis: ellipsis ?? this.ellipsis,
      tooltip: tooltip ?? this.tooltip,
      tooltipAr: tooltipAr ?? this.tooltipAr,
      headerDirection: headerDirection ?? this.headerDirection,
      contentDirection: contentDirection ?? this.contentDirection,
      directionalPadding: directionalPadding ?? this.directionalPadding,
    );
  }


}
