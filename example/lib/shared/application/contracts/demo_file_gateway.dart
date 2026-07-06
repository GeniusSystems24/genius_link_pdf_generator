enum DemoStorageLocation { temporary, documents }

abstract interface class DemoFileGateway {
  Future<String> saveBytes({
    required List<int> bytes,
    required String fileName,
    DemoStorageLocation location = DemoStorageLocation.documents,
  });

  Future<String> saveAndOpen({
    required List<int> bytes,
    required String fileName,
    DemoStorageLocation location = DemoStorageLocation.documents,
  });

  Future<void> open(String filePath);
}
