import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/templates/models/documents/export_template_background_generators.dart';
import 'package:genius_pdf_example/features/templates/presentation/widgets/template_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

Future<Uint8List> _generateTaxInvoiceInBackground({required bool isRtl}) {
  return generateTaxInvoiceTemplateInBackground(isRtl: isRtl);
}

/// Dedicated example screen for the Tax Invoice template.
class TaxInvoiceTemplateScreen extends StatelessWidget {
  const TaxInvoiceTemplateScreen({super.key});

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
final result = await generateExamplePdf(
  builder: template,
  fileName: 'tax_invoice_demo',
  metadata: const <String, dynamic>{
    'feature': 'templates',
    'template': 'TaxInvoiceTemplate',
    'workflow': 'usage-example',
  },
);
final pdfBytes = result.bytes;
''';

  @override
  Widget build(BuildContext context) {
    return  TemplateExampleDetailScreen(
      category: 'Report Templates',
      title: pdfLocalization.taxInvoice,
      titleAr: 'فاتورة ضريبية',
      description: pdfLocalization.zatcaOrientedTaxInvoiceExampleDesc,
      icon: Icons.receipt_long_outlined,
      backgroundGenerator: _generateTaxInvoiceInBackground,
      backgroundFileName: 'tax_invoice_demo.pdf',
      jobMetadata: const <String, dynamic>{
        'feature': 'templates',
        'template': 'TaxInvoiceTemplate',
      },
      showGenerationToast: true,
      usageCode: dartUsageCode,
    );
  }
}
