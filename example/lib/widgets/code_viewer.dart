import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_syntax_view/flutter_syntax_view.dart';
import '../theme/app_theme.dart';

class CodeViewer extends StatelessWidget {
  const CodeViewer({
    super.key,
    required this.code,
    this.language = Syntax.DART,
    this.height,
  });

  final String code;
  final Syntax language;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;

        return Container(
          height: height ?? 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            ),
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Header
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color:
                    isDark ? const Color(0xFF0F172A) : const Color(0xFFE2E8F0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? Colors.blue.withValues(alpha: 0.2)
                                : Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Icon(
                            Icons.code_rounded,
                            size: 14,
                            color: isDark ? Colors.blue[200] : Colors.blue[700],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Example Code',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Code copied to clipboard',
                              style: TextStyle(
                                color: isDark ? Colors.black : Colors.white,
                              ),
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor:
                                isDark ? Colors.white : Colors.black87,
                          ),
                        );
                      },
                      tooltip: 'Copy Code',
                      style: IconButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        foregroundColor:
                            isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SyntaxView(
                  code: code,
                  syntax: language,
                  syntaxTheme:
                      isDark ? SyntaxTheme.dracula() : SyntaxTheme.ayuLight(),
                  fontSize: 12.0,
                  withZoom: false,
                  withLinesCount: true,
                  expanded: true,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
