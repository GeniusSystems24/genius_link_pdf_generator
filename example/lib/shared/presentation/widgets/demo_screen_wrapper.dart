
import 'package:flutter/material.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/example_action_toolbar.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_page_shell.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_panels.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/responsive_split_layout.dart';

/// Compatibility wrapper for demo screens hosted by the dashboard scaffold.
class DemoScreenWrapper extends StatelessWidget {
  const DemoScreenWrapper({
    super.key,
    required this.child,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.showInternalAppBar = false,
  });

  final Widget child;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showInternalAppBar;

  @override
  Widget build(BuildContext context) => child;
}

/// General purpose example page retained for compatibility with existing code.
class DemoPage extends StatelessWidget {
  const DemoPage({
    super.key,
    required this.title,
    required this.description,
    this.options,
    required this.content,
    this.codeExample,
    this.onGenerate,
    this.isGenerating = false,
    this.generateLabel,
  });

  final String title;
  final String description;
  final Widget? options;
  final Widget content;
  final Widget? codeExample;
  final VoidCallback? onGenerate;
  final bool isGenerating;
  final String? generateLabel;

  @override
  Widget build(BuildContext context) {
    return ExamplePageShell(
      title: title,
      description: description,
      children: <Widget>[
        if (options != null) ExampleSettingsPanel(child: options!),
        if (codeExample == null)
          PdfPreviewPanel(child: content)
        else
          ResponsiveSplitLayout(
            primary: PdfPreviewPanel(child: content),
            secondary: ExampleSectionAdapter(
              title: 'Code example',
              icon: Icons.code_rounded,
              child: codeExample!,
            ),
          ),
        if (onGenerate != null)
          ExampleActionToolbar(
            actions: <Widget>[
              FilledButton.icon(
                onPressed: isGenerating ? null : onGenerate,
                icon: isGenerating
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.picture_as_pdf_outlined),
                label: Text(
                  isGenerating ? 'Generating…' : (generateLabel ?? 'Generate PDF'),
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class ExampleSectionAdapter extends StatelessWidget {
  const ExampleSectionAdapter({
    super.key,
    required this.title,
    required this.icon,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.color,
    this.icon,
  });

  final String label;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: icon == null ? null : Icon(icon, size: 16, color: color),
      label: Text(label),
      side: BorderSide(color: color.withValues(alpha: 0.35)),
      backgroundColor: color.withValues(alpha: 0.10),
    );
  }
}
