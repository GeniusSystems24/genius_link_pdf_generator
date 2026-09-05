import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/models/documents/components/info_box_customer_company_info_boxes_demo_builder.dart';
import 'package:genius_pdf_example/features/getting_started/presentation/widgets/s00_baseline_example_detail_screen.dart';

/// Dedicated S00 screen for the InfoBox Baseline regression example.
///
/// The `Dart usage code` panel contains the exact builder source executed by
/// this screen when **Run example** is pressed.
class S00InfoBoxBaselineExampleScreen extends StatelessWidget {
  const S00InfoBoxBaselineExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Customer & Company Boxes** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `customer_company_info_boxes_example_screen.dart` and displayed as **Dart usage code**.
class CustomerCompanyInfoBoxesDemoBuilder extends GeniusPdfDocumentBuilder {
  CustomerCompanyInfoBoxesDemoBuilder(super.config);

  @override
  void build() {
    newPage();

    // Title using builder method
    addSectionDivider(
      title: config.isRTL
          ? 'صندوق المعلومات - GeniusPdfInfoBox'
          : 'Info Box - GeniusPdfInfoBox',
      spacing: 10,
    );

    addSpace(15);

    final customerBox = GeniusPdfInfoBox(
      config: config,
      title: 'Customer Info',
      titleAr: 'بيانات العميل',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Name',
          labelAr: 'الاسم',
          value: config.isRTL ? 'أحمد محمد' : 'Ahmed Mohammed',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Phone',
          labelAr: 'الهاتف',
          value: '+966 50 123 4567',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Email',
          labelAr: 'البريد',
          value: 'ahmed@example.com',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Address',
          labelAr: 'العنوان',
          value: config.isRTL ? 'الرياض، السعودية' : 'Riyadh, Saudi Arabia',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
    );

    final companyBox = GeniusPdfInfoBox.company(
      companyName: config.isRTL ? 'شركة الأمل للتجارة' : 'Al-Amal Trading Co.',
      taxNumber: '300123456789003',
      commercialReg: '1010123456',
      address: config.isRTL
          ? 'الرياض، المملكة العربية السعودية'
          : 'Riyadh, Saudi Arabia',
      phone: '+966 11 123 4567',
      email: 'info@alamal.com',
      config: config,
    );

    // Dual info box using builder method
    addDualInfoBox(
      leftBox: config.isRTL ? companyBox : customerBox,
      rightBox: config.isRTL ? customerBox : companyBox,
      equalHeight: true,
      boxSpacing: 20,
      swapForRTL: false,
      spacing: 15,
    );

    addSpace(10);
  }
}''';

  @override
  Widget build(BuildContext context) {
    return S00BaselineExampleDetailScreen(
      title: 'InfoBox Baseline',
      apiName: 'CustomerCompanyInfoBoxesDemoBuilder',
      description: 'Verify label/value placement, icon placement, and mixed numeric/Latin values using the focused InfoBox builder.',
      icon: Icons.info_outline,
      builderFactory: (config) => CustomerCompanyInfoBoxesDemoBuilder(config),
      usageCode: dartUsageCode,
      expectedLtr: 'Review label/value and icon placement plus mixed numeric/Latin values. S00 records current behavior rather than correcting it.',
      expectedRtl: 'Review label/value and icon placement plus mixed numeric/Latin values. S00 records current behavior rather than correcting it.',
      fileName: 's00_info_box.pdf',
    );
  }
}
