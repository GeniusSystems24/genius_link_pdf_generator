import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'template_build_result.dart';

Future<TemplateBuildResult> buildTemplateInvoiceBytes(
  GeniusPdfConfig config) async {
  final templateBuilder = TemplateBuilder(
    id: 'demo-invoice',
    name: 'Demo Invoice',
    nameAr: 'فاتورة تجريبية',
  )
      .addVariable(TemplateVariable.string('invoiceNumber', required: true))
      .addVariable(TemplateVariable.string('customerName', required: true))
      .addVariable(TemplateVariable.date('invoiceDate'))
      .addVariable(TemplateVariable.list('items'))
      .addVariable(TemplateVariable.currency('subtotal'))
      .addVariable(TemplateVariable.currency('vat'))
      .addVariable(TemplateVariable.currency('total'))
      .addElement(const TextElement(
        text: 'INVOICE',
        textAr: 'فاتورة',
        fontSize: 24,
        isBold: true,
      ))
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
      ], flexValues: [1, 1])
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
          const TableColumn(
              field: 'total', title: 'Total', titleAr: 'الإجمالي', flex: 1),
        ],
        dataVariable: 'items',
      )
      .addSpacer(10)
      .addDivider()
      .addSpacer(10)
      .addVariableElement('subtotal', prefix: 'Subtotal: ', suffix: ' SAR')
      .addVariableElement('vat', prefix: 'VAT (15%): ', suffix: ' SAR')
      .addElement(const VariableElement(
        variableName: 'total',
        prefix: 'Total: ',
        suffix: ' SAR',
        isBold: true,
      ))
      .addSpacer(10)
      .addText('Payment due within 14 days.', fontSize: 11)
      .addText('Thank you for your business.', fontSize: 11);

  templateBuilder.description =
      'Detailed invoice template with totals and notes';
  final template = templateBuilder.build();

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'invoiceNumber': 'INV-2026-001',
      'customerName': 'Ahmed Mohamed',
      'invoiceDate': DateTime.now().toString().split(' ')[0],
      'items': [
        {'name': 'Product A', 'qty': 2, 'price': 150, 'total': 300},
        {'name': 'Product B', 'qty': 1, 'price': 250, 'total': 250},
        {'name': 'Service C', 'qty': 3, 'price': 100, 'total': 300},
      ],
      'subtotal': 850,
      'vat': 127.5,
      'total': 977.5,
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
