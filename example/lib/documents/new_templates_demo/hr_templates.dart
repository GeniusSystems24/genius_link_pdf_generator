import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../../data/sample_data.dart';
import 'shared_build.dart';

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
