import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/financial_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

/// Dedicated example screen for the Cash Flow Statement business template.
class CashFlowTemplateScreen extends StatelessWidget {
  const CashFlowTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

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

final build = buildCashFlowDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return const BusinessTemplateDetailScreen(
      category: 'Financial Reports',
      title: 'Cash Flow Statement',
      titleAr: 'قائمة التدفقات النقدية',
      description: 'Operating, investing, and financing cash-flow activities.',
      icon: Icons.water_drop_outlined,
      buildTemplate: buildCashFlowDemo,
      usageCode: dartUsageCode,
    );
  }
}
