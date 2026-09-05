import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/financial_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

/// Dedicated example screen for the Income Statement business template.
class IncomeStatementTemplateScreen extends StatelessWidget {
  const IncomeStatementTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildIncomeStatementDemo({required bool isRtl}) {
  final data = IncomeStatementData(
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 31),
    revenue: IncomeStatementSection(
      title: 'Revenue',
      titleAr: 'الإيرادات',
      items: const [
        IncomeStatementItem(
          accountCode: '4100',
          accountName: 'Sales Revenue',
          accountNameAr: 'إيرادات المبيعات',
          amount: 500000,
        ),
        IncomeStatementItem(
          accountCode: '4200',
          accountName: 'Service Revenue',
          accountNameAr: 'إيرادات الخدمات',
          amount: 150000,
        ),
      ],
    ),
    costOfSales: IncomeStatementSection(
      title: 'Cost of Sales',
      titleAr: 'تكلفة المبيعات',
      items: const [
        IncomeStatementItem(
          accountCode: '5100',
          accountName: 'Cost of Goods Sold',
          accountNameAr: 'تكلفة البضاعة المباعة',
          amount: 280000,
        ),
      ],
    ),
    operatingExpenses: IncomeStatementSection(
      title: 'Operating Expenses',
      titleAr: 'المصروفات التشغيلية',
      items: const [
        IncomeStatementItem(
          accountCode: '6100',
          accountName: 'Salaries & Wages',
          accountNameAr: 'الرواتب والأجور',
          amount: 120000,
        ),
        IncomeStatementItem(
          accountCode: '6200',
          accountName: 'Rent Expense',
          accountNameAr: 'مصروف الإيجار',
          amount: 25000,
        ),
      ],
    ),
    taxExpense: 25000,
  );

  final template = IncomeStatementTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'income_statement_demo',
  );
}

final build = buildIncomeStatementDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return const BusinessTemplateDetailScreen(
      category: 'Financial Reports',
      title: 'Income Statement',
      titleAr: 'قائمة الدخل',
      description: 'Revenue, cost of sales, operating expenses, and profitability.',
      icon: Icons.trending_up_outlined,
      buildTemplate: buildIncomeStatementDemo,
      usageCode: dartUsageCode,
    );
  }
}
