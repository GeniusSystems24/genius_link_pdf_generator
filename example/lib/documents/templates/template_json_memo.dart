import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'template_build_result.dart';

Future<TemplateBuildResult> buildTemplateFromJsonMemoBytes(
  GeniusPdfConfig config,
) async {
  const jsonTemplate = '''
{
  "id": "json-memo",
  "name": "Internal Memo",
  "nameAr": "مذكرة داخلية",
  "version": "1.0.0",
  "category": "general",
  "variables": [
    {"name": "to", "type": "string", "required": true, "label": "To"},
    {"name": "from", "type": "string", "required": true, "label": "From"},
    {"name": "subject", "type": "string", "required": true, "label": "Subject"},
    {"name": "date", "type": "date", "label": "Date"},
    {"name": "body", "type": "string", "required": true, "label": "Body"},
    {"name": "action", "type": "string", "label": "Action Required"}
  ],
  "content": [
    {"type": "text", "text": "MEMO", "textAr": "مذكرة", "fontSize": 22, "isBold": true},
    {"type": "spacer", "height": 15},
    {"type": "variable", "variableName": "to", "prefix": "To: ", "prefixAr": "إلى: "},
    {"type": "variable", "variableName": "from", "prefix": "From: ", "prefixAr": "من: "},
    {"type": "variable", "variableName": "date", "prefix": "Date: ", "prefixAr": "التاريخ: "},
    {"type": "variable", "variableName": "subject", "prefix": "Subject: ", "prefixAr": "الموضوع: ", "isBold": true},
    {"type": "spacer", "height": 15},
    {"type": "variable", "variableName": "body"},
    {"type": "spacer", "height": 15},
    {"type": "variable", "variableName": "action", "prefix": "Action: ", "prefixAr": "الإجراء: ", "isBold": true}
  ]
}
''';

  final template = TemplateDefinition.fromJsonString(jsonTemplate);

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'to': 'Operations Team',
      'from': 'HR Department',
      'subject': 'Policy Update',
      'date': DateTime.now().toString().split(' ')[0],
      'body': 'Please review the updated attendance policy effective next month. '
          'Managers should brief their teams and acknowledge receipt.',
      'action': 'Acknowledge via email by Friday',
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
