import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:genius_link_pdf_generator/src/printing/application/print_preview_gateway.dart';
import 'package:genius_link_pdf_generator/src/printing/application/print_preview_result.dart';
import 'package:genius_link_pdf_generator/src/printing/presentation/print_preview_controller.dart';

void main() {
  test('print preview controller delegates through its gateway', () async {
    final gateway = _Gateway();
    final controller = GeniusPrintPreviewController(gateway: gateway);
    final config = GeniusPdfConfig(baseFontBytes: Uint8List(0));

    final result = await controller.print(
      pdfBytes: Uint8List.fromList(<int>[1]),
      documentName: 'sample',
      settings: const GeniusPrintSettings(),
      config: config,
    );

    expect(result.success, isTrue);
    expect(gateway.printCalls, 1);
  });
}

class _Gateway implements GeniusPrintPreviewGateway {
  int printCalls = 0;

  @override
  Future<GeniusPrintPreviewResult> print({
    required Uint8List pdfBytes,
    required String documentName,
    required GeniusPrintSettings settings,
    required GeniusPdfConfig config,
  }) async {
    printCalls++;
    return const GeniusPrintPreviewResult.success();
  }

  @override
  Future<GeniusPrintPreviewResult> save({
    required Uint8List pdfBytes,
    required String fileName,
  }) async => const GeniusPrintPreviewResult.success(filePath: '/tmp/a.pdf');

  @override
  Future<GeniusPrintPreviewResult> share({
    required Uint8List pdfBytes,
    required String fileName,
  }) async => const GeniusPrintPreviewResult.success();
}
