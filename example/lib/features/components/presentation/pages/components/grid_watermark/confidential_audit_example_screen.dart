import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/components/presentation/widgets/component_example_detail_screen.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Dedicated screen for **Confidential Audit**.
///
/// The PDF is generated only after **Run example** is pressed. The code panel
/// displays the exact standalone builder source used to generate the preview.
class GridWatermarkConfidentialAuditExampleScreen extends StatelessWidget {
  const GridWatermarkConfidentialAuditExampleScreen({super.key});

  static const String dartUsageCode = r'''import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

/// Focused document builder for the **Confidential Audit** example.
///
/// This file contains only one logical example. It is also embedded verbatim
/// in `confidential_audit_example_screen.dart` and displayed as **Dart usage code**.
class GridWatermarkConfidentialAuditDemoBuilder extends GeniusPdfDocumentBuilder {
  GridWatermarkConfidentialAuditDemoBuilder(super.config);

  @override
  void build() {
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
  }
}''';

  @override
  Widget build(BuildContext context) {
    return  ComponentExampleDetailScreen(
      componentId: 'grid_watermark_confidential_audit',
      category: 'Components / Component Compositions / Grid + Watermark',
      title: pdfLocalization.confidentialAudit,
      apiName: 'GeniusPdfDataGrid + GeniusPdfWatermark',
      description: pdfLocalization.confidentialAuditFindingsGridDesc,
      icon: Icons.policy_outlined,
      usageCode: dartUsageCode,
    );
  }
}
