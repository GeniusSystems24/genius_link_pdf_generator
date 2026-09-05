
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/code_viewer.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_section.dart';

class ExampleSettingsPanel extends StatelessWidget {
  const ExampleSettingsPanel({
    super.key,
    required this.child,
    this.title = 'Configuration',
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: title,
      description: description,
      leading: const Icon(Icons.tune_rounded),
      child: child,
    );
  }
}

class CodePreviewPanel extends StatelessWidget {
  const CodePreviewPanel({
    super.key,
    required this.code,
    this.title = 'Code example',
    this.height = 260,
  });

  final String title;
  final String code;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: title,
      leading: const Icon(Icons.code_rounded),
      padding: EdgeInsets.zero,
      child: CodeViewer(code: code, height: height),
    );
  }
}

class PdfPreviewPanel extends StatelessWidget {
  const PdfPreviewPanel({
    super.key,
    required this.child,
    this.title = 'Preview',
    this.description,
  });

  final String title;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ExampleSection(
      title: title,
      description: description,
      leading: const Icon(Icons.picture_as_pdf_outlined),
      child: child,
    );
  }
}

enum ExampleResultTone { neutral, info, success, warning, danger }

class ResultStatusPanel extends StatelessWidget {
  const ResultStatusPanel({
    super.key,
    required this.title,
    required this.message,
    this.tone = ExampleResultTone.neutral,
    this.trailing,
  });

  final String title;
  final String message;
  final ExampleResultTone tone;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final semantics = SuperSemanticColors.of(context);
    final semantic = switch (tone) {
      ExampleResultTone.neutral => semantics.neutral,
      ExampleResultTone.info => semantics.info,
      ExampleResultTone.success => semantics.success,
      ExampleResultTone.warning => semantics.warning,
      ExampleResultTone.danger => semantics.danger,
    };

    return Container(
      padding: context.superTheme.spacing.cardPadding,
      decoration: BoxDecoration(
        color: semantic.subtle,
        border: Border.all(color: semantic.border),
        borderRadius: context.superTheme.spacing.cardBorderRadius,
      ),
      child: Row(
        children: <Widget>[
          Icon(Icons.info_outline_rounded, color: semantic.solid),
          SizedBox(width: context.superTheme.spacing.space3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: context.superTextTheme.titleMd.copyWith(color: semantic.onSubtle)),
                SizedBox(height: context.superTheme.spacing.space1),
                Text(message, style: context.superTextTheme.bodySm.copyWith(color: semantic.onSubtle)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
