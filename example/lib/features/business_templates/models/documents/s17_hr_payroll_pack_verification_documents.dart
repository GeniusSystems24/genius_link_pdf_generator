// Generated from the former aggregate verification page.
// ignore_for_file: unused_element

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

/// Scenarios extracted from the former S17HrPayrollPackVerificationPage.
enum S17HrPayrollPackScenario {
  employeeProfile,
  employeeList,
  employmentContract,
  employeeAction,
  attendance,
  timesheet,
  overtime,
  leaveBalance,
  leaveRequest,
  payslip,
  payrollSheet,
  payrollSummary,
  allowances,
  deductions,
  loanAdvance,
  salaryCertificate,
  employmentCertificate,
  experienceCertificate,
  endOfService,
  finalSettlement,
}

/// Executes one focused S17 verification scenario.
class S17HrPayrollPackRunner {
  S17HrPayrollPackRunner({
    required GeniusPdfConfig baseConfig,
    required S17HrPayrollPackScenario scenario,
  }) : _baseConfig = baseConfig,
       _scenario = scenario;

  final GeniusPdfConfig _baseConfig;
  final S17HrPayrollPackScenario _scenario;
  final GeniusHrPrintableRole _role = GeniusHrPrintableRole.hr;
  bool _rtl = false;
  final bool _confidential = true;
  final bool _maskSensitive = true;
  final int _rowCount = 1;
  GeniusPdfConfig get _config => _baseConfig.copyWith(
    textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
  );

  GeniusHrPrintPolicy get _policy => GeniusHrPrintPolicy(
    role: _role,
    confidential: _confidential,
    maskedFields: _maskSensitive
        ? const {
            GeniusHrField.nationalId,
            GeniusHrField.passport,
            GeniusHrField.bankAccount,
            GeniusHrField.iban,
          }
        : const {},
  );

  String _label(S17HrPayrollPackScenario value) => switch (value) {
    S17HrPayrollPackScenario.employeeProfile => 'Employee Profile',
    S17HrPayrollPackScenario.employeeList => 'Employee List',
    S17HrPayrollPackScenario.employmentContract => 'Employment Contract/Form',
    S17HrPayrollPackScenario.employeeAction => 'Employee Action Form',
    S17HrPayrollPackScenario.attendance => 'Attendance Report',
    S17HrPayrollPackScenario.timesheet => 'Timesheet',
    S17HrPayrollPackScenario.overtime => 'Overtime Report',
    S17HrPayrollPackScenario.leaveBalance => 'Leave Balance',
    S17HrPayrollPackScenario.leaveRequest => 'Leave Request',
    S17HrPayrollPackScenario.payslip => 'Payslip',
    S17HrPayrollPackScenario.payrollSheet => 'Payroll Sheet',
    S17HrPayrollPackScenario.payrollSummary => 'Payroll Summary',
    S17HrPayrollPackScenario.allowances => 'Allowances Report',
    S17HrPayrollPackScenario.deductions => 'Deductions Report',
    S17HrPayrollPackScenario.loanAdvance => 'Loan / Advance',
    S17HrPayrollPackScenario.salaryCertificate => 'Salary Certificate',
    S17HrPayrollPackScenario.employmentCertificate => 'Employment Certificate',
    S17HrPayrollPackScenario.experienceCertificate => 'Experience Certificate',
    S17HrPayrollPackScenario.endOfService => 'End-of-Service',
    S17HrPayrollPackScenario.finalSettlement => 'Final Settlement',
  };

  String get _expected =>
      'Expected Result: ${_label(_scenario)} uses the real S17 public API in '
      '${_rtl ? 'RTL' : 'LTR'} with role ${_role.name}; '
      '${_maskSensitive ? 'sensitive IDs are masked' : 'masking is disabled'}'
      '${_confidential ? ', and a confidential watermark is present' : ''}. '
      'Arabic names remain RTL while Employee IDs/IBAN/bank identifiers stay '
      'structured. Payroll totals reconcile before rendering.';

  GeniusHrEmployee _employee(int index) => GeniusHrEmployee(
    employeeId: 'EMP-${(index + 1).toString().padLeft(5, '0')}',
    name: index == 0 ? 'Ahmed Abdulrahman Al-Mutairi' : 'Employee ${index + 1}',
    nameAr: index == 0 ? 'أحمد عبدالرحمن المطيري' : 'الموظف ${index + 1}',
    joinDate: DateTime(2018 + index % 5, 1, 1),
    department: 'Finance & Operations',
    departmentAr: 'المالية والعمليات',
    jobTitle: 'Senior ERP Specialist',
    jobTitleAr: 'أخصائي نظم موارد مؤسسية أول',
    nationalId: '10${(10000000 + index).toString()}',
    passport: 'P${1000000 + index}',
    phone: '+96650000${index.toString().padLeft(4, '0')}',
    email: 'employee$index@example.com',
    bankName: 'Genius Bank',
    bankAccount: '9876543210${index.toString().padLeft(6, '0')}',
    iban: 'SA0380000000608010${(100000 + index)}',
    address: 'Riyadh, Saudi Arabia',
    addressAr: 'الرياض، المملكة العربية السعودية',
    baseSalary: ErpMoney.fromAmount(
      10000 + index * 10,
      currency: ErpCurrency.sar,
    ),
    managerName: 'Manager 01',
    managerNameAr: 'المدير 01',
  );

  GeniusHrPayrollEntry _payroll(int index) {
    final longList = _rowCount > 1 ? 40 : 4;
    return GeniusHrPayrollEntry(
      employee: _employee(index),
      period: '2026-09',
      baseSalary: ErpMoney.fromAmount(
        10000 + index * 10,
        currency: ErpCurrency.sar,
      ),
      earnings: List.generate(
        longList,
        (line) => GeniusHrPayrollEarning(
          code: 'ALW-${line + 1}',
          label: line == 0
              ? 'Long allowance description for payroll wrapping verification'
              : 'Allowance ${line + 1}',
          labelAr: line == 0
              ? 'وصف بدل عربي طويل للتحقق من التفاف النص في كشف الراتب'
              : 'بدل ${line + 1}',
          amount: ErpMoney.fromAmount(100 + line, currency: ErpCurrency.sar),
        ),
      ),
      deductions: List.generate(
        longList,
        (line) => GeniusHrPayrollDeduction(
          code: 'DED-${line + 1}',
          label: line == 0
              ? 'Long deduction description for payroll wrapping verification'
              : 'Deduction ${line + 1}',
          labelAr: line == 0
              ? 'وصف استقطاع عربي طويل للتحقق من التفاف النص'
              : 'استقطاع ${line + 1}',
          amount: ErpMoney.fromAmount(10 + line, currency: ErpCurrency.sar),
          reference: 'REF-${line + 1}',
        ),
      ),
      daysWorked: 30,
      hoursWorked: 176,
      overtimeHours: 12.5,
      bankReference: 'BANK-PAY-${index + 1}',
    );
  }

  Future<Uint8List> generate() async {
    const service = GeniusHrPayrollService();
    final config = _config;
    final policy = _policy;
    final count = _rowCount;
    final employees = List.generate(count, _employee);
    final payroll = List.generate(count, _payroll);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case S17HrPayrollPackScenario.employeeProfile:
        document = GeniusEmployeeProfileDocument(
          config,
          report: service.employeeProfile(employees.first, policy: policy),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.employeeList:
        document = GeniusEmployeeListDocument(
          config,
          report: service.employeeList(employees, policy: policy),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.employmentContract:
        final employee = employees.first;
        document = GeniusEmploymentContractDocument(
          config,
          report: service.employmentContract(
            GeniusHrEmploymentContract(
              contractNumber: 'CTR-2026-001',
              employee: employee,
              startDate: employee.joinDate,
              probationEndDate: employee.joinDate.add(const Duration(days: 90)),
              workLocation: 'Riyadh HQ',
              workLocationAr: 'المقر الرئيسي - الرياض',
              hoursPerWeek: 40,
              terms:
                  'Long employment terms for wrapping and optional-field verification.',
              termsAr:
                  'شروط توظيف عربية طويلة للتحقق من التفاف النص والحقول الاختيارية.',
              signatory: 'HR Director',
              signatoryAr: 'مدير الموارد البشرية',
            ),
            policy: policy,
          ),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.employeeAction:
        document = GeniusEmployeeActionFormDocument(
          config,
          report: service.employeeActionForm(
            GeniusHrEmployeeAction(
              actionNumber: 'ACT-2026-001',
              employee: employees.first,
              effectiveDate: DateTime(2026, 10, 1),
              actionType: 'Promotion',
              actionTypeAr: 'ترقية',
              previousValue: 'ERP Specialist',
              newValue: 'Senior ERP Specialist',
              reason: 'Performance and expanded responsibilities',
              reasonAr: 'الأداء وتوسّع المسؤوليات',
              approvedBy: 'HR Director',
            ),
            policy: policy,
          ),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.attendance:
        document = GeniusAttendanceReportDocument(
          config,
          report: service.attendanceReport(
            List.generate(
              count,
              (index) => GeniusHrAttendanceEntry(
                employee: employees[index],
                date: DateTime(2026, 9, (index % 28) + 1),
                status: index % 7 == 0
                    ? GeniusHrAttendanceStatus.late
                    : GeniusHrAttendanceStatus.present,
                scheduledStart: DateTime(2026, 9, 4, 8),
                scheduledEnd: DateTime(2026, 9, 4, 17),
                checkIn: DateTime(2026, 9, 4, 8, index % 7 == 0 ? 18 : 0),
                checkOut: DateTime(2026, 9, 4, 17),
              ),
            ),
          ),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.timesheet:
        document = GeniusTimesheetDocument(
          config,
          report: service.timesheet(
            List.generate(
              count,
              (index) => GeniusHrTimesheetEntry(
                employee: employees[index],
                date: DateTime(2026, 9, (index % 28) + 1),
                hours: 7.5 + (index % 3) * 0.25,
                project: 'ERP-PROJ-${index % 5}',
                projectAr: 'مشروع ERP ${index % 5}',
                task: 'Implementation Task ${index + 1}',
                taskAr: 'مهمة تنفيذ ${index + 1}',
                billable: index.isEven,
              ),
            ),
          ),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.overtime:
        document = GeniusOvertimeReportDocument(
          config,
          report: service.overtimeReport(
            List.generate(
              count,
              (index) => GeniusHrOvertimeEntry(
                employee: employees[index],
                date: DateTime(2026, 9, (index % 28) + 1),
                hours: 2 + (index % 3) * 0.5,
                rateMultiplier: index.isEven ? 1.5 : 2,
                reason: 'Month-end support',
                reasonAr: 'دعم إقفال نهاية الشهر',
              ),
            ),
          ),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.leaveBalance:
        document = GeniusLeaveBalanceDocument(
          config,
          report: service.leaveBalance(
            List.generate(
              count,
              (index) => GeniusHrLeaveBalance(
                employee: employees[index],
                leaveType: 'Annual',
                leaveTypeAr: 'سنوية',
                entitledDays: 30,
                usedDays: 8 + index % 5,
                pendingDays: index % 2,
              ),
            ),
          ),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.leaveRequest:
        document = GeniusLeaveRequestDocument(
          config,
          report: service.leaveRequest(
            GeniusHrLeaveRequest(
              requestNumber: 'LEV-2026-001',
              employee: employees.first,
              leaveType: 'Annual',
              leaveTypeAr: 'سنوية',
              startDate: DateTime(2026, 10, 5),
              endDate: DateTime(2026, 10, 9),
              days: 5,
              status: GeniusHrLeaveStatus.approved,
              reason: 'Family leave',
              reasonAr: 'إجازة عائلية',
              approver: 'Manager 01',
            ),
          ),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.payslip:
        document = GeniusPayslipDocument(
          config,
          report: service.payslip(payroll.first, policy: policy),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.payrollSheet:
        document = GeniusPayrollSheetDocument(
          config,
          report: service.payrollSheet(payroll, policy: policy),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.payrollSummary:
        document = GeniusPayrollSummaryDocument(
          config,
          report: service.payrollSummary(payroll),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.allowances:
        document = GeniusAllowancesReportDocument(
          config,
          report: service.allowancesReport(payroll),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.deductions:
        document = GeniusDeductionsReportDocument(
          config,
          report: service.deductionsReport(payroll),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.loanAdvance:
        document = GeniusEmployeeLoanAdvanceReportDocument(
          config,
          report: service.loanAdvanceReport(
            List.generate(
              count,
              (index) => GeniusHrLoanAdvance(
                reference: 'LOAN-${index + 1}',
                employee: employees[index],
                originalAmount: ErpMoney.fromAmount(
                  5000,
                  currency: ErpCurrency.sar,
                ),
                repaidAmount: ErpMoney.fromAmount(
                  1500 + index,
                  currency: ErpCurrency.sar,
                ),
                description: 'Employee advance',
                descriptionAr: 'سلفة موظف',
              ),
            ),
            policy: policy,
          ),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.salaryCertificate:
      case S17HrPayrollPackScenario.employmentCertificate:
      case S17HrPayrollPackScenario.experienceCertificate:
        final certificate = GeniusHrCertificateData(
          certificateNumber: 'CERT-2026-001',
          employee: employees.first,
          issueDate: DateTime(2026, 9, 4),
          recipient: 'To whom it may concern',
          recipientAr: 'إلى من يهمه الأمر',
          body:
              'This certificate confirms the employee information shown above and is issued upon request.',
          bodyAr:
              'تشهد الشركة بصحة بيانات الموظف الموضحة أعلاه وقد صدرت هذه الشهادة بناءً على طلبه.',
        );
        if (_scenario == S17HrPayrollPackScenario.salaryCertificate) {
          document = GeniusSalaryCertificateDocument(
            config,
            report: service.salaryCertificate(
              certificate,
              salary: payroll.first.baseSalary,
              printPolicy: policy,
            ),
            printPolicy: policy,
          );
        } else if (_scenario ==
            S17HrPayrollPackScenario.employmentCertificate) {
          document = GeniusEmploymentCertificateDocument(
            config,
            report: service.employmentCertificate(
              certificate,
              printPolicy: policy,
            ),
            printPolicy: policy,
          );
        } else {
          document = GeniusExperienceCertificateDocument(
            config,
            report: service.experienceCertificate(
              certificate,
              printPolicy: policy,
            ),
            printPolicy: policy,
          );
        }
        break;
      case S17HrPayrollPackScenario.endOfService:
        final result = service.calculateEndOfService(
          employee: employees.first,
          serviceEndDate: DateTime(2026, 9, 30),
          monthlySalary: payroll.first.baseSalary,
        );
        document = GeniusEndOfServiceReportDocument(
          config,
          report: service.endOfServiceReport(result),
          printPolicy: policy,
        );
        break;
      case S17HrPayrollPackScenario.finalSettlement:
        final eos = service.calculateEndOfService(
          employee: employees.first,
          serviceEndDate: DateTime(2026, 9, 30),
          monthlySalary: payroll.first.baseSalary,
        );
        final settlement = service.calculateFinalSettlement(
          employee: employees.first,
          endDate: DateTime(2026, 9, 30),
          salaryDue: ErpMoney.fromAmount(5000, currency: ErpCurrency.sar),
          leaveEncashment: ErpMoney.fromAmount(1200, currency: ErpCurrency.sar),
          endOfService: eos.benefit,
          otherEarnings: ErpMoney.fromAmount(300, currency: ErpCurrency.sar),
          deductions: ErpMoney.fromAmount(2500, currency: ErpCurrency.sar),
        );
        document = GeniusFinalSettlementDocument(
          config,
          report: service.finalSettlementReport(settlement),
          printPolicy: policy,
        );
        break;
    }

    final bytes = Uint8List.fromList(document.generate());
    document.dispose();
    return bytes;
  }
}

Future<Uint8List> buildS17EmployeeProfileVerificationPdf(
  GeniusPdfConfig config,
) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.employeeProfile,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17EmployeeListVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.employeeList,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17EmploymentContractVerificationPdf(
  GeniusPdfConfig config,
) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.employmentContract,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17EmployeeActionVerificationPdf(
  GeniusPdfConfig config,
) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.employeeAction,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17AttendanceVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.attendance,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17TimesheetVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.timesheet,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17OvertimeVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.overtime,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17LeaveBalanceVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.leaveBalance,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17LeaveRequestVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.leaveRequest,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17PayslipVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.payslip,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17PayrollSheetVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.payrollSheet,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17PayrollSummaryVerificationPdf(
  GeniusPdfConfig config,
) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.payrollSummary,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17AllowancesVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.allowances,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17DeductionsVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.deductions,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17LoanAdvanceVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.loanAdvance,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17SalaryCertificateVerificationPdf(
  GeniusPdfConfig config,
) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.salaryCertificate,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17EmploymentCertificateVerificationPdf(
  GeniusPdfConfig config,
) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.employmentCertificate,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17ExperienceCertificateVerificationPdf(
  GeniusPdfConfig config,
) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.experienceCertificate,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17EndOfServiceVerificationPdf(GeniusPdfConfig config) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.endOfService,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}

Future<Uint8List> buildS17FinalSettlementVerificationPdf(
  GeniusPdfConfig config,
) {
  final runner = S17HrPayrollPackRunner(
    baseConfig: config,
    scenario: S17HrPayrollPackScenario.finalSettlement,
  );
  runner._rtl = config.textDirection == TextDirection.rtl;
  return runner.generate();
}
