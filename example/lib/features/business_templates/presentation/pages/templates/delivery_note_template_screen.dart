import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/sales_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

/// Dedicated example screen for the Delivery Note business template.
class DeliveryNoteTemplateScreen extends StatelessWidget {
  const DeliveryNoteTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildDeliveryNoteDemo({required bool isRtl}) {
  final recipient = const DeliveryRecipient(
    name: 'Ahmed Al-Farsi',
    nameAr: 'أحمد الفارسي',
    company: 'XYZ Corp',
    companyAr: 'شركة XYZ',
    address: '321 Business Park, Riyadh',
    phone: '+966 55 123 4567',
  );

  final delivery = DeliveryNoteData(
    deliveryNumber: 'DN-2026-0089',
    deliveryDate: DateTime.now(),
    salesOrderRef: 'SO-2026-0156',
    driverName: 'Khalid Mohammed',
    vehicleNumber: 'ABC 1234',
    items: const [
      DeliveryItem(
        itemNumber: 1,
        productCode: 'PROD-001',
        description: 'Widget A',
        descriptionAr: 'منتج أ',
        orderedQty: 100,
        deliveredQty: 100,
        unit: 'pcs',
      ),
      DeliveryItem(
        itemNumber: 2,
        productCode: 'PROD-002',
        description: 'Widget B',
        descriptionAr: 'منتج ب',
        orderedQty: 50,
        deliveredQty: 45,
        unit: 'pcs',
      ),
    ],
  );

  final template = DeliveryNoteTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    recipient: recipient,
    delivery: delivery,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'delivery_note_demo',
  );
}

final build = buildDeliveryNoteDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return const BusinessTemplateDetailScreen(
      category: 'Sales Documents',
      title: 'Delivery Note',
      titleAr: 'إشعار تسليم',
      description: 'Shipment and delivery confirmation with recipient and quantity details.',
      icon: Icons.local_shipping_outlined,
      buildTemplate: buildDeliveryNoteDemo,
      usageCode: dartUsageCode,
    );
  }
}
