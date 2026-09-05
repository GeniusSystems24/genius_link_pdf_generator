
import '../../domain/erp/erp.dart';

/// Employment state used by S17 employee lists/forms.
enum GeniusHrEmploymentStatus {
  active,
  probation,
  leave,
  suspended,
  terminated,
}

/// Attendance state used by daily attendance reports.
enum GeniusHrAttendanceStatus {
  present,
  absent,
  late,
  leave,
  holiday,
  remote,
}

/// Leave-request lifecycle.
enum GeniusHrLeaveStatus {
  draft,
  submitted,
  approved,
  rejected,
  cancelled,
}

/// Printable HR role used by privacy/variant policy.
enum GeniusHrPrintableRole {
  employee,
  manager,
  hr,
  payroll,
  auditor,
}

/// Sensitive HR fields controlled by S17 field-visibility policy.
enum GeniusHrField {
  employeeId,
  nationalId,
  passport,
  phone,
  email,
  bankName,
  bankAccount,
  iban,
  baseSalary,
  allowances,
  deductions,
  loanBalance,
  address,
}

/// Core employee profile used by S17 outputs.
class GeniusHrEmployee {
  const GeniusHrEmployee({
    required this.employeeId,
    required this.name,
    required this.joinDate,
    this.nameAr,
    this.department,
    this.departmentAr,
    this.jobTitle,
    this.jobTitleAr,
    this.status = GeniusHrEmploymentStatus.active,
    this.nationalId,
    this.passport,
    this.phone,
    this.email,
    this.bankName,
    this.bankAccount,
    this.iban,
    this.address,
    this.addressAr,
    this.baseSalary,
    this.managerName,
    this.managerNameAr,
    this.metadata = const {},
  });

  final String employeeId;
  final String name;
  final String? nameAr;
  final DateTime joinDate;
  final String? department;
  final String? departmentAr;
  final String? jobTitle;
  final String? jobTitleAr;
  final GeniusHrEmploymentStatus status;
  final String? nationalId;
  final String? passport;
  final String? phone;
  final String? email;
  final String? bankName;
  final String? bankAccount;
  final String? iban;
  final String? address;
  final String? addressAr;
  final ErpMoney? baseSalary;
  final String? managerName;
  final String? managerNameAr;
  final Map<String, Object?> metadata;
}

/// Employment contract/form payload.
class GeniusHrEmploymentContract {
  const GeniusHrEmploymentContract({
    required this.contractNumber,
    required this.employee,
    required this.startDate,
    this.endDate,
    this.probationEndDate,
    this.workLocation,
    this.workLocationAr,
    this.hoursPerWeek,
    this.terms,
    this.termsAr,
    this.signatory,
    this.signatoryAr,
  });

  final String contractNumber;
  final GeniusHrEmployee employee;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime? probationEndDate;
  final String? workLocation;
  final String? workLocationAr;
  final double? hoursPerWeek;
  final String? terms;
  final String? termsAr;
  final String? signatory;
  final String? signatoryAr;
}

/// Employee action/change form payload.
class GeniusHrEmployeeAction {
  const GeniusHrEmployeeAction({
    required this.actionNumber,
    required this.employee,
    required this.effectiveDate,
    required this.actionType,
    this.actionTypeAr,
    this.previousValue,
    this.newValue,
    this.reason,
    this.reasonAr,
    this.approvedBy,
  });

  final String actionNumber;
  final GeniusHrEmployee employee;
  final DateTime effectiveDate;
  final String actionType;
  final String? actionTypeAr;
  final String? previousValue;
  final String? newValue;
  final String? reason;
  final String? reasonAr;
  final String? approvedBy;
}

/// One attendance day.
class GeniusHrAttendanceEntry {
  const GeniusHrAttendanceEntry({
    required this.employee,
    required this.date,
    required this.status,
    this.scheduledStart,
    this.scheduledEnd,
    this.checkIn,
    this.checkOut,
    this.notes,
    this.notesAr,
  });

  final GeniusHrEmployee employee;
  final DateTime date;
  final GeniusHrAttendanceStatus status;
  final DateTime? scheduledStart;
  final DateTime? scheduledEnd;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final String? notes;
  final String? notesAr;

  Duration get workedDuration {
    if (checkIn == null || checkOut == null) {
      return Duration.zero;
    }
    final value = checkOut!.difference(checkIn!);
    return value.isNegative ? Duration.zero : value;
  }

  Duration get lateDuration {
    if (scheduledStart == null || checkIn == null) {
      return Duration.zero;
    }
    final value = checkIn!.difference(scheduledStart!);
    return value.isNegative ? Duration.zero : value;
  }
}

/// One project/task timesheet entry.
class GeniusHrTimesheetEntry {
  const GeniusHrTimesheetEntry({
    required this.employee,
    required this.date,
    required this.hours,
    this.project,
    this.projectAr,
    this.task,
    this.taskAr,
    this.billable = false,
    this.notes,
    this.notesAr,
  }) : assert(hours >= 0);

  final GeniusHrEmployee employee;
  final DateTime date;
  final double hours;
  final String? project;
  final String? projectAr;
  final String? task;
  final String? taskAr;
  final bool billable;
  final String? notes;
  final String? notesAr;
}

/// Overtime entry.
class GeniusHrOvertimeEntry {
  const GeniusHrOvertimeEntry({
    required this.employee,
    required this.date,
    required this.hours,
    this.rateMultiplier = 1.0,
    this.reason,
    this.reasonAr,
  })  : assert(hours >= 0),
        assert(rateMultiplier >= 0);

  final GeniusHrEmployee employee;
  final DateTime date;
  final double hours;
  final double rateMultiplier;
  final String? reason;
  final String? reasonAr;
}

/// Leave entitlement/balance.
class GeniusHrLeaveBalance {
  const GeniusHrLeaveBalance({
    required this.employee,
    required this.leaveType,
    required this.entitledDays,
    required this.usedDays,
    this.leaveTypeAr,
    this.pendingDays = 0,
  });

  final GeniusHrEmployee employee;
  final String leaveType;
  final String? leaveTypeAr;
  final double entitledDays;
  final double usedDays;
  final double pendingDays;

  double get availableDays => entitledDays - usedDays - pendingDays;
}

/// Leave request/form.
class GeniusHrLeaveRequest {
  const GeniusHrLeaveRequest({
    required this.requestNumber,
    required this.employee,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.days,
    this.leaveTypeAr,
    this.status = GeniusHrLeaveStatus.submitted,
    this.reason,
    this.reasonAr,
    this.approver,
  }) : assert(days >= 0);

  final String requestNumber;
  final GeniusHrEmployee employee;
  final String leaveType;
  final String? leaveTypeAr;
  final DateTime startDate;
  final DateTime endDate;
  final double days;
  final GeniusHrLeaveStatus status;
  final String? reason;
  final String? reasonAr;
  final String? approver;
}

/// One earning/allowance line in a payslip.
class GeniusHrPayrollEarning {
  const GeniusHrPayrollEarning({
    required this.code,
    required this.label,
    required this.amount,
    this.labelAr,
    this.taxable = true,
  });

  final String code;
  final String label;
  final String? labelAr;
  final ErpMoney amount;
  final bool taxable;
}

/// One deduction line in a payslip.
class GeniusHrPayrollDeduction {
  const GeniusHrPayrollDeduction({
    required this.code,
    required this.label,
    required this.amount,
    this.labelAr,
    this.reference,
  });

  final String code;
  final String label;
  final String? labelAr;
  final ErpMoney amount;
  final String? reference;
}

/// Source payroll input before totals are reconciled.
class GeniusHrPayrollEntry {
  const GeniusHrPayrollEntry({
    required this.employee,
    required this.period,
    required this.baseSalary,
    this.earnings = const [],
    this.deductions = const [],
    this.daysWorked,
    this.hoursWorked,
    this.overtimeHours,
    this.bankReference,
  });

  final GeniusHrEmployee employee;
  final String period;
  final ErpMoney baseSalary;
  final List<GeniusHrPayrollEarning> earnings;
  final List<GeniusHrPayrollDeduction> deductions;
  final double? daysWorked;
  final double? hoursWorked;
  final double? overtimeHours;
  final String? bankReference;
}

/// Reconciled payroll result.
class GeniusHrPayrollResult {
  const GeniusHrPayrollResult({
    required this.source,
    required this.gross,
    required this.totalEarnings,
    required this.totalDeductions,
    required this.net,
  });

  final GeniusHrPayrollEntry source;
  final ErpMoney gross;
  final ErpMoney totalEarnings;
  final ErpMoney totalDeductions;
  final ErpMoney net;
}

/// Employee loan/advance balance.
class GeniusHrLoanAdvance {
  const GeniusHrLoanAdvance({
    required this.reference,
    required this.employee,
    required this.originalAmount,
    required this.repaidAmount,
    this.description,
    this.descriptionAr,
  });

  final String reference;
  final GeniusHrEmployee employee;
  final ErpMoney originalAmount;
  final ErpMoney repaidAmount;
  final String? description;
  final String? descriptionAr;

  ErpMoney get outstanding => originalAmount - repaidAmount;
}

/// End-of-service formula is policy-driven rather than jurisdiction-hardcoded.
class GeniusHrEndOfServicePolicy {
  const GeniusHrEndOfServicePolicy({
    this.thresholdYears = 5,
    this.firstYearsDaysPerYear = 15,
    this.laterYearsDaysPerYear = 30,
    this.daysPerSalaryMonth = 30,
    this.includePartialYear = true,
    this.maximumServiceYears,
  })  : assert(thresholdYears >= 0),
        assert(firstYearsDaysPerYear >= 0),
        assert(laterYearsDaysPerYear >= 0),
        assert(daysPerSalaryMonth > 0);

  final double thresholdYears;
  final double firstYearsDaysPerYear;
  final double laterYearsDaysPerYear;
  final double daysPerSalaryMonth;
  final bool includePartialYear;
  final double? maximumServiceYears;
}

/// End-of-service calculation result.
class GeniusHrEndOfServiceResult {
  const GeniusHrEndOfServiceResult({
    required this.employee,
    required this.serviceEndDate,
    required this.serviceYears,
    required this.eligibleDays,
    required this.dailyRate,
    required this.benefit,
  });

  final GeniusHrEmployee employee;
  final DateTime serviceEndDate;
  final double serviceYears;
  final double eligibleDays;
  final ErpMoney dailyRate;
  final ErpMoney benefit;
}

/// Final settlement inputs/result.
class GeniusHrFinalSettlement {
  const GeniusHrFinalSettlement({
    required this.employee,
    required this.endDate,
    required this.salaryDue,
    required this.leaveEncashment,
    required this.endOfService,
    required this.otherEarnings,
    required this.deductions,
    required this.netSettlement,
  });

  final GeniusHrEmployee employee;
  final DateTime endDate;
  final ErpMoney salaryDue;
  final ErpMoney leaveEncashment;
  final ErpMoney endOfService;
  final ErpMoney otherEarnings;
  final ErpMoney deductions;
  final ErpMoney netSettlement;
}

/// Generic certificate payload used by salary/employment/experience outputs.
class GeniusHrCertificateData {
  const GeniusHrCertificateData({
    required this.certificateNumber,
    required this.employee,
    required this.issueDate,
    required this.body,
    this.bodyAr,
    this.validUntil,
    this.recipient,
    this.recipientAr,
    this.additionalFields = const {},
  });

  final String certificateNumber;
  final GeniusHrEmployee employee;
  final DateTime issueDate;
  final DateTime? validUntil;
  final String body;
  final String? bodyAr;
  final String? recipient;
  final String? recipientAr;
  final Map<String, String> additionalFields;
}

/// Single-page certificate guard.
///
/// The renderer does not guess physical pagination. Instead, S17 validates a
/// conservative content contract before rendering certificates.
class GeniusHrCertificatePolicy {
  const GeniusHrCertificatePolicy({
    this.enforceSinglePage = true,
    this.maxBodyCharacters = 1800,
    this.maxAdditionalFields = 12,
  })  : assert(maxBodyCharacters > 0),
        assert(maxAdditionalFields >= 0);

  final bool enforceSinglePage;
  final int maxBodyCharacters;
  final int maxAdditionalFields;
}
