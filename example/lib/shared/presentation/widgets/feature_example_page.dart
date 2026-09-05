import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/example_page_shell.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_panels.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/example_section.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/responsive_split_layout.dart';

enum FeatureExampleTone { neutral, info, success, warning, danger }

/// Common presentation for one focused example destination.
///
/// It deliberately has no tabs or sibling-example navigation. The navigation
/// sidebar owns example discovery; this widget owns only the selected example.
class FeatureExamplePage extends StatelessWidget {
  const FeatureExamplePage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.content,
    required this.code,
    this.contentTitle = 'Interactive example',
    this.contentDescription,
    this.settings,
    this.actions = const <Widget>[],
    this.statusMessage,
    this.statusTone = FeatureExampleTone.neutral,
    this.codeHeight = 420,
    this.breakpoint = 1080,
  });

  final String title;
  final String description;
  final IconData icon;
  final Widget content;
  final String code;
  final String contentTitle;
  final String? contentDescription;
  final Widget? settings;
  final List<Widget> actions;
  final String? statusMessage;
  final FeatureExampleTone statusTone;
  final double codeHeight;
  final double breakpoint;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    return ExamplePageShell(
      title: title,
      description: description,
      leading: _FeatureIcon(icon: icon),
      actions: actions,
      children: <Widget>[
        if (settings != null)
          ExampleSettingsPanel(
            title: 'Configuration',
            child: settings!,
          ),
        ResponsiveSplitLayout(
          breakpoint: breakpoint,
          primaryFlex: 13,
          secondaryFlex: 10,
          primary: ExampleSection(
            title: contentTitle,
            description: contentDescription,
            leading: Icon(icon),
            child: content,
          ),
          secondary: CodePreviewPanel(
            title: 'Dart usage code',
            code: code,
            height: codeHeight,
          ),
        ),
        if (statusMessage != null && statusMessage!.trim().isNotEmpty)
          ResultStatusPanel(
            title: 'Execution status',
            message: statusMessage!,
            tone: switch (statusTone) {
              FeatureExampleTone.neutral => ExampleResultTone.neutral,
              FeatureExampleTone.info => ExampleResultTone.info,
              FeatureExampleTone.success => ExampleResultTone.success,
              FeatureExampleTone.warning => ExampleResultTone.warning,
              FeatureExampleTone.danger => ExampleResultTone.danger,
            },
          ),
        SizedBox(height: spacing.space1),
      ],
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  const _FeatureIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final spacing = context.superTheme.spacing;
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.primaryContainer,
        borderRadius: BorderRadius.circular(spacing.radiusControl),
      ),
      child: Icon(icon, color: colors.onPrimaryContainer, size: 22),
    );
  }
}

/// Reusable action tile for interactive examples.
class FeatureActionCard extends StatelessWidget {
  const FeatureActionCard({
    super.key,
    required this.title,
    required this.icon,
    this.subtitle,
    this.onPressed,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final colors = Theme.of(context).colorScheme;
    final text = context.superTextTheme;
    final enabled = onPressed != null;

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: t.spacing.cardPadding,
          child: Row(
            children: <Widget>[
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: enabled
                      ? colors.primaryContainer
                      : colors.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(t.spacing.radiusControl),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: enabled
                      ? colors.onPrimaryContainer
                      : colors.onSurfaceVariant,
                ),
              ),
              SizedBox(width: t.spacing.space3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      title,
                      style: text.labelMd.copyWith(
                        color: enabled ? t.fg1 : t.fg3,
                      ),
                    ),
                    if (subtitle != null) ...<Widget>[
                      SizedBox(height: t.spacing.space1),
                      Text(
                        subtitle!,
                        style: text.bodySm.copyWith(color: t.fg3),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing!
              else
                Icon(Icons.chevron_right_rounded, color: t.fg3),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureActionGrid extends StatelessWidget {
  const FeatureActionGrid({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final gap = context.superTheme.spacing.space2;
    return LayoutBuilder(
      builder: (context, constraints) {
        final twoColumns = constraints.maxWidth >= 620;
        if (!twoColumns) {
          return Column(
            children: <Widget>[
              for (var i = 0; i < children.length; i++) ...<Widget>[
                children[i],
                if (i != children.length - 1) SizedBox(height: gap),
              ],
            ],
          );
        }
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: <Widget>[
            for (final child in children)
              SizedBox(
                width: (constraints.maxWidth - gap) / 2,
                child: child,
              ),
          ],
        );
      },
    );
  }
}

class FeatureStatusPanel extends StatelessWidget {
  const FeatureStatusPanel({
    super.key,
    required this.message,
    this.loading = false,
    this.tone = FeatureExampleTone.neutral,
  });

  final String message;
  final bool loading;
  final FeatureExampleTone tone;

  @override
  Widget build(BuildContext context) {
    return ResultStatusPanel(
      title: loading ? 'Running' : 'Status',
      message: message.trim().isEmpty
          ? (loading ? 'Executing the selected action…' : 'Ready for action.')
          : message,
      tone: loading
          ? ExampleResultTone.info
          : switch (tone) {
              FeatureExampleTone.neutral => ExampleResultTone.neutral,
              FeatureExampleTone.info => ExampleResultTone.info,
              FeatureExampleTone.success => ExampleResultTone.success,
              FeatureExampleTone.warning => ExampleResultTone.warning,
              FeatureExampleTone.danger => ExampleResultTone.danger,
            },
      trailing: loading
          ? const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : null,
    );
  }
}

class FeatureReadyState extends StatelessWidget {
  const FeatureReadyState({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: t.spacing.space5,
        vertical: t.spacing.space8,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        border: Border.all(color: colors.outlineVariant),
        borderRadius: t.spacing.cardBorderRadius,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colors.onPrimaryContainer, size: 28),
          ),
          SizedBox(height: t.spacing.space3),
          Text(
            title,
            textAlign: TextAlign.center,
            style: context.superTextTheme.titleMd.copyWith(color: t.fg1),
          ),
          SizedBox(height: t.spacing.space2),
          Text(
            description,
            textAlign: TextAlign.center,
            style: context.superTextTheme.bodySm.copyWith(color: t.fg3),
          ),
        ],
      ),
    );
  }
}
