import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/architecture/presentation/internal/v2_architecture_single_example_host.dart';

/// Focused V2 Architecture example for Multi-page Report.
class FluentApiMultiPageReportExampleScreen extends StatelessWidget {
  const FluentApiMultiPageReportExampleScreen({super.key});

  /// Exact code executed by this example.
  static const String dartUsageCode = r'''Future<Uint8List> buildMultiPageReportBytes() async {
  const primaryColor = PdfColor.fromInt(0xFF6366F1);
  const lightBg = PdfColor.fromInt(0xFFF8FAFC);
  const darkText = PdfColor.fromInt(0xFF1E293B);

  final regularFont = geniusPdfConfig.assets.primaryFont;

  return GeniusPdfBuilder(
    id: 'monthly-report',
    config: GeniusPdfConfig(
      baseFontBytes: regularFont,
      baseFontSize: 10,
    ),
  )
      .metadata(title: 'Monthly Report', author: 'System')
      .pageFormat(PdfPageFormat.a4)
      .addMultiPage((mp) {
    mp.add(pw.Container(
        padding: const pw.EdgeInsets.all(24),
        decoration: const pw.BoxDecoration(color: primaryColor),
        width: double.infinity,
        child: pw.Text('Monthly Performance Report',
            style: pw.TextStyle(
                color: PdfColors.white,
                fontSize: 24,
                fontWeight: pw.FontWeight.bold))));

    mp.pageNumberFooter();

    mp.add(pw.SizedBox(height: 20));
    mp.add(pw.Container(
        padding: const pw.EdgeInsets.all(20),
        decoration: const pw.BoxDecoration(color: lightBg),
        child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('January 2026',
                  style: pw.TextStyle(
                      color: primaryColor,
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Text('Executive Summary',
                  style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                      color: darkText)),
              pw.SizedBox(height: 12),
              pw.Text(
                'This report provides a comprehensive overview of our performance metrics for January 2026. '
                'Key highlights include revenue growth of 15% and customer satisfaction scores above 90%.',
                style: const pw.TextStyle(lineSpacing: 1.5),
              ),
            ])));

    mp.add(pw.SizedBox(height: 20));
    mp.heading('Key Results', level: 2);
    mp.add(pw.Row(children: [
      pw.Expanded(
          child: _buildKpiCard('Revenue', '1.5M SAR', '+15%', primaryColor)),
      pw.SizedBox(width: 12),
      pw.Expanded(
          child: _buildKpiCard('CSAT', '92%', '+2%', PdfColors.green600)),
      pw.SizedBox(width: 12),
      pw.Expanded(
          child: _buildKpiCard('Costs', '-8%', 'Good', PdfColors.orange600)),
    ]));

    mp.add(pw.SizedBox(height: 20));
    mp.heading('Revenue Analysis', level: 2);
    mp.paragraph(
        'Total revenue for the month reached 1.5 million SAR, representing a 15% increase compared to the same period last year.');
    mp.add(pw.TableHelper.fromTextArray(
      data: [
        ['Riyadh', '620K SAR', '+12%'],
        ['Jeddah', '540K SAR', '+18%'],
        ['Dammam', '340K SAR', '+14%'],
      ],
      headers: ['Region', 'Revenue', 'Change'],
    ));

    mp.add(pw.SizedBox(height: 20));
    mp.heading('Customer Metrics', level: 2);
    mp.paragraph(
        'Customer satisfaction scores averaged 92%, with particular strength in product quality (95%) and customer service (91%).');
    return mp.build();
  }).addPage((page) {
    page.header('Detailed KPI Summary');
    page.spacer(12);
    page.table(
      [
        ['KPI', 'Value', 'Target', 'Status'],
        ['Revenue', '1.5M SAR', '1.3M SAR', 'Above'],
        ['CSAT', '92%', '90%', 'Above'],
        ['Cost Reduction', '8%', '5%', 'Above'],
        ['Delivery', '96%', '95%', 'On Track'],
      ],
      headers: ['Metric', 'Current', 'Target', 'Status'],
    );
    page.spacer(20);
    page.container(
        padding: const pw.EdgeInsets.all(16),
        decoration: pw.BoxDecoration(
          color: const PdfColor.fromInt(0xFFEEF2FF),
          border: pw.Border.all(color: const PdfColor.fromInt(0xFFC7D2FE)),
          borderRadius: pw.BorderRadius.circular(6),
        ),
        child: pw
            .Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text('Recommendations',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: primaryColor)),
          pw.SizedBox(height: 4),
          pw.Text('- Increase customer support staffing during peak hours.'),
          pw.Text('- Expand automation for inventory reconciliation.'),
        ]));
    page.spacer(20);
    page.footer('Confidential - Internal Use Only');
    return page.build();
  }).buildBytes();
}''';

  @override
  Widget build(BuildContext context) {
    return const V2ArchitectureSingleExampleHost(
      example: V2ArchitectureExample.multiPageReport,
      usageCode: dartUsageCode,
    );
  }
}
