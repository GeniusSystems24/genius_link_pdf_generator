
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

class ExampleActionToolbar extends StatelessWidget {
  const ExampleActionToolbar({
    super.key,
    required this.actions,
    this.leading,
  });

  final Widget? leading;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    return Card(
      child: Padding(
        padding: spacing.cardPadding,
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: spacing.space3,
          runSpacing: spacing.space2,
          children: <Widget>[
            if (leading != null) leading!,
            Wrap(
              spacing: spacing.space2,
              runSpacing: spacing.space2,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
