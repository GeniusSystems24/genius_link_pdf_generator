import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/src/application/application.dart';
import 'package:genius_link_pdf_generator/src/domain/domain.dart';

void main() {
  test('generation use case delegates through ports and disposes source', () async {
    final source = _BuildSource();
    final files = _MemoryFiles();
    final interactions = _Interactions();
    final service = GeniusPdfGenerationApplicationService(
      generator: const _Generator(),
      files: files,
      interactions: interactions,
      logger: const _Logger(),
    );

    final result = await service.generateAndSave(
      builder: source,
      fileName: 'report',
      runInBackground: false,
    );

    expect(result, isA<GeniusPdfSuccess>());
    expect((result as GeniusPdfSuccess).filePath, '/documents/report.pdf');
    expect(source.disposed, isTrue);
    expect(files.values['/documents/report.pdf'], isNotEmpty);
  });

  test('does not duplicate the PDF extension when saving', () async {
    final source = _BuildSource();
    final files = _MemoryFiles();
    final service = GeniusPdfGenerationApplicationService(
      generator: const _Generator(),
      files: files,
      interactions: _Interactions(),
      logger: const _Logger(),
    );

    final result = await service.generateAndSave(
      builder: source,
      fileName: 'report.pdf',
      runInBackground: false,
    );

    expect(result, isA<GeniusPdfSuccess>());
    expect((result as GeniusPdfSuccess).filePath, '/documents/report.pdf');
    expect(files.values.containsKey('/documents/report.pdf.pdf'), isFalse);
  });

  test('empty batch completes without division by zero', () async {
    final service = GeniusPdfGenerationApplicationService(
      generator: const _Generator(),
      files: _MemoryFiles(),
      interactions: _Interactions(),
      logger: const _Logger(),
    );
    final updates = <double>[];

    final results = await service.generateBatch(
      builders: const [],
      onProgress: (progress, _) => updates.add(progress),
    );

    expect(results, isEmpty);
    expect(updates, <double>[1]);
  });
}

class _BuildSource implements GeniusPdfBuildSource {
  bool disposed = false;

  @override
  String? get defaultOutputPath => null;

  @override
  List<int> generate() => <int>[1, 2, 3];

  @override
  void dispose() => disposed = true;
}

class _Generator implements GeniusPdfDocumentGenerator {
  const _Generator();

  @override
  Future<Uint8List> generate(
    GeniusPdfBuildSource builder, {
    required bool runInBackground,
  }) async =>
      Uint8List.fromList(builder.generate());
}

class _MemoryFiles implements GeniusPdfFileGateway {
  final Map<String, Uint8List> values = <String, Uint8List>{};

  @override
  Future<String> documentsDirectoryPath() async => '/documents';

  @override
  Future<String> temporaryDirectoryPath() async => '/temporary';

  @override
  Future<void> ensureDirectory(String path) async {}

  @override
  Future<Uint8List> readBytes(String path) async => values[path]!;

  @override
  Future<void> writeBytes(String path, Uint8List bytes) async {
    values[path] = bytes;
  }
}

class _Interactions implements GeniusPdfInteractionGateway {
  @override
  Future<void> openFile(String path) async {}

  @override
  Future<bool> printPdf(Uint8List bytes, String documentName) async => true;

  @override
  Future<void> sharePdf(Uint8List bytes, String fileName) async {}

  @override
  Future<Object?> shareWithOptions({
    required String filePath,
    String? subject,
    String? text,
  }) async =>
      null;
}

class _Logger implements GeniusPdfLogPort {
  const _Logger();

  @override
  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {}

  @override
  void info(String message, {String? tag}) {}
}
