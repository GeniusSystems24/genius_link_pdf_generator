import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Security Access Report** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `security_access_example_screen.dart` and displayed as **Dart usage code**.
class GridWatermarkSecurityAccessDemoBuilder extends GeniusPdfDocumentBuilder {
  GridWatermarkSecurityAccessDemoBuilder(super.config);

  @override
  void build() {
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
