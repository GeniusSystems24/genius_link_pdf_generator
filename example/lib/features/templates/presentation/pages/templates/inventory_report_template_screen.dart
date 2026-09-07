import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/models/documents/export_template_background_generators.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

Future<Uint8List> _generateInventoryReportInBackground({required bool isRtl}) {
  return generateInventoryReportTemplateInBackground(isRtl: isRtl);
}

/// Dedicated example screen for the Inventory Report template.
class InventoryReportTemplateScreen extends StatelessWidget {
  const InventoryReportTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same builder used by this example.
// Set isRtl to false for LTR output.

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart'
    show geniusPdfConfig;
import 'package:genius_pdf_example/shared/application/services/example_pdf_generation.dart';
import 'package:genius_pdf_example/shared/data/sample_data.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
GeniusPdfConfig createTemplatesDemoConfig({required bool isRtl}) {
  return geniusPdfConfig.copyWith(
    textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
  );
}

InventoryReportTemplate buildInventoryReportTemplate({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return InventoryReportTemplate(
    config: config,
    company: SampleData.companyInfo,
    data: SampleData.inventoryData,
    printedBy: config.isRTL ? "أنور السياري" : "Anwar Al-saiary",
    reportId: "123456789",
    showSignatures: true,
    showQRCode: true,
  );
}

final template = buildInventoryReportTemplate(isRtl: true);
final result = await generateExamplePdf(
  builder: template,
  fileName: 'inventory_report_demo',
  metadata: const <String, dynamic>{
    'feature': 'templates',
    'template': 'InventoryReportTemplate',
    'workflow': 'usage-example',
  },
);
final pdfBytes = result.bytes;
''';

  @override
  Widget build(BuildContext context) {
    return  TemplateExampleDetailScreen(
      category: 'Report Templates',
      title: pdfLocalization.inventoryReport,
      titleAr: 'تقرير المخزون',
      description: pdfLocalization.inventoryValuationReportCategoryDesc,
      icon: Icons.inventory_2_outlined,
      backgroundGenerator: _generateInventoryReportInBackground,
      backgroundFileName: 'inventory_report_demo.pdf',
      jobMetadata: const <String, dynamic>{
        'feature': 'templates',
        'template': 'InventoryReportTemplate',
      },
      showGenerationToast: true,
      usageCode: dartUsageCode,
    );
  }
}
