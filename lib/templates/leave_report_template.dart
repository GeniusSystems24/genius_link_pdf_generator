import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../src/components/components.dart';
import '../src/core/pdf_config.dart';

import 'erp_shared_template_layout.dart';
import '../src/families/erp/erp_families.dart';
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
class LeaveReportTemplate extends GeniusErpRegisterDocument {
  LeaveReportTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
    this.reportId,
    this.printedBy,
    this.showQRCode = true,
    this.showSignatures = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final LeaveReportData data;
  final PdfFont? boldFont;

  /// Report ID for QR code URL
  final String? reportId;

  /// User who printed the report
  final String? printedBy;

  /// Whether to show QR code with report link
  final bool showQRCode;

  /// Whether to show signature areas
  final bool showSignatures;

  /// Whether to show notes section
  final bool showNotes;

  /// Custom notes to display
  final String? notes;
  final String? notesAr;

  @override
  void build() {
    // Add repeating footer with user info on all pages
    if (printedBy != null || showQRCode) {
      addFooter(
        userName: printedBy,
        printTime: _formatDate(DateTime.now()),
        showPageNumber: true,
      );
    }

    newPage();

    _drawHeader();
    _drawReportInfo();
    _drawOverallSummary();

    if (data.showBalances && data.leaveBalances.isNotEmpty) {
      _drawLeaveBalances();
    }

    if (data.showRequests && data.leaveRequests.isNotEmpty) {
      _drawLeaveRequests();
    }

    _drawLeaveTypeBreakdown();

    // Draw Footer Section (Notes + QR Code)
    _drawFooterSection();

    // Signatures section
    if (showSignatures) {
      drawErpSignatureRow(
        signatures: const [
          GeniusErpTemplateSignatureSpec(
            title: 'Prepared By',
            titleAr: 'أعده',
          ),
          GeniusErpTemplateSignatureSpec(
            title: 'HR Manager',
            titleAr: 'مدير الموارد البشرية',
          ),
        ],
        itemWidth: 120,
        lineWidth: 110,
      );
    }
  }

  void _drawHeader() {
    final title = config.isRTL
        ? (data.reportTitleAr ?? data.reportTitle)
        : data.reportTitle;
    final periodText =
        '${_formatDate(data.periodStart)} - ${_formatDate(data.periodEnd)}';

    final header = GeniusPdfReportHeader(
      config: config,
      title: title,
      subtitle: 'Period: $periodText',
      subtitleAr: 'الفترة: $periodText',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 18),
        showBorder: false,
      ),
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    addReportHeader(header, height: 100);
  }

  void _drawReportInfo() {
    final infoBox = GeniusPdfInfoBox(
      config: config,
      title: 'Report Details',
      titleAr: 'تفاصيل التقرير',
      columns: 3,
      showEmptyItems: true,
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Period Start',
          labelAr: 'بداية الفترة',
          value: _formatDate(data.periodStart),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Period End',
          labelAr: 'نهاية الفترة',
          value: _formatDate(data.periodEnd),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Show Balances',
          labelAr: 'إظهار الأرصدة',
          value: data.showBalances
              ? (config.isRTL ? 'نعم' : 'Yes')
              : (config.isRTL ? 'لا' : 'No'),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Show Requests',
          labelAr: 'إظهار الطلبات',
          value: data.showRequests
              ? (config.isRTL ? 'نعم' : 'Yes')
              : (config.isRTL ? 'لا' : 'No'),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Total Requests',
          labelAr: 'إجمالي الطلبات',
          value: '${data.totalRequests}',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Total Days',
          labelAr: 'إجمالي الأيام',
          value: '${data.totalLeaveDays}',
        ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    addInfoBox(infoBox, spacing: 6);
  }

  void _drawOverallSummary() {
    final summary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem(
          label: 'Total Requests',
          labelAr: 'إجمالي الطلبات',
          value: '${data.totalRequests}',
        ),
        GeniusPdfSummaryItem(
          label: 'Pending',
          labelAr: 'قيد الانتظار',
          value: '${data.pendingRequests}',
        ),
        GeniusPdfSummaryItem(
          label: 'Approved',
          labelAr: 'معتمد',
          value: '${data.approvedRequests}',
        ),
        GeniusPdfSummaryItem(
          label: 'Total Days',
          labelAr: 'إجمالي الأيام',
          value: '${data.totalLeaveDays}',
        ),
      ],
      style: const GeniusPdfSummaryStyle.minimal(),
      alignment: config.isRTL
          ? GeniusPdfSummaryAlignment.right
          : GeniusPdfSummaryAlignment.left,
    );

    addReportSummary(
      summary: summary,
      title: 'Overview',
      titleAr: 'الملخص العام',
      spacing: 8,
    );
  }

  void _drawLeaveBalances() {
    addSectionDivider(
      title: config.isRTL ? 'رصيد الإجازات' : 'Leave Balances',
      spacing: 10,
    );

    final hasDepartment = data.leaveBalances
        .any((e) => e.department != null && e.department!.trim().isNotEmpty);

    final grid = GeniusPdfDataGrid(
      config: config,
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
          flexFactor: 20,
        ),
        if (hasDepartment)
          const GeniusPdfGridColumn(
            id: 'department',
            title: 'Department',
            titleAr: 'القسم',
            flexFactor: 12,
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
                  if (hasDepartment)
                    'department': config.isRTL
                        ? (bal.departmentAr ?? bal.department ?? '-')
                        : (bal.department ?? '-'),
                  'entitled': bal.annualEntitlement,
                  'carry': bal.carryForward,
                  'annual': bal.annualUsed,
                  'sick': bal.sickUsed,
                  'unpaid': bal.unpaidUsed,
                  'balance': bal.annualBalance,
                },
              ))
          .toList(),
      style: GeniusPdfGridStyle.modern(),
    );

    addGrid(grid, spacing: 6);
    addSpace(8);
  }

  void _drawLeaveRequests() {
    addSectionDivider(
      title: config.isRTL ? 'طلبات الإجازة' : 'Leave Requests',
      spacing: 10,
    );

    final hasDepartment = data.leaveRequests
        .any((e) => e.department != null && e.department!.trim().isNotEmpty);
    final hasApprovedBy = data.leaveRequests
        .any((e) => e.approvedBy != null && e.approvedBy!.trim().isNotEmpty);

    final grid = GeniusPdfDataGrid(
      config: config,
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
          flexFactor: 20,
        ),
        if (hasDepartment)
          const GeniusPdfGridColumn(
            id: 'department',
            title: 'Department',
            titleAr: 'القسم',
            flexFactor: 12,
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
        if (hasApprovedBy)
          const GeniusPdfGridColumn(
            id: 'approvedBy',
            title: 'Approved By',
            titleAr: 'المعتمد',
            width: 75,
          ),
      ],
      rows: data.leaveRequests
          .map((leave) => GeniusPdfGridRow(
                cells: {
                  'id': leave.leaveId,
                  'employee': config.isRTL
                      ? (leave.employeeNameAr ?? leave.employeeName)
                      : leave.employeeName,
                  if (hasDepartment)
                    'department': config.isRTL
                        ? (leave.departmentAr ?? leave.department ?? '-')
                        : (leave.department ?? '-'),
                  'type': config.isRTL
                      ? leave.leaveTypeTextAr
                      : leave.leaveTypeText,
                  'from': _formatDate(leave.startDate),
                  'to': _formatDate(leave.endDate),
                  'days': leave.days,
                  'status':
                      config.isRTL ? leave.statusTextAr : leave.statusText,
                  if (hasApprovedBy)
                    'approvedBy': config.isRTL
                        ? (leave.approvedByAr ?? leave.approvedBy ?? '-')
                        : (leave.approvedBy ?? '-'),
                },
              ))
          .toList(),
      style: GeniusPdfGridStyle.modern(),
    );

    addGrid(grid, spacing: 6);
    addSpace(8);
  }

  void _drawLeaveTypeBreakdown() {
    if (data.leaveTypeBreakdown.isEmpty) return;

    if (currentY > pageHeight - 120) {
      newPage();
    }

    addSectionDivider(
      title: config.isRTL ? 'توزيع أنواع الإجازات' : 'Leave Type Breakdown',
      spacing: 10,
    );

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
      final labelX = config.isRTL ? pageWidth - 80 : 0.0;
      final barX = config.isRTL ? pageWidth - 85 - barWidth : 85.0;
      final valueX = config.isRTL ? barX - 55 : 90 + barWidth;

      currentPage.graphics.drawString(
        typeText,
        baseFont,
        bounds: Rect.fromLTWH(labelX, currentY, 80, barHeight),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle,
          textDirection: config.pdfTextDirection
        ),
      );

      currentPage.graphics.drawRectangle(
        brush: PdfSolidBrush(colors[colorIndex % colors.length]),
        bounds: Rect.fromLTWH(barX, currentY + 3, barWidth, barHeight - 6),
      );

      currentPage.graphics.drawString(
        '$days ${config.isRTL ? 'يوم' : 'days'}',
        config.configAssets == null
            ? config.baseFont
            : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 8,
                style: PdfFontStyle.regular),
        bounds: Rect.fromLTWH(valueX, currentY, 50, barHeight),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.middle,
          textDirection: config.pdfTextDirection
        ),
      );
      colorIndex++;
    }

    addSpace(15);
  }

  void _drawFooterSection() {
    if (!showNotes && (!showQRCode || reportId == null)) {
      return;
    }

    addSpace(20);

    // If only one section is shown, draw it normally
    if (showNotes && (!showQRCode || reportId == null)) {
      _drawNotes(width: pageWidth);
      return;
    }

    if (!showNotes && (showQRCode && reportId != null)) {
      _drawQRCodeSection(width: pageWidth);
      return;
    }

    // Draw side-by-side if both are present
    addTwoColumns(
      spacing: 10,
      leftFlex: config.isLTR ? 2 : 1,
      rightFlex: config.isLTR ? 1 : 2,
      leftContent: (page, bounds) {
        if (config.isLTR) {
          return _drawNotesContent(page, bounds);
        } else {
          return _drawQRCodeContent(page, bounds);
        }
      },
      rightContent: (page, bounds) {
        if (config.isLTR) {
          return _drawQRCodeContent(page, bounds);
        } else {
          return _drawNotesContent(page, bounds);
        }
      },
    );

    addSpace(20);
  }

  void _drawNotes({required double width}) {
    _drawNotesContent(currentPage, Rect.fromLTWH(0, currentY, width, 0));
  }

  double _drawNotesContent(PdfPage page, Rect bounds) {
    final displayNotes = notes ?? (config.isRTL ? notesAr : notes);
    final defaultNotes = config.isRTL
        ? '''ملاحظات:
• يمثل هذا التقرير طلبات وأرصدة الإجازات المسجلة في النظام.
• يرجى مراجعة الرصيد المتبقي قبل تقديم طلب جديد.
'''
        : '''Notes:
• This report represents leave requests and balances recorded in the system.
• Please checks remaining balance before submitting a new request.
''';

    final notesText = displayNotes ?? defaultNotes;

    final font = config.baseFont;
    final element = PdfTextElement(
      text: notesText,
      font: font,
      format: config.isLTR
          ? null
          : PdfStringFormat(
              textDirection: PdfTextDirection.rightToLeft,
              alignment: PdfTextAlignment.right),
    );

    final result = element.draw(
      page: page,
      bounds: bounds,
    );

    return result?.bounds.height ?? 0;
  }

  void _drawQRCodeSection({required double width}) {
    _drawQRCodeContent(currentPage, Rect.fromLTWH(0, currentY, width, 0));
  }

  double _drawQRCodeContent(PdfPage page, Rect bounds) {
    if (reportId == null) return 0;

    final qrUrl = 'https://localhost:443/report/$reportId';
    final caption = 'ID: $reportId';

    final captionFont = config.baseFont;
    final captionLayout = PdfTextElement(
      text: caption,
      font: captionFont,
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: config.pdfTextDirection
      ),
    ).draw(
        page: page,
        bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 0));

    final captionHeight = captionLayout?.bounds.height ?? 0;
    const qrSize = 80.0;
    final x = bounds.left + (bounds.width - qrSize) / 2;
    final y = bounds.top + captionHeight + 5;

    final urlQR = GeniusPdfQRCodeGenerator.url(
      url: qrUrl,
      config: config,
      caption: null,
    );

    urlQR.draw(
      page: page,
      bounds: Rect.fromLTWH(x, y, qrSize, qrSize),
    );

    return captionHeight + 5 + qrSize;
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
