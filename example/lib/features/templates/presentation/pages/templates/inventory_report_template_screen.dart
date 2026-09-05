import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';
import 'package:genius_pdf_example/features/templates/models/documents/templates_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

TemplateExampleBuild _buildInventoryReportTemplate({required bool isRtl}) {
  return TemplateExampleBuild(
    builder: buildInventoryReportTemplate(isRtl: isRtl),
    fileName: 'inventory_report_demo',
  );
}

/// Dedicated example screen for the Inventory Report template.
class InventoryReportTemplateScreen extends StatelessWidget {
  const InventoryReportTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same builder used by this example.
// Set isRtl to false for LTR output.

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart'
    show geniusPdfConfig;
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
final pdfBytes = Uint8List.fromList(template.generate());
template.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return  TemplateExampleDetailScreen(
      category: 'Report Templates',
      title: pdfLocalization.inventoryReport,
      titleAr: 'تقرير المخزون',
      description: pdfLocalization.inventoryValuationReportCategoryDesc,
      icon: Icons.inventory_2_outlined,
      buildTemplate: _buildInventoryReportTemplate,
      usageCode: dartUsageCode,
    );
  }
}
