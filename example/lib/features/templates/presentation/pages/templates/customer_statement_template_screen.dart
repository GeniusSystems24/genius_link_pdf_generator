import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';
import 'package:genius_pdf_example/features/templates/models/documents/templates_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';

TemplateExampleBuild _buildCustomerStatementTemplate({required bool isRtl}) {
  return TemplateExampleBuild(
    builder: buildCustomerStatementTemplate(isRtl: isRtl),
    fileName: 'customer_statement_demo',
  );
}

/// Dedicated example screen for the Customer Statement template.
class CustomerStatementTemplateScreen extends StatelessWidget {
  const CustomerStatementTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same builder used by this example.
// Set isRtl to false for LTR output.

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart'
    show geniusPdfConfig;
import 'package:genius_pdf_example/shared/data/sample_data.dart';

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
final pdfBytes = Uint8List.fromList(template.generate());
template.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return const TemplateExampleDetailScreen(
      category: 'Report Templates',
      title: 'Customer Statement',
      titleAr: 'كشف حساب عميل',
      description: 'Customer account statement example with customer information, transaction history, balances, and bilingual output.',
      icon: Icons.account_balance_wallet_outlined,
      buildTemplate: _buildCustomerStatementTemplate,
      usageCode: dartUsageCode,
    );
  }
}
