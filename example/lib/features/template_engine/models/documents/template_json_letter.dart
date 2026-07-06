import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/template_engine/models/documents/template_build_result.dart';

Future<TemplateBuildResult> buildTemplateFromJsonLetterBytes(
  GeniusPdfConfig config,
) async {
  const jsonTemplate = '''
{
  "id": "json-letter",
  "name": "Business Letter",
  "nameAr": "خطاب رسمي",
  "version": "1.1.0",
  "category": "general",
  "variables": [
    {"name": "recipient", "type": "string", "required": true, "label": "Recipient"},
    {"name": "subject", "type": "string", "required": true, "label": "Subject"},
    {"name": "body", "type": "string", "required": true, "label": "Body"},
    {"name": "sender", "type": "string", "required": true, "label": "Sender"},
    {"name": "date", "type": "date", "label": "Date"},
    {"name": "company", "type": "string", "label": "Company"}
  ],
    GeniusPdfConfig config) async {
    {"type": "text", "text": "Company: ", "textAr": "الشركة: "},
    {"type": "variable", "variableName": "company"},
    {"type": "spacer", "height": 15},
    {"type": "variable", "variableName": "date"},
    {"type": "spacer", "height": 20},
    {"type": "variable", "variableName": "recipient", "prefix": "To: ", "prefixAr": "إلى: "},
    {"type": "spacer", "height": 15},
    {"type": "variable", "variableName": "subject", "prefix": "Subject: ", "prefixAr": "الموضوع: ", "isBold": true},
    {"type": "spacer", "height": 20},
    {"type": "variable", "variableName": "body"},
    {"type": "spacer", "height": 30},
    {"type": "text", "text": "Best regards,", "textAr": "مع أطيب التحيات،"},
    {"type": "spacer", "height": 10},
    {"type": "variable", "variableName": "sender", "isBold": true}
  ]
}
''';

  final template = TemplateDefinition.fromJsonString(jsonTemplate);

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'recipient': 'Mr. John Smith\nABC Corporation',
      'subject': 'Partnership Proposal',
      'body': 'Dear Mr. Smith,\n\nI am writing to propose a strategic partnership between our organizations. '
          'Our companies share similar values and complementary strengths that could benefit both parties.\n\n'
          'I would welcome the opportunity to discuss this proposal in detail at your convenience.',
      'sender': 'Sarah Johnson\nCEO, XYZ Inc.',
      'date': DateTime.now().toString().split(' ')[0],
      'company': 'XYZ Inc.',
    },
    isRtl: false,
  );
  return TemplateBuildResult(bytes: bytes, template: template);
}
