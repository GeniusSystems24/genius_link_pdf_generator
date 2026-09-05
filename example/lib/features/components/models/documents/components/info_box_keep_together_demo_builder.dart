import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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
}
