import 'dart:ui';
import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

import '../src/components/components.dart';
import '../src/core/pdf_config.dart';

import 'erp_shared_template_layout.dart';
import '../src/families/erp/erp_families.dart';
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
class EmployeeReportTemplate extends GeniusErpRegisterDocument {
  EmployeeReportTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.data,
    this.boldFont,
    this.showDepartmentSummary = true,
    this.reportId,
    this.printedBy,
    this.showQRCode = true,
    this.showSignatures = true,
    this.showNotes = true,
    this.notes,
    this.notesAr,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final EmployeeReportData data;
  final PdfFont? boldFont;
  final bool showDepartmentSummary;

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
        printTime: _formatDateDate(DateTime.now()),
        showPageNumber: true,
      );
    }

    newPage();

    _drawHeader();
    _drawReportInfo();
    _drawSummaryStats();

    if (showDepartmentSummary) {
      _drawDepartmentSummary();
    }

    _drawEmployeeTable();

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
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    addReportHeader(header, height: 100);
  }

  void _drawReportInfo() {
    final infoBox = GeniusPdfInfoBox(
      config: config,
      title: 'Report Details',
      titleAr: 'تفاصيل التقرير',
      columns: 2,
      showEmptyItems: true,
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Report Date',
          labelAr: 'تاريخ التقرير',
          value: _formatDate(data.reportDate),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Department',
          labelAr: 'القسم',
          value: data.departmentFilter ?? (config.isRTL ? 'الكل' : 'All'),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Status',
          labelAr: 'الحالة',
          value: config.isRTL
              ? _getStatusFilterTextAr(data.statusFilter)
              : _getStatusFilterText(data.statusFilter),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Show Salary',
          labelAr: 'إظهار الراتب',
          value: data.showSalary
              ? (config.isRTL ? 'نعم' : 'Yes')
              : (config.isRTL ? 'لا' : 'No'),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Contact Info',
          labelAr: 'بيانات التواصل',
          value: data.showContactInfo
              ? (config.isRTL ? 'نعم' : 'Yes')
              : (config.isRTL ? 'لا' : 'No'),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Currency',
          labelAr: 'العملة',
          value: data.currency,
        ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    addInfoBox(infoBox, spacing: 6);
  }

  void _drawSummaryStats() {
    final summary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem(
          label: 'Total Employees',
          labelAr: 'إجمالي الموظفين',
          value: '${data.totalEmployees}',
        ),
        GeniusPdfSummaryItem(
          label: 'Active',
          labelAr: 'نشط',
          value: '${data.activeEmployees}',
        ),
        GeniusPdfSummaryItem(
          label: 'On Leave',
          labelAr: 'في إجازة',
          value: '${data.onLeaveEmployees}',
        ),
      ],
      style: const GeniusPdfSummaryStyle.minimal(),
      alignment: GeniusPdfSummaryAlignment.left,
    );

    addReportSummary(
      summary: summary,
      title: 'Summary',
      titleAr: 'ملخص',
      spacing: 8,
    );
  }

  void _drawDepartmentSummary() {
    addSectionDivider(
      title: config.isRTL ? 'ملخص الأقسام' : 'Department Summary',
      spacing: 10,
    );

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
        const GeniusPdfGridColumn(
          id: 'activeRate',
          title: 'Active %',
          titleAr: 'نسبة النشط',
          width: 60,
          alignment: GeniusPdfTextAlign.center,
        ),
        const GeniusPdfGridColumn(
          id: 'leaveRate',
          title: 'Leave %',
          titleAr: 'نسبة الإجازة',
          width: 60,
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
                'activeRate': s.employeeCount == 0
                    ? '0%'
                    : '${((s.activeCount / s.employeeCount) * 100).toStringAsFixed(0)}%',
                'leaveRate': s.employeeCount == 0
                    ? '0%'
                    : '${((s.onLeaveCount / s.employeeCount) * 100).toStringAsFixed(0)}%',
              }))
          .toList(),
      style: GeniusPdfGridStyle.modern(),
    );

    addGrid(grid, spacing: 6);
    addSpace(10);
  }

  void _drawEmployeeTable() {
    addSectionDivider(
      title: config.isRTL ? 'قائمة الموظفين' : 'Employee List',
      spacing: 10,
    );

    final hasEmail = data.employees
        .any((e) => e.email != null && e.email!.trim().isNotEmpty);
    final hasManager = data.employees
        .any((e) => e.manager != null && e.manager!.trim().isNotEmpty);

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
        flexFactor: 20,
      ),
      const GeniusPdfGridColumn(
        id: 'department',
        title: 'Department',
        titleAr: 'القسم',
        flexFactor: 10,
      ),
      const GeniusPdfGridColumn(
        id: 'designation',
        title: 'Designation',
        titleAr: 'المسمى',
        flexFactor: 12,
      ),
      if (hasManager)
        const GeniusPdfGridColumn(
          id: 'manager',
          title: 'Manager',
          titleAr: 'المدير',
          flexFactor: 12,
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
            width: 80,
          ));
      if (hasEmail) {
        columns.insert(
          columns.length - 1,
          const GeniusPdfGridColumn(
            id: 'email',
            title: 'Email',
            titleAr: 'البريد',
            flexFactor: 2,
          ),
        );
      }
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
        if (hasManager)
          'manager': config.isRTL
              ? (emp.managerAr ?? emp.manager ?? '-')
              : (emp.manager ?? '-'),
        'joinDate': _formatDate(emp.joiningDate),
        'status': config.isRTL ? emp.statusTextAr : emp.statusText,
      };

      if (data.showContactInfo) {
        cells['phone'] = emp.phone ?? '-';
        if (hasEmail) {
          cells['email'] = emp.email ?? '-';
        }
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
      style: GeniusPdfGridStyle.modern(),
    );

    addGrid(grid, spacing: 6);
    addSpace(8);
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
• هذا التقرير سري وخاص بالموظفين المصرح لهم فقط.
• يرجى إبلاغ إدارة الموارد البشرية عن أي اختلافات.
'''
        : '''Notes:
• This report is confidential and for authorized personnel only.
• Please report any discrepancies to the HR Department.
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


  String _getStatusFilterText(EmployeeStatus? status) {
    if (status == null) return 'All';
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

  String _getStatusFilterTextAr(EmployeeStatus? status) {
    if (status == null) return 'الكل';
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
