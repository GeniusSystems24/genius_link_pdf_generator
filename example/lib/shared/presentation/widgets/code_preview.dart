import 'package:genius_pdf_example/app/localization/showcase_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:super_core/super_core.dart';

class CodePreview extends StatelessWidget {
  const CodePreview({super.key, required this.code, this.height = 340});
  final String code;
  final double height;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final t = context.superTheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: t.inputBg,
        border: Border.all(color: t.border),
        borderRadius: t.spacing.borderRadiusCard,
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: t.spacing.space3,
              vertical: t.spacing.space2,
            ),
            child: Row(
              children: [
                const Icon(Icons.code_outlined, size: 18),
                SizedBox(width: t.spacing.space2),
                Expanded(child: Text(l10n.tr('Dart usage'), style: context.superTextTheme.label)),
                IconButton(
                  tooltip: l10n.tr('Copy code'),
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.tr('Code copied'))));
                    }
                  },
                  icon: const Icon(Icons.copy_outlined, size: 18),
                ),
              ],
            ),
          ),
          Hairline(color: t.border),
          Expanded(
            child: SyntaxView(
              code: code,
              syntax: Syntax.DART,
              syntaxTheme: dark ? SyntaxTheme.dracula() : SyntaxTheme.ayuLight(),
              fontSize: 12,
              withZoom: false,
              withLinesCount: true,
              expanded: true,
            ),
          ),
        ],
      ),
    );
  }
}
