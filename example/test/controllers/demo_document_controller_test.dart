import 'package:flutter_test/flutter_test.dart';
import 'package:genius_pdf_example/shared/application/contracts/demo_file_gateway.dart';
import 'package:genius_pdf_example/shared/presentation/controllers/demo_document_controller.dart';

void main() {
  test('document controller delegates persistence to its gateway', () async {
    final gateway = _FakeFileGateway();
    final controller = DemoDocumentController(files: gateway);

    final saved = await controller.save(
      bytes: const [1, 2, 3],
      fileName: 'sample.pdf',
    );
    await controller.open(saved);

    expect(saved, '/tmp/sample.pdf');
    expect(gateway.savedFileName, 'sample.pdf');
    expect(gateway.openedPath, '/tmp/sample.pdf');
  });
}

final class _FakeFileGateway implements DemoFileGateway {
  String? savedFileName;
  String? openedPath;

  @override
  Future<void> open(String filePath) async => openedPath = filePath;

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
  Future<String> saveBytes({
    required List<int> bytes,
    required String fileName,
    DemoStorageLocation location = DemoStorageLocation.documents,
  }) async {
    savedFileName = fileName;
    return '/tmp/$fileName';
  }
}
