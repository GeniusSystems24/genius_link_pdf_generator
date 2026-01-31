import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

String buildExportTemplateJson() {
  final template = TemplateDefinition(
    id: 'export-demo',
    name: 'Export Demo',
    nameAr: 'عرض التصدير',
    description: 'A template for demonstrating JSON export',
    version: '1.0.0',
    author: 'Genius Systems',
    category: TemplateCategory.general,
    tags: ['demo', 'export', 'example'],
    variables: [
      TemplateVariable.string('title', required: true, label: 'Title'),
      TemplateVariable.list('items', label: 'Items'),
    ],
    content: const [
      TextElement(text: 'Demo Template', fontSize: 20),
      SpacerElement(height: 10),
      VariableElement(variableName: 'title'),
      SpacerElement(height: 6),
      TextElement(text: 'Items:'),
      SpacerElement(height: 4),
      VariableElement(variableName: 'items'),
    ],
  );

  return template.toJsonString(pretty: true);
}
