import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../../data/sample_data.dart';
import 'shared_build.dart';

NewTemplatesDemoBuild buildBalanceSheetDemo({required bool isRtl}) {
  final data = BalanceSheetData(
    reportDate: DateTime.now(),
    assets: BalanceSheetSection(
      title: 'Assets',
      titleAr: 'الأصول',
      items: const [
        BalanceSheetItem(
          accountCode: '1100',
          accountName: 'Cash and Bank',
          accountNameAr: 'النقد والبنوك',
          amount: 150000,
        ),
        BalanceSheetItem(
          accountCode: '1200',
          accountName: 'Accounts Receivable',
          accountNameAr: 'المدينون',
          amount: 85000,
        ),
        BalanceSheetItem(
          accountCode: '1300',
          accountName: 'Inventory',
          accountNameAr: 'المخزون',
          amount: 120000,
        ),
        BalanceSheetItem(
          accountCode: '1500',
          accountName: 'Fixed Assets',
          accountNameAr: 'الأصول الثابتة',
          amount: 200000,
        ),
      ],
    ),
    liabilities: BalanceSheetSection(
      title: 'Liabilities',
      titleAr: 'الالتزامات',
      items: const [
        BalanceSheetItem(
          accountCode: '2100',
          accountName: 'Accounts Payable',
          accountNameAr: 'الدائنون',
          amount: 65000,
        ),
        BalanceSheetItem(
          accountCode: '2200',
          accountName: 'Short-term Loans',
          accountNameAr: 'قروض قصيرة الأجل',
          amount: 100000,
        ),
      ],
    ),
    equity: BalanceSheetSection(
      title: 'Equity',
      titleAr: 'حقوق الملكية',
      items: const [
        BalanceSheetItem(
          accountCode: '3100',
          accountName: 'Share Capital',
          accountNameAr: 'رأس المال',
          amount: 300000,
        ),
        BalanceSheetItem(
          accountCode: '3200',
          accountName: 'Retained Earnings',
          accountNameAr: 'الأرباح المحتجزة',
          amount: 90000,
        ),
      ],
    ),
  );

  final template = BalanceSheetTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'balance_sheet_demo',
  );
}

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

NewTemplatesDemoBuild buildCashFlowDemo({required bool isRtl}) {
  final data = CashFlowData(
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 31),
    operatingActivities: CashFlowSection(
      type: CashFlowActivityType.operating,
      title: '',
      items: const [
        CashFlowItem(
          description: 'Cash received from customers',
          descriptionAr: 'النقد المستلم من العملاء',
          amount: 480000,
        ),
        CashFlowItem(
          description: 'Cash paid to suppliers',
          descriptionAr: 'النقد المدفوع للموردين',
          amount: -250000,
        ),
        CashFlowItem(
          description: 'Cash paid to employees',
          descriptionAr: 'النقد المدفوع للموظفين',
          amount: -120000,
        ),
      ],
    ),
    investingActivities: CashFlowSection(
      type: CashFlowActivityType.investing,
      title: '',
      items: const [
        CashFlowItem(
          description: 'Purchase of equipment',
          descriptionAr: 'شراء معدات',
          amount: -50000,
        ),
      ],
    ),
    financingActivities: CashFlowSection(
      type: CashFlowActivityType.financing,
      title: '',
      items: const [
        CashFlowItem(
          description: 'Bank loan received',
          descriptionAr: 'قرض بنكي مستلم',
          amount: 100000,
        ),
      ],
    ),
    beginningCashBalance: 100000,
  );

  final template = CashFlowTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'cash_flow_demo',
  );
}

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
