import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import 'package:super_core/super_core.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
class CodeViewer extends StatelessWidget {
  const CodeViewer({
    super.key,
    required this.code,
    this.language = Syntax.DART,
    this.height,
    this.title = 'Dart usage code',
  });

  final String code;
  final Syntax language;
  final double? height;
  final String title;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;
    final t = context.superTheme;
    final text = context.superTextTheme;

    return Container(
      height: height ?? 320,
      decoration: BoxDecoration(
        borderRadius: t.spacing.cardBorderRadius,
        border: Border.all(color: colors.outlineVariant),
        color: colors.surfaceContainerLow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: t.spacing.space3,
              vertical: t.spacing.space2,
            ),
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              border: Border(
                bottom: BorderSide(color: colors.outlineVariant),
              ),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    borderRadius: BorderRadius.circular(t.spacing.radiusControl),
                  ),
                  child: Icon(
                    Icons.code_rounded,
                    size: 16,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                SizedBox(width: t.spacing.space2),
                Expanded(
                  child: Text(
                    title,
                    style: text.labelMd.copyWith(color: t.fg1),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  tooltip: pdfLocalization.copyCode,
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: code));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(
                        behavior: SnackBarBehavior.floating,
                        content: Text(pdfLocalization.codeCopiedToClipboard),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: SyntaxView(
              code: code,
              syntax: language,
              syntaxTheme: isDark ? SyntaxTheme.dracula() : SyntaxTheme.ayuLight(),
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
