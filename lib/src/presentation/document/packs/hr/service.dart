
import '../../../../domain/erp/erp.dart';
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';
import 'models.dart';
import 'privacy.dart';

/// Deterministic HR/payroll preparation service for Sprint S17.
///
/// Rendering classes consume only prepared report/certificate data. Payroll,
/// end-of-service and final-settlement arithmetic is intentionally kept here.
class GeniusHrPayrollService {
  const GeniusHrPayrollService();

  GeniusErpPackReportData employeeProfile(
    GeniusHrEmployee employee, {
    GeniusHrPrintPolicy policy = const GeniusHrPrintPolicy(),
  }) {
    final protectedEmployeeId = policy.protect(
      GeniusHrField.employeeId,
      employee.employeeId,
    );

    final fields = <GeniusErpDetailField>[
      if (protectedEmployeeId != null)
        _field(
          'Employee ID',
          'رقم الموظف',
          protectedEmployeeId,
        ),
      _field(
        'Name',
        'الاسم',
        employee.name,
        valueAr: employee.nameAr,
      ),
      if (employee.jobTitle != null)
        _field(
          'Job Title',
          'المسمى الوظيفي',
          employee.jobTitle!,
          valueAr: employee.jobTitleAr,
        ),
      if (employee.department != null)
        _field(
          'Department',
          'القسم',
          employee.department!,
          valueAr: employee.departmentAr,
        ),
      _field(
        'Join Date',
        'تاريخ الالتحاق',
        _date(employee.joinDate),
      ),
      _field(
        'Status',
        'الحالة',
        employee.status.name,
      ),
      if (policy.isVisible(GeniusHrField.nationalId) &&
          employee.nationalId != null)
        _field(
          'National ID',
          'الهوية الوطنية',
          policy.protect(
                GeniusHrField.nationalId,
                employee.nationalId,
              ) ??
              '',
        ),
      if (policy.isVisible(GeniusHrField.passport) &&
          employee.passport != null)
        _field(
          'Passport',
          'جواز السفر',
          policy.protect(
                GeniusHrField.passport,
                employee.passport,
              ) ??
              '',
        ),
      if (policy.isVisible(GeniusHrField.phone) &&
          employee.phone != null)
        _field(
          'Phone',
          'الهاتف',
          policy.protect(
                GeniusHrField.phone,
                employee.phone,
              ) ??
              '',
        ),
      if (policy.isVisible(GeniusHrField.email) &&
          employee.email != null)
        _field(
          'Email',
          'البريد الإلكتروني',
          policy.protect(
                GeniusHrField.email,
                employee.email,
              ) ??
              '',
        ),
      if (policy.isVisible(GeniusHrField.iban) &&
          employee.iban != null)
        _field(
          'IBAN',
          'IBAN',
          policy.protect(
                GeniusHrField.iban,
                employee.iban,
              ) ??
              '',
        ),
      if (policy.isVisible(GeniusHrField.baseSalary) &&
          employee.baseSalary != null)
        _field(
          'Base Salary',
          'الراتب الأساسي',
          _money(employee.baseSalary!),
        ),
    ];

    final report = GeniusErpPackReportData(
      title: 'Employee Profile',
      titleAr: 'ملف الموظف',
      subtitle: employee.employeeId,
      subtitleAr: employee.employeeId,
      details: fields,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'label',
          title: 'Profile',
          titleAr: 'الملف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'value',
          title: 'Value',
          titleAr: 'القيمة',
          flexFactor: 3,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'label': 'Manager',
            'value': GeniusErpPackLocalizedValue(
              value: employee.managerName ?? '',
              valueAr: employee.managerNameAr,
            ),
          },
        ),
      ],
    );

    return policy.applyVariant(report);
  }

  GeniusErpPackReportData employeeList(
    List<GeniusHrEmployee> employees, {
    GeniusHrPrintPolicy policy = const GeniusHrPrintPolicy(),
  }) {
    final showNationalId =
        policy.isVisible(GeniusHrField.nationalId);
    final showSalary = policy.isVisible(GeniusHrField.baseSalary);

    final report = GeniusErpPackReportData(
      title: 'Employee List',
      titleAr: 'قائمة الموظفين',
      columns: [
        const GeniusErpPackReportColumn(
          id: 'id',
          title: 'Employee ID',
          titleAr: 'رقم الموظف',
        ),
        const GeniusErpPackReportColumn(
          id: 'name',
          title: 'Name',
          titleAr: 'الاسم',
          flexFactor: 2,
        ),
        const GeniusErpPackReportColumn(
          id: 'department',
          title: 'Department',
          titleAr: 'القسم',
        ),
        const GeniusErpPackReportColumn(
          id: 'job',
          title: 'Job Title',
          titleAr: 'المسمى',
        ),
        if (showNationalId)
          const GeniusErpPackReportColumn(
            id: 'nationalId',
            title: 'National ID',
            titleAr: 'الهوية',
          ),
        if (showSalary)
          const GeniusErpPackReportColumn(
            id: 'salary',
            title: 'Base Salary',
            titleAr: 'الراتب الأساسي',
          ),
        const GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
      ],
      rows: [
        for (final employee in employees)
          GeniusErpPackReportRow(
            cells: {
              'id': policy.protect(
                    GeniusHrField.employeeId,
                    employee.employeeId,
                  ) ??
                  '',
              'name': GeniusErpPackLocalizedValue(
                value: employee.name,
                valueAr: employee.nameAr,
              ),
              'department': GeniusErpPackLocalizedValue(
                value: employee.department ?? '',
                valueAr: employee.departmentAr,
              ),
              'job': GeniusErpPackLocalizedValue(
                value: employee.jobTitle ?? '',
                valueAr: employee.jobTitleAr,
              ),
              if (showNationalId)
                'nationalId': policy.protect(
                      GeniusHrField.nationalId,
                      employee.nationalId,
                    ) ??
                    '',
              if (showSalary)
                'salary': employee.baseSalary == null
                    ? ''
                    : _money(employee.baseSalary!),
              'status': employee.status.name,
            },
          ),
      ],
    );

    return policy.applyVariant(report);
  }

  GeniusErpPackReportData employmentContract(
    GeniusHrEmploymentContract contract, {
    GeniusHrPrintPolicy policy = const GeniusHrPrintPolicy(),
  }) {
    final report = GeniusErpPackReportData(
      title: 'Employment Contract / Form',
      titleAr: 'عقد / نموذج توظيف',
      subtitle: contract.contractNumber,
      subtitleAr: contract.contractNumber,
      details: [
        _field(
          'Employee',
          'الموظف',
          contract.employee.name,
          valueAr: contract.employee.nameAr,
        ),
        _field(
          'Employee ID',
          'رقم الموظف',
          policy.protect(
                GeniusHrField.employeeId,
                contract.employee.employeeId,
              ) ??
              '',
        ),
        _field(
          'Start Date',
          'تاريخ البداية',
          _date(contract.startDate),
        ),
        if (contract.endDate != null)
          _field(
            'End Date',
            'تاريخ النهاية',
            _date(contract.endDate!),
          ),
        if (contract.probationEndDate != null)
          _field(
            'Probation End',
            'نهاية التجربة',
            _date(contract.probationEndDate!),
          ),
        if (contract.hoursPerWeek != null)
          _field(
            'Hours / Week',
            'ساعات / أسبوع',
            contract.hoursPerWeek!.toStringAsFixed(2),
          ),
        if (contract.workLocation != null)
          _field(
            'Work Location',
            'موقع العمل',
            contract.workLocation!,
            valueAr: contract.workLocationAr,
          ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'terms',
          title: 'Terms',
          titleAr: 'الشروط',
          flexFactor: 4,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'terms': GeniusErpPackLocalizedValue(
              value: contract.terms ?? '',
              valueAr: contract.termsAr,
            ),
          },
        ),
      ],
      notes: contract.signatory == null
          ? null
          : 'Authorized signatory: ${contract.signatory}',
      notesAr: contract.signatoryAr == null
          ? null
          : 'المخول بالتوقيع: ${contract.signatoryAr}',
    );
    return policy.applyVariant(report);
  }

  GeniusErpPackReportData employeeActionForm(
    GeniusHrEmployeeAction action, {
    GeniusHrPrintPolicy policy = const GeniusHrPrintPolicy(),
  }) {
    final report = GeniusErpPackReportData(
      title: 'Employee Action Form',
      titleAr: 'نموذج إجراء موظف',
      subtitle: action.actionNumber,
      subtitleAr: action.actionNumber,
      details: [
        _field(
          'Employee',
          'الموظف',
          action.employee.name,
          valueAr: action.employee.nameAr,
        ),
        _field(
          'Employee ID',
          'رقم الموظف',
          policy.protect(
                GeniusHrField.employeeId,
                action.employee.employeeId,
              ) ??
              '',
        ),
        _field(
          'Effective Date',
          'تاريخ السريان',
          _date(action.effectiveDate),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'action',
          title: 'Action',
          titleAr: 'الإجراء',
        ),
        GeniusErpPackReportColumn(
          id: 'previous',
          title: 'Previous',
          titleAr: 'السابق',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'new',
          title: 'New',
          titleAr: 'الجديد',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'reason',
          title: 'Reason',
          titleAr: 'السبب',
          flexFactor: 2,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'action': GeniusErpPackLocalizedValue(
              value: action.actionType,
              valueAr: action.actionTypeAr,
            ),
            'previous': action.previousValue ?? '',
            'new': action.newValue ?? '',
            'reason': GeniusErpPackLocalizedValue(
              value: action.reason ?? '',
              valueAr: action.reasonAr,
            ),
          },
        ),
      ],
      notes: action.approvedBy == null
          ? null
          : 'Approved by: ${action.approvedBy}',
    );
    return policy.applyVariant(report);
  }

  GeniusErpPackReportData attendanceReport(
    List<GeniusHrAttendanceEntry> entries,
  ) {
    return GeniusErpPackReportData(
      title: 'Attendance Report',
      titleAr: 'تقرير الحضور',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'employee',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
        ),
        GeniusErpPackReportColumn(
          id: 'checkIn',
          title: 'Check In',
          titleAr: 'الحضور',
        ),
        GeniusErpPackReportColumn(
          id: 'checkOut',
          title: 'Check Out',
          titleAr: 'الانصراف',
        ),
        GeniusErpPackReportColumn(
          id: 'worked',
          title: 'Worked Hours',
          titleAr: 'ساعات العمل',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'late',
          title: 'Late Minutes',
          titleAr: 'دقائق التأخير',
          kind: GeniusErpPackReportColumnKind.number,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'employee': GeniusErpPackLocalizedValue(
                value: entry.employee.name,
                valueAr: entry.employee.nameAr,
              ),
              'status': entry.status.name,
              'checkIn': _time(entry.checkIn),
              'checkOut': _time(entry.checkOut),
              'worked':
                  entry.workedDuration.inMinutes / 60.0,
              'late': entry.lateDuration.inMinutes,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData timesheet(
    List<GeniusHrTimesheetEntry> entries,
  ) {
    final total = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.hours,
    );

    return GeniusErpPackReportData(
      title: 'Timesheet',
      titleAr: 'سجل الساعات',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'employee',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'project',
          title: 'Project',
          titleAr: 'المشروع',
        ),
        GeniusErpPackReportColumn(
          id: 'task',
          title: 'Task',
          titleAr: 'المهمة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'hours',
          title: 'Hours',
          titleAr: 'الساعات',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'billable',
          title: 'Billable',
          titleAr: 'قابل للفوترة',
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'employee': GeniusErpPackLocalizedValue(
                value: entry.employee.name,
                valueAr: entry.employee.nameAr,
              ),
              'project': GeniusErpPackLocalizedValue(
                value: entry.project ?? '',
                valueAr: entry.projectAr,
              ),
              'task': GeniusErpPackLocalizedValue(
                value: entry.task ?? '',
                valueAr: entry.taskAr,
              ),
              'hours': entry.hours,
              'billable': entry.billable ? 'Yes' : 'No',
            },
          ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'date': '',
            'employee': 'Total',
            'project': '',
            'task': '',
            'hours': total,
            'billable': '',
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData overtimeReport(
    List<GeniusHrOvertimeEntry> entries,
  ) {
    final hours = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.hours,
    );
    final weighted = entries.fold<double>(
      0,
      (sum, entry) => sum + entry.hours * entry.rateMultiplier,
    );

    return GeniusErpPackReportData(
      title: 'Overtime Report',
      titleAr: 'تقرير العمل الإضافي',
      details: [
        _field(
          'Total Hours',
          'إجمالي الساعات',
          hours.toStringAsFixed(2),
        ),
        _field(
          'Weighted Hours',
          'الساعات الموزونة',
          weighted.toStringAsFixed(2),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'date',
          title: 'Date',
          titleAr: 'التاريخ',
        ),
        GeniusErpPackReportColumn(
          id: 'employee',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'hours',
          title: 'Hours',
          titleAr: 'الساعات',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'rate',
          title: 'Rate ×',
          titleAr: 'المعامل ×',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'reason',
          title: 'Reason',
          titleAr: 'السبب',
          flexFactor: 2,
        ),
      ],
      rows: [
        for (final entry in entries)
          GeniusErpPackReportRow(
            cells: {
              'date': _date(entry.date),
              'employee': GeniusErpPackLocalizedValue(
                value: entry.employee.name,
                valueAr: entry.employee.nameAr,
              ),
              'hours': entry.hours,
              'rate': entry.rateMultiplier,
              'reason': GeniusErpPackLocalizedValue(
                value: entry.reason ?? '',
                valueAr: entry.reasonAr,
              ),
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData leaveBalance(
    List<GeniusHrLeaveBalance> balances,
  ) {
    return GeniusErpPackReportData(
      title: 'Leave Balance',
      titleAr: 'رصيد الإجازات',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'employee',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'type',
          title: 'Leave Type',
          titleAr: 'نوع الإجازة',
        ),
        GeniusErpPackReportColumn(
          id: 'entitled',
          title: 'Entitled',
          titleAr: 'المستحق',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'used',
          title: 'Used',
          titleAr: 'المستخدم',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'pending',
          title: 'Pending',
          titleAr: 'معلق',
          kind: GeniusErpPackReportColumnKind.number,
        ),
        GeniusErpPackReportColumn(
          id: 'available',
          title: 'Available',
          titleAr: 'المتاح',
          kind: GeniusErpPackReportColumnKind.number,
        ),
      ],
      rows: [
        for (final balance in balances)
          GeniusErpPackReportRow(
            cells: {
              'employee': GeniusErpPackLocalizedValue(
                value: balance.employee.name,
                valueAr: balance.employee.nameAr,
              ),
              'type': GeniusErpPackLocalizedValue(
                value: balance.leaveType,
                valueAr: balance.leaveTypeAr,
              ),
              'entitled': balance.entitledDays,
              'used': balance.usedDays,
              'pending': balance.pendingDays,
              'available': balance.availableDays,
            },
          ),
      ],
    );
  }

  GeniusErpPackReportData leaveRequest(
    GeniusHrLeaveRequest request,
  ) {
    return GeniusErpPackReportData(
      title: 'Leave Request',
      titleAr: 'طلب إجازة',
      subtitle: request.requestNumber,
      subtitleAr: request.requestNumber,
      details: [
        _field(
          'Employee',
          'الموظف',
          request.employee.name,
          valueAr: request.employee.nameAr,
        ),
        _field(
          'Leave Type',
          'نوع الإجازة',
          request.leaveType,
          valueAr: request.leaveTypeAr,
        ),
        _field(
          'Start',
          'البداية',
          _date(request.startDate),
        ),
        _field(
          'End',
          'النهاية',
          _date(request.endDate),
        ),
        _field(
          'Days',
          'الأيام',
          request.days.toStringAsFixed(2),
        ),
        _field(
          'Status',
          'الحالة',
          request.status.name,
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'reason',
          title: 'Reason',
          titleAr: 'السبب',
          flexFactor: 4,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'reason': GeniusErpPackLocalizedValue(
              value: request.reason ?? '',
              valueAr: request.reasonAr,
            ),
          },
        ),
      ],
      notes: request.approver == null
          ? null
          : 'Approver: ${request.approver}',
    );
  }

  GeniusHrPayrollResult calculatePayroll(
    GeniusHrPayrollEntry entry,
  ) {
    final currency = entry.baseSalary.currency;
    var earnings = ErpMoney.zero(currency);
    var deductions = ErpMoney.zero(currency);

    for (final value in entry.earnings) {
      _sameCurrency(currency, value.amount);
      earnings = earnings + value.amount;
    }
    for (final value in entry.deductions) {
      _sameCurrency(currency, value.amount);
      deductions = deductions + value.amount;
    }

    final gross = entry.baseSalary + earnings;
    final net = gross - deductions;

    return GeniusHrPayrollResult(
      source: entry,
      gross: gross,
      totalEarnings: earnings,
      totalDeductions: deductions,
      net: net,
    );
  }

  GeniusErpPackReportData payslip(
    GeniusHrPayrollEntry entry, {
    GeniusHrPrintPolicy policy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.employee,
    ),
  }) {
    final result = calculatePayroll(entry);
    final showAllowances =
        policy.isVisible(GeniusHrField.allowances);
    final showDeductions =
        policy.isVisible(GeniusHrField.deductions);

    final rows = <GeniusErpPackReportRow>[
      GeniusErpPackReportRow(
        cells: {
          'type': 'Earning',
          'code': 'BASE',
          'description': const GeniusErpPackLocalizedValue(
            value: 'Base Salary',
            valueAr: 'الراتب الأساسي',
          ),
          'amount': entry.baseSalary.toDouble(),
        },
      ),
      if (showAllowances)
        for (final earning in entry.earnings)
          GeniusErpPackReportRow(
            cells: {
              'type': 'Earning',
              'code': earning.code,
              'description': GeniusErpPackLocalizedValue(
                value: earning.label,
                valueAr: earning.labelAr,
              ),
              'amount': earning.amount.toDouble(),
            },
          ),
      if (showDeductions)
        for (final deduction in entry.deductions)
          GeniusErpPackReportRow(
            cells: {
              'type': 'Deduction',
              'code': deduction.code,
              'description': GeniusErpPackLocalizedValue(
                value: deduction.label,
                valueAr: deduction.labelAr,
              ),
              'amount': -deduction.amount.toDouble(),
            },
          ),
      GeniusErpPackReportRow(
        isTotal: true,
        cells: {
          'type': 'Net',
          'code': '',
          'description': const GeniusErpPackLocalizedValue(
            value: 'Net Pay',
            valueAr: 'صافي الراتب',
          ),
          'amount': result.net.toDouble(),
        },
      ),
    ];

    final report = GeniusErpPackReportData(
      title: 'Payslip',
      titleAr: 'قسيمة الراتب',
      subtitle: entry.period,
      subtitleAr: entry.period,
      details: [
        _field(
          'Employee',
          'الموظف',
          entry.employee.name,
          valueAr: entry.employee.nameAr,
        ),
        _field(
          'Employee ID',
          'رقم الموظف',
          policy.protect(
                GeniusHrField.employeeId,
                entry.employee.employeeId,
              ) ??
              '',
        ),
        if (policy.isVisible(GeniusHrField.iban) &&
            entry.employee.iban != null)
          _field(
            'IBAN',
            'IBAN',
            policy.protect(
                  GeniusHrField.iban,
                  entry.employee.iban,
                ) ??
                '',
          ),
        _field(
          'Gross',
          'الإجمالي',
          _money(result.gross),
        ),
        _field(
          'Deductions',
          'الاستقطاعات',
          _money(result.totalDeductions),
        ),
        _field(
          'Net',
          'الصافي',
          _money(result.net),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'type',
          title: 'Type',
          titleAr: 'النوع',
        ),
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الرمز',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'البيان',
          flexFactor: 3,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: rows,
    );

    return policy.applyVariant(report);
  }

  GeniusErpPackReportData payrollSheet(
    List<GeniusHrPayrollEntry> entries, {
    GeniusHrPrintPolicy policy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) {
    final results = entries.map(calculatePayroll).toList();
    final report = GeniusErpPackReportData(
      title: 'Payroll Sheet',
      titleAr: 'كشف الرواتب',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'id',
          title: 'Employee ID',
          titleAr: 'رقم الموظف',
        ),
        GeniusErpPackReportColumn(
          id: 'name',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'period',
          title: 'Period',
          titleAr: 'الفترة',
        ),
        GeniusErpPackReportColumn(
          id: 'base',
          title: 'Base',
          titleAr: 'الأساسي',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'earnings',
          title: 'Allowances',
          titleAr: 'البدلات',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'deductions',
          title: 'Deductions',
          titleAr: 'الاستقطاعات',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'net',
          title: 'Net',
          titleAr: 'الصافي',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final result in results)
          GeniusErpPackReportRow(
            cells: {
              'id': policy.protect(
                    GeniusHrField.employeeId,
                    result.source.employee.employeeId,
                  ) ??
                  '',
              'name': GeniusErpPackLocalizedValue(
                value: result.source.employee.name,
                valueAr: result.source.employee.nameAr,
              ),
              'period': result.source.period,
              'base': result.source.baseSalary.toDouble(),
              'earnings': result.totalEarnings.toDouble(),
              'deductions': result.totalDeductions.toDouble(),
              'net': result.net.toDouble(),
            },
          ),
      ],
    );

    return policy.applyVariant(report);
  }

  GeniusErpPackReportData payrollSummary(
    List<GeniusHrPayrollEntry> entries,
  ) {
    if (entries.isEmpty) {
      return _empty(
        'Payroll Summary',
        'ملخص الرواتب',
      );
    }

    final results = entries.map(calculatePayroll).toList();
    final currency = results.first.source.baseSalary.currency;
    var base = ErpMoney.zero(currency);
    var earnings = ErpMoney.zero(currency);
    var deductions = ErpMoney.zero(currency);
    var net = ErpMoney.zero(currency);

    for (final result in results) {
      _sameCurrency(currency, result.source.baseSalary);
      base = base + result.source.baseSalary;
      earnings = earnings + result.totalEarnings;
      deductions = deductions + result.totalDeductions;
      net = net + result.net;
    }

    final reconciled = base + earnings - deductions;

    return GeniusErpPackReportData(
      title: 'Payroll Summary',
      titleAr: 'ملخص الرواتب',
      details: [
        _field('Employees', 'الموظفون', results.length.toString()),
        _field('Base', 'الأساسي', _money(base)),
        _field('Allowances', 'البدلات', _money(earnings)),
        _field('Deductions', 'الاستقطاعات', _money(deductions)),
        _field('Net', 'الصافي', _money(net)),
        _field(
          'Reconciliation',
          'المطابقة',
          reconciled.toDouble() == net.toDouble() ? 'Balanced' : 'Mismatch',
          valueAr: reconciled.toDouble() == net.toDouble() ? 'متطابق' : 'غير متطابق',
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'metric',
          title: 'Metric',
          titleAr: 'البند',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {'metric': 'Base Salary', 'amount': base.toDouble()},
        ),
        GeniusErpPackReportRow(
          cells: {'metric': 'Allowances', 'amount': earnings.toDouble()},
        ),
        GeniusErpPackReportRow(
          cells: {
            'metric': 'Deductions',
            'amount': deductions.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {'metric': 'Net Payroll', 'amount': net.toDouble()},
        ),
      ],
    );
  }

  GeniusErpPackReportData allowancesReport(
    List<GeniusHrPayrollEntry> entries,
  ) =>
      _payrollLineReport(
        entries,
        earnings: true,
        title: 'Allowances Report',
        titleAr: 'تقرير البدلات',
      );

  GeniusErpPackReportData deductionsReport(
    List<GeniusHrPayrollEntry> entries,
  ) =>
      _payrollLineReport(
        entries,
        earnings: false,
        title: 'Deductions Report',
        titleAr: 'تقرير الاستقطاعات',
      );

  GeniusErpPackReportData loanAdvanceReport(
    List<GeniusHrLoanAdvance> values, {
    GeniusHrPrintPolicy policy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) {
    final report = GeniusErpPackReportData(
      title: 'Employee Loan / Advance Report',
      titleAr: 'تقرير سلف / قروض الموظفين',
      columns: const [
        GeniusErpPackReportColumn(
          id: 'reference',
          title: 'Reference',
          titleAr: 'المرجع',
        ),
        GeniusErpPackReportColumn(
          id: 'employee',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'original',
          title: 'Original',
          titleAr: 'الأصل',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'repaid',
          title: 'Repaid',
          titleAr: 'المسدد',
          kind: GeniusErpPackReportColumnKind.money,
        ),
        GeniusErpPackReportColumn(
          id: 'outstanding',
          title: 'Outstanding',
          titleAr: 'المتبقي',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final value in values)
          GeniusErpPackReportRow(
            cells: {
              'reference': value.reference,
              'employee': GeniusErpPackLocalizedValue(
                value: value.employee.name,
                valueAr: value.employee.nameAr,
              ),
              'original': value.originalAmount.toDouble(),
              'repaid': value.repaidAmount.toDouble(),
              'outstanding': value.outstanding.toDouble(),
            },
          ),
      ],
    );
    return policy.applyVariant(report);
  }

  GeniusHrEndOfServiceResult calculateEndOfService({
    required GeniusHrEmployee employee,
    required DateTime serviceEndDate,
    required ErpMoney monthlySalary,
    GeniusHrEndOfServicePolicy policy =
        const GeniusHrEndOfServicePolicy(),
  }) {
    if (serviceEndDate.isBefore(employee.joinDate)) {
      throw ArgumentError(
        'Service end date cannot be before employee join date.',
      );
    }

    final serviceDays =
        serviceEndDate.difference(employee.joinDate).inDays;
    var years = serviceDays / 365.2425;

    if (!policy.includePartialYear) {
      years = years.floorToDouble();
    }
    if (policy.maximumServiceYears != null &&
        years > policy.maximumServiceYears!) {
      years = policy.maximumServiceYears!;
    }

    final firstYears = years <= policy.thresholdYears
        ? years
        : policy.thresholdYears;
    final laterYears =
        years > policy.thresholdYears
            ? years - policy.thresholdYears
            : 0.0;

    final eligibleDays =
        firstYears * policy.firstYearsDaysPerYear +
            laterYears * policy.laterYearsDaysPerYear;

    final dailyRate = monthlySalary.multiply(
      1 / policy.daysPerSalaryMonth,
    );
    final benefit = dailyRate.multiply(eligibleDays);

    return GeniusHrEndOfServiceResult(
      employee: employee,
      serviceEndDate: serviceEndDate,
      serviceYears: years,
      eligibleDays: eligibleDays,
      dailyRate: dailyRate,
      benefit: benefit,
    );
  }

  GeniusErpPackReportData endOfServiceReport(
    GeniusHrEndOfServiceResult result,
  ) {
    return GeniusErpPackReportData(
      title: 'End-of-Service Calculation',
      titleAr: 'حساب نهاية الخدمة',
      details: [
        _field(
          'Employee',
          'الموظف',
          result.employee.name,
          valueAr: result.employee.nameAr,
        ),
        _field(
          'Join Date',
          'تاريخ الالتحاق',
          _date(result.employee.joinDate),
        ),
        _field(
          'End Date',
          'تاريخ النهاية',
          _date(result.serviceEndDate),
        ),
        _field(
          'Service Years',
          'سنوات الخدمة',
          result.serviceYears.toStringAsFixed(4),
        ),
        _field(
          'Eligible Days',
          'الأيام المستحقة',
          result.eligibleDays.toStringAsFixed(4),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'metric',
          title: 'Metric',
          titleAr: 'البند',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'metric': 'Daily Rate',
            'amount': result.dailyRate.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'metric': 'End-of-Service Benefit',
            'amount': result.benefit.toDouble(),
          },
        ),
      ],
    );
  }

  GeniusHrFinalSettlement calculateFinalSettlement({
    required GeniusHrEmployee employee,
    required DateTime endDate,
    required ErpMoney salaryDue,
    required ErpMoney leaveEncashment,
    required ErpMoney endOfService,
    required ErpMoney otherEarnings,
    required ErpMoney deductions,
  }) {
    final currency = salaryDue.currency;
    for (final value in [
      leaveEncashment,
      endOfService,
      otherEarnings,
      deductions,
    ]) {
      _sameCurrency(currency, value);
    }

    final net = salaryDue +
        leaveEncashment +
        endOfService +
        otherEarnings -
        deductions;

    return GeniusHrFinalSettlement(
      employee: employee,
      endDate: endDate,
      salaryDue: salaryDue,
      leaveEncashment: leaveEncashment,
      endOfService: endOfService,
      otherEarnings: otherEarnings,
      deductions: deductions,
      netSettlement: net,
    );
  }

  GeniusErpPackReportData finalSettlementReport(
    GeniusHrFinalSettlement settlement,
  ) {
    return GeniusErpPackReportData(
      title: 'Final Settlement',
      titleAr: 'المخالصة النهائية',
      details: [
        _field(
          'Employee',
          'الموظف',
          settlement.employee.name,
          valueAr: settlement.employee.nameAr,
        ),
        _field(
          'End Date',
          'تاريخ النهاية',
          _date(settlement.endDate),
        ),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'item',
          title: 'Settlement Item',
          titleAr: 'بند المخالصة',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'item': 'Salary Due',
            'amount': settlement.salaryDue.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'item': 'Leave Encashment',
            'amount': settlement.leaveEncashment.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'item': 'End of Service',
            'amount': settlement.endOfService.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'item': 'Other Earnings',
            'amount': settlement.otherEarnings.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          cells: {
            'item': 'Deductions',
            'amount': -settlement.deductions.toDouble(),
          },
        ),
        GeniusErpPackReportRow(
          isTotal: true,
          cells: {
            'item': 'Net Settlement',
            'amount': settlement.netSettlement.toDouble(),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData salaryCertificate(
    GeniusHrCertificateData certificate, {
    required ErpMoney salary,
    GeniusHrCertificatePolicy certificatePolicy =
        const GeniusHrCertificatePolicy(),
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.hr,
    ),
  }) {
    validateCertificate(certificate, certificatePolicy);
    final report = _certificateReport(
      certificate,
      title: 'Salary Certificate',
      titleAr: 'شهادة راتب',
      extraDetails: [
        if (printPolicy.isVisible(GeniusHrField.baseSalary))
          _field(
            'Salary',
            'الراتب',
            _money(salary),
          ),
      ],
    );
    return printPolicy.applyVariant(report);
  }

  GeniusErpPackReportData employmentCertificate(
    GeniusHrCertificateData certificate, {
    GeniusHrCertificatePolicy certificatePolicy =
        const GeniusHrCertificatePolicy(),
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.hr,
    ),
  }) {
    validateCertificate(certificate, certificatePolicy);
    return printPolicy.applyVariant(
      _certificateReport(
        certificate,
        title: 'Employment Certificate',
        titleAr: 'شهادة عمل',
      ),
    );
  }

  GeniusErpPackReportData experienceCertificate(
    GeniusHrCertificateData certificate, {
    GeniusHrCertificatePolicy certificatePolicy =
        const GeniusHrCertificatePolicy(),
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.hr,
    ),
  }) {
    validateCertificate(certificate, certificatePolicy);
    return printPolicy.applyVariant(
      _certificateReport(
        certificate,
        title: 'Experience Certificate',
        titleAr: 'شهادة خبرة',
      ),
    );
  }

  void validateCertificate(
    GeniusHrCertificateData certificate,
    GeniusHrCertificatePolicy policy,
  ) {
    if (!policy.enforceSinglePage) return;

    final longestBody = certificate.body.length >
            (certificate.bodyAr?.length ?? 0)
        ? certificate.body.length
        : (certificate.bodyAr?.length ?? 0);

    if (longestBody > policy.maxBodyCharacters) {
      throw ArgumentError(
        'Certificate body exceeds the configured single-page contract.',
      );
    }
    if (certificate.additionalFields.length >
        policy.maxAdditionalFields) {
      throw ArgumentError(
        'Certificate additional fields exceed the configured '
        'single-page contract.',
      );
    }
  }

  GeniusErpPackReportData _certificateReport(
    GeniusHrCertificateData certificate, {
    required String title,
    required String titleAr,
    List<GeniusErpDetailField> extraDetails = const [],
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      subtitle: certificate.certificateNumber,
      subtitleAr: certificate.certificateNumber,
      details: [
        _field(
          'Employee',
          'الموظف',
          certificate.employee.name,
          valueAr: certificate.employee.nameAr,
        ),
        _field(
          'Issue Date',
          'تاريخ الإصدار',
          _date(certificate.issueDate),
        ),
        if (certificate.validUntil != null)
          _field(
            'Valid Until',
            'صالح حتى',
            _date(certificate.validUntil!),
          ),
        if (certificate.recipient != null)
          _field(
            'Recipient',
            'الجهة',
            certificate.recipient!,
            valueAr: certificate.recipientAr,
          ),
        ...extraDetails,
        for (final entry in certificate.additionalFields.entries)
          _field(entry.key, entry.key, entry.value),
      ],
      columns: const [
        GeniusErpPackReportColumn(
          id: 'body',
          title: 'Certificate',
          titleAr: 'الشهادة',
          flexFactor: 4,
        ),
      ],
      rows: [
        GeniusErpPackReportRow(
          cells: {
            'body': GeniusErpPackLocalizedValue(
              value: certificate.body,
              valueAr: certificate.bodyAr,
            ),
          },
        ),
      ],
    );
  }

  GeniusErpPackReportData _payrollLineReport(
    List<GeniusHrPayrollEntry> entries, {
    required bool earnings,
    required String title,
    required String titleAr,
  }) {
    return GeniusErpPackReportData(
      title: title,
      titleAr: titleAr,
      columns: const [
        GeniusErpPackReportColumn(
          id: 'employee',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'period',
          title: 'Period',
          titleAr: 'الفترة',
        ),
        GeniusErpPackReportColumn(
          id: 'code',
          title: 'Code',
          titleAr: 'الرمز',
        ),
        GeniusErpPackReportColumn(
          id: 'description',
          title: 'Description',
          titleAr: 'البيان',
          flexFactor: 2,
        ),
        GeniusErpPackReportColumn(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          kind: GeniusErpPackReportColumnKind.money,
        ),
      ],
      rows: [
        for (final entry in entries)
          if (earnings)
            for (final line in entry.earnings)
              GeniusErpPackReportRow(
                cells: {
                  'employee': GeniusErpPackLocalizedValue(
                    value: entry.employee.name,
                    valueAr: entry.employee.nameAr,
                  ),
                  'period': entry.period,
                  'code': line.code,
                  'description': GeniusErpPackLocalizedValue(
                    value: line.label,
                    valueAr: line.labelAr,
                  ),
                  'amount': line.amount.toDouble(),
                },
              )
          else
            for (final line in entry.deductions)
              GeniusErpPackReportRow(
                cells: {
                  'employee': GeniusErpPackLocalizedValue(
                    value: entry.employee.name,
                    valueAr: entry.employee.nameAr,
                  ),
                  'period': entry.period,
                  'code': line.code,
                  'description': GeniusErpPackLocalizedValue(
                    value: line.label,
                    valueAr: line.labelAr,
                  ),
                  'amount': line.amount.toDouble(),
                },
              ),
      ],
    );
  }

  GeniusErpDetailField _field(
    String label,
    String labelAr,
    String value, {
    String? valueAr,
  }) =>
      GeniusErpDetailField(
        label: label,
        labelAr: labelAr,
        value: valueAr == null ? value : '$value / $valueAr',
      );

  String _date(DateTime value) =>
      value.toIso8601String().split('T').first;

  String _time(DateTime? value) {
    if (value == null) return '';
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _money(ErpMoney value) =>
      '${value.toDouble().toStringAsFixed(value.currency.precision)} '
      '${value.currency.code}';

  void _sameCurrency(
    ErpCurrency currency,
    ErpMoney value,
  ) {
    if (value.currency != currency) {
      throw ArgumentError(
        'HR/payroll calculation requires one currency.',
      );
    }
  }

  GeniusErpPackReportData _empty(
    String title,
    String titleAr,
  ) =>
      GeniusErpPackReportData(
        title: title,
        titleAr: titleAr,
        columns: const [
          GeniusErpPackReportColumn(
            id: 'message',
            title: 'Result',
            titleAr: 'النتيجة',
          ),
        ],
        rows: const [
          GeniusErpPackReportRow(
            cells: {'message': 'No data'},
          ),
        ],
      );
}
