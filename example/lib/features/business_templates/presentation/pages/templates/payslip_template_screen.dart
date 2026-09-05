import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/hr_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

/// Dedicated example screen for the Payslip business template.
class PayslipTemplateScreen extends StatelessWidget {
  const PayslipTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildPayslipDemo({required bool isRtl}) {
  final employee = PayslipEmployee(
    employeeId: 'EMP-001',
    name: 'Mohammed Al-Ahmed',
    nameAr: 'محمد الأحمد',
    department: 'Engineering',
    departmentAr: 'الهندسة',
    designation: 'Senior Developer',
    designationAr: 'مطور أول',
    joiningDate: DateTime(2022, 3, 15),
    bankName: 'Al Rajhi Bank',
    bankAccount: 'SA12345678901234567890',
  );

  final payslip = PayslipData(
    payPeriod: 'January 2026',
    payDate: DateTime(2026, 1, 28),
    workingDays: 22,
    paidDays: 22,
    earnings: const [
      EarningsItem(
        description: 'Basic Salary',
        descriptionAr: 'الراتب الأساسي',
        amount: 15000,
      ),
      EarningsItem(
        description: 'Housing Allowance',
        descriptionAr: 'بدل السكن',
        amount: 3750,
      ),
      EarningsItem(
        description: 'Transportation',
        descriptionAr: 'بدل المواصلات',
        amount: 1500,
      ),
    ],
    deductions: const [
      DeductionsItem(
        description: 'GOSI',
        descriptionAr: 'التأمينات',
        amount: 1462.50,
      ),
    ],
  );

  final template = PayslipTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    employee: employee,
    payslip: payslip,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'payslip_demo',
  );
}

final build = buildPayslipDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return const BusinessTemplateDetailScreen(
      category: 'HR Documents',
      title: 'Payslip',
      titleAr: 'قسيمة الراتب',
      description: 'Employee payslip with earnings, allowances, deductions, and net pay.',
      icon: Icons.payments_outlined,
      buildTemplate: buildPayslipDemo,
      usageCode: dartUsageCode,
    );
  }
}
