part of '../grid_models.dart';

/// Represents a group of rows with optional header and summary.
///
/// Enhanced group with support for:
/// - Bilingual titles
/// - Nested subgroups
/// - Multiple summary rows
/// - Custom styling
/// - Collapsible state
/// - Aggregate calculations
///
/// ## Example
/// ```dart
/// GeniusPdfGridGroup(
///   title: 'Q1 Sales',
///   titleAr: 'مبيعات الربع الأول',
///   rows: salesRows,
///   summary: GeniusPdfGridRow.total({'total': 15000}),
/// )
/// ```
class GeniusPdfGridGroup {
  const GeniusPdfGridGroup({
    required this.title,
    required this.rows,
    this.titleAr,
    this.subtitle,
    this.subtitleAr,
    this.summary,
    this.summaries,
    this.style,
    this.headerStyle,
    this.summaryStyle,
    this.level = 0,
    this.collapsed = false,
    this.showHeader = true,
    this.showSummary = true,
    this.headerSpan = true,
    this.summaryLabel,
    this.summaryLabelAr,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.indent,
    this.keepTogether = false,
    this.pageBreakBefore = false,
    this.pageBreakAfter = false,
    this.subgroups,
    this.tag,
    this.metadata,
  });

  /// Creates a simple group with just title and rows.
  factory GeniusPdfGridGroup.simple({
    required String title,
    required List<GeniusPdfGridRow> rows,
    String? titleAr,
  }) {
    return GeniusPdfGridGroup(
      title: title,
      titleAr: titleAr,
      rows: rows,
    );
  }

  /// Creates a group with auto-calculated summary.
  factory GeniusPdfGridGroup.withSummary({
    required String title,
    required List<GeniusPdfGridRow> rows,
    required List<String> sumColumns,
    String? titleAr,
    String summaryLabel = 'Subtotal',
    String? summaryLabelAr,
    String? labelColumnId,
  }) {
    final summaryValues = <String, dynamic>{};
    if (labelColumnId != null) {
      summaryValues[labelColumnId] = summaryLabel;
    }
    for (final columnId in sumColumns) {
      double total = 0;
      for (final row in rows) {
        final value = row.cells[columnId];
        if (value is num) {
          total += value;
        } else if (value is String) {
          final parsed = double.tryParse(value);
          if (parsed != null) total += parsed;
        }
      }
      summaryValues[columnId] = total;
    }
    return GeniusPdfGridGroup(
      title: title,
      titleAr: titleAr,
      rows: rows,
      summaryLabel: summaryLabel,
      summaryLabelAr: summaryLabelAr,
      summary: GeniusPdfGridRow.subtotal(summaryValues),
    );
  }

  /// Creates a hierarchical group with subgroups.
  factory GeniusPdfGridGroup.hierarchical({
    required String title,
    required List<GeniusPdfGridGroup> subgroups,
    String? titleAr,
    GeniusPdfGridRow? summary,
    int level = 0,
  }) {
    // Flatten rows from subgroups
    final allRows = <GeniusPdfGridRow>[];
    for (final subgroup in subgroups) {
      allRows.addAll(subgroup.rows);
    }
    return GeniusPdfGridGroup(
      title: title,
      titleAr: titleAr,
      rows: allRows,
      subgroups: subgroups,
      summary: summary,
      level: level,
    );
  }

  /// Group title (English or default).
  final String title;

  /// Arabic title (optional).
  final String? titleAr;

  /// Subtitle under the main title.
  final String? subtitle;

  /// Arabic subtitle.
  final String? subtitleAr;

  /// Rows in this group.
  final List<GeniusPdfGridRow> rows;

  /// Primary summary row for this group.
  final GeniusPdfGridRow? summary;

  /// Multiple summary rows (for complex summaries).
  final List<GeniusPdfGridRow>? summaries;

  /// Custom style for group row backgrounds.
  final GeniusPdfCellStyle? style;

  /// Custom style for group header.
  final GeniusPdfCellStyle? headerStyle;

  /// Custom style for summary rows.
  final GeniusPdfCellStyle? summaryStyle;

  /// Nesting level for hierarchical groups.
  final int level;

  /// Whether the group is collapsed (for display only).
  final bool collapsed;

  /// Whether to show the group header.
  final bool showHeader;

  /// Whether to show the summary row.
  final bool showSummary;

  /// Whether header spans all columns.
  final bool headerSpan;

  /// Label for the summary row.
  final String? summaryLabel;

  /// Arabic label for the summary row.
  final String? summaryLabelAr;

  /// Icon identifier for group header.
  final String? icon;

  /// Icon color.
  final Color? iconColor;

  /// Background color for the group section.
  final Color? backgroundColor;

  /// Custom indent (overrides calculated indent based on level).
  final double? indent;

  /// Whether to keep the group together on one page.
  final bool keepTogether;

  /// Whether to insert a page break before this group.
  final bool pageBreakBefore;

  /// Whether to insert a page break after this group.
  final bool pageBreakAfter;

  /// Nested subgroups.
  final List<GeniusPdfGridGroup>? subgroups;

  /// Custom tag for identification.
  final String? tag;

  /// Additional metadata.
  final Map<String, dynamic>? metadata;

  /// Gets the display title based on locale.
  String getTitle({bool isArabic = false}) {
    if (isArabic && titleAr != null) return titleAr!;
    return title;
  }

  /// Gets the subtitle based on locale.
  String? getSubtitle({bool isArabic = false}) {
    if (isArabic && subtitleAr != null) return subtitleAr;
    return subtitle;
  }

  /// Gets the summary label based on locale.
  String? getSummaryLabel({bool isArabic = false}) {
    if (isArabic && summaryLabelAr != null) return summaryLabelAr;
    return summaryLabel;
  }

  /// Gets the total number of rows including subgroups.
  int get totalRowCount {
    int count = rows.length;
    if (subgroups != null) {
      for (final subgroup in subgroups!) {
        count += subgroup.totalRowCount;
      }
    }
    return count;
  }

  /// Gets all rows including from subgroups in order.
  List<GeniusPdfGridRow> get allRows {
    if (subgroups == null || subgroups!.isEmpty) {
      return rows;
    }
    final result = <GeniusPdfGridRow>[];
    for (final subgroup in subgroups!) {
      result.addAll(subgroup.allRows);
    }
    return result;
  }

  /// Gets all summary rows (primary + additional).
  List<GeniusPdfGridRow> get allSummaries {
    final result = <GeniusPdfGridRow>[];
    if (summary != null) result.add(summary!);
    if (summaries != null) result.addAll(summaries!);
    return result;
  }

  /// Calculates sum for a specific column across all rows.
  double calculateSum(String columnId) {
    double total = 0;
    for (final row in allRows) {
      final value = row.cells[columnId];
      if (value is num) {
        total += value;
      } else if (value is String) {
        final parsed = double.tryParse(value);
        if (parsed != null) total += parsed;
      }
    }
    return total;
  }

  /// Calculates average for a specific column.
  double calculateAverage(String columnId) {
    final all = allRows;
    if (all.isEmpty) return 0;
    return calculateSum(columnId) / all.length;
  }

  /// Gets the effective indent based on level.
  double getEffectiveIndent(double indentPerLevel) {
    return indent ?? (level * indentPerLevel);
  }

  /// Creates a copy with modified values.
  GeniusPdfGridGroup copyWith({
    String? title,
    String? titleAr,
    String? subtitle,
    String? subtitleAr,
    List<GeniusPdfGridRow>? rows,
    GeniusPdfGridRow? summary,
    List<GeniusPdfGridRow>? summaries,
    GeniusPdfCellStyle? style,
    GeniusPdfCellStyle? headerStyle,
    GeniusPdfCellStyle? summaryStyle,
    int? level,
    bool? collapsed,
    bool? showHeader,
    bool? showSummary,
    bool? headerSpan,
    String? summaryLabel,
    String? summaryLabelAr,
    String? icon,
    Color? iconColor,
    Color? backgroundColor,
    double? indent,
    bool? keepTogether,
    bool? pageBreakBefore,
    bool? pageBreakAfter,
    List<GeniusPdfGridGroup>? subgroups,
    String? tag,
    Map<String, dynamic>? metadata,
  }) {
    return GeniusPdfGridGroup(
      title: title ?? this.title,
      titleAr: titleAr ?? this.titleAr,
      subtitle: subtitle ?? this.subtitle,
      subtitleAr: subtitleAr ?? this.subtitleAr,
      rows: rows ?? this.rows,
      summary: summary ?? this.summary,
      summaries: summaries ?? this.summaries,
      style: style ?? this.style,
      headerStyle: headerStyle ?? this.headerStyle,
      summaryStyle: summaryStyle ?? this.summaryStyle,
      level: level ?? this.level,
      collapsed: collapsed ?? this.collapsed,
      showHeader: showHeader ?? this.showHeader,
      showSummary: showSummary ?? this.showSummary,
      headerSpan: headerSpan ?? this.headerSpan,
      summaryLabel: summaryLabel ?? this.summaryLabel,
      summaryLabelAr: summaryLabelAr ?? this.summaryLabelAr,
      icon: icon ?? this.icon,
      iconColor: iconColor ?? this.iconColor,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      indent: indent ?? this.indent,
      keepTogether: keepTogether ?? this.keepTogether,
      pageBreakBefore: pageBreakBefore ?? this.pageBreakBefore,
      pageBreakAfter: pageBreakAfter ?? this.pageBreakAfter,
      subgroups: subgroups ?? this.subgroups,
      tag: tag ?? this.tag,
      metadata: metadata ?? this.metadata,
    );
  }
}
