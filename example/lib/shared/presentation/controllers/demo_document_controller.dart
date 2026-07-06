import 'package:genius_pdf_example/shared/application/contracts/demo_file_gateway.dart';

/// Coordinates document persistence/opening for demo views.
///
/// Views depend on this controller, while platform details remain behind
/// [DemoFileGateway].
final class DemoDocumentController {
  const DemoDocumentController({required DemoFileGateway files}) : _files = files;

  final DemoFileGateway _files;

  Future<String> save({
    required List<int> bytes,
    required String fileName,
    DemoStorageLocation location = DemoStorageLocation.documents,
  }) =>
      _files.saveBytes(
        bytes: bytes,
        fileName: fileName,
        location: location,
      );

  Future<String> saveBytes({
    required List<int> bytes,
    required String fileName,
    DemoStorageLocation location = DemoStorageLocation.documents,
  }) =>
      save(bytes: bytes, fileName: fileName, location: location);

  Future<String> saveAndOpen({
    required List<int> bytes,
    required String fileName,
    DemoStorageLocation location = DemoStorageLocation.documents,
  }) =>
      _files.saveAndOpen(
        bytes: bytes,
        fileName: fileName,
        location: location,
      );

  Future<void> open(String filePath) => _files.open(filePath);
}
