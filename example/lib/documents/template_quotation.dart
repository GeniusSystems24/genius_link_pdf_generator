import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'template_build_result.dart';

Future<TemplateBuildResult> buildTemplateQuotationBytes(
  GeniusPdfConfig config) async {
  final templateBuilder = TemplateBuilder(
    id: 'demo-quote',
    name: 'Quotation',
    nameAr: 'عرض سعر',
  )
      .addVariable(TemplateVariable.string('quoteNumber', required: true))
      .addVariable(TemplateVariable.date('quoteDate', required: true))
      .addVariable(TemplateVariable.string('customerName', required: true))
      .addVariable(TemplateVariable.string('validUntil'))
      .addVariable(TemplateVariable.list('items', required: true))
      .addVariable(TemplateVariable.currency('subtotal'))
      .addVariable(TemplateVariable.currency('discount'))
      .addVariable(TemplateVariable.currency('total'))
      .addText('QUOTATION', textAr: 'عرض سعر', fontSize: 24)
      .addSpacer(12)
      .addRow([
        const VariableElement(variableName: 'quoteNumber', prefix: 'Quote #: '),
        const VariableElement(variableName: 'quoteDate', prefix: 'Date: '),
      ], flexValues: [1, 1])
      .addSpacer(6)
      .addRow([
        const VariableElement(variableName: 'customerName', prefix: 'Customer: '),
        const VariableElement(variableName: 'validUntil', prefix: 'Valid Until: '),
      ], flexValues: [1, 1])
      .addSpacer(10)
      .addDivider()
      .addSpacer(8)
      .addTable(
        columns: [
          const TableColumn(field: 'name', title: 'Item', flex: 2),
          const TableColumn(field: 'qty', title: 'Qty', flex: 1),
          const TableColumn(field: 'price', title: 'Price', flex: 1),
          const TableColumn(field: 'total', title: 'Total', flex: 1),
        ],
        dataVariable: 'items',
      )
      .addSpacer(8)
      .addDivider()
      .addSpacer(6)
      .addVariableElement('subtotal', prefix: 'Subtotal: ', suffix: ' SAR')
      .addVariableElement('discount', prefix: 'Discount: ', suffix: ' SAR')
      .addElement(const VariableElement(
        variableName: 'total',
        prefix: 'Total: ',
        suffix: ' SAR',
        isBold: true,
      ))
      .addSpacer(8)
      .addText('Prices are valid for 14 days.', fontSize: 11);

  templateBuilder.description = 'Quotation template with validity and discounts';
  final template = templateBuilder.build();

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'quoteNumber': 'Q-2026-011',
      'quoteDate': DateTime.now().toString().split(' ')[0],
      'customerName': 'Tech Horizon LLC',
      'validUntil': '2026-02-14',
      'items': [
        {'name': 'Software License', 'qty': 5, 'price': 1200, 'total': 6000},
        {'name': 'Implementation', 'qty': 1, 'price': 3500, 'total': 3500},
      ],
      'subtotal': 9500,
      'discount': 500,
      'total': 9000,
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
