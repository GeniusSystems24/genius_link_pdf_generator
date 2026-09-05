import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/ai_features/presentation/pages/ai_features_demo_screen.dart';
import 'package:genius_pdf_example/features/architecture/presentation/pages/v2_architecture_demo_screen.dart';
import 'package:genius_pdf_example/features/barcode/presentation/pages/barcode_demo_screen.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/pages/new_templates_demo_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components_demo_screen.dart';
import 'package:genius_pdf_example/features/custom_report/presentation/pages/custom_report_screen.dart';
import 'package:genius_pdf_example/features/dashboard/domain/models/dashboard_destination.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s00_baseline_regression_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s01_directionality_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s02_components_rtl_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s03_flow_layout_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s04_data_grid_vnext_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s05_formatting_theme_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s06_erp_domain_calculation_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s07_erp_semantic_components_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s09_migrated_transaction_templates_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s10_template_family_consolidation_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s11_print_profiles_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s08_erp_document_families_verification_page.dart';
import 'package:genius_pdf_example/features/export/presentation/pages/export_demo_screen.dart';
import 'package:genius_pdf_example/features/job_manager/presentation/pages/job_manager_demo_screen.dart';
import 'package:genius_pdf_example/features/modern_vouchers/presentation/pages/modern_vouchers_demo_screen.dart';
import 'package:genius_pdf_example/features/printing/presentation/pages/printing_demo_screen.dart';
import 'package:genius_pdf_example/features/security/presentation/pages/security_demo_screen.dart';
import 'package:genius_pdf_example/features/sharing/presentation/pages/sharing_demo_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples_showcase_screen.dart';
import 'package:genius_pdf_example/features/template_engine/presentation/pages/template_engine_demo_screen.dart';
import 'package:genius_pdf_example/features/templates/presentation/pages/templates_demo_screen.dart';

import 'package:genius_pdf_example/features/dashboard/presentation/pages/s12_sales_erp_pack_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s13_purchasing_erp_pack_verification_page.dart';

import 'package:genius_pdf_example/features/dashboard/presentation/pages/s14_accounting_finance_pack_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s15_inventory_wms_pack_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s16_pos_retail_pack_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s17_hr_payroll_pack_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s18_manufacturing_quality_pack_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s19_fixed_assets_projects_pack_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s20_maintenance_service_logistics_pack_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s21_crm_pack_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s22_template_engine_vnext_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s23_compliance_signing_archival_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s24_performance_regression_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s25_template_designer_verification_page.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/s26_industry_packs_verification_page.dart';
final class DashboardDestinationRegistry {
  const DashboardDestinationRegistry._();

  static const primaryDestinations = <DashboardDestination>[
    DashboardDestination(id: 'dashboard', title: 'Dashboard'),
    DashboardDestination(id: 's00_baseline', title: 'S00 Baseline'),
    DashboardDestination(id: 's01_directionality', title: 'S01 Directionality'),
    DashboardDestination(id: 's02_components_rtl', title: 'S02 Components RTL'),
    DashboardDestination(id: 's03_flow_layout', title: 'S03 Flow Layout'),
    DashboardDestination(
        id: 's04_data_grid_vnext', title: 'S04 DataGrid vNext'),
    DashboardDestination(
        id: 's05_formatting_theme', title: 'S05 Formatting & Theme'),
    DashboardDestination(
        id: 's06_erp_domain_calculation',
        title: 'S06 ERP Domain & Calculations'),
    DashboardDestination(
        id: 's07_erp_semantic_components',
        title: 'S07 ERP Semantic Components'),
    DashboardDestination(
        id: 's08_erp_document_families', title: 'S08 ERP Document Families'),
    DashboardDestination(
        id: 's09_migrated_transaction_templates',
        title: 'S09 Migrated Transaction Templates'),
    DashboardDestination(
        id: 's10_template_family_consolidation',
        title: 'S10 Template Family Consolidation'),
    DashboardDestination(id: 's11_print_profiles', title: 'S11 Print Profiles'),
    DashboardDestination(id: 's12_sales_erp_pack', title: 'S12 Sales ERP Pack'),
    DashboardDestination(
        id: 's13_purchasing_erp_pack', title: 'S13 Purchasing ERP Pack'),
    DashboardDestination(id: 's14_accounting_finance_pack', title: 'S14 Accounting & Finance Pack'),
    DashboardDestination(id: 's15_inventory_wms_pack', title: 'S15 Inventory & WMS Pack'),
    DashboardDestination(id: 's16_pos_retail_pack', title: 'S16 POS & Retail Pack'),
    DashboardDestination(id: 's17_hr_payroll_pack', title: 'S17 HR & Payroll Pack'),
    DashboardDestination(id: 's18_manufacturing_quality_pack', title: 'S18 Manufacturing & Quality Pack'),
    DashboardDestination(id: 's19_fixed_assets_projects_pack', title: 'S19 Fixed Assets & Projects Pack'),
    DashboardDestination(id: 's20_maintenance_service_logistics_pack', title: 'S20 Maintenance, Service & Logistics Pack'),
    DashboardDestination(id: 's21_crm_pack', title: 'S21 CRM Pack'),
    DashboardDestination(id: 's22_template_engine_vnext', title: 'S22 Template Engine vNext'),
    DashboardDestination(id: 's23_compliance_signing_archival', title: 'S23 Compliance, Signing & Archival'),
    DashboardDestination(id: 's24_performance_regression', title: 'S24 Performance & Regression'),
    DashboardDestination(id: 's25_template_designer', title: 'S25 Template Designer'),
    DashboardDestination(id: 's26_industry_packs', title: 'S26 Industry / Plugin Packs'),
    DashboardDestination(id: 'components', title: 'Components'),
    DashboardDestination(id: 'templates', title: 'Templates'),
    DashboardDestination(id: 'new_templates', title: 'Business Templates'),
    DashboardDestination(id: 'template_engine', title: 'Template Engine'),
    DashboardDestination(id: 'barcodes', title: 'Barcodes & QR'),
    DashboardDestination(id: 'security', title: 'Security'),
    DashboardDestination(id: 'export', title: 'Export'),
    DashboardDestination(id: 'printing', title: 'Printing'),
    DashboardDestination(id: 'sharing', title: 'Sharing'),
    DashboardDestination(id: 'ai_features', title: 'AI Features'),
    DashboardDestination(id: 'v2_architecture', title: 'Advanced Features'),
    DashboardDestination(id: 'examples', title: 'Examples'),
    DashboardDestination(id: 'job_manager', title: 'Job Manager'),
    DashboardDestination(id: 'custom_report', title: 'Custom Report'),
    DashboardDestination(id: 'modern_vouchers', title: 'Modern Vouchers'),
  ];

  static String titleFor(String id) => switch (id) {
        'dashboard' => 'Dashboard',
        's02_components_rtl' => 'S02 Components RTL',
        's03_flow_layout' => 'S03 Flow Layout',
        's04_data_grid_vnext' => 'S04 DataGrid vNext',
        's05_formatting_theme' => 'S05 Formatting & Theme',
        's06_erp_domain_calculation' => 'S06 ERP Domain & Calculations',
        's07_erp_semantic_components' => 'S07 ERP Semantic Components',
        's08_erp_document_families' => 'S08 ERP Document Families',
        's09_migrated_transaction_templates' =>
          'S09 Migrated Transaction Templates',
        's10_template_family_consolidation' =>
          'S10 Template Family Consolidation',
        's11_print_profiles' => 'S11 Print Profiles',
        's12_sales_erp_pack' => 'S12 Sales ERP Pack',
        's13_purchasing_erp_pack' => 'S13 Purchasing ERP Pack',
        's00_baseline' => 'S00 Baseline',
        's01_directionality' => 'S01 Directionality',
        'components' ||
        'data_grid' ||
        'rich_text' ||
        'info_box' ||
        'headers' ||
        'summary' ||
        'grid_qrcode' ||
        'grid_infobox' ||
        'grid_watermark' ||
        'grid_richtext' =>
          'Components',
        'templates' || 'templates_demo' || 'invoices' => 'Templates',
        'new_templates' ||
        'financial' ||
        'sales' ||
        'hr' =>
          'Business Templates',
        'template_engine' => 'Template Engine',
        'barcodes' => 'Barcodes & QR',
        'security' => 'Security',
        'export' => 'Export',
        'printing' => 'Printing',
        'sharing' => 'Sharing',
        'ai_features' => 'AI Features',
        'advanced' || 'v2_architecture' => 'Advanced Features',
        'examples' => 'Examples',
        'job_manager' => 'Job Manager',
        'custom_report' => 'Custom Report',
        'modern_vouchers' => 'Modern Vouchers',
        's14_accounting_finance_pack' => 'S14 Accounting & Finance Pack',
        's15_inventory_wms_pack' => 'S15 Inventory & WMS Pack',
        's16_pos_retail_pack' => 'S16 POS & Retail Pack',
        's17_hr_payroll_pack' => 'S17 HR & Payroll Pack',
        's18_manufacturing_quality_pack' => 'S18 Manufacturing & Quality Pack',
        's19_fixed_assets_projects_pack' => 'S19 Fixed Assets & Projects Pack',
        's20_maintenance_service_logistics_pack' => 'S20 Maintenance, Service & Logistics Pack',
        's21_crm_pack' => 'S21 CRM Pack',
        's22_template_engine_vnext' => 'S22 Template Engine vNext',
        's23_compliance_signing_archival' => 'S23 Compliance, Signing & Archival',
        's24_performance_regression' => 'S24 Performance & Regression',
        's25_template_designer' => 'S25 Template Designer',
        's26_industry_packs' => 'S26 Industry / Plugin Packs',
        _ => 'Genius PDF',
      };

  static Widget build(
    String id, {
    required ValueChanged<String> onNavigate,
  }) =>
      switch (id) {
        'dashboard' => DashboardHome(onNavigate: onNavigate),
        's00_baseline' => const S00BaselineRegressionVerificationPage(),
        's01_directionality' => const S01DirectionalityVerificationPage(),
        's02_components_rtl' => const S02ComponentsRtlVerificationPage(),
        's03_flow_layout' => const S03FlowLayoutVerificationPage(),
        's04_data_grid_vnext' => const S04DataGridVNextVerificationPage(),
        's05_formatting_theme' => const S05FormattingThemeVerificationPage(),
        's06_erp_domain_calculation' =>
          const S06ErpDomainCalculationVerificationPage(),
        's07_erp_semantic_components' =>
          const S07ErpSemanticComponentsVerificationPage(),
        's08_erp_document_families' =>
          const S08ErpDocumentFamiliesVerificationPage(),
        's09_migrated_transaction_templates' =>
          const S09MigratedTransactionTemplatesVerificationPage(),
        's10_template_family_consolidation' =>
          const S10TemplateFamilyConsolidationVerificationPage(),
        's11_print_profiles' => const S11PrintProfilesVerificationPage(),
        's12_sales_erp_pack' => const S12SalesErpPackVerificationPage(),
        's13_purchasing_erp_pack' =>
          const S13PurchasingErpPackVerificationPage(),
        'components' ||
        'data_grid' =>
          const ComponentsDemoScreen(initialTab: 0),
        'rich_text' => const ComponentsDemoScreen(initialTab: 1),
        'info_box' => const ComponentsDemoScreen(initialTab: 2),
        'headers' => const ComponentsDemoScreen(initialTab: 3),
        'summary' => const ComponentsDemoScreen(initialTab: 4),
        'grid_qrcode' => const ComponentsDemoScreen(initialTab: 5),
        'grid_infobox' => const ComponentsDemoScreen(initialTab: 6),
        'grid_watermark' => const ComponentsDemoScreen(initialTab: 7),
        'grid_richtext' => const ComponentsDemoScreen(initialTab: 8),
        'templates' ||
        'templates_demo' ||
        'invoices' =>
          const TemplatesDemoScreen(initialTab: 0),
        'new_templates' ||
        'financial' =>
          const NewTemplatesDemoScreen(initialTab: 0),
        'sales' => const NewTemplatesDemoScreen(initialTab: 1),
        'hr' => const NewTemplatesDemoScreen(initialTab: 2),
        'template_engine' => const TemplateEngineDemoScreen(),
        'barcodes' => const BarcodeDemoScreen(),
        'security' => const SecurityDemoScreen(),
        'export' => const ExportDemoScreen(),
        'printing' => const PrintingDemoScreen(),
        'sharing' => const SharingDemoScreen(),
        'ai_features' => const AiFeaturesDemoScreen(),
        'advanced' || 'v2_architecture' => const V2ArchitectureDemoScreen(),
        'examples' => const ExamplesShowcaseScreen(),
        'job_manager' => const JobManagerDemoScreen(),
        'custom_report' => const CustomReportScreen(),
        'modern_vouchers' => const ModernVouchersDemoScreen(),
        's14_accounting_finance_pack' => const S14AccountingFinancePackVerificationPage(),
        's15_inventory_wms_pack' => const S15InventoryWmsPackVerificationPage(),
        's16_pos_retail_pack' => const S16PosRetailPackVerificationPage(),
        's17_hr_payroll_pack' => const S17HrPayrollPackVerificationPage(),
        's18_manufacturing_quality_pack' => const S18ManufacturingQualityPackVerificationPage(),
        's19_fixed_assets_projects_pack' => const S19FixedAssetsProjectsPackVerificationPage(),
        's20_maintenance_service_logistics_pack' => const S20MaintenanceServiceLogisticsPackVerificationPage(),
        's21_crm_pack' => const S21CrmPackVerificationPage(),
        's22_template_engine_vnext' => const S22TemplateEngineVNextVerificationPage(),
        's23_compliance_signing_archival' => const S23ComplianceSigningArchivalVerificationPage(),
        's24_performance_regression' => const S24PerformanceRegressionVerificationPage(),
        's25_template_designer' => const S25TemplateDesignerVerificationPage(),
        's26_industry_packs' => const S26IndustryPacksVerificationPage(),
        _ => DashboardHome(onNavigate: onNavigate),
      };
}
