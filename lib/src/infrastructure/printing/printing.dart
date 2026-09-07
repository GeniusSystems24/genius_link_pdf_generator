/// Genius PDF Printing Module
///
/// Advanced printing features for PDF documents.
///
/// This module provides:
/// - [GeniusPrinterService] - Main service for printing, sharing, and rasterizing PDFs
/// - [GeniusPrinterDiscovery] - Discover and manage printers
/// - [GeniusPrintPreview] - Visual preview widget with settings adjustment
/// - [GeniusPrintPreviewEnhanced] - Enhanced preview with share and save options (v2.3.3+4)
/// - [GeniusPrintSettingsManager] - Save and manage print profiles
/// - [GeniusPrintSettings] - Comprehensive print settings configuration
/// - [GeniusPdfRasterResult] - PDF to image conversion results (v2.3.3+4)
/// - [GeniusPdfShareResult] - PDF sharing results (v2.3.3+4)
///
/// New in v2.3.3+4:
/// - PDF sharing via system share sheet
/// - PDF to image rasterization
/// - Save PDF to file
/// - Enhanced print preview with share/save buttons
/// - Improved printer discovery with capabilities detection
library;

export 'printer_models.dart';
export 'printer_discovery.dart';
export 'printer_service.dart';
export '../../presentation/printing/print_preview.dart';
export 'print_settings_manager.dart';
export '../../application/printing/print_preview_gateway.dart';
export '../../application/printing/print_preview_result.dart';
export '../../presentation/printing/ui/print_preview_controller.dart';
export 'profiles/print_profiles.dart';
