import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/contracts/pdf_generation_ports.dart';

class FlutterPdfInteractionGateway implements GeniusPdfInteractionGateway {
  const FlutterPdfInteractionGateway({
    this.openFileAction,
    this.sharePdfAction,
    this.printPdfAction,
  });

  final Future<void> Function(String path)? openFileAction;
  final Future<void> Function(Uint8List bytes, String fileName)? sharePdfAction;
  final Future<bool> Function(Uint8List bytes, String documentName)?
      printPdfAction;

  @override
  Future<void> openFile(String path) async {
    if (openFileAction != null) return openFileAction!(path);
    await OpenFile.open(path);
  }

  @override
  Future<void> sharePdf(Uint8List bytes, String fileName) async {
    if (sharePdfAction != null) return sharePdfAction!(bytes, fileName);
    await Printing.sharePdf(bytes: bytes, filename: fileName);
  }

  @override
  Future<bool> printPdf(Uint8List bytes, String documentName) {
    if (printPdfAction != null) return printPdfAction!(bytes, documentName);
    return Printing.layoutPdf(
      onLayout: (_) => bytes,
      name: documentName,
    );
  }

  @override
  Future<Object?> shareWithOptions({
    required String filePath,
    String? subject,
    String? text,
  }) {
    return SharePlus.instance.share(
      ShareParams(
        files: <XFile>[XFile(filePath, mimeType: 'application/pdf')],
        subject: subject,
        text: text,
      ),
    );
  }
}
