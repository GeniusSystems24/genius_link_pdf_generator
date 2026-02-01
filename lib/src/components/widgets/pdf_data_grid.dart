import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../extensions/color_extensions.dart';
import '../../core/pdf_config.dart';
import '../../core/pdf_print_theme.dart';
import '../models/grid_models.dart';
import '../models/pdf_styles.dart';
import '../../core/pdf_logger.dart';

/// A powerful data grid component for PDF documents.
///
/// [GeniusPdfDataGrid] provides a flexible way to create tables in PDF documents
/// with support for:
/// - Custom column definitions with various alignments
/// - Header rows with RTL/LTR support
/// - Alternating row colors
/// - Group headers and totals
/// - Automatic pagination
/// - Currency and number formatting
///
/// ## Example
/// ```dart
/// final grid = PdfDataGrid(
///   columns: [
///     PdfGridColumn(id: 'name', title: 'Name', titleAr: 'الاسم'),
///     PdfGridColumn.currency(id: 'amount', title: 'Amount', titleAr: 'المبلغ'),
///   ],
///   rows: [
///     PdfGridRow(cells: {'name': 'Item 1', 'amount': 100.00}),
///     PdfGridRow(cells: {'name': 'Item 2', 'amount': 200.00}),
///     PdfGridRow.total({'name': 'Total', 'amount': 300.00}),
///   ],
/// );
///
/// // Draw in document
/// grid.draw(page: currentPage, bounds: Rect.fromLTWH(0, y, width, height));
/// ```
class GeniusPdfDataGrid {
  GeniusPdfDataGrid({
    required this.columns,
    required this.rows,
    required this.config,
    GeniusPdfGridStyle? style,
    this.groups,
  }) : style = _resolveGridStyle(style, config);

  /// Column definitions.
  final List<GeniusPdfGridColumn> columns;

  /// Data rows.
  final List<GeniusPdfGridRow> rows;

  /// Grid styling configuration.
  final GeniusPdfGridStyle style;

  /// PDF configuration.
  final GeniusPdfConfig config;

  /// Optional grouped data.
  final List<GeniusPdfGridGroup>? groups;

  static GeniusPdfGridStyle _resolveGridStyle(
    GeniusPdfGridStyle? style,
    GeniusPdfConfig config,
  ) {
    if (style != null) return style;
    return _gridStyleFromTheme(config.printTheme);
  }

  static GeniusPdfGridStyle _gridStyleFromTheme(GeniusPdfPrintTheme theme) {
    final gridTheme = theme.gridTheme ?? const GeniusPdfGridTheme.defaults();
    final typography = theme.typography;

    return GeniusPdfGridStyle(
      headerStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: typography.headingSize,
          fontWeight: material.FontWeight.bold,
          color: gridTheme.headerTextColor,
          alignment: GeniusPdfTextAlign.center,
        ),
        backgroundColor: gridTheme.headerBackgroundColor,
        border: GeniusPdfBorderStyle.all(
          width: gridTheme.headerBorderWidth,
          color: gridTheme.borderColor,
        ),
        padding: gridTheme.headerPadding,
      ),
      cellStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: typography.bodySize,
          color: theme.colorScheme.onSurface,
        ),
        border: GeniusPdfBorderStyle.all(
          width: gridTheme.cellBorderWidth,
          color: gridTheme.borderColor,
        ),
        padding: gridTheme.cellPadding,
      ),
      alternateRowStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: typography.bodySize,
          color: theme.colorScheme.onSurface,
        ),
        backgroundColor: gridTheme.alternateRowColor,
        padding: gridTheme.cellPadding,
      ),
      totalRowStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: typography.bodySize,
          fontWeight: material.FontWeight.bold,
          color: gridTheme.totalRowTextColor,
        ),
        backgroundColor: gridTheme.totalRowBackgroundColor,
        border: GeniusPdfBorderStyle.all(
          width: gridTheme.headerBorderWidth,
          color: gridTheme.borderColor,
        ),
        padding: gridTheme.cellPadding,
      ),
      groupHeaderStyle: GeniusPdfCellStyle(
        textStyle: GeniusPdfTextStyle(
          fontSize: typography.bodySize,
          fontWeight: material.FontWeight.bold,
          color: gridTheme.groupHeaderTextColor,
        ),
        backgroundColor: gridTheme.groupHeaderBackgroundColor,
        padding: gridTheme.headerPadding,
      ),
      borderStyle: GeniusPdfBorderStyle.all(
        width: theme.borders.normalWidth,
        color: gridTheme.borderColor,
      ),
      showGridLines: gridTheme.showInnerBorder,
      showVerticalLines: gridTheme.showInnerBorder,
      showHorizontalLines: gridTheme.showInnerBorder,
    );
  }

  /// Gets visible columns only.
  List<GeniusPdfGridColumn> get visibleColumns =>
      columns.where((c) => c.isVisible).toList();

  /// Draws the grid on a PDF page.
  ///
  /// Returns the layout result for positioning subsequent content.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    GeniusPdfLogger.debug(
        'Drawing grid: ${columns.length} columns, ${rows.length} rows',
        tag: 'DataGrid');
    final grid = _buildGrid(page);

    return grid.draw(
      page: page,
      bounds: bounds,
      format: layoutFormat ??
          PdfLayoutFormat(
            layoutType: PdfLayoutType.paginate,
            breakType: PdfLayoutBreakType.fitPage,
          ),
    );
  }

  /// Draws the grid at a specific position on the page.
  PdfLayoutResult? drawAt({
    required PdfPage page,
    required double x,
    required double y,
    double? width,
    double? height,
    PdfLayoutFormat? layoutFormat,
  }) {
    final pageSize = page.getClientSize();
    return draw(
      page: page,
      bounds: Rect.fromLTWH(
        x,
        y,
        width ?? pageSize.width - x,
        height ?? pageSize.height - y,
      ),
      layoutFormat: layoutFormat,
    );
  }

  PdfGrid _buildGrid(PdfPage page) {
    final grid = PdfGrid();
    final cols = visibleColumns;

    // Calculate column widths
    final pageWidth = page.getClientSize().width;
    final columnWidths = _calculateColumnWidths(cols, pageWidth);

    // Add columns
    grid.columns.add(count: cols.length);
    for (int i = 0; i < cols.length; i++) {
      grid.columns[i].width = columnWidths[i];
    }

    // Add header row if enabled
    if (style.showHeader) {
      final headerRow = grid.headers.add(1)[0];
      _applyRowStyle(headerRow, style.headerStyle, isHeader: true);

      for (int i = 0; i < cols.length; i++) {
        final colIndex = config.isRTL ? cols.length - 1 - i : i;
        final column = cols[colIndex];
        final cell = headerRow.cells[i];

        cell.value = column.getTitle(isArabic: config.isRTL);
        _applyCellStyle(
          cell,
          column.headerStyle ?? style.headerStyle,
          column,
          isHeader: true,
        );
      }
    }

    // Handle grouped data
    if (groups != null && groups!.isNotEmpty) {
      _addGroupedRows(grid, cols);
    } else {
      // Add data rows
      _addDataRows(grid, cols, rows);
    }

    // Configure grid settings
    grid.style.cellSpacing = style.cellSpacing;
    if (style.repeatHeaderOnPages) {
      grid.repeatHeader = true;
    }

    return grid;
  }

  void _addGroupedRows(PdfGrid grid, List<GeniusPdfGridColumn> cols) {
    for (final group in groups!) {
      // Add group header
      final groupHeaderRow = grid.rows.add();
      groupHeaderRow.cells[0].value = group.getTitle(isArabic: config.isRTL);
      groupHeaderRow.cells[0].columnSpan = cols.length;

      final groupStyle = group.style ?? style.groupHeaderStyle;
      if (groupStyle != null) {
        _applyRowStyle(groupHeaderRow, groupStyle);
      } else {
        // Default group header style
        _applyRowStyle(
          groupHeaderRow,
          GeniusPdfCellStyle(
            textStyle: const GeniusPdfTextStyle(
              fontSize: 11,
              fontWeight: material.FontWeight.bold,
            ),
            backgroundColor: const Color(0xFFE0E0E0),
            border: const GeniusPdfBorderStyle.all(),
            padding: GeniusPdfCellPadding(
              left: 4 + (group.level * 10),
              right: 4,
              top: 4,
              bottom: 4,
            ),
          ),
        );
      }

      // Add group rows
      _addDataRows(grid, cols, group.rows);

      // Add group summary if present
      if (group.summary != null) {
        _addSingleRow(grid, cols, group.summary!, grid.rows.count);
      }
    }
  }

  void _addDataRows(
    PdfGrid grid,
    List<GeniusPdfGridColumn> cols,
    List<GeniusPdfGridRow> dataRows,
  ) {
    for (int rowIndex = 0; rowIndex < dataRows.length; rowIndex++) {
      final rowData = dataRows[rowIndex];
      _addSingleRow(grid, cols, rowData, rowIndex);
    }
  }

  void _addSingleRow(
    PdfGrid grid,
    List<GeniusPdfGridColumn> cols,
    GeniusPdfGridRow rowData,
    int rowIndex,
  ) {
    final row = grid.rows.add();

    // Determine row style
    GeniusPdfCellStyle rowStyle;
    if (rowData.isTotal) {
      rowStyle = rowData.style ?? style.totalRowStyle;
    } else if (rowData.isGroupHeader) {
      rowStyle = rowData.style ??
          style.groupHeaderStyle ??
          GeniusPdfCellStyle(
            textStyle: const GeniusPdfTextStyle(
              fontSize: 10,
              fontWeight: material.FontWeight.bold,
            ),
            backgroundColor: const Color(0xFFF5F5F5),
            padding: GeniusPdfCellPadding(
              left: 4 + (rowData.groupLevel * 10),
              right: 4,
              top: 4,
              bottom: 4,
            ),
          );
    } else if (style.alternateRowColors &&
        rowIndex % 2 == 1 &&
        style.alternateRowStyle != null) {
      rowStyle = rowData.style ?? style.alternateRowStyle!;
    } else {
      rowStyle = rowData.style ?? style.cellStyle;
    }

    _applyRowStyle(row, rowStyle);

    // Handle group header spanning
    if (rowData.isGroupHeader) {
      row.cells[0].value = rowData.cells['_group'] ?? '';
      row.cells[0].columnSpan = cols.length;
      _applyCellStyle(row.cells[0], rowStyle, cols[0]);
      return;
    }

    // Populate cells
    for (int i = 0; i < cols.length; i++) {
      final colIndex = config.isRTL ? cols.length - 1 - i : i;
      final column = cols[colIndex];
      final cell = row.cells[i];

      // Handle column spanning
      if (rowData.span != null && rowData.span!.containsKey(column.id)) {
        cell.columnSpan = rowData.span![column.id]!;
      }

      // Get formatted value
      cell.value = rowData.getFormattedValue(column);

      // Apply cell style
      final cellStyle = column.cellStyle ?? rowStyle;
      _applyCellStyle(cell, cellStyle, column, isTotal: rowData.isTotal);
    }
  }

  void _applyRowStyle(
    PdfGridRow row,
    GeniusPdfCellStyle style, {
    bool isHeader = false,
  }) {
    if (this.style.rowHeight != null && !isHeader) {
      row.height = this.style.rowHeight!;
    }
    if (isHeader && this.style.headerHeight != null) {
      row.height = this.style.headerHeight!;
    }
  }

  void _applyCellStyle(
    PdfGridCell cell,
    GeniusPdfCellStyle cellStyle,
    GeniusPdfGridColumn column, {
    bool isHeader = false,
    bool isTotal = false,
  }) {
    // Background color
    if (cellStyle.backgroundColor != null) {
      cell.style.backgroundBrush =
          PdfSolidBrush(cellStyle.backgroundColor!.toPdfColor());
    }

    // Border
    cell.style.borders = cellStyle.border.toPdfBorders();

    // Padding
    cell.style.cellPadding = cellStyle.padding.toPdfPaddings();

    // Font - baseFont and boldFont are required, no fallback to Helvetica
    PdfFont font;
    if (cellStyle.textStyle.isBold || isHeader || isTotal) {
      font = config.boldFont;
    } else {
      font = config.baseFont;
    }
    cell.style.font = font;

    // Text color
    cell.style.textBrush = cellStyle.textStyle.toBrush();

    // String format (alignment)
    final alignment = column.alignment;
    cell.style.stringFormat = PdfStringFormat(
      alignment: alignment.toPdfTextAlignment(config.isRTL),
      lineAlignment:
          cellStyle.textStyle.verticalAlignment.toPdfVerticalAlignment(),
      textDirection: config.isRTL
          ? PdfTextDirection.rightToLeft
          : PdfTextDirection.leftToRight,
    );
  }

  List<double> _calculateColumnWidths(
    List<GeniusPdfGridColumn> cols,
    double availableWidth,
  ) {
    final widths = <double>[];
    double usedWidth = 0;
    int flexCount = 0;
    int totalFlex = 0;

    // First pass: calculate fixed widths and count flex columns
    for (final col in (config.isRTL ? cols.reversed : cols)) {
      if (col.width != null) {
        widths.add(col.width!);
        usedWidth += col.width!;
      } else if (col.flexFactor != null) {
        widths.add(0); // Placeholder
        flexCount++;
        totalFlex += col.flexFactor!;
      } else {
        widths.add(0); // Will use default
        flexCount++;
        totalFlex++;
      }
    }

    // Second pass: distribute remaining width
    final remainingWidth = availableWidth - usedWidth;
    if (flexCount > 0 && remainingWidth > 0) {
      final flexUnit = remainingWidth / totalFlex;
      for (int i = 0; i < cols.length; i++) {
        if (widths[i] == 0) {
          final flex = cols[i].flexFactor ?? 1;
          var calculatedWidth = flexUnit * flex;

          // Apply min/max constraints
          if (cols[i].minWidth != null && calculatedWidth < cols[i].minWidth!) {
            calculatedWidth = cols[i].minWidth!;
          }
          if (cols[i].maxWidth != null && calculatedWidth > cols[i].maxWidth!) {
            calculatedWidth = cols[i].maxWidth!;
          }

          widths[i] = calculatedWidth;
        }
      }
    } else if (flexCount > 0) {
      // Use default width if no remaining space
      for (int i = 0; i < cols.length; i++) {
        if (widths[i] == 0) {
          widths[i] = style.defaultColumnWidth;
        }
      }
    }

    return widths;
  }
}

/// Extension methods for easily adding grids to document builders.
extension PdfDataGridExtensions on GeniusPdfDataGrid {
  /// Creates a simple two-column grid from a map.
  static GeniusPdfDataGrid fromMap({
    required Map<String, dynamic> data,
    String labelHeader = 'Label',
    String labelHeaderAr = 'البيان',
    String valueHeader = 'Value',
    String valueHeaderAr = 'القيمة',
    required GeniusPdfConfig config,
    GeniusPdfGridStyle? style,
  }) {
    return GeniusPdfDataGrid(
      config: config,
      columns: [
        GeniusPdfGridColumn(
          id: 'label',
          title: labelHeader,
          titleAr: labelHeaderAr,
          flexFactor: 2,
        ),
        GeniusPdfGridColumn(
          id: 'value',
          title: valueHeader,
          titleAr: valueHeaderAr,
          flexFactor: 1,
          alignment: GeniusPdfTextAlign.end,
        ),
      ],
      rows: data.entries
          .map((e) =>
              GeniusPdfGridRow(cells: {'label': e.key, 'value': e.value}))
          .toList(),
      style: style ?? const GeniusPdfGridStyle.classic(),
    );
  }

  /// Creates a ledger-style grid with debit/credit columns.
  static GeniusPdfDataGrid ledger({
    required List<Map<String, dynamic>> entries,
    required String dateColumn,
    required String descriptionColumn,
    required String debitColumn,
    required String creditColumn,
    required String balanceColumn,
    String dateHeader = 'Date',
    String dateHeaderAr = 'التاريخ',
    String descriptionHeader = 'Description',
    String descriptionHeaderAr = 'البيان',
    String debitHeader = 'Debit',
    String debitHeaderAr = 'مدين',
    String creditHeader = 'Credit',
    String creditHeaderAr = 'دائن',
    String balanceHeader = 'Balance',
    String balanceHeaderAr = 'الرصيد',
    required GeniusPdfConfig config,
    GeniusPdfGridStyle? style,
  }) {
    return GeniusPdfDataGrid(
      config: config,
      columns: [
        GeniusPdfGridColumn(
          id: dateColumn,
          title: dateHeader,
          titleAr: dateHeaderAr,
          width: 70,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn(
          id: descriptionColumn,
          title: descriptionHeader,
          titleAr: descriptionHeaderAr,
          flexFactor: 2,
        ),
        GeniusPdfGridColumn.currency(
          id: debitColumn,
          title: debitHeader,
          titleAr: debitHeaderAr,
          width: 80,
        ),
        GeniusPdfGridColumn.currency(
          id: creditColumn,
          title: creditHeader,
          titleAr: creditHeaderAr,
          width: 80,
        ),
        GeniusPdfGridColumn.currency(
          id: balanceColumn,
          title: balanceHeader,
          titleAr: balanceHeaderAr,
          width: 90,
        ),
      ],
      rows: entries
          .map((e) => GeniusPdfGridRow(cells: {
                dateColumn: e[dateColumn],
                descriptionColumn: e[descriptionColumn],
                debitColumn: e[debitColumn],
                creditColumn: e[creditColumn],
                balanceColumn: e[balanceColumn],
              }))
          .toList(),
      style: style ?? const GeniusPdfGridStyle.classic(),
    );
  }
}

// ============================================================================
// Conditional Formatting
// ============================================================================

/// Type of condition for conditional formatting.
enum GeniusConditionType {
  /// Value equals a specific value.
  equals,

  /// Value does not equal a specific value.
  notEquals,

  /// Value is greater than a specific value.
  greaterThan,

  /// Value is greater than or equal to a specific value.
  greaterThanOrEqual,

  /// Value is less than a specific value.
  lessThan,

  /// Value is less than or equal to a specific value.
  lessThanOrEqual,

  /// Value is between two values.
  between,

  /// Value contains a string.
  contains,

  /// Value starts with a string.
  startsWith,

  /// Value ends with a string.
  endsWith,

  /// Value is empty or null.
  isEmpty,

  /// Value is not empty.
  isNotEmpty,

  /// Custom condition using a function.
  custom,
}

/// A conditional formatting rule for grid cells.
class GeniusConditionalFormatRule {
  const GeniusConditionalFormatRule({
    required this.conditionType,
    this.value,
    this.value2,
    this.customCondition,
    this.backgroundColor,
    this.textColor,
    this.fontWeight,
    this.prefix,
    this.suffix,
    this.columnIds,
    this.priority = 0,
  });

  /// Creates a rule for positive values (green).
  factory GeniusConditionalFormatRule.positive({
    List<String>? columnIds,
    Color backgroundColor = const Color(0xFFE8F5E9),
    Color textColor = const Color(0xFF2E7D32),
  }) {
    return GeniusConditionalFormatRule(
      conditionType: GeniusConditionType.greaterThan,
      value: 0,
      backgroundColor: backgroundColor,
      textColor: textColor,
      columnIds: columnIds,
    );
  }

  /// Creates a rule for negative values (red).
  factory GeniusConditionalFormatRule.negative({
    List<String>? columnIds,
    Color backgroundColor = const Color(0xFFFFEBEE),
    Color textColor = const Color(0xFFC62828),
  }) {
    return GeniusConditionalFormatRule(
      conditionType: GeniusConditionType.lessThan,
      value: 0,
      backgroundColor: backgroundColor,
      textColor: textColor,
      columnIds: columnIds,
    );
  }

  /// Creates a rule for zero values.
  factory GeniusConditionalFormatRule.zero({
    List<String>? columnIds,
    Color backgroundColor = const Color(0xFFFFFDE7),
    Color textColor = const Color(0xFFF9A825),
  }) {
    return GeniusConditionalFormatRule(
      conditionType: GeniusConditionType.equals,
      value: 0,
      backgroundColor: backgroundColor,
      textColor: textColor,
      columnIds: columnIds,
    );
  }

  /// Creates a rule for values above a threshold.
  factory GeniusConditionalFormatRule.aboveThreshold({
    required num threshold,
    List<String>? columnIds,
    Color backgroundColor = const Color(0xFFE3F2FD),
    Color textColor = const Color(0xFF1565C0),
  }) {
    return GeniusConditionalFormatRule(
      conditionType: GeniusConditionType.greaterThanOrEqual,
      value: threshold,
      backgroundColor: backgroundColor,
      textColor: textColor,
      columnIds: columnIds,
    );
  }

  /// Creates a rule for values below a threshold.
  factory GeniusConditionalFormatRule.belowThreshold({
    required num threshold,
    List<String>? columnIds,
    Color backgroundColor = const Color(0xFFFCE4EC),
    Color textColor = const Color(0xFFC2185B),
  }) {
    return GeniusConditionalFormatRule(
      conditionType: GeniusConditionType.lessThan,
      value: threshold,
      backgroundColor: backgroundColor,
      textColor: textColor,
      columnIds: columnIds,
    );
  }

  /// Creates a rule for values between two thresholds.
  factory GeniusConditionalFormatRule.between({
    required num min,
    required num max,
    List<String>? columnIds,
    Color backgroundColor = const Color(0xFFF3E5F5),
    Color textColor = const Color(0xFF7B1FA2),
  }) {
    return GeniusConditionalFormatRule(
      conditionType: GeniusConditionType.between,
      value: min,
      value2: max,
      backgroundColor: backgroundColor,
      textColor: textColor,
      columnIds: columnIds,
    );
  }

  /// Creates a rule based on text content.
  factory GeniusConditionalFormatRule.textContains({
    required String text,
    List<String>? columnIds,
    Color backgroundColor = const Color(0xFFFFF8E1),
    Color textColor = const Color(0xFFFF8F00),
  }) {
    return GeniusConditionalFormatRule(
      conditionType: GeniusConditionType.contains,
      value: text,
      backgroundColor: backgroundColor,
      textColor: textColor,
      columnIds: columnIds,
    );
  }

  /// Creates a custom rule with a function.
  factory GeniusConditionalFormatRule.custom({
    required bool Function(
            dynamic value, String columnId, Map<String, dynamic> rowData)
        condition,
    List<String>? columnIds,
    Color? backgroundColor,
    Color? textColor,
    material.FontWeight? fontWeight,
    String? prefix,
    String? suffix,
  }) {
    return GeniusConditionalFormatRule(
      conditionType: GeniusConditionType.custom,
      customCondition: condition,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontWeight: fontWeight,
      prefix: prefix,
      suffix: suffix,
      columnIds: columnIds,
    );
  }

  /// The type of condition.
  final GeniusConditionType conditionType;

  /// The value to compare against.
  final dynamic value;

  /// The second value for range conditions.
  final dynamic value2;

  /// Custom condition function.
  final bool Function(
          dynamic value, String columnId, Map<String, dynamic> rowData)?
      customCondition;

  /// Background color when condition is met.
  final Color? backgroundColor;

  /// Text color when condition is met.
  final Color? textColor;

  /// Font weight when condition is met.
  final material.FontWeight? fontWeight;

  /// Prefix to add to cell value.
  final String? prefix;

  /// Suffix to add to cell value.
  final String? suffix;

  /// Column IDs this rule applies to. If null, applies to all columns.
  final List<String>? columnIds;

  /// Priority of this rule (higher = applied later).
  final int priority;

  /// Checks if this rule applies to a column.
  bool appliesToColumn(String columnId) {
    return columnIds == null || columnIds!.contains(columnId);
  }

  /// Evaluates if the condition is met.
  bool evaluate(
      dynamic cellValue, String columnId, Map<String, dynamic> rowData) {
    if (!appliesToColumn(columnId)) return false;

    switch (conditionType) {
      case GeniusConditionType.equals:
        return cellValue == value;

      case GeniusConditionType.notEquals:
        return cellValue != value;

      case GeniusConditionType.greaterThan:
        if (cellValue is num && value is num) {
          return cellValue > value;
        }
        return false;

      case GeniusConditionType.greaterThanOrEqual:
        if (cellValue is num && value is num) {
          return cellValue >= value;
        }
        return false;

      case GeniusConditionType.lessThan:
        if (cellValue is num && value is num) {
          return cellValue < value;
        }
        return false;

      case GeniusConditionType.lessThanOrEqual:
        if (cellValue is num && value is num) {
          return cellValue <= value;
        }
        return false;

      case GeniusConditionType.between:
        if (cellValue is num && value is num && value2 is num) {
          return cellValue >= value && cellValue <= value2;
        }
        return false;

      case GeniusConditionType.contains:
        return cellValue.toString().contains(value.toString());

      case GeniusConditionType.startsWith:
        return cellValue.toString().startsWith(value.toString());

      case GeniusConditionType.endsWith:
        return cellValue.toString().endsWith(value.toString());

      case GeniusConditionType.isEmpty:
        return cellValue == null || cellValue.toString().isEmpty;

      case GeniusConditionType.isNotEmpty:
        return cellValue != null && cellValue.toString().isNotEmpty;

      case GeniusConditionType.custom:
        return customCondition?.call(cellValue, columnId, rowData) ?? false;
    }
  }
}

/// Manager for applying conditional formatting rules.
class GeniusConditionalFormatManager {
  GeniusConditionalFormatManager({
    List<GeniusConditionalFormatRule>? rules,
  }) : _rules = rules ?? [];

  final List<GeniusConditionalFormatRule> _rules;

  /// Adds a rule.
  void addRule(GeniusConditionalFormatRule rule) {
    _rules.add(rule);
    _rules.sort((a, b) => a.priority.compareTo(b.priority));
  }

  /// Removes a rule.
  void removeRule(GeniusConditionalFormatRule rule) {
    _rules.remove(rule);
  }

  /// Clears all rules.
  void clearRules() {
    _rules.clear();
  }

  /// Gets all rules.
  List<GeniusConditionalFormatRule> get rules => List.unmodifiable(_rules);

  /// Gets the formatting to apply for a cell.
  GeniusCellFormatting? getFormatting(
    dynamic cellValue,
    String columnId,
    Map<String, dynamic> rowData,
  ) {
    Color? backgroundColor;
    Color? textColor;
    material.FontWeight? fontWeight;
    String? prefix;
    String? suffix;

    for (final rule in _rules) {
      if (rule.evaluate(cellValue, columnId, rowData)) {
        backgroundColor = rule.backgroundColor ?? backgroundColor;
        textColor = rule.textColor ?? textColor;
        fontWeight = rule.fontWeight ?? fontWeight;
        prefix = rule.prefix ?? prefix;
        suffix = rule.suffix ?? suffix;
      }
    }

    if (backgroundColor == null &&
        textColor == null &&
        fontWeight == null &&
        prefix == null &&
        suffix == null) {
      return null;
    }

    return GeniusCellFormatting(
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontWeight: fontWeight,
      prefix: prefix,
      suffix: suffix,
    );
  }
}

/// Formatting to apply to a cell.
class GeniusCellFormatting {
  const GeniusCellFormatting({
    this.backgroundColor,
    this.textColor,
    this.fontWeight,
    this.prefix,
    this.suffix,
  });

  final Color? backgroundColor;
  final Color? textColor;
  final material.FontWeight? fontWeight;
  final String? prefix;
  final String? suffix;

  /// Applies prefix and suffix to a value.
  String formatValue(dynamic value) {
    final stringValue = value?.toString() ?? '';
    final p = prefix ?? '';
    final s = suffix ?? '';
    return '$p$stringValue$s';
  }
}

// ============================================================================
// Data Grid with Conditional Formatting
// ============================================================================

/// Extension to add conditional formatting support to GeniusPdfDataGrid.
extension GeniusConditionalFormattingExtension on GeniusPdfDataGrid {
  /// Creates a grid with conditional formatting rules.
  static GeniusPdfDataGrid withFormatting({
    required List<GeniusPdfGridColumn> columns,
    required List<GeniusPdfGridRow> rows,
    required List<GeniusConditionalFormatRule> rules,
    required GeniusPdfConfig config,
    GeniusPdfGridStyle style = const GeniusPdfGridStyle.classic(),
    List<GeniusPdfGridGroup>? groups,
  }) {
    // Apply formatting to rows
    final formatManager = GeniusConditionalFormatManager(rules: rules);
    final formattedRows = rows.map((row) {
      final newCells = <String, dynamic>{};
      for (final entry in row.cells.entries) {
        final formatting = formatManager.getFormatting(
          entry.value,
          entry.key,
          row.cells,
        );

        if (formatting != null) {
          newCells[entry.key] = formatting.formatValue(entry.value);
        } else {
          newCells[entry.key] = entry.value;
        }
      }

      return row.copyWith(cells: newCells);
    }).toList();

    return GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: formattedRows,
      style: style,
      groups: groups,
    );
  }
}

// ============================================================================
// Data Grid Utilities
// ============================================================================

/// Utilities for working with data grids.
class GeniusDataGridUtils {
  GeniusDataGridUtils._();

  /// Calculates column totals from rows.
  static Map<String, num> calculateTotals(
    List<GeniusPdfGridRow> rows,
    List<String> columnIds,
  ) {
    final totals = <String, num>{};
    for (final columnId in columnIds) {
      totals[columnId] = 0;
    }

    for (final row in rows) {
      if (!row.isSpecialRow) {
        for (final columnId in columnIds) {
          final value = row.cells[columnId];
          if (value is num) {
            totals[columnId] = (totals[columnId] ?? 0) + value;
          }
        }
      }
    }

    return totals;
  }

  /// Calculates column averages from rows.
  static Map<String, double> calculateAverages(
    List<GeniusPdfGridRow> rows,
    List<String> columnIds,
  ) {
    final totals = calculateTotals(rows, columnIds);
    final dataRowCount = rows.where((r) => !r.isSpecialRow).length;

    if (dataRowCount == 0) {
      return columnIds.asMap().map((_, id) => MapEntry(id, 0.0));
    }

    return totals.map((key, value) => MapEntry(key, value / dataRowCount));
  }

  /// Creates a total row from calculated totals.
  static GeniusPdfGridRow createTotalRow(
    Map<String, dynamic> totals, {
    String? labelColumnId,
    String label = 'Total',
    String labelAr = 'الإجمالي',
    bool isRTL = true,
  }) {
    final cells = Map<String, dynamic>.from(totals);
    if (labelColumnId != null) {
      cells[labelColumnId] = isRTL ? labelAr : label;
    }
    return GeniusPdfGridRow.total(cells);
  }

  /// Groups rows by a column value.
  static Map<dynamic, List<GeniusPdfGridRow>> groupBy(
    List<GeniusPdfGridRow> rows,
    String columnId,
  ) {
    final groups = <dynamic, List<GeniusPdfGridRow>>{};

    for (final row in rows) {
      final key = row.cells[columnId];
      groups.putIfAbsent(key, () => []).add(row);
    }

    return groups;
  }

  /// Sorts rows by a column value.
  static List<GeniusPdfGridRow> sortBy(
    List<GeniusPdfGridRow> rows,
    String columnId, {
    bool ascending = true,
  }) {
    final sorted = List<GeniusPdfGridRow>.from(rows);
    sorted.sort((a, b) {
      final valueA = a.cells[columnId];
      final valueB = b.cells[columnId];

      int comparison;
      if (valueA is Comparable && valueB is Comparable) {
        comparison = valueA.compareTo(valueB);
      } else {
        comparison = valueA.toString().compareTo(valueB.toString());
      }

      return ascending ? comparison : -comparison;
    });
    return sorted;
  }

  /// Filters rows by a condition.
  static List<GeniusPdfGridRow> filter(
    List<GeniusPdfGridRow> rows,
    bool Function(GeniusPdfGridRow row) condition,
  ) {
    return rows.where(condition).toList();
  }
}
