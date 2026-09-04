/// PDF Components
///
/// A collection of reusable PDF components for building professional reports.
///
/// This library provides:
/// - [GeniusPdfDataGrid] - Flexible data tables with RTL support
/// - [GeniusPdfRichText] - Styled text with colors and links
/// - [GeniusPdfInfoBox] - Information boxes for grouped content
/// - [GeniusPdfReportHeader] - Professional report headers
/// - [GeniusPdfSummarySection] - Totals and calculations display
/// - [GeniusPdfSignatureArea] - Signature areas for documents
/// - [GeniusPdfQRCode] - QR code display component
/// - [GeniusPdfWatermark] - Watermarks (text, image, diagonal, tiled)
/// - [GeniusPdfDigitalSignature] - Digital signatures
/// - [GeniusPdfBarcode] - Barcodes (EAN-13, Code128, etc.)
/// - [GeniusPdfQRCodeGenerator] - Dynamic QR codes (URL, ZATCA, WiFi, vCard)
/// - S07 ERP semantic components: identity, party, address, money, tax, terms, approvals, metrics, labels, and null-safe composition.
library;

// Models
export 'models/pdf_styles.dart';
export 'models/grid_models.dart';
export 'models/security_models.dart';
export 'models/barcode_models.dart';

// Widgets
export 'widgets/pdf_data_grid.dart';
export 'widgets/pdf_rich_text.dart';
export 'widgets/pdf_info_box.dart';
export 'widgets/pdf_report_header.dart';
export 'widgets/pdf_summary.dart';

// Barcodes & QR Codes
export 'widgets/pdf_barcode.dart';

// Security
export 'widgets/pdf_watermark.dart';
export 'widgets/pdf_digital_signature.dart';

// ERP semantic components (S07)
export 'erp/erp_components.dart';
