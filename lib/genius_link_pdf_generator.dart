/// Genius Link PDF Generator
///
/// A comprehensive PDF generation and preview library for Flutter applications
/// with clean architecture design, RTL/LTR support, and seamless integration.
///
/// ## Features
///
/// - **Clean Architecture**: Well-organized code with separation of concerns
/// - **Fluent API**: Easy-to-use builder pattern for document creation
/// - **RTL/LTR Support**: Full support for Arabic, Hebrew, and other RTL languages
/// - **Background Processing**: Generate PDFs without blocking the UI
/// - **Preview Widgets**: Built-in widgets for PDF display and interaction
/// - **Asset Management**: Centralized font and image management
/// - **Reusable Components**: Data grids, rich text, info boxes, and more
/// - **Report Templates**: Tax invoices, trial balance, statements, and more
///
/// ## Quick Start
///
/// ```dart
/// // 1. Initialize assets at app startup
/// await GeniusPdfAssets.initialize(
///   fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din/din.ttf'),
/// );
///
/// // 2. Create a document builder
/// class InvoiceBuilder extends GeniusPdfDocumentBuilder {
///   InvoiceBuilder(super.config);
///
///   @override
///   void build() {
///     addLine('Invoice #123');
///     addLine('Total: \$100.00');
///   }
/// }
///
/// // 3. Generate and display
/// final service = GeniusPdfService();
/// await service.generateAndOpen(
///   builder: InvoiceBuilder(config),
///   fileName: 'invoice_123',
/// );
/// ```
///
/// ## Using Components
///
/// ```dart
/// // Create a data grid
/// final grid = GeniusPdfDataGrid(
///   columns: [
///     GeniusPdfGridColumn(id: 'name', title: 'Name', titleAr: 'الاسم'),
///     GeniusPdfGridColumn.currency(id: 'amount', title: 'Amount', titleAr: 'المبلغ'),
///   ],
///   rows: [
///     GeniusPdfGridRow(cells: {'name': 'Item 1', 'amount': 100.00}),
///     GeniusPdfGridRow.total({'name': 'Total', 'amount': 100.00}),
///   ],
/// );
///
/// // Draw on page
/// grid.draw(page: currentPage, bounds: bounds);
/// ```
///
/// ## Using Templates
///
/// ```dart
/// // Create a tax invoice
/// final invoice = TaxInvoiceTemplate(
///   config: pdfConfig,
///   company: companyInfo,
///   customer: customerInfo,
///   invoice: invoiceData,
/// );
///
/// final bytes = invoice.generate();
/// ```
///
/// See the [README.md] for complete documentation.
library;

// Legacy convenience re-export. New code should import Syncfusion directly or
// use `genius_link_pdf_generator_api.dart` for the stable package-owned API.
export 'package:syncfusion_flutter_pdf/pdf.dart';

// Core
export 'src/core/pdf_config.dart';
export 'src/core/pdf_formatter.dart';
export 'src/core/pdf_theme.dart';
export 'src/core/directionality.dart';
export 'src/core/pdf_assets.dart';
export 'src/core/pdf_logger.dart';
export 'src/core/pdf_print_theme.dart';
export 'src/domain/financial/financial.dart';
export 'src/domain/erp/erp.dart';

// Domain models
export 'src/models/pdf_image.dart';
export 'src/models/pdf_result.dart';
export 'src/domain/models/pdf_operations.dart';
export 'src/domain/models/pdf_delivery.dart';

// Composition and application contracts (optional advanced injection)
export 'src/compose/pdf_composition_root.dart';
export 'src/app/contracts/pdf_generation_ports.dart';
export 'src/app/contracts/pdf_document_processor.dart';

// Builders
export 'src/builders/pdf_document_builder.dart';

// Stable package-owned facade
export 'src/public/genius_pdf_client.dart';

// Services
export 'src/services/pdf_service.dart';
export 'src/services/pdf_generation_manager.dart';
export 'src/services/pdf_security_service.dart';

// Export
export 'src/services/export/export.dart';

// MVC presentation
export 'src/ui/views/pdf_preview.dart';
export 'src/ui/controllers/genius_pdf_controller.dart';
export 'src/ui/controllers/genius_pdf_preview_controller.dart';

// Extensions
export 'src/extensions/color_extensions.dart';
export 'src/extensions/datetime_extensions.dart';

// Components
export 'src/components/components.dart';

// ERP document families (S08)
export 'src/families/erp/erp_families.dart';

// Templates
export 'templates/templates.dart';

// Template Engine
export 'templates/engine/engine.dart';

// V2 Architecture
export 'src/core/v2/v2.dart';

// AI Features (v2.1.0)
export 'src/ai/ai.dart';

// Printing (v2.2.0)
export 'src/printing/printing.dart';

// Sharing (v2.3.0)
export 'src/sharing/sharing.dart';
export 'src/packs/packs.dart';
export 'src/engine_vnext/template_engine_vnext.dart';
export 'src/compliance/compliance.dart';
export 'src/quality/quality.dart';
export 'src/designer/template_designer.dart';
export 'src/industries/industry_pack_api.dart';
