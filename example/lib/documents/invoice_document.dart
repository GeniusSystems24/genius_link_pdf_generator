import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:pdf/pdf.dart' hide PdfFont;
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> buildInvoiceDocumentBytes() async {
  final today = DateTime.now().toString().split(' ')[0];

  return GeniusPdfBuilder(id: 'invoice-001')
      .metadata(title: 'Invoice INV-2026-001', author: 'Genius Systems')
      .pageFormat(PdfPageFormat.a4)
      .addPage((page) => page
          .header('INVOICE', fontSize: 28)
          .spacer(10)
          .row([
            pw.Expanded(child: pw.Text('Invoice Number: INV-2026-001')),
            pw.Text('Date: $today'),
          ])
          .spacer(12)
          .subheader('Bill To')
          .paragraph('Ahmed Mohamed\nABC Company\nRiyadh, Saudi Arabia')
          .spacer(10)
          .subheader('Invoice Details')
          .table(
            [
              ['Product A', '2', '150 SAR', '300 SAR'],
              ['Product B', '1', '250 SAR', '250 SAR'],
              ['Service C', '3', '100 SAR', '300 SAR'],
            ],
            headers: ['Item', 'Qty', 'Unit Price', 'Total'],
          )
          .spacer(10)
          .container(
            padding: const pw.EdgeInsets.all(10),
            decoration: pw.BoxDecoration(
              color: PdfColors.blueGrey50,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: PdfColors.blueGrey200),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Totals', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 6),
                pw.Row(children: [
                  pw.Expanded(child: pw.Text('Subtotal')),
                  pw.Text('850 SAR'),
                ]),
                pw.Row(children: [
                  pw.Expanded(child: pw.Text('VAT (15%)')),
                  pw.Text('127.50 SAR'),
                ]),
                pw.Divider(),
                pw.Row(children: [
                  pw.Expanded(child: pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold))),
                  pw.Text('977.50 SAR', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ]),
              ],
            ),
          )
          .spacer(10)
          .subheader('Payment Terms')
          .numberedList([
            'Payment due within 14 days.',
            'Bank transfer preferred.',
            'Include invoice number in reference.',
          ])
          .spacer(8)
          .bulletList([
            'Support: support@genius-systems.com',
            'Phone: +966-555-123-456',
          ])
          .spacer(8)
          .richText([
            pw.TextSpan(text: 'Note: ', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
            const pw.TextSpan(text: 'Please contact us for any billing questions.'),
          ])
          .spacer(12)
          .footer('Thank you for your business')
          .build())
      .buildBytes();
}
