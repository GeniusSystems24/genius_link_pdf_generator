part of '../printer_service.dart';

extension GeniusPrintBytesExtension on Uint8List {
  /// Prints this PDF data
  Future<GeniusPrintResult> print({
    required String documentName,
    GeniusPrintSettings? settings,
    required GeniusPdfConfig pdfConfig,
  }) {
    return GeniusPrinterService.instance.printWithDialog(
      pdfBytes: this,
      documentName: documentName,
      settings: settings,
      config: pdfConfig,
    );
  }

  /// Shares this PDF data
  Future<GeniusPdfShareResult> share({
    required String fileName,
    String? subject,
    String? text,
  }) {
    return GeniusPrinterService.instance.sharePdf(
      pdfBytes: this,
      fileName: fileName,
      subject: subject,
      text: text,
    );
  }

  /// Saves this PDF to a file
  Future<GeniusPdfShareResult> saveToFile({
    required String fileName,
    String? directory,
  }) {
    return GeniusPrinterService.instance.savePdfToFile(
      pdfBytes: this,
      fileName: fileName,
      directory: directory,
    );
  }

  /// Converts this PDF to images
  Future<GeniusPdfRasterResult> toImages({
    double dpi = 150,
    GeniusRasterFormat format = GeniusRasterFormat.png,
  }) {
    return GeniusPrinterService.instance.rasterPdf(
      pdfBytes: this,
      dpi: dpi,
      format: format,
    );
  }

  /// Gets a thumbnail of the first page
  Future<Uint8List?> toThumbnail({double dpi = 72}) {
    return GeniusPrinterService.instance.generateThumbnail(
      pdfBytes: this,
      dpi: dpi,
    );
  }
}
