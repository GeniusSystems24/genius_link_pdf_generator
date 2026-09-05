import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Success & Error States** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `success_error_boxes_example_screen.dart` and displayed as **Dart usage code**.
class SuccessErrorBoxesDemoBuilder extends GeniusPdfDocumentBuilder {
  SuccessErrorBoxesDemoBuilder(super.config);

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

    // Success and Error boxes side by side
    final successBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'نجاح' : 'Success',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: config.isRTL ? 'الحالة' : 'Status',
          value:
              config.isRTL ? 'تم إتمام العملية بنجاح' : 'Operation completed',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.success(),
    );

    final errorBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'خطأ' : 'Error',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: config.isRTL ? 'المشكلة' : 'Issue',
          value: config.isRTL ? 'فشل في معالجة الطلب' : 'Failed to process',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.error(),
    );

    addDualInfoBox(
      leftBox: successBox,
      rightBox: errorBox,
      equalHeight: true,
      boxSpacing: 20,
      spacing: 10,
    );
  }
}
