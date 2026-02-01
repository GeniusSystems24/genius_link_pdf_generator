import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

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
class AttendanceReportTemplate extends GeniusPdfDocumentBuilder {
  AttendanceReportTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final AttendanceReportData data;
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
    _drawEmployeeSummaryTable();

    if (data.showDailyDetails && data.employees.length <= 5) {
      _drawDailyDetails();
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

    header.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(0, 0, pageWidth, 100),
    );

    addSpace(105);
  }

  void _drawOverallSummary() {
    final title = config.isRTL ? 'الملخص العام' : 'Overall Summary';

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

    // Summary stats
    final stats = [
      (
        config.isRTL ? 'عدد الموظفين' : 'Total Employees',
        '${data.totalEmployees}'
      ),
      (
        config.isRTL ? 'متوسط نسبة الحضور' : 'Avg Attendance Rate',
        '${data.averageAttendanceRate.toStringAsFixed(1)}%'
      ),
    ];

    final font = baseFont;
    final itemWidth = pageWidth / stats.length;

    for (var i = 0; i < stats.length; i++) {
      final stat = stats[i];
      final x = i * itemWidth;

      currentPage.graphics.drawString(
        '${stat.$1}: ${stat.$2}',
        font,
        bounds: Rect.fromLTWH(x + 10, currentY, itemWidth - 20, 18),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        ),
      );
    }

    addSpace(30);
  }

  void _drawEmployeeSummaryTable() {
    final title =
        config.isRTL ? 'ملخص حضور الموظفين' : 'Employee Attendance Summary';

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
        flexFactor: 2,
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
      style: const GeniusPdfGridStyle.modern(),
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

  void _drawDailyDetails() {
    for (final emp in data.employees) {
      if (currentY > pageHeight - 150) {
        newPage();
      }

      final empName = config.isRTL
          ? (emp.employeeNameAr ?? emp.employeeName)
          : emp.employeeName;

      currentPage.graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(200, 200, 220)),
        bounds: Rect.fromLTWH(0, currentY, pageWidth, 20),
      );

      currentPage.graphics.drawString(
        '$empName (${emp.employeeId})',
        _boldFont,
        bounds: Rect.fromLTWH(5, currentY + 3, pageWidth - 10, 16),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        ),
      );

      addSpace(25);

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
        style: const GeniusPdfGridStyle.modern(),

      );

      final result = grid.drawAt(
        page: currentPage,
        x: 0,
        y: currentY,
        width: pageWidth,
      );

      if (result != null) {
        addSpace(result.bounds.height + 15);
      }
    }
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
