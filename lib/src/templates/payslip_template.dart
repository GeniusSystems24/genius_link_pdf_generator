import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart'
    hide PdfGridColumn, PdfGridRow, PdfGridStyle, PdfTextStyle;

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
    this.reportId,
    this.printedBy,
    this.showQRCode = true,
    this.showSignatures = true,
    this.showNotes = true,
  }) : super(config);

  final GeniusPdfCompanyInfo company;
  final PayslipEmployee employee;
  final PayslipData payslip;
  final PdfFont? boldFont;
  final bool showBankDetails;

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

  PdfFont get _boldFont =>
      boldFont ??
      (config.configAssets == null
          ? config.baseFont
          : PdfTrueTypeFont(config.configAssets!.primaryFont.toList(), 10,
              style: PdfFontStyle.bold));

  @override
  void build() {
    // Add footers on every page
    addFooter(
      userName: printedBy,
      printTime: _formatDate(DateTime.now()),
      showPageNumber: true,
    );

    newPage();

    _drawHeader();
    _drawEmployeeInfo();
    _drawPayPeriodInfo();
    _drawEarningsAndDeductions();
    _drawNetPay();

    // Draw Footer Section (Notes + QR Code)
    _drawFooterSection();

    // Standard Disclaimers / Signatures
    // Note: Payslips often don't need manual signatures if generated electronically,
    // but we support it if requested.
    if (showSignatures) {
      _drawSignatures();
    } else {
      _drawDigitalDisclaimer();
    }
  }

  void _drawHeader() {
    final header = GeniusPdfReportHeader(
      config: config,
      title: 'Payslip',
      titleAr: 'كشف راتب',
      company: company,
      printDate: DateTime.now(),
      style: const GeniusPdfReportHeaderStyle(
        titleStyle: GeniusPdfTextStyle.title(fontSize: 20),
        showBorder: false,
      ),
      layout: GeniusPdfReportHeaderLayout.standard,
    );

    addReportHeader(header, height: 100);
  }

  void _drawEmployeeInfo() {
    final infoItems = <GeniusPdfLabeledValue>[
      GeniusPdfLabeledValue(
        config: config,
        label: 'Employee ID',
        labelAr: 'رقم الموظف',
        value: employee.employeeId,
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Name',
        labelAr: 'الاسم',
        value:
            config.isRTL ? (employee.nameAr ?? employee.name) : employee.name,
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Department',
        labelAr: 'القسم',
        value: config.isRTL
            ? (employee.departmentAr ?? employee.department ?? '-')
            : (employee.department ?? '-'),
      ),
      GeniusPdfLabeledValue(
        config: config,
        label: 'Designation',
        labelAr: 'المسمى الوظيفي',
        value: config.isRTL
            ? (employee.designationAr ?? employee.designation ?? '-')
            : (employee.designation ?? '-'),
      ),
      if (employee.joiningDate != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Joining Date',
          labelAr: 'تاريخ الالتحاق',
          value: _formatDate(employee.joiningDate!),
        ),
      if (employee.nationalId != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'National ID',
          labelAr: 'رقم الهوية',
          value: employee.nationalId!,
        ),
      if (showBankDetails && employee.bankName != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Bank',
          labelAr: 'البنك',
          value: employee.bankName!,
        ),
      if (showBankDetails && employee.bankAccount != null)
        GeniusPdfLabeledValue(
          config: config,
          label: 'Account No',
          labelAr: 'رقم الحساب',
          value: employee.bankAccount!,
        ),
    ];

    final infoBox = GeniusPdfInfoBox(
      config: config,
      title: 'Employee Information',
      titleAr: 'معلومات الموظف',
      columns: 2,
      showEmptyItems: true,
      items: infoItems,
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    addInfoBox(infoBox, spacing: 6);
  }

  void _drawPayPeriodInfo() {
    final periodBox = GeniusPdfInfoBox(
      config: config,
      title: 'Pay Period',
      titleAr: 'فترة الدفع',
      columns: 3,
      showEmptyItems: true,
      items: [
        GeniusPdfLabeledValue(
          config: config,
          label: 'Period',
          labelAr: 'الفترة',
          value: payslip.payPeriod,
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Pay Date',
          labelAr: 'تاريخ الدفع',
          value: _formatDate(payslip.payDate),
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Working Days',
          labelAr: 'أيام العمل',
          value: payslip.workingDays?.toString() ?? '-',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Paid Days',
          labelAr: 'الأيام المدفوعة',
          value: payslip.paidDays?.toString() ?? '-',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Leaves Taken',
          labelAr: 'الإجازات',
          value: payslip.leavesTaken?.toString() ?? '-',
        ),
        GeniusPdfLabeledValue(
          config: config,
          label: 'Overtime Hours',
          labelAr: 'ساعات العمل الإضافي',
          value: payslip.overtimeHours?.toString() ?? '-',
        ),
      ],
      style: const GeniusPdfInfoBoxStyle.headerContent(),
    );

    addInfoBox(periodBox, spacing: 6);
  }

  void _drawEarningsAndDeductions() {
    final earningsRows = payslip.earnings
        .map((item) => (
              config.isRTL
                  ? (item.descriptionAr ?? item.description)
                  : item.description,
              item.amount,
            ))
        .toList();
    final deductionsRows = payslip.deductions
        .map((item) => (
              config.isRTL
                  ? (item.descriptionAr ?? item.description)
                  : item.description,
              item.amount,
            ))
        .toList();

    addTwoColumns(
      spacing: 6,
      gap: 16,
      leftContent: (page, bounds) {
        return _drawAmountGrid(
          page,
          bounds,
          title: 'Earnings',
          titleAr: 'الإستحقاقات',
          rows: earningsRows,
          totalLabel: config.isRTL ? 'إجمالي الإستحقاقات' : 'Total Earnings',
          total: payslip.totalEarnings,
        );
      },
      rightContent: (page, bounds) {
        return _drawAmountGrid(
          page,
          bounds,
          title: 'Deductions',
          titleAr: 'الإستقطاعات',
          rows: deductionsRows,
          totalLabel: config.isRTL ? 'إجمالي الإستقطاعات' : 'Total Deductions',
          total: payslip.totalDeductions,
        );
      },
    );
  }

  double _drawAmountGrid(
    PdfPage page,
    Rect bounds, {
    required String title,
    required String titleAr,
    required List<(String, double)> rows,
    required String totalLabel,
    required double total,
  }) {
    final displayTitle = config.isRTL ? titleAr : title;
    final titleHeight = _boldFont.height + 6;

    page.graphics.drawString(
      displayTitle,
      _boldFont,
      bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, titleHeight),
      format: PdfStringFormat(
        alignment:
            config.isRTL ? PdfTextAlignment.right : PdfTextAlignment.left,
        textDirection: config.pdfTextDirection
      ),
    );

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: [
        const GeniusPdfGridColumn(
          id: 'desc',
          title: 'Description',
          titleAr: 'الوصف',
          flexFactor: 2,
        ),
        GeniusPdfGridColumn.currency(
          id: 'amount',
          title: 'Amount',
          titleAr: 'المبلغ',
          width: 80,
          currencySymbol: '',
        ),
      ],
      rows: [
        ...rows.map((item) => GeniusPdfGridRow(
              cells: {
                'desc': item.$1,
                'amount': item.$2,
              },
            )),
        GeniusPdfGridRow.total({
          'desc': totalLabel,
          'amount': total,
        }),
      ],
      style: GeniusPdfGridStyle.modern(),
    );

    final result = grid.drawAt(
      page: page,
      x: bounds.left,
      y: bounds.top + titleHeight,
      width: bounds.width,
    );

    return (result?.bounds.bottom ?? (bounds.top + titleHeight)) - bounds.top;
  }

  void _drawNetPay() {
    final summary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem.subtotal(
          label: 'Total Earnings',
          labelAr: 'إجمالي الإستحقاقات',
          value: _formatCurrency(payslip.totalEarnings),
        ),
        GeniusPdfSummaryItem.subtotal(
          label: 'Total Deductions',
          labelAr: 'إجمالي الإستقطاعات',
          value: _formatCurrency(payslip.totalDeductions),
        ),
        GeniusPdfSummaryItem.total(
          label: 'Net Pay',
          labelAr: 'صافي الراتب',
          value: _formatCurrency(payslip.netPay),
        ),
      ],
      style: const GeniusPdfSummaryStyle.bordered(),
      alignment: GeniusPdfSummaryAlignment.right,
      width: pageWidth * 0.5,
    );

    addSummary(summary, spacing: 8);
  }

  void _drawFooterSection() {
    final notes = payslip.notes;
    final notesAr = payslip.notesAr;
    final hasNotes = (notes != null && notes.isNotEmpty) ||
        (notesAr != null && notesAr.isNotEmpty);

    if (!showNotes && (!showQRCode || reportId == null) && !hasNotes) {
      return;
    }

    addSpace(20);

    // If only one section is shown, draw it normally
    if (showNotes && (!showQRCode || reportId == null)) {
      _drawNotes(width: pageWidth);
      return;
    }

    if (!showNotes && (showQRCode && reportId != null) && !hasNotes) {
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
    // Payslip notes might be user provided or default
    final displayNotes =
        payslip.notes ?? (config.isRTL ? payslip.notesAr : payslip.notes);

    // Only show notes if they exist, payslips often don't have default generic notes
    // but if we want some defaults...
    final defaultNotes = config.isRTL
        ? '''ملاحظات:
• يرجى الاحتفاظ بهذا الكشف لسجلاتك.'''
        : '''Notes:
• Please keep this payslip for your records.''';

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

  void _drawSignatures() {
    if (currentY > pageHeight - 100) {
      newPage();
    }

    addSpace(20);
    addHorizontalLine(spacing: 10);
    final signatureY = currentY;

    // Prepared By
    final preparedBy = GeniusPdfSignatureArea(
      config: config,
      title: 'Prepared By',
      titleAr: 'أعده',
      lineWidth: 110,
      showDate: false,
    );

    preparedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
        config.isRTL ? pageWidth - 120 : 0,
        signatureY,
        120,
        60,
      ),
    );

    // HR manager or Approved by
    final approvedBy = GeniusPdfSignatureArea(
      config: config,
      title: 'Approved By',
      titleAr: 'اعتمده',
      lineWidth: 110,
      showDate: false,
    );

    approvedBy.draw(
      page: currentPage,
      bounds: Rect.fromLTWH(
        config.isRTL ? 0 : pageWidth - 120,
        signatureY,
        120,
        60,
      ),
    );

    addSpace(70);
  }

  void _drawDigitalDisclaimer() {
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
      format: PdfStringFormat(
        alignment: PdfTextAlignment.center,
        textDirection: config.pdfTextDirection
      ),
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
