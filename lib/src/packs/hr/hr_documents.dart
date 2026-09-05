
import '../../components/components.dart';
import '../../families/erp/erp_families.dart';
import '../shared/erp_pack_shared.dart';
import 'hr_privacy.dart';

import '../../builders/pdf_document_builder.dart';
import 'hr_models.dart';
mixin _HrPrivacyRendering on GeniusPdfDocumentBuilder {
  GeniusHrPrintPolicy get hrPrintPolicy;

  /// Applies privacy watermarks through the real builder document.
  void addWatermark(GeniusPdfWatermark watermark) {
    watermark.applyToDocument(document);
  }

  void applyHrPrivacyWatermark() {
    final custom = config.isRTL
        ? (hrPrintPolicy.watermarkTextAr ??
            hrPrintPolicy.watermarkText)
        : (hrPrintPolicy.watermarkText ??
            hrPrintPolicy.watermarkTextAr);
    if (custom != null && custom.trim().isNotEmpty) {
      addWatermark(
        GeniusPdfWatermark.draft(
          text: custom,
          opacity: 0.10,
          config: config,
        ),
      );
      return;
    }

    if (hrPrintPolicy.confidential) {
      addWatermark(
        GeniusPdfWatermark.confidential(
          config: config,
        ),
      );
    }
  }
}

abstract class _HrRegisterDocument extends GeniusErpRegisterDocument
    with _HrPrivacyRendering {
  _HrRegisterDocument(
    super.config, {
    required this.report,
    this.hrPrintPolicy = const GeniusHrPrintPolicy(),
  });

  final GeniusErpPackReportData report;

  @override
  final GeniusHrPrintPolicy hrPrintPolicy;

  @override
  void build() {
    renderErpPackReport(report);
    applyHrPrivacyWatermark();
  }
}

abstract class _HrOperationalDocument extends GeniusErpOperationalForm
    with _HrPrivacyRendering {
  _HrOperationalDocument(
    super.config, {
    required this.report,
    this.hrPrintPolicy = const GeniusHrPrintPolicy(),
  });

  final GeniusErpPackReportData report;

  @override
  final GeniusHrPrintPolicy hrPrintPolicy;

  @override
  void build() {
    renderErpPackReport(report);
    applyHrPrivacyWatermark();
  }
}

abstract class _HrAnalyticalDocument extends GeniusErpAnalyticalReport
    with _HrPrivacyRendering {
  _HrAnalyticalDocument(
    super.config, {
    required this.report,
    this.hrPrintPolicy = const GeniusHrPrintPolicy(),
  });

  final GeniusErpPackReportData report;

  @override
  final GeniusHrPrintPolicy hrPrintPolicy;

  @override
  void build() {
    renderErpPackReport(report);
    applyHrPrivacyWatermark();
  }
}

abstract class _HrCertificateDocument extends GeniusErpCertificateDocument
    with _HrPrivacyRendering {
  _HrCertificateDocument(
    super.config, {
    required this.report,
    this.hrPrintPolicy = const GeniusHrPrintPolicy(),
  });

  final GeniusErpPackReportData report;

  @override
  final GeniusHrPrintPolicy hrPrintPolicy;

  @override
  void build() {
    renderErpPackReport(report);
    applyHrPrivacyWatermark();
  }
}

/// S17-T01 — Employee Profile.
class GeniusEmployeeProfileDocument extends _HrRegisterDocument {
  GeniusEmployeeProfileDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T02 — Employee List.
class GeniusEmployeeListDocument extends _HrRegisterDocument {
  GeniusEmployeeListDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T03 — Employment Contract/Form.
class GeniusEmploymentContractDocument extends _HrOperationalDocument {
  GeniusEmploymentContractDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T04 — Employee Action Form.
class GeniusEmployeeActionFormDocument extends _HrOperationalDocument {
  GeniusEmployeeActionFormDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T05 — Attendance Report.
class GeniusAttendanceReportDocument extends _HrRegisterDocument {
  GeniusAttendanceReportDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T06 — Timesheet.
class GeniusTimesheetDocument extends _HrRegisterDocument {
  GeniusTimesheetDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T07 — Overtime Report.
class GeniusOvertimeReportDocument extends _HrRegisterDocument {
  GeniusOvertimeReportDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T08 — Leave Balance.
class GeniusLeaveBalanceDocument extends _HrRegisterDocument {
  GeniusLeaveBalanceDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T09 — Leave Request.
class GeniusLeaveRequestDocument extends _HrOperationalDocument {
  GeniusLeaveRequestDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T10 — Payslip.
class GeniusPayslipDocument extends _HrOperationalDocument {
  GeniusPayslipDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.employee,
    ),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T11 — Payroll Sheet.
class GeniusPayrollSheetDocument extends _HrRegisterDocument {
  GeniusPayrollSheetDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T12 — Payroll Summary.
class GeniusPayrollSummaryDocument extends _HrAnalyticalDocument {
  GeniusPayrollSummaryDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T13 — Allowances Report.
class GeniusAllowancesReportDocument extends _HrRegisterDocument {
  GeniusAllowancesReportDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T14 — Deductions Report.
class GeniusDeductionsReportDocument extends _HrRegisterDocument {
  GeniusDeductionsReportDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T15 — Employee Loan/Advance Report.
class GeniusEmployeeLoanAdvanceReportDocument
    extends _HrRegisterDocument {
  GeniusEmployeeLoanAdvanceReportDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T16 — Salary Certificate.
class GeniusSalaryCertificateDocument extends _HrCertificateDocument {
  GeniusSalaryCertificateDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T17 — Employment Certificate.
class GeniusEmploymentCertificateDocument
    extends _HrCertificateDocument {
  GeniusEmploymentCertificateDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T18 — Experience Certificate.
class GeniusExperienceCertificateDocument
    extends _HrCertificateDocument {
  GeniusExperienceCertificateDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T19 — End-of-Service calculation/report.
class GeniusEndOfServiceReportDocument
    extends _HrAnalyticalDocument {
  GeniusEndOfServiceReportDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.hr,
    ),
  }) : super(hrPrintPolicy: printPolicy);
}

/// S17-T20 — Final Settlement.
class GeniusFinalSettlementDocument extends _HrOperationalDocument {
  GeniusFinalSettlementDocument(
    super.config, {
    required super.report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.hr,
    ),
  }) : super(hrPrintPolicy: printPolicy);
}
