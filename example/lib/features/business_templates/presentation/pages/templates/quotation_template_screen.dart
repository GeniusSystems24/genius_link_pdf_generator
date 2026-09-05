import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/sales_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

/// Dedicated example screen for the Quotation business template.
class QuotationTemplateScreen extends StatelessWidget {
  const QuotationTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildQuotationDemo({required bool isRtl}) {
  final customer = const QuotationCustomer(
    name: 'ABC Trading Company',
    nameAr: 'شركة ABC للتجارة',
    // company removed
    address: '456 Commercial Street, Jeddah',
    phone: '+966 12 345 6789',
    email: 'purchasing@abctrading.com',
  );

  final quotation = QuotationData(
    customer: customer,
    quotationNumber: 'QT-2026-0001',
    quotationDate: DateTime.now(),
    validUntil: DateTime.now().add(const Duration(days: 30)),
    terms: 'Net 30',
    termsAr: 'صافي 30 يوم',
    items: const [
      QuotationItem(
        itemNumber: 1,
        description: 'Office Desk - Executive Model',
        descriptionAr: 'مكتب تنفيذي',
        quantity: 5,
        unitPrice: 2500,
      ),
      QuotationItem(
        itemNumber: 2,
        description: 'Executive Chair',
        descriptionAr: 'كرسي تنفيذي',
        quantity: 5,
        unitPrice: 1800,
      ),
    ],
    // taxes removed
  );

  final template = QuotationTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    quotation: quotation,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'quotation_demo',
  );
}

final build = buildQuotationDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return const BusinessTemplateDetailScreen(
      category: 'Sales Documents',
      title: 'Quotation',
      titleAr: 'عرض سعر',
      description: 'A professional customer quotation with products, pricing, and validity.',
      icon: Icons.request_quote_outlined,
      buildTemplate: buildQuotationDemo,
      usageCode: dartUsageCode,
    );
  }
}
