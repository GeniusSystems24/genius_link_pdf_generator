        import 'package:flutter/material.dart';

        enum ShowcaseGroup {
          start,
          authoring,
          content,
          documents,
          delivery,
          operations,
          scale,
          integration,
          advanced,
        }

        enum ShowcasePageKind {
          dashboard,
          workbench,
          operations,
          jobs,
          gallery,
          module,
          legacy,
          reference,
        }

        enum ShowcaseDemoKind {
          none,
          basic,
          typography,
          directionality,
          headers,
          grid,
          media,
          advancedLayout,
          composer,
          taxInvoice,
          trialBalance,
          customerStatement,
          inventoryReport,
        }

        class ShowcaseDestination {
          const ShowcaseDestination({
            required this.id,
            required this.group,
            required this.title,
            required this.description,
            required this.icon,
            required this.kind,
            this.demo = ShowcaseDemoKind.none,
            this.api = const <String>[],
            this.keywords = const <String>[],
          });

          final String id;
          final ShowcaseGroup group;
          final String title;
          final String description;
          final IconData icon;
          final ShowcasePageKind kind;
          final ShowcaseDemoKind demo;
          final List<String> api;
          final List<String> keywords;
        }

        abstract final class ShowcaseCatalog {
          static const destinations = <ShowcaseDestination>[
            ShowcaseDestination(
              id: 'dashboard', group: ShowcaseGroup.start,
              title: 'Overview', description: 'Package capabilities and quick entry points.',
              icon: Icons.space_dashboard_outlined, kind: ShowcasePageKind.dashboard,
              keywords: ['home', 'dashboard', 'overview'],
            ),
            ShowcaseDestination(
              id: 'getting-started', group: ShowcaseGroup.start,
              title: 'Getting started', description: 'Load fonts, configure a document, generate bytes, and preview the result.',
              icon: Icons.rocket_launch_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.basic,
              api: ['GeniusPdfConfig', 'GeniusPdfDocumentBuilder', 'GeniusPdfClient'],
            ),
            ShowcaseDestination(
              id: 'document-builder', group: ShowcaseGroup.authoring,
              title: 'GeniusPdfDocumentBuilder', description: 'Fluent document authoring, position tracking, pagination and page lifecycle.',
              icon: Icons.description_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.basic,
              api: ['GeniusPdfDocumentBuilder', 'addLine', 'addSpace', 'newPage'],
            ),
            ShowcaseDestination(
              id: 'configuration', group: ShowcaseGroup.authoring,
              title: 'Configuration & page setup', description: 'Page size, orientation, margins, fonts, directionality, theme and formatter configuration.',
              icon: Icons.tune_outlined, kind: ShowcasePageKind.reference,
              api: ['GeniusPdfConfig', 'GeniusPdfPageSize', 'PdfPageOrientation', 'PdfMargins'],
            ),
            ShowcaseDestination(
              id: 'typography', group: ShowcaseGroup.content,
              title: 'Text & typography', description: 'Plain text, rich text, font roles, styling and technical content.',
              icon: Icons.text_fields_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.typography,
              api: ['addLine', 'addRichText', 'GeniusPdfRichText'],
            ),
            ShowcaseDestination(
              id: 'directionality', group: ShowcaseGroup.content,
              title: 'Arabic, RTL & bilingual', description: 'Arabic, RTL/LTR and bilingual document generation with per-document direction.',
              icon: Icons.translate_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.directionality,
              api: ['TextDirection.rtl', 'TextDirection.ltr', 'GeniusPdfConfig.copyWith'],
            ),
            ShowcaseDestination(
              id: 'headers-footers', group: ShowcaseGroup.content,
              title: 'Headers & footers', description: 'Report headers, page footers, page numbers and reusable document chrome.',
              icon: Icons.vertical_align_center_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.headers,
              api: ['addHeader', 'addFooter', 'addReportHeader'],
            ),
            ShowcaseDestination(
              id: 'tables-reports', group: ShowcaseGroup.content,
              title: 'Tables, grids & summaries', description: 'Data grids, groups, totals, summaries and report-oriented layouts.',
              icon: Icons.table_chart_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.grid,
              api: ['GeniusPdfDataGrid', 'GeniusPdfGridColumn', 'GeniusPdfSummarySection'],
            ),
            ShowcaseDestination(
              id: 'media', group: ShowcaseGroup.content,
              title: 'Images, QR, barcodes & attachments', description: 'QR codes, 1D/2D barcodes, image attachments and document media workflows supported by the package.',
              icon: Icons.qr_code_2_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.media,
              api: ['addQRCode', 'GeniusPdfBarcode', 'addImageAttachment', 'addImagePage', 'addAttachments'],
            ),
            ShowcaseDestination(
              id: 'reusable-components', group: ShowcaseGroup.content,
              title: 'Reusable PDF components', description: 'Info boxes, rich text, grids, summaries, headers and reusable composition blocks.',
              icon: Icons.widgets_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.advancedLayout,
              api: ['GeniusPdfInfoBox', 'GeniusPdfRichText', 'GeniusPdfReportHeader', 'addTwoColumns'],
            ),
            ShowcaseDestination(
              id: 'report-composer', group: ShowcaseGroup.documents,
              title: 'Fluent report composer', description: 'Compose paginated reports from headers, sections, grids and summaries.',
              icon: Icons.view_agenda_outlined, kind: ShowcasePageKind.reference,
              api: ['GeniusPdfReportComposer'],
            ),
            ShowcaseDestination(
              id: 'custom-reports', group: ShowcaseGroup.documents,
              title: 'Custom reports', description: 'Use reusable primitives to assemble application-specific reporting documents.',
              icon: Icons.analytics_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.advancedLayout,
            ),
            ShowcaseDestination(
              id: 'templates', group: ShowcaseGroup.documents,
              title: 'Templates', description: 'Explore the built-in tax invoice, trial balance, statement and inventory report templates.',
              icon: Icons.library_books_outlined, kind: ShowcasePageKind.gallery,
            ),
            ShowcaseDestination(
              id: 'business-documents', group: ShowcaseGroup.documents,
              title: 'Business documents', description: 'Practical invoice, finance, HR and operational document patterns from the repository examples.',
              icon: Icons.business_center_outlined, kind: ShowcasePageKind.gallery,
            ),
            ShowcaseDestination(
              id: 'preview', group: ShowcaseGroup.delivery,
              title: 'PDF preview', description: 'Embed GeniusPdfPreviewWidget and inspect generated bytes directly in the app.',
              icon: Icons.preview_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.basic,
              api: ['GeniusPdfPreviewWidget'],
            ),
            ShowcaseDestination(
              id: 'delivery', group: ShowcaseGroup.delivery,
              title: 'Save, open, share & print', description: 'Exercise the delivery methods exposed by GeniusPdfClient from one generated result.',
              icon: Icons.send_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.basic,
              api: ['generateAndSave', 'generateAndOpen', 'generateAndShare', 'print'],
            ),
            ShowcaseDestination(
              id: 'pdf-operations', group: ShowcaseGroup.operations,
              title: 'Existing PDF operations', description: 'Inspect, merge, split, extract, rotate and watermark generated PDFs.',
              icon: Icons.build_circle_outlined, kind: ShowcasePageKind.operations,
              api: ['getPdfInfo', 'mergePdfs', 'splitPdf', 'extractPages', 'rotatePages', 'addWatermark'],
            ),
            ShowcaseDestination(
              id: 'background-generation', group: ShowcaseGroup.scale,
              title: 'Background generation', description: 'Compare foreground and background generation using the stable client facade.',
              icon: Icons.memory_outlined, kind: ShowcasePageKind.workbench,
              demo: ShowcaseDemoKind.basic,
              api: ['GeniusPdfClient.generate(runInBackground: true)'],
            ),
            ShowcaseDestination(
              id: 'batch-generation', group: ShowcaseGroup.scale,
              title: 'Batch generation', description: 'Generate multiple independent document builders with one batch request.',
              icon: Icons.dynamic_feed_outlined, kind: ShowcasePageKind.reference,
              api: ['GeniusPdfClient.generateBatch'],
            ),
            ShowcaseDestination(
              id: 'job-queues', group: ShowcaseGroup.scale,
              title: 'Job queues', description: 'Queue, prioritize, observe, cancel and retry PDF generation jobs.',
              icon: Icons.queue_outlined, kind: ShowcasePageKind.jobs,
              api: ['GeniusPdfGenerationManager', 'GeniusPdfJobPriority', 'GeniusPdfJobStatus'],
            ),
            ShowcaseDestination(
              id: 'previous-examples', group: ShowcaseGroup.integration,
              title: 'Previous examples', description: 'All example coverage from the previous application, excluding S00-S26 verification screens.',
              icon: Icons.history_edu_outlined, kind: ShowcasePageKind.legacy,
              api: ['GeniusPdfDocumentBuilder', 'GeniusPdfClient', 'GeniusPdfGenerationManager'],
            ),
            ShowcaseDestination(
              id: 'architecture-di', group: ShowcaseGroup.integration,
              title: 'Architecture & dependency injection', description: 'Stable client facade, composition root, runtime injection and application-owned state.',
              icon: Icons.account_tree_outlined, kind: ShowcasePageKind.reference,
              api: ['GeniusPdfClient', 'GeniusPdfRuntime', 'GeniusPdfCompositionRoot'],
            ),
            ShowcaseDestination(
              id: 'testing', group: ShowcaseGroup.integration,
              title: 'Testing', description: 'Test document builders and inject runtime ports without coupling tests to platform plugins.',
              icon: Icons.science_outlined, kind: ShowcasePageKind.reference,
              api: ['GeniusPdfRuntime', 'GeniusPdfResult'],
            ),
            ShowcaseDestination(id: 'erp-families', group: ShowcaseGroup.advanced, title: 'ERP document families', description: 'Generic ERP families and semantic document contracts.', icon: Icons.account_tree_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'erp-packs', group: ShowcaseGroup.advanced, title: 'ERP packs overview', description: 'Shared ERP pack contracts and package-level exports.', icon: Icons.inventory_2_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'sales-pack', group: ShowcaseGroup.advanced, title: 'Sales pack', description: 'Sales transaction documents and related ERP workflows.', icon: Icons.point_of_sale_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'purchasing-pack', group: ShowcaseGroup.advanced, title: 'Purchasing pack', description: 'Purchase documents and procurement workflows.', icon: Icons.shopping_cart_checkout_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'accounting-pack', group: ShowcaseGroup.advanced, title: 'Accounting & finance pack', description: 'Accounting, finance and statement document workflows.', icon: Icons.account_balance_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'inventory-pack', group: ShowcaseGroup.advanced, title: 'Inventory & WMS pack', description: 'Inventory, warehouse and stock document workflows.', icon: Icons.warehouse_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'pos-pack', group: ShowcaseGroup.advanced, title: 'POS & retail pack', description: 'Retail receipts, labels, QR and barcode-oriented print workflows.', icon: Icons.receipt_long_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'hr-pack', group: ShowcaseGroup.advanced, title: 'HR & payroll pack', description: 'HR, payroll and employee document workflows.', icon: Icons.badge_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'manufacturing-pack', group: ShowcaseGroup.advanced, title: 'Manufacturing & quality pack', description: 'Manufacturing and quality document workflows.', icon: Icons.precision_manufacturing_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'assets-projects-pack', group: ShowcaseGroup.advanced, title: 'Fixed assets & projects pack', description: 'Asset, project and label-oriented document workflows.', icon: Icons.business_center_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'service-logistics-pack', group: ShowcaseGroup.advanced, title: 'Service & logistics pack', description: 'Service, shipment, tracking and logistics document workflows.', icon: Icons.local_shipping_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'crm-pack', group: ShowcaseGroup.advanced, title: 'CRM pack', description: 'CRM-oriented customer and commercial document workflows.', icon: Icons.handshake_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'template-engine-vnext', group: ShowcaseGroup.advanced, title: 'Template engine vNext', description: 'Schema-driven templates, bindings and rendering pipeline.', icon: Icons.schema_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'compliance', group: ShowcaseGroup.advanced, title: 'Compliance & archival', description: 'Compliance, signing, audit and archival profile APIs.', icon: Icons.verified_user_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'quality', group: ShowcaseGroup.advanced, title: 'Quality & regression', description: 'Performance, regression and verification utilities shipped by the package.', icon: Icons.fact_check_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'template-designer', group: ShowcaseGroup.advanced, title: 'Template designer model', description: 'Programmatic designer model and layout definition APIs.', icon: Icons.dashboard_customize_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'industry-packs', group: ShowcaseGroup.advanced, title: 'Industry packs', description: 'Optional industry/plugin pack API surface detected in this repository.', icon: Icons.extension_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'ai', group: ShowcaseGroup.advanced, title: 'AI features', description: 'Experimental AI-assisted PDF capabilities exposed by the package.', icon: Icons.auto_awesome_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'printing-module', group: ShowcaseGroup.advanced, title: 'Printing module', description: 'Advanced printing profiles and package printing integration.', icon: Icons.print_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'sharing-module', group: ShowcaseGroup.advanced, title: 'Sharing module', description: 'Extended sharing workflows and options.', icon: Icons.share_outlined, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'security', group: ShowcaseGroup.advanced, title: 'Security', description: 'PDF security workflows exposed by GeniusPdfSecurityService.', icon: Icons.lock_outline, kind: ShowcasePageKind.module),
        ShowcaseDestination(id: 'export', group: ShowcaseGroup.advanced, title: 'Export', description: 'Optional export services and supported output workflows.', icon: Icons.file_download_outlined, kind: ShowcasePageKind.module),
          ];
        }
