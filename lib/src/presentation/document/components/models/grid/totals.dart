part of '../grid_models.dart';

// ============================================================================
// Auto Total Rows (v2.12.0)
// ============================================================================

/// Type of automatic calculation for total rows.
enum GeniusPdfTotalType {
  /// Sum of all values in the column.
  sum,

  /// Average of all values in the column.
  average,

  /// Count of non-empty values.
  count,

  /// Minimum value in the column.
  min,

  /// Maximum value in the column.
  max,

  /// Custom calculation using a provided function.
  custom,
}

/// Defines an auto-calculated total/summary row for the grid.
///
/// Multiple [GeniusPdfAutoTotal] instances can be added to a single grid
/// to create subtotal, tax, discount, and grand total rows.
///
/// ## Example
/// ```dart
/// final grid = GeniusPdfDataGrid(
///   columns: columns,
///   rows: dataRows,
///   autoTotals: [
///     GeniusPdfAutoTotal.sum(
///       label: 'Subtotal',
///       labelAr: 'المجموع الفرعي',
///       labelColumnId: 'desc',
///     ),
///     GeniusPdfAutoTotal.average(
///       label: 'Average',
///       labelAr: 'المتوسط',
///       labelColumnId: 'desc',
///       columnIds: ['price'],
///     ),
///   ],
/// );
/// ```
class GeniusPdfAutoTotal {
  const GeniusPdfAutoTotal({
    required this.type,
    this.label,
    this.labelAr,
    this.labelColumnId,
    this.columnIds,
    this.style,
    this.customCalculation,
    this.extraCells,
    this.span,
  });

  /// Creates a sum total row.
  factory GeniusPdfAutoTotal.sum({
    String? label,
    String? labelAr,
    String? labelColumnId,
    List<String>? columnIds,
    GeniusPdfCellStyle? style,
    Map<String, dynamic>? extraCells,
    Map<String, int>? span,
  }) {
    return GeniusPdfAutoTotal(
      type: GeniusPdfTotalType.sum,
      label: label ?? 'Total',
      labelAr: labelAr ?? 'الإجمالي',
      labelColumnId: labelColumnId,
      columnIds: columnIds,
      style: style,
      extraCells: extraCells,
      span: span,
    );
  }

  /// Creates an average total row.
  factory GeniusPdfAutoTotal.average({
    String? label,
    String? labelAr,
    String? labelColumnId,
    List<String>? columnIds,
    GeniusPdfCellStyle? style,
  }) {
    return GeniusPdfAutoTotal(
      type: GeniusPdfTotalType.average,
      label: label ?? 'Average',
      labelAr: labelAr ?? 'المتوسط',
      labelColumnId: labelColumnId,
      columnIds: columnIds,
      style: style,
    );
  }

  /// Creates a count total row.
  factory GeniusPdfAutoTotal.count({
    String? label,
    String? labelAr,
    String? labelColumnId,
    List<String>? columnIds,
    GeniusPdfCellStyle? style,
  }) {
    return GeniusPdfAutoTotal(
      type: GeniusPdfTotalType.count,
      label: label ?? 'Count',
      labelAr: labelAr ?? 'العدد',
      labelColumnId: labelColumnId,
      columnIds: columnIds,
      style: style,
    );
  }

  /// Creates a min total row.
  factory GeniusPdfAutoTotal.min({
    String? label,
    String? labelAr,
    String? labelColumnId,
    List<String>? columnIds,
    GeniusPdfCellStyle? style,
  }) {
    return GeniusPdfAutoTotal(
      type: GeniusPdfTotalType.min,
      label: label ?? 'Min',
      labelAr: labelAr ?? 'الأدنى',
      labelColumnId: labelColumnId,
      columnIds: columnIds,
      style: style,
    );
  }

  /// Creates a max total row.
  factory GeniusPdfAutoTotal.max({
    String? label,
    String? labelAr,
    String? labelColumnId,
    List<String>? columnIds,
    GeniusPdfCellStyle? style,
  }) {
    return GeniusPdfAutoTotal(
      type: GeniusPdfTotalType.max,
      label: label ?? 'Max',
      labelAr: labelAr ?? 'الأقصى',
      labelColumnId: labelColumnId,
      columnIds: columnIds,
      style: style,
    );
  }

  /// Creates a custom total row with a calculation function.
  factory GeniusPdfAutoTotal.custom({
    required Map<String, num> Function(List<GeniusPdfGridRow> rows) calculation,
    String? label,
    String? labelAr,
    String? labelColumnId,
    GeniusPdfCellStyle? style,
    Map<String, dynamic>? extraCells,
  }) {
    return GeniusPdfAutoTotal(
      type: GeniusPdfTotalType.custom,
      label: label,
      labelAr: labelAr,
      labelColumnId: labelColumnId,
      style: style,
      customCalculation: calculation,
      extraCells: extraCells,
    );
  }

  /// The calculation type.
  final GeniusPdfTotalType type;

  /// Label for this total row (English).
  final String? label;

  /// Label for this total row (Arabic).
  final String? labelAr;

  /// Which column to place the label in.
  final String? labelColumnId;

  /// Which columns to calculate. Null = all numeric columns.
  final List<String>? columnIds;

  /// Custom style for this total row.
  final GeniusPdfCellStyle? style;

  /// Custom calculation function (for [GeniusPdfTotalType.custom]).
  final Map<String, num> Function(List<GeniusPdfGridRow> rows)?
      customCalculation;

  /// Extra static cells to merge into the total row.
  final Map<String, dynamic>? extraCells;

  /// Column span definitions for this total row.
  final Map<String, int>? span;

  /// Gets the display label based on locale.
  String? getLabel({bool isArabic = false}) {
    if (isArabic && labelAr != null) return labelAr;
    return label;
  }

  /// Calculates values from a list of data rows.
  Map<String, num> calculate(
    List<GeniusPdfGridRow> rows,
    List<GeniusPdfGridColumn> columns,
  ) {
    if (type == GeniusPdfTotalType.custom && customCalculation != null) {
      return customCalculation!(rows);
    }

    final dataRows = rows.where((r) => !r.isSpecialRow).toList();
    final targetColumns = columnIds ??
        columns.where((c) => c.isNumeric).map((c) => c.id).toList();

    final result = <String, num>{};

    for (final colId in targetColumns) {
      final values = <num>[];
      for (final row in dataRows) {
        final val = row.cells[colId];
        if (val is num) {
          values.add(val);
        } else if (val is String) {
          final parsed = double.tryParse(val);
          if (parsed != null) values.add(parsed);
        }
      }

      if (values.isEmpty) {
        result[colId] = 0;
        continue;
      }

      switch (type) {
        case GeniusPdfTotalType.sum:
          result[colId] = values.fold<num>(0, (a, b) => a + b);
          break;
        case GeniusPdfTotalType.average:
          result[colId] = values.fold<num>(0, (a, b) => a + b) / values.length;
          break;
        case GeniusPdfTotalType.count:
          result[colId] = values.length;
          break;
        case GeniusPdfTotalType.min:
          result[colId] = values.reduce((a, b) => a < b ? a : b);
          break;
        case GeniusPdfTotalType.max:
          result[colId] = values.reduce((a, b) => a > b ? a : b);
          break;
        case GeniusPdfTotalType.custom:
          break;
      }
    }

    return result;
  }
}
