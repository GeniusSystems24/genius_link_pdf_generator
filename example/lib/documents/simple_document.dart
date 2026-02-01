import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors, PdfColor;
import 'package:pdf/pdf.dart' as p hide PdfFont;
import 'package:pdf/widgets.dart' as pw;

import '../main.dart' show geniusPdfConfig;

Future<Uint8List> buildSimpleDocumentBytes() async {
  const primaryColor = p.PdfColor.fromInt(0xFF6366F1);
  const lightBg = p.PdfColor.fromInt(0xFFF8FAFC);

  return GeniusPdfBuilder(
    id: 'simple-doc',
    config: GeniusPdfConfig(
      baseFontBytes: geniusPdfConfig.assets.primaryFont,
      baseFontSize: 10,
    ),
  )
      .metadata(title: 'Simple Document', author: 'Demo')
      .pageFormat(p.PdfPageFormat.a4)
      .addPage((page) => page
          .container(
            decoration: const pw.BoxDecoration(color: p.PdfColors.white),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 24, vertical: 20),
                  decoration: const pw.BoxDecoration(
                    color: lightBg,
                    border: pw.Border(
                        left: pw.BorderSide(color: primaryColor, width: 4)),
                  ),
                  width: double.infinity,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('ARCHITECTURE OVERVIEW',
                          style: pw.TextStyle(
                              color: primaryColor,
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                              letterSpacing: 1.2)),
                      pw.SizedBox(height: 4),
                      pw.Text('V2 Architecture Highlights',
                          style: pw.TextStyle(
                              fontSize: 24, fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(24),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          'This document demonstrates a detailed, component-rich layout '
                          'using the enhanced Fluent API. It includes headers, subheaders, '
                          'tables, lists, dividers, rich text, and styled containers.',
                          style: const pw.TextStyle(
                              lineSpacing: 2, color: p.PdfColors.grey700)),
                      pw.SizedBox(height: 24),
                      pw.Row(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Expanded(
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Core Principles',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 14)),
                                  pw.SizedBox(height: 8),
                                  pw.Bullet(
                                      text: 'Plugin System for extensibility'),
                                  pw.Bullet(
                                      text: 'Dependency Injection container'),
                                  pw.Bullet(text: 'Event-driven architecture'),
                                  pw.Bullet(text: 'Smart caching system'),
                                ]),
                          ),
                          pw.SizedBox(width: 24),
                          pw.Expanded(
                            child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Key Benefits',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 14)),
                                  pw.SizedBox(height: 8),
                                  pw.Bullet(
                                      text:
                                          'Define content with chainable methods'),
                                  pw.Bullet(text: 'Generate bytes in-memory'),
                                  pw.Bullet(
                                      text: 'Save and open with one flow'),
                                  pw.Bullet(text: 'Platform compatibility'),
                                ]),
                          ),
                        ],
                      ),
                      pw.SizedBox(height: 24),
                      pw.Divider(color: p.PdfColors.grey200),
                      pw.SizedBox(height: 24),
                      pw.Text('Quick Comparison',
                          style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold, fontSize: 14)),
                      pw.SizedBox(height: 12),
                      // ignore: deprecated_member_use
                      pw.Table.fromTextArray(
                        headerDecoration:
                            const pw.BoxDecoration(color: lightBg),
                        headerStyle: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                            fontSize: 10,
                            color: primaryColor),
                        cellStyle: const pw.TextStyle(fontSize: 10),
                        cellAlignments: {
                          0: pw.Alignment.centerLeft,
                          1: pw.Alignment.centerLeft,
                          2: pw.Alignment.center
                        },
                        headers: ['Module', 'Purpose', 'Status'],
                        data: [
                          ['Fluent API', 'Document building', 'Stable'],
                          ['Plugins', 'Extensibility layer', 'Beta'],
                          ['DI', 'Service resolution', 'Stable'],
                          ['Events', 'Lifecycle tracking', 'Stable'],
                        ],
                      ),
                      pw.SizedBox(height: 20),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(12),
                        decoration: pw.BoxDecoration(
                          color: const p.PdfColor.fromInt(
                              0xFFEEF2FF), // Very light Indigo
                          borderRadius: pw.BorderRadius.circular(6),
                          border: pw.Border.all(
                              color: const p.PdfColor.fromInt(0xFFC7D2FE)),
                        ),
                        child: pw.Row(
                          children: [
                            pw.Container(
                              width: 40,
                              height: 40,
                              decoration: const pw.BoxDecoration(
                                  color: primaryColor,
                                  shape: pw.BoxShape.circle),
                              child: pw.Center(
                                  child: pw.Text('i',
                                      style: pw.TextStyle(
                                          color: p.PdfColors.white,
                                          fontWeight: pw.FontWeight.bold,
                                          fontSize: 18))),
                            ),
                            pw.SizedBox(width: 12),
                            pw.Expanded(
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text('Pro Tip',
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold,
                                          color: primaryColor)),
                                  pw.Text(
                                      'You can mix built-in components with custom widgets to build complex layouts.',
                                      style: const pw.TextStyle(
                                          fontSize: 10,
                                          color: p.PdfColors.grey700)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                pw.Spacer(),
                // Footer
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(16),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                        top: pw.BorderSide(color: p.PdfColors.grey200)),
                  ),
                  child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text('Generated by Genius Link',
                            style: const pw.TextStyle(
                                color: p.PdfColors.grey500, fontSize: 8)),
                        pw.Text('Page 1 of 1',
                            style: const pw.TextStyle(
                                color: p.PdfColors.grey500, fontSize: 8)),
                      ]),
                ),
              ],
            ),
          )
          .build())
      .buildBytes();
}
