import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:genius_pdf_example/features/export/models/documents/template_image_export_examples.dart';
import 'package:genius_pdf_example/features/templates/models/documents/account_export_demo_documents.dart';
import 'package:genius_pdf_example/shared/presentation/controllers/demo_document_controller.dart';

Future<void> _appendBuilderImages({
  required GeniusPdfDocumentBuilder builder,
  required String fileName,
  required GeniusExportFormat format,
  required GeniusImageQuality quality,
  required DemoDocumentController documents,
  required List<Uint8List> pages,
  required List<String> filePaths,
}) async {
  PdfDocument? document;
  try {
    final pdfBytes = Uint8List.fromList(builder.generate());
    document = PdfDocument(inputBytes: pdfBytes);
    final results = await document.exportToImages(format: format, quality: quality);
    for (var index = 0; index < results.length; index++) {
      switch (results[index]) {
        case GeniusExportSuccess(:final data):
          pages.add(data);
          filePaths.add(await documents.saveBytes(
            bytes: data,
            fileName: '${fileName}_${index + 1}.${format.extension}',
          ));
        case GeniusExportFailure(:final message):
          throw StateError(message);
      }
    }
  } finally {
    document?.dispose();
    builder.dispose();
  }
}

/// Exports [SingleAccountImage] through the existing PDF-to-image pipeline.
Future<TemplateImageExportResult> exportSingleAccountImageDemo({
  required bool isRtl,
  required GeniusExportFormat format,
  required GeniusImageQuality quality,
  required DemoDocumentController documents,
}) async {
  final pages = <Uint8List>[];
  final paths = <String>[];
  await _appendBuilderImages(
    builder: buildSingleAccountImageDemo(isRtl: isRtl),
    fileName: 'single_account_image',
    format: format,
    quality: quality,
    documents: documents,
    pages: pages,
    filePaths: paths,
  );
  return TemplateImageExportResult(
    pages: pages,
    filePaths: paths,
    format: format,
    quality: quality,
  );
}

/// Splits a larger account set and exports one compact image per chunk.
Future<TemplateImageExportResult> exportMultiAccountImageDemo({
  required bool isRtl,
  required GeniusExportFormat format,
  required GeniusImageQuality quality,
  required DemoDocumentController documents,
}) async {
  final pages = <Uint8List>[];
  final paths = <String>[];
  final builders = buildMultiAccountImageDemos(isRtl: isRtl);
  for (final builder in builders) {
    await _appendBuilderImages(
      builder: builder,
      fileName: 'multi_account_image_${builder.imageIndex + 1}',
      format: format,
      quality: quality,
      documents: documents,
      pages: pages,
      filePaths: paths,
    );
  }
  return TemplateImageExportResult(
    pages: pages,
    filePaths: paths,
    format: format,
    quality: quality,
  );
}
