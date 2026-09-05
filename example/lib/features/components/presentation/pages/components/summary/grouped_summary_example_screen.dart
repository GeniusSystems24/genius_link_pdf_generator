import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';
import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Dedicated screen for **Grouped Income & Expenses**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class GroupedSummaryExampleScreen extends StatelessWidget {
  const GroupedSummaryExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'dart:ui' show Color;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Focused document builder for the **Grouped Income & Expenses** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `grouped_summary_example_screen.dart` and displayed as **Dart usage code**.
class GroupedSummaryDemoBuilder extends GeniusPdfDocumentBuilder {
  GroupedSummaryDemoBuilder(super.config);

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

    // --- Example 2: Grouped Summary ---
    addLine(
      config.isRTL
          ? 'مثال ٢: ملخص مجمّع مع مجموعات (إيرادات / مصروفات)'
          : 'Example 2: Grouped summary (Revenue / Expenses)',
      topMargin: 5,
    );

    addSpace(12);

    addReportSummary(
      summary: GeniusPdfSummarySection(
        config: config,
        title: config.isRTL ? 'الملخص المالي' : 'Financial Summary',
        titleAr: 'الملخص المالي',
        groups: [
          GeniusPdfSummaryGroup.income(
            title: config.isRTL ? 'الإيرادات' : 'Revenue',
            titleAr: 'الإيرادات',
            items: [
              GeniusPdfSummaryItem(
                label: 'Product Sales',
                labelAr: 'مبيعات المنتجات',
                value: config.formatter.formatMoney(85000.00, currencyCode: 'SAR'),
              ),
              GeniusPdfSummaryItem(
                label: 'Service Revenue',
                labelAr: 'إيرادات الخدمات',
                value: config.formatter.formatMoney(32000.00, currencyCode: 'SAR'),
              ),
              GeniusPdfSummaryItem(
                label: 'Consulting Fees',
                labelAr: 'رسوم الاستشارات',
                value: config.formatter.formatMoney(15000.00, currencyCode: 'SAR'),
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total Revenue',
                labelAr: 'إجمالي الإيرادات',
                value: config.formatter.formatMoney(132000.00, currencyCode: 'SAR'),
                valueColor: const Color(0xFF2E7D32),
              ),
            ],
          ),
          GeniusPdfSummaryGroup.expense(
            title: config.isRTL ? 'المصروفات' : 'Expenses',
            titleAr: 'المصروفات',
            items: [
              GeniusPdfSummaryItem(
                label: 'Operating Costs',
                labelAr: 'تكاليف التشغيل',
                value: config.formatter.formatMoney(45000.00, currencyCode: 'SAR'),
              ),
              GeniusPdfSummaryItem(
                label: 'Salaries',
                labelAr: 'الرواتب',
                value: config.formatter.formatMoney(38000.00, currencyCode: 'SAR'),
              ),
              GeniusPdfSummaryItem(
                label: 'Rent & Utilities',
                labelAr: 'الإيجار والمرافق',
                value: config.formatter.formatMoney(12000.00, currencyCode: 'SAR'),
              ),
              GeniusPdfSummaryItem.subtotal(
                label: 'Total Expenses',
                labelAr: 'إجمالي المصروفات',
                value: config.formatter.formatMoney(95000.00, currencyCode: 'SAR'),
                valueColor: const Color(0xFFC62828),
              ),
            ],
          ),
        ],
        items: [
          const GeniusPdfSummaryItem.separator(height: 4),
          GeniusPdfSummaryItem.total(
            label: 'Net Profit',
            labelAr: 'صافي الربح',
            value: config.formatter.formatMoney(37000.00, currencyCode: 'SAR'),
            valueColor: const Color(0xFF2E7D32),
          ),
        ],
        style: GeniusPdfSummaryStyle.bordered(),
        width: 280,
      ),
      spacing: 15,
    );

    // ================================================================
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'summary_grouped',
      category: 'Components / Core PDF Components / Summary',
      title: pdfLocalization.groupedIncomeAndExpenses,
      apiName: 'GeniusPdfSummarySection',
      description: pdfLocalization.geniusPdfSummaryGroupIncomeExpenseDesc,
      icon: Icons.account_tree_outlined,
      usageCode: dartUsageCode,
    );
  }
}
