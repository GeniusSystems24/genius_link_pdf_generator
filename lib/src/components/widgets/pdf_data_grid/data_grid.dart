part of '../pdf_data_grid.dart';

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
    this.directionality,
    this.direction = GeniusPdfDirection.auto,
    this.followDirection = true,
    this.preserveDefinitionOrder = false,
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

  final GeniusPdfDirectionality? directionality;
  final GeniusPdfDirection direction;
  final bool followDirection;
  final bool preserveDefinitionOrder;

  GeniusPdfDirectionality get _effectiveDirectionality =>
      GeniusPdfComponentDirectionality.context(
        config: config,
        inherited: directionality,
        componentDirection: direction,
      );
  GeniusPdfResolvedDirection get _layoutDirection =>
      _effectiveDirectionality.resolve().direction;
  bool get _isRtl => _layoutDirection == GeniusPdfResolvedDirection.rtl;
  int _definitionIndex(int i, int count) =>
      GeniusPdfComponentDirectionality.definitionIndex(
        index: i,
        count: count,
        direction: _layoutDirection,
        followDirection: followDirection,
        preserveDefinitionOrder: preserveDefinitionOrder,
      );

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
        final colIndex = _definitionIndex(i, cols.length);
        final column = cols[colIndex];
        final cell = headerRow.cells[i];

        cell.value = column.getTitle(isArabic: _isRtl);
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
      groupHeaderRow.cells[0].value = group.getTitle(isArabic: _isRtl);
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
            autoTotal.getLabel(isArabic: _isRtl) ?? '';
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
      final colIndex = _definitionIndex(i, cols.length);
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

    // Resolve logical padding at the drawing boundary only.
    if (column.directionalPadding != null) {
      final p = column.directionalPadding!.resolve(_layoutDirection);
      cell.style.cellPadding = PdfPaddings(
        left: p.left,
        right: p.right,
        top: p.top,
        bottom: p.bottom,
      );
    } else {
      cell.style.cellPadding = cellStyle.padding.toPdfPaddings();
    }

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
    final requestedDirection = isHeader
        ? column.headerDirection
        : (column.isNumeric &&
                column.contentDirection == GeniusPdfDirection.auto
            ? GeniusPdfDirection.ltr
            : column.contentDirection);
    final runDirection = switch (requestedDirection) {
      GeniusPdfDirection.ltr => GeniusPdfResolvedDirection.ltr,
      GeniusPdfDirection.rtl => GeniusPdfResolvedDirection.rtl,
      GeniusPdfDirection.auto => _layoutDirection,
    };
    cell.style.stringFormat = PdfStringFormat(
      alignment: !isHeader && column.isNumeric
          ? PdfTextAlignment.right
          : column.alignment.toPdfTextAlignment(_isRtl),
      lineAlignment: verticalAlign.toPdfVerticalAlignment(),
      textDirection: GeniusPdfComponentDirectionality.pdfDirection(runDirection),
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
        final raw = availableWidth *
            col.widthPercent!.clamp(0.0, 1.0).toDouble();
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
    return value
        .clamp(math.min(colMin, colMax), math.max(colMin, colMax))
        .toDouble();
  }
}
