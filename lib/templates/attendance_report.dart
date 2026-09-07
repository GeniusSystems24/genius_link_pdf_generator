import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../src/presentation/document/components/components.dart';
import '../src/core/pdf_config.dart';

import 'erp_shared_layout.dart';
import '../src/presentation/document/families/erp/erp_families.dart';
/// Attendance status enum.
enum AttendanceStatus {
  present,
  absent,
  late,
  halfDay,
  leave,
  holiday,
  weekend,
}

/// Daily attendance record.
class DailyAttendance {
  const DailyAttendance({
    required this.date,
    required this.status,
    this.checkIn,
    this.checkOut,
    this.workingHours,
    this.overtimeHours,
    this.notes,
  });

  final DateTime date;
  final AttendanceStatus status;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final double? workingHours;
  final double? overtimeHours;
  final String? notes;

  String get statusText {
    switch (status) {
      case AttendanceStatus.present:
        return 'Present';
      case AttendanceStatus.absent:
        return 'Absent';
      case AttendanceStatus.late:
        return 'Late';
      case AttendanceStatus.halfDay:
        return 'Half Day';
      case AttendanceStatus.leave:
        return 'Leave';
      case AttendanceStatus.holiday:
        return 'Holiday';
      case AttendanceStatus.weekend:
        return 'Weekend';
    }
  }

  String get statusTextAr {
    switch (status) {
      case AttendanceStatus.present:
        return 'حاضر';
      case AttendanceStatus.absent:
        return 'غائب';
      case AttendanceStatus.late:
        return 'متأخر';
      case AttendanceStatus.halfDay:
        return 'نصف يوم';
      case AttendanceStatus.leave:
        return 'إجازة';
      case AttendanceStatus.holiday:
        return 'عطلة رسمية';
      case AttendanceStatus.weekend:
        return 'عطلة أسبوعية';
    }
  }
}

/// Employee attendance summary.
class AttendanceEmployeeSummary {
  const AttendanceEmployeeSummary({
    required this.employeeId,
    required this.employeeName,
    required this.attendance,
    this.employeeNameAr,
    this.department,
    this.departmentAr,
  });

  final String employeeId;
  final String employeeName;
  final String? employeeNameAr;
  final String? department;
  final String? departmentAr;
  final List<DailyAttendance> attendance;

  int get presentDays => attendance
      .where((a) =>
          a.status == AttendanceStatus.present ||
          a.status == AttendanceStatus.late)
      .length;
  int get absentDays =>
      attendance.where((a) => a.status == AttendanceStatus.absent).length;
  int get lateDays =>
      attendance.where((a) => a.status == AttendanceStatus.late).length;
  int get leaveDays =>
      attendance.where((a) => a.status == AttendanceStatus.leave).length;
  double get totalWorkingHours =>
      attendance.fold(0.0, (sum, a) => sum + (a.workingHours ?? 0));
  double get totalOvertimeHours =>
      attendance.fold(0.0, (sum, a) => sum + (a.overtimeHours ?? 0));
  double get attendanceRate {
    final workingDays = attendance
        .where((a) =>
            a.status != AttendanceStatus.holiday &&
            a.status != AttendanceStatus.weekend)
        .length;
    if (workingDays == 0) return 100;
    return (presentDays / workingDays) * 100;
  }
}

/// Attendance report data model.
class AttendanceReportData {
  const AttendanceReportData({
    required this.reportTitle,
    required this.periodStart,
    required this.periodEnd,
    required this.employees,
    this.reportTitleAr,
    this.showDailyDetails = true,
    this.showOvertime = true,
  });

  final String reportTitle;
  final String? reportTitleAr;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<AttendanceEmployeeSummary> employees;
  final bool showDailyDetails;
  final bool showOvertime;

  int get totalEmployees => employees.length;
  double get averageAttendanceRate {
    if (employees.isEmpty) return 0;
    return employees.fold(0.0, (sum, e) => sum + e.attendanceRate) /
        employees.length;
  }
}

/// A professional attendance report template.
///
/// Creates detailed attendance reports with daily tracking,
/// summary statistics, and overtime calculations.
///
/// ## Example
/// ```dart
/// final report = AttendanceReportTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: attendanceData,
/// );
///
/// final bytes = report.generate();
/// ```
class AttendanceReportTemplate extends GeniusErpRegisterDocument {
  AttendanceReportTemplate({
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
  final AttendanceReportData data;
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
    _drawEmployeeSummaryTable();

    if (data.showDailyDetails && data.employees.length <= 5) {
      _drawDailyDetails();
    }

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
          label: 'Employees',
          labelAr: 'الموظفون',
          value: '${data.totalEmployees}',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Daily Details',
          labelAr: 'تفاصيل يومية',
          value: data.showDailyDetails
              ? (config.isRTL ? 'نعم' : 'Yes')
              : (config.isRTL ? 'لا' : 'No'),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Overtime',
          labelAr: 'عمل إضافي',
          value: data.showOvertime
              ? (config.isRTL ? 'نعم' : 'Yes')
              : (config.isRTL ? 'لا' : 'No'),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Avg Rate',
          labelAr: 'متوسط النسبة',
          value: '${data.averageAttendanceRate.toStringAsFixed(1)}%',
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
          label: 'Total Employees',
          labelAr: 'عدد الموظفين',
          value: '${data.totalEmployees}',
        ),
        GeniusPdfSummaryItem(
          label: 'Avg Attendance Rate',
          labelAr: 'متوسط نسبة الحضور',
          value: '${data.averageAttendanceRate.toStringAsFixed(1)}%',
        ),
      ],
      style: const GeniusPdfSummaryStyle.minimal(),
      alignment: config.isRTL
          ? GeniusPdfSummaryAlignment.right
          : GeniusPdfSummaryAlignment.left,
    );

    addReportSummary(
      summary: summary,
      title: 'Overall Summary',
      titleAr: 'الملخص العام',
      spacing: 8,
    );
  }

  void _drawEmployeeSummaryTable() {
    addSectionDivider(
      title:
          config.isRTL ? 'ملخص حضور الموظفين' : 'Employee Attendance Summary',
      spacing: 10,
    );

    final hasDepartment = data.employees
        .any((e) => e.department != null && e.department!.trim().isNotEmpty);

    final columns = <GeniusPdfGridColumn>[
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
        id: 'present',
        title: 'Present',
        titleAr: 'حاضر',
        width: 55,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'absent',
        title: 'Absent',
        titleAr: 'غائب',
        width: 55,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'late',
        title: 'Late',
        titleAr: 'متأخر',
        width: 50,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'leave',
        title: 'Leave',
        titleAr: 'إجازة',
        width: 50,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'hours',
        title: 'Hours',
        titleAr: 'الساعات',
        width: 60,
        alignment: GeniusPdfTextAlign.center,
      ),
    ];

    if (data.showOvertime) {
      columns.add(const GeniusPdfGridColumn(
        id: 'overtime',
        title: 'OT',
        titleAr: 'إضافي',
        width: 50,
        alignment: GeniusPdfTextAlign.center,
      ));
    }

    columns.add(const GeniusPdfGridColumn(
      id: 'rate',
      title: 'Rate',
      titleAr: 'النسبة',
      width: 55,
      alignment: GeniusPdfTextAlign.center,
    ));

    final rows = data.employees.map((emp) {
      final cells = <String, dynamic>{
        'id': emp.employeeId,
        'name': config.isRTL
            ? (emp.employeeNameAr ?? emp.employeeName)
            : emp.employeeName,
        if (hasDepartment)
          'department': config.isRTL
              ? (emp.departmentAr ?? emp.department ?? '-')
              : (emp.department ?? '-'),
        'present': emp.presentDays,
        'absent': emp.absentDays,
        'late': emp.lateDays,
        'leave': emp.leaveDays,
        'hours': emp.totalWorkingHours.toStringAsFixed(1),
        'rate': '${emp.attendanceRate.toStringAsFixed(0)}%',
      };

      if (data.showOvertime) {
        cells['overtime'] = emp.totalOvertimeHours.toStringAsFixed(1);
      }

      return GeniusPdfGridRow(cells: cells);
    }).toList();

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: GeniusPdfGridStyle.modern(),
    );

    addGrid(grid, spacing: 6);
    addSpace(8);
  }

  void _drawDailyDetails() {
    for (final emp in data.employees) {
      final empName = config.isRTL
          ? (emp.employeeNameAr ?? emp.employeeName)
          : emp.employeeName;

      addSectionDivider(
        title: '$empName (${emp.employeeId})',
        spacing: 8,
      );

      // Daily attendance grid
      final grid = GeniusPdfDataGrid(
        config: config,
        columns: [
          const GeniusPdfGridColumn(
            id: 'date',
            title: 'Date',
            titleAr: 'التاريخ',
            width: 80,
          ),
          const GeniusPdfGridColumn(
            id: 'day',
            title: 'Day',
            titleAr: 'اليوم',
            width: 60,
          ),
          const GeniusPdfGridColumn(
            id: 'status',
            title: 'Status',
            titleAr: 'الحالة',
            width: 70,
            alignment: GeniusPdfTextAlign.center,
          ),
          const GeniusPdfGridColumn(
            id: 'checkIn',
            title: 'Check In',
            titleAr: 'الدخول',
            width: 70,
            alignment: GeniusPdfTextAlign.center,
          ),
          const GeniusPdfGridColumn(
            id: 'checkOut',
            title: 'Check Out',
            titleAr: 'الخروج',
            width: 70,
            alignment: GeniusPdfTextAlign.center,
          ),
          const GeniusPdfGridColumn(
            id: 'hours',
            title: 'Hours',
            titleAr: 'الساعات',
            width: 60,
            alignment: GeniusPdfTextAlign.center,
          ),
        ],
        rows: emp.attendance
            .map((att) => GeniusPdfGridRow(
                  cells: {
                    'date': _formatDate(att.date),
                    'day': _getDayName(att.date),
                    'status': config.isRTL ? att.statusTextAr : att.statusText,
                    'checkIn':
                        att.checkIn != null ? _formatTime(att.checkIn!) : '-',
                    'checkOut':
                        att.checkOut != null ? _formatTime(att.checkOut!) : '-',
                    'hours': att.workingHours?.toStringAsFixed(1) ?? '-',
                  },
                ))
            .toList(),
        style: GeniusPdfGridStyle.modern(),
      );

      addGrid(grid, spacing: 4);
      addSpace(10);
    }
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
• يرجى مراجعة سجل الحضور بدقة للتأكد من عدم وجود أخطاء.
• في حال وجود استفسارات، يرجى التواصل مع إدارة الموارد البشرية.
'''
        : '''Notes:
• Please review the attendance record carefully for any discrepancies.
• For inquiries, please contact the HR Department.
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


  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const daysAr = ['اثنين', 'ثلاثاء', 'أربعاء', 'خميس', 'جمعة', 'سبت', 'أحد'];
    final dayIndex = date.weekday - 1;
    return config.isRTL ? daysAr[dayIndex] : days[dayIndex];
  }
}
