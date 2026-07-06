part of '../grid_models.dart';

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
