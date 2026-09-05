import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated screen for **Financial Analysis**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class GridRichtextFinancialAnalysisExampleScreen extends StatelessWidget {
  const GridRichtextFinancialAnalysisExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Financial Analysis** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `financial_analysis_example_screen.dart` and displayed as **Dart usage code**.
class GridRichtextFinancialAnalysisDemoBuilder extends GeniusPdfDocumentBuilder {
  GridRichtextFinancialAnalysisDemoBuilder(super.config);

  @override
  void build() {
    // PAGE 1: Financial Analysis with Rich Text
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'جدول البيانات مع النصوص المنسقة — Grid + Rich Text'
          : 'Data Grid with Rich Text — Grid + Rich Text',
      spacing: 10,
    );

    addLine(
      config.isRTL ? 'تقرير التحليل المالي' : 'Financial Analysis Report',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(10);

    // Introduction using rich text builder
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .text(config.isRTL
              ? 'يقدم هذا التقرير تحليلاً شاملاً للأداء المالي خلال الربع الأول من عام 2026. '
              : 'This report provides a comprehensive analysis of financial performance for Q1 2026. ')
          .bold(config.isRTL ? 'النتائج الرئيسية' : 'Key findings')
          .text(config.isRTL
              ? ' تظهر نمواً إيجابياً بنسبة '
              : ' show positive growth of ')
          .positive('+15.6%')
          .text(config.isRTL
              ? ' مقارنة بالفترة السابقة.'
              : ' compared to the previous period.')
          .build(),
      spacing: 10,
    );

    addSpace(15);

    // Revenue breakdown grid
    addLine(
      config.isRTL ? '١. توزيع الإيرادات' : '1. Revenue Breakdown',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(10);

    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'source',
            title: 'Revenue Source',
            titleAr: 'مصدر الإيرادات',
            width: 150,
          ),
          GeniusPdfGridColumn.currency(
            id: 'q1_2025',
            title: 'Q1 2025',
            titleAr: 'ر١ ٢٠٢٥',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn.currency(
            id: 'q1_2026',
            title: 'Q1 2026',
            titleAr: 'ر١ ٢٠٢٦',
            widthPercent: 0.20,
            currencySymbol: config.isRTL ? 'ر.س' : 'SAR',
          ),
          GeniusPdfGridColumn(
            id: 'change',
            title: 'Change',
            titleAr: 'التغيير',
            width: 80,
            alignment: GeniusPdfTextAlign.center,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'source': config.isRTL ? 'مبيعات المنتجات' : 'Product Sales',
            'q1_2025': 450000.0,
            'q1_2026': 520000.0,
            'change': '+15.6%',
          }),
          GeniusPdfGridRow(cells: {
            'source': config.isRTL ? 'خدمات الصيانة' : 'Service Revenue',
            'q1_2025': 180000.0,
            'q1_2026': 195000.0,
            'change': '+8.3%',
          }),
          GeniusPdfGridRow(cells: {
            'source': config.isRTL ? 'تراخيص البرامج' : 'Software Licensing',
            'q1_2025': 85000.0,
            'q1_2026': 112000.0,
            'change': '+31.8%',
          }),
          GeniusPdfGridRow(cells: {
            'source': config.isRTL ? 'خدمات استشارية' : 'Consulting',
            'q1_2025': 65000.0,
            'q1_2026': 58000.0,
            'change': '-10.8%',
          }),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.sum(
            label: 'Total Revenue',
            labelAr: 'إجمالي الإيرادات',
            labelColumnId: 'source',
            columnIds: ['q1_2025', 'q1_2026'],
          ),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    addSpace(15);

    // Analysis commentary
    addRichText(
      GeniusPdfRichTextBuilder(config: config)
          .bold(config.isRTL ? 'تحليل الإيرادات: ' : 'Revenue Analysis: ')
          .text(config.isRTL
              ? 'شهدت الشركة نمواً ملحوظاً في قطاع '
              : 'The company experienced notable growth in ')
          .bold(config.isRTL ? 'تراخيص البرامج' : 'Software Licensing')
          .text(' (+31.8%)')
          .text(config.isRTL
              ? '، بينما شهد قطاع الاستشارات انخفاضاً طفيفاً بنسبة '
              : ', while Consulting saw a slight decline of ')
          .negative('-10.8%')
          .text(config.isRTL
              ? ' نتيجة انتهاء بعض المشاريع الكبرى.'
              : ' due to completion of major projects.')
          .build(),
      spacing: 10,
    );

    // ================================================================
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'grid_richtext_financial_analysis',
      category: 'Components / Component Compositions / Grid + Rich Text',
      title: pdfLocalization.financialAnalysis,
      apiName: 'GeniusPdfDataGrid + GeniusPdfRichText',
      description: pdfLocalization.introductoryRichTextRevenueAnalysisDesc,
      icon: Icons.analytics_outlined,
      usageCode: dartUsageCode,
    );
  }
}
