/// Export functionality for PDF documents.
///
/// This library provides comprehensive export capabilities for PDF documents,
/// supporting multiple formats including images (PNG, JPEG), HTML, plain text,
/// and PDF/A for long-term archival.
///
/// ## Quick Start
/// ```dart
/// import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
///
/// // Create export service
/// final service = GeniusPdfExportService();
///
/// // Export to PNG
/// final result = await service.export(
///   document,
///   GeniusExportConfiguration.image(format: GeniusExportFormat.png),
/// );
///
/// if (result is GeniusExportSuccess) {
///   print('Exported ${result.pageCount} pages');
///   print('File size: ${result.fileSizeFormatted}');
/// }
/// ```
///
/// ## Batch Export
/// ```dart
/// final exporter = GeniusBatchExporter();
///
/// final result = await exporter.exportAllToFormat(
///   documents,
///   GeniusExportConfiguration.html(),
///   outputDirectory: '/path/to/output',
/// );
///
/// print('Success rate: ${result.successRate}%');
/// ```
library ;

export 'batch_exporter.dart';
export 'export_models.dart';
export 'pdf_export_service.dart';
export 'pdf_to_html_exporter.dart';
export 'pdf_to_image_exporter.dart';
export 'pdf_to_text_exporter.dart';
