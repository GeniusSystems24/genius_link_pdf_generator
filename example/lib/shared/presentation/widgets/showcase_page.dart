import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({
    super.key,
    required this.title,
    required this.description,
    required this.children,
    this.icon,
    this.api = const <String>[],
    this.actions = const <Widget>[],
  });

  final String title;
  final String description;
  final IconData? icon;
  final List<String> api;
  final List<Widget> actions;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: t.spacing.pagePadding,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1440),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PageHeader(
                  title: title,
                  description: description,
                  icon: icon,
                  api: api,
                  actions: actions,
                ),
                SizedBox(height: t.spacing.space4),
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1)
                    SizedBox(height: t.spacing.space3),
                ],
                SizedBox(height: t.spacing.space6),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageHeader extends StatelessWidget {
  const _PageHeader({
    required this.title,
    required this.description,
    required this.icon,
    required this.api,
    required this.actions,
  });

  final String title;
  final String description;
  final IconData? icon;
  final List<String> api;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    return SuperSectionCard1(
      showMarker: false,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final heading = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Container(
                  width: 44,
                  height: 44,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: t.spacing.borderRadiusMd,
                  ),
                  child: Icon(
                    icon,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                SizedBox(width: t.spacing.space3),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: context.superTextTheme.h1),
                    SizedBox(height: t.spacing.space1),
                    Text(
                      description,
                      style: context.superTextTheme.body.copyWith(color: t.fg2),
                    ),
                  ],
                ),
              ),
            ],
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (compact || actions.isEmpty) heading else Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: heading),
                  SizedBox(width: t.spacing.space4),
                  Wrap(spacing: t.spacing.space2, runSpacing: t.spacing.space2, children: actions),
                ],
              ),
              if (compact && actions.isNotEmpty) ...[
                SizedBox(height: t.spacing.space3),
                Wrap(spacing: t.spacing.space2, runSpacing: t.spacing.space2, children: actions),
              ],
              if (api.isNotEmpty) ...[
                SizedBox(height: t.spacing.space3),
                Wrap(
                  spacing: t.spacing.space2,
                  runSpacing: t.spacing.space2,
                  children: [for (final value in api) Chip(label: Text(value))],
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class ShowcaseSection extends StatelessWidget {
  const ShowcaseSection({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.icon,
    this.trailing,
    this.collapsible = false,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget child;
  final Widget? trailing;
  final bool collapsible;

  @override
  Widget build(BuildContext context) => SuperSectionCard1(
    title: title,
    subtitle: subtitle,
    icon: icon,
    trailing: trailing,
    collapsible: collapsible,
    child: child,
  );
}

class ResponsiveSplit extends StatelessWidget {
  const ResponsiveSplit({
    super.key,
    required this.primary,
    required this.secondary,
    this.breakpoint = 900,
    this.primaryFlex = 5,
    this.secondaryFlex = 7,
  });

  final Widget primary;
  final Widget secondary;
  final double breakpoint;
  final int primaryFlex;
  final int secondaryFlex;

  @override
  Widget build(BuildContext context) {
    final gap = context.superTheme.spacing.space3;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(children: [primary, SizedBox(height: gap), secondary]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: primaryFlex, child: primary),
            SizedBox(width: gap),
            Expanded(flex: secondaryFlex, child: secondary),
          ],
        );
      },
    );
  }
}
