import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/hr_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated example screen for the Leave Report business template.
class LeaveReportTemplateScreen extends StatelessWidget {
  const LeaveReportTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildLeaveReportDemo({required bool isRtl}) {
  final data = LeaveReportData(
    reportTitle: 'Leave Report',
    reportTitleAr: 'تقرير الإجازات',
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 12, 31),
    leaveBalances: const [
      LeaveBalance(
        employeeId: 'EMP-001',
        employeeName: 'Mohammed Al-Ahmed',
        employeeNameAr: 'محمد الأحمد',
        annualEntitlement: 21,
        annualUsed: 5,
        sickUsed: 2,
        carryForward: 3,
      ),
    ],
    leaveRequests: [
      LeaveRecord(
        leaveId: 'LV-001',
        employeeId: 'EMP-001',
        employeeName: 'Mohammed Al-Ahmed',
        leaveType: LeaveType.annual,
        startDate: DateTime(2026, 2, 15),
        endDate: DateTime(2026, 2, 19),
        status: LeaveStatus.approved,
      ),
    ],
  );

  final template = LeaveReportTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'leave_report_demo',
  );
}

final build = buildLeaveReportDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return  BusinessTemplateDetailScreen(
      category: 'HR Documents',
      title: pdfLocalization.leaveReport,
      titleAr: 'تقرير الإجازات',
      description: pdfLocalization.leaveBalancesRequestsPeriodsTypesDesc,
      icon: Icons.event_available_outlined,
      buildTemplate: buildLeaveReportDemo,
      usageCode: dartUsageCode,
    );
  }
}
