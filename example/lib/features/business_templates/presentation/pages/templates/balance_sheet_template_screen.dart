import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/financial_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated example screen for the Balance Sheet business template.
class BalanceSheetTemplateScreen extends StatelessWidget {
  const BalanceSheetTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

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

final build = buildBalanceSheetDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return  BusinessTemplateDetailScreen(
      category: 'Financial Reports',
      title: pdfLocalization.balanceSheet,
      titleAr: 'الميزانية العمومية',
      description: pdfLocalization.assetsLiabilitiesEquityCompleteDesc,
      icon: Icons.account_balance_wallet_outlined,
      buildTemplate: buildBalanceSheetDemo,
      usageCode: dartUsageCode,
    );
  }
}
