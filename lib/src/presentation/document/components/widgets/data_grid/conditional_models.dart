part of '../pdf_data_grid.dart';

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
