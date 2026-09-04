import 'dart:ui';

import 'directionality.dart';
import 'pdf_print_theme.dart';
import '../components/models/pdf_styles.dart';

/// Semantic colors are independent from RTL/LTR.
class GeniusPdfSemanticColors {
  const GeniusPdfSemanticColors({
    required this.success,
    required this.warning,
    required this.error,
    required this.info,
    required this.debit,
    required this.credit,
    required this.positive,
    required this.negative,
    required this.muted,
    required this.highlight,
  });

  factory GeniusPdfSemanticColors.fromPrintTheme(GeniusPdfPrintTheme theme) {
    final c = theme.colorScheme;
    return GeniusPdfSemanticColors(
      success: c.positiveAmount,
      warning: const Color(0xFFF9A825),
      error: c.error,
      info: c.primary,
      debit: c.negativeAmount,
      credit: c.positiveAmount,
      positive: c.positiveAmount,
      negative: c.negativeAmount,
      muted: c.dividerColor,
      highlight: c.highlightBackground,
    );
  }

  final Color success;
  final Color warning;
  final Color error;
  final Color info;
  final Color debit;
  final Color credit;
  final Color positive;
  final Color negative;
  final Color muted;
  final Color highlight;
}

/// Logical start/end spacing token.
class GeniusPdfLogicalSpacing {
  const GeniusPdfLogicalSpacing({this.start = 0, this.end = 0, this.top = 0, this.bottom = 0});
  final double start;
  final double end;
  final double top;
  final double bottom;

  GeniusPdfCellPadding resolve(GeniusPdfResolvedDirection direction) {
    final rtl = direction == GeniusPdfResolvedDirection.rtl;
    return GeniusPdfCellPadding(left: rtl ? end : start, right: rtl ? start : end, top: top, bottom: bottom);
  }
}

class GeniusPdfLogicalSpacingTokens {
  const GeniusPdfLogicalSpacingTokens({required this.cell, required this.content, required this.section});

  factory GeniusPdfLogicalSpacingTokens.fromPrintTheme(GeniusPdfPrintTheme theme) {
    final s = theme.spacing;
    return GeniusPdfLogicalSpacingTokens(
      cell: GeniusPdfLogicalSpacing(start: s.cellPaddingHorizontal, end: s.cellPaddingHorizontal, top: s.cellPaddingVertical, bottom: s.cellPaddingVertical),
      content: GeniusPdfLogicalSpacing(start: s.contentPadding, end: s.contentPadding, top: s.contentPadding, bottom: s.contentPadding),
      section: GeniusPdfLogicalSpacing(start: s.md, end: s.md, top: s.sectionGap, bottom: s.sectionGap),
    );
  }

  final GeniusPdfLogicalSpacing cell;
  final GeniusPdfLogicalSpacing content;
  final GeniusPdfLogicalSpacing section;
}

/// Logical leading/trailing border token.
class GeniusPdfLogicalBorder {
  const GeniusPdfLogicalBorder({required this.base, this.leading = false, this.trailing = false, this.top = false, this.bottom = false});
  final GeniusPdfBorderStyle base;
  final bool leading;
  final bool trailing;
  final bool top;
  final bool bottom;

  GeniusPdfBorderStyle resolve(GeniusPdfResolvedDirection direction) {
    final rtl = direction == GeniusPdfResolvedDirection.rtl;
    return base.copyWith(left: rtl ? trailing : leading, right: rtl ? leading : trailing, top: top, bottom: bottom);
  }
}

class GeniusPdfLogicalBorderTokens {
  const GeniusPdfLogicalBorderTokens({required this.sectionAccent, required this.divider});

  factory GeniusPdfLogicalBorderTokens.fromPrintTheme(GeniusPdfPrintTheme theme) {
    final b = theme.borders;
    return GeniusPdfLogicalBorderTokens(
      sectionAccent: GeniusPdfLogicalBorder(base: b.sectionBorderStyle ?? b.thick, leading: true),
      divider: GeniusPdfLogicalBorder(base: b.dividerStyle ?? b.thin, bottom: true),
    );
  }

  final GeniusPdfLogicalBorder sectionAccent;
  final GeniusPdfLogicalBorder divider;
}

/// Direction-aware alignment defaults; color/weight are intentionally absent.
class GeniusPdfTypographyAlignmentTokens {
  const GeniusPdfTypographyAlignmentTokens({
    this.body = GeniusPdfTextAlign.start,
    this.label = GeniusPdfTextAlign.start,
    this.value = GeniusPdfTextAlign.end,
    this.heading = GeniusPdfTextAlign.start,
    this.centered = GeniusPdfTextAlign.center,
  });
  final GeniusPdfTextAlign body;
  final GeniusPdfTextAlign label;
  final GeniusPdfTextAlign value;
  final GeniusPdfTextAlign heading;
  final GeniusPdfTextAlign centered;
}

class GeniusPdfTableThemeTokens {
  const GeniusPdfTableThemeTokens({required this.headerBackground, required this.headerText, required this.cellText, required this.alternateRow, required this.border, required this.totalBackground, required this.totalText, required this.cellPadding, required this.headerPadding});

  factory GeniusPdfTableThemeTokens.fromPrintTheme(GeniusPdfPrintTheme theme) {
    final g = theme.gridTheme ?? const GeniusPdfGridTheme.defaults();
    return GeniusPdfTableThemeTokens(
      headerBackground: g.headerBackgroundColor,
      headerText: g.headerTextColor,
      cellText: theme.colorScheme.onSurface,
      alternateRow: g.alternateRowColor,
      border: g.borderColor,
      totalBackground: g.totalRowBackgroundColor,
      totalText: g.totalRowTextColor,
      cellPadding: g.cellPadding,
      headerPadding: g.headerPadding,
    );
  }

  final Color headerBackground;
  final Color headerText;
  final Color cellText;
  final Color alternateRow;
  final Color border;
  final Color totalBackground;
  final Color totalText;
  final GeniusPdfCellPadding cellPadding;
  final GeniusPdfCellPadding headerPadding;
}

class GeniusPdfDocumentThemeTokens {
  const GeniusPdfDocumentThemeTokens({required this.background, required this.surface, required this.text, required this.heading, required this.divider, required this.sectionGap, required this.componentGap});

  factory GeniusPdfDocumentThemeTokens.fromPrintTheme(GeniusPdfPrintTheme theme) => GeniusPdfDocumentThemeTokens(
        background: theme.colorScheme.background,
        surface: theme.colorScheme.surface,
        text: theme.colorScheme.onBackground,
        heading: theme.colorScheme.headerText,
        divider: theme.colorScheme.dividerColor,
        sectionGap: theme.spacing.sectionGap,
        componentGap: theme.spacing.componentGap,
      );

  final Color background;
  final Color surface;
  final Color text;
  final Color heading;
  final Color divider;
  final double sectionGap;
  final double componentGap;
}

class GeniusPdfSummaryHighlightTokens {
  const GeniusPdfSummaryHighlightTokens({required this.background, required this.text, required this.positive, required this.negative});

  factory GeniusPdfSummaryHighlightTokens.fromPrintTheme(GeniusPdfPrintTheme theme) => GeniusPdfSummaryHighlightTokens(
        background: theme.colorScheme.highlightBackground,
        text: theme.colorScheme.onSurface,
        positive: theme.colorScheme.positiveAmount,
        negative: theme.colorScheme.negativeAmount,
      );

  final Color background;
  final Color text;
  final Color positive;
  final Color negative;
}

/// Backward-compatible S05 facade over [GeniusPdfPrintTheme].
class GeniusPdfTheme {
  const GeniusPdfTheme({required this.printTheme, required this.semanticColors, required this.logicalSpacing, required this.logicalBorders, required this.typographyAlignment, required this.table, required this.document, required this.summary});

  factory GeniusPdfTheme.fromPrintTheme(GeniusPdfPrintTheme printTheme) => GeniusPdfTheme(
        printTheme: printTheme,
        semanticColors: GeniusPdfSemanticColors.fromPrintTheme(printTheme),
        logicalSpacing: GeniusPdfLogicalSpacingTokens.fromPrintTheme(printTheme),
        logicalBorders: GeniusPdfLogicalBorderTokens.fromPrintTheme(printTheme),
        typographyAlignment: const GeniusPdfTypographyAlignmentTokens(),
        table: GeniusPdfTableThemeTokens.fromPrintTheme(printTheme),
        document: GeniusPdfDocumentThemeTokens.fromPrintTheme(printTheme),
        summary: GeniusPdfSummaryHighlightTokens.fromPrintTheme(printTheme),
      );

  factory GeniusPdfTheme.defaults() => GeniusPdfTheme.fromPrintTheme(GeniusPdfPrintTheme.defaults());
  factory GeniusPdfTheme.corporate({Color primaryColor = const Color(0xFF1565C0), Color accentColor = const Color(0xFF0D47A1), Color textColor = const Color(0xFF212121)}) => GeniusPdfTheme.fromPrintTheme(GeniusPdfPrintTheme.corporate(primaryColor: primaryColor, accentColor: accentColor, textColor: textColor));
  factory GeniusPdfTheme.minimal({Color primaryColor = const Color(0xFF37474F), Color accentColor = const Color(0xFF263238)}) => GeniusPdfTheme.fromPrintTheme(GeniusPdfPrintTheme.minimal(primaryColor: primaryColor, accentColor: accentColor));
  factory GeniusPdfTheme.saudi({Color primaryColor = const Color(0xFF006C35), Color accentColor = const Color(0xFF00897B)}) => GeniusPdfTheme.fromPrintTheme(GeniusPdfPrintTheme.saudi(primaryColor: primaryColor, accentColor: accentColor));

  final GeniusPdfPrintTheme printTheme;
  final GeniusPdfSemanticColors semanticColors;
  final GeniusPdfLogicalSpacingTokens logicalSpacing;
  final GeniusPdfLogicalBorderTokens logicalBorders;
  final GeniusPdfTypographyAlignmentTokens typographyAlignment;
  final GeniusPdfTableThemeTokens table;
  final GeniusPdfDocumentThemeTokens document;
  final GeniusPdfSummaryHighlightTokens summary;

  GeniusPdfPrintTypography get typography => printTheme.typography;
  GeniusPdfPrintSpacing get spacing => printTheme.spacing;
  GeniusPdfPrintBorders get borders => printTheme.borders;
  GeniusPdfPrintColorScheme get colors => printTheme.colorScheme;
}
