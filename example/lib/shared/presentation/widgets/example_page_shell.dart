
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

class ExamplePageShell extends StatelessWidget {
  const ExamplePageShell({
    super.key,
    required this.title,
    required this.description,
    required this.children,
    this.leading,
    this.actions = const <Widget>[],
  });

  final String title;
  final String description;
  final Widget? leading;
  final List<Widget> actions;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final mode = SuperDeviceMode.of(context);
    final maxWidth = switch (mode) {
      SuperDeviceMode.mobile => 900.0,
      SuperDeviceMode.tablet => 1200.0,
      SuperDeviceMode.desktop => 1600.0,
    };

    return SingleChildScrollView(
      padding: spacing.pagePadding,
      child: Align(
        alignment: AlignmentDirectional.topCenter,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ExamplePageHeader(
                title: title,
                description: description,
                leading: leading,
                actions: actions,
              ),
              SizedBox(height: spacing.space6),
              for (var index = 0; index < children.length; index++) ...<Widget>[
                children[index],
                if (index != children.length - 1)
                  SizedBox(height: spacing.space5),
              ],
              SizedBox(height: spacing.space8),
            ],
          ),
        ),
      ),
    );
  }
}

class ExamplePageHeader extends StatelessWidget {
  const ExamplePageHeader({
    super.key,
    required this.title,
    required this.description,
    this.leading,
    this.actions = const <Widget>[],
  });

  final String title;
  final String description;
  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final typography = context.superTextTheme;
    final foreground = context.superTheme.fg1;
    final secondary = context.superTheme.fg2;

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: spacing.space4,
      runSpacing: spacing.space3,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 820),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (leading != null) ...<Widget>[
                IconTheme(
                  data: IconThemeData(color: Theme.of(context).colorScheme.primary),
                  child: leading!,
                ),
                SizedBox(width: spacing.space3),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(title, style: typography.headlineSm.copyWith(color: foreground)),
                    SizedBox(height: spacing.space2),
                    Text(description, style: typography.body.copyWith(color: secondary)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (actions.isNotEmpty)
          Wrap(spacing: spacing.space2, runSpacing: spacing.space2, children: actions),
      ],
    );
  }
}
