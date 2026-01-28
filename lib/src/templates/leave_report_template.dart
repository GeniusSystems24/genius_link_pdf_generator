import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

/// Leave type enum.
enum LeaveType {
  annual,
  sick,
  unpaid,
  maternity,
  paternity,
  emergency,
  compensatory,
  other,
}

/// Leave status enum.
enum LeaveStatus {
  pending,
  approved,
  rejected,
  cancelled,
}

/// Leave request record.
class LeaveRecord {
  const LeaveRecord({
    required this.leaveId,
    required this.employeeId,
    required this.employeeName,
    required this.leaveType,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.employeeNameAr,
    this.department,
    this.departmentAr,
    this.reason,
    this.reasonAr,
    this.approvedBy,
    this.approvedByAr,
    this.approvalDate,
    this.remarks,
  });

  final String leaveId;
  final String employeeId;
  final String employeeName;
  final String? employeeNameAr;
  final String? department;
  final String? departmentAr;
  final LeaveType leaveType;
  final DateTime startDate;
  final DateTime endDate;
  final LeaveStatus status;
  final String? reason;
  final String? reasonAr;
  final String? approvedBy;
  final String? approvedByAr;
  final DateTime? approvalDate;
  final String? remarks;

  int get days => endDate.difference(startDate).inDays + 1;

  String get leaveTypeText {
    switch (leaveType) {
      case LeaveType.annual:
        return 'Annual';
      case LeaveType.sick:
        return 'Sick';
      case LeaveType.unpaid:
        return 'Unpaid';
      case LeaveType.maternity:
        return 'Maternity';
      case LeaveType.paternity:
        return 'Paternity';
      case LeaveType.emergency:
        return 'Emergency';
      case LeaveType.compensatory:
        return 'Compensatory';
      case LeaveType.other:
        return 'Other';
    }
  }

  String get leaveTypeTextAr {
    switch (leaveType) {
      case LeaveType.annual:
        return 'سنوية';
      case LeaveType.sick:
        return 'مرضية';
      case LeaveType.unpaid:
        return 'بدون راتب';
      case LeaveType.maternity:
        return 'أمومة';
      case LeaveType.paternity:
        return 'أبوة';
      case LeaveType.emergency:
        return 'طارئة';
      case LeaveType.compensatory:
        return 'تعويضية';
      case LeaveType.other:
        return 'أخرى';
    }
  }

  String get statusText {
    switch (status) {
      case LeaveStatus.pending:
        return 'Pending';
      case LeaveStatus.approved:
        return 'Approved';
      case LeaveStatus.rejected:
        return 'Rejected';
      case LeaveStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get statusTextAr {
    switch (status) {
      case LeaveStatus.pending:
        return 'قيد الانتظار';
      case LeaveStatus.approved:
        return 'معتمد';
      case LeaveStatus.rejected:
        return 'مرفوض';
      case LeaveStatus.cancelled:
        return 'ملغي';
    }
  }
}

/// Employee leave balance.
class LeaveBalance {
  const LeaveBalance({
    required this.employeeId,
    required this.employeeName,
    required this.annualEntitlement,
    required this.annualUsed,
    required this.sickUsed,
    this.employeeNameAr,
    this.department,
    this.departmentAr,
    this.unpaidUsed = 0,
    this.carryForward = 0,
  });

  final String employeeId;
  final String employeeName;
  final String? employeeNameAr;
  final String? department;
  final String? departmentAr;
  final int annualEntitlement;
  final int annualUsed;
  final int sickUsed;
  final int unpaidUsed;
  final int carryForward;

  int get annualBalance => annualEntitlement + carryForward - annualUsed;
  int get totalUsed => annualUsed + sickUsed + unpaidUsed;
}

/// Leave report data model.
class LeaveReportData {
  const LeaveReportData({
    required this.reportTitle,
    required this.periodStart,
    required this.periodEnd,
    this.reportTitleAr,
    this.leaveRequests = const [],
    this.leaveBalances = const [],
    this.showBalances = true,
    this.showRequests = true,
  });

  final String reportTitle;
  final String? reportTitleAr;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<LeaveRecord> leaveRequests;
  final List<LeaveBalance> leaveBalances;
  final bool showBalances;
  final bool showRequests;

  int get totalRequests => leaveRequests.length;
  int get pendingRequests =>
      leaveRequests.where((l) => l.status == LeaveStatus.pending).length;
  int get approvedRequests =>
      leaveRequests.where((l) => l.status == LeaveStatus.approved).length;
  int get totalLeaveDays => leaveRequests
      .where((l) => l.status == LeaveStatus.approved)
      .fold(0, (sum, l) => sum + l.days);

  Map<LeaveType, int> get leaveTypeBreakdown {
    final breakdown = <LeaveType, int>{};
    for (final leave
        in leaveRequests.where((l) => l.status == LeaveStatus.approved)) {
      breakdown[leave.leaveType] =
          (breakdown[leave.leaveType] ?? 0) + leave.days;
    }
    return breakdown;
  }
}

/// A professional leave report template.
///
/// Creates comprehensive leave reports with balances,
/// requests, and approval tracking.
///
/// ## Example
/// ```dart
/// final report = LeaveReportTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: leaveData,
/// );
///
/// final bytes = report.generate();
/// ```
class LeaveReportTemplate extends GeniusPdfDocumentBuilder {
  LeaveReportTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final LeaveReportData data;
  final PdfFont? boldFont;

  PdfFont get _boldFont =>
      boldFont ??
      (config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold));

  @override
  void build() {
    newPage();

    _drawHeader();
    _drawOverallSummary();

    if (data.showBalances && data.leaveBalances.isNotEmpty) {
      _drawLeaveBalances();
    }

    if (data.showRequests && data.leaveRequests.isNotEmpty) {
      _drawLeaveRequests();
    }

    _drawLeaveTypeBreakdown();
  }

  void _drawHeader() {
    final title = config.isRTL
        ? (data.reportTitleAr ?? data.reportTitle)
        : data.reportTitle;
    final periodText =
        '${_formatDate(data.periodStart)} - ${_formatDate(data.periodEnd)}';

    final header = GeniusPdfReportHeader(
      title: title,
      subtitle: 'Period: $periodText',
      subtitleAr: 'الفترة: $periodText',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 18),
        showBorder: false,
      ),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(105);
  }

  void _drawOverallSummary() {
    final title = config.isRTL ? 'الملخص العام' : 'Overview';

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(70, 130, 180)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 22),
    );

    currentPage.graphics.drawString(
      title,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 11,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(10, currentY + 4, pageWidth - 20, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(28);

    // Stats boxes
    final stats = [
      (
        config.isRTL ? 'إجمالي الطلبات' : 'Total Requests',
        data.totalRequests,
        PdfColor(70, 130, 180)
      ),
      (
        config.isRTL ? 'قيد الانتظار' : 'Pending',
        data.pendingRequests,
        PdfColor(255, 165, 0)
      ),
      (
        config.isRTL ? 'معتمد' : 'Approved',
        data.approvedRequests,
        PdfColor(46, 139, 87)
      ),
      (
        config.isRTL ? 'إجمالي الأيام' : 'Total Days',
        data.totalLeaveDays,
        PdfColor(138, 43, 226)
      ),
    ];

    final boxWidth = (pageWidth - 60) / stats.length;
    for (var i = 0; i < stats.length; i++) {
      final stat = stats[i];
      final x = i * (boxWidth + 20);

      currentPage.graphics.drawRectangle(
        brush: PdfSolidBrush(stat.$3),
        bounds: Rect.fromLTWH(x, currentY, boxWidth, 50),
      );

      currentPage.graphics.drawString(
        '${stat.$2}',
        config.configAssets == null
            ? config.baseFont
            : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 18,
                style: PdfFontStyle.bold),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(x, currentY + 8, boxWidth, 22),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );

      currentPage.graphics.drawString(
        stat.$1,
        config.configAssets == null
            ? config.baseFont
            : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 8,
                style: PdfFontStyle.regular),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(x, currentY + 32, boxWidth, 14),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
    }

    addSpace(60);
  }

  void _drawLeaveBalances() {
    final title = config.isRTL ? 'رصيد الإجازات' : 'Leave Balances';

    currentPage.graphics.drawString(
      title,
      _boldFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(22);

    final grid = GeniusPdfDataGrid(
      columns: [
        const GeniusPdfGridColumn(
          id: 'id',
          title: 'ID',
          titleAr: 'الرقم',
          width: 50,
        ),
        const GeniusPdfGridColumn(
          id: 'name',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        const GeniusPdfGridColumn(
          id: 'entitled',
          title: 'Entitled',
          titleAr: 'المستحقة',
          width: 60,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'carry',
          title: 'Carry',
          titleAr: 'مرحلة',
          width: 50,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'annual',
          title: 'Annual Used',
          titleAr: 'سنوية مستخدمة',
          width: 70,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'sick',
          title: 'Sick',
          titleAr: 'مرضية',
          width: 50,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'unpaid',
          title: 'Unpaid',
          titleAr: 'بدون راتب',
          width: 55,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'balance',
          title: 'Balance',
          titleAr: 'الرصيد',
          width: 60,
          alignment: GeniusPdfTextAlign.center,
        ),
      ],
      rows: data.leaveBalances
          .map((bal) => GeniusPdfGridRow(
                cells: {
                  'id': bal.employeeId,
                  'name': config.isRTL
                      ? (bal.employeeNameAr ?? bal.employeeName)
                      : bal.employeeName,
                  'entitled': bal.annualEntitlement,
                  'carry': bal.carryForward,
                  'annual': bal.annualUsed,
                  'sick': bal.sickUsed,
                  'unpaid': bal.unpaidUsed,
                  'balance': bal.annualBalance,
                },
              ))
          .toList(),
      style: const GeniusPdfGridStyle.modern(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      addSpace(result.bounds.height + 20);
    }
  }

  void _drawLeaveRequests() {
    if (currentY > pageHeight - 150) {
      newPage();
    }

    final title = config.isRTL ? 'طلبات الإجازة' : 'Leave Requests';

    currentPage.graphics.drawString(
      title,
      _boldFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(22);

    final grid = GeniusPdfDataGrid(
      columns: [
        const GeniusPdfGridColumn(
          id: 'id',
          title: 'Req #',
          titleAr: 'رقم الطلب',
          width: 50,
        ),
        const GeniusPdfGridColumn(
          id: 'employee',
          title: 'Employee',
          titleAr: 'الموظف',
          flexFactor: 2,
        ),
        const GeniusPdfGridColumn(
          id: 'type',
          title: 'Type',
          titleAr: 'النوع',
          width: 65,
        ),
        const GeniusPdfGridColumn(
          id: 'from',
          title: 'From',
          titleAr: 'من',
          width: 75,
        ),
        const GeniusPdfGridColumn(
          id: 'to',
          title: 'To',
          titleAr: 'إلى',
          width: 75,
        ),
        const GeniusPdfGridColumn(
          id: 'days',
          title: 'Days',
          titleAr: 'الأيام',
          width: 45,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'status',
          title: 'Status',
          titleAr: 'الحالة',
          width: 65,
          alignment: GeniusPdfTextAlign.center,
        ),
      ],
      rows: data.leaveRequests
          .map((leave) => GeniusPdfGridRow(
                cells: {
                  'id': leave.leaveId,
                  'employee': config.isRTL
                      ? (leave.employeeNameAr ?? leave.employeeName)
                      : leave.employeeName,
                  'type': config.isRTL
                      ? leave.leaveTypeTextAr
                      : leave.leaveTypeText,
                  'from': _formatDate(leave.startDate),
                  'to': _formatDate(leave.endDate),
                  'days': leave.days,
                  'status':
                      config.isRTL ? leave.statusTextAr : leave.statusText,
                },
              ))
          .toList(),
      style: const GeniusPdfGridStyle.modern(),
      baseFont: baseFont,
      boldFont: _boldFont,
      isRTL: config.isRTL,
    );

    final result = grid.drawAt(
      page: currentPage,
      x: 0,
      y: currentY,
      width: pageWidth,
    );

    if (result != null) {
      addSpace(result.bounds.height + 20);
    }
  }

  void _drawLeaveTypeBreakdown() {
    if (data.leaveTypeBreakdown.isEmpty) return;

    if (currentY > pageHeight - 120) {
      newPage();
    }

    final title =
        config.isRTL ? 'توزيع أنواع الإجازات' : 'Leave Type Breakdown';

    currentPage.graphics.drawString(
      title,
      _boldFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 18),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(22);

    final breakdown = data.leaveTypeBreakdown;
    final colors = [
      PdfColor(70, 130, 180),
      PdfColor(255, 165, 0),
      PdfColor(46, 139, 87),
      PdfColor(138, 43, 226),
      PdfColor(220, 20, 60),
      PdfColor(0, 128, 128),
    ];

    var colorIndex = 0;
    const barHeight = 25.0;

    for (final entry in breakdown.entries) {
      final typeText = config.isRTL
          ? _getLeaveTypeTextAr(entry.key)
          : _getLeaveTypeText(entry.key);
      final days = entry.value;
      final barWidth = (pageWidth - 100) *
          (days / (data.totalLeaveDays > 0 ? data.totalLeaveDays : 1));

      currentPage.graphics.drawString(
        typeText,
        baseFont,
        bounds: Rect.fromLTWH(0, currentY, 80, barHeight),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );

      currentPage.graphics.drawRectangle(
        brush: PdfSolidBrush(colors[colorIndex % colors.length]),
        bounds: Rect.fromLTWH(85, currentY + 3, barWidth, barHeight - 6),
      );

      currentPage.graphics.drawString(
        '$days ${config.isRTL ? 'يوم' : 'days'}',
        config.configAssets == null
            ? config.baseFont
            : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 8,
                style: PdfFontStyle.regular),
        bounds: Rect.fromLTWH(90 + barWidth, currentY, 50, barHeight),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle,
        ),
      );
      colorIndex++;
    }

    addSpace(15);
  }

  String _getLeaveTypeText(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return 'Annual';
      case LeaveType.sick:
        return 'Sick';
      case LeaveType.unpaid:
        return 'Unpaid';
      case LeaveType.maternity:
        return 'Maternity';
      case LeaveType.paternity:
        return 'Paternity';
      case LeaveType.emergency:
        return 'Emergency';
      case LeaveType.compensatory:
        return 'Compensatory';
      case LeaveType.other:
        return 'Other';
    }
  }

  String _getLeaveTypeTextAr(LeaveType type) {
    switch (type) {
      case LeaveType.annual:
        return 'سنوية';
      case LeaveType.sick:
        return 'مرضية';
      case LeaveType.unpaid:
        return 'بدون راتب';
      case LeaveType.maternity:
        return 'أمومة';
      case LeaveType.paternity:
        return 'أبوة';
      case LeaveType.emergency:
        return 'طارئة';
      case LeaveType.compensatory:
        return 'تعويضية';
      case LeaveType.other:
        return 'أخرى';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
