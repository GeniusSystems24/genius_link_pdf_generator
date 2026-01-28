import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart' hide PdfTextStyle;

import '../builders/pdf_document_builder.dart';
import '../components/components.dart';
import '../core/pdf_config.dart';

/// Employee information for payslip.
class PayslipEmployee {
  const PayslipEmployee({
    required this.employeeId,
    required this.name,
    this.nameAr,
    this.department,
    this.departmentAr,
    this.designation,
    this.designationAr,
    this.joiningDate,
    this.bankName,
    this.bankAccount,
    this.nationalId,
  });

  final String employeeId;
  final String name;
  final String? nameAr;
  final String? department;
  final String? departmentAr;
  final String? designation;
  final String? designationAr;
  final DateTime? joiningDate;
  final String? bankName;
  final String? bankAccount;
  final String? nationalId;
}

/// Earnings item.
class EarningsItem {
  const EarningsItem({
    required this.description,
    required this.amount,
    this.descriptionAr,
  });

  final String description;
  final String? descriptionAr;
  final double amount;
}

/// Deductions item.
class DeductionsItem {
  const DeductionsItem({
    required this.description,
    required this.amount,
    this.descriptionAr,
  });

  final String description;
  final String? descriptionAr;
  final double amount;
}

/// Payslip data model.
class PayslipData {
  const PayslipData({
    required this.payPeriod,
    required this.payDate,
    required this.earnings,
    required this.deductions,
    this.workingDays,
    this.paidDays,
    this.leavesTaken,
    this.overtimeHours,
    this.notes,
    this.notesAr,
    this.currency = 'SAR',
  });

  final String payPeriod; // e.g., "January 2026"
  final DateTime payDate;
  final List<EarningsItem> earnings;
  final List<DeductionsItem> deductions;
  final int? workingDays;
  final int? paidDays;
  final int? leavesTaken;
  final double? overtimeHours;
  final String? notes;
  final String? notesAr;
  final String currency;

  double get totalEarnings =>
      earnings.fold(0, (sum, item) => sum + item.amount);
  double get totalDeductions =>
      deductions.fold(0, (sum, item) => sum + item.amount);
  double get netPay => totalEarnings - totalDeductions;
}

/// A professional payslip template.
///
/// Creates detailed payslips with earnings, deductions,
/// and net pay calculations.
///
/// ## Example
/// ```dart
/// final payslip = PayslipTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   employee: employeeInfo,
///   payslip: payslipData,
/// );
///
/// final bytes = payslip.generate();
/// ```
class PayslipTemplate extends GeniusPdfDocumentBuilder {
  PayslipTemplate({
    required GeniusPdfConfig config,
    required this.company,
    required this.employee,
    required this.payslip,
    this.boldFont,
    this.showBankDetails = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final PayslipEmployee employee;
  final PayslipData payslip;
  final PdfFont? boldFont;
  final bool showBankDetails;

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
    _drawEmployeeInfo();
    _drawPayPeriodInfo();
    _drawEarningsAndDeductions();
    _drawNetPay();

    if (payslip.notes != null || payslip.notesAr != null) {
      _drawNotes();
    }

    _drawFooter();
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      title: 'Payslip',
      titleAr: 'كشف راتب',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 20),
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

  void _drawEmployeeInfo() {
    final title = config.isRTL ? 'معلومات الموظف' : 'Employee Information';

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

    // Employee details grid
    final leftItems = [
      ('${config.isRTL ? 'رقم الموظف' : 'Employee ID'}:', employee.employeeId),
      (
        '${config.isRTL ? 'الاسم' : 'Name'}:',
        config.isRTL ? (employee.nameAr ?? employee.name) : employee.name
      ),
      (
        '${config.isRTL ? 'القسم' : 'Department'}:',
        config.isRTL
            ? (employee.departmentAr ?? employee.department ?? '-')
            : (employee.department ?? '-')
      ),
      (
        '${config.isRTL ? 'المسمى الوظيفي' : 'Designation'}:',
        config.isRTL
            ? (employee.designationAr ?? employee.designation ?? '-')
            : (employee.designation ?? '-')
      ),
    ];

    final rightItems = <(String, String)>[];
    if (employee.joiningDate != null) {
      rightItems.add((
        '${config.isRTL ? 'تاريخ الالتحاق' : 'Joining Date'}:',
        _formatDate(employee.joiningDate!)
      ));
    }
    if (employee.nationalId != null) {
      rightItems.add((
        '${config.isRTL ? 'رقم الهوية' : 'National ID'}:',
        employee.nationalId!
      ));
    }
    if (showBankDetails && employee.bankName != null) {
      rightItems
          .add(('${config.isRTL ? 'البنك' : 'Bank'}:', employee.bankName!));
    }
    if (showBankDetails && employee.bankAccount != null) {
      rightItems.add((
        '${config.isRTL ? 'رقم الحساب' : 'Account No'}:',
        employee.bankAccount!
      ));
    }

    final font = baseFont;
    var yOffset = currentY;

    for (var i = 0; i < leftItems.length || i < rightItems.length; i++) {
      if (i < leftItems.length) {
        final item = leftItems[i];
        currentPage.graphics.drawString(
          item.$1,
          _boldFont,
          bounds: Rect.fromLTWH(10, yOffset, 100, 16),
          format: PdfStringFormat(
            alignment:
                config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          ),
        );
        currentPage.graphics.drawString(
          item.$2,
          font,
          bounds: Rect.fromLTWH(110, yOffset, pageWidth * 0.4 - 110, 16),
          format: PdfStringFormat(
            alignment:
                config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          ),
        );
      }

      if (i < rightItems.length) {
        final item = rightItems[i];
        currentPage.graphics.drawString(
          item.$1,
          _boldFont,
          bounds: Rect.fromLTWH(pageWidth * 0.5, yOffset, 100, 16),
          format: PdfStringFormat(
            alignment:
                config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          ),
        );
        currentPage.graphics.drawString(
          item.$2,
          font,
          bounds: Rect.fromLTWH(
              pageWidth * 0.5 + 100, yOffset, pageWidth * 0.5 - 110, 16),
          format: PdfStringFormat(
            alignment:
                config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
          ),
        );
      }

      yOffset += 18;
    }

    addSpace((leftItems.length > rightItems.length
                ? leftItems.length
                : rightItems.length) *
            18 +
        10);
  }

  void _drawPayPeriodInfo() {
    final title = config.isRTL ? 'فترة الدفع' : 'Pay Period';

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(100, 149, 237)),
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

    final periodItems = [
      ('${config.isRTL ? 'الفترة' : 'Period'}:', payslip.payPeriod),
      (
        '${config.isRTL ? 'تاريخ الدفع' : 'Pay Date'}:',
        _formatDate(payslip.payDate)
      ),
      if (payslip.workingDays != null)
        (
          '${config.isRTL ? 'أيام العمل' : 'Working Days'}:',
          '${payslip.workingDays}'
        ),
      if (payslip.paidDays != null)
        (
          '${config.isRTL ? 'الأيام المدفوعة' : 'Paid Days'}:',
          '${payslip.paidDays}'
        ),
      if (payslip.leavesTaken != null)
        (
          '${config.isRTL ? 'الإجازات' : 'Leaves Taken'}:',
          '${payslip.leavesTaken}'
        ),
      if (payslip.overtimeHours != null)
        (
          '${config.isRTL ? 'ساعات العمل الإضافي' : 'Overtime Hours'}:',
          '${payslip.overtimeHours}'
        ),
    ];

    final font = baseFont;
    const itemsPerRow = 3;
    final itemWidth = pageWidth / itemsPerRow;

    for (var i = 0; i < periodItems.length; i++) {
      final item = periodItems[i];
      final col = i % itemsPerRow;
      final row = i ~/ itemsPerRow;
      final x = col * itemWidth;
      final y = currentY + (row * 20);

      currentPage.graphics.drawString(
        '${item.$1} ${item.$2}',
        font,
        bounds: Rect.fromLTWH(x + 10, y, itemWidth - 20, 18),
        format: PdfStringFormat(
          alignment:
              config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        ),
      );
    }

    final rows = (periodItems.length / itemsPerRow).ceil();
    addSpace(rows * 20 + 15);
  }

  void _drawEarningsAndDeductions() {
    final halfWidth = (pageWidth - 20) / 2;

    // Earnings section
    _drawSectionHeader(
      config.isRTL ? 'الإستحقاقات' : 'Earnings',
      0,
      halfWidth,
      PdfColor(46, 139, 87),
    );

    var earningsY = currentY + 25;
    for (final item in payslip.earnings) {
      _drawLineItem(
        config.isRTL
            ? (item.descriptionAr ?? item.description)
            : item.description,
        item.amount,
        0,
        halfWidth,
        earningsY,
      );
      earningsY += 18;
    }

    // Earnings total
    _drawTotalLine(
      config.isRTL ? 'إجمالي الإستحقاقات' : 'Total Earnings',
      payslip.totalEarnings,
      0,
      halfWidth,
      earningsY,
      PdfColor(46, 139, 87),
    );

    // Deductions section
    _drawSectionHeader(
      config.isRTL ? 'الإستقطاعات' : 'Deductions',
      halfWidth + 20,
      halfWidth,
      PdfColor(205, 92, 92),
    );

    var deductionsY = currentY + 25;
    for (final item in payslip.deductions) {
      _drawLineItem(
        config.isRTL
            ? (item.descriptionAr ?? item.description)
            : item.description,
        item.amount,
        halfWidth + 20,
        halfWidth,
        deductionsY,
      );
      deductionsY += 18;
    }

    // Deductions total
    _drawTotalLine(
      config.isRTL ? 'إجمالي الإستقطاعات' : 'Total Deductions',
      payslip.totalDeductions,
      halfWidth + 20,
      halfWidth,
      deductionsY,
      PdfColor(205, 92, 92),
    );

    final maxY = earningsY > deductionsY ? earningsY : deductionsY;
    addSpace(maxY - currentY + 35);
  }

  void _drawSectionHeader(
      String title, double x, double width, PdfColor color) {
    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(color),
      bounds: Rect.fromLTWH(x, currentY, width, 20),
    );

    currentPage.graphics.drawString(
      title,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(x + 5, currentY + 3, width - 10, 16),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );
  }

  void _drawLineItem(
      String description, double amount, double x, double width, double y) {
    final font = baseFont;

    currentPage.graphics.drawString(
      description,
      font,
      bounds: Rect.fromLTWH(x + 5, y, width * 0.6, 16),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    currentPage.graphics.drawString(
      _formatCurrency(amount),
      font,
      bounds: Rect.fromLTWH(x + width * 0.6, y, width * 0.4 - 5, 16),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );
  }

  void _drawTotalLine(String label, double amount, double x, double width,
      double y, PdfColor color) {
    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(240, 240, 240)),
      bounds: Rect.fromLTWH(x, y, width, 20),
    );

    currentPage.graphics.drawString(
      label,
      _boldFont,
      bounds: Rect.fromLTWH(x + 5, y + 3, width * 0.6, 16),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    currentPage.graphics.drawString(
      _formatCurrency(amount),
      _boldFont,
      brush: PdfSolidBrush(color),
      bounds: Rect.fromLTWH(x + width * 0.6, y + 3, width * 0.4 - 5, 16),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );
  }

  void _drawNetPay() {
    final netPayLabel = config.isRTL ? 'صافي الراتب' : 'Net Pay';

    currentPage.graphics.drawRectangle(
      brush: PdfSolidBrush(PdfColor(25, 25, 112)),
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 35),
    );

    currentPage.graphics.drawString(
      netPayLabel,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 14,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(15, currentY + 8, pageWidth * 0.5, 22),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    currentPage.graphics.drawString(
      _formatCurrency(payslip.netPay),
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 14,
              style: PdfFontStyle.bold),
      brush: PdfBrushes.white,
      bounds: Rect.fromLTWH(
          pageWidth * 0.5, currentY + 8, pageWidth * 0.5 - 15, 22),
      format: PdfStringFormat(alignment: PdfTextAlignment.right),
    );

    addSpace(45);
  }

  void _drawNotes() {
    final notesLabel = config.isRTL ? 'ملاحظات:' : 'Notes:';
    final notesText =
        config.isRTL ? (payslip.notesAr ?? payslip.notes!) : payslip.notes!;

    currentPage.graphics.drawString(
      '$notesLabel\n$notesText',
      baseFont,
      bounds: Rect.fromLTWH(0, currentY, pageWidth, 40),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
      ),
    );

    addSpace(45);
  }

  void _drawFooter() {
    final bottomY = pageHeight - 60;

    final disclaimer = config.isRTL
        ? 'هذا كشف راتب يتم إنشاؤه إلكترونياً ولا يتطلب توقيع.'
        : 'This is a computer-generated payslip and does not require a signature.';

    currentPage.graphics.drawString(
      disclaimer,
      config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 8,
              style: PdfFontStyle.italic),
      brush: PdfSolidBrush(PdfColor(128, 128, 128)),
      bounds: Rect.fromLTWH(0, bottomY, pageWidth, 20),
      format: PdfStringFormat(alignment: PdfTextAlignment.center),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatCurrency(double amount) {
    final formatted = amount.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$formatted ${payslip.currency}';
  }
}
