import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/models/documents/export_template_background_generators.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

Future<Uint8List> _generateCustomerStatementInBackground({required bool isRtl}) {
  return generateCustomerStatementTemplateInBackground(isRtl: isRtl);
}

/// Dedicated example screen for the Customer Statement template.
class CustomerStatementTemplateScreen extends StatelessWidget {
  const CustomerStatementTemplateScreen({super.key});

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

CustomerStatementTemplate buildCustomerStatementTemplate({
  required bool isRtl,
}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return CustomerStatementTemplate(
    config: config,
    company: SampleData.companyInfo,
    customer: SampleData.statementCustomer,
    data: SampleData.statementData,
  );
}

final template = buildCustomerStatementTemplate(isRtl: true);
final result = await generateExamplePdf(
  builder: template,
  fileName: 'customer_statement_demo',
  metadata: const <String, dynamic>{
    'feature': 'templates',
    'template': 'CustomerStatementTemplate',
    'workflow': 'usage-example',
  },
);
final pdfBytes = result.bytes;
''';

  @override
  Widget build(BuildContext context) {
    return  TemplateExampleDetailScreen(
      category: 'Report Templates',
      title: pdfLocalization.customerStatement,
      titleAr: 'كشف حساب عميل',
      description: pdfLocalization.customerAccountStatementExampleDesc,
      icon: Icons.account_balance_wallet_outlined,
      backgroundGenerator: _generateCustomerStatementInBackground,
      backgroundFileName: 'customer_statement_demo.pdf',
      jobMetadata: const <String, dynamic>{
        'feature': 'templates',
        'template': 'CustomerStatementTemplate',
      },
      showGenerationToast: true,
      usageCode: dartUsageCode,
    );
  }
}
