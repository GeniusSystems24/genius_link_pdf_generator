import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/template_engine/models/documents/template_build_result.dart';

Future<TemplateBuildResult> buildTemplatePurchaseOrderBytes(
  GeniusPdfConfig config,
) async {
  final templateBuilder = TemplateBuilder(
    id: 'demo-po',
    name: 'Purchase Order',
    nameAr: 'أمر شراء',
  )
      .addVariable(TemplateVariable.string('poNumber', required: true))
      .addVariable(TemplateVariable.date('poDate', required: true))
      .addVariable(TemplateVariable.string('supplierName', required: true))
      .addVariable(TemplateVariable.string('buyerName', required: true))
      .addVariable(TemplateVariable.list('items', required: true))
      .addVariable(TemplateVariable.currency('total', required: true))
      .addText('PURCHASE ORDER', textAr: 'أمر شراء', fontSize: 24)
      .addSpacer(16)
      .addRow([
        const VariableElement(variableName: 'poNumber', prefix: 'PO #: '),
        const VariableElement(variableName: 'poDate', prefix: 'Date: '),
      ], flexValues: [
        1,
        1
      ])
      .addSpacer(8)
      .addRow([
        const VariableElement(
            variableName: 'supplierName', prefix: 'Supplier: '),
        const VariableElement(variableName: 'buyerName', prefix: 'Buyer: '),
      ], flexValues: [
        1,
        1
      ])
      .addSpacer(12)
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
      .addSpacer(8)
      .addElement(const VariableElement(
        variableName: 'total',
        prefix: 'Total: ',
        suffix: ' SAR',
        isBold: true,
      ))
      .addSpacer(10)
      .addText('Delivery within 7 business days.', fontSize: 11);

  templateBuilder.description =
      'Purchase order with supplier info and item list';
  final template = templateBuilder.build();

  final engine = PdfTemplateEngine(config: config);
  final bytes = await engine.render(
    template: template,
    data: {
      'poNumber': 'PO-2026-045',
      'poDate': DateTime.now().toString().split(' ')[0],
      'supplierName': 'Alpha Supplies Co.',
      'buyerName': 'Genius Systems',
      'items': [
        {'name': 'Printer Paper', 'qty': 10, 'price': 25, 'total': 250},
        {'name': 'Ink Cartridges', 'qty': 4, 'price': 120, 'total': 480},
        {'name': 'Office Chairs', 'qty': 2, 'price': 450, 'total': 900},
      ],
      'total': 1630,
    },
    isRtl: false,
  );

  return TemplateBuildResult(bytes: bytes, template: template);
}
