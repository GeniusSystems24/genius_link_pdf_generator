part of '../pdf_data_grid.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sprint S04 — DataGrid vNext for ERP Reports
// ─────────────────────────────────────────────────────────────────────────────

/// Width strategy used by [GeniusPdfGridColumnPolicy].
enum GeniusPdfGridWidthMode {
  fixed,
  flex,
  autoFit,
}

/// Overflow policy for a DataGrid text cell.
enum GeniusPdfGridTextOverflow {
  wrap,
  ellipsis,
  clip,
}

/// Controls whether a tall DataGrid row may split between PDF pages.
enum GeniusPdfGridRowSplitPolicy {
  keepTogether,
  allowSplit,
}

/// ERP semantic type used by S04 DataGrid formatter hooks.
///
/// The cross-component formatter engine is intentionally deferred to S05.
enum GeniusPdfGridValueKind {
  text,
  number,
  money,
  percentage,
  quantity,
  date,
  dateTime,
  identifier,
  debit,
  credit,
}

/// Aggregate operation for group and grand-total expressions.
enum GeniusPdfGridAggregate {
  sum,
  average,
  count,
  min,
  max,
  custom,
}

/// Logical start/end padding for headers or data cells.
class GeniusPdfGridDirectionalPadding {
  const GeniusPdfGridDirectionalPadding({
    this.start = 0,
    this.end = 0,
    this.top = 0,
    this.bottom = 0,
  });

  final double start;
  final double end;
  final double top;
  final double bottom;

  GeniusPdfCellPadding resolve(bool isRtl) => GeniusPdfCellPadding(
        left: isRtl ? end : start,
        right: isRtl ? start : end,
        top: top,
        bottom: bottom,
      );
}

/// Context passed to an S04 value formatter.
class GeniusPdfGridFormatContext {
  const GeniusPdfGridFormatContext({
    required this.value,
    required this.row,
    required this.column,
    required this.rowIndex,
    required this.config,
    this.currencyCode,
  });

  final dynamic value;
  final GeniusPdfGridRow row;
  final GeniusPdfGridColumn column;
  final int rowIndex;
  final GeniusPdfConfig config;
  final String? currencyCode;

  bool get isRtl => config.isRTL;
}

/// Formatter callback used by the S04 DataGrid-local integration hooks.
typedef GeniusPdfGridFormatter = String Function(
  GeniusPdfGridFormatContext context,
);

/// DataGrid-local formatter hooks.
///
/// S05 replaces these local hooks with the package-wide formatter contract.
class GeniusPdfGridFormatterHooks {
  const GeniusPdfGridFormatterHooks({
    this.money,
    this.number,
    this.percentage,
    this.quantity,
    this.date,
    this.dateTime,
    this.identifier,
  });

  final GeniusPdfGridFormatter? money;
  final GeniusPdfGridFormatter? number;
  final GeniusPdfGridFormatter? percentage;
  final GeniusPdfGridFormatter? quantity;
  final GeniusPdfGridFormatter? date;
  final GeniusPdfGridFormatter? dateTime;
  final GeniusPdfGridFormatter? identifier;
}

/// S04 behavior associated with an existing [GeniusPdfGridColumn].
class GeniusPdfGridColumnPolicy {
  const GeniusPdfGridColumnPolicy({
    this.widthMode,
    this.fixedWidth,
    this.flex = 1,
    this.minWidth,
    this.maxWidth,
    this.autoFitSampleSize = 100,
    this.overflow = GeniusPdfGridTextOverflow.wrap,
    this.maxLines,
    this.valueKind = GeniusPdfGridValueKind.text,
    this.decimalPlaces = 2,
    this.percentageIsFraction = false,
    this.accountingNegative = false,
    this.currencyCode,
    this.currencyResolver,
    this.headerDirection = GeniusPdfDirection.auto,
    this.contentDirection = GeniusPdfDirection.auto,
    this.headerPadding,
    this.cellPadding,
    this.formatter,
  })  : assert(flex > 0),
        assert(autoFitSampleSize > 0),
        assert(decimalPlaces >= 0);

  final GeniusPdfGridWidthMode? widthMode;
  final double? fixedWidth;
  final double flex;
  final double? minWidth;
  final double? maxWidth;
  final int autoFitSampleSize;
  final GeniusPdfGridTextOverflow overflow;
  final int? maxLines;
  final GeniusPdfGridValueKind valueKind;
  final int decimalPlaces;
  final bool percentageIsFraction;
  final bool accountingNegative;
  final String? currencyCode;
  final String? Function(GeniusPdfGridRow row)? currencyResolver;

  /// Header run direction. `auto` inherits the document direction.
  final GeniusPdfDirection headerDirection;

  /// Content run direction. Numeric/identifier values become LTR when `auto`.
  final GeniusPdfDirection contentDirection;

  final GeniusPdfGridDirectionalPadding? headerPadding;
  final GeniusPdfGridDirectionalPadding? cellPadding;

  /// Per-column formatter; highest-precedence formatter hook.
  final GeniusPdfGridFormatter? formatter;
}

/// Context for row builder and conditional row-style callbacks.
class GeniusPdfGridRowContext {
  const GeniusPdfGridRowContext({
    required this.row,
    required this.rowIndex,
    required this.config,
  });

  final GeniusPdfGridRow row;
  final int rowIndex;
  final GeniusPdfConfig config;
}

/// Context for cell builder and conditional cell-style callbacks.
class GeniusPdfGridCellContext {
  const GeniusPdfGridCellContext({
    required this.row,
    required this.rowIndex,
    required this.column,
    required this.columnIndex,
    required this.value,
    required this.config,
  });

  final GeniusPdfGridRow row;
  final int rowIndex;
  final GeniusPdfGridColumn column;
  final int columnIndex;
  final dynamic value;
  final GeniusPdfConfig config;
}

typedef GeniusPdfGridRowBuilder = GeniusPdfGridRow Function(
  GeniusPdfGridRowContext context,
);

typedef GeniusPdfGridRowStyleBuilder = GeniusPdfCellStyle? Function(
  GeniusPdfGridRowContext context,
);

typedef GeniusPdfGridCellStyleBuilder = GeniusPdfCellStyle? Function(
  GeniusPdfGridCellContext context,
);

typedef GeniusPdfGridCellBuilder = GeniusPdfGridCellBuildResult? Function(
  GeniusPdfGridCellContext context,
);

/// Result returned by [GeniusPdfGridCellBuilder].
class GeniusPdfGridCellBuildResult {
  const GeniusPdfGridCellBuildResult({
    this.value,
    this.style,
    this.rowSpan = 1,
    this.columnSpan = 1,
  })  : assert(rowSpan > 0),
        assert(columnSpan > 0);

  final dynamic value;
  final GeniusPdfCellStyle? style;
  final int rowSpan;
  final int columnSpan;
}

/// Explicit row/column span for one source cell.
class GeniusPdfGridCellSpan {
  const GeniusPdfGridCellSpan({
    required this.rowIndex,
    required this.columnId,
    this.rowSpan = 1,
    this.columnSpan = 1,
  })  : assert(rowIndex >= 0),
        assert(rowSpan > 0),
        assert(columnSpan > 0);

  final int rowIndex;
  final String columnId;
  final int rowSpan;
  final int columnSpan;
}

/// Dynamic grouping level built from source rows.
class GeniusPdfGridGroupDefinition {
  const GeniusPdfGridGroupDefinition({
    required this.keySelector,
    this.titleBuilder,
    this.titleArBuilder,
  });

  final Object? Function(GeniusPdfGridRow row) keySelector;
  final String Function(Object? key)? titleBuilder;
  final String Function(Object? key)? titleArBuilder;

  String title(Object? key) => titleBuilder?.call(key) ?? '$key';

  String? titleAr(Object? key) => titleArBuilder?.call(key);
}

typedef GeniusPdfGridCustomAggregate = dynamic Function(
  List<GeniusPdfGridRow> rows,
);

/// Reusable subtotal/grand-total expression.
class GeniusPdfGridSummaryExpression {
  const GeniusPdfGridSummaryExpression({
    required this.outputColumnId,
    required this.aggregate,
    this.sourceColumnId,
    this.label,
    this.labelAr,
    this.labelColumnId,
    this.custom,
  });

  const GeniusPdfGridSummaryExpression.sum({
    required this.outputColumnId,
    required this.sourceColumnId,
    this.label,
    this.labelAr,
    this.labelColumnId,
  })  : aggregate = GeniusPdfGridAggregate.sum,
        custom = null;

  const GeniusPdfGridSummaryExpression.average({
    required this.outputColumnId,
    required this.sourceColumnId,
    this.label,
    this.labelAr,
    this.labelColumnId,
  })  : aggregate = GeniusPdfGridAggregate.average,
        custom = null;

  const GeniusPdfGridSummaryExpression.count({
    required this.outputColumnId,
    this.sourceColumnId,
    this.label,
    this.labelAr,
    this.labelColumnId,
  })  : aggregate = GeniusPdfGridAggregate.count,
        custom = null;

  const GeniusPdfGridSummaryExpression.custom({
    required this.outputColumnId,
    required this.custom,
    this.sourceColumnId,
    this.label,
    this.labelAr,
    this.labelColumnId,
  }) : aggregate = GeniusPdfGridAggregate.custom;

  final String outputColumnId;
  final String? sourceColumnId;
  final GeniusPdfGridAggregate aggregate;
  final String? label;
  final String? labelAr;
  final String? labelColumnId;
  final GeniusPdfGridCustomAggregate? custom;

  dynamic evaluate(List<GeniusPdfGridRow> rows) {
    if (aggregate == GeniusPdfGridAggregate.custom) {
      final callback = custom;
      if (callback == null) {
        throw StateError(
          'A custom summary expression requires a custom callback.',
        );
      }
      return callback(rows);
    }

    if (aggregate == GeniusPdfGridAggregate.count &&
        sourceColumnId == null) {
      return rows.length;
    }

    final sourceId = sourceColumnId;
    if (sourceId == null) {
      throw StateError('$aggregate requires sourceColumnId.');
    }

    final values = <num>[];
    for (final row in rows) {
      var raw = row.cells[sourceId];
      if (raw is _GeniusPdfVNextCellValue) {
        raw = raw.rawValue;
      }

      if (aggregate == GeniusPdfGridAggregate.count) {
        if (raw != null) values.add(1);
        continue;
      }

      if (raw is num) {
        values.add(raw);
      } else if (raw is String) {
        final parsed = double.tryParse(raw.replaceAll(',', '').trim());
        if (parsed != null) values.add(parsed);
      }
    }

    if (aggregate == GeniusPdfGridAggregate.count) {
      return values.length;
    }
    if (values.isEmpty) return 0.0;

    switch (aggregate) {
      case GeniusPdfGridAggregate.sum:
        return values.fold<num>(0, (sum, value) => sum + value);
      case GeniusPdfGridAggregate.average:
        return values.fold<num>(0, (sum, value) => sum + value) /
            values.length;
      case GeniusPdfGridAggregate.min:
        return values.reduce((a, b) => a < b ? a : b);
      case GeniusPdfGridAggregate.max:
        return values.reduce((a, b) => a > b ? a : b);
      case GeniusPdfGridAggregate.count:
        return values.length;
      case GeniusPdfGridAggregate.custom:
        throw StateError('Custom aggregate was handled before this switch.');
    }
  }
}

/// Abstract lazy row source for large ERP grids.
abstract class GeniusPdfGridRowSource {
  const GeniusPdfGridRowSource();

  int get length;

  GeniusPdfGridRow rowAt(int index);
}

/// List-backed row source.
class GeniusPdfGridListRowSource extends GeniusPdfGridRowSource {
  const GeniusPdfGridListRowSource(this.rows);

  final List<GeniusPdfGridRow> rows;

  @override
  int get length => rows.length;

  @override
  GeniusPdfGridRow rowAt(int index) => rows[index];
}

/// Generator-backed lazy row source.
class GeniusPdfGridLazyRowSource extends GeniusPdfGridRowSource {
  const GeniusPdfGridLazyRowSource({
    required this.length,
    required this.builder,
  });

  @override
  final int length;

  final GeniusPdfGridRow Function(int index) builder;

  @override
  GeniusPdfGridRow rowAt(int index) => builder(index);
}

/// Large-data preparation options.
class GeniusPdfGridPerformanceOptions {
  const GeniusPdfGridPerformanceOptions({
    this.veryLargeDataMode = false,
    this.autoFitSampleSize = 100,
    this.cacheMeasuredWidths = true,
    this.cacheResolvedStyles = true,
  }) : assert(autoFitSampleSize > 0);

  final bool veryLargeDataMode;
  final int autoFitSampleSize;
  final bool cacheMeasuredWidths;
  final bool cacheResolvedStyles;
}

/// Empty-grid presentation.
class GeniusPdfGridEmptyState {
  const GeniusPdfGridEmptyState({
    this.message = 'No data',
    this.messageAr = 'لا توجد بيانات',
    this.style,
  });

  final String message;
  final String messageAr;
  final GeniusPdfCellStyle? style;
}

/// Debit/credit and negative-value styles.
class GeniusPdfGridAccountingStyle {
  const GeniusPdfGridAccountingStyle({
    this.debitStyle,
    this.creditStyle,
    this.negativeStyle,
  });

  final GeniusPdfCellStyle? debitStyle;
  final GeniusPdfCellStyle? creditStyle;
  final GeniusPdfCellStyle? negativeStyle;
}

/// Preparation benchmark diagnostics.
class GeniusPdfGridBenchmarkResult {
  const GeniusPdfGridBenchmarkResult({
    required this.requestedRows,
    required this.preparedRows,
    required this.preparationMicros,
    required this.widthResolutionMicros,
    required this.widthCacheHit,
    required this.measuredColumnCount,
  });

  final int requestedRows;
  final int preparedRows;
  final int preparationMicros;
  final int widthResolutionMicros;
  final bool widthCacheHit;
  final int measuredColumnCount;

  Duration get preparationDuration =>
      Duration(microseconds: preparationMicros);

  Duration get widthResolutionDuration =>
      Duration(microseconds: widthResolutionMicros);

  @override
  String toString() {
    return 'GeniusPdfGridBenchmarkResult('
        'requestedRows=$requestedRows, '
        'preparedRows=$preparedRows, '
        'preparation=${preparationDuration.inMilliseconds}ms, '
        'widths=${widthResolutionDuration.inMilliseconds}ms, '
        'widthCacheHit=$widthCacheHit, '
        'measuredColumns=$measuredColumnCount)';
  }
}

class _GeniusPdfVNextCellValue {
  const _GeniusPdfVNextCellValue({
    required this.text,
    required this.rawValue,
    this.style,
  });

  final String text;
  final dynamic rawValue;
  final GeniusPdfCellStyle? style;

  @override
  String toString() => text;
}

class _GeniusPdfPreparedRow {
  const _GeniusPdfPreparedRow({
    required this.sourceIndex,
    required this.sourceRow,
    required this.row,
    required this.rowSpans,
  });

  final int sourceIndex;
  final GeniusPdfGridRow sourceRow;
  final GeniusPdfGridRow row;
  final Map<String, int> rowSpans;
}

class _GeniusPdfPreparedGroup {
  const _GeniusPdfPreparedGroup({
    required this.key,
    required this.title,
    required this.titleAr,
    required this.level,
    required this.rows,
    required this.children,
  });

  final Object? key;
  final String title;
  final String? titleAr;
  final int level;
  final List<_GeniusPdfPreparedRow> rows;
  final List<_GeniusPdfPreparedGroup> children;

  List<_GeniusPdfPreparedRow> get allRows {
    if (children.isEmpty) return rows;
    final result = <_GeniusPdfPreparedRow>[];
    for (final child in children) {
      result.addAll(child.allRows);
    }
    return result;
  }
}

class _GeniusPdfPreparedGrid {
  const _GeniusPdfPreparedGrid({
    required this.columns,
    required this.rows,
    required this.groups,
    required this.widths,
    required this.widthCacheHit,
    required this.measuredColumnCount,
  });

  final List<GeniusPdfGridColumn> columns;
  final List<_GeniusPdfPreparedRow> rows;
  final List<_GeniusPdfPreparedGroup> groups;
  final List<double> widths;
  final bool widthCacheHit;
  final int measuredColumnCount;
}

class _GeniusPdfWidthResult {
  const _GeniusPdfWidthResult({
    required this.widths,
    required this.cacheHit,
    required this.measuredColumnCount,
  });

  final List<double> widths;
  final bool cacheHit;
  final int measuredColumnCount;
}

/// ERP-grade DataGrid preparation layer introduced by Sprint S04.
///
/// The class composes [GeniusPdfDataGrid] so existing low-level rendering,
/// theming and pagination behavior remain the single drawing implementation.
class GeniusPdfDataGridVNext {
  GeniusPdfDataGridVNext({
    required this.columns,
    required this.config,
    this.rows = const [],
    this.rowSource,
    this.style,
    this.columnPolicies = const {},
    this.groupBy = const [],
    this.groupSummaries = const [],
    this.grandTotals = const [],
    this.cellSpans = const [],
    this.rowBuilder,
    this.cellBuilder,
    this.rowStyleBuilder,
    this.cellStyleBuilder,
    this.formatters = const GeniusPdfGridFormatterHooks(),
    this.accountingStyle = const GeniusPdfGridAccountingStyle(),
    this.emptyState = const GeniusPdfGridEmptyState(),
    this.followDirection = true,
    this.preserveDefinitionOrder = false,
    this.repeatHeaderOnPages = true,
    this.repeatGroupHeaders = true,
    this.rowSplitPolicy = GeniusPdfGridRowSplitPolicy.keepTogether,
    this.groupIndentPerLevel = 12,
    this.groupGap = 6,
    this.performance = const GeniusPdfGridPerformanceOptions(),
  }) : assert(
          rowSource == null || rows.isEmpty,
          'Provide rows or rowSource, not both.',
        );

  final List<GeniusPdfGridColumn> columns;
  final List<GeniusPdfGridRow> rows;
  final GeniusPdfGridRowSource? rowSource;
  final GeniusPdfConfig config;
  final GeniusPdfGridStyle? style;
  final Map<String, GeniusPdfGridColumnPolicy> columnPolicies;
  final List<GeniusPdfGridGroupDefinition> groupBy;
  final List<GeniusPdfGridSummaryExpression> groupSummaries;
  final List<GeniusPdfGridSummaryExpression> grandTotals;
  final List<GeniusPdfGridCellSpan> cellSpans;
  final GeniusPdfGridRowBuilder? rowBuilder;
  final GeniusPdfGridCellBuilder? cellBuilder;
  final GeniusPdfGridRowStyleBuilder? rowStyleBuilder;
  final GeniusPdfGridCellStyleBuilder? cellStyleBuilder;
  final GeniusPdfGridFormatterHooks formatters;
  final GeniusPdfGridAccountingStyle accountingStyle;
  final GeniusPdfGridEmptyState emptyState;
  final bool followDirection;
  final bool preserveDefinitionOrder;
  final bool repeatHeaderOnPages;
  final bool repeatGroupHeaders;
  final GeniusPdfGridRowSplitPolicy rowSplitPolicy;
  final double groupIndentPerLevel;
  final double groupGap;
  final GeniusPdfGridPerformanceOptions performance;

  static final Map<String, List<double>> _widthCache =
      <String, List<double>>{};

  final Map<String, GeniusPdfCellStyle> _styleCache =
      <String, GeniusPdfCellStyle>{};

  int get sourceRowCount => rowSource?.length ?? rows.length;

  static void clearWidthCache() => _widthCache.clear();

  /// Runs the S04 preparation benchmark without drawing PDF pages.
  GeniusPdfGridBenchmarkResult benchmark({
    required double availableWidth,
    int? rowLimit,
  }) {
    final requestedCandidate = rowLimit ?? sourceRowCount;
    final requested = requestedCandidate < sourceRowCount
        ? requestedCandidate
        : sourceRowCount;

    final prepareWatch = Stopwatch()..start();
    final source = _materializeSourceRows(limit: requested);
    prepareWatch.stop();

    final widthWatch = Stopwatch()..start();
    final widthResult = _resolveColumnWidths(source, availableWidth);
    widthWatch.stop();

    _prepareRows(source, widthResult.widths);

    return GeniusPdfGridBenchmarkResult(
      requestedRows: requested,
      preparedRows: source.length,
      preparationMicros: prepareWatch.elapsedMicroseconds,
      widthResolutionMicros: widthWatch.elapsedMicroseconds,
      widthCacheHit: widthResult.cacheHit,
      measuredColumnCount: widthResult.measuredColumnCount,
    );
  }

  /// Draws the grid using the existing [GeniusPdfDataGrid] renderer.
  PdfLayoutResult? draw({
    required PdfPage page,
    required Rect bounds,
    PdfLayoutFormat? layoutFormat,
  }) {
    final prepared = _prepare(availableWidth: bounds.width);

    if (prepared.rows.isEmpty) {
      return _drawEmpty(
        page: page,
        bounds: bounds,
        columns: prepared.columns,
        layoutFormat: layoutFormat,
      );
    }

    if (prepared.groups.isEmpty) {
      return _drawPreparedRows(
        page: page,
        bounds: bounds,
        columns: prepared.columns,
        preparedRows: prepared.rows,
        footerRows: _grandTotalRows(prepared.rows),
        layoutFormat: layoutFormat,
      );
    }

    return _drawGrouped(
      page: page,
      bounds: bounds,
      prepared: prepared,
      layoutFormat: layoutFormat,
    );
  }

  _GeniusPdfPreparedGrid _prepare({
    required double availableWidth,
    int? rowLimit,
  }) {
    final source = _materializeSourceRows(limit: rowLimit);
    final widthResult = _resolveColumnWidths(source, availableWidth);
    final preparedRows = _prepareRows(source, widthResult.widths);
    final preparedColumns = _prepareColumns(widthResult.widths);
    final groups = _buildGroups(preparedRows);

    return _GeniusPdfPreparedGrid(
      columns: preparedColumns,
      rows: preparedRows,
      groups: groups,
      widths: widthResult.widths,
      widthCacheHit: widthResult.cacheHit,
      measuredColumnCount: widthResult.measuredColumnCount,
    );
  }

  List<GeniusPdfGridRow> _materializeSourceRows({int? limit}) {
    final candidate = limit ?? sourceRowCount;
    final count = candidate < sourceRowCount ? candidate : sourceRowCount;
    final result = <GeniusPdfGridRow>[];

    for (var index = 0; index < count; index++) {
      final source = rowSource?.rowAt(index) ?? rows[index];
      final context = GeniusPdfGridRowContext(
        row: source,
        rowIndex: index,
        config: config,
      );
      result.add(rowBuilder?.call(context) ?? source);
    }

    return result;
  }

  List<_GeniusPdfPreparedRow> _prepareRows(
    List<GeniusPdfGridRow> source,
    List<double> widths,
  ) {
    final result = <_GeniusPdfPreparedRow>[];

    for (var rowIndex = 0; rowIndex < source.length; rowIndex++) {
      final sourceRow = source[rowIndex];
      final rowContext = GeniusPdfGridRowContext(
        row: sourceRow,
        rowIndex: rowIndex,
        config: config,
      );

      final resolvedRowStyle =
          rowStyleBuilder?.call(rowContext) ?? sourceRow.style;
      final cells = Map<String, dynamic>.from(sourceRow.cells);
      final columnSpans = Map<String, int>.from(
        sourceRow.span ?? const <String, int>{},
      );
      final rowSpans = <String, int>{};

      for (var columnIndex = 0;
          columnIndex < columns.length;
          columnIndex++) {
        final column = columns[columnIndex];
        final policy =
            columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
        final raw = cells[column.id];

        final cellContext = GeniusPdfGridCellContext(
          row: sourceRow,
          rowIndex: rowIndex,
          column: column,
          columnIndex: columnIndex,
          value: raw,
          config: config,
        );

        final custom = cellBuilder?.call(cellContext);
        final effectiveRaw = custom?.value ?? raw;
        final conditionalStyle =
            custom?.style ?? cellStyleBuilder?.call(cellContext);

        var display = _formatValue(
          value: effectiveRaw,
          row: sourceRow,
          rowIndex: rowIndex,
          column: column,
          policy: policy,
        );

        display = _applyOverflow(
          display,
          policy,
          widths[columnIndex],
        );

        final semanticStyle = _semanticCellStyle(
          value: effectiveRaw,
          policy: policy,
        );

        cells[column.id] = _GeniusPdfVNextCellValue(
          text: display,
          rawValue: effectiveRaw,
          style: conditionalStyle ?? semanticStyle,
        );

        GeniusPdfGridCellSpan? explicitSpan;
        for (final span in cellSpans) {
          if (span.rowIndex == rowIndex &&
              span.columnId == column.id) {
            explicitSpan = span;
          }
        }

        final columnSpan = custom?.columnSpan ??
            explicitSpan?.columnSpan ??
            1;
        final rowSpan = custom?.rowSpan ??
            explicitSpan?.rowSpan ??
            1;

        if (columnSpan > 1) {
          columnSpans[column.id] = columnSpan;
        }
        if (rowSpan > 1) {
          rowSpans[column.id] = rowSpan;
        }
      }

      result.add(
        _GeniusPdfPreparedRow(
          sourceIndex: rowIndex,
          sourceRow: sourceRow,
          row: sourceRow.copyWith(
            cells: cells,
            style: resolvedRowStyle,
            span: columnSpans.isEmpty ? null : columnSpans,
          ),
          rowSpans: rowSpans,
        ),
      );
    }

    return result;
  }

  List<GeniusPdfGridColumn> _prepareColumns(List<double> widths) {
    final logical = <GeniusPdfGridColumn>[];

    for (var index = 0; index < columns.length; index++) {
      final base = columns[index];
      final policy =
          columnPolicies[base.id] ?? const GeniusPdfGridColumnPolicy();

      final headerStyle = _withDirectionalPadding(
        base.headerStyle,
        policy.headerPadding,
      );
      final cellStyle = _withDirectionalPadding(
        base.cellStyle,
        policy.cellPadding,
      );
      final isNumeric = base.isNumeric || _isNumericKind(policy.valueKind);

      logical.add(
        GeniusPdfGridColumn(
          id: base.id,
          title: base.title,
          titleAr: base.titleAr,
          subtitle: base.subtitle,
          subtitleAr: base.subtitleAr,
          width: widths[index],
          minWidth: widths[index],
          maxWidth: widths[index],
          flexFactor: null,
          alignment: isNumeric ? GeniusPdfTextAlign.end : base.alignment,
          verticalAlignment: base.verticalAlignment,
          headerAlignment: base.headerAlignment,
          headerStyle: headerStyle,
          cellStyle: cellStyle,
          cellStyleBuilder: (value) {
            if (value is _GeniusPdfVNextCellValue && value.style != null) {
              return value.style;
            }
            return cellStyle;
          },
          valueFormatter: (value) {
            if (value is _GeniusPdfVNextCellValue) {
              return value.text;
            }
            if (value == null) return '';
            return _formatValue(
              value: value,
              row: GeniusPdfGridRow(
                cells: <String, dynamic>{base.id: value},
              ),
              rowIndex: -1,
              column: base,
              policy: policy,
            );
          },
          isNumeric: isNumeric,
          isVisible: base.isVisible,
          isSortable: base.isSortable,
          sortDirection: base.sortDirection,
          wrapText: policy.overflow == GeniusPdfGridTextOverflow.wrap,
          maxLines: policy.maxLines ?? base.maxLines,
          ellipsis: base.ellipsis,
          tooltip: base.tooltip,
          tooltipAr: base.tooltipAr,
        ),
      );
    }

    // Legacy DataGrid mirrors definitions for RTL. Reverse the source only
    // when the caller wants physical definition order preserved.
    if (config.isRTL && (!followDirection || preserveDefinitionOrder)) {
      return logical.reversed.toList();
    }
    return logical;
  }

  GeniusPdfCellStyle? _withDirectionalPadding(
    GeniusPdfCellStyle? source,
    GeniusPdfGridDirectionalPadding? padding,
  ) {
    if (padding == null) return source;
    final base = source ?? const GeniusPdfCellStyle();
    return base.copyWith(
      padding: padding.resolve(config.isRTL),
    );
  }

  String _formatValue({
    required dynamic value,
    required GeniusPdfGridRow row,
    required int rowIndex,
    required GeniusPdfGridColumn column,
    required GeniusPdfGridColumnPolicy policy,
  }) {
    final currency =
        policy.currencyResolver?.call(row) ?? policy.currencyCode;
    final context = GeniusPdfGridFormatContext(
      value: value,
      row: row,
      column: column,
      rowIndex: rowIndex,
      config: config,
      currencyCode: currency,
    );

    // S04 custom column formatter remains highest precedence.
    if (policy.formatter != null) {
      return policy.formatter!(context);
    }

    // Explicit S05 column specification is next.
    if (column.formatSpec != null) {
      return config.formatter.format(
        value,
        column.formatSpec!,
        isRtl: config.isRTL,
      );
    }

    switch (policy.valueKind) {
      case GeniusPdfGridValueKind.money:
      case GeniusPdfGridValueKind.debit:
      case GeniusPdfGridValueKind.credit:
        if (formatters.money != null) return formatters.money!(context);
        return config.formatter.formatMoney(
          value,
          currencyCode: currency,
          decimalPlaces: policy.decimalPlaces,
          negativeFormat: policy.accountingNegative
              ? GeniusPdfNegativeFormat.accounting
              : null,
        );
      case GeniusPdfGridValueKind.number:
        if (formatters.number != null) return formatters.number!(context);
        return config.formatter.formatNumber(
          value,
          decimalPlaces: policy.decimalPlaces,
          negativeFormat: policy.accountingNegative
              ? GeniusPdfNegativeFormat.accounting
              : null,
        );
      case GeniusPdfGridValueKind.percentage:
        if (formatters.percentage != null) return formatters.percentage!(context);
        return config.formatter.formatPercentage(
          value,
          decimalPlaces: policy.decimalPlaces,
          isFraction: policy.percentageIsFraction,
        );
      case GeniusPdfGridValueKind.quantity:
        if (formatters.quantity != null) return formatters.quantity!(context);
        return config.formatter.formatQuantity(
          value,
          decimalPlaces: policy.decimalPlaces,
          isRtl: config.isRTL,
        );
      case GeniusPdfGridValueKind.date:
        if (formatters.date != null) return formatters.date!(context);
        return config.formatter.formatDate(value);
      case GeniusPdfGridValueKind.dateTime:
        if (formatters.dateTime != null) return formatters.dateTime!(context);
        return config.formatter.formatDateTime(value);
      case GeniusPdfGridValueKind.identifier:
        if (formatters.identifier != null) return formatters.identifier!(context);
        return config.formatter.formatIdentifier(value);
      case GeniusPdfGridValueKind.text:
        return value == null
            ? config.formatter.settings.nullPolicy.placeholder
            : value.toString();
    }
  }

  GeniusPdfCellStyle? _semanticCellStyle({
    required dynamic value,
    required GeniusPdfGridColumnPolicy policy,
  }) {
    if (policy.valueKind == GeniusPdfGridValueKind.debit) {
      return accountingStyle.debitStyle;
    }
    if (policy.valueKind == GeniusPdfGridValueKind.credit) {
      return accountingStyle.creditStyle;
    }

    final number = _asNumber(value);
    if (number != null &&
        number < 0 &&
        accountingStyle.negativeStyle != null) {
      return accountingStyle.negativeStyle;
    }
    return null;
  }

  String _applyOverflow(
    String value,
    GeniusPdfGridColumnPolicy policy,
    double width,
  ) {
    if (value.isEmpty ||
        policy.overflow == GeniusPdfGridTextOverflow.wrap) {
      return value;
    }

    final estimatedCharWidth = math.max(
      1.0,
      config.baseFontSize * 0.52,
    ).toDouble();
    final maxChars = math.max(
      1,
      (width / estimatedCharWidth).floor(),
    ).toInt();

    if (value.length <= maxChars) return value;

    switch (policy.overflow) {
      case GeniusPdfGridTextOverflow.wrap:
        return value;
      case GeniusPdfGridTextOverflow.clip:
        return value.substring(0, maxChars);
      case GeniusPdfGridTextOverflow.ellipsis:
        if (maxChars <= 3) {
          return List<String>.filled(maxChars, '.').join();
        }
        return '${value.substring(0, maxChars - 3)}...';
    }
  }

  _GeniusPdfWidthResult _resolveColumnWidths(
    List<GeniusPdfGridRow> rows,
    double availableWidth,
  ) {
    if (columns.isEmpty) {
      return const _GeniusPdfWidthResult(
        widths: <double>[],
        cacheHit: false,
        measuredColumnCount: 0,
      );
    }

    final cacheKey = _widthCacheKey(availableWidth, rows.length);
    if (performance.cacheMeasuredWidths) {
      final cached = _widthCache[cacheKey];
      if (cached != null && cached.length == columns.length) {
        return _GeniusPdfWidthResult(
          widths: List<double>.from(cached),
          cacheHit: true,
          measuredColumnCount: 0,
        );
      }
    }

    final widths = List<double>.filled(columns.length, 0);
    final flexIndexes = <int>[];
    final autoIndexes = <int>[];
    var allocated = 0.0;
    var measuredColumnCount = 0;

    for (var index = 0; index < columns.length; index++) {
      final column = columns[index];
      if (!column.isVisible) continue;

      final policy =
          columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
      final mode = policy.widthMode ?? _inferWidthMode(column);

      switch (mode) {
        case GeniusPdfGridWidthMode.fixed:
          final candidate = policy.fixedWidth ??
              column.width ??
              (column.widthPercent == null
                  ? null
                  : availableWidth * column.widthPercent!) ??
              policy.minWidth ??
              column.minWidth ??
              60;
          final width = _clampWidth(candidate, policy, column);
          widths[index] = width;
          allocated += width;
          break;
        case GeniusPdfGridWidthMode.flex:
          flexIndexes.add(index);
          break;
        case GeniusPdfGridWidthMode.autoFit:
          autoIndexes.add(index);
          break;
      }
    }

    for (final index in autoIndexes) {
      final column = columns[index];
      final policy =
          columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
      var sampleLimit = policy.autoFitSampleSize;
      if (performance.autoFitSampleSize < sampleLimit) {
        sampleLimit = performance.autoFitSampleSize;
      }
      if (rows.length < sampleLimit) sampleLimit = rows.length;

      var measured = config.baseFont.measureString(
        column.getTitle(isArabic: config.isRTL),
      ).width;

      for (var rowIndex = 0; rowIndex < sampleLimit; rowIndex++) {
        final raw = rows[rowIndex].cells[column.id];
        if (raw == null) continue;
        final candidate = config.baseFont.measureString(raw.toString()).width;
        if (candidate > measured) measured = candidate;
      }

      final width = _clampWidth(
        measured + 12,
        policy,
        column,
      );
      widths[index] = width;
      allocated += width;
      measuredColumnCount++;
    }

    final remaining = availableWidth > allocated
        ? availableWidth - allocated
        : 0.0;
    var totalFlex = 0.0;

    for (final index in flexIndexes) {
      final column = columns[index];
      final policy =
          columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
      totalFlex += policy.flex;
    }

    for (final index in flexIndexes) {
      final column = columns[index];
      final policy =
          columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
      final rawWidth = totalFlex <= 0
          ? 0.0
          : remaining * (policy.flex / totalFlex);
      widths[index] = _clampWidth(
        rawWidth,
        policy,
        column,
      );
    }

    _fitWidthsToAvailable(widths, availableWidth);

    if (performance.cacheMeasuredWidths) {
      _widthCache[cacheKey] = List<double>.from(widths);
    }

    return _GeniusPdfWidthResult(
      widths: widths,
      cacheHit: false,
      measuredColumnCount: measuredColumnCount,
    );
  }

  GeniusPdfGridWidthMode _inferWidthMode(GeniusPdfGridColumn column) {
    if (column.width != null || column.widthPercent != null) {
      return GeniusPdfGridWidthMode.fixed;
    }
    if (column.flexFactor != null) {
      return GeniusPdfGridWidthMode.flex;
    }
    return GeniusPdfGridWidthMode.autoFit;
  }

  double _clampWidth(
    double width,
    GeniusPdfGridColumnPolicy policy,
    GeniusPdfGridColumn column,
  ) {
    final minWidth = policy.minWidth ?? column.minWidth ?? 20;
    final maxWidth =
        policy.maxWidth ?? column.maxWidth ?? double.infinity;
    return width.clamp(minWidth, maxWidth).toDouble();
  }

  void _fitWidthsToAvailable(
    List<double> widths,
    double availableWidth,
  ) {
    final total = widths.fold<double>(
      0,
      (sum, width) => sum + width,
    );
    if (total <= availableWidth || total <= 0) return;

    final scalable = <int>[];
    var fixedTotal = 0.0;

    for (var index = 0; index < columns.length; index++) {
      final policy =
          columnPolicies[columns[index].id] ??
          const GeniusPdfGridColumnPolicy();
      final mode = policy.widthMode ?? _inferWidthMode(columns[index]);
      if (mode == GeniusPdfGridWidthMode.fixed) {
        fixedTotal += widths[index];
      } else {
        scalable.add(index);
      }
    }

    final scalableAvailable =
        availableWidth > fixedTotal ? availableWidth - fixedTotal : 0.0;
    final scalableTotal = scalable.fold<double>(
      0,
      (sum, index) => sum + widths[index],
    );
    if (scalableTotal <= 0) return;

    final ratio = scalableAvailable / scalableTotal;
    for (final index in scalable) {
      final policy =
          columnPolicies[columns[index].id] ??
          const GeniusPdfGridColumnPolicy();
      widths[index] = _clampWidth(
        widths[index] * ratio,
        policy,
        columns[index],
      );
    }
  }

  String _widthCacheKey(double availableWidth, int rowCount) {
    final buffer = StringBuffer()
      ..write(availableWidth.toStringAsFixed(2))
      ..write('|')
      ..write(config.isRTL ? 'rtl' : 'ltr')
      ..write('|')
      ..write(rowCount)
      ..write('|')
      ..write(performance.veryLargeDataMode);

    for (final column in columns) {
      final policy =
          columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
      buffer
        ..write('|')
        ..write(column.id)
        ..write(':')
        ..write(policy.widthMode)
        ..write(':')
        ..write(policy.fixedWidth)
        ..write(':')
        ..write(policy.flex)
        ..write(':')
        ..write(policy.minWidth)
        ..write(':')
        ..write(policy.maxWidth);
    }
    return buffer.toString();
  }

  List<_GeniusPdfPreparedGroup> _buildGroups(
    List<_GeniusPdfPreparedRow> rows,
  ) {
    if (groupBy.isEmpty || rows.isEmpty) {
      return const <_GeniusPdfPreparedGroup>[];
    }
    return _groupLevel(rows, level: 0);
  }

  List<_GeniusPdfPreparedGroup> _groupLevel(
    List<_GeniusPdfPreparedRow> rows, {
    required int level,
  }) {
    if (level >= groupBy.length) {
      return const <_GeniusPdfPreparedGroup>[];
    }

    final definition = groupBy[level];
    final buckets = <Object?, List<_GeniusPdfPreparedRow>>{};

    for (final prepared in rows) {
      final key = definition.keySelector(prepared.sourceRow);
      buckets.putIfAbsent(key, () => <_GeniusPdfPreparedRow>[]).add(prepared);
    }

    final result = <_GeniusPdfPreparedGroup>[];
    for (final entry in buckets.entries) {
      final children = level + 1 < groupBy.length
          ? _groupLevel(entry.value, level: level + 1)
          : const <_GeniusPdfPreparedGroup>[];

      result.add(
        _GeniusPdfPreparedGroup(
          key: entry.key,
          title: definition.title(entry.key),
          titleAr: definition.titleAr(entry.key),
          level: level,
          rows: children.isEmpty
              ? entry.value
              : const <_GeniusPdfPreparedRow>[],
          children: children,
        ),
      );
    }

    return result;
  }

  GeniusPdfGridGroup _toLegacyGroup(
    _GeniusPdfPreparedGroup group, {
    bool suppressHeader = false,
  }) {
    final allRows = group.allRows;
    final summary = groupSummaries.isEmpty
        ? null
        : _summaryRow(
            allRows,
            groupSummaries,
            subtotal: true,
          );

    return GeniusPdfGridGroup(
      title: group.title,
      titleAr: group.titleAr,
      rows: group.children.isEmpty
          ? group.rows.map((item) => item.row).toList()
          : const <GeniusPdfGridRow>[],
      subgroups: group.children.isEmpty
          ? null
          : group.children
              .map((child) => _toLegacyGroup(child))
              .toList(),
      summary: summary,
      level: group.level,
      showHeader: !suppressHeader,
      showSummary: summary != null,
      headerStyle: _groupHeaderStyle(group.level),
      summaryStyle: _resolvedStyle(
        'group-summary-${group.level}',
        style?.subtotalRowStyle ??
            style?.totalRowStyle ??
            const GeniusPdfCellStyle.total(),
      ),
    );
  }

  GeniusPdfCellStyle _groupHeaderStyle(int level) {
    final key = 'group-header-$level-${config.isRTL}';
    final cached = performance.cacheResolvedStyles ? _styleCache[key] : null;
    if (cached != null) return cached;

    final base = style?.groupHeaderStyle ??
        const GeniusPdfCellStyle(
          textStyle: GeniusPdfTextStyle(
            fontWeight: material.FontWeight.bold,
          ),
          backgroundColor: Color(0xFFE8E8E8),
          padding: GeniusPdfCellPadding.all(4),
        );

    final indent = level * groupIndentPerLevel;
    final resolved = base.copyWith(
      padding: GeniusPdfCellPadding(
        left: config.isRTL
            ? base.padding.left
            : base.padding.left + indent,
        right: config.isRTL
            ? base.padding.right + indent
            : base.padding.right,
        top: base.padding.top,
        bottom: base.padding.bottom,
      ),
    );

    if (performance.cacheResolvedStyles) {
      _styleCache[key] = resolved;
    }
    return resolved;
  }

  GeniusPdfCellStyle _resolvedStyle(
    String key,
    GeniusPdfCellStyle value,
  ) {
    if (!performance.cacheResolvedStyles) return value;
    return _styleCache.putIfAbsent(key, () => value);
  }

  GeniusPdfGridRow _summaryRow(
    List<_GeniusPdfPreparedRow> rows,
    List<GeniusPdfGridSummaryExpression> expressions, {
    required bool subtotal,
  }) {
    final cells = <String, dynamic>{};
    final sourceRows = rows.map((item) => item.sourceRow).toList();

    for (final expression in expressions) {
      cells[expression.outputColumnId] =
          expression.evaluate(sourceRows);

      final labelColumn = expression.labelColumnId;
      if (labelColumn != null) {
        final label = config.isRTL
            ? (expression.labelAr ?? expression.label)
            : (expression.label ?? expression.labelAr);
        if (label != null) cells[labelColumn] = label;
      }
    }

    return subtotal
        ? GeniusPdfGridRow.subtotal(cells)
        : GeniusPdfGridRow.total(cells);
  }

  List<GeniusPdfGridRow>? _grandTotalRows(
    List<_GeniusPdfPreparedRow> rows,
  ) {
    if (grandTotals.isEmpty) return null;
    return <GeniusPdfGridRow>[
      _summaryRow(rows, grandTotals, subtotal: false),
    ];
  }

  GeniusPdfGridStyle _effectiveStyle({
    bool showHeader = true,
  }) {
    final base = style ?? GeniusPdfDataGrid._resolveGridStyle(null, config);
    return base.copyWith(
      showHeader: showHeader,
      repeatHeaderOnPages: repeatHeaderOnPages && showHeader,
    );
  }

  PdfLayoutResult? _drawPreparedRows({
    required PdfPage page,
    required Rect bounds,
    required List<GeniusPdfGridColumn> columns,
    required List<_GeniusPdfPreparedRow> preparedRows,
    List<GeniusPdfGridRow>? footerRows,
    PdfLayoutFormat? layoutFormat,
    String? repeatedGroupTitle,
    String? repeatedGroupTitleAr,
    int groupLevel = 0,
  }) {
    final legacy = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: preparedRows.map((item) => item.row).toList(),
      footerRows: footerRows,
      style: _effectiveStyle(),
    );

    final grid = legacy._buildGrid(
      page,
      availableWidth: bounds.width,
    );
    grid.allowRowBreakingAcrossPages =
        rowSplitPolicy == GeniusPdfGridRowSplitPolicy.allowSplit;

    if (repeatGroupHeaders &&
        repeatedGroupTitle != null &&
        columns.isNotEmpty) {
      final header = grid.headers.add(1)[0];
      header.cells[0].value = config.isRTL
          ? (repeatedGroupTitleAr ?? repeatedGroupTitle)
          : repeatedGroupTitle;
      header.cells[0].columnSpan = columns.length;
      final groupStyle = _groupHeaderStyle(groupLevel);
      legacy._applyRowStyle(
        header,
        groupStyle,
        isGroupHeader: true,
      );
      legacy._applyCellStyle(
        header.cells[0],
        groupStyle,
        columns.first,
        isFirstColumn: true,
        isLastColumn: true,
      );
      grid.repeatHeader = true;
    }

    _applyCellPolicies(
      grid,
      columns,
      preparedRows,
    );

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

  void _applyCellPolicies(
    PdfGrid grid,
    List<GeniusPdfGridColumn> preparedColumns,
    List<_GeniusPdfPreparedRow> preparedRows,
  ) {
    final physicalColumns = _physicalColumns(preparedColumns);

    // Header run direction.
    if (grid.headers.count > 0) {
      final columnHeader = grid.headers[0];
      for (var columnIndex = 0;
          columnIndex < physicalColumns.length;
          columnIndex++) {
        final column = physicalColumns[columnIndex];
        final policy =
            columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
        _setCellDirection(
          columnHeader.cells[columnIndex],
          _resolveDirection(
            policy.headerDirection,
            numericOrIdentifier: false,
          ),
          isNumeric: false,
        );
      }
    }

    for (var rowIndex = 0;
        rowIndex < preparedRows.length &&
            rowIndex < grid.rows.count;
        rowIndex++) {
      final prepared = preparedRows[rowIndex];

      for (var columnIndex = 0;
          columnIndex < physicalColumns.length;
          columnIndex++) {
        final column = physicalColumns[columnIndex];
        final policy =
            columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
        final raw = prepared.sourceRow.cells[column.id];
        final numericOrIdentifier =
            _isNumericKind(policy.valueKind) ||
            column.isNumeric ||
            _looksLikeIdentifier(raw);

        _setCellDirection(
          grid.rows[rowIndex].cells[columnIndex],
          _resolveDirection(
            policy.contentDirection,
            numericOrIdentifier: numericOrIdentifier,
          ),
          isNumeric: _isNumericKind(policy.valueKind) || column.isNumeric,
        );

        final rowSpan = prepared.rowSpans[column.id];
        if (rowSpan != null && rowSpan > 1) {
          grid.rows[rowIndex].cells[columnIndex].rowSpan = rowSpan;
        }
      }
    }

    // Footer/grand-total rows use the same per-column direction policy.
    for (var rowIndex = preparedRows.length;
        rowIndex < grid.rows.count;
        rowIndex++) {
      _applySummaryRowPolicies(
        grid.rows[rowIndex],
        preparedColumns,
      );
    }
  }

  void _applySummaryRowPolicies(
    PdfGridRow gridRow,
    List<GeniusPdfGridColumn> preparedColumns,
  ) {
    final physicalColumns = _physicalColumns(preparedColumns);
    for (var columnIndex = 0;
        columnIndex < physicalColumns.length;
        columnIndex++) {
      final column = physicalColumns[columnIndex];
      final policy =
          columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
      final numeric = _isNumericKind(policy.valueKind) || column.isNumeric;
      _setCellDirection(
        gridRow.cells[columnIndex],
        _resolveDirection(
          policy.contentDirection,
          numericOrIdentifier: numeric,
        ),
        isNumeric: numeric,
      );
    }
  }

  List<GeniusPdfGridColumn> _physicalColumns(
    List<GeniusPdfGridColumn> preparedColumns,
  ) {
    return config.isRTL
        ? preparedColumns.reversed.toList()
        : preparedColumns;
  }

  GeniusPdfDirection _resolveDirection(
    GeniusPdfDirection requested, {
    required bool numericOrIdentifier,
  }) {
    if (requested != GeniusPdfDirection.auto) return requested;
    if (numericOrIdentifier) return GeniusPdfDirection.ltr;
    return config.isRTL ? GeniusPdfDirection.rtl : GeniusPdfDirection.ltr;
  }

  void _setCellDirection(
    PdfGridCell cell,
    GeniusPdfDirection direction, {
    required bool isNumeric,
  }) {
    final existing = cell.style.stringFormat ?? PdfStringFormat();
    cell.style.stringFormat = PdfStringFormat(
      alignment: isNumeric
          ? PdfTextAlignment.right
          : existing.alignment,
      lineAlignment: existing.lineAlignment,
      textDirection: direction == GeniusPdfDirection.rtl
          ? PdfTextDirection.rightToLeft
          : PdfTextDirection.leftToRight,
    );
  }

  PdfLayoutResult? _drawGrouped({
    required PdfPage page,
    required Rect bounds,
    required _GeniusPdfPreparedGrid prepared,
    PdfLayoutFormat? layoutFormat,
  }) {
    var currentPage = page;
    var currentY = bounds.top;
    PdfLayoutResult? lastResult;

    for (final topGroup in prepared.groups) {
      final legacyGroup = _toLegacyGroup(
        topGroup,
        suppressHeader: true,
      );

      final legacy = GeniusPdfDataGrid(
        config: config,
        columns: prepared.columns,
        rows: const <GeniusPdfGridRow>[],
        groups: <GeniusPdfGridGroup>[legacyGroup],
        style: _effectiveStyle(),
      );

      final grid = legacy._buildGrid(
        currentPage,
        availableWidth: bounds.width,
      );
      grid.allowRowBreakingAcrossPages =
          rowSplitPolicy == GeniusPdfGridRowSplitPolicy.allowSplit;

      if (repeatGroupHeaders && prepared.columns.isNotEmpty) {
        final header = grid.headers.add(1)[0];
        header.cells[0].value = config.isRTL
            ? (topGroup.titleAr ?? topGroup.title)
            : topGroup.title;
        header.cells[0].columnSpan = prepared.columns.length;

        final groupStyle = _groupHeaderStyle(topGroup.level);
        legacy._applyRowStyle(
          header,
          groupStyle,
          isGroupHeader: true,
        );
        legacy._applyCellStyle(
          header.cells[0],
          groupStyle,
          prepared.columns.first,
          isFirstColumn: true,
          isLastColumn: true,
        );
        grid.repeatHeader = true;
      }

      _applyGroupedCellPolicies(
        grid,
        prepared.columns,
        legacyGroup,
        topGroup.allRows,
      );

      final clientHeight = currentPage.getClientSize().height;
      final remaining = clientHeight - currentY;
      final drawHeight = remaining > 1 ? remaining : 1.0;

      lastResult = grid.draw(
        page: currentPage,
        bounds: Rect.fromLTWH(
          bounds.left,
          currentY,
          bounds.width,
          drawHeight,
        ),
        format: layoutFormat ??
            PdfLayoutFormat(
              layoutType: PdfLayoutType.paginate,
              breakType: PdfLayoutBreakType.fitPage,
            ),
      );

      if (lastResult != null) {
        currentPage = lastResult.page;
        currentY = lastResult.bounds.bottom + groupGap;
      }
    }

    if (grandTotals.isNotEmpty) {
      final totalRow = _summaryRow(
        prepared.rows,
        grandTotals,
        subtotal: false,
      );

      final totalGrid = GeniusPdfDataGrid(
        config: config,
        columns: prepared.columns,
        rows: const <GeniusPdfGridRow>[],
        footerRows: <GeniusPdfGridRow>[totalRow],
        style: _effectiveStyle(showHeader: false),
      );

      final grid = totalGrid._buildGrid(
        currentPage,
        availableWidth: bounds.width,
      );
      for (var rowIndex = 0; rowIndex < grid.rows.count; rowIndex++) {
        _applySummaryRowPolicies(
          grid.rows[rowIndex],
          prepared.columns,
        );
      }

      final clientHeight = currentPage.getClientSize().height;
      final remaining = clientHeight - currentY;
      final drawHeight = remaining > 1 ? remaining : 1.0;

      lastResult = grid.draw(
        page: currentPage,
        bounds: Rect.fromLTWH(
          bounds.left,
          currentY,
          bounds.width,
          drawHeight,
        ),
        format: layoutFormat ??
            PdfLayoutFormat(
              layoutType: PdfLayoutType.paginate,
              breakType: PdfLayoutBreakType.fitPage,
            ),
      );
    }

    return lastResult;
  }

  void _applyGroupedCellPolicies(
    PdfGrid grid,
    List<GeniusPdfGridColumn> preparedColumns,
    GeniusPdfGridGroup legacyGroup,
    List<_GeniusPdfPreparedRow> preparedRows,
  ) {
    final rowMap = <GeniusPdfGridRow, _GeniusPdfPreparedRow>{};
    for (final prepared in preparedRows) {
      rowMap[prepared.row] = prepared;
    }

    var gridRowIndex = 0;

    void visit(GeniusPdfGridGroup group) {
      if (group.showHeader) gridRowIndex++;

      final children = group.subgroups;
      if (children != null && children.isNotEmpty) {
        for (final child in children) {
          visit(child);
        }
      } else {
        for (final row in group.rows) {
          final prepared = rowMap[row];
          if (prepared != null && gridRowIndex < grid.rows.count) {
            _applyPreparedRowPolicies(
              grid.rows[gridRowIndex],
              preparedColumns,
              prepared,
            );
          }
          gridRowIndex++;
        }
      }

      if (group.showSummary) {
        if (group.summary != null) {
          if (gridRowIndex < grid.rows.count) {
            _applySummaryRowPolicies(
              grid.rows[gridRowIndex],
              preparedColumns,
            );
          }
          gridRowIndex++;
        }

        final summaries = group.summaries;
        if (summaries != null) {
          for (var summaryIndex = 0;
              summaryIndex < summaries.length;
              summaryIndex++) {
            if (gridRowIndex < grid.rows.count) {
              _applySummaryRowPolicies(
                grid.rows[gridRowIndex],
                preparedColumns,
              );
            }
            gridRowIndex++;
          }
        }
      }
    }

    visit(legacyGroup);
  }

  void _applyPreparedRowPolicies(
    PdfGridRow gridRow,
    List<GeniusPdfGridColumn> preparedColumns,
    _GeniusPdfPreparedRow prepared,
  ) {
    final physicalColumns = _physicalColumns(preparedColumns);

    for (var columnIndex = 0;
        columnIndex < physicalColumns.length;
        columnIndex++) {
      final column = physicalColumns[columnIndex];
      final policy =
          columnPolicies[column.id] ?? const GeniusPdfGridColumnPolicy();
      final raw = prepared.sourceRow.cells[column.id];
      final numericOrIdentifier =
          _isNumericKind(policy.valueKind) ||
          column.isNumeric ||
          _looksLikeIdentifier(raw);

      _setCellDirection(
        gridRow.cells[columnIndex],
        _resolveDirection(
          policy.contentDirection,
          numericOrIdentifier: numericOrIdentifier,
        ),
        isNumeric: _isNumericKind(policy.valueKind) || column.isNumeric,
      );

      final rowSpan = prepared.rowSpans[column.id];
      if (rowSpan != null && rowSpan > 1) {
        gridRow.cells[columnIndex].rowSpan = rowSpan;
      }
    }
  }

  PdfLayoutResult? _drawEmpty({
    required PdfPage page,
    required Rect bounds,
    required List<GeniusPdfGridColumn> columns,
    PdfLayoutFormat? layoutFormat,
  }) {
    if (columns.isEmpty) return null;

    final firstId = columns.first.id;
    final row = GeniusPdfGridRow(
      cells: <String, dynamic>{
        firstId: config.isRTL
            ? emptyState.messageAr
            : emptyState.message,
      },
      style: emptyState.style,
      span: <String, int>{
        firstId: columns.length,
      },
    );

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: <GeniusPdfGridRow>[row],
      style: _effectiveStyle(),
    );

    return grid.draw(
      page: page,
      bounds: bounds,
      layoutFormat: layoutFormat,
    );
  }

  bool _isNumericKind(GeniusPdfGridValueKind kind) {
    switch (kind) {
      case GeniusPdfGridValueKind.number:
      case GeniusPdfGridValueKind.money:
      case GeniusPdfGridValueKind.percentage:
      case GeniusPdfGridValueKind.quantity:
      case GeniusPdfGridValueKind.debit:
      case GeniusPdfGridValueKind.credit:
        return true;
      case GeniusPdfGridValueKind.text:
      case GeniusPdfGridValueKind.date:
      case GeniusPdfGridValueKind.dateTime:
      case GeniusPdfGridValueKind.identifier:
        return false;
    }
  }

  bool _looksLikeIdentifier(dynamic value) {
    if (value == null) return false;
    final text = value.toString().trim();
    if (text.isEmpty) return false;
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) return false;
    return RegExp(
      r'^[A-Za-z0-9][A-Za-z0-9._:/@+\-\s]*$',
    ).hasMatch(text);
  }

  num? _asNumber(dynamic value) {
    if (value is num) return value;
    if (value is String) {
      return num.tryParse(
        value.replaceAll(',', '').trim(),
      );
    }
    return null;
  }
}
