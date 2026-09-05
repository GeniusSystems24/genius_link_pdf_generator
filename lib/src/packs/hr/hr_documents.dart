
import '../../components/components.dart';
import '../../core/pdf_config.dart';
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
    GeniusPdfConfig config, {
    required this.report,
    this.hrPrintPolicy = const GeniusHrPrintPolicy(),
  }) : super(config);

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
    GeniusPdfConfig config, {
    required this.report,
    this.hrPrintPolicy = const GeniusHrPrintPolicy(),
  }) : super(config);

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
    GeniusPdfConfig config, {
    required this.report,
    this.hrPrintPolicy = const GeniusHrPrintPolicy(),
  }) : super(config);

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
    GeniusPdfConfig config, {
    required this.report,
    this.hrPrintPolicy = const GeniusHrPrintPolicy(),
  }) : super(config);

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
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T02 — Employee List.
class GeniusEmployeeListDocument extends _HrRegisterDocument {
  GeniusEmployeeListDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T03 — Employment Contract/Form.
class GeniusEmploymentContractDocument extends _HrOperationalDocument {
  GeniusEmploymentContractDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T04 — Employee Action Form.
class GeniusEmployeeActionFormDocument extends _HrOperationalDocument {
  GeniusEmployeeActionFormDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T05 — Attendance Report.
class GeniusAttendanceReportDocument extends _HrRegisterDocument {
  GeniusAttendanceReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T06 — Timesheet.
class GeniusTimesheetDocument extends _HrRegisterDocument {
  GeniusTimesheetDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T07 — Overtime Report.
class GeniusOvertimeReportDocument extends _HrRegisterDocument {
  GeniusOvertimeReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T08 — Leave Balance.
class GeniusLeaveBalanceDocument extends _HrRegisterDocument {
  GeniusLeaveBalanceDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T09 — Leave Request.
class GeniusLeaveRequestDocument extends _HrOperationalDocument {
  GeniusLeaveRequestDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T10 — Payslip.
class GeniusPayslipDocument extends _HrOperationalDocument {
  GeniusPayslipDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.employee,
    ),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T11 — Payroll Sheet.
class GeniusPayrollSheetDocument extends _HrRegisterDocument {
  GeniusPayrollSheetDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T12 — Payroll Summary.
class GeniusPayrollSummaryDocument extends _HrAnalyticalDocument {
  GeniusPayrollSummaryDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T13 — Allowances Report.
class GeniusAllowancesReportDocument extends _HrRegisterDocument {
  GeniusAllowancesReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T14 — Deductions Report.
class GeniusDeductionsReportDocument extends _HrRegisterDocument {
  GeniusDeductionsReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T15 — Employee Loan/Advance Report.
class GeniusEmployeeLoanAdvanceReportDocument
    extends _HrRegisterDocument {
  GeniusEmployeeLoanAdvanceReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.payroll,
    ),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T16 — Salary Certificate.
class GeniusSalaryCertificateDocument extends _HrCertificateDocument {
  GeniusSalaryCertificateDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T17 — Employment Certificate.
class GeniusEmploymentCertificateDocument
    extends _HrCertificateDocument {
  GeniusEmploymentCertificateDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T18 — Experience Certificate.
class GeniusExperienceCertificateDocument
    extends _HrCertificateDocument {
  GeniusExperienceCertificateDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T19 — End-of-Service calculation/report.
class GeniusEndOfServiceReportDocument
    extends _HrAnalyticalDocument {
  GeniusEndOfServiceReportDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.hr,
    ),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}

/// S17-T20 — Final Settlement.
class GeniusFinalSettlementDocument extends _HrOperationalDocument {
  GeniusFinalSettlementDocument(
    GeniusPdfConfig config, {
    required GeniusErpPackReportData report,
    GeniusHrPrintPolicy printPolicy = const GeniusHrPrintPolicy(
      role: GeniusHrPrintableRole.hr,
    ),
  }) : super(
          config,
          report: report,
          hrPrintPolicy: printPolicy,
        );
}
