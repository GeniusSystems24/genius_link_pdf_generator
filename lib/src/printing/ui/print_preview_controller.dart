import 'dart:typed_data';

import '../../core/pdf_config.dart';
import '../app/print_preview_gateway.dart';
import '../app/print_preview_result.dart';
import '../printer_models.dart';

/// MVC controller for print preview actions.
class GeniusPrintPreviewController {
  const GeniusPrintPreviewController({required this.gateway});

  final GeniusPrintPreviewGateway gateway;

  Future<GeniusPrintPreviewResult> print({
    required Uint8List pdfBytes,
    required String documentName,
    required GeniusPrintSettings settings,
    required GeniusPdfConfig config,
  }) =>
      gateway.print(
        pdfBytes: pdfBytes,
        documentName: documentName,
        settings: settings,
        config: config,
      );

  Future<GeniusPrintPreviewResult> share({
    required Uint8List pdfBytes,
    required String fileName,
  }) =>
      gateway.share(pdfBytes: pdfBytes, fileName: fileName);

  Future<GeniusPrintPreviewResult> save({
    required Uint8List pdfBytes,
    required String fileName,
  }) =>
      gateway.save(pdfBytes: pdfBytes, fileName: fileName);
}
