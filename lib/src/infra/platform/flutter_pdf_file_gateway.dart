import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';

import '../../app/contracts/pdf_generation_ports.dart';

class FlutterPdfFileGateway implements GeniusPdfFileGateway {
  const FlutterPdfFileGateway({
    this.documentsDirectoryProvider,
    this.temporaryDirectoryProvider,
  });

  final Future<Directory> Function()? documentsDirectoryProvider;
  final Future<Directory> Function()? temporaryDirectoryProvider;

  @override
  Future<String> documentsDirectoryPath() async =>
      (await (documentsDirectoryProvider?.call() ??
              getApplicationDocumentsDirectory()))
          .path;

  @override
  Future<String> temporaryDirectoryPath() async =>
      (await (temporaryDirectoryProvider?.call() ?? getTemporaryDirectory()))
          .path;

  @override
  Future<void> ensureDirectory(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  @override
  Future<void> writeBytes(String path, Uint8List bytes) async {
    await File(path).writeAsBytes(bytes);
  }

  @override
  Future<Uint8List> readBytes(String path) => File(path).readAsBytes();
}
