import 'package:flutter/material.dart';
import 'package:super_core/super_core.dart';

enum OperationTone { neutral, busy, success, error }

class OperationStatePanel extends StatelessWidget {
  const OperationStatePanel({
    super.key,
    required this.message,
    this.detail,
    this.tone = OperationTone.neutral,
  });
  final String message;
  final String? detail;
  final OperationTone tone;

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final semantic = SuperSemanticColors.of(context);
    final role = switch (tone) {
      OperationTone.busy => semantic.info,
      OperationTone.success => semantic.success,
      OperationTone.error => semantic.danger,
      OperationTone.neutral => null,
    };
    final bg = role?.subtle ?? t.inputBg;
    final fg = role?.onSubtle ?? t.fg2;
    final border = role?.border ?? t.border;
    final icon = switch (tone) {
      OperationTone.busy => Icons.autorenew,
      OperationTone.success => Icons.check_circle_outline,
      OperationTone.error => Icons.error_outline,
      OperationTone.neutral => Icons.info_outline,
    };
    return Container(
      padding: t.spacing.cardPadding,
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: border),
        borderRadius: t.spacing.borderRadiusCard,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 20),
          SizedBox(width: t.spacing.space2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(message, style: context.superTextTheme.label.copyWith(color: fg)),
                if (detail != null) ...[
                  SizedBox(height: t.spacing.space1),
                  Text(detail!, style: context.superTextTheme.caption.copyWith(color: fg)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
