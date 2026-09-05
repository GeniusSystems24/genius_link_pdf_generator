import 'package:flutter/material.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/feature_example_page.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Shared layout used by component-oriented and document-oriented examples.
///
/// [gradient] and [isDark] remain for source compatibility with the legacy
/// examples, but the active presentation is entirely theme-driven.
class ComponentPage extends StatelessWidget {
  const ComponentPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.isDark,
    required this.isRTL,
    required this.onRTLChanged,
    required this.isGenerating,
    this.onGenerate,
    required this.codeExample,
    required this.preview,
  });

  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final bool isDark;
  final bool isRTL;
  final ValueChanged<bool> onRTLChanged;
  final bool isGenerating;
  final VoidCallback? onGenerate;
  final String codeExample;
  final Widget preview;

  @override
  Widget build(BuildContext context) {
    return FeatureExamplePage(
      title: title,
      description: description,
      icon: icon,
      settings: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 8,
        children: <Widget>[
           Text(pdfLocalization.textDirection),
          SegmentedButton<bool>(
            segments: <ButtonSegment<bool>>[
              ButtonSegment<bool>(
                value: false,
                label: Text(pdfLocalization.ltr),
                icon: Icon(Icons.format_textdirection_l_to_r_rounded),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text(pdfLocalization.rtl),
                icon: Icon(Icons.format_textdirection_r_to_l_rounded),
              ),
            ],
            selected: <bool>{isRTL},
            onSelectionChanged: (selection) {
              if (selection.isNotEmpty) onRTLChanged(selection.first);
            },
          ),
        ],
      ),
      contentTitle: 'Example',
      contentDescription:
          pdfLocalization.availableActionExplicitlyExecuteDesc,
      content: preview,
      code: codeExample,
      statusMessage: isGenerating ? 'Executing example…' : null,
      statusTone: isGenerating
          ? FeatureExampleTone.info
          : FeatureExampleTone.neutral,
      actions: onGenerate == null
          ? const <Widget>[]
          : <Widget>[
              FilledButton.icon(
                onPressed: isGenerating ? null : onGenerate,
                icon: isGenerating
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(isGenerating ? 'Running…' : 'Run example'),
              ),
            ],
    );
  }
}
