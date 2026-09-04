/// Template engine for dynamic PDF generation.
///
/// This library provides a flexible template engine for creating PDF documents
/// from template definitions with variable substitution, conditional rendering,
/// and loops.
///
/// ## Quick Start
/// ```dart
/// import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
///
/// // Create engine
/// final engine = PdfTemplateEngine(config: config);
///
/// // Define a template
/// final template = TemplateDefinition(
///   id: 'my-template',
///   name: 'My Template',
///   variables: [
///     TemplateVariable.string('title', required: true),
///     TemplateVariable.list('items'),
///   ],
///   content: [
///     VariableElement(variableName: 'title'),
///     LoopElement(
///       loop: TemplateLoop(variable: 'items'),
///       children: [
///         VariableElement(variableName: 'item.name'),
///       ],
///     ),
///   ],
/// );
///
/// // Render with data
/// final bytes = await engine.render(
///   template: template,
///   data: {
///     'title': 'My Report',
///     'items': [{'name': 'Item 1'}, {'name': 'Item 2'}],
///   },
/// );
/// ```
///
/// ## Template Builder
/// ```dart
/// final template = TemplateBuilder(id: 'report', name: 'Report')
///   .addVariable(TemplateVariable.string('title'))
///   .addText('Report')
///   .addVariableElement('title')
///   .addDivider()
///   .build();
/// ```
///
/// ## Template Registry
/// ```dart
/// final registry = TemplateRegistry.instance;
/// registry.register(template);
///
/// final myTemplate = registry.get('my-template');
/// ```
library;

export 'pdf_template_engine.dart';
export 'template_definition.dart';
export 'template_elements.dart';
export 'template_models.dart';
export 'template_registry.dart';
export 'erp_family_registry_extension.dart';
