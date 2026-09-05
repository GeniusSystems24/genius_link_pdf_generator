import 'dart:typed_data';

import '../../core/pdf_config.dart';
import '../app/print_preview_gateway.dart';
import '../app/print_preview_result.dart';
import '../printer_models.dart';
import '../printer_service.dart';

/// Adapter from preview use cases to the legacy printer service.
class GeniusPrinterServicePreviewGateway implements GeniusPrintPreviewGateway {
  const GeniusPrinterServicePreviewGateway({GeniusPrinterService? service})
      : _service = service;

  final GeniusPrinterService? _service;
  GeniusPrinterService get _printer => _service ?? GeniusPrinterService.instance;

  @override
  Future<GeniusPrintPreviewResult> print({
    required Uint8List pdfBytes,
    required String documentName,
    required GeniusPrintSettings settings,
    required GeniusPdfConfig config,
  }) async {
    final result = await _printer.printWithDialog(
      pdfBytes: pdfBytes,
      documentName: documentName,
      settings: settings,
      config: config,
    );
    return result.success
        ? const GeniusPrintPreviewResult.success()
        : GeniusPrintPreviewResult.failure(result.error ?? 'Printing failed.');
  }

  @override
  Future<GeniusPrintPreviewResult> share({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    final result = await _printer.sharePdf(
      pdfBytes: pdfBytes,
      fileName: fileName,
    );
    return result.success
        ? GeniusPrintPreviewResult.success(filePath: result.filePath)
        : GeniusPrintPreviewResult.failure(result.error ?? 'Sharing failed.');
  }

  @override
  Future<GeniusPrintPreviewResult> save({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    final result = await _printer.savePdfToFile(
      pdfBytes: pdfBytes,
      fileName: fileName,
    );
    return result.success
        ? GeniusPrintPreviewResult.success(filePath: result.filePath)
        : GeniusPrintPreviewResult.failure(result.error ?? 'Saving failed.');
  }
}
