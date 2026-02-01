import 'dart:ui';

import 'pdf_styles.dart';

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
    this.minWidth,
    this.maxWidth,
    this.flexFactor,
    this.alignment = GeniusPdfTextAlign.start,
    this.verticalAlignment = GeniusPdfVerticalAlign.top,
    this.headerAlignment,
    this.headerStyle,
    this.cellStyle,
    this.valueFormatter,
    this.isNumeric = false,
    this.isVisible = true,
    this.isSortable = false,
    this.sortDirection,
    this.wrapText = false,
    this.maxLines,
    this.ellipsis = '...',
    this.tooltip,
    this.tooltipAr,
  });

  /// Creates a numeric column with right alignment.
  factory GeniusPdfGridColumn.numeric(
      {required String id,
      required String title,
      String? titleAr,
      double? width,
      double? minWidth,
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
      minWidth: minWidth ?? 60,
      alignment: alignment,
      headerStyle: headerStyle,
      cellStyle: cellStyle,
      valueFormatter: valueFormatter ??
          (value) {
            if (value == null) return '';
            final number =
                value is num ? value : double.tryParse(value.toString());
            if (number == null) return value.toString();
            final formatted = number.toStringAsFixed(decimalPlaces);
            if (showThousandSeparator) {
              return _formatWithThousandSeparator(formatted);
            }
            return formatted;
          },
      isNumeric: true,
    );
  }

  /// Creates a currency column with formatting.
  factory GeniusPdfGridColumn.currency({
    required String id,
    required String title,
    String? titleAr,
    double? width,
    double? minWidth,
    String currencySymbol = 'SAR',
    int decimalPlaces = 2,
    bool currencyBefore = false,
    bool showThousandSeparator = true,
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? cellStyle,
    GeniusPdfTextAlign alignment = GeniusPdfTextAlign.end,
  }) {
    return GeniusPdfGridColumn(
      id: id,
      title: title,
      titleAr: titleAr,
      width: width,
      minWidth: minWidth ?? 80,
      alignment: alignment,
      headerStyle: headerStyle,
      cellStyle: cellStyle,
      isNumeric: true,
      valueFormatter: (value) {
        if (value == null) return '';
        final number = value is num ? value : double.tryParse(value.toString());
        if (number == null) return value.toString();
        var formatted = number.toStringAsFixed(decimalPlaces);
        if (showThousandSeparator) {
          formatted = _formatWithThousandSeparator(formatted);
        }
        return currencyBefore
            ? '$currencySymbol $formatted'
            : '$formatted $currencySymbol';
      },
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
      valueFormatter: (value) {
        if (value == null) return '';
        final number = value is num ? value : double.tryParse(value.toString());
        if (number == null) return value.toString();
        return '${number.toStringAsFixed(decimalPlaces)}%';
      },
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
      valueFormatter: (value) {
        if (value == null) return '';
        if (value is DateTime) {
          return _formatDate(value, dateFormat);
        }
        if (value is String) {
          final parsed = DateTime.tryParse(value);
          if (parsed != null) {
            return _formatDate(parsed, dateFormat);
          }
        }
        return value.toString();
      },
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

  /// Function to format cell values.
  final String Function(dynamic value)? valueFormatter;

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
    double? minWidth,
    double? maxWidth,
    int? flexFactor,
    GeniusPdfTextAlign? alignment,
    GeniusPdfVerticalAlign? verticalAlignment,
    GeniusPdfTextAlign? headerAlignment,
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? cellStyle,
    String Function(dynamic value)? valueFormatter,
    bool? isNumeric,
    bool? isVisible,
    bool? isSortable,
    bool? sortDirection,
    bool? wrapText,
    int? maxLines,
    String? ellipsis,
    String? tooltip,
    String? tooltipAr,
  }) {
    return GeniusPdfGridColumn(
      id: id ?? this.id,
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      subtitle: subtitle ?? this.subtitle,
      subtitleAr: subtitleAr ?? this.subtitleAr,
      width: width ?? this.width,
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      flexFactor: flexFactor ?? this.flexFactor,
      alignment: alignment ?? this.alignment,
      verticalAlignment: verticalAlignment ?? this.verticalAlignment,
      headerAlignment: headerAlignment ?? this.headerAlignment,
      headerStyle: headerStyle ?? this.headerStyle,
      cellStyle: cellStyle ?? this.cellStyle,
      valueFormatter: valueFormatter ?? this.valueFormatter,
      isNumeric: isNumeric ?? this.isNumeric,
      isVisible: isVisible ?? this.isVisible,
      isSortable: isSortable ?? this.isSortable,
      sortDirection: sortDirection ?? this.sortDirection,
      wrapText: wrapText ?? this.wrapText,
      maxLines: maxLines ?? this.maxLines,
      ellipsis: ellipsis ?? this.ellipsis,
      tooltip: tooltip ?? this.tooltip,
      tooltipAr: tooltipAr ?? this.tooltipAr,
    );
  }

  /// Helper to format numbers with thousand separators.
  static String _formatWithThousandSeparator(String number) {
    final parts = number.split('.');
    final intPart = parts[0];
    final decPart = parts.length > 1 ? '.${parts[1]}' : '';
    final buffer = StringBuffer();
    int count = 0;
    for (int i = intPart.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0 && intPart[i] != '-') {
        buffer.write(',');
      }
      buffer.write(intPart[i]);
      count++;
    }
    return buffer.toString().split('').reversed.join() + decPart;
  }

  /// Helper to format dates.
  static String _formatDate(DateTime date, String format) {
    var result = format;
    result = result.replaceAll('yyyy', date.year.toString());
    result =
        result.replaceAll('yy', (date.year % 100).toString().padLeft(2, '0'));
    result = result.replaceAll('MM', date.month.toString().padLeft(2, '0'));
    result = result.replaceAll('M', date.month.toString());
    result = result.replaceAll('dd', date.day.toString().padLeft(2, '0'));
    result = result.replaceAll('d', date.day.toString());
    result = result.replaceAll('HH', date.hour.toString().padLeft(2, '0'));
    result = result.replaceAll('H', date.hour.toString());
    result = result.replaceAll('mm', date.minute.toString().padLeft(2, '0'));
    result = result.replaceAll('ss', date.second.toString().padLeft(2, '0'));
    return result;
  }
}

/// Represents a row of data for [PdfDataGrid].
///
/// Enhanced row with support for:
/// - Multiple row types (header, data, total, group header, subtotal)
/// - Custom styling per row
/// - Cell spanning and merging
/// - Height constraints
/// - Conditional formatting
/// - Selection and highlighting
///
/// ## Example
/// ```dart
/// GeniusPdfGridRow(
///   cells: {'name': 'Product A', 'price': 100.0},
///   style: GeniusPdfCellStyle(backgroundColor: Colors.grey),
/// )
/// ```
class GeniusPdfGridRow {
  const GeniusPdfGridRow({
    required this.cells,
    this.style,
    this.isHeader = false,
    this.isTotal = false,
    this.isGroupHeader = false,
    this.isSubtotal = false,
    this.groupLevel = 0,
    this.span,
    this.height,
    this.minHeight,
    this.maxHeight,
    this.backgroundColor,
    this.isSelected = false,
    this.isHighlighted = false,
    this.highlightColor,
    this.tag,
    this.keepTogether = false,
    this.keepWithNext = false,
    this.pageBreakBefore = false,
    this.indent = 0,
  });

  /// Creates a header row.
  factory GeniusPdfGridRow.header(
    Map<String, dynamic> cells, {
    GeniusPdfCellStyle? style,
    double? height,
  }) {
    return GeniusPdfGridRow(
      cells: cells,
      isHeader: true,
      style: style,
      height: height,
    );
  }

  /// Creates a total/summary row.
  factory GeniusPdfGridRow.total(
    Map<String, dynamic> cells, {
    GeniusPdfCellStyle? style,
    String? label,
    String? labelColumnId,
  }) {
    final effectiveCells = Map<String, dynamic>.from(cells);
    if (label != null && labelColumnId != null) {
      effectiveCells[labelColumnId] = label;
    }
    return GeniusPdfGridRow(
      cells: effectiveCells,
      isTotal: true,
      style: style ?? const GeniusPdfCellStyle.total(),
    );
  }

  /// Creates a subtotal row (lighter styling than total).
  factory GeniusPdfGridRow.subtotal(
    Map<String, dynamic> cells, {
    GeniusPdfCellStyle? style,
    String? label,
    String? labelColumnId,
  }) {
    final effectiveCells = Map<String, dynamic>.from(cells);
    if (label != null && labelColumnId != null) {
      effectiveCells[labelColumnId] = label;
    }
    return GeniusPdfGridRow(
      cells: effectiveCells,
      isSubtotal: true,
      style: style ??
          const GeniusPdfCellStyle(
            textStyle: GeniusPdfTextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 9,
            ),
            backgroundColor: Color(0xFFF5F5F5),
            padding: GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
          ),
    );
  }

  /// Creates a group header row.
  factory GeniusPdfGridRow.groupHeader(
    String text, {
    String? textAr,
    int level = 0,
    GeniusPdfCellStyle? style,
    Color? backgroundColor,
    bool keepWithNext = true,
  }) {
    return GeniusPdfGridRow(
      cells: {'_group': text, '_groupAr': textAr},
      isGroupHeader: true,
      groupLevel: level,
      style: style,
      backgroundColor: backgroundColor,
      keepWithNext: keepWithNext,
    );
  }

  /// Creates a separator/divider row.
  factory GeniusPdfGridRow.separator({
    double height = 8,
    Color? backgroundColor,
  }) {
    return GeniusPdfGridRow(
      cells: const {},
      height: height,
      backgroundColor: backgroundColor ?? const Color(0xFFEEEEEE),
    );
  }

  /// Creates a blank/spacer row.
  factory GeniusPdfGridRow.spacer([double height = 12]) {
    return GeniusPdfGridRow(
      cells: const {},
      height: height,
    );
  }

  /// Cell values mapped by column ID.
  final Map<String, dynamic> cells;

  /// Custom style for this row.
  final GeniusPdfCellStyle? style;

  /// Whether this is a header row.
  final bool isHeader;

  /// Whether this is a total/summary row.
  final bool isTotal;

  /// Whether this is a subtotal row.
  final bool isSubtotal;

  /// Whether this is a group header row.
  final bool isGroupHeader;

  /// Nesting level for grouped data.
  final int groupLevel;

  /// Column span for merged cells (column ID to span count).
  final Map<String, int>? span;

  /// Fixed height for this row.
  final double? height;

  /// Minimum height constraint.
  final double? minHeight;

  /// Maximum height constraint.
  final double? maxHeight;

  /// Background color override.
  final Color? backgroundColor;

  /// Whether this row is selected.
  final bool isSelected;

  /// Whether this row is highlighted.
  final bool isHighlighted;

  /// Highlight color when isHighlighted is true.
  final Color? highlightColor;

  /// Custom tag for identification.
  final String? tag;

  /// Whether to keep all row content on same page.
  final bool keepTogether;

  /// Whether to keep this row with the next row on same page.
  final bool keepWithNext;

  /// Whether to insert a page break before this row.
  final bool pageBreakBefore;

  /// Indent level for nested content (in points).
  final double indent;

  /// Whether this is a special row (header, total, group header, etc.).
  bool get isSpecialRow => isHeader || isTotal || isSubtotal || isGroupHeader;

  /// Whether this is a summary row (total or subtotal).
  bool get isSummaryRow => isTotal || isSubtotal;

  /// Gets the value for a specific column.
  dynamic getValue(String columnId) => cells[columnId];

  /// Gets the formatted value for a column.
  String getFormattedValue(GeniusPdfGridColumn column) {
    final value = cells[column.id];
    if (value == null) return '';
    if (column.valueFormatter != null) {
      return column.valueFormatter!(value);
    }
    return value.toString();
  }

  /// Gets the group header text based on locale.
  String? getGroupHeaderText({bool isArabic = false}) {
    if (!isGroupHeader) return null;
    if (isArabic && cells['_groupAr'] != null) {
      return cells['_groupAr'].toString();
    }
    return cells['_group']?.toString();
  }

  /// Gets the effective background color.
  Color? getEffectiveBackgroundColor({
    bool isAlternate = false,
    Color? alternateColor,
  }) {
    if (isHighlighted && highlightColor != null) return highlightColor;
    if (backgroundColor != null) return backgroundColor;
    if (style?.backgroundColor != null) return style!.backgroundColor;
    if (isAlternate && alternateColor != null) return alternateColor;
    return null;
  }

  /// Creates a copy with modified values.
  GeniusPdfGridRow copyWith({
    Map<String, dynamic>? cells,
    GeniusPdfCellStyle? style,
    bool? isHeader,
    bool? isTotal,
    bool? isSubtotal,
    bool? isGroupHeader,
    int? groupLevel,
    Map<String, int>? span,
    double? height,
    double? minHeight,
    double? maxHeight,
    Color? backgroundColor,
    bool? isSelected,
    bool? isHighlighted,
    Color? highlightColor,
    String? tag,
    bool? keepTogether,
    bool? keepWithNext,
    bool? pageBreakBefore,
    double? indent,
  }) {
    return GeniusPdfGridRow(
      cells: cells ?? this.cells,
      style: style ?? this.style,
      isHeader: isHeader ?? this.isHeader,
      isTotal: isTotal ?? this.isTotal,
      isSubtotal: isSubtotal ?? this.isSubtotal,
      isGroupHeader: isGroupHeader ?? this.isGroupHeader,
      groupLevel: groupLevel ?? this.groupLevel,
      span: span ?? this.span,
      height: height ?? this.height,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      isSelected: isSelected ?? this.isSelected,
      isHighlighted: isHighlighted ?? this.isHighlighted,
      highlightColor: highlightColor ?? this.highlightColor,
      tag: tag ?? this.tag,
      keepTogether: keepTogether ?? this.keepTogether,
      keepWithNext: keepWithNext ?? this.keepWithNext,
      pageBreakBefore: pageBreakBefore ?? this.pageBreakBefore,
      indent: indent ?? this.indent,
    );
  }
}

/// Configuration for grid appearance.
///
/// Enhanced grid style with comprehensive theming options for:
/// - Header, cell, and row styling
/// - Border configuration
/// - Spacing and layout
/// - Responsive width management
/// - Print-specific options
///
/// ## Example
/// ```dart
/// GeniusPdfGridStyle.corporate(
///   primaryColor: Color(0xFF1565C0),
///   accentColor: Color(0xFF0D47A1),
/// )
/// ```
class GeniusPdfGridStyle {
  const GeniusPdfGridStyle({
    this.headerStyle = const GeniusPdfCellStyle.header(),
    this.cellStyle = const GeniusPdfCellStyle(),
    this.alternateRowStyle,
    this.totalRowStyle = const GeniusPdfCellStyle.total(),
    this.subtotalRowStyle,
    this.groupHeaderStyle,
    this.selectedRowStyle,
    this.highlightedRowStyle,
    this.borderStyle = const GeniusPdfBorderStyle.all(),
    this.outerBorderStyle,
    this.showHeader = true,
    this.repeatHeaderOnPages = true,
    this.alternateRowColors = true,
    this.alternateStartIndex = 1,
    this.cellSpacing = 0,
    this.rowSpacing = 0,
    this.defaultColumnWidth = 100,
    this.minColumnWidth = 30,
    this.maxColumnWidth = 300,
    this.rowHeight,
    this.minRowHeight = 16,
    this.maxRowHeight,
    this.headerHeight,
    this.groupHeaderHeight,
    this.horizontalPadding = 0,
    this.verticalPadding = 0,
    this.groupIndentPerLevel = 12,
    this.showGridLines = true,
    this.gridLineColor,
    this.gridLineWidth = 0.5,
    this.showVerticalLines = true,
    this.showHorizontalLines = true,
    this.roundedCorners = false,
    this.cornerRadius = 4,
    this.shadowEnabled = false,
    this.shadowColor,
    this.shadowOffset = 2,
    this.shadowBlur = 4,
    this.clipContent = true,
    this.fitToPage = false,
    this.breakRowsAcrossPages = true,
  });

  /// Creates a modern/minimal grid style.
  const GeniusPdfGridStyle.modern()
      : headerStyle = const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
          backgroundColor: Color(0xFFE3F2FD),
          border:
              GeniusPdfBorderStyle.bottom(width: 2, color: Color(0xFF1565C0)),
          padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
        ),
        cellStyle = const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle.body(),
          border: GeniusPdfBorderStyle.bottom(color: Color(0xFFE0E0E0)),
          padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
        ),
        alternateRowStyle = const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle.body(),
          backgroundColor: Color(0xFFFAFAFA),
          border: GeniusPdfBorderStyle.bottom(color: Color(0xFFE0E0E0)),
          padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
        ),
        totalRowStyle = const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
          backgroundColor: Color(0xFFE8E8E8),
          border: GeniusPdfBorderStyle.all(width: 1),
          padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
        ),
        subtotalRowStyle = const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
          backgroundColor: Color(0xFFF5F5F5),
          padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
        ),
        groupHeaderStyle = const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1565C0),
          ),
          backgroundColor: Color(0xFFE3F2FD),
          padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
        ),
        selectedRowStyle = null,
        highlightedRowStyle = null,
        borderStyle = const GeniusPdfBorderStyle.none(),
        outerBorderStyle = null,
        showHeader = true,
        repeatHeaderOnPages = true,
        alternateRowColors = true,
        alternateStartIndex = 1,
        cellSpacing = 0,
        rowSpacing = 0,
        defaultColumnWidth = 100,
        minColumnWidth = 30,
        maxColumnWidth = 300,
        rowHeight = null,
        minRowHeight = 20,
        maxRowHeight = null,
        headerHeight = null,
        groupHeaderHeight = null,
        horizontalPadding = 0,
        verticalPadding = 0,
        groupIndentPerLevel = 12,
        showGridLines = false,
        gridLineColor = null,
        gridLineWidth = 0.5,
        showVerticalLines = false,
        showHorizontalLines = true,
        roundedCorners = false,
        cornerRadius = 4,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        shadowBlur = 4,
        clipContent = true,
        fitToPage = false,
        breakRowsAcrossPages = true;

  /// Creates a classic bordered grid style.
  const GeniusPdfGridStyle.classic()
      : headerStyle = const GeniusPdfCellStyle.header(),
        cellStyle = const GeniusPdfCellStyle(),
        alternateRowStyle = const GeniusPdfCellStyle.alternateEven(),
        totalRowStyle = const GeniusPdfCellStyle.total(),
        subtotalRowStyle = null,
        groupHeaderStyle = null,
        selectedRowStyle = null,
        highlightedRowStyle = null,
        borderStyle = const GeniusPdfBorderStyle.all(),
        outerBorderStyle = null,
        showHeader = true,
        repeatHeaderOnPages = true,
        alternateRowColors = true,
        alternateStartIndex = 1,
        cellSpacing = 0,
        rowSpacing = 0,
        defaultColumnWidth = 100,
        minColumnWidth = 30,
        maxColumnWidth = 300,
        rowHeight = null,
        minRowHeight = 16,
        maxRowHeight = null,
        headerHeight = null,
        groupHeaderHeight = null,
        horizontalPadding = 0,
        verticalPadding = 0,
        groupIndentPerLevel = 12,
        showGridLines = true,
        gridLineColor = null,
        gridLineWidth = 0.5,
        showVerticalLines = true,
        showHorizontalLines = true,
        roundedCorners = false,
        cornerRadius = 4,
        shadowEnabled = false,
        shadowColor = null,
        shadowOffset = 2,
        shadowBlur = 4,
        clipContent = true,
        fitToPage = false,
        breakRowsAcrossPages = true;

  /// Creates a corporate/professional grid style.
  factory GeniusPdfGridStyle.corporate({
    Color primaryColor = const Color(0xFF1565C0),
    Color headerBackground = const Color(0xFF1565C0),
    Color headerTextColor = const Color(0xFFFFFFFF),
    Color alternateRowColor = const Color(0xFFF5F5F5),
    Color totalRowColor = const Color(0xFFE0E0E0),
    double borderWidth = 1.0,
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: headerTextColor,
        ),
        backgroundColor: headerBackground,
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      cellStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle.body(),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      alternateRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle.body(),
        backgroundColor: alternateRowColor,
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: totalRowColor,
        border: GeniusPdfBorderStyle.all(width: borderWidth),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      subtotalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: totalRowColor.withValues(alpha: 0.5),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 4),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primaryColor,
        ),
        backgroundColor: alternateRowColor,
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle: GeniusPdfBorderStyle.all(width: borderWidth),
      showGridLines: true,
      gridLineColor: const Color(0xFFE0E0E0),
      gridLineWidth: 0.5,
    );
  }

  /// Creates a minimal/clean grid style.
  factory GeniusPdfGridStyle.minimal({
    Color accentColor = const Color(0xFF424242),
    double headerBorderWidth = 2.0,
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: accentColor,
        ),
        border: GeniusPdfBorderStyle.bottom(
          width: headerBorderWidth,
          color: accentColor,
        ),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 5),
      ),
      cellStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(fontSize: 9),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
      ),
      alternateRowStyle: null,
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
        ),
        border: GeniusPdfBorderStyle.top(
          width: headerBorderWidth,
          color: accentColor,
        ),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 5),
      ),
      borderStyle: const GeniusPdfBorderStyle.none(),
      alternateRowColors: false,
      showGridLines: false,
      showVerticalLines: false,
      showHorizontalLines: false,
    );
  }

  /// Creates a Saudi-themed grid style with green colors.
  factory GeniusPdfGridStyle.saudi({
    Color primaryColor = const Color(0xFF006C35),
    Color accentColor = const Color(0xFF004D25),
  }) {
    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Color(0xFFFFFFFF),
        ),
        backgroundColor: primaryColor,
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      cellStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle.body(),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      alternateRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle.body(),
        backgroundColor: primaryColor.withValues(alpha: 0.05),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 5),
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: const GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.15),
        border: GeniusPdfBorderStyle.all(width: 1, color: primaryColor),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: accentColor,
        ),
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        padding:
            const GeniusPdfCellPadding.symmetric(horizontal: 8, vertical: 6),
      ),
      borderStyle: GeniusPdfBorderStyle.all(color: primaryColor),
      showGridLines: true,
      gridLineColor: primaryColor.withValues(alpha: 0.3),
    );
  }

  /// Creates an invoice/financial grid style.
  factory GeniusPdfGridStyle.invoice({
    bool showAlternateRows = true,
  }) {
    return GeniusPdfGridStyle(
      headerStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Color(0xFF333333),
        ),
        backgroundColor: Color(0xFFF0F0F0),
        border: GeniusPdfBorderStyle.all(color: Color(0xFFCCCCCC)),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 5),
      ),
      cellStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(fontSize: 9),
        border: GeniusPdfBorderStyle.horizontal(color: Color(0xFFE0E0E0)),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
      ),
      alternateRowStyle: showAlternateRows
          ? const GeniusPdfCellStyle(
              textStyle: GeniusPdfTextStyle(fontSize: 9),
              backgroundColor: Color(0xFFFAFAFA),
              border: GeniusPdfBorderStyle.horizontal(color: Color(0xFFE0E0E0)),
              padding:
                  GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
            )
          : null,
      totalRowStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Color(0xFFE8E8E8),
        border: GeniusPdfBorderStyle.all(color: Color(0xFFCCCCCC)),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 6),
      ),
      subtotalRowStyle: const GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
        backgroundColor: Color(0xFFF5F5F5),
        border: GeniusPdfBorderStyle.top(color: Color(0xFFCCCCCC)),
        padding: GeniusPdfCellPadding.symmetric(horizontal: 6, vertical: 4),
      ),
      borderStyle: const GeniusPdfBorderStyle.all(color: Color(0xFFCCCCCC)),
      outerBorderStyle:
          const GeniusPdfBorderStyle.all(width: 1.5, color: Color(0xFF999999)),
      alternateRowColors: showAlternateRows,
      showGridLines: true,
      gridLineColor: const Color(0xFFE0E0E0),
    );
  }

  /// Style for header cells.
  final GeniusPdfCellStyle headerStyle;

  /// Default style for data cells.
  final GeniusPdfCellStyle cellStyle;

  /// Style for alternate rows (null to disable).
  final GeniusPdfCellStyle? alternateRowStyle;

  /// Style for total/summary rows.
  final GeniusPdfCellStyle totalRowStyle;

  /// Style for subtotal rows.
  final GeniusPdfCellStyle? subtotalRowStyle;

  /// Style for group header rows.
  final GeniusPdfCellStyle? groupHeaderStyle;

  /// Style for selected rows.
  final GeniusPdfCellStyle? selectedRowStyle;

  /// Style for highlighted rows.
  final GeniusPdfCellStyle? highlightedRowStyle;

  /// Border style for cells.
  final GeniusPdfBorderStyle borderStyle;

  /// Outer border style for the entire grid.
  final GeniusPdfBorderStyle? outerBorderStyle;

  /// Whether to show header row.
  final bool showHeader;

  /// Whether to repeat header on each page.
  final bool repeatHeaderOnPages;

  /// Whether to use alternate row colors.
  final bool alternateRowColors;

  /// Starting index for alternate row colors (0 or 1).
  final int alternateStartIndex;

  /// Horizontal spacing between cells.
  final double cellSpacing;

  /// Vertical spacing between rows.
  final double rowSpacing;

  /// Default width for columns without explicit width.
  final double defaultColumnWidth;

  /// Minimum allowed column width.
  final double minColumnWidth;

  /// Maximum allowed column width.
  final double maxColumnWidth;

  /// Fixed height for all data rows (null for auto).
  final double? rowHeight;

  /// Minimum row height.
  final double minRowHeight;

  /// Maximum row height.
  final double? maxRowHeight;

  /// Height for header row (null for auto).
  final double? headerHeight;

  /// Height for group header rows (null for auto).
  final double? groupHeaderHeight;

  /// Horizontal padding around the grid.
  final double horizontalPadding;

  /// Vertical padding around the grid.
  final double verticalPadding;

  /// Indent increment per group level.
  final double groupIndentPerLevel;

  /// Whether to show grid lines.
  final bool showGridLines;

  /// Color for grid lines (null uses borderStyle color).
  final Color? gridLineColor;

  /// Width of grid lines.
  final double gridLineWidth;

  /// Whether to show vertical grid lines.
  final bool showVerticalLines;

  /// Whether to show horizontal grid lines.
  final bool showHorizontalLines;

  /// Whether to use rounded corners.
  final bool roundedCorners;

  /// Corner radius when roundedCorners is true.
  final double cornerRadius;

  /// Whether to enable shadow.
  final bool shadowEnabled;

  /// Shadow color.
  final Color? shadowColor;

  /// Shadow offset.
  final double shadowOffset;

  /// Shadow blur radius.
  final double shadowBlur;

  /// Whether to clip content that exceeds cell bounds.
  final bool clipContent;

  /// Whether to fit grid width to page.
  final bool fitToPage;

  /// Whether rows can break across pages.
  final bool breakRowsAcrossPages;

  /// Gets the effective style for a row based on its type and index.
  GeniusPdfCellStyle getRowStyle(GeniusPdfGridRow row, int index) {
    if (row.isHeader) return headerStyle;
    if (row.isTotal) return totalRowStyle;
    if (row.isSubtotal) return subtotalRowStyle ?? totalRowStyle;
    if (row.isGroupHeader) return groupHeaderStyle ?? headerStyle;
    if (row.isSelected && selectedRowStyle != null) return selectedRowStyle!;
    if (row.isHighlighted && highlightedRowStyle != null) {
      return highlightedRowStyle!;
    }
    if (row.style != null) return row.style!;
    if (alternateRowColors && alternateRowStyle != null) {
      if ((index + alternateStartIndex) % 2 == 0) {
        return alternateRowStyle!;
      }
    }
    return cellStyle;
  }

  GeniusPdfGridStyle copyWith({
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? cellStyle,
    GeniusPdfCellStyle? alternateRowStyle,
    GeniusPdfCellStyle? totalRowStyle,
    GeniusPdfCellStyle? subtotalRowStyle,
    GeniusPdfCellStyle? groupHeaderStyle,
    GeniusPdfCellStyle? selectedRowStyle,
    GeniusPdfCellStyle? highlightedRowStyle,
    GeniusPdfBorderStyle? borderStyle,
    GeniusPdfBorderStyle? outerBorderStyle,
    bool? showHeader,
    bool? repeatHeaderOnPages,
    bool? alternateRowColors,
    int? alternateStartIndex,
    double? cellSpacing,
    double? rowSpacing,
    double? defaultColumnWidth,
    double? minColumnWidth,
    double? maxColumnWidth,
    double? rowHeight,
    double? minRowHeight,
    double? maxRowHeight,
    double? headerHeight,
    double? groupHeaderHeight,
    double? horizontalPadding,
    double? verticalPadding,
    double? groupIndentPerLevel,
    bool? showGridLines,
    Color? gridLineColor,
    double? gridLineWidth,
    bool? showVerticalLines,
    bool? showHorizontalLines,
    bool? roundedCorners,
    double? cornerRadius,
    bool? shadowEnabled,
    Color? shadowColor,
    double? shadowOffset,
    double? shadowBlur,
    bool? clipContent,
    bool? fitToPage,
    bool? breakRowsAcrossPages,
  }) {
    return GeniusPdfGridStyle(
      headerStyle: headerStyle ?? this.headerStyle,
      cellStyle: cellStyle ?? this.cellStyle,
      alternateRowStyle: alternateRowStyle ?? this.alternateRowStyle,
      totalRowStyle: totalRowStyle ?? this.totalRowStyle,
      subtotalRowStyle: subtotalRowStyle ?? this.subtotalRowStyle,
      groupHeaderStyle: groupHeaderStyle ?? this.groupHeaderStyle,
      selectedRowStyle: selectedRowStyle ?? this.selectedRowStyle,
      highlightedRowStyle: highlightedRowStyle ?? this.highlightedRowStyle,
      borderStyle: borderStyle ?? this.borderStyle,
      outerBorderStyle: outerBorderStyle ?? this.outerBorderStyle,
      showHeader: showHeader ?? this.showHeader,
      repeatHeaderOnPages: repeatHeaderOnPages ?? this.repeatHeaderOnPages,
      alternateRowColors: alternateRowColors ?? this.alternateRowColors,
      alternateStartIndex: alternateStartIndex ?? this.alternateStartIndex,
      cellSpacing: cellSpacing ?? this.cellSpacing,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      defaultColumnWidth: defaultColumnWidth ?? this.defaultColumnWidth,
      minColumnWidth: minColumnWidth ?? this.minColumnWidth,
      maxColumnWidth: maxColumnWidth ?? this.maxColumnWidth,
      rowHeight: rowHeight ?? this.rowHeight,
      minRowHeight: minRowHeight ?? this.minRowHeight,
      maxRowHeight: maxRowHeight ?? this.maxRowHeight,
      headerHeight: headerHeight ?? this.headerHeight,
      groupHeaderHeight: groupHeaderHeight ?? this.groupHeaderHeight,
      horizontalPadding: horizontalPadding ?? this.horizontalPadding,
      verticalPadding: verticalPadding ?? this.verticalPadding,
      groupIndentPerLevel: groupIndentPerLevel ?? this.groupIndentPerLevel,
      showGridLines: showGridLines ?? this.showGridLines,
      gridLineColor: gridLineColor ?? this.gridLineColor,
      gridLineWidth: gridLineWidth ?? this.gridLineWidth,
      showVerticalLines: showVerticalLines ?? this.showVerticalLines,
      showHorizontalLines: showHorizontalLines ?? this.showHorizontalLines,
      roundedCorners: roundedCorners ?? this.roundedCorners,
      cornerRadius: cornerRadius ?? this.cornerRadius,
      shadowEnabled: shadowEnabled ?? this.shadowEnabled,
      shadowColor: shadowColor ?? this.shadowColor,
      shadowOffset: shadowOffset ?? this.shadowOffset,
      shadowBlur: shadowBlur ?? this.shadowBlur,
      clipContent: clipContent ?? this.clipContent,
      fitToPage: fitToPage ?? this.fitToPage,
      breakRowsAcrossPages: breakRowsAcrossPages ?? this.breakRowsAcrossPages,
    );
  }
}

/// Represents a group of rows with optional header and summary.
///
/// Enhanced group with support for:
/// - Bilingual titles
/// - Nested subgroups
/// - Multiple summary rows
/// - Custom styling
/// - Collapsible state
/// - Aggregate calculations
///
/// ## Example
/// ```dart
/// GeniusPdfGridGroup(
///   title: 'Q1 Sales',
///   titleAr: 'مبيعات الربع الأول',
///   rows: salesRows,
///   summary: GeniusPdfGridRow.total({'total': 15000}),
/// )
/// ```
class GeniusPdfGridGroup {
  const GeniusPdfGridGroup({
    required this.title,
    required this.rows,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.summary,
    this.summaries,
    this.style,
    this.headerStyle,
    this.summaryStyle,
    this.level = 0,
    this.collapsed = false,
    this.showHeader = true,
    this.showSummary = true,
    this.headerSpan = true,
    this.summaryLabel,
    this.summaryLabelAr,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.indent,
    this.keepTogether = false,
    this.pageBreakBefore = false,
    this.pageBreakAfter = false,
    this.subgroups,
    this.tag,
    this.metadata,
  });

  /// Creates a simple group with just title and rows.
  factory GeniusPdfGridGroup.simple({
    required String title,
    required List<GeniusPdfGridRow> rows,
    String? titleAr,
  }) {
    return GeniusPdfGridGroup(
      title: title,
      titleAr: titleAr,
      rows: rows,
    );
  }

  /// Creates a group with auto-calculated summary.
  factory GeniusPdfGridGroup.withSummary({
    required String title,
    required List<GeniusPdfGridRow> rows,
    required List<String> sumColumns,
    String? titleAr,
    String summaryLabel = 'Subtotal',
    String? summaryLabelAr,
    String? labelColumnId,
  }) {
    final summaryValues = <String, dynamic>{};
    if (labelColumnId != null) {
      summaryValues[labelColumnId] = summaryLabel;
    }
    for (final columnId in sumColumns) {
      double total = 0;
      for (final row in rows) {
        final value = row.cells[columnId];
        if (value is num) {
          total += value;
        } else if (value is String) {
          final parsed = double.tryParse(value);
          if (parsed != null) total += parsed;
        }
      }
      summaryValues[columnId] = total;
    }
    return GeniusPdfGridGroup(
      title: title,
      titleAr: titleAr,
      rows: rows,
      summaryLabel: summaryLabel,
      summaryLabelAr: summaryLabelAr,
      summary: GeniusPdfGridRow.subtotal(summaryValues),
    );
  }

  /// Creates a hierarchical group with subgroups.
  factory GeniusPdfGridGroup.hierarchical({
    required String title,
    required List<GeniusPdfGridGroup> subgroups,
    String? titleAr,
    GeniusPdfGridRow? summary,
    int level = 0,
  }) {
    // Flatten rows from subgroups
    final allRows = <GeniusPdfGridRow>[];
    for (final subgroup in subgroups) {
      allRows.addAll(subgroup.rows);
    }
    return GeniusPdfGridGroup(
      title: title,
      titleAr: titleAr,
      rows: allRows,
      subgroups: subgroups,
      summary: summary,
      level: level,
    );
  }

  /// Group title (English or default).
  final String title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Subtitle under the main title.
  final String? subtitle;

  /// Arabic subtitle.
  final String? subtitleAr;

  /// Rows in this group.
  final List<GeniusPdfGridRow> rows;

  /// Primary summary row for this group.
  final GeniusPdfGridRow? summary;

  /// Multiple summary rows (for complex summaries).
  final List<GeniusPdfGridRow>? summaries;

  /// Custom style for group row backgrounds.
  final GeniusPdfCellStyle? style;

  /// Custom style for group header.
  final GeniusPdfCellStyle? headerStyle;

  /// Custom style for summary rows.
  final GeniusPdfCellStyle? summaryStyle;

  /// Nesting level for hierarchical groups.
  final int level;

  /// Whether the group is collapsed (for display only).
  final bool collapsed;

  /// Whether to show the group header.
  final bool showHeader;

  /// Whether to show the summary row.
  final bool showSummary;

  /// Whether header spans all columns.
  final bool headerSpan;

  /// Label for the summary row.
  final String? summaryLabel;

  /// Arabic label for the summary row.
  final String? summaryLabelAr;

  /// Icon identifier for group header.
  final String? icon;

  /// Icon color.
  final Color? iconColor;

  /// Background color for the group section.
  final Color? backgroundColor;

  /// Custom indent (overrides calculated indent based on level).
  final double? indent;

  /// Whether to keep the group together on one page.
  final bool keepTogether;

  /// Whether to insert a page break before this group.
  final bool pageBreakBefore;

  /// Whether to insert a page break after this group.
  final bool pageBreakAfter;

  /// Nested subgroups.
  final List<GeniusPdfGridGroup>? subgroups;

  /// Custom tag for identification.
  final String? tag;

  /// Additional metadata.
  final Map<String, dynamic>? metadata;

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

  /// Gets the summary label based on locale.
  String? getSummaryLabel({bool isArabic = false}) {
    if (isArabic && summaryLabelAr != null) return summaryLabelAr;
    return summaryLabel;
  }

  /// Gets the total number of rows including subgroups.
  int get totalRowCount {
    int count = rows.length;
    if (subgroups != null) {
      for (final subgroup in subgroups!) {
        count += subgroup.totalRowCount;
      }
    }
    return count;
  }

  /// Gets all rows including from subgroups in order.
  List<GeniusPdfGridRow> get allRows {
    if (subgroups == null || subgroups!.isEmpty) {
      return rows;
    }
    final result = <GeniusPdfGridRow>[];
    for (final subgroup in subgroups!) {
      result.addAll(subgroup.allRows);
    }
    return result;
  }

  /// Gets all summary rows (primary + additional).
  List<GeniusPdfGridRow> get allSummaries {
    final result = <GeniusPdfGridRow>[];
    if (summary != null) result.add(summary!);
    if (summaries != null) result.addAll(summaries!);
    return result;
  }

  /// Calculates sum for a specific column across all rows.
  double calculateSum(String columnId) {
    double total = 0;
    for (final row in allRows) {
      final value = row.cells[columnId];
      if (value is num) {
        total += value;
      } else if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) total += parsed;
      }
    }
    return total;
  }

  /// Calculates average for a specific column.
  double calculateAverage(String columnId) {
    final all = allRows;
    if (all.isEmpty) return 0;
    return calculateSum(columnId) / all.length;
  }

  /// Gets the effective indent based on level.
  double getEffectiveIndent(double indentPerLevel) {
    return indent ?? (level * indentPerLevel);
  }

  /// Creates a copy with modified values.
  GeniusPdfGridGroup copyWith({
    String? title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    List<GeniusPdfGridRow>? rows,
    GeniusPdfGridRow? summary,
    List<GeniusPdfGridRow>? summaries,
    GeniusPdfCellStyle? style,
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? summaryStyle,
    int? level,
    bool? collapsed,
    bool? showHeader,
    bool? showSummary,
    bool? headerSpan,
    String? summaryLabel,
    String? summaryLabelAr,
    String? icon,
    Color? iconColor,
    Color? backgroundColor,
    double? indent,
    bool? keepTogether,
    bool? pageBreakBefore,
    bool? pageBreakAfter,
    List<GeniusPdfGridGroup>? subgroups,
    String? tag,
    Map<String, dynamic>? metadata,
  }) {
    return GeniusPdfGridGroup(
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      subtitle: subtitle ?? this.subtitle,
      subtitleAr: subtitleAr ?? this.subtitleAr,
      rows: rows ?? this.rows,
      summary: summary ?? this.summary,
      summaries: summaries ?? this.summaries,
      style: style ?? this.style,
      headerStyle: headerStyle ?? this.headerStyle,
      summaryStyle: summaryStyle ?? this.summaryStyle,
      level: level ?? this.level,
      collapsed: collapsed ?? this.collapsed,
      showHeader: showHeader ?? this.showHeader,
      showSummary: showSummary ?? this.showSummary,
      headerSpan: headerSpan ?? this.headerSpan,
      summaryLabel: summaryLabel ?? this.summaryLabel,
      summaryLabelAr: summaryLabelAr ?? this.summaryLabelAr,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      indent: indent ?? this.indent,
      keepTogether: keepTogether ?? this.keepTogether,
      pageBreakBefore: pageBreakBefore ?? this.pageBreakBefore,
      pageBreakAfter: pageBreakAfter ?? this.pageBreakAfter,
      subgroups: subgroups ?? this.subgroups,
      tag: tag ?? this.tag,
      metadata: metadata ?? this.metadata,
    );
  }
}
