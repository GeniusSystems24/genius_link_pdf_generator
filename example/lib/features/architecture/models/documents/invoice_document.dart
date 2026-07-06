// ignore_for_file: depend_on_referenced_packages

import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors, PdfColor;
import 'package:pdf/pdf.dart' hide PdfFont;
import 'package:pdf/widgets.dart' as pw;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart' show geniusPdfConfig;

Future<Uint8List> buildInvoiceDocumentBytes() async {
  final today = DateTime.now().toString().split(' ')[0];
  const primaryColor = PdfColor.fromInt(0xFF6366F1);
  const lightBg = PdfColor.fromInt(0xFFF8FAFC);
  const darkText = PdfColor.fromInt(0xFF1E293B);
  const lightText = PdfColor.fromInt(0xFF64748B);

  return GeniusPdfBuilder(
    id: 'invoice-001',
    config: GeniusPdfConfig(
      baseFontBytes: geniusPdfConfig.assets.primaryFont,
      baseFontSize: 10,
    ),
  )
      .metadata(title: 'Invoice INV-2026-001', author: 'Genius Systems')
      .pageFormat(PdfPageFormat.a4)
      .addPage((page) => page
          .container(
            decoration: const pw.BoxDecoration(
              color: PdfColors.white,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.all(24),
                  decoration: const pw.BoxDecoration(
                    color: primaryColor,
                    borderRadius:
                        pw.BorderRadius.vertical(top: pw.Radius.circular(0)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'INVOICE',
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            '#INV-2026-001',
                            style: const pw.TextStyle(
                              fontSize: 14,
                              color: PdfColors.white,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            'Genius Systems',
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white,
                            ),
                          ),
                          pw.Text(
                            'Riyadh, Saudi Arabia',
                            style: const pw.TextStyle(
                              fontSize: 10,
                              color: PdfColors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(24),
                  child: pw.Column(
                    children: [
                      // Info Grid
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Bill To',
                                    style: pw.TextStyle(
                                        color: lightText, fontSize: 10)),
                                pw.SizedBox(height: 4),
                                pw.Text('Ahmed Mohamed',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: darkText)),
                                pw.Text('ABC Company',
                                    style: const pw.TextStyle(color: darkText)),
                                pw.Text('Riyadh, Saudi Arabia',
                                    style: const pw.TextStyle(color: darkText)),
                              ],
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text('Date',
                                    style: pw.TextStyle(
                                        color: lightText, fontSize: 10)),
                                pw.SizedBox(height: 4),
                                pw.Text(today,
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: darkText)),
                                pw.SizedBox(height: 12),
                                pw.Text('Due Date',
                                    style: pw.TextStyle(
                                        color: lightText, fontSize: 10)),
                                pw.SizedBox(height: 4),
                                pw.Text('Within 14 days',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: darkText)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 32),
                      // Table
                      pw.Table.fromTextArray(
                        headerDecoration: const pw.BoxDecoration(
                          color: lightBg,
                          borderRadius: pw.BorderRadius.vertical(
                              top: pw.Radius.circular(4)),
                        ),
                        headerHeight: 30,
                        cellHeight: 30,
                        headerStyle: pw.TextStyle(
                          color: darkText,
                          fontSize: 10,
                          fontWeight: pw.FontWeight.bold,
                        ),
                        cellStyle: const pw.TextStyle(
                          color: darkText,
                          fontSize: 10,
                        ),
                        rowDecoration: const pw.BoxDecoration(
                          border: pw.Border(
                            bottom: pw.BorderSide(
                              color: PdfColors.grey200,
                              width: 0.5,
                            ),
                          ),
                        ),
                        headers: [
                          'Item Description',
                          'Qty',
                          'Unit Price',
                          'Total'
                        ],
                        data: [
                          [
                            'Product A - Premium License',
                            '2',
                            '150.00 SAR',
                            '300.00 SAR'
                          ],
                          [
                            'Product B - Standard License',
                            '1',
                            '250.00 SAR',
                            '250.00 SAR'
                          ],
                          [
                            'Service C - Consultation',
                            '3',
                            '100.00 SAR',
                            '300.00 SAR'
                          ],
                        ],
                      ),
                      pw.SizedBox(height: 24),
                      // Totals
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.end,
                        children: [
                          pw.Container(
                            width: 200,
                            child: pw.Column(
                              children: [
                                pw.Row(
                                  children: [
                                    pw.Expanded(
                                        child: pw.Text('Subtotal',
                                            style: pw.TextStyle(
                                                color: lightText))),
                                    pw.Text('850.00 SAR',
                                        style: pw.TextStyle(color: darkText)),
                                  ],
                                ),
                                pw.SizedBox(height: 8),
                                pw.Row(
                                  children: [
                                    pw.Expanded(
                                        child: pw.Text('VAT (15%)',
                                            style: pw.TextStyle(
                                                color: lightText))),
                                    pw.Text('127.50 SAR',
                                        style: pw.TextStyle(color: darkText)),
                                  ],
                                ),
                                pw.Divider(color: PdfColors.grey200),
                                pw.Row(
                                  children: [
                                    pw.Expanded(
                                        child: pw.Text('Total',
                                            style: pw.TextStyle(
                                                fontWeight: pw.FontWeight.bold,
                                                fontSize: 14,
                                                color: primaryColor))),
                                    pw.Text('977.50 SAR',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            fontSize: 14,
                                            color: primaryColor)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 48),
                      // Footer
                      pw.Container(
                        width: double.infinity,
                        padding: const pw.EdgeInsets.all(16),
                        decoration: pw.BoxDecoration(
                          color: lightBg,
                          borderRadius: pw.BorderRadius.circular(8),
                        ),
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text('Payment Terms',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: darkText,
                                    fontSize: 11)),
                            pw.SizedBox(height: 4),
                            pw.Text(
                                'Payment due within 14 days. Please include invoice number in reference.',
                                style: pw.TextStyle(
                                    color: lightText, fontSize: 10)),
                            pw.SizedBox(height: 8),
                            pw.Text('Support',
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: darkText,
                                    fontSize: 11)),
                            pw.SizedBox(height: 4),
                            pw.Text(
                                'Email: support@genius-systems.com  |  Phone: +966-555-123-456',
                                style: pw.TextStyle(
                                    color: lightText, fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
          .build())
      .buildBytes();
}
