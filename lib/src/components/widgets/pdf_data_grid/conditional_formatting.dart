part of '../pdf_data_grid.dart';

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
