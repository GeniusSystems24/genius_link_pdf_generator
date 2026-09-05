
import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

class ExampleAsyncStatePanel extends StatelessWidget {
  const ExampleAsyncStatePanel._({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
    this.loading = false,
  });

  factory ExampleAsyncStatePanel.empty({
    String title = 'Nothing to show yet',
    String message = 'Run the example to populate this area.',
    Widget? action,
  }) => ExampleAsyncStatePanel._(
        icon: Icons.inbox_outlined,
        title: title,
        message: message,
        action: action,
      );

  factory ExampleAsyncStatePanel.loading({
    String title = 'Working…',
    String message = 'The example is processing the current request.',
  }) => ExampleAsyncStatePanel._(
        icon: Icons.hourglass_top_rounded,
        title: title,
        message: message,
        loading: true,
      );

  factory ExampleAsyncStatePanel.error({
    String title = 'Unable to complete the example',
    required String message,
    Widget? action,
  }) => ExampleAsyncStatePanel._(
        icon: Icons.error_outline_rounded,
        title: title,
        message: message,
        action: action,
      );

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final spacing = context.superTheme.spacing;
    return Card(
      child: Padding(
        padding: spacing.cardPadding,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (loading)
                  const CircularProgressIndicator()
                else
                  Icon(icon, size: 32, color: context.superTheme.fg2),
                SizedBox(height: spacing.space3),
                Text(title, textAlign: TextAlign.center, style: context.superTextTheme.titleMd),
                SizedBox(height: spacing.space2),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: context.superTextTheme.bodySm.copyWith(color: context.superTheme.fg2),
                ),
                if (action != null) ...<Widget>[
                  SizedBox(height: spacing.space4),
                  action!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
