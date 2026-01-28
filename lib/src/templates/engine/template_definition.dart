import 'dart:convert';
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'template_elements.dart';
import 'template_models.dart';

/// Defines a complete PDF template structure.
///
/// A template definition includes metadata, variables, and the content
/// structure that can be rendered to a PDF document.
///
/// ## Example
/// ```dart
/// final template = TemplateDefinition(
///   id: 'invoice-template',
///   name: 'Tax Invoice',
///   nameAr: 'فاتورة ضريبية',
///   version: '1.0.0',
///   variables: [
///     TemplateVariable.string('invoiceNumber', required: true),
///     TemplateVariable.date('invoiceDate', required: true),
///     TemplateVariable.currency('total'),
///   ],
///   content: [
///     TextElement(text: 'Invoice', textAr: 'فاتورة'),
///     VariableElement(variableName: 'invoiceNumber'),
///   ],
/// );
/// ```
class TemplateDefinition {

  /// Creates a template from JSON.
  factory TemplateDefinition.fromJson(Map<String, dynamic> json) {
    return TemplateDefinition(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['descriptionAr'] as String?,
      version: json['version'] as String? ?? '1.0.0',
      author: json['author'] as String?,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.cast<String>() ?? [],
      variables: (json['variables'] as List<dynamic>?)
              ?.map((e) => TemplateVariable.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      content: (json['content'] as List<dynamic>)
          .map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      pageSettings: json['pageSettings'] != null
          ? TemplatePageSettings.fromJson(
              json['pageSettings'] as Map<String, dynamic>)
          : null,
      header: (json['header'] as List<dynamic>?)
          ?.map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      footer: (json['footer'] as List<dynamic>?)
          ?.map((e) => TemplateElement.fromJson(e as Map<String, dynamic>))
          .toList(),
      styles: (json['styles'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, ElementStyle.fromJson(v as Map<String, dynamic>)),
          ) ??
          {},
      metadata: json['metadata'] as Map<String, dynamic>? ?? {},
    );
  }

  /// Creates a template from a JSON string.
  factory TemplateDefinition.fromJsonString(String jsonString) {
    return TemplateDefinition.fromJson(
      jsonDecode(jsonString) as Map<String, dynamic>,
    );
  }
  /// Creates a template definition.
  const TemplateDefinition({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    this.version = '1.0.0',
    this.author,
    this.category,
    this.tags = const [],
    this.variables = const [],
    required this.content,
    this.pageSettings,
    this.header,
    this.footer,
    this.styles = const {},
    this.metadata = const {},
  });

  /// Unique identifier for this template.
  final String id;

  /// Template name (English).
  final String name;

  /// Template name (Arabic).
  final String? nameAr;

  /// Template description (English).
  final String? description;

  /// Template description (Arabic).
  final String? descriptionAr;

  /// Template version.
  final String version;

  /// Template author.
  final String? author;

  /// Template category for organization.
  final String? category;

  /// Tags for searching and filtering.
  final List<String> tags;

  /// Variables used in this template.
  final List<TemplateVariable> variables;

  /// Main content elements.
  final List<TemplateElement> content;

  /// Page settings for this template.
  final TemplatePageSettings? pageSettings;

  /// Header elements (repeated on each page).
  final List<TemplateElement>? header;

  /// Footer elements (repeated on each page).
  final List<TemplateElement>? footer;

  /// Named styles that can be referenced by elements.
  final Map<String, ElementStyle> styles;

  /// Additional metadata.
  final Map<String, dynamic> metadata;

  /// Gets the display name based on RTL setting.
  String getName(bool isRtl) => (isRtl && nameAr != null) ? nameAr! : name;

  /// Gets the description based on RTL setting.
  String? getDescription(bool isRtl) =>
      (isRtl && descriptionAr != null) ? descriptionAr : description;

  /// Validates data against the template's variable definitions.
  List<ValidationResult> validate(Map<String, dynamic> data) {
    final results = <ValidationResult>[];

    for (final variable in variables) {
      final value = data[variable.name];

      // Check required
      if (variable.required && value == null) {
        results.add(ValidationResult(
          isValid: false,
          error: '${variable.name} is required',
          errorAr: '${variable.getLabel(true)} مطلوب',
        ));
        continue;
      }

      // Check validation rules
      if (variable.validation != null && value != null) {
        final result = variable.validation!.validate(value, variable.type);
        if (!result.isValid) {
          results.add(result);
        }
      }
    }

    return results;
  }

  /// Gets default values for all variables.
  Map<String, dynamic> getDefaultValues() {
    final defaults = <String, dynamic>{};

    for (final variable in variables) {
      if (variable.defaultValue != null) {
        defaults[variable.name] = variable.defaultValue;
      }
    }

    return defaults;
  }

  /// Converts this template to JSON.
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        if (nameAr != null) 'nameAr': nameAr,
        if (description != null) 'description': description,
        if (descriptionAr != null) 'descriptionAr': descriptionAr,
        'version': version,
        if (author != null) 'author': author,
        if (category != null) 'category': category,
        'tags': tags,
        'variables': variables.map((v) => v.toJson()).toList(),
        'content': content.map((e) => e.toJson()).toList(),
        if (pageSettings != null) 'pageSettings': pageSettings!.toJson(),
        if (header != null) 'header': header!.map((e) => e.toJson()).toList(),
        if (footer != null) 'footer': footer!.map((e) => e.toJson()).toList(),
        if (styles.isNotEmpty)
          'styles': styles.map((k, v) => MapEntry(k, v.toJson())),
        if (metadata.isNotEmpty) 'metadata': metadata,
      };

  /// Converts this template to a JSON string.
  String toJsonString({bool pretty = false}) {
    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(toJson());
    }
    return jsonEncode(toJson());
  }

  /// Creates a copy with updated values.
  TemplateDefinition copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? version,
    String? author,
    String? category,
    List<String>? tags,
    List<TemplateVariable>? variables,
    List<TemplateElement>? content,
    TemplatePageSettings? pageSettings,
    List<TemplateElement>? header,
    List<TemplateElement>? footer,
    Map<String, ElementStyle>? styles,
    Map<String, dynamic>? metadata,
  }) {
    return TemplateDefinition(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      version: version ?? this.version,
      author: author ?? this.author,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      variables: variables ?? this.variables,
      content: content ?? this.content,
      pageSettings: pageSettings ?? this.pageSettings,
      header: header ?? this.header,
      footer: footer ?? this.footer,
      styles: styles ?? this.styles,
      metadata: metadata ?? this.metadata,
    );
  }
}

/// Page settings for a template.
class TemplatePageSettings {

  factory TemplatePageSettings.fromJson(Map<String, dynamic> json) {
    return TemplatePageSettings(
      pageSize: _stringToPageSize(json['pageSize'] as String?),
      orientation: json['orientation'] != null
          ? PdfPageOrientation.values.firstWhere(
              (e) => e.name == json['orientation'],
              orElse: () => PdfPageOrientation.portrait,
            )
          : PdfPageOrientation.portrait,
      margins: json['margins'] != null
          ? TemplateMargins.fromJson(json['margins'] as Map<String, dynamic>)
          : null,
    );
  }
  const TemplatePageSettings({
    this.pageSize = PdfPageSize.a4,
    this.orientation = PdfPageOrientation.portrait,
    this.margins,
  });

  /// Page size.
  final Size pageSize;

  /// Page orientation.
  final PdfPageOrientation orientation;

  /// Page margins.
  final TemplateMargins? margins;

  Map<String, dynamic> toJson() => {
        'pageSize': _pageSizeToString(pageSize),
        'orientation': orientation.name,
        if (margins != null) 'margins': margins!.toJson(),
      };

  static String _pageSizeToString(Size size) {
    if (size == PdfPageSize.a4) return 'a4';
    if (size == PdfPageSize.a3) return 'a3';
    if (size == PdfPageSize.letter) return 'letter';
    if (size == PdfPageSize.legal) return 'legal';
    return 'a4';
  }

  static Size _stringToPageSize(String? size) {
    switch (size) {
      case 'a3':
        return PdfPageSize.a3;
      case 'letter':
        return PdfPageSize.letter;
      case 'legal':
        return PdfPageSize.legal;
      case 'a4':
      default:
        return PdfPageSize.a4;
    }
  }
}

/// Margins for a template page.
class TemplateMargins {

  factory TemplateMargins.fromJson(Map<String, dynamic> json) {
    return TemplateMargins(
      left: (json['left'] as num?)?.toDouble() ?? 40,
      top: (json['top'] as num?)?.toDouble() ?? 40,
      right: (json['right'] as num?)?.toDouble() ?? 40,
      bottom: (json['bottom'] as num?)?.toDouble() ?? 40,
    );
  }
  const TemplateMargins({
    this.left = 40,
    this.top = 40,
    this.right = 40,
    this.bottom = 40,
  });

  const TemplateMargins.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  final double left;
  final double top;
  final double right;
  final double bottom;

  Map<String, dynamic> toJson() => {
        'left': left,
        'top': top,
        'right': right,
        'bottom': bottom,
      };
}

/// Template categories for organization.
class TemplateCategory {
  const TemplateCategory._();

  static const String financial = 'financial';
  static const String sales = 'sales';
  static const String hr = 'hr';
  static const String inventory = 'inventory';
  static const String general = 'general';
  static const String custom = 'custom';

  static const List<String> all = [
    financial,
    sales,
    hr,
    inventory,
    general,
    custom,
  ];

  static String getName(String category, bool isRtl) {
    final names = {
      financial: isRtl ? 'مالي' : 'Financial',
      sales: isRtl ? 'مبيعات' : 'Sales',
      hr: isRtl ? 'موارد بشرية' : 'HR',
      inventory: isRtl ? 'مخزون' : 'Inventory',
      general: isRtl ? 'عام' : 'General',
      custom: isRtl ? 'مخصص' : 'Custom',
    };
    return names[category] ?? category;
  }
}
