import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

/// Employee status enum.
enum EmployeeStatus {
  active,
  inactive,
  onLeave,
  terminated,
  probation,
}

/// Employee record for report.
class EmployeeRecord {
  const EmployeeRecord({
    required this.employeeId,
    required this.name,
    required this.department,
    required this.designation,
    required this.joiningDate,
    required this.status,
    this.nameAr,
    this.departmentAr,
    this.designationAr,
    this.email,
    this.phone,
    this.salary,
    this.manager,
    this.managerAr,
  });

  final String employeeId;
  final String name;
  final String? nameAr;
  final String department;
  final String? departmentAr;
  final String designation;
  final String? designationAr;
  final DateTime joiningDate;
  final EmployeeStatus status;
  final String? email;
  final String? phone;
  final double? salary;
  final String? manager;
  final String? managerAr;

  String get statusText {
    switch (status) {
      case EmployeeStatus.active:
        return 'Active';
      case EmployeeStatus.inactive:
        return 'Inactive';
      case EmployeeStatus.onLeave:
        return 'On Leave';
      case EmployeeStatus.terminated:
        return 'Terminated';
      case EmployeeStatus.probation:
        return 'Probation';
    }
  }

  String get statusTextAr {
    switch (status) {
      case EmployeeStatus.active:
        return 'نشط';
      case EmployeeStatus.inactive:
        return 'غير نشط';
      case EmployeeStatus.onLeave:
        return 'في إجازة';
      case EmployeeStatus.terminated:
        return 'منتهي الخدمة';
      case EmployeeStatus.probation:
        return 'تحت التجربة';
    }
  }
}

/// Department summary for report.
class DepartmentSummary {
  const DepartmentSummary({
    required this.department,
    required this.employeeCount,
    this.departmentAr,
    this.activeCount = 0,
    this.onLeaveCount = 0,
  });

  final String department;
  final String? departmentAr;
  final int employeeCount;
  final int activeCount;
  final int onLeaveCount;
}

/// Employee report data model.
class EmployeeReportData {
  const EmployeeReportData({
    required this.reportTitle,
    required this.reportDate,
    required this.employees,
    this.reportTitleAr,
    this.departmentFilter,
    this.statusFilter,
    this.showSalary = false,
    this.showContactInfo = true,
    this.currency = 'SAR',
  });

  final String reportTitle;
  final String? reportTitleAr;
  final DateTime reportDate;
  final List<EmployeeRecord> employees;
  final String? departmentFilter;
  final EmployeeStatus? statusFilter;
  final bool showSalary;
  final bool showContactInfo;
  final String currency;

  int get totalEmployees => employees.length;
  int get activeEmployees =>
      employees.where((e) => e.status == EmployeeStatus.active).length;
  int get onLeaveEmployees =>
      employees.where((e) => e.status == EmployeeStatus.onLeave).length;

  List<DepartmentSummary> get departmentSummaries {
    final Map<String, List<EmployeeRecord>> deptMap = {};
    for (final emp in employees) {
      deptMap.putIfAbsent(emp.department, () => []).add(emp);
    }
    return deptMap.entries
        .map((e) => DepartmentSummary(
              department: e.key,
              employeeCount: e.value.length,
              activeCount: e.value
                  .where((emp) => emp.status == EmployeeStatus.active)
                  .length,
              onLeaveCount: e.value
                  .where((emp) => emp.status == EmployeeStatus.onLeave)
                  .length,
            ))
        .toList();
  }
}

/// A professional employee report template.
///
/// Creates comprehensive employee reports with filtering,
/// summary statistics, and detailed listings.
///
/// ## Example
/// ```dart
/// final report = EmployeeReportTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   data: employeeReportData,
/// );
///
/// final bytes = report.generate();
/// ```
class EmployeeReportTemplate extends GeniusPdfDocumentBuilder {
  EmployeeReportTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
    this.showDepartmentSummary = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final EmployeeReportData data;
  final PdfFont? boldFont;
  final bool showDepartmentSummary;

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
    _drawSummaryStats();

    if (showDepartmentSummary) {
      _drawDepartmentSummary();
    }

    _drawEmployeeTable();
  }

  void _drawHeader() {
    final title = config.isRTL
        ? (data.reportTitleAr ?? data.reportTitle)
        : data.reportTitle;

    final header = GeniusPdfReportHeader(
      config: config,
      title: title,
      subtitle: 'As of ${_formatDate(data.reportDate)}',
      subtitleAr: 'كما في ${_formatDate(data.reportDate)}',
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

  void _drawSummaryStats() {
    final title = config.isRTL ? 'ملخص' : 'Summary';

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
        config.isRTL ? 'إجمالي الموظفين' : 'Total Employees',
        data.totalEmployees,
        PdfColor(70, 130, 180)
      ),
      (
        config.isRTL ? 'نشط' : 'Active',
        data.activeEmployees,
        PdfColor(46, 139, 87)
      ),
      (
        config.isRTL ? 'في إجازة' : 'On Leave',
        data.onLeaveEmployees,
        PdfColor(255, 165, 0)
      ),
    ];

    final boxWidth = (pageWidth - 40) / stats.length;
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
            : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 20,
                style: PdfFontStyle.bold),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(x, currentY + 8, boxWidth, 25),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );

      currentPage.graphics.drawString(
        stat.$1,
        config.configAssets == null
            ? config.baseFont
            : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 9,
                style: PdfFontStyle.regular),
        brush: PdfBrushes.white,
        bounds: Rect.fromLTWH(x, currentY + 32, boxWidth, 16),
        format: PdfStringFormat(alignment: PdfTextAlignment.center),
      );
    }

    addSpace(60);
  }

  void _drawDepartmentSummary() {
    final title = config.isRTL ? 'ملخص الأقسام' : 'Department Summary';

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

    final summaries = data.departmentSummaries;
    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'department',
          title: 'Department',
          titleAr: 'القسم',
          flexFactor: 2,
        ),
        const GeniusPdfGridColumn(
          id: 'total',
          title: 'Total',
          titleAr: 'الإجمالي',
          width: 70,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'active',
          title: 'Active',
          titleAr: 'نشط',
          width: 70,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'onLeave',
          title: 'On Leave',
          titleAr: 'في إجازة',
          width: 70,
          alignment: GeniusPdfTextAlign.center,
        ),
      ],
      rows: summaries
          .map((s) => GeniusPdfGridRow(cells: {
                'department': config.isRTL
                    ? (s.departmentAr ?? s.department)
                    : s.department,
                'total': s.employeeCount,
                'active': s.activeCount,
                'onLeave': s.onLeaveCount,
              }))
          .toList(),
      style: const GeniusPdfGridStyle(showHeader: false),
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

  void _drawEmployeeTable() {
    final title = config.isRTL ? 'قائمة الموظفين' : 'Employee List';

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
        title: 'Name',
        titleAr: 'الاسم',
        flexFactor: 2,
      ),
      const GeniusPdfGridColumn(
        id: 'department',
        title: 'Department',
        titleAr: 'القسم',
        flexFactor: 1,
      ),
      const GeniusPdfGridColumn(
        id: 'designation',
        title: 'Designation',
        titleAr: 'المسمى',
        flexFactor: 1,
      ),
      const GeniusPdfGridColumn(
        id: 'joinDate',
        title: 'Join Date',
        titleAr: 'تاريخ الالتحاق',
        width: 80,
        alignment: GeniusPdfTextAlign.center,
      ),
      const GeniusPdfGridColumn(
        id: 'status',
        title: 'Status',
        titleAr: 'الحالة',
        width: 70,
        alignment: GeniusPdfTextAlign.center,
      ),
    ];

    if (data.showContactInfo) {
      columns.insert(
          columns.length - 1,
          const GeniusPdfGridColumn(
            id: 'phone',
            title: 'Phone',
            titleAr: 'الهاتف',
            width: 90,
          ));
    }

    if (data.showSalary) {
      columns.add(GeniusPdfGridColumn.currency(
        id: 'salary',
        title: 'Salary',
        titleAr: 'الراتب',
        width: 90,
        currencySymbol: '',
      ));
    }

    final rows = data.employees.map((emp) {
      final cells = <String, dynamic>{
        'id': emp.employeeId,
        'name': config.isRTL ? (emp.nameAr ?? emp.name) : emp.name,
        'department': config.isRTL
            ? (emp.departmentAr ?? emp.department)
            : emp.department,
        'designation': config.isRTL
            ? (emp.designationAr ?? emp.designation)
            : emp.designation,
        'joinDate': _formatDate(emp.joiningDate),
        'status': config.isRTL ? emp.statusTextAr : emp.statusText,
      };

      if (data.showContactInfo) {
        cells['phone'] = emp.phone ?? '-';
      }

      if (data.showSalary) {
        cells['salary'] = emp.salary ?? 0;
      }

      return GeniusPdfGridRow(cells: cells);
    }).toList();

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
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
      addSpace(result.bounds.height + 15);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
