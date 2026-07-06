import 'dart:async';
import 'dart:convert';

import 'template_definition.dart';
import 'template_elements.dart';
import 'template_models.dart';


/// Registry for managing and storing templates.
///
/// The template registry provides a central place to store, retrieve,
/// and manage template definitions. It supports categories, tags,
/// and searching.
///
/// ## Example
/// ```dart
/// final registry = TemplateRegistry();
///
/// // Register templates
/// registry.register(invoiceTemplate);
/// registry.register(reportTemplate);
///
/// // Get a template by ID
/// final template = registry.get('invoice-template');
///
/// // Search templates
/// final results = registry.search('invoice');
///
/// // Get templates by category
/// final financialTemplates = registry.getByCategory('financial');
/// ```
class TemplateRegistry {
  /// Creates a template registry.
  TemplateRegistry();

  /// Singleton instance for global access.
  static TemplateRegistry? _instance;

  /// Gets the global singleton instance.
  static TemplateRegistry get instance {
    _instance ??= TemplateRegistry();
    return _instance!;
  }

  /// Resets the singleton instance.
  static void resetInstance() {
    _instance = null;
  }

  final Map<String, TemplateDefinition> _templates = {};
  final _changeController = StreamController<TemplateRegistryChange>.broadcast();

  /// Stream of registry changes.
  Stream<TemplateRegistryChange> get changes => _changeController.stream;

  /// Gets all registered template IDs.
  List<String> get templateIds => _templates.keys.toList();

  /// Gets all registered templates.
  List<TemplateDefinition> get templates => _templates.values.toList();

  /// Gets the number of registered templates.
  int get count => _templates.length;

  /// Registers a template.
  ///
  /// If a template with the same ID already exists, it will be replaced.
  void register(TemplateDefinition template) {
    final isUpdate = _templates.containsKey(template.id);
    _templates[template.id] = template;

    _changeController.add(TemplateRegistryChange(
      type: isUpdate ? ChangeType.updated : ChangeType.added,
      templateId: template.id,
      template: template,
    ));
  }

  /// Registers multiple templates.
  void registerAll(List<TemplateDefinition> templates) {
    for (final template in templates) {
      register(template);
    }
  }

  /// Unregisters a template by ID.
  ///
  /// Returns true if the template was found and removed.
  bool unregister(String templateId) {
    final template = _templates.remove(templateId);
    if (template != null) {
      _changeController.add(TemplateRegistryChange(
        type: ChangeType.removed,
        templateId: templateId,
        template: template,
      ));
      return true;
    }
    return false;
  }

  /// Gets a template by ID.
  ///
  /// Returns null if not found.
  TemplateDefinition? get(String templateId) {
    return _templates[templateId];
  }

  /// Gets a template by ID or throws if not found.
  TemplateDefinition getOrThrow(String templateId) {
    final template = _templates[templateId];
    if (template == null) {
      throw TemplateNotFoundException(templateId);
    }
    return template;
  }

  /// Checks if a template exists.
  bool has(String templateId) {
    return _templates.containsKey(templateId);
  }

  /// Gets templates by category.
  List<TemplateDefinition> getByCategory(String category) {
    return _templates.values
        .where((t) => t.category == category)
        .toList();
  }

  /// Gets templates by tag.
  List<TemplateDefinition> getByTag(String tag) {
    return _templates.values
        .where((t) => t.tags.contains(tag))
        .toList();
  }

  /// Gets templates matching any of the given tags.
  List<TemplateDefinition> getByTags(List<String> tags) {
    return _templates.values
        .where((t) => t.tags.any((tag) => tags.contains(tag)))
        .toList();
  }

  /// Searches templates by name, description, or tags.
  List<TemplateDefinition> search(String query, {bool isRtl = false}) {
    final lowerQuery = query.toLowerCase();

    return _templates.values.where((t) {
      final name = t.getName(isRtl).toLowerCase();
      final description = t.getDescription(isRtl)?.toLowerCase() ?? '';
      final tags = t.tags.map((tag) => tag.toLowerCase()).join(' ');

      return name.contains(lowerQuery) ||
          description.contains(lowerQuery) ||
          tags.contains(lowerQuery);
    }).toList();
  }

  /// Gets all unique categories.
  List<String> get categories {
    final cats = <String>{};
    for (final template in _templates.values) {
      if (template.category != null) {
        cats.add(template.category!);
      }
    }
    return cats.toList()..sort();
  }

  /// Gets all unique tags.
  List<String> get allTags {
    final tags = <String>{};
    for (final template in _templates.values) {
      tags.addAll(template.tags);
    }
    return tags.toList()..sort();
  }

  /// Exports all templates to JSON.
  String exportToJson({bool pretty = false}) {
    final data = {
      'version': '1.0',
      'templates': _templates.values.map((t) => t.toJson()).toList(),
    };

    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(data);
    }
    return jsonEncode(data);
  }

  /// Imports templates from JSON.
  ///
  /// Returns the number of templates imported.
  int importFromJson(String jsonString, {bool replace = false}) {
    final data = jsonDecode(jsonString) as Map<String, dynamic>;
    final templatesList = data['templates'] as List<dynamic>;

    var count = 0;
    for (final templateJson in templatesList) {
      final template = TemplateDefinition.fromJson(
        templateJson as Map<String, dynamic>,
      );

      if (replace || !has(template.id)) {
        register(template);
        count++;
      }
    }

    return count;
  }

  /// Clears all registered templates.
  void clear() {
    final ids = _templates.keys.toList();
    _templates.clear();

    for (final id in ids) {
      _changeController.add(TemplateRegistryChange(
        type: ChangeType.removed,
        templateId: id,
      ));
    }
  }

  /// Disposes of the registry.
  void dispose() {
    _changeController.close();
  }
}

/// Change notification for template registry.
class TemplateRegistryChange {
  const TemplateRegistryChange({
    required this.type,
    required this.templateId,
    this.template,
  });

  final ChangeType type;
  final String templateId;
  final TemplateDefinition? template;
}

/// Types of registry changes.
enum ChangeType {
  added,
  updated,
  removed,
}

/// Exception thrown when a template is not found.
class TemplateNotFoundException implements Exception {
  const TemplateNotFoundException(this.templateId);

  final String templateId;

  @override
  String toString() => 'Template not found: $templateId';
}

/// Pre-built template library with common templates.
class TemplateLibrary {
  TemplateLibrary._();

  /// Registers all built-in templates to the given registry.
  static void registerBuiltInTemplates(TemplateRegistry registry) {
    registry.registerAll([
      _simpleInvoiceTemplate(),
      _simpleReportTemplate(),
      _simpleLetterTemplate(),
    ]);
  }

  static TemplateDefinition _simpleInvoiceTemplate() {
    return TemplateDefinition(
      id: 'builtin-simple-invoice',
      name: 'Simple Invoice',
      nameAr: 'فاتورة بسيطة',
      description: 'A simple invoice template',
      descriptionAr: 'قالب فاتورة بسيطة',
      category: TemplateCategory.sales,
      tags: ['invoice', 'simple', 'sales'],
      variables: [
        TemplateVariable.string('invoiceNumber', required: true, label: 'Invoice Number', labelAr: 'رقم الفاتورة'),
        TemplateVariable.date('invoiceDate', required: true, label: 'Invoice Date', labelAr: 'تاريخ الفاتورة'),
        TemplateVariable.string('customerName', required: true, label: 'Customer Name', labelAr: 'اسم العميل'),
        TemplateVariable.list('items', required: true, label: 'Items', labelAr: 'البنود'),
        TemplateVariable.currency('total', required: true, label: 'Total', labelAr: 'الإجمالي'),
      ],
      content: const [
        TextElement(
          text: 'INVOICE',
          textAr: 'فاتورة',
          fontSize: 24,
          isBold: true,
        ),
        SpacerElement(height: 20),
        RowElement(
          children: [
            VariableElement(
              variableName: 'invoiceNumber',
              prefix: 'Invoice #: ',
              prefixAr: 'رقم الفاتورة: ',
            ),
            VariableElement(
              variableName: 'invoiceDate',
              prefix: 'Date: ',
              prefixAr: 'التاريخ: ',
            ),
          ],
          flexValues: [1, 1],
        ),
        SpacerElement(height: 10),
        VariableElement(
          variableName: 'customerName',
          prefix: 'Customer: ',
          prefixAr: 'العميل: ',
        ),
        SpacerElement(height: 20),
        DividerElement(),
        SpacerElement(height: 10),
        TableElement(
          columns: [
            TableColumn(field: 'name', title: 'Item', titleAr: 'البند', flex: 2),
            TableColumn(field: 'quantity', title: 'Qty', titleAr: 'الكمية', flex: 1),
            TableColumn(field: 'price', title: 'Price', titleAr: 'السعر', flex: 1),
            TableColumn(field: 'total', title: 'Total', titleAr: 'الإجمالي', flex: 1),
          ],
          dataVariable: 'items',
        ),
        SpacerElement(height: 10),
        DividerElement(),
        SpacerElement(height: 10),
        VariableElement(
          variableName: 'total',
          prefix: 'Total: ',
          prefixAr: 'الإجمالي: ',
          suffix: ' SAR',
          suffixAr: ' ريال',
          isBold: true,
        ),
      ],
    );
  }

  static TemplateDefinition _simpleReportTemplate() {
    return TemplateDefinition(
      id: 'builtin-simple-report',
      name: 'Simple Report',
      nameAr: 'تقرير بسيط',
      description: 'A simple report template',
      descriptionAr: 'قالب تقرير بسيط',
      category: TemplateCategory.general,
      tags: ['report', 'simple', 'general'],
      variables: [
        TemplateVariable.string('title', required: true, label: 'Report Title', labelAr: 'عنوان التقرير'),
        TemplateVariable.date('date', required: true, label: 'Report Date', labelAr: 'تاريخ التقرير'),
        TemplateVariable.string('content', required: true, label: 'Content', labelAr: 'المحتوى'),
      ],
      content: const [
        VariableElement(
          variableName: 'title',
          fontSize: 20,
          isBold: true,
        ),
        SpacerElement(height: 10),
        VariableElement(
          variableName: 'date',
          prefix: 'Date: ',
          prefixAr: 'التاريخ: ',
        ),
        SpacerElement(height: 20),
        DividerElement(),
        SpacerElement(height: 20),
        VariableElement(variableName: 'content'),
      ],
    );
  }

  static TemplateDefinition _simpleLetterTemplate() {
    return TemplateDefinition(
      id: 'builtin-simple-letter',
      name: 'Simple Letter',
      nameAr: 'خطاب بسيط',
      description: 'A simple letter template',
      descriptionAr: 'قالب خطاب بسيط',
      category: TemplateCategory.general,
      tags: ['letter', 'simple', 'general'],
      variables: [
        TemplateVariable.date('date', required: true, label: 'Date', labelAr: 'التاريخ'),
        TemplateVariable.string('recipient', required: true, label: 'Recipient', labelAr: 'المستلم'),
        TemplateVariable.string('subject', required: true, label: 'Subject', labelAr: 'الموضوع'),
        TemplateVariable.string('body', required: true, label: 'Body', labelAr: 'المحتوى'),
        TemplateVariable.string('sender', required: true, label: 'Sender', labelAr: 'المرسل'),
      ],
      content: const [
        VariableElement(variableName: 'date'),
        SpacerElement(height: 20),
        VariableElement(
          variableName: 'recipient',
          prefix: 'To: ',
          prefixAr: 'إلى: ',
        ),
        SpacerElement(height: 10),
        VariableElement(
          variableName: 'subject',
          prefix: 'Subject: ',
          prefixAr: 'الموضوع: ',
          isBold: true,
        ),
        SpacerElement(height: 20),
        VariableElement(variableName: 'body'),
        SpacerElement(height: 30),
        TextElement(text: 'Sincerely,', textAr: 'مع التحية،'),
        SpacerElement(height: 10),
        VariableElement(variableName: 'sender'),
      ],
    );
  }
}
