import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'template_build_result.dart';

Future<TemplateBuildResult> buildTemplateContractBytes(
  GeniusPdfConfig config) async {
  final templateBuilder = TemplateBuilder(
    id: 'demo-contract',
    name: 'Service Contract',
    nameAr: 'عقد خدمة',
  )
      .addVariable(TemplateVariable.string('contractNumber', required: true))
      .addVariable(TemplateVariable.date('contractDate', required: true))
      .addVariable(TemplateVariable.string('partyA', required: true))
      .addVariable(TemplateVariable.string('partyB', required: true))
      .addVariable(TemplateVariable.string('scope', required: true))
      .addVariable(TemplateVariable.string('term', required: true))
      .addVariable(TemplateVariable.currency('value', required: true))
      .addText('SERVICE CONTRACT', textAr: 'عقد خدمة', fontSize: 22)
      .addSpacer(10)
      .addVariableElement('contractNumber', prefix: 'Contract #: ')
      .addVariableElement('contractDate', prefix: 'Date: ')
      .addSpacer(10)
      .addDivider()
      .addSpacer(8)
      .addText('Parties', fontSize: 16)
      .addVariableElement('partyA', prefix: 'Party A: ')
      .addVariableElement('partyB', prefix: 'Party B: ')
      .addSpacer(10)
      .addText('Scope of Work', fontSize: 16)
      .addVariableElement('scope')
      .addSpacer(10)
      .addText('Term', fontSize: 16)
      .addVariableElement('term')
      .addSpacer(10)
      .addText('Contract Value', fontSize: 16)
      .addElement(const VariableElement(
        variableName: 'value',
        prefix: 'Total: ',
        suffix: ' SAR',
        isBold: true,
      ))
      .addSpacer(12)
      .addText('Signatures:', fontSize: 14)
      .addSpacer(20)
      .addRow([
        const TextElement(text: 'Party A Signature: __________________'),
        const TextElement(text: 'Party B Signature: __________________'),
      ], flexValues: [1, 1]);

  templateBuilder.description = 'Service contract with parties, scope, and value';
  final template = templateBuilder.build();

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'contractNumber': 'CT-2026-031',
      'contractDate': DateTime.now().toString().split(' ')[0],
      'partyA': 'Genius Systems',
      'partyB': 'Al Noor Trading',
      'scope': 'Provide ERP implementation, training, and support for 6 months.',
      'term': 'Start: 2026-02-01, End: 2026-07-31',
      'value': 120000,
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
