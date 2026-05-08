import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../extensions/color_extensions.dart';
import '../../core/pdf_config.dart';
import '../../core/pdf_print_theme.dart';
import '../models/grid_models.dart';
import '../models/pdf_styles.dart';
import '../../core/pdf_logger.dart';

/// A powerful data grid component for PDF documents (v2.12.0).
///
/// [GeniusPdfDataGrid] provides a flexible way to create tables in PDF documents
/// with support for:
/// - Custom column definitions with various alignments
/// - Header rows with RTL/LTR support
/// - Alternating row colors
/// - Group headers with nested subgroups
/// - Multiple total/summary rows per grid (auto-calculated)
/// - Percentage-based and flex-based column widths
/// - Multi-pass column width redistribution with min/max constraints
/// - Automatic pagination
/// - Currency and number formatting
///
/// ## Example — Simple Grid with Auto Totals
/// ```dart
/// final grid = GeniusPdfDataGrid(
///   columns: [
///     GeniusPdfGridColumn(id: 'name', title: 'Name', titleAr: 'الاسم'),
///     GeniusPdfGridColumn.currency(id: 'amount', title: 'Amount', titleAr: 'المبلغ'),
///   ],
///   rows: [
///     GeniusPdfGridRow(cells: {'name': 'Item 1', 'amount': 100.00}),
///     GeniusPdfGridRow(cells: {'name': 'Item 2', 'amount': 200.00}),
///   ],
///   autoTotals: [
///     GeniusPdfAutoTotal.sum(
///       label: 'Total', labelAr: 'الإجمالي', labelColumnId: 'name',
///     ),
///   ],
///   config: config,
/// );
///
/// grid.draw(page: currentPage, bounds: Rect.fromLTWH(0, y, width, height));
/// ```
///
/// ## Example — Grouped Grid with Multiple Totals
/// ```dart
/// final grid = GeniusPdfDataGrid(
///   columns: columns,
///   rows: [],
///   groups: [
///     GeniusPdfGridGroup.withSummary(
///       title: 'Electronics', titleAr: 'إلكترونيات',
///       rows: electronicsRows, sumColumns: ['total'],
///       labelColumnId: 'desc',
///     ),
///     GeniusPdfGridGroup.withSummary(
///       title: 'Services', titleAr: 'خدمات',
///       rows: servicesRows, sumColumns: ['total'],
///       labelColumnId: 'desc',
///     ),
///   ],
///   footerRows: [
///     GeniusPdfGridRow.total({'desc': 'Grand Total', 'total': 25000}),
///   ],
///   config: config,
/// );
/// ```
class GeniusPdfDataGrid {
  GeniusPdfDataGrid({
    required this.columns,
    required this.rows,
    required this.config,
    GeniusPdfGridStyle? style,
    this.groups,
    this.footerRows,
    this.autoTotals,
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

  /// Explicit footer/total rows appended after all data rows.
  final List<GeniusPdfGridRow>? footerRows;

  /// Auto-calculated total rows appended after data rows (before footerRows).
  final List<GeniusPdfAutoTotal>? autoTotals;

  /// Running counter of rendered data rows. Used to keep alternating-row
  /// colors consistent across groups and special rows in a single draw pass.
  int _dataRowCounter = 0;

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

  /// Collects all data rows (excluding special rows) for total calculations.
  List<GeniusPdfGridRow> get _allDataRows {
    if (groups != null && groups!.isNotEmpty) {
      return groups!.expand((g) => _collectDataRows(g)).toList();
    }
    return rows.where((r) => !r.isSpecialRow).toList();
  }

  /// Recursively collects data rows from a group and its subgroups.
  List<GeniusPdfGridRow> _collectDataRows(GeniusPdfGridGroup group) {
    final result = <GeniusPdfGridRow>[];
    if (group.subgroups != null && group.subgroups!.isNotEmpty) {
      for (final sub in group.subgroups!) {
        result.addAll(_collectDataRows(sub));
      }
    }
    result.addAll(group.rows.where((r) => !r.isSpecialRow));
    return result;
  }

  /// Draws the grid on a PDF page.
  ///
  /// Returns the layout result for positioning subsequent content.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    final totalAutoRows = autoTotals?.length ?? 0;
    final totalFooterRows = footerRows?.length ?? 0;
    GeniusPdfLogger.debug(
        'Drawing grid: ${columns.length} columns, ${rows.length} rows'
        '${totalAutoRows > 0 ? ', $totalAutoRows auto-totals' : ''}'
        '${totalFooterRows > 0 ? ', $totalFooterRows footer rows' : ''}',
        tag: 'DataGrid');
    final grid = _buildGrid(page, availableWidth: bounds.width);

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

  PdfGrid _buildGrid(PdfPage page, {double? availableWidth}) {
    final grid = PdfGrid();
    final cols = visibleColumns;

    // Reset render state (v2.12.9): counter is shared across groups so
    // alternating-row colors stay consistent throughout the entire grid.
    _dataRowCounter = 0;

    // Calculate column widths with improved algorithm (v2.12.9)
    final gridWidth = availableWidth ?? page.getClientSize().width;
    final columnWidths = _calculateColumnWidths(cols, gridWidth);

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

    // Add auto-calculated total rows (v2.12.0)
    if (autoTotals != null && autoTotals!.isNotEmpty) {
      _addAutoTotalRows(grid, cols);
    }

    // Add explicit footer rows (v2.12.0)
    if (footerRows != null && footerRows!.isNotEmpty) {
      for (final footerRow in footerRows!) {
        _addSingleRow(grid, cols, footerRow, grid.rows.count);
      }
    }

    // Configure grid settings
    grid.style.cellSpacing = style.cellSpacing;
    if (style.repeatHeaderOnPages) {
      grid.repeatHeader = true;
    }

    return grid;
  }

  /// Adds grouped rows with recursive subgroup support (v2.12.0 enhanced).
  void _addGroupedRows(PdfGrid grid, List<GeniusPdfGridColumn> cols) {
    for (final group in groups!) {
      _addGroup(grid, cols, group);
    }
  }

  /// Recursively adds a group and its subgroups to the grid.
  void _addGroup(
    PdfGrid grid,
    List<GeniusPdfGridColumn> cols,
    GeniusPdfGridGroup group,
  ) {
    // Add group header if enabled
    if (group.showHeader) {
      final groupHeaderRow = grid.rows.add();
      groupHeaderRow.cells[0].value = group.getTitle(isArabic: config.isRTL);
      groupHeaderRow.cells[0].columnSpan = cols.length;

      final baseStyle =
          group.headerStyle ?? group.style ?? style.groupHeaderStyle;
      // v2.12.9: derive a level-aware style — deeper groups get a lighter
      // tint and proportional left indent, regardless of which base style
      // is in use, so nested groups read as a clear visual hierarchy.
      final resolvedStyle = _withGroupLevelDecoration(
        baseStyle ??
            const GeniusPdfCellStyle(
              textStyle: GeniusPdfTextStyle(
                fontSize: 11,
                fontWeight: material.FontWeight.bold,
              ),
              backgroundColor: Color(0xFFE0E0E0),
              border: GeniusPdfBorderStyle.all(),
              padding: GeniusPdfCellPadding.all(4),
            ),
        group.level,
      );
      _applyRowStyle(groupHeaderRow, resolvedStyle, isGroupHeader: true);
      _applyCellStyle(
        groupHeaderRow.cells[0],
        resolvedStyle,
        cols[0],
        isFirstColumn: true,
        isLastColumn: true,
      );
    }

    // Add subgroups recursively if present
    if (group.subgroups != null && group.subgroups!.isNotEmpty) {
      for (final subgroup in group.subgroups!) {
        _addGroup(grid, cols, subgroup);
      }
    } else {
      // Add group data rows
      _addDataRows(grid, cols, group.rows);
    }

    // Add group summary rows if present
    if (group.showSummary) {
      // Primary summary
      if (group.summary != null) {
        final summaryRow = group.summaryStyle != null
            ? group.summary!.copyWith(style: group.summaryStyle)
            : group.summary!;
        _addSingleRow(grid, cols, summaryRow, grid.rows.count);
      }

      // Additional summaries (v2.12.0)
      if (group.summaries != null) {
        for (final summaryRow in group.summaries!) {
          final styledRow =
              group.summaryStyle != null && summaryRow.style == null
                  ? summaryRow.copyWith(style: group.summaryStyle)
                  : summaryRow;
          _addSingleRow(grid, cols, styledRow, grid.rows.count);
        }
      }
    }
  }

  /// Adds auto-calculated total rows to the grid (v2.12.0).
  void _addAutoTotalRows(PdfGrid grid, List<GeniusPdfGridColumn> cols) {
    final dataRows = _allDataRows;

    for (final autoTotal in autoTotals!) {
      final calculated = autoTotal.calculate(dataRows, cols);
      final cells = <String, dynamic>{};

      // Add calculated values
      cells.addAll(calculated);

      // Add label
      if (autoTotal.labelColumnId != null) {
        cells[autoTotal.labelColumnId!] =
            autoTotal.getLabel(isArabic: config.isRTL) ?? '';
      }

      // Add extra static cells
      if (autoTotal.extraCells != null) {
        cells.addAll(autoTotal.extraCells!);
      }

      final totalRow = GeniusPdfGridRow.total(
        cells,
        style: autoTotal.style,
      );

      // Apply span if specified
      final effectiveRow = autoTotal.span != null
          ? totalRow.copyWith(span: autoTotal.span)
          : totalRow;

      _addSingleRow(grid, cols, effectiveRow, grid.rows.count);
    }
  }

  void _addDataRows(
    PdfGrid grid,
    List<GeniusPdfGridColumn> cols,
    List<GeniusPdfGridRow> dataRows,
  ) {
    for (final rowData in dataRows) {
      // Pass the running counter so stripe alternation stays consistent
      // across groups. Special rows (totals, headers) reuse the index but
      // their cell-style branch wins before the alternation check.
      _addSingleRow(grid, cols, rowData, _dataRowCounter);
      if (!rowData.isSpecialRow) _dataRowCounter++;
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
    } else if (rowData.isSubtotal) {
      rowStyle = rowData.style ?? style.subtotalRowStyle ?? style.totalRowStyle;
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
              left: 4 + (rowData.groupLevel * style.groupIndentPerLevel),
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

    _applyRowStyle(row, rowStyle, isGroupHeader: rowData.isGroupHeader);

    // Handle group header spanning
    if (rowData.isGroupHeader) {
      row.cells[0].value = rowData.cells['_group'] ?? '';
      row.cells[0].columnSpan = cols.length;
      _applyCellStyle(
        row.cells[0],
        _withGroupLevelDecoration(rowStyle, rowData.groupLevel),
        cols[0],
        isFirstColumn: true,
        isLastColumn: true,
      );
      return;
    }

    // Populate cells
    final lastIdx = cols.length - 1;
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

      // v2.12.9: merge column.cellStyle on top of the row style instead of
      // replacing it outright, so column-level styling no longer wipes
      // alternate-row backgrounds or special-row visual cues.
      var effectiveCellStyle = column.cellStyle == null
          ? rowStyle
          : _mergeColumnOverRow(column.cellStyle!, rowStyle);

      if (column.cellStyleBuilder != null) {
        final rawValue = rowData.getValue(column.id);
        final builtStyle = column.cellStyleBuilder!(rawValue);
        if (builtStyle != null) {
          // Builder result also merges over the row style for consistency.
          effectiveCellStyle = _mergeColumnOverRow(builtStyle, rowStyle);
        }
      }

      _applyCellStyle(
        cell,
        effectiveCellStyle,
        column,
        isTotal: rowData.isTotal || rowData.isSubtotal,
        isFirstColumn: i == 0,
        isLastColumn: i == lastIdx,
      );
    }
  }

  void _applyRowStyle(
    PdfGridRow row,
    GeniusPdfCellStyle cellStyle, {
    bool isHeader = false,
    bool isGroupHeader = false,
  }) {
    final s = style;

    // Explicit configured heights take priority (v2.12.9 — added
    // groupHeaderHeight which was previously declared but ignored).
    if (isHeader && s.headerHeight != null) {
      row.height = s.headerHeight!;
      return;
    }
    if (isGroupHeader && s.groupHeaderHeight != null) {
      row.height = s.groupHeaderHeight!;
      return;
    }
    if (!isHeader && !isGroupHeader && s.rowHeight != null) {
      row.height = s.rowHeight!;
      return;
    }

    // v2.12.9: when no explicit height is configured, derive a sensible
    // minimum from font size + padding so small font/padding combinations
    // don't crop ascenders/descenders. minRowHeight from the style is
    // honored as the lower bound; maxRowHeight (if set) caps it.
    final lineHeight = cellStyle.textStyle.fontSize * 1.4;
    final padded =
        lineHeight + cellStyle.padding.top + cellStyle.padding.bottom;
    var auto = math.max(padded, s.minRowHeight);
    if (s.maxRowHeight != null) {
      auto = math.min(auto, s.maxRowHeight!);
    }
    row.height = auto;
  }

  void _applyCellStyle(
    PdfGridCell cell,
    GeniusPdfCellStyle cellStyle,
    GeniusPdfGridColumn column, {
    bool isHeader = false,
    bool isTotal = false,
    bool isFirstColumn = false,
    bool isLastColumn = false,
  }) {
    // Background color
    if (cellStyle.backgroundColor != null) {
      cell.style.backgroundBrush =
          PdfSolidBrush(cellStyle.backgroundColor!.toPdfColor());
    }

    // Border — v2.12.9: outerBorderStyle (when configured) overrides the
    // outermost left/right edges so the grid can sport a distinct frame
    // without disturbing internal cell borders.
    cell.style.borders =
        _resolveCellBorders(cellStyle.border, isFirstColumn, isLastColumn);

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

    // String format (alignment) — v2.12.9: column.verticalAlignment now
    // takes precedence over the cellStyle's textStyle vertical alignment
    // because column-level vertical alignment is a column-wide invariant.
    final verticalAlign = column.verticalAlignment != GeniusPdfVerticalAlign.top
        ? column.verticalAlignment
        : cellStyle.textStyle.verticalAlignment;
    cell.style.stringFormat = PdfStringFormat(
      alignment: column.alignment.toPdfTextAlignment(config.isRTL),
      lineAlignment: verticalAlign.toPdfVerticalAlignment(),
      textDirection: config.pdfTextDirection,
    );
  }

  /// Combines the cell's own border with [GeniusPdfGridStyle.outerBorderStyle]
  /// so the grid's outer frame is rendered without overriding internal edges.
  PdfBorders _resolveCellBorders(
    GeniusPdfBorderStyle base,
    bool isFirstColumn,
    bool isLastColumn,
  ) {
    final outer = style.outerBorderStyle;
    if (outer == null || (!isFirstColumn && !isLastColumn)) {
      return base.toPdfBorders();
    }
    final basePen = base.toPen();
    final noPen = PdfPen(PdfColor(0, 0, 0, 0), width: 0);
    final outerPen = outer.toPen();

    PdfPen sidePen(bool baseSide) => baseSide ? basePen : noPen;
    final leftIsOuter = isFirstColumn && outer.left;
    final rightIsOuter = isLastColumn && outer.right;
    return PdfBorders(
      left: leftIsOuter ? outerPen : sidePen(base.left),
      right: rightIsOuter ? outerPen : sidePen(base.right),
      top: base.top ? basePen : noPen,
      bottom: base.bottom ? basePen : noPen,
    );
  }

  /// Returns a copy of [columnStyle] that adopts the row-level background
  /// (e.g. alternate / total / subtotal tints) when the column did not
  /// explicitly opt in to its own background. Border and text styling from
  /// the column are otherwise preserved.
  GeniusPdfCellStyle _mergeColumnOverRow(
    GeniusPdfCellStyle columnStyle,
    GeniusPdfCellStyle rowStyle,
  ) {
    if (columnStyle.backgroundColor != null) return columnStyle;
    if (rowStyle.backgroundColor == null) return columnStyle;
    return columnStyle.copyWith(backgroundColor: rowStyle.backgroundColor);
  }

  /// Decorates a group-header cell style with level-based tinting and
  /// horizontal indent so nested groups produce a clear visual hierarchy.
  ///
  /// The lightening factor scales by `level * 0.06` (capped at 0.5) and is
  /// applied only when the source style already has a background color so
  /// border-only group styles stay untouched.
  GeniusPdfCellStyle _withGroupLevelDecoration(
    GeniusPdfCellStyle source,
    int level,
  ) {
    if (level <= 0) return source;

    final indent = level * style.groupIndentPerLevel.toDouble();
    final paddedLeft = source.padding.left + indent;
    final newPadding = GeniusPdfCellPadding(
      left: paddedLeft,
      right: source.padding.right,
      top: source.padding.top,
      bottom: source.padding.bottom,
    );

    Color? newBg = source.backgroundColor;
    if (newBg != null) {
      final lighten = math.min(0.06 * level, 0.5);
      newBg = Color.lerp(newBg, const Color(0xFFFFFFFF), lighten);
    }

    return source.copyWith(backgroundColor: newBg, padding: newPadding);
  }

  /// Column width calculation with multi-pass constraint redistribution,
  /// percentage support, padding awareness, and tiered fit-to-width
  /// reconciliation (v2.12.9).
  ///
  /// **Pass 1** classifies columns as fixed (`col.width`), percent
  /// (`col.widthPercent`), or flex (default), and resolves the first two
  /// against the column's min/max constraints.
  ///
  /// **Pass 2** distributes the remaining width across flex columns up to
  /// four iterations. Columns clamped by min/max release their excess
  /// back into a pool that's redistributed across still-unclamped flex
  /// columns until the pool is stable.
  ///
  /// **Pass 3** reconciles total width with the available width. When the
  /// totals diverge it scales — but tiered: flex columns absorb the delta
  /// first, then percent columns, and only fixed columns as a last resort.
  /// This protects user-authored fixed widths from being silently scaled.
  List<double> _calculateColumnWidths(
    List<GeniusPdfGridColumn> cols,
    double availableWidth,
  ) {
    if (cols.isEmpty || availableWidth <= 0) {
      return List<double>.filled(cols.length, 0);
    }

    final widths = List<double>.filled(cols.length, 0);
    // RTL keeps the same logical→visual column ordering as before so
    // existing layouts render unchanged.
    final orderedCols = config.isRTL ? cols.reversed.toList() : cols;

    final fixedIndices = <int>[];
    final percentIndices = <int>[];
    final flexIndices = <int>[];

    double usedWidth = 0;
    int totalFlex = 0;

    // --- Pass 1: classify columns and resolve fixed + percentage widths ---
    for (int i = 0; i < orderedCols.length; i++) {
      final col = orderedCols[i];
      if (col.width != null) {
        widths[i] = _clampWidth(col.width!, col);
        usedWidth += widths[i];
        fixedIndices.add(i);
      } else if (col.widthPercent != null) {
        final raw = availableWidth * col.widthPercent!.clamp(0.0, 1.0);
        widths[i] = _clampWidth(raw, col);
        usedWidth += widths[i];
        percentIndices.add(i);
      } else {
        flexIndices.add(i);
        totalFlex += col.flexFactor ?? 1;
      }
    }

    // --- Pass 2: distribute remaining width to flex columns ---
    final remaining = availableWidth - usedWidth;

    if (flexIndices.isEmpty) {
      // Nothing to distribute — total may still drift from availableWidth,
      // which Pass 3 will reconcile across percent/fixed pools.
    } else if (remaining <= 0) {
      // No room to grow flex columns: fall back to defaultColumnWidth so
      // they still render. Pass 3 will then shrink everything to fit.
      for (final idx in flexIndices) {
        widths[idx] = _clampWidth(style.defaultColumnWidth, orderedCols[idx]);
      }
    } else {
      var unclamped = List<int>.from(flexIndices);
      var poolFlex = totalFlex;
      var pool = remaining;

      for (int pass = 0; pass < 4 && unclamped.isNotEmpty && pool > 0; pass++) {
        final unit =
            poolFlex > 0 ? pool / poolFlex : pool / unclamped.length;
        final stillUnclamped = <int>[];
        var leftover = 0.0;
        var nextFlex = 0;

        for (final idx in unclamped) {
          final col = orderedCols[idx];
          final flex = col.flexFactor ?? 1;
          final raw = poolFlex > 0 ? unit * flex : unit;
          final clamped = _clampWidth(raw, col);
          widths[idx] = clamped;
          if ((clamped - raw).abs() > 0.5) {
            leftover += raw - clamped;
          } else {
            stillUnclamped.add(idx);
            nextFlex += flex;
          }
        }

        if (leftover.abs() < 0.5 || stillUnclamped.isEmpty) break;
        pool = leftover;
        poolFlex = nextFlex;
        unclamped = stillUnclamped;
      }
    }

    // --- Pass 3: reconcile total with availableWidth, tier by tier ---
    final delta = availableWidth - widths.fold<double>(0, (a, b) => a + b);
    if (delta.abs() > 1.0) {
      // Try absorbing the delta in: flex first, then percent, then fixed.
      // This protects fixed-width columns from silent scaling while still
      // keeping the grid flush with the available width.
      for (final pool in [flexIndices, percentIndices, fixedIndices]) {
        final remainingDelta =
            availableWidth - widths.fold<double>(0, (a, b) => a + b);
        if (remainingDelta.abs() <= 1.0 || pool.isEmpty) continue;

        final poolTotal = pool.fold<double>(0, (a, b) => a + widths[b]);
        if (poolTotal <= 0) continue;

        final scale = (poolTotal + remainingDelta) / poolTotal;
        if (scale <= 0) continue;
        for (final idx in pool) {
          widths[idx] = _clampWidth(widths[idx] * scale, orderedCols[idx]);
        }
      }
    }

    // Final residual goes to the last column to guarantee the row fills
    // the available width exactly (sub-pixel rounding correction).
    final residual =
        availableWidth - widths.fold<double>(0, (a, b) => a + b);
    if (residual.abs() > 0 && widths.isNotEmpty) {
      widths[widths.length - 1] += residual;
    }

    return widths;
  }

  /// Clamps a width value to the column's min/max constraints and
  /// the grid style's global min/max column width.
  double _clampWidth(double value, GeniusPdfGridColumn col) {
    final globalMin = style.minColumnWidth;
    final globalMax = style.maxColumnWidth;
    final colMin = col.minWidth ?? globalMin;
    final colMax = col.maxWidth ?? globalMax;
    return value.clamp(math.min(colMin, colMax), math.max(colMin, colMax));
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

  /// Creates an invoice-style grid with auto-calculated totals (v2.12.0).
  static GeniusPdfDataGrid invoice({
    required List<Map<String, dynamic>> items,
    required GeniusPdfConfig config,
    String codeColumn = 'code',
    String descColumn = 'desc',
    String qtyColumn = 'qty',
    String priceColumn = 'price',
    String totalColumn = 'total',
    double taxRate = 0.15,
    String currencySymbol = 'SAR',
    GeniusPdfGridStyle? style,
  }) {
    final dataRows = items
        .map((item) => GeniusPdfGridRow(cells: Map<String, dynamic>.from(item)))
        .toList();

    // Calculate totals
    double subtotal = 0;
    for (final item in items) {
      final total = item[totalColumn];
      if (total is num) subtotal += total;
    }
    final tax = subtotal * taxRate;
    final grandTotal = subtotal + tax;

    return GeniusPdfDataGrid(
      config: config,
      columns: [
        GeniusPdfGridColumn(
          id: codeColumn,
          title: 'Code',
          titleAr: 'الكود',
          width: 60,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn(
          id: descColumn,
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 3,
        ),
        GeniusPdfGridColumn.numeric(
          id: qtyColumn,
          title: 'Qty',
          titleAr: 'الكمية',
          width: 50,
          alignment: GeniusPdfTextAlign.center,
        ),
        GeniusPdfGridColumn.currency(
          id: priceColumn,
          title: 'Price',
          titleAr: 'السعر',
          currencySymbol: currencySymbol,
          width: 90,
        ),
        GeniusPdfGridColumn.currency(
          id: totalColumn,
          title: 'Total',
          titleAr: 'الإجمالي',
          currencySymbol: currencySymbol,
          width: 100,
        ),
      ],
      rows: dataRows,
      footerRows: [
        GeniusPdfGridRow.subtotal({
          descColumn: config.isRTL ? 'المجموع الفرعي' : 'Subtotal',
          totalColumn: subtotal,
        }),
        GeniusPdfGridRow(
          cells: {
            descColumn: config.isRTL
                ? 'الضريبة (${(taxRate * 100).toStringAsFixed(0)}%)'
                : 'Tax (${(taxRate * 100).toStringAsFixed(0)}%)',
            totalColumn: tax,
          },
          isSubtotal: true,
        ),
        GeniusPdfGridRow.total({
          descColumn: config.isRTL ? 'الإجمالي الكلي' : 'Grand Total',
          totalColumn: grandTotal,
        }),
      ],
      style: style ?? GeniusPdfGridStyle.invoice(),
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
    GeniusPdfGridStyle? style,
    List<GeniusPdfGridGroup>? groups,
    List<GeniusPdfGridRow>? footerRows,
    List<GeniusPdfAutoTotal>? autoTotals,
  }) {
    style ??= const GeniusPdfGridStyle.classic();
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
      footerRows: footerRows,
      autoTotals: autoTotals,
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

  /// Creates [GeniusPdfGridGroup] list from rows grouped by a column (v2.12.0).
  ///
  /// Automatically groups data rows by the specified column and optionally
  /// calculates summaries for each group.
  static List<GeniusPdfGridGroup> autoGroup({
    required List<GeniusPdfGridRow> rows,
    required String groupByColumn,
    List<String>? sumColumns,
    String? summaryLabelColumnId,
    String summaryLabel = 'Subtotal',
    String? summaryLabelAr,
    Map<String, String>? titleMap,
    Map<String, String>? titleArMap,
  }) {
    final grouped = groupBy(rows, groupByColumn);
    return grouped.entries.map((entry) {
      final groupKey = entry.key?.toString() ?? '';
      final groupRows = entry.value;

      if (sumColumns != null && sumColumns.isNotEmpty) {
        return GeniusPdfGridGroup.withSummary(
          title: titleMap?[groupKey] ?? groupKey,
          titleAr: titleArMap?[groupKey],
          rows: groupRows,
          sumColumns: sumColumns,
          labelColumnId: summaryLabelColumnId,
          summaryLabel: summaryLabel,
          summaryLabelAr: summaryLabelAr,
        );
      }

      return GeniusPdfGridGroup.simple(
        title: titleMap?[groupKey] ?? groupKey,
        titleAr: titleArMap?[groupKey],
        rows: groupRows,
      );
    }).toList();
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

  /// Creates multiple total rows for common invoice patterns (v2.12.0).
  ///
  /// Returns a list of [GeniusPdfGridRow] representing subtotal, tax,
  /// discount, and grand total rows.
  static List<GeniusPdfGridRow> invoiceTotals({
    required double subtotal,
    required String totalColumnId,
    String labelColumnId = 'desc',
    double taxRate = 0.15,
    double discount = 0,
    bool isRTL = true,
    String currencySymbol = 'SAR',
  }) {
    final rows = <GeniusPdfGridRow>[];

    // Subtotal
    rows.add(GeniusPdfGridRow.subtotal({
      labelColumnId: isRTL ? 'المجموع الفرعي' : 'Subtotal',
      totalColumnId: subtotal,
    }));

    // Discount (if any)
    if (discount > 0) {
      rows.add(GeniusPdfGridRow.subtotal({
        labelColumnId: isRTL ? 'الخصم' : 'Discount',
        totalColumnId: -discount,
      }));
    }

    // Tax
    final taxableAmount = subtotal - discount;
    final taxAmount = taxableAmount * taxRate;
    rows.add(GeniusPdfGridRow.subtotal({
      labelColumnId: isRTL
          ? 'الضريبة (${(taxRate * 100).toStringAsFixed(0)}%)'
          : 'Tax (${(taxRate * 100).toStringAsFixed(0)}%)',
      totalColumnId: taxAmount,
    }));

    // Grand total
    final grandTotal = taxableAmount + taxAmount;
    rows.add(GeniusPdfGridRow.total({
      labelColumnId: isRTL ? 'الإجمالي الكلي' : 'Grand Total',
      totalColumnId: grandTotal,
    }));

    return rows;
  }
}
