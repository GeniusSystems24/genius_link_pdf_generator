import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/hr_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

/// Dedicated example screen for the Employee Report business template.
class EmployeeReportTemplateScreen extends StatelessWidget {
  const EmployeeReportTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildEmployeeReportDemo({required bool isRtl}) {
  final data = EmployeeReportData(
    reportTitle: 'Employee Report',
    reportTitleAr: 'تقرير الموظفين',
    reportDate: DateTime.now(),
    showSalary: true,
    employees: [
      EmployeeRecord(
        employeeId: 'EMP-001',
        name: 'Mohammed Al-Ahmed',
        nameAr: 'محمد الأحمد',
        department: 'Engineering',
        departmentAr: 'الهندسة',
        designation: 'Senior Developer',
        joiningDate: DateTime(2022, 3, 15),
        status: EmployeeStatus.active,
        salary: 21450,
      ),
      EmployeeRecord(
        employeeId: 'EMP-002',
        name: 'Sara Al-Qahtani',
        nameAr: 'سارة القحطاني',
        department: 'HR',
        departmentAr: 'الموارد البشرية',
        designation: 'HR Manager',
        joiningDate: DateTime(2021, 6, 1),
        status: EmployeeStatus.active,
        salary: 25000,
      ),
    ],
  );

  final template = EmployeeReportTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'employee_report_demo',
  );
}

final build = buildEmployeeReportDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return const BusinessTemplateDetailScreen(
      category: 'HR Documents',
      title: 'Employee Report',
      titleAr: 'تقرير الموظفين',
      description: 'Employee directory/report with department, role, status, and salary data.',
      icon: Icons.badge_outlined,
      buildTemplate: buildEmployeeReportDemo,
      usageCode: dartUsageCode,
    );
  }
}
