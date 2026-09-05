import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated screen for **Customer & Company Boxes**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class CustomerCompanyInfoBoxesExampleScreen extends StatelessWidget {
  const CustomerCompanyInfoBoxesExampleScreen({super.key});

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
    return  ComponentExampleDetailScreen(
      componentId: 'info_box_customer_company',
      category: 'Components / Core PDF Components / Info Box',
      title: pdfLocalization.customerAndCompanyBoxes,
      apiName: 'GeniusPdfInfoBox',
      description: pdfLocalization.structuredCustomerCompanyDetailsSideDesc,
      icon: Icons.badge_outlined,
      usageCode: dartUsageCode,
    );
  }
}
