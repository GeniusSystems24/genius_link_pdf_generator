import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Builds a Grid + Watermark demo PDF document.
///
/// Demonstrates combining data grids with watermarks:
/// 1. Confidential audit report with watermark
/// 2. Security report with grid data
///
/// Note: Watermarks are applied at the document level after generation
/// using [GeniusPdfWatermark.applyToDocument] or page extensions.
class GridWatermarkDemoBuilder extends GeniusPdfDocumentBuilder {
  GridWatermarkDemoBuilder(super.config);

  @override
  void build() {
    // ================================================================
    // PAGE 1: Confidential Audit Report
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'جدول البيانات مع العلامة المائية — Grid + Watermark'
          : 'Data Grid with Watermark — Grid + Watermark',
      spacing: 10,
    );

    addLine(
      config.isRTL ? 'تقرير التدقيق السري' : 'Confidential Audit Report',
      font: config.boldFont,
      topMargin: 10,
    );

    addSpace(15);

    // Audit findings grid
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'finding',
            title: '#',
            titleAr: '#',
            width: 40,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn(
            id: 'area',
            title: 'Audit Area',
            titleAr: 'مجال التدقيق',
            width: 120,
          ),
          GeniusPdfGridColumn(
            id: 'finding_desc',
            title: 'Finding',
            titleAr: 'الملاحظة',
            width: 200,
          ),
          GeniusPdfGridColumn(
            id: 'severity',
            title: 'Severity',
            titleAr: 'الخطورة',
            width: 80,
            alignment: GeniusPdfTextAlign.center,
          ),
          GeniusPdfGridColumn(
            id: 'status',
            title: 'Status',
            titleAr: 'الحالة',
            width: 80,
            alignment: GeniusPdfTextAlign.center,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'finding': 1,
            'area': config.isRTL ? 'الأمن المعلوماتي' : 'IT Security',
            'finding_desc': config.isRTL
                ? 'ضعف في سياسة كلمات المرور'
                : 'Weak password policy detected',
            'severity': config.isRTL ? 'عالي' : 'High',
            'status': config.isRTL ? 'مفتوح' : 'Open',
          }),
          GeniusPdfGridRow(cells: {
            'finding': 2,
            'area': config.isRTL ? 'الشؤون المالية' : 'Finance',
            'finding_desc': config.isRTL
                ? 'عدم مطابقة في سجلات الدفع'
                : 'Payment records discrepancy',
            'severity': config.isRTL ? 'متوسط' : 'Medium',
            'status': config.isRTL ? 'قيد المعالجة' : 'In Progress',
          }),
          GeniusPdfGridRow(cells: {
            'finding': 3,
            'area': config.isRTL ? 'الموارد البشرية' : 'HR',
            'finding_desc': config.isRTL
                ? 'ملفات الموظفين غير مكتملة'
                : 'Incomplete employee files',
            'severity': config.isRTL ? 'منخفض' : 'Low',
            'status': config.isRTL ? 'مغلق' : 'Closed',
          }),
          GeniusPdfGridRow(cells: {
            'finding': 4,
            'area': config.isRTL ? 'العمليات' : 'Operations',
            'finding_desc': config.isRTL
                ? 'تأخر في اجراءات الموردين'
                : 'Vendor approval delays',
            'severity': config.isRTL ? 'متوسط' : 'Medium',
            'status': config.isRTL ? 'مفتوح' : 'Open',
          }),
        ],
        style: GeniusPdfGridStyle.corporate(),
      ),
      spacing: 10,
    );

    addSpace(20);

    // Summary info box
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملخص التدقيق' : 'Audit Summary',
        titleAr: 'ملخص التدقيق',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'إجمالي الملاحظات' : 'Total Findings',
            labelAr: 'إجمالي الملاحظات',
            value: '4',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'ملاحظات عالية الخطورة' : 'High Severity',
            labelAr: 'ملاحظات عالية الخطورة',
            value: '1',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: config.isRTL ? 'ملاحظات مغلقة' : 'Closed Findings',
            labelAr: 'ملاحظات مغلقة',
            value: '1 (25%)',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.warning(),
      ),
      spacing: 10,
    );

    // ================================================================
    // PAGE 2: Security Access Report
    // ================================================================
    newPage();

    addSectionDivider(
      title: config.isRTL
          ? 'مثال ٢: تقرير الوصول الأمني'
          : 'Example 2: Security Access Report',
      spacing: 10,
    );

    addSpace(15);

    // Access log grid
    addGrid(
      GeniusPdfDataGrid(
        config: config,
        columns: [
          GeniusPdfGridColumn(
            id: 'timestamp',
            title: 'Timestamp',
            titleAr: 'الوقت',
            width: 100,
          ),
          GeniusPdfGridColumn(
            id: 'user',
            title: 'User',
            titleAr: 'المستخدم',
            width: 100,
          ),
          GeniusPdfGridColumn(
            id: 'action',
            title: 'Action',
            titleAr: 'الإجراء',
            width: 120,
          ),
          GeniusPdfGridColumn(
            id: 'resource',
            title: 'Resource',
            titleAr: 'المورد',
            width: 120,
          ),
          GeniusPdfGridColumn(
            id: 'ip',
            title: 'IP Address',
            titleAr: 'عنوان IP',
            width: 100,
          ),
        ],
        rows: [
          GeniusPdfGridRow(cells: {
            'timestamp': '09:15:22',
            'user': 'admin@co.sa',
            'action': config.isRTL ? 'تسجيل دخول' : 'Login',
            'resource': config.isRTL ? 'لوحة التحكم' : 'Dashboard',
            'ip': '192.168.1.100',
          }),
          GeniusPdfGridRow(cells: {
            'timestamp': '09:23:45',
            'user': 'admin@co.sa',
            'action': config.isRTL ? 'تعديل' : 'Modify',
            'resource': config.isRTL ? 'إعدادات النظام' : 'System Config',
            'ip': '192.168.1.100',
          }),
          GeniusPdfGridRow(cells: {
            'timestamp': '10:05:12',
            'user': 'user1@co.sa',
            'action': config.isRTL ? 'عرض' : 'View',
            'resource': config.isRTL ? 'التقارير المالية' : 'Financial Reports',
            'ip': '192.168.1.105',
          }),
          GeniusPdfGridRow(cells: {
            'timestamp': '10:15:30',
            'user': 'unknown',
            'action': config.isRTL ? 'محاولة فاشلة' : 'Failed Attempt',
            'resource': config.isRTL ? 'ملفات سرية' : 'Confidential Files',
            'ip': '10.0.0.50',
          }),
          GeniusPdfGridRow(cells: {
            'timestamp': '11:30:00',
            'user': 'admin@co.sa',
            'action': config.isRTL ? 'تسجيل خروج' : 'Logout',
            'resource': config.isRTL ? 'الجلسة' : 'Session',
            'ip': '192.168.1.100',
          }),
        ],
        autoTotals: [
          GeniusPdfAutoTotal.count(
            label: 'Total Events',
            labelAr: 'إجمالي الأحداث',
            labelColumnId: 'action',
            columnIds: [],
          ),
        ],
        style: GeniusPdfGridStyle.invoice(),
      ),
      spacing: 10,
    );

    addSpace(20);

    // Note about watermark
    addInfoBox(
      GeniusPdfInfoBox(
        config: config,
        title: config.isRTL ? 'ملاحظة التطبيق' : 'Implementation Note',
        titleAr: 'ملاحظة التطبيق',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: '',
            value: config.isRTL
                ? 'يتم تطبيق العلامات المائية على مستوى المستند باستخدام GeniusPdfWatermark.applyToDocument() بعد إنشاء المحتوى'
                : 'Watermarks are applied at document level using GeniusPdfWatermark.applyToDocument() after content generation',
          ),
        ],
        style: GeniusPdfInfoBoxStyle.info(),
      ),
      spacing: 10,
    );

    // QR Code for verification
    addLine(
      config.isRTL ? 'رمز التحقق من التقرير' : 'Report Verification Code',
      font: config.boldFont,
      topMargin: 15,
    );

    addSpace(10);

    addQRCode(
      GeniusPdfQRCodeGenerator.url(
        url: 'https://verify.geniussystems.co/report/AUD-2026-0015',
        config: config,
      ),
      size: 80,
      alignment: GeniusPdfImageAlignment.center,
      spacing: 5,
    );
  }
}
