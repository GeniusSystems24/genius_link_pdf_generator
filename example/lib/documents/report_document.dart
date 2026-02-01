import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:pdf/pdf.dart' hide PdfFont;
import 'package:pdf/widgets.dart' as pw;

import '../main.dart' show geniusPdfConfig;

Future<Uint8List> buildMultiPageReportBytes() async {
    return GeniusPdfBuilder(
                id: 'monthly-report',
                                config: GeniusPdfConfig(
                                    baseFontBytes: geniusPdfConfig.assets.primaryFont,
                                    baseFontSize: 10,
                                ),
            )
      .metadata(title: 'Monthly Report', author: 'System')
      .pageFormat(PdfPageFormat.a4)
      .addMultiPage((mp) => mp
          .textHeader('Monthly Performance Report - January 2026')
          .pageNumberFooter(format: 'Page {page} of {pages}')
          .heading('Executive Summary')
          .paragraph('This report provides a comprehensive overview of our '
              'performance metrics for January 2026. Key highlights include '
              'revenue growth of 15% and customer satisfaction scores above 90%.')
          .heading('Key Results', level: 1)
                    .addAll([
                        pw.Bullet(text: 'Revenue growth: +15% YoY'),
                        pw.Bullet(text: 'Customer satisfaction: 92% average'),
                        pw.Bullet(text: 'Operational cost reduction: 8%'),
                        pw.Bullet(text: 'On-time delivery: 96%'),
                        pw.SizedBox(height: 8),
                    ])
          .heading('Revenue Analysis', level: 1)
          .paragraph('Total revenue for the month reached 1.5 million SAR, '
              'representing a 15% increase compared to the same period last year.')
                    .add(pw.TableHelper.fromTextArray(
                        headers: const ['Region', 'Revenue', 'Change'],
                        data: const [
                            ['Riyadh', '620K SAR', '+12%'],
                            ['Jeddah', '540K SAR', '+18%'],
                            ['Dammam', '340K SAR', '+14%'],
                        ],
                    ))
                    .add(pw.SizedBox(height: 8))
                    .add(pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        decoration: pw.BoxDecoration(
                            color: PdfColors.blueGrey50,
                            borderRadius: pw.BorderRadius.circular(6),
                            border: pw.Border.all(color: PdfColors.blueGrey200),
                        ),
                        child: pw.Text(
                            'Revenue growth was strongest in Jeddah due to targeted campaigns.',
                        ),
                    ))
          .heading('Customer Metrics', level: 1)
          .paragraph(
              'Customer satisfaction scores averaged 92%, with particular '
              'strength in product quality (95%) and customer service (91%).')
                    .add(pw.RichText(
                        text: pw.TextSpan(children: [
                            pw.TextSpan(
                                    text: 'CSAT drivers: ',
                                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            const pw.TextSpan(
                                    text: 'response time improvements and proactive follow-ups.'),
                        ]),
                    ))
          .heading('Operational Efficiency', level: 1)
          .paragraph('Operational costs were reduced by 8% through process '
              'improvements and automation initiatives.')
          .heading('Recommendations')
          .paragraph(
              'Based on the analysis, we recommend continuing investment '
              'in customer service training and expanding automation efforts.')
          .build())
      .addPage((page) => page
          .header('KPI Summary')
          .spacer(12)
          .table([
            ['KPI', 'Value', 'Target', 'Status'],
            ['Revenue', '1.5M SAR', '1.3M SAR', 'Above'],
            ['CSAT', '92%', '90%', 'Above'],
            ['Cost Reduction', '8%', '5%', 'Above'],
            ['Delivery', '96%', '95%', 'On Track'],
          ])
                    .spacer(10)
                    .subheader('Action Plan')
                    .numberedList([
                        'Increase customer support staffing during peak hours.',
                        'Expand automation for inventory reconciliation.',
                        'Launch retention campaigns for top segments.',
                    ])
          .spacer(12)
          .divider()
          .spacer(8)
          .subheader('Notes')
          .paragraph(
              'All KPIs met or exceeded targets. See appendix for detailed '
              'department-level breakdowns.')
                    .spacer(8)
                    .footer('Confidential - Internal Use Only')
          .build())
      .buildBytes();
}
