import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/sales_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated example screen for the Purchase Order business template.
class PurchaseOrderTemplateScreen extends StatelessWidget {
  const PurchaseOrderTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildPurchaseOrderDemo({required bool isRtl}) {
  final vendor = const PurchaseOrderVendor(
    name: 'Tech Supplies Co.',
    nameAr: 'شركة مستلزمات التقنية',
    vendorCode: 'VND-001',
    address: '789 Industrial Area, Dammam',
    vatNumber: '300098765400001',
  );

  final po = PurchaseOrderData(
    poNumber: 'PO-2026-0042',
    poDate: DateTime.now(),
    expectedDeliveryDate: DateTime.now().add(const Duration(days: 14)),
    paymentTerms: 'Net 45',
    status: 'Approved',
    items: const [
      PurchaseOrderItem(
        itemNumber: 1,
        productCode: 'LAP-001',
        description: 'Laptop - Business Model',
        descriptionAr: 'لابتوب - موديل الأعمال',
        quantity: 10,
        unitPrice: 4500,
      ),
      PurchaseOrderItem(
        itemNumber: 2,
        productCode: 'MON-002',
        description: 'Monitor 27" 4K',
        descriptionAr: 'شاشة 27 بوصة 4K',
        quantity: 10,
        unitPrice: 1200,
      ),
    ],
    taxes: const [
      (name: 'VAT', nameAr: 'ضريبة القيمة المضافة', rate: 15.0),
    ],
  );

  final template = PurchaseOrderTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    vendor: vendor,
    purchaseOrder: po,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'purchase_order_demo',
  );
}

final build = buildPurchaseOrderDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return  BusinessTemplateDetailScreen(
      category: 'Sales Documents',
      title: pdfLocalization.purchaseOrder,
      titleAr: 'أمر شراء',
      description: pdfLocalization.vendorPurchaseOrderItemsDeliveryDateDesc,
      icon: Icons.shopping_bag_outlined,
      buildTemplate: buildPurchaseOrderDemo,
      usageCode: dartUsageCode,
    );
  }
}
