import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

void main() {
  test('legacy GeniusPdfService constructor remains available', () {
    final service = GeniusPdfService(
      documentsDirectoryProvider: () async => Directory.systemTemp,
      temporaryDirectoryProvider: () async => Directory.systemTemp,
      openFileAction: (_) async {},
      sharePdfAction: (_, __) async {},
      printPdfAction: (_, __) async => true,
    );
    expect(service, isA<GeniusPdfService>());
  });

  test('legacy result and operation models remain exported', () {
    final success = GeniusPdfSuccess(
      bytes: Uint8List.fromList(<int>[1]),
      fileName: 'sample',
    );
    const merge = GeniusPdfMergeResult(success: false);
    const split = GeniusPdfSplitResult(success: false);
    expect(success.isSuccess, isTrue);
    expect(merge.success, isFalse);
    expect(split.success, isFalse);
  });

  test('MVC controllers are available through the package entrypoint', () {
    const previewController = GeniusPdfPreviewController();
    expect(previewController, isA<GeniusPdfPreviewController>());
  });

  test('stable package-owned client is available', () {
    const client = GeniusPdfClient();
    expect(client, isA<GeniusPdfClient>());
  });
}
