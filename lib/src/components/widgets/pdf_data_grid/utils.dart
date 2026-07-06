part of '../pdf_data_grid.dart';

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
