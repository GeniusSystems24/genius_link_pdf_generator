import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated screen for **Footer-Edge Keep Together**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class InfoBoxKeepTogetherExampleScreen extends StatelessWidget {
  const InfoBoxKeepTogetherExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Footer-Edge Keep Together** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `info_box_keep_together_example_screen.dart` and displayed as **Dart usage code**.
class InfoBoxKeepTogetherDemoBuilder extends GeniusPdfDocumentBuilder {
  InfoBoxKeepTogetherDemoBuilder(super.config);

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

    final footerEdgeGap = remainingHeight > 18 ? remainingHeight - 18 : 0.0;
    addSpace(footerEdgeGap);

    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: 'Footer Edge Keep-Together',
        items: List.generate(
          4,
          (index) => GeniusPdfLabeledValue(
            config: config,
            label: 'Check ${index + 1}',
            value: 'This box should move to a new page when needed.',
          ),
        ),
        style: GeniusPdfInfoBoxStyle.card(),
      ),
      spacing: 6,
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'info_box_keep_together',
      category: 'Components / Core PDF Components / Info Box',
      title: pdfLocalization.footerEdgeKeepTogether,
      apiName: 'GeniusPdfInfoBox',
      description: pdfLocalization.verifyMultiRowInfoBoxMovesSafelyNewDesc,
      icon: Icons.vertical_align_bottom_outlined,
      usageCode: dartUsageCode,
    );
  }
}
