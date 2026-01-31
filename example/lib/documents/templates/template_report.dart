import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'template_build_result.dart';

Future<TemplateBuildResult> buildTemplateReportBytes(
  GeniusPdfConfig config) async {
  final templateBuilder = TemplateBuilder(
    id: 'demo-report',
    name: 'Monthly Report',
    nameAr: 'التقرير الشهري',
  )
      .addVariable(TemplateVariable.string('title', required: true))
      .addVariable(TemplateVariable.string('department'))
      .addVariable(TemplateVariable.date('reportDate'))
      .addVariable(TemplateVariable.list('highlights'))
      .addVariable(TemplateVariable.list('sections'))
      .addText('MONTHLY REPORT', textAr: 'التقرير الشهري', fontSize: 24)
      .addSpacer(15)
      .addVariableElement('title', prefix: 'Title: ')
      .addVariableElement('department', prefix: 'Department: ')
      .addVariableElement('reportDate', prefix: 'Date: ')
      .addSpacer(16)
      .addDivider(thickness: 2)
      .addSpacer(10)
      .addElement(const TextElement(
        text: 'Highlights',
        fontSize: 16,
        isBold: true,
      ))
      .addLoop(
        variable: 'highlights',
        itemName: 'item',
        children: const [
          VariableElement(variableName: 'item'),
          SpacerElement(height: 4),
        ],
      )
      .addSpacer(12)
      .addDivider()
      .addSpacer(12)
      .addLoop(
        variable: 'sections',
        itemName: 'section',
        children: const [
          VariableElement(
            variableName: 'section.title',
            fontSize: 16,
            isBold: true,
          ),
          SpacerElement(height: 5),
          VariableElement(variableName: 'section.content'),
          SpacerElement(height: 12),
        ],
      );

  templateBuilder.description =
      'Multi-section report template with highlights and notes';
  final template = templateBuilder.build();

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'title': 'Q1 Performance Review',
      'department': 'Engineering',
      'reportDate': DateTime.now().toString().split(' ')[0],
      'highlights': [
        'Revenue up 15% YoY',
        'Customer satisfaction 92%',
        'Cost reduction 8%',
      ],
      'sections': [
        {
          'title': 'Summary',
          'content':
              'Overall performance exceeded expectations with 120% target achievement.',
        },
        {
          'title': 'Key Achievements',
          'content':
              'Launched 3 new products, reduced costs by 15%, improved efficiency by 25%.',
        },
        {
          'title': 'Challenges',
          'content':
              'Supply chain disruptions caused delays in Q1. Mitigation measures implemented.',
        },
        {
          'title': 'Next Steps',
          'content':
              'Expand automation and invest in customer support training in Q2.',
        },
      ],
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
