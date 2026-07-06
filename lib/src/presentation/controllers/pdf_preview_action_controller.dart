import 'dart:typed_data';

import '../../application/contracts/pdf_generation_ports.dart';

/// MVC controller for preview actions.
///
/// This controller depends only on application ports. Platform plugins are
/// supplied by the composition root, which keeps presentation isolated from
/// infrastructure details.
class GeniusPdfPreviewActionController {
  const GeniusPdfPreviewActionController({
    required GeniusPdfFileGateway files,
    required GeniusPdfInteractionGateway interactions,
  })  : _files = files,
        _interactions = interactions;

  final GeniusPdfFileGateway _files;
  final GeniusPdfInteractionGateway _interactions;

  Future<void> print(Uint8List bytes, String documentName) async {
    if (bytes.isEmpty) return;
    await _interactions.printPdf(bytes, documentName);
  }

  Future<void> share(Uint8List bytes, String fileName) {
    if (bytes.isEmpty) return Future<void>.value();
    return _interactions.sharePdf(bytes, fileName);
  }

  Future<String> download(Uint8List bytes, String fileName) async {
    final directoryPath = await _files.documentsDirectoryPath();
    await _files.ensureDirectory(directoryPath);
    final effectiveName = fileName.endsWith('.pdf') ? fileName : '$fileName.pdf';
    final path = '$directoryPath/$effectiveName';
    await _files.writeBytes(path, bytes);
    return path;
  }

  Future<Uint8List> readFile(String path) => _files.readBytes(path);
}
