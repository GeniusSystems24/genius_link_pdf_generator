part of '../pdf_summary.dart';

/// A group of related summary items with an optional header (v2.12.5).
///
/// Groups allow organizing summary items into logical sections within
/// a single [GeniusPdfSummarySection]. Each group can have:
/// - A bilingual title/header
/// - Custom header styling
/// - An optional background color for the header
/// - Its own list of [GeniusPdfSummaryItem]s
///
/// ## Example
/// ```dart
/// GeniusPdfSummaryGroup(
///   title: 'Revenue',
///   titleAr: 'الإيرادات',
///   items: [
///     GeniusPdfSummaryItem(label: 'Sales', value: '50,000'),
///     GeniusPdfSummaryItem(label: 'Services', value: '15,000'),
///     GeniusPdfSummaryItem.subtotal(label: 'Total Revenue', value: '65,000'),
///   ],
/// )
/// ```
class GeniusPdfSummaryGroup {
  const GeniusPdfSummaryGroup({
    this.title,
    this.titleAr,
    required this.items,
    this.headerStyle,
    this.headerBackgroundColor,
  });

  /// Creates a group with a highlighted header background.
  const GeniusPdfSummaryGroup.highlighted({
    required this.title,
    this.titleAr,
    required this.items,
    this.headerStyle,
    this.headerBackgroundColor = const Color(0xFFE8E8E8),
  });

  /// Creates a group for income/revenue items (green tint header).
  const GeniusPdfSummaryGroup.income({
    required this.title,
    this.titleAr,
    required this.items,
    this.headerStyle,
  }) : headerBackgroundColor = const Color(0xFFE8F5E9);

  /// Creates a group for expense/deduction items (red tint header).
  const GeniusPdfSummaryGroup.expense({
    required this.title,
    this.titleAr,
    required this.items,
    this.headerStyle,
  }) : headerBackgroundColor = const Color(0xFFFFEBEE);

  /// Group title (English).
  final String? title;

  /// Group title (Arabic).
  final String? titleAr;

  /// Items within this group.
  final List<GeniusPdfSummaryItem> items;

  /// Custom text style for the group header.
  final GeniusPdfTextStyle? headerStyle;

  /// Background color for the group header row.
  final Color? headerBackgroundColor;
}
