import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/src/app/application.dart';
import 'package:genius_link_pdf_generator/src/domain/domain.dart';

void main() {
  test('rejects empty watermark before invoking infrastructure', () async {
    final processor = _Processor();
    final service = GeniusPdfDocumentApplicationService(processor: processor);

    final result = await service.addWatermark(
      pdfBytes: Uint8List.fromList(<int>[1]),
      watermarkText: '   ',
    );

    expect(result, isA<GeniusPdfFailure>());
    expect(processor.watermarkCalls, 0);
  });

  test('rejects empty PDF input before invoking the processor', () async {
    final processor = _Processor();
    final service = GeniusPdfDocumentApplicationService(processor: processor);

    final result = await service.rotatePages(
      pdfBytes: Uint8List(0),
      rotation: 90,
    );

    expect(result, isA<GeniusPdfFailure>());
    expect(processor.rotateCalls, 0);
  });

  test('rejects invalid split configuration at the application boundary', () async {
    final processor = _Processor();
    final service = GeniusPdfDocumentApplicationService(processor: processor);

    final result = await service.splitPdf(
      pdfBytes: Uint8List.fromList(<int>[1]),
      baseFileName: 'sample',
      pagesPerFile: 0,
    );

    expect(result.success, isFalse);
    expect(processor.splitCalls, 0);
  });

  test('clamps watermark opacity at the application boundary', () async {
    final processor = _Processor();
    final service = GeniusPdfDocumentApplicationService(processor: processor);

    await service.addWatermark(
      pdfBytes: Uint8List.fromList(<int>[1]),
      watermarkText: 'Draft',
      opacity: 4,
    );

    expect(processor.opacity, 1);
  });
}

class _Processor implements GeniusPdfDocumentProcessor {
  int watermarkCalls = 0;
  int rotateCalls = 0;
  int splitCalls = 0;
  double? opacity;

  @override
  Future<GeniusPdfResult> addWatermark({
    required Uint8List pdfBytes,
    required String watermarkText,
    double opacity = 0.3,
    double rotation = -45,
    double fontSize = 72,
    String outputFileName = 'watermarked',
    GeniusPdfTextFlow textDirection = GeniusPdfTextFlow.ltr,
  }) async {
    watermarkCalls++;
    this.opacity = opacity;
    return GeniusPdfSuccess(bytes: pdfBytes, fileName: outputFileName);
  }

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
  }) async {
    rotateCalls++;
    return GeniusPdfSuccess(bytes: pdfBytes, fileName: outputFileName);
  }

  @override
  Future<GeniusPdfSplitResult> splitPdf({
    required Uint8List pdfBytes,
    required String baseFileName,
    int? pagesPerFile,
    List<List<int>>? pageRanges,
    bool saveToFiles = false,
    GeniusPdfProgressCallback? onProgress,
  }) async {
    splitCalls++;
    return GeniusPdfSplitResult.failure('unused');
  }
}
