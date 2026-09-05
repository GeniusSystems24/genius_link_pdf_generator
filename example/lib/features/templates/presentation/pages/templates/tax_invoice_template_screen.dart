import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';
import 'package:genius_pdf_example/features/templates/models/documents/templates_demo_documents.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';

TemplateExampleBuild _buildTaxInvoiceTemplate({required bool isRtl}) {
  return TemplateExampleBuild(
    builder: buildTaxInvoiceTemplate(isRtl: isRtl),
    fileName: 'tax_invoice_demo',
  );
}

/// Dedicated example screen for the Tax Invoice template.
class TaxInvoiceTemplateScreen extends StatelessWidget {
  const TaxInvoiceTemplateScreen({super.key});

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

TaxInvoiceTemplate buildTaxInvoiceTemplate({required bool isRtl}) {
  final config = createTemplatesDemoConfig(isRtl: isRtl);
  return TaxInvoiceTemplate(
    config: config,
    company: SampleData.companyInfo,
    customer: SampleData.invoiceCustomer,
    invoice: SampleData.invoiceData,
    showQRCode: false,
  );
}

final template = buildTaxInvoiceTemplate(isRtl: true);
final pdfBytes = Uint8List.fromList(template.generate());
template.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return const TemplateExampleDetailScreen(
      category: 'Report Templates',
      title: 'Tax Invoice',
      titleAr: 'فاتورة ضريبية',
      description: 'ZATCA-oriented tax invoice example with company and customer data, line items, totals, and bilingual document direction.',
      icon: Icons.receipt_long_outlined,
      buildTemplate: _buildTaxInvoiceTemplate,
      usageCode: dartUsageCode,
    );
  }
}
