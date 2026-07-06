import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/template_engine/models/documents/template_build_result.dart';

Future<TemplateBuildResult> buildBuiltInReportBytes(
  GeniusPdfConfig config) async {
  final registry = TemplateRegistry.instance;

  if (!registry.has('builtin-simple-report')) {
    TemplateLibrary.registerBuiltInTemplates(registry);
  }

  final template = registry.getOrThrow('builtin-simple-report');

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'title': 'Operations Summary',
      'date': DateTime.now().toString().split(' ')[0],
      'content': 'Operations remained stable with service uptime at 99.8%. '
          'No critical incidents were recorded this month.',
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
