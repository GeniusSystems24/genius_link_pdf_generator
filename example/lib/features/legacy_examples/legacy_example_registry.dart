import 'dart:typed_data';

import 'package:flutter/material.dart' show TextDirection;
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart' hide TextDirection;

import '../../app/dependencies/example_dependencies.dart';
import '../components/models/documents/components/data_grid_demo_builder.dart';
import '../components/models/documents/components/grid_infobox_demo_builder.dart';
import '../components/models/documents/components/grid_qrcode_demo_builder.dart';
import '../components/models/documents/components/grid_richtext_demo_builder.dart';
import '../components/models/documents/components/grid_watermark_demo_builder.dart';
import '../components/models/documents/components/headers_demo_builder.dart';
import '../components/models/documents/components/info_box_demo_builder.dart';
import '../components/models/documents/components/rich_text_demo_builder.dart';
import '../components/models/documents/components/summary_demo_builder.dart';
import '../modern_vouchers/models/documents/modern_vouchers_demo_documents.dart';
import '../showcase/models/documents/advanced_layout_demo_document.dart';
import '../showcase/models/documents/auxiliary_voucher_demo_builder.dart';
import '../showcase/models/documents/banking_voucher_demo_builder.dart';
import '../showcase/models/documents/complete_voucher_demo_builder.dart';
import '../showcase/models/documents/multi_grid_summary_demo_document.dart';
import '../showcase/models/documents/new_templates_demo_documents.dart';
import '../showcase/models/documents/position_tracking_demo_document.dart';
import '../showcase/models/documents/qr_attachments_demo_document.dart';
import '../showcase/models/documents/remittance_voucher_demo_builder.dart';
import '../showcase/models/documents/report_composer_demo_document.dart';
import '../showcase/models/documents/trade_voucher_demo_builder.dart';
import '../showcase/models/documents/voucher_demo_builder.dart';
import '../templates/models/documents/templates_demo_documents.dart';

enum LegacyExampleMode { builder, bytes, reference }

class LegacyExampleDefinition {
  const LegacyExampleDefinition({
    required this.id,
    required this.group,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.descriptionAr,
    required this.mode,
    this.currentCoverage,
  });

  final String id;
  final String group;
  final String title;
  final String titleAr;
  final String description;
  final String descriptionAr;
  final LegacyExampleMode mode;
  final String? currentCoverage;
}

abstract final class LegacyExampleRegistry {
  static const examples = <LegacyExampleDefinition>[
    LegacyExampleDefinition(id: 'component-data-grid', group: 'Components', title: 'Data Grid', titleAr: 'جدول البيانات', description: 'Previous component DataGrid example.', descriptionAr: 'مثال جدول البيانات من الإصدار السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'component-rich-text', group: 'Components', title: 'Rich Text', titleAr: 'النص المنسق', description: 'Previous rich-text component example.', descriptionAr: 'مثال النص المنسق من الإصدار السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'component-info-box', group: 'Components', title: 'Info Box', titleAr: 'صندوق المعلومات', description: 'Previous info-box component example.', descriptionAr: 'مثال صندوق المعلومات من الإصدار السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'component-headers', group: 'Components', title: 'Headers', titleAr: 'الرؤوس', description: 'Previous header variants example.', descriptionAr: 'مثال أنواع الرؤوس من الإصدار السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'component-summary', group: 'Components', title: 'Summary', titleAr: 'الملخص', description: 'Previous summary component example.', descriptionAr: 'مثال الملخص من الإصدار السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'component-grid-qr', group: 'Components', title: 'Grid + QR', titleAr: 'جدول + QR', description: 'Data grid combined with QR.', descriptionAr: 'جدول بيانات مع رمز QR.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'component-grid-info', group: 'Components', title: 'Grid + Info Box', titleAr: 'جدول + معلومات', description: 'Data grid combined with information boxes.', descriptionAr: 'جدول بيانات مع صناديق معلومات.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'component-grid-watermark', group: 'Components', title: 'Grid + Watermark', titleAr: 'جدول + علامة مائية', description: 'Data grid watermark example.', descriptionAr: 'مثال جدول مع علامة مائية.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'component-grid-rich-text', group: 'Components', title: 'Grid + Rich Text', titleAr: 'جدول + نص منسق', description: 'Data grid and rich-text composition.', descriptionAr: 'دمج جدول البيانات مع النص المنسق.', mode: LegacyExampleMode.builder),

    LegacyExampleDefinition(id: 'template-tax-invoice', group: 'Templates', title: 'Tax Invoice', titleAr: 'فاتورة ضريبية', description: 'Previous tax invoice template.', descriptionAr: 'قالب الفاتورة الضريبية السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'template-trial-balance', group: 'Templates', title: 'Trial Balance', titleAr: 'ميزان مراجعة', description: 'Previous trial balance template.', descriptionAr: 'قالب ميزان المراجعة السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'template-customer-statement', group: 'Templates', title: 'Customer Statement', titleAr: 'كشف حساب عميل', description: 'Previous customer statement template.', descriptionAr: 'قالب كشف حساب العميل السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'template-inventory-report', group: 'Templates', title: 'Inventory Report', titleAr: 'تقرير مخزون', description: 'Previous inventory report template.', descriptionAr: 'قالب تقرير المخزون السابق.', mode: LegacyExampleMode.builder),

    LegacyExampleDefinition(id: 'business-balance-sheet', group: 'Business Templates', title: 'Balance Sheet', titleAr: 'الميزانية العمومية', description: 'Financial template example.', descriptionAr: 'مثال قالب مالي.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-income-statement', group: 'Business Templates', title: 'Income Statement', titleAr: 'قائمة الدخل', description: 'Financial template example.', descriptionAr: 'مثال قالب مالي.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-cash-flow', group: 'Business Templates', title: 'Cash Flow Statement', titleAr: 'قائمة التدفقات النقدية', description: 'Financial template example.', descriptionAr: 'مثال قالب مالي.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-budget', group: 'Business Templates', title: 'Budget Report', titleAr: 'تقرير الميزانية', description: 'Financial template example.', descriptionAr: 'مثال قالب مالي.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-quotation', group: 'Business Templates', title: 'Quotation', titleAr: 'عرض سعر', description: 'Sales document template.', descriptionAr: 'قالب مستند مبيعات.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-purchase-order', group: 'Business Templates', title: 'Purchase Order', titleAr: 'أمر شراء', description: 'Sales/procurement document template.', descriptionAr: 'قالب أمر شراء.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-delivery-note', group: 'Business Templates', title: 'Delivery Note', titleAr: 'إشعار تسليم', description: 'Delivery document template.', descriptionAr: 'قالب مستند تسليم.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-credit-note', group: 'Business Templates', title: 'Credit Note', titleAr: 'إشعار دائن', description: 'Credit-note template.', descriptionAr: 'قالب إشعار دائن.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-payslip', group: 'Business Templates', title: 'Payslip', titleAr: 'قسيمة راتب', description: 'HR template example.', descriptionAr: 'مثال قالب موارد بشرية.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-employee-report', group: 'Business Templates', title: 'Employee Report', titleAr: 'تقرير موظف', description: 'HR template example.', descriptionAr: 'مثال قالب موارد بشرية.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-attendance-report', group: 'Business Templates', title: 'Attendance Report', titleAr: 'تقرير حضور', description: 'HR template example.', descriptionAr: 'مثال قالب موارد بشرية.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'business-leave-report', group: 'Business Templates', title: 'Leave Report', titleAr: 'تقرير إجازات', description: 'HR template example.', descriptionAr: 'مثال قالب موارد بشرية.', mode: LegacyExampleMode.builder),

    LegacyExampleDefinition(id: 'showcase-advanced-layout', group: 'Examples Showcase', title: 'Advanced Layout', titleAr: 'التخطيط المتقدم', description: 'Previous advanced layout showcase.', descriptionAr: 'مثال التخطيط المتقدم السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'showcase-position-tracking', group: 'Examples Showcase', title: 'Position Tracking', titleAr: 'تتبع الموضع', description: 'Previous position tracking showcase.', descriptionAr: 'مثال تتبع الموضع السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'showcase-multi-grid-summary', group: 'Examples Showcase', title: 'Multi-Grid Summary', titleAr: 'ملخص متعدد الجداول', description: 'Previous multi-grid continuation showcase.', descriptionAr: 'مثال متابعة الجداول والملخص السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'showcase-qr-attachments', group: 'Examples Showcase', title: 'QR & Attachments', titleAr: 'QR والمرفقات', description: 'Previous QR and attachments showcase.', descriptionAr: 'مثال QR والمرفقات السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'showcase-report-composer', group: 'Examples Showcase', title: 'Report Composer', titleAr: 'منشئ التقارير', description: 'Previous fluent report composer showcase.', descriptionAr: 'مثال منشئ التقارير السابق.', mode: LegacyExampleMode.bytes),
    LegacyExampleDefinition(id: 'showcase-service-vouchers', group: 'Examples Showcase', title: 'Service Vouchers', titleAr: 'سندات الخدمات', description: 'Previous voucher batch showcase.', descriptionAr: 'مثال دفعة السندات السابق.', mode: LegacyExampleMode.bytes),
    LegacyExampleDefinition(id: 'showcase-banking-vouchers', group: 'Examples Showcase', title: 'Banking Vouchers', titleAr: 'السندات البنكية', description: 'Previous banking voucher showcase.', descriptionAr: 'مثال السندات البنكية السابق.', mode: LegacyExampleMode.bytes),
    LegacyExampleDefinition(id: 'showcase-remittance-vouchers', group: 'Examples Showcase', title: 'Remittance Vouchers', titleAr: 'سندات الحوالات', description: 'Previous remittance voucher showcase.', descriptionAr: 'مثال سندات الحوالات السابق.', mode: LegacyExampleMode.bytes),
    LegacyExampleDefinition(id: 'showcase-trade-vouchers', group: 'Examples Showcase', title: 'Trade Vouchers', titleAr: 'السندات التجارية', description: 'Previous trade voucher showcase.', descriptionAr: 'مثال السندات التجارية السابق.', mode: LegacyExampleMode.bytes),
    LegacyExampleDefinition(id: 'showcase-auxiliary-vouchers', group: 'Examples Showcase', title: 'Auxiliary Vouchers', titleAr: 'السندات المساعدة', description: 'Previous auxiliary voucher showcase.', descriptionAr: 'مثال السندات المساعدة السابق.', mode: LegacyExampleMode.bytes),
    LegacyExampleDefinition(id: 'showcase-complete-demo', group: 'Examples Showcase', title: 'Complete Demo', titleAr: 'المثال الكامل', description: 'Comprehensive previous voucher showcase.', descriptionAr: 'المثال الشامل للسندات من الإصدار السابق.', mode: LegacyExampleMode.bytes),

    LegacyExampleDefinition(id: 'voucher-sales', group: 'Modern Vouchers', title: 'Sales Voucher', titleAr: 'سند مبيعات', description: 'Previous modern sales voucher.', descriptionAr: 'سند المبيعات الحديث السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'voucher-purchase', group: 'Modern Vouchers', title: 'Purchase Voucher', titleAr: 'سند مشتريات', description: 'Previous modern purchase voucher.', descriptionAr: 'سند المشتريات الحديث السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'voucher-sales-return', group: 'Modern Vouchers', title: 'Sales Return', titleAr: 'مرتجع مبيعات', description: 'Previous modern sales-return voucher.', descriptionAr: 'سند مرتجع المبيعات السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'voucher-purchase-return', group: 'Modern Vouchers', title: 'Purchase Return', titleAr: 'مرتجع مشتريات', description: 'Previous modern purchase-return voucher.', descriptionAr: 'سند مرتجع المشتريات السابق.', mode: LegacyExampleMode.builder),
    LegacyExampleDefinition(id: 'voucher-b5-payment', group: 'Modern Vouchers', title: 'B5 Payment', titleAr: 'سند صرف B5', description: 'Previous B5 payment voucher.', descriptionAr: 'سند الصرف B5 السابق.', mode: LegacyExampleMode.builder),

    LegacyExampleDefinition(id: 'screen-template-engine', group: 'Previous Screens', title: 'Template Engine', titleAr: 'محرك القوالب', description: 'Previous interactive template-engine screen.', descriptionAr: 'شاشة محرك القوالب السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'Template engine vNext / Package Modules'),
    LegacyExampleDefinition(id: 'screen-barcodes', group: 'Previous Screens', title: 'Barcodes & QR', titleAr: 'الباركود وQR', description: 'Previous barcode and QR screen.', descriptionAr: 'شاشة الباركود وQR السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'Images, QR, barcodes & attachments'),
    LegacyExampleDefinition(id: 'screen-security', group: 'Previous Screens', title: 'Security', titleAr: 'الأمان', description: 'Previous security example screen.', descriptionAr: 'شاشة الأمان السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'Security / Package Modules'),
    LegacyExampleDefinition(id: 'screen-export', group: 'Previous Screens', title: 'Export', titleAr: 'التصدير', description: 'Previous export example screen.', descriptionAr: 'شاشة التصدير السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'Export / Package Modules'),
    LegacyExampleDefinition(id: 'screen-printing', group: 'Previous Screens', title: 'Printing', titleAr: 'الطباعة', description: 'Previous printing example screen.', descriptionAr: 'شاشة الطباعة السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'Printing module'),
    LegacyExampleDefinition(id: 'screen-sharing', group: 'Previous Screens', title: 'Sharing', titleAr: 'المشاركة', description: 'Previous sharing example screen.', descriptionAr: 'شاشة المشاركة السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'Sharing module'),
    LegacyExampleDefinition(id: 'screen-ai', group: 'Previous Screens', title: 'AI Features', titleAr: 'ميزات الذكاء الاصطناعي', description: 'Previous AI features screen.', descriptionAr: 'شاشة ميزات الذكاء الاصطناعي السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'AI features / Package Modules'),
    LegacyExampleDefinition(id: 'screen-architecture', group: 'Previous Screens', title: 'Advanced Features', titleAr: 'الميزات المتقدمة', description: 'Previous v2 architecture example screen.', descriptionAr: 'شاشة المعمارية المتقدمة السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'Architecture & dependency injection'),
    LegacyExampleDefinition(id: 'screen-job-manager', group: 'Previous Screens', title: 'Job Manager', titleAr: 'مدير المهام', description: 'Previous job-manager screen.', descriptionAr: 'شاشة مدير المهام السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'Job queues'),
    LegacyExampleDefinition(id: 'screen-custom-report', group: 'Previous Screens', title: 'Custom Report', titleAr: 'تقرير مخصص', description: 'Previous configurable custom-report screen.', descriptionAr: 'شاشة التقرير المخصص السابقة.', mode: LegacyExampleMode.reference, currentCoverage: 'Custom reports'),
  ];

  static GeniusPdfDocumentBuilder buildDocument(String id, {required GeniusPdfConfig config}) {
    final rtl = config.isRTL;
    return switch (id) {
      'component-data-grid' => DataGridDemoBuilder(config),
      'component-rich-text' => RichTextDemoBuilder(config),
      'component-info-box' => InfoBoxDemoBuilder(config),
      'component-headers' => HeadersDemoBuilder(config),
      'component-summary' => SummaryDemoBuilder(config),
      'component-grid-qr' => GridQrcodeDemoBuilder(config),
      'component-grid-info' => GridInfoboxDemoBuilder(config),
      'component-grid-watermark' => GridWatermarkDemoBuilder(config),
      'component-grid-rich-text' => GridRichtextDemoBuilder(config),
      'template-tax-invoice' => buildTaxInvoiceTemplate(isRtl: rtl),
      'template-trial-balance' => buildTrialBalanceTemplate(isRtl: rtl),
      'template-customer-statement' => buildCustomerStatementTemplate(isRtl: rtl),
      'template-inventory-report' => buildInventoryReportTemplate(isRtl: rtl),
      'business-balance-sheet' => buildBalanceSheetDemo(isRtl: rtl).builder,
      'business-income-statement' => buildIncomeStatementDemo(isRtl: rtl).builder,
      'business-cash-flow' => buildCashFlowDemo(isRtl: rtl).builder,
      'business-budget' => buildBudgetReportDemo(isRtl: rtl).builder,
      'business-quotation' => buildQuotationDemo(isRtl: rtl).builder,
      'business-purchase-order' => buildPurchaseOrderDemo(isRtl: rtl).builder,
      'business-delivery-note' => buildDeliveryNoteDemo(isRtl: rtl).builder,
      'business-credit-note' => buildCreditNoteDemo(isRtl: rtl).builder,
      'business-payslip' => buildPayslipDemo(isRtl: rtl).builder,
      'business-employee-report' => buildEmployeeReportDemo(isRtl: rtl).builder,
      'business-attendance-report' => buildAttendanceReportDemo(isRtl: rtl).builder,
      'business-leave-report' => buildLeaveReportDemo(isRtl: rtl).builder,
      'showcase-advanced-layout' => AdvancedLayoutDemoBuilder(config: config),
      'showcase-position-tracking' => PositionTrackingDemoBuilder(config: config),
      'showcase-multi-grid-summary' => MultiGridSummaryDemoBuilder(config: config),
      'showcase-qr-attachments' => QRAttachmentsDemoBuilder(config: config),
      'voucher-sales' => buildModernSalesVoucher(isRtl: rtl),
      'voucher-purchase' => buildModernPurchaseVoucher(isRtl: rtl),
      'voucher-sales-return' => buildModernSalesReturnVoucher(isRtl: rtl),
      'voucher-purchase-return' => buildModernPurchaseReturnVoucher(isRtl: rtl),
      'voucher-b5-payment' => buildB5PaymentVoucher(isRtl: rtl),
      _ => throw ArgumentError.value(id, 'id', 'Legacy example is not builder-backed'),
    };
  }

  static Uint8List buildBytes(String id, {required GeniusPdfConfig config}) {
    final bytes = switch (id) {
      'showcase-report-composer' => buildComposerDemoReport(config: config),
      'showcase-service-vouchers' => buildVoucherDemoReport(config: config),
      'showcase-banking-vouchers' => buildBankingVoucherDemoReport(config: config),
      'showcase-remittance-vouchers' => buildRemittanceVoucherDemoReport(config: config),
      'showcase-trade-vouchers' => buildTradeVoucherDemoReport(config: config),
      'showcase-auxiliary-vouchers' => buildAuxiliaryVoucherDemoReport(config: config),
      'showcase-complete-demo' => buildCompleteVoucherDemoReport(config: config),
      _ => throw ArgumentError.value(id, 'id', 'Legacy example is not byte-backed'),
    };
    return Uint8List.fromList(bytes);
  }

  static GeniusPdfConfig configFor(TextDirection direction) =>
      geniusPdfConfig.copyWith(textDirection: direction);
}
