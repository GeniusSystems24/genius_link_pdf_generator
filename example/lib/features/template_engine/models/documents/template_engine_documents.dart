import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

class TemplateBuildResult {
  final Uint8List bytes;
  final TemplateDefinition template;

  const TemplateBuildResult({
    required this.bytes,
    required this.template,
  });
}

Future<TemplateBuildResult> buildTemplateInvoiceBytes(
  GeniusPdfConfig config) async {
  final template = TemplateBuilder(
    id: 'demo-invoice',
    name: 'Demo Invoice',
    nameAr: 'فاتورة تجريبية',
  )
      .addVariable(TemplateVariable.string('invoiceNumber', required: true))
      .addVariable(TemplateVariable.string('customerName', required: true))
      .addVariable(TemplateVariable.date('invoiceDate'))
      .addVariable(TemplateVariable.list('items'))
      .addVariable(TemplateVariable.currency('total'))
      .addText('INVOICE', textAr: 'فاتورة', fontSize: 24)
      .addSpacer(20)
      .addRow([
        const VariableElement(
          variableName: 'invoiceNumber',
          prefix: 'Invoice #: ',
          prefixAr: 'رقم الفاتورة: ',
        ),
        const VariableElement(
          variableName: 'invoiceDate',
          prefix: 'Date: ',
          prefixAr: 'التاريخ: ',
        ),
      ], flexValues: [
        1,
        1
      ])
      .addSpacer(10)
      .addVariableElement('customerName', prefix: 'Customer: ')
      .addSpacer(20)
      .addDivider()
      .addSpacer(10)
      .addTable(
        columns: [
          const TableColumn(
              field: 'name', title: 'Item', titleAr: 'البند', flex: 2),
          const TableColumn(
              field: 'qty', title: 'Qty', titleAr: 'الكمية', flex: 1),
          const TableColumn(
              field: 'price', title: 'Price', titleAr: 'السعر', flex: 1),
        ],
        dataVariable: 'items',
      )
      .addSpacer(10)
      .addDivider()
      .addSpacer(10)
      .addVariableElement('total', prefix: 'Total: ', suffix: ' SAR')
      .build();

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'invoiceNumber': 'INV-2026-001',
      'customerName': 'Ahmed Mohamed',
      'invoiceDate': DateTime.now().toString().split(' ')[0],
      'items': [
        {'name': 'Product A', 'qty': 2, 'price': 150},
        {'name': 'Product B', 'qty': 1, 'price': 300},
        {'name': 'Product C', 'qty': 3, 'price': 75},
      ],
      'total': 825,
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}

Future<TemplateBuildResult> buildTemplateReportBytes(
  GeniusPdfConfig config) async {
  final template = TemplateBuilder(
    id: 'demo-report',
    name: 'Monthly Report',
    nameAr: 'التقرير الشهري',
  )
      .addVariable(TemplateVariable.string('title', required: true))
      .addVariable(TemplateVariable.string('department'))
      .addVariable(TemplateVariable.date('reportDate'))
      .addVariable(TemplateVariable.list('sections'))
      .addText('MONTHLY REPORT', textAr: 'التقرير الشهري', fontSize: 24)
      .addSpacer(15)
      .addVariableElement('title', prefix: 'Title: ')
      .addVariableElement('department', prefix: 'Department: ')
      .addVariableElement('reportDate', prefix: 'Date: ')
      .addSpacer(20)
      .addDivider(thickness: 2)
      .addSpacer(15)
      .addLoop(
        variable: 'sections',
        itemName: 'section',
        children: [
          const VariableElement(
            variableName: 'section.title',
            fontSize: 16,
            isBold: true,
          ),
          const SpacerElement(height: 5),
          const VariableElement(variableName: 'section.content'),
          const SpacerElement(height: 15),
        ],
      )
      .build();

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'title': 'Q1 Performance Review',
      'department': 'Engineering',
      'reportDate': DateTime.now().toString().split(' ')[0],
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
      ],
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}

Future<TemplateBuildResult> buildTemplateFromJsonBytes(
  GeniusPdfConfig config) async {
  const jsonTemplate = '''
{
  "id": "json-letter",
  "name": "Business Letter",
  "nameAr": "خطاب رسمي",
  "version": "1.0.0",
  "category": "general",
  "variables": [
    {"name": "recipient", "type": "string", "required": true, "label": "Recipient"},
    {"name": "subject", "type": "string", "required": true, "label": "Subject"},
    {"name": "body", "type": "string", "required": true, "label": "Body"},
    {"name": "sender", "type": "string", "required": true, "label": "Sender"},
    {"name": "date", "type": "date", "label": "Date"}
  ],
  "content": [
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
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}

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
