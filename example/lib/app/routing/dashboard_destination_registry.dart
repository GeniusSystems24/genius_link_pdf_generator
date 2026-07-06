import 'package:flutter/widgets.dart';

import 'package:genius_pdf_example/features/ai_features/presentation/pages/ai_features_demo_screen.dart';
import 'package:genius_pdf_example/features/architecture/presentation/pages/v2_architecture_demo_screen.dart';
import 'package:genius_pdf_example/features/barcode/presentation/pages/barcode_demo_screen.dart';
import 'package:genius_pdf_example/features/business_templates/presentation/pages/new_templates_demo_screen.dart';
import 'package:genius_pdf_example/features/components/presentation/pages/components_demo_screen.dart';
import 'package:genius_pdf_example/features/custom_report/presentation/pages/custom_report_screen.dart';
import 'package:genius_pdf_example/features/dashboard/domain/models/dashboard_destination.dart';
import 'package:genius_pdf_example/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:genius_pdf_example/features/export/presentation/pages/export_demo_screen.dart';
import 'package:genius_pdf_example/features/job_manager/presentation/pages/job_manager_demo_screen.dart';
import 'package:genius_pdf_example/features/modern_vouchers/presentation/pages/modern_vouchers_demo_screen.dart';
import 'package:genius_pdf_example/features/printing/presentation/pages/printing_demo_screen.dart';
import 'package:genius_pdf_example/features/security/presentation/pages/security_demo_screen.dart';
import 'package:genius_pdf_example/features/sharing/presentation/pages/sharing_demo_screen.dart';
import 'package:genius_pdf_example/features/showcase/presentation/pages/examples_showcase_screen.dart';
import 'package:genius_pdf_example/features/template_engine/presentation/pages/template_engine_demo_screen.dart';
import 'package:genius_pdf_example/features/templates/presentation/pages/templates_demo_screen.dart';

final class DashboardDestinationRegistry {
  const DashboardDestinationRegistry._();

  static const primaryDestinations = <DashboardDestination>[
    DashboardDestination(id: 'dashboard', title: 'Dashboard'),
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
        'components' || 'data_grid' || 'rich_text' || 'info_box' ||
        'headers' || 'summary' || 'grid_qrcode' || 'grid_infobox' ||
        'grid_watermark' || 'grid_richtext' => 'Components',
        'templates' || 'templates_demo' || 'invoices' => 'Templates',
        'new_templates' || 'financial' || 'sales' || 'hr' =>
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
        _ => 'Genius PDF',
      };

  static Widget build(
    String id, {
    required ValueChanged<String> onNavigate,
  }) =>
      switch (id) {
        'dashboard' => DashboardHome(onNavigate: onNavigate),
        'components' || 'data_grid' =>
          const ComponentsDemoScreen(initialTab: 0),
        'rich_text' => const ComponentsDemoScreen(initialTab: 1),
        'info_box' => const ComponentsDemoScreen(initialTab: 2),
        'headers' => const ComponentsDemoScreen(initialTab: 3),
        'summary' => const ComponentsDemoScreen(initialTab: 4),
        'grid_qrcode' => const ComponentsDemoScreen(initialTab: 5),
        'grid_infobox' => const ComponentsDemoScreen(initialTab: 6),
        'grid_watermark' => const ComponentsDemoScreen(initialTab: 7),
        'grid_richtext' => const ComponentsDemoScreen(initialTab: 8),
        'templates' || 'templates_demo' || 'invoices' =>
          const TemplatesDemoScreen(initialTab: 0),
        'new_templates' || 'financial' =>
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
        'advanced' || 'v2_architecture' =>
          const V2ArchitectureDemoScreen(),
        'examples' => const ExamplesShowcaseScreen(),
        'job_manager' => const JobManagerDemoScreen(),
        'custom_report' => const CustomReportScreen(),
        'modern_vouchers' => const ModernVouchersDemoScreen(),
        _ => DashboardHome(onNavigate: onNavigate),
      };
}
