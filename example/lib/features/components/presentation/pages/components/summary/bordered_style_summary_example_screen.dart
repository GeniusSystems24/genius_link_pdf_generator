import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Bordered Style**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class BorderedStyleSummaryExampleScreen extends StatelessWidget {
  const BorderedStyleSummaryExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Bordered Style** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `bordered_style_summary_example_screen.dart` and displayed as **Dart usage code**.
class BorderedStyleSummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  BorderedStyleSummaryDemoBuilder(super.config);

  @override
  void build() {
    // ================================================================
    // PAGE 1: Basic Invoice Summary + Grouped Summary
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'ملخص المبالغ v2.12.5 — GeniusPdfSummary'
          : 'Summary Section v2.12.5 — GeniusPdfSummary',
      spacing: 10,
    );

    // Shared items for comparison
    final comparisonItems = [
      GeniusPdfSummaryItem(
        label: 'Subtotal',
        labelAr: 'المجموع الفرعي',
        value: config.formatter.formatMoney(10000, currencyCode: 'SAR'),
      ),
      GeniusPdfSummaryItem(
        label: 'Tax (15%)',
        labelAr: 'ضريبة (15%)',
        value: config.formatter.formatMoney(1500, currencyCode: 'SAR'),
      ),
      GeniusPdfSummaryItem.total(
        label: 'Total',
        labelAr: 'الإجمالي',
        value: config.formatter.formatMoney(11500, currencyCode: 'SAR'),
      ),
    ];

    // Bordered style
    addLine(
      config.isRTL ? 'نمط الحدود (bordered)' : 'bordered style',
      topMargin: 4,
    );
    addSpace(4);
    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        items: comparisonItems,
        style: GeniusPdfSummaryStyle.bordered(),
        width: 220,
      ),
      spacing: 10,
    );

    addSpace(12);
  }
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'summary_style_bordered',
      category: 'Components / Core PDF Components / Summary',
      title: 'Bordered Style',
      apiName: 'GeniusPdfSummarySection',
      description: 'Render the same summary data with GeniusPdfSummaryStyle.bordered().',
      icon: Icons.border_outer_outlined,
      usageCode: dartUsageCode,
    );
  }
}
