import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/business_templates/models/documents/hr_templates.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/widgets/business_template_detail_screen.dart';

/// Dedicated example screen for the Attendance Report business template.
class AttendanceReportTemplateScreen extends StatelessWidget {
  const AttendanceReportTemplateScreen({super.key});

  static const String dartUsageCode = r'''// Dart usage code — the same data/template setup used by this example.
// Set isRtl to false for LTR output.

NewTemplatesDemoBuild buildAttendanceReportDemo({required bool isRtl}) {
  final data = AttendanceReportData(
    reportTitle: 'Attendance Report',
    reportTitleAr: 'تقرير الحضور',
    periodStart: DateTime(2026, 1, 1),
    periodEnd: DateTime(2026, 1, 15),
    showDailyDetails: false,
    employees: [
      AttendanceEmployeeSummary(
        employeeId: 'EMP-001',
        employeeName: 'Mohammed Al-Ahmed',
        employeeNameAr: 'محمد الأحمد',
        attendance: List.generate(
          11,
          (i) => DailyAttendance(
            date: DateTime(2026, 1, 1).add(Duration(days: i)),
            status: i % 7 == 5 || i % 7 == 6
                ? AttendanceStatus.weekend
                : AttendanceStatus.present,
            workingHours: 8,
          ),
        ),
      ),
    ],
  );

  final template = AttendanceReportTemplate(
    config: createNewTemplatesDemoConfig(isRtl: isRtl),
    company: SampleData.companyInfo,
    data: data,
  );

  return NewTemplatesDemoBuild(
    builder: template,
    fileName: 'attendance_report_demo',
  );
}

final build = buildAttendanceReportDemo(isRtl: true);
final pdfBytes = Uint8List.fromList(build.builder.generate());
build.builder.dispose();
''';

  @override
  Widget build(BuildContext context) {
    return const BusinessTemplateDetailScreen(
      category: 'HR Documents',
      title: 'Attendance Report',
      titleAr: 'تقرير الحضور',
      description: 'Attendance summary with working days, statuses, and working hours.',
      icon: Icons.fact_check_outlined,
      buildTemplate: buildAttendanceReportDemo,
      usageCode: dartUsageCode,
    );
  }
}
