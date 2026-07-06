import 'dart:typed_data';

/// Minimal source required by PDF generation use cases.
abstract interface class GeniusPdfBuildSource {
  String? get defaultOutputPath;
  List<int> generate();
  void dispose();
}

/// Optional capability for builders that provide their own isolate-safe
/// generation strategy. Existing builders do not need to implement it.
abstract interface class GeniusPdfBackgroundBuildSource
    implements GeniusPdfBuildSource {
  Future<Uint8List> generateInBackground();
}

/// Produces PDF bytes from a document source.
abstract interface class GeniusPdfDocumentGenerator {
  Future<Uint8List> generate(
    GeniusPdfBuildSource builder, {
    required bool runInBackground,
  });
}

/// Provides file-system operations required by PDF use cases.
abstract interface class GeniusPdfFileGateway {
  Future<String> documentsDirectoryPath();
  Future<String> temporaryDirectoryPath();
  Future<void> ensureDirectory(String path);
  Future<void> writeBytes(String path, Uint8List bytes);
  Future<Uint8List> readBytes(String path);
}

/// Provides platform interactions without coupling application logic to plugins.
abstract interface class GeniusPdfInteractionGateway {
  Future<void> openFile(String path);
  Future<void> sharePdf(Uint8List bytes, String fileName);
  Future<bool> printPdf(Uint8List bytes, String documentName);

  /// Returns the plugin-specific result as an opaque value.
  Future<Object?> shareWithOptions({
    required String filePath,
    String? subject,
    String? text,
  });
}

/// Minimal logging contract used by application and infrastructure services.
abstract interface class GeniusPdfLogPort {
  void info(String message, {String? tag});
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  });
}
