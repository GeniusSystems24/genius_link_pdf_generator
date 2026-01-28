import 'dart:ui';

import 'package:flutter/material.dart' as material;
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../../extensions/color_extensions.dart';
import '../models/grid_models.dart';
import '../models/pdf_styles.dart';

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
    this.style = const GeniusPdfGridStyle.classic(),
    required this.baseFont,
    required this.boldFont,
    this.isRTL = true,
    this.groups,
  });

  /// Column definitions.
  final List<GeniusPdfGridColumn> columns;

  /// Data rows.
  final List<GeniusPdfGridRow> rows;

  /// Grid styling configuration.
  final GeniusPdfGridStyle style;

  /// Base font for text.
  final PdfFont baseFont;

  /// Bold font for headers and totals.
  final PdfFont boldFont;

  /// Whether to use RTL layout.
  final bool isRTL;

  /// Optional grouped data.
  final List<GeniusPdfGridGroup>? groups;

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
        final colIndex = isRTL ? cols.length - 1 - i : i;
        final column = cols[colIndex];
        final cell = headerRow.cells[i];

        cell.value = column.getTitle(isArabic: isRTL);
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
      groupHeaderRow.cells[0].value = group.getTitle(isArabic: isRTL);
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
      final colIndex = isRTL ? cols.length - 1 - i : i;
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
      font = boldFont;
    } else {
      font = baseFont;
    }
    cell.style.font = font;

    // Text color
    cell.style.textBrush = cellStyle.textStyle.toBrush();

    // String format (alignment)
    final alignment = column.alignment;
    cell.style.stringFormat = PdfStringFormat(
      alignment: alignment.toPdfTextAlignment(),
      lineAlignment:
          cellStyle.textStyle.verticalAlignment.toPdfVerticalAlignment(),
      textDirection:
          isRTL ? PdfTextDirection.rightToLeft : PdfTextDirection.leftToRight,
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
    for (final col in cols) {
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
    GeniusPdfGridStyle? style,
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    return GeniusPdfDataGrid(
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
          alignment: GeniusPdfTextAlign.right,
        ),
      ],
      rows: data.entries
          .map((e) =>
              GeniusPdfGridRow(cells: {'label': e.key, 'value': e.value}))
          .toList(),
      style: style ?? const GeniusPdfGridStyle.classic(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
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
    GeniusPdfGridStyle? style,
    required PdfFont baseFont,
    required PdfFont boldFont,
    bool isRTL = true,
  }) {
    return GeniusPdfDataGrid(
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
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: isRTL,
    );
  }
}
