import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/financial_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated example screen for the Budget Report business template.
class BudgetReportTemplateScreen extends StatelessWidget {
  const BudgetReportTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildBudgetReportDemo({required bool isRtl}) {
  final data = BudgetReportData(
    reportTitle: 'Monthly Budget Report',
    reportTitleAr: 'تقرير الميزانية الشهرية',
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 31),
    sections: [
      BudgetSection(
        title: 'Revenue',
        titleAr: 'الإيرادات',
        items: const [
          BudgetItem(
            category: 'Product Sales',
            categoryAr: 'مبيعات المنتجات',
            budgetedAmount: 400000,
            actualAmount: 420000,
          ),
          BudgetItem(
            category: 'Service Revenue',
            categoryAr: 'إيرادات الخدمات',
            budgetedAmount: 100000,
            actualAmount: 95000,
          ),
        ],
      ),
      BudgetSection(
        title: 'Expenses',
        titleAr: 'المصروفات',
        isExpense: true,
        items: const [
          BudgetItem(
            category: 'Salaries',
            categoryAr: 'الرواتب',
            budgetedAmount: 120000,
            actualAmount: 125000,
          ),
          BudgetItem(
            category: 'Marketing',
            categoryAr: 'التسويق',
            budgetedAmount: 50000,
            actualAmount: 42000,
          ),
        ],
      ),
    ],
  );

  final template = BudgetReportTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'budget_report_demo',
  );
}

final build = buildBudgetReportDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return  BusinessTemplateDetailScreen(
      category: 'Financial Reports',
      title: pdfLocalization.budgetReport,
      titleAr: 'تقرير الميزانية',
      description: pdfLocalization.budgetVersusActualComparisonVarianceDesc,
      icon: Icons.pie_chart_outline_rounded,
      buildTemplate: buildBudgetReportDemo,
      usageCode: dartUsageCode,
    );
  }
}
