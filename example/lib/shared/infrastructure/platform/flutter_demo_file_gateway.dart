import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'package:genius_pdf_example/shared/application/contracts/demo_file_gateway.dart';

final class FlutterDemoFileGateway implements DemoFileGateway {
  const FlutterDemoFileGateway();

  @override
  Future<String> saveBytes({
    required List<int> bytes,
    required String fileName,
    DemoStorageLocation location = DemoStorageLocation.documents,
  }) async {
    final directory = switch (location) {
      DemoStorageLocation.temporary => await getTemporaryDirectory(),
      DemoStorageLocation.documents => await getApplicationDocumentsDirectory(),
    };
    final normalizedName = fileName.contains('.') ? fileName : '$fileName.pdf';
    final file = File('${directory.path}/$normalizedName');
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  @override
  Future<String> saveAndOpen({
    required List<int> bytes,
    required String fileName,
    DemoStorageLocation location = DemoStorageLocation.documents,
  }) async {
    final path = await saveBytes(
      bytes: bytes,
      fileName: fileName,
      location: location,
    );
    await open(path);
    return path;
  }

  @override
  Future<void> open(String filePath) async {
    final result = await OpenFile.open(filePath);
    if (result.type != ResultType.done) {
      throw StateError(result.message);
    }
  }
}
