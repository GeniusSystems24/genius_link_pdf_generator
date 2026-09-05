import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Info & Warning States**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class InfoWarningBoxesExampleScreen extends StatelessWidget {
  const InfoWarningBoxesExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Info & Warning States** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `info_warning_boxes_example_screen.dart` and displayed as **Dart usage code**.
class InfoWarningBoxesDemoBuilder extends GeniusPdfDocumentBuilder {
  InfoWarningBoxesDemoBuilder(super.config);

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

    // Info and Warning boxes side by side
    final infoBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'معلومة' : 'Info',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: config.isRTL ? 'ملاحظة' : 'Note',
          value: config.isRTL
              ? 'يرجى الاحتفاظ بهذه الفاتورة'
              : 'Please keep this invoice',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.info(),
    );

    final warningBox = GeniusPdfInfoBox(
      config: config,
      title: config.isRTL ? 'تحذير' : 'Warning',
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: config.isRTL ? 'تنبيه' : 'Alert',
          value: config.isRTL ? 'مستند للمعاينة فقط' : 'Preview only document',
        ),
      ],
      style: GeniusPdfInfoBoxStyle.warning(),
    );

    addDualInfoBox(
      leftBox: infoBox,
      rightBox: warningBox,
      equalHeight: true,
      boxSpacing: 20,
      spacing: 10,
    );

    addSpace(10);
  }
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'info_box_info_warning',
      category: 'Components / Core PDF Components / Info Box',
      title: 'Info & Warning States',
      apiName: 'GeniusPdfInfoBox',
      description: 'Compare informational and warning semantic info-box styles in a dual-box layout.',
      icon: Icons.warning_amber_outlined,
      usageCode: dartUsageCode,
    );
  }
}
