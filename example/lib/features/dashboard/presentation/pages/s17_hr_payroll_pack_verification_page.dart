
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

import 'package:genius_pdf_example/shared/presentation/widgets/create_save_open_pdf_button.dart';
enum _S17Scenario {
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

class S17HrPayrollPackVerificationPage extends StatefulWidget {
  const S17HrPayrollPackVerificationPage({super.key});

  @override
  State<S17HrPayrollPackVerificationPage> createState() =>
      _S17HrPayrollPackVerificationPageState();
}

class _S17HrPayrollPackVerificationPageState
    extends State<S17HrPayrollPackVerificationPage> {
  _S17Scenario _scenario = _S17Scenario.payslip;
  GeniusHrPrintableRole _role = GeniusHrPrintableRole.hr;
  bool _rtl = false;
  bool _confidential = true;
  bool _maskSensitive = true;
  int _rowCount = 1;
  late Future<Uint8List> _pdf;

  @override
  void initState() {
    super.initState();
    _pdf = _generate();
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
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

  String _label(_S17Scenario value) => switch (value) {
        _S17Scenario.employeeProfile => 'Employee Profile',
        _S17Scenario.employeeList => 'Employee List',
        _S17Scenario.employmentContract => 'Employment Contract/Form',
        _S17Scenario.employeeAction => 'Employee Action Form',
        _S17Scenario.attendance => 'Attendance Report',
        _S17Scenario.timesheet => 'Timesheet',
        _S17Scenario.overtime => 'Overtime Report',
        _S17Scenario.leaveBalance => 'Leave Balance',
        _S17Scenario.leaveRequest => 'Leave Request',
        _S17Scenario.payslip => 'Payslip',
        _S17Scenario.payrollSheet => 'Payroll Sheet',
        _S17Scenario.payrollSummary => 'Payroll Summary',
        _S17Scenario.allowances => 'Allowances Report',
        _S17Scenario.deductions => 'Deductions Report',
        _S17Scenario.loanAdvance => 'Loan / Advance',
        _S17Scenario.salaryCertificate => 'Salary Certificate',
        _S17Scenario.employmentCertificate => 'Employment Certificate',
        _S17Scenario.experienceCertificate => 'Experience Certificate',
        _S17Scenario.endOfService => 'End-of-Service',
        _S17Scenario.finalSettlement => 'Final Settlement',
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
        name: index == 0
            ? 'Ahmed Abdulrahman Al-Mutairi'
            : 'Employee ${index + 1}',
        nameAr: index == 0
            ? 'أحمد عبدالرحمن المطيري'
            : 'الموظف ${index + 1}',
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
          amount: ErpMoney.fromAmount(
            100 + line,
            currency: ErpCurrency.sar,
          ),
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
          amount: ErpMoney.fromAmount(
            10 + line,
            currency: ErpCurrency.sar,
          ),
          reference: 'REF-${line + 1}',
        ),
      ),
      daysWorked: 30,
      hoursWorked: 176,
      overtimeHours: 12.5,
      bankReference: 'BANK-PAY-${index + 1}',
    );
  }

  Future<Uint8List> _generate() async {
    const service = GeniusHrPayrollService();
    final config = _config;
    final policy = _policy;
    final count = _rowCount;
    final employees = List.generate(count, _employee);
    final payroll = List.generate(count, _payroll);
    late final GeniusPdfDocumentBuilder document;

    switch (_scenario) {
      case _S17Scenario.employeeProfile:
        document = GeniusEmployeeProfileDocument(
          config,
          report: service.employeeProfile(
            employees.first,
            policy: policy,
          ),
          printPolicy: policy,
        );
        break;
      case _S17Scenario.employeeList:
        document = GeniusEmployeeListDocument(
          config,
          report: service.employeeList(
            employees,
            policy: policy,
          ),
          printPolicy: policy,
        );
        break;
      case _S17Scenario.employmentContract:
        final employee = employees.first;
        document = GeniusEmploymentContractDocument(
          config,
          report: service.employmentContract(
            GeniusHrEmploymentContract(
              contractNumber: 'CTR-2026-001',
              employee: employee,
              startDate: employee.joinDate,
              probationEndDate: employee.joinDate.add(
                const Duration(days: 90),
              ),
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
      case _S17Scenario.employeeAction:
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
      case _S17Scenario.attendance:
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
                checkIn: DateTime(
                  2026,
                  9,
                  4,
                  8,
                  index % 7 == 0 ? 18 : 0,
                ),
                checkOut: DateTime(2026, 9, 4, 17),
              ),
            ),
          ),
          printPolicy: policy,
        );
        break;
      case _S17Scenario.timesheet:
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
      case _S17Scenario.overtime:
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
      case _S17Scenario.leaveBalance:
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
      case _S17Scenario.leaveRequest:
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
      case _S17Scenario.payslip:
        document = GeniusPayslipDocument(
          config,
          report: service.payslip(
            payroll.first,
            policy: policy,
          ),
          printPolicy: policy,
        );
        break;
      case _S17Scenario.payrollSheet:
        document = GeniusPayrollSheetDocument(
          config,
          report: service.payrollSheet(
            payroll,
            policy: policy,
          ),
          printPolicy: policy,
        );
        break;
      case _S17Scenario.payrollSummary:
        document = GeniusPayrollSummaryDocument(
          config,
          report: service.payrollSummary(payroll),
          printPolicy: policy,
        );
        break;
      case _S17Scenario.allowances:
        document = GeniusAllowancesReportDocument(
          config,
          report: service.allowancesReport(payroll),
          printPolicy: policy,
        );
        break;
      case _S17Scenario.deductions:
        document = GeniusDeductionsReportDocument(
          config,
          report: service.deductionsReport(payroll),
          printPolicy: policy,
        );
        break;
      case _S17Scenario.loanAdvance:
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
      case _S17Scenario.salaryCertificate:
      case _S17Scenario.employmentCertificate:
      case _S17Scenario.experienceCertificate:
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
        if (_scenario == _S17Scenario.salaryCertificate) {
          document = GeniusSalaryCertificateDocument(
            config,
            report: service.salaryCertificate(
              certificate,
              salary: payroll.first.baseSalary,
              printPolicy: policy,
            ),
            printPolicy: policy,
          );
        } else if (_scenario == _S17Scenario.employmentCertificate) {
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
      case _S17Scenario.endOfService:
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
      case _S17Scenario.finalSettlement:
        final eos = service.calculateEndOfService(
          employee: employees.first,
          serviceEndDate: DateTime(2026, 9, 30),
          monthlySalary: payroll.first.baseSalary,
        );
        final settlement = service.calculateFinalSettlement(
          employee: employees.first,
          endDate: DateTime(2026, 9, 30),
          salaryDue: ErpMoney.fromAmount(
            5000,
            currency: ErpCurrency.sar,
          ),
          leaveEncashment: ErpMoney.fromAmount(
            1200,
            currency: ErpCurrency.sar,
          ),
          endOfService: eos.benefit,
          otherEarnings: ErpMoney.fromAmount(
            300,
            currency: ErpCurrency.sar,
          ),
          deductions: ErpMoney.fromAmount(
            2500,
            currency: ErpCurrency.sar,
          ),
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

  void _refresh() {
    setState(() {
      _pdf = _generate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Sprint S17 — HR & Payroll Pack',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SizedBox(
                        width: 290,
                        child: DropdownButtonFormField<_S17Scenario>(
                          initialValue: _scenario,
                          decoration: const InputDecoration(
                            labelText: 'Scenario',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in _S17Scenario.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(_label(value)),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _scenario = value;
                            _refresh();
                          },
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: DropdownButtonFormField<GeniusHrPrintableRole>(
                          initialValue: _role,
                          decoration: const InputDecoration(
                            labelText: 'Printable role',
                            border: OutlineInputBorder(),
                          ),
                          items: [
                            for (final value in GeniusHrPrintableRole.values)
                              DropdownMenuItem(
                                value: value,
                                child: Text(value.name),
                              ),
                          ],
                          onChanged: (value) {
                            if (value == null) return;
                            _role = value;
                            _refresh();
                          },
                        ),
                      ),
                      SegmentedButton<int>(
                        segments: const [
                          ButtonSegment(value: 1, label: Text('1')),
                          ButtonSegment(value: 25, label: Text('25')),
                          ButtonSegment(value: 100, label: Text('100')),
                        ],
                        selected: {_rowCount},
                        onSelectionChanged: (value) {
                          _rowCount = value.first;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('RTL'),
                        selected: _rtl,
                        onSelected: (value) {
                          _rtl = value;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('Mask sensitive'),
                        selected: _maskSensitive,
                        onSelected: (value) {
                          _maskSensitive = value;
                          _refresh();
                        },
                      ),
                      FilterChip(
                        label: const Text('Confidential'),
                        selected: _confidential,
                        onSelected: (value) {
                          _confidential = value;
                          _refresh();
                        },
                      ),
                      FilledButton.icon(
                        onPressed: _refresh,
                        icon: const Icon(Icons.refresh_rounded),
                        label: const Text('Regenerate PDF'),
                      ),
                      CreateSaveOpenPdfButton(
                        onCreate: _generate,
                        fileName: 's17_hr_payroll_pack.pdf',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(_expected),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: FutureBuilder<Uint8List>(
                future: _pdf,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(
                        'Generation failed:\n${snapshot.error}',
                      ),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return GeniusPdfPreviewWidget(
                    pdfData: snapshot.data!,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
