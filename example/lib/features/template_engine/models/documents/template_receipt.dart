import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/template_engine/models/documents/template_build_result.dart';

Future<TemplateBuildResult> buildTemplateReceiptBytes(
  GeniusPdfConfig config) async {
  final templateBuilder = TemplateBuilder(
    id: 'demo-receipt',
    name: 'Receipt',
    nameAr: 'إيصال',
  )
      .addVariable(TemplateVariable.string('receiptNumber', required: true))
      .addVariable(TemplateVariable.date('receiptDate', required: true))
      .addVariable(TemplateVariable.string('customerName'))
      .addVariable(TemplateVariable.list('items'))
      .addVariable(TemplateVariable.currency('total'))
      .addVariable(TemplateVariable.string('paymentMethod'))
      .addText('RECEIPT', textAr: 'إيصال', fontSize: 24)
      .addSpacer(12)
      .addRow([
        const VariableElement(variableName: 'receiptNumber', prefix: 'Receipt #: '),
        const VariableElement(variableName: 'receiptDate', prefix: 'Date: '),
      ], flexValues: [1, 1])
      .addSpacer(8)
      .addVariableElement('customerName', prefix: 'Customer: ')
      .addSpacer(10)
      .addDivider()
      .addSpacer(8)
      .addTable(
        columns: [
          const TableColumn(field: 'name', title: 'Item', flex: 2),
          const TableColumn(field: 'qty', title: 'Qty', flex: 1),
          const TableColumn(field: 'price', title: 'Price', flex: 1),
        ],
        dataVariable: 'items',
      )
      .addSpacer(8)
      .addDivider()
      .addSpacer(6)
      .addElement(const VariableElement(
        variableName: 'total',
        prefix: 'Total: ',
        suffix: ' SAR',
        isBold: true,
      ))
      .addVariableElement('paymentMethod', prefix: 'Paid via: ')
      .addSpacer(8)
      .addText('Thank you for your purchase!', fontSize: 11);

  templateBuilder.description = 'Receipt template with payment summary';
  final template = templateBuilder.build();

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'receiptNumber': 'RCPT-2026-210',
      'receiptDate': DateTime.now().toString().split(' ')[0],
      'customerName': 'Noura Al-Salem',
      'items': [
        {'name': 'Notebook', 'qty': 2, 'price': 25},
        {'name': 'Pen Set', 'qty': 1, 'price': 40},
      ],
      'total': 90,
      'paymentMethod': 'Credit Card',
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
