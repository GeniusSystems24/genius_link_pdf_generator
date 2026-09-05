import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

/// Dedicated screen for **Expense Recommendations**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class GridRichtextExpenseRecommendationsExampleScreen extends StatelessWidget {
  const GridRichtextExpenseRecommendationsExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Expense Recommendations** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `expense_recommendations_example_screen.dart` and displayed as **Dart usage code**.
class GridRichtextExpenseRecommendationsDemoBuilder extends GeniusPdfDocumentBuilder {
  GridRichtextExpenseRecommendationsDemoBuilder(super.config);

  @override
  void build() {
    // PAGE 2: Expense Analysis with Recommendations
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٢: تحليل المصروفات والتوصيات'
          : 'Example 2: Expense Analysis & Recommendations',
      spacing: 10,
    );

    addSpace(15);

    // Expense grid
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'category',
            title: 'Expense Category',
            titleAr: 'فئة المصروفات',
            width: 150,
          ),
          GeniusPdfGridColumn.currency(
            id: 'budget',
            title: 'Budget',
            titleAr: 'الميزانية',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.currency(
            id: 'actual',
            title: 'Actual',
            titleAr: 'الفعلي',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn(
            id: 'variance',
            title: 'Variance',
            titleAr: 'الفرق',
            width: 80,
            alignment: GeniusPdfTextAlign.center,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'الرواتب والأجور' : 'Salaries & Wages',
            'budget': 320000.0,
            'actual': 318500.0,
            'variance': '-0.5%',
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'التسويق والإعلان' : 'Marketing',
            'budget': 85000.0,
            'actual': 102000.0,
            'variance': '+20.0%',
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'البنية التحتية' : 'Infrastructure',
            'budget': 45000.0,
            'actual': 43200.0,
            'variance': '-4.0%',
          }),
          GeniusPdfGridRow(cells: {
            'category': config.isRTL ? 'البحث والتطوير' : 'R&D',
            'budget': 75000.0,
            'actual': 82000.0,
            'variance': '+9.3%',
          }),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total Expenses',
            labelAr: 'إجمالي المصروفات',
            labelColumnId: 'category',
            columnIds: ['budget', 'actual'],
          ),
        ],
        style: GeniusPdfGridStyle.invoice(),
      ),
      spacing: 10,
    );

    addSpace(20);

    // Recommendations section with rich text
    addLine(
      config.isRTL ? 'التوصيات الرئيسية' : 'Key Recommendations',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(10);

    // Recommendation 1
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold('1. ')
          .bold(config.isRTL
              ? 'مراجعة ميزانية التسويق: '
              : 'Review Marketing Budget: ')
          .text(config.isRTL
              ? 'تجاوزت المصروفات الميزانية بنسبة '
              : 'Expenses exceeded budget by ')
          .negative('+20%')
          .text(config.isRTL
              ? '. يُوصى بتحليل العائد على الاستثمار للحملات الحالية.'
              : '. Recommend ROI analysis of current campaigns.')
          .build(),
      spacing: 8,
    );

    // Recommendation 2
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold('2. ')
          .bold(config.isRTL
              ? 'استثمار إضافي في البحث والتطوير: '
              : 'Additional R&D Investment: ')
          .text(config.isRTL
              ? 'نظراً للنمو القوي في تراخيص البرامج '
              : 'Given strong Software Licensing growth ')
          .positive('(+31.8%)')
          .text(config.isRTL
              ? '، يُوصى بزيادة الاستثمار في هذا القطاع.'
              : ', recommend increasing investment in this sector.')
          .build(),
      spacing: 8,
    );

    // Recommendation 3
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold('3. ')
          .bold(config.isRTL
              ? 'تنويع مصادر الإيرادات: '
              : 'Diversify Revenue Sources: ')
          .text(config.isRTL
              ? 'تقليل الاعتماد على قطاع واحد من خلال تطوير خدمات استشارية جديدة.'
              : 'Reduce dependence on single sector by developing new consulting services.')
          .build(),
      spacing: 8,
    );

    addSpace(15);

    // Summary info box
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملخص التقرير' : 'Report Summary',
        titleAr: 'ملخص التقرير',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'إجمالي الإيرادات' : 'Total Revenue',
            labelAr: 'إجمالي الإيرادات',
            value: config.isRTL ? '٨٨٥,٠٠٠ ر.س' : 'SAR 885,000',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'إجمالي المصروفات' : 'Total Expenses',
            labelAr: 'إجمالي المصروفات',
            value: config.isRTL ? '٥٤٥,٧٠٠ ر.س' : 'SAR 545,700',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'صافي الربح' : 'Net Profit',
            labelAr: 'صافي الربح',
            value: config.isRTL ? '٣٣٩,٣٠٠ ر.س' : 'SAR 339,300',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.success(),
      ),
      spacing: 10,
    );
  }
}''';

  @override
  Widget build(BuildContext context) {
    return const ComponentExampleDetailScreen(
      componentId: 'grid_richtext_expense_recommendations',
      category: 'Components / Component Compositions / Grid + Rich Text',
      title: 'Expense Recommendations',
      apiName: 'GeniusPdfDataGrid + GeniusPdfRichText',
      description: 'Combine an expense grid with formatted recommendation blocks and a report summary info box.',
      icon: Icons.insights_outlined,
      usageCode: dartUsageCode,
    );
  }
}
