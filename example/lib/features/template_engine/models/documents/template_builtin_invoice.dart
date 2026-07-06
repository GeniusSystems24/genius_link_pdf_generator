import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/template_engine/models/documents/template_build_result.dart';

Future<TemplateBuildResult> buildBuiltInInvoiceBytes(
  GeniusPdfConfig config) async {
  final registry = TemplateRegistry.instance;

  if (!registry.has('builtin-simple-invoice')) {
    TemplateLibrary.registerBuiltInTemplates(registry);
  }

  final template = registry.getOrThrow('builtin-simple-invoice');

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'invoiceNumber': 'INV-2026-999',
      'invoiceDate': DateTime.now().toIso8601String(),
      'customerName': 'Test Customer',
      'items': [
        {'name': 'Service A', 'quantity': 1, 'price': 500, 'total': 500},
        {'name': 'Service B', 'quantity': 2, 'price': 250, 'total': 500},
      ],
      'total': 1000,
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
