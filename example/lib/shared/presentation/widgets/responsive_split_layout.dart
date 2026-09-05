
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

class ResponsiveSplitLayout extends StatelessWidget {
  const ResponsiveSplitLayout({
    super.key,
    required this.primary,
    required this.secondary,
    this.breakpoint = 1080,
    this.primaryFlex = 3,
    this.secondaryFlex = 2,
  });

  final Widget primary;
  final Widget secondary;
  final double breakpoint;
  final int primaryFlex;
  final int secondaryFlex;

  @override
  Widget build(BuildContext context) {
    final gap = context.superTheme.spacing.space4;
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < breakpoint) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              primary,
              SizedBox(height: gap),
              secondary,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(flex: primaryFlex, child: primary),
            SizedBox(width: gap),
            Expanded(flex: secondaryFlex, child: secondary),
          ],
        );
      },
    );
  }
}
