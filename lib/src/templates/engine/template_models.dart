
/// Represents a variable that can be used in templates.
///
/// Variables are placeholders in templates that get replaced with actual values
/// during rendering.
///
/// ## Example
/// ```dart
/// final variable = TemplateVariable(
///   name: 'customerName',
///   type: VariableType.string,
///   defaultValue: 'Unknown Customer',
///   label: 'Customer Name',
///   labelAr: 'اسم العميل',
/// );
/// ```
class TemplateVariable {

  /// Creates from JSON.
  factory TemplateVariable.fromJson(Map<String, dynamic> json) {
    return TemplateVariable(
      name: json['name'] as String,
      type: VariableType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => VariableType.string,
      ),
      defaultValue: json['defaultValue'],
      label: json['label'] as String?,
      labelAr: json['labelAr'] as String?,
      required: json['required'] as bool? ?? false,
      format: json['format'] as String?,
      validation: json['validation'] != null
          ? VariableValidation.fromJson(json['validation'])
          : null,
    );
  }
  /// Creates a template variable.
  const TemplateVariable({
    required this.name,
    required this.type,
    this.defaultValue,
    this.label,
    this.labelAr,
    this.required = false,
    this.format,
    this.validation,
  });

  /// Creates a string variable.
  factory TemplateVariable.string(
    String name, {
    String? defaultValue,
    String? label,
    String? labelAr,
    bool required = false,
  }) {
    return TemplateVariable(
      name: name,
      type: VariableType.string,
      defaultValue: defaultValue,
      label: label,
      labelAr: labelAr,
      required: required,
    );
  }

  /// Creates a number variable.
  factory TemplateVariable.number(
    String name, {
    num? defaultValue,
    String? label,
    String? labelAr,
    bool required = false,
    String? format,
  }) {
    return TemplateVariable(
      name: name,
      type: VariableType.number,
      defaultValue: defaultValue,
      label: label,
      labelAr: labelAr,
      required: required,
      format: format,
    );
  }

  /// Creates a currency variable.
  factory TemplateVariable.currency(
    String name, {
    num? defaultValue,
    String? label,
    String? labelAr,
    bool required = false,
    String currencySymbol = 'SAR',
  }) {
    return TemplateVariable(
      name: name,
      type: VariableType.currency,
      defaultValue: defaultValue,
      label: label,
      labelAr: labelAr,
      required: required,
      format: currencySymbol,
    );
  }

  /// Creates a date variable.
  factory TemplateVariable.date(
    String name, {
    DateTime? defaultValue,
    String? label,
    String? labelAr,
    bool required = false,
    String format = 'yyyy-MM-dd',
  }) {
    return TemplateVariable(
      name: name,
      type: VariableType.date,
      defaultValue: defaultValue?.toIso8601String(),
      label: label,
      labelAr: labelAr,
      required: required,
      format: format,
    );
  }

  /// Creates a boolean variable.
  factory TemplateVariable.boolean(
    String name, {
    bool defaultValue = false,
    String? label,
    String? labelAr,
  }) {
    return TemplateVariable(
      name: name,
      type: VariableType.boolean,
      defaultValue: defaultValue,
      label: label,
      labelAr: labelAr,
    );
  }

  /// Creates a list variable.
  factory TemplateVariable.list(
    String name, {
    List<dynamic>? defaultValue,
    String? label,
    String? labelAr,
    bool required = false,
  }) {
    return TemplateVariable(
      name: name,
      type: VariableType.list,
      defaultValue: defaultValue,
      label: label,
      labelAr: labelAr,
      required: required,
    );
  }

  /// Creates an image variable.
  factory TemplateVariable.image(
    String name, {
    String? label,
    String? labelAr,
    bool required = false,
  }) {
    return TemplateVariable(
      name: name,
      type: VariableType.image,
      label: label,
      labelAr: labelAr,
      required: required,
    );
  }

  /// Variable name (identifier).
  final String name;

  /// Variable type.
  final VariableType type;

  /// Default value if not provided.
  final dynamic defaultValue;

  /// Human-readable label (English).
  final String? label;

  /// Human-readable label (Arabic).
  final String? labelAr;

  /// Whether this variable is required.
  final bool required;

  /// Format string for formatting the value.
  final String? format;

  /// Validation rules for the variable.
  final VariableValidation? validation;

  /// Gets the display label based on RTL setting.
  String getLabel(bool isRtl) => (isRtl ? labelAr : label) ?? name;

  /// Converts to JSON.
  Map<String, dynamic> toJson() => {
        'name': name,
        'type': type.name,
        'defaultValue': defaultValue,
        'label': label,
        'labelAr': labelAr,
        'required': required,
        'format': format,
        if (validation != null) 'validation': validation!.toJson(),
      };
}

/// Types of template variables.
enum VariableType {
  /// String/text value.
  string,

  /// Numeric value.
  number,

  /// Currency value with formatting.
  currency,

  /// Date value.
  date,

  /// Boolean (true/false) value.
  boolean,

  /// List/array of values.
  list,

  /// Object/map value.
  object,

  /// Image data (bytes or path).
  image,
}

/// Validation rules for template variables.
class VariableValidation {

  factory VariableValidation.fromJson(Map<String, dynamic> json) {
    return VariableValidation(
      minLength: json['minLength'] as int?,
      maxLength: json['maxLength'] as int?,
      min: json['min'] as num?,
      max: json['max'] as num?,
      pattern: json['pattern'] as String?,
      allowedValues: json['allowedValues'] as List<dynamic>?,
    );
  }
  const VariableValidation({
    this.minLength,
    this.maxLength,
    this.min,
    this.max,
    this.pattern,
    this.allowedValues,
  });

  /// Minimum length for strings.
  final int? minLength;

  /// Maximum length for strings.
  final int? maxLength;

  /// Minimum value for numbers.
  final num? min;

  /// Maximum value for numbers.
  final num? max;

  /// Regex pattern for validation.
  final String? pattern;

  /// List of allowed values.
  final List<dynamic>? allowedValues;

  /// Validates a value against these rules.
  ValidationResult validate(dynamic value, VariableType type) {
    if (value == null) {
      return const ValidationResult(isValid: true);
    }

    switch (type) {
      case VariableType.string:
        if (value is String) {
          if (minLength != null && value.length < minLength!) {
            return ValidationResult(
              isValid: false,
              error: 'Minimum length is $minLength',
              errorAr: 'الحد الأدنى للطول هو $minLength',
            );
          }
          if (maxLength != null && value.length > maxLength!) {
            return ValidationResult(
              isValid: false,
              error: 'Maximum length is $maxLength',
              errorAr: 'الحد الأقصى للطول هو $maxLength',
            );
          }
          if (pattern != null && !RegExp(pattern!).hasMatch(value)) {
            return const ValidationResult(
              isValid: false,
              error: 'Value does not match pattern',
              errorAr: 'القيمة لا تتطابق مع النمط',
            );
          }
        }
        break;

      case VariableType.number:
      case VariableType.currency:
        if (value is num) {
          if (min != null && value < min!) {
            return ValidationResult(
              isValid: false,
              error: 'Minimum value is $min',
              errorAr: 'الحد الأدنى للقيمة هو $min',
            );
          }
          if (max != null && value > max!) {
            return ValidationResult(
              isValid: false,
              error: 'Maximum value is $max',
              errorAr: 'الحد الأقصى للقيمة هو $max',
            );
          }
        }
        break;

      default:
        break;
    }

    if (allowedValues != null && !allowedValues!.contains(value)) {
      return const ValidationResult(
        isValid: false,
        error: 'Value not in allowed list',
        errorAr: 'القيمة غير موجودة في القائمة المسموحة',
      );
    }

    return const ValidationResult(isValid: true);
  }

  Map<String, dynamic> toJson() => {
        if (minLength != null) 'minLength': minLength,
        if (maxLength != null) 'maxLength': maxLength,
        if (min != null) 'min': min,
        if (max != null) 'max': max,
        if (pattern != null) 'pattern': pattern,
        if (allowedValues != null) 'allowedValues': allowedValues,
      };
}

/// Result of a validation check.
class ValidationResult {
  const ValidationResult({
    required this.isValid,
    this.error,
    this.errorAr,
  });

  final bool isValid;
  final String? error;
  final String? errorAr;

  String? getError(bool isRtl) => isRtl ? errorAr : error;
}

/// Represents a conditional block in a template.
///
/// Conditions control which parts of the template are rendered
/// based on variable values.
///
/// ## Example
/// ```dart
/// final condition = TemplateCondition(
///   variable: 'showDiscount',
///   operator: ConditionOperator.equals,
///   value: true,
/// );
/// ```
class TemplateCondition {

  factory TemplateCondition.fromJson(Map<String, dynamic> json) {
    return TemplateCondition(
      variable: json['variable'] as String,
      operator: ConditionOperator.values.firstWhere(
        (e) => e.name == json['operator'],
        orElse: () => ConditionOperator.equals,
      ),
      value: json['value'],
      and: (json['and'] as List<dynamic>?)
          ?.map((e) => TemplateCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
      or: (json['or'] as List<dynamic>?)
          ?.map((e) => TemplateCondition.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  const TemplateCondition({
    required this.variable,
    required this.operator,
    this.value,
    this.and,
    this.or,
  });

  /// Creates an equality condition.
  factory TemplateCondition.equals(String variable, dynamic value) {
    return TemplateCondition(
      variable: variable,
      operator: ConditionOperator.equals,
      value: value,
    );
  }

  /// Creates a not-equals condition.
  factory TemplateCondition.notEquals(String variable, dynamic value) {
    return TemplateCondition(
      variable: variable,
      operator: ConditionOperator.notEquals,
      value: value,
    );
  }

  /// Creates a greater-than condition.
  factory TemplateCondition.greaterThan(String variable, num value) {
    return TemplateCondition(
      variable: variable,
      operator: ConditionOperator.greaterThan,
      value: value,
    );
  }

  /// Creates a less-than condition.
  factory TemplateCondition.lessThan(String variable, num value) {
    return TemplateCondition(
      variable: variable,
      operator: ConditionOperator.lessThan,
      value: value,
    );
  }

  /// Creates an "is empty" condition.
  factory TemplateCondition.isEmpty(String variable) {
    return TemplateCondition(
      variable: variable,
      operator: ConditionOperator.isEmpty,
    );
  }

  /// Creates an "is not empty" condition.
  factory TemplateCondition.isNotEmpty(String variable) {
    return TemplateCondition(
      variable: variable,
      operator: ConditionOperator.isNotEmpty,
    );
  }

  /// Creates a "contains" condition for strings/lists.
  factory TemplateCondition.contains(String variable, dynamic value) {
    return TemplateCondition(
      variable: variable,
      operator: ConditionOperator.contains,
      value: value,
    );
  }

  /// The variable to check.
  final String variable;

  /// The comparison operator.
  final ConditionOperator operator;

  /// The value to compare against.
  final dynamic value;

  /// Additional conditions to AND with this one.
  final List<TemplateCondition>? and;

  /// Additional conditions to OR with this one.
  final List<TemplateCondition>? or;

  /// Evaluates this condition against the given data.
  bool evaluate(Map<String, dynamic> data) {
    final varValue = _getNestedValue(data, variable);
    var result = _evaluateSingle(varValue);

    // Handle AND conditions
    if (and != null && and!.isNotEmpty) {
      for (final condition in and!) {
        if (!condition.evaluate(data)) {
          result = false;
          break;
        }
      }
    }

    // Handle OR conditions
    if (or != null && or!.isNotEmpty) {
      var orResult = false;
      for (final condition in or!) {
        if (condition.evaluate(data)) {
          orResult = true;
          break;
        }
      }
      result = result || orResult;
    }

    return result;
  }

  bool _evaluateSingle(dynamic varValue) {
    switch (operator) {
      case ConditionOperator.equals:
        return varValue == value;
      case ConditionOperator.notEquals:
        return varValue != value;
      case ConditionOperator.greaterThan:
        return varValue is num && value is num && varValue > value;
      case ConditionOperator.greaterThanOrEquals:
        return varValue is num && value is num && varValue >= value;
      case ConditionOperator.lessThan:
        return varValue is num && value is num && varValue < value;
      case ConditionOperator.lessThanOrEquals:
        return varValue is num && value is num && varValue <= value;
      case ConditionOperator.contains:
        if (varValue is String && value is String) {
          return varValue.contains(value);
        }
        if (varValue is List) {
          return varValue.contains(value);
        }
        return false;
      case ConditionOperator.startsWith:
        return varValue is String && value is String && varValue.startsWith(value);
      case ConditionOperator.endsWith:
        return varValue is String && value is String && varValue.endsWith(value);
      case ConditionOperator.isEmpty:
        if (varValue == null) return true;
        if (varValue is String) return varValue.isEmpty;
        if (varValue is List) return varValue.isEmpty;
        if (varValue is Map) return varValue.isEmpty;
        return false;
      case ConditionOperator.isNotEmpty:
        if (varValue == null) return false;
        if (varValue is String) return varValue.isNotEmpty;
        if (varValue is List) return varValue.isNotEmpty;
        if (varValue is Map) return varValue.isNotEmpty;
        return true;
      case ConditionOperator.isNull:
        return varValue == null;
      case ConditionOperator.isNotNull:
        return varValue != null;
    }
  }

  dynamic _getNestedValue(Map<String, dynamic> data, String path) {
    final parts = path.split('.');
    dynamic current = data;

    for (final part in parts) {
      if (current is Map<String, dynamic>) {
        current = current[part];
      } else if (current is List && int.tryParse(part) != null) {
        final index = int.parse(part);
        if (index >= 0 && index < current.length) {
          current = current[index];
        } else {
          return null;
        }
      } else {
        return null;
      }
    }

    return current;
  }

  /// Creates a combined AND condition.
  TemplateCondition andCondition(TemplateCondition other) {
    return TemplateCondition(
      variable: variable,
      operator: operator,
      value: value,
      and: [...?and, other],
      or: or,
    );
  }

  /// Creates a combined OR condition.
  TemplateCondition orCondition(TemplateCondition other) {
    return TemplateCondition(
      variable: variable,
      operator: operator,
      value: value,
      and: and,
      or: [...?or, other],
    );
  }

  Map<String, dynamic> toJson() => {
        'variable': variable,
        'operator': operator.name,
        'value': value,
        if (and != null) 'and': and!.map((c) => c.toJson()).toList(),
        if (or != null) 'or': or!.map((c) => c.toJson()).toList(),
      };
}

/// Comparison operators for conditions.
enum ConditionOperator {
  equals,
  notEquals,
  greaterThan,
  greaterThanOrEquals,
  lessThan,
  lessThanOrEquals,
  contains,
  startsWith,
  endsWith,
  isEmpty,
  isNotEmpty,
  isNull,
  isNotNull,
}

/// Represents a loop/iteration in a template.
///
/// Loops allow repeating elements for each item in a list.
///
/// ## Example
/// ```dart
/// final loop = TemplateLoop(
///   variable: 'items',
///   itemName: 'item',
///   indexName: 'index',
/// );
/// ```
class TemplateLoop {

  factory TemplateLoop.fromJson(Map<String, dynamic> json) {
    return TemplateLoop(
      variable: json['variable'] as String,
      itemName: json['itemName'] as String? ?? 'item',
      indexName: json['indexName'] as String? ?? 'index',
      filter: json['filter'] != null
          ? TemplateCondition.fromJson(json['filter'] as Map<String, dynamic>)
          : null,
      sortBy: json['sortBy'] as String?,
      sortDescending: json['sortDescending'] as bool? ?? false,
      limit: json['limit'] as int?,
      offset: json['offset'] as int? ?? 0,
    );
  }
  const TemplateLoop({
    required this.variable,
    this.itemName = 'item',
    this.indexName = 'index',
    this.filter,
    this.sortBy,
    this.sortDescending = false,
    this.limit,
    this.offset = 0,
  });

  /// The list variable to iterate over.
  final String variable;

  /// Name for the current item in the loop.
  final String itemName;

  /// Name for the current index in the loop.
  final String indexName;

  /// Optional filter condition for items.
  final TemplateCondition? filter;

  /// Field to sort by.
  final String? sortBy;

  /// Whether to sort in descending order.
  final bool sortDescending;

  /// Maximum number of items to process.
  final int? limit;

  /// Number of items to skip.
  final int offset;

  /// Gets the items to iterate over from the data.
  List<Map<String, dynamic>> getItems(Map<String, dynamic> data) {
    final value = _getNestedValue(data, variable);

    if (value is! List) {
      return [];
    }

    var items = value.map((e) {
      if (e is Map<String, dynamic>) {
        return e;
      }
      return {'value': e};
    }).toList();

    // Apply filter
    if (filter != null) {
      items = items.where((item) {
        final itemData = {...data, itemName: item};
        return filter!.evaluate(itemData);
      }).toList();
    }

    // Apply sorting
    if (sortBy != null) {
      items.sort((a, b) {
        final aValue = a[sortBy];
        final bValue = b[sortBy];
        int result;
        if (aValue is Comparable && bValue is Comparable) {
          result = aValue.compareTo(bValue);
        } else {
          result = aValue.toString().compareTo(bValue.toString());
        }
        return sortDescending ? -result : result;
      });
    }

    // Apply offset
    if (offset > 0 && offset < items.length) {
      items = items.sublist(offset);
    }

    // Apply limit
    if (limit != null && limit! > 0 && limit! < items.length) {
      items = items.sublist(0, limit);
    }

    return items;
  }

  dynamic _getNestedValue(Map<String, dynamic> data, String path) {
    final parts = path.split('.');
    dynamic current = data;

    for (final part in parts) {
      if (current is Map<String, dynamic>) {
        current = current[part];
      } else if (current is List && int.tryParse(part) != null) {
        final index = int.parse(part);
        if (index >= 0 && index < current.length) {
          current = current[index];
        } else {
          return null;
        }
      } else {
        return null;
      }
    }

    return current;
  }

  Map<String, dynamic> toJson() => {
        'variable': variable,
        'itemName': itemName,
        'indexName': indexName,
        if (filter != null) 'filter': filter!.toJson(),
        if (sortBy != null) 'sortBy': sortBy,
        'sortDescending': sortDescending,
        if (limit != null) 'limit': limit,
        'offset': offset,
      };
}

/// Context for template rendering.
///
/// Contains all the data and state needed during template processing.
class TemplateContext {
  TemplateContext({
    required this.data,
    this.isRtl = false,
    Map<String, dynamic>? loopContext,
  }) : _loopContext = loopContext ?? {};

  /// The main data for the template.
  final Map<String, dynamic> data;

  /// Whether to use RTL formatting.
  final bool isRtl;

  /// Current loop context (item, index, etc.).
  final Map<String, dynamic> _loopContext;

  /// Gets a value from the context.
  dynamic getValue(String path) {
    // Check loop context first
    final parts = path.split('.');
    if (_loopContext.containsKey(parts.first)) {
      return _getNestedValue(_loopContext, path);
    }
    return _getNestedValue(data, path);
  }

  /// Gets all data merged with loop context.
  Map<String, dynamic> get mergedData => {...data, ..._loopContext};

  /// Creates a new context for a loop iteration.
  TemplateContext forLoopIteration(
    TemplateLoop loop,
    Map<String, dynamic> item,
    int index,
  ) {
    return TemplateContext(
      data: data,
      isRtl: isRtl,
      loopContext: {
        ..._loopContext,
        loop.itemName: item,
        loop.indexName: index,
        '${loop.itemName}_first': index == 0,
        '${loop.itemName}_index': index,
      },
    );
  }

  dynamic _getNestedValue(Map<String, dynamic> data, String path) {
    final parts = path.split('.');
    dynamic current = data;

    for (final part in parts) {
      if (current is Map<String, dynamic>) {
        current = current[part];
      } else if (current is List && int.tryParse(part) != null) {
        final index = int.parse(part);
        if (index >= 0 && index < current.length) {
          current = current[index];
        } else {
          return null;
        }
      } else {
        return null;
      }
    }

    return current;
  }
}
