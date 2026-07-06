import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/template_engine/models/documents/template_build_result.dart';

Future<TemplateBuildResult> buildBuiltInLetterBytes(
  GeniusPdfConfig config) async {
  final registry = TemplateRegistry.instance;

  if (!registry.has('builtin-simple-letter')) {
    TemplateLibrary.registerBuiltInTemplates(registry);
  }

  final template = registry.getOrThrow('builtin-simple-letter');

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'date': DateTime.now().toString().split(' ')[0],
      'recipient': 'Finance Department',
      'subject': 'Budget Alignment',
      'body': 'Please review the Q2 budget allocations and provide feedback by next week.',
      'sender': 'Operations Director',
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
