
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

class ExampleSection extends StatelessWidget {
  const ExampleSection({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.leading,
    this.trailing,
    this.padding,
  });

  final String title;
  final String? description;
  final Widget? leading;
  final Widget? trailing;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    final typography = context.superTextTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: padding ?? spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  IconTheme(
                    data: IconThemeData(color: Theme.of(context).colorScheme.primary),
                    child: leading!,
                  ),
                  SizedBox(width: spacing.space2),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: typography.titleMd),
                      if (description != null) ...<Widget>[
                        SizedBox(height: spacing.space1),
                        Text(
                          description!,
                          style: typography.bodySm.copyWith(color: context.superTheme.fg2),
                        ),
                      ],
                    ],
                  ),
                ),
                if (trailing != null) ...<Widget>[
                  SizedBox(width: spacing.space3),
                  trailing!,
                ],
              ],
            ),
            SizedBox(height: spacing.space4),
            child,
          ],
        ),
      ),
    );
  }
}
