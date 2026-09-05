import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/src/app/application.dart';
import 'package:genius_link_pdf_generator/src/compose/pdf_composition_root.dart';
import 'package:genius_link_pdf_generator/src/domain/domain.dart';

void main() {
  test('composition root honors every injected port', () {
    const generator = _Generator();
    final files = _Files();
    const interactions = _Interactions();
    const processor = _Processor();
    const logger = _Logger();

    final runtime = GeniusPdfCompositionRoot.create(
      documentGenerator: generator,
      fileGateway: files,
      interactionGateway: interactions,
      documentProcessor: processor,
      logger: logger,
    );

    expect(identical(runtime.generator, generator), isTrue);
    expect(identical(runtime.files, files), isTrue);
    expect(identical(runtime.interactions, interactions), isTrue);
    expect(identical(runtime.processor, processor), isTrue);
    expect(identical(runtime.logger, logger), isTrue);
  });
}

class _Generator implements GeniusPdfDocumentGenerator {
  const _Generator();

  @override
  Future<Uint8List> generate(
    GeniusPdfBuildSource builder, {
    required bool runInBackground,
  }) async => Uint8List.fromList(builder.generate());
}

class _Files implements GeniusPdfFileGateway {
  @override
  Future<String> documentsDirectoryPath() async => '/documents';

  @override
  Future<void> ensureDirectory(String path) async {}

  @override
  Future<Uint8List> readBytes(String path) async => Uint8List(0);

  @override
  Future<String> temporaryDirectoryPath() async => '/temporary';

  @override
  Future<void> writeBytes(String path, Uint8List bytes) async {}
}

class _Interactions implements GeniusPdfInteractionGateway {
  const _Interactions();

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
  }) async => null;
}

class _Processor implements GeniusPdfDocumentProcessor {
  const _Processor();

  @override
  Future<GeniusPdfResult> addWatermark({
    required Uint8List pdfBytes,
    required String watermarkText,
    double opacity = 0.3,
    double rotation = -45,
    double fontSize = 72,
    String outputFileName = 'watermarked',
    GeniusPdfTextFlow textDirection = GeniusPdfTextFlow.ltr,
  }) async => GeniusPdfSuccess(bytes: pdfBytes, fileName: outputFileName);

  @override
  Future<GeniusPdfResult> extractPages({
    required Uint8List pdfBytes,
    required List<int> pageNumbers,
    required String outputFileName,
  }) async => GeniusPdfSuccess(bytes: pdfBytes, fileName: outputFileName);

  @override
  Future<GeniusPdfInfo?> getPdfInfo(Uint8List pdfBytes) async => null;

  @override
  Future<GeniusPdfMergeResult> mergePdfs({
    required List<Uint8List> pdfBytesList,
    required String outputFileName,
    bool saveToFile = false,
    GeniusPdfProgressCallback? onProgress,
    GeniusPdfCancellationToken? cancellationToken,
  }) async => GeniusPdfMergeResult.failure('unused');

  @override
  Future<GeniusPdfResult> rotatePages({
    required Uint8List pdfBytes,
    required int rotation,
    List<int>? pageNumbers,
    String outputFileName = 'rotated',
  }) async => GeniusPdfSuccess(bytes: pdfBytes, fileName: outputFileName);

  @override
  Future<GeniusPdfSplitResult> splitPdf({
    required Uint8List pdfBytes,
    required String baseFileName,
    int? pagesPerFile,
    List<List<int>>? pageRanges,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
  }) async => GeniusPdfSplitResult.failure('unused');
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
