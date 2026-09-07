import 'dart:typed_data';

import '../../core/pdf_config.dart';
import '../../infrastructure/printing/printer_models.dart';
import 'print_preview_result.dart';

/// Operations required by print-preview controllers.
abstract interface class GeniusPrintPreviewGateway {
  Future<GeniusPrintPreviewResult> print({
    required Uint8List pdfBytes,
    required String documentName,
    required GeniusPrintSettings settings,
    required GeniusPdfConfig config,
  });

  Future<GeniusPrintPreviewResult> share({
    required Uint8List pdfBytes,
    required String fileName,
  });

  Future<GeniusPrintPreviewResult> save({
    required Uint8List pdfBytes,
    required String fileName,
  });
}
