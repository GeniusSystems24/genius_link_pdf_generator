import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'support/pdf_stability_fixtures.dart';

void main() {
  late Directory tempDir;

  setUpAll(() async {
    tempDir = await Directory.systemTemp.createTemp('genius_pdf_service_test_');
  });

  tearDownAll(() async {
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  // ─── US6: GeniusPdfService.generate() ────────────────────────────────────

  group('GeniusPdfService.generate()', () {
    test('returns GeniusPdfSuccess with non-empty bytes on success', () async {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('Service reliability test', topMargin: 0);
      });

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
      );

      final result = await service.generate(
        builder: builder,
        fileName: 'test_generate',
        runInBackground: false,
      );

      expect(result.isSuccess, isTrue);
      final success = result as GeniusPdfSuccess;
      expect(success.bytes, isNotEmpty);
      expect(success.fileName, equals('test_generate'));
    });

    test('returns GeniusPdfFailure when builder throws', () async {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final builder = TestPdfDocumentBuilder(config, onBuild: (_) {
        throw StateError('Builder deliberately failed');
      });

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
      );

      final result = await service.generate(
        builder: builder,
        fileName: 'test_failure',
        runInBackground: false,
      );

      expect(result.isFailure, isTrue);
      expect(result, isA<GeniusPdfFailure>());
    });

    test('does not rethrow — always returns a result', () async {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final builder = TestPdfDocumentBuilder(config, onBuild: (_) {
        throw Exception('Unexpected error');
      });

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
      );

      expect(
        () => service.generate(
          builder: builder,
          fileName: 'test_no_rethrow',
          runInBackground: false,
        ),
        returnsNormally,
      );
    });
  });

  // ─── US6: GeniusPdfService.generateBatch() ───────────────────────────────

  group('GeniusPdfService.generateBatch()', () {
    test('result list length matches input builder count', () async {
      final builders = List.generate(3, (i) {
        final cfg = createTestConfig(pageSize: const Size(200, 280));
        return (
          builder: TestPdfDocumentBuilder(cfg, onBuild: (b) {
            b.newPage();
            b.addLine('Batch item $i', topMargin: 0);
          }),
          fileName: 'batch_$i',
        );
      });

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
      );

      final results = await service.generateBatch(
        builders: builders,
        saveToFiles: false,
      );

      expect(results.length, equals(3));
    });

    test('result ordering preserves input order', () async {
      final fileNames = ['first', 'second', 'third'];

      final builders = List.generate(fileNames.length, (i) {
        final cfg = createTestConfig(pageSize: const Size(200, 280));
        return (
          builder: TestPdfDocumentBuilder(cfg, onBuild: (b) {
            b.newPage();
            b.addLine('Order test $i', topMargin: 0);
          }),
          fileName: fileNames[i],
        );
      });

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
      );

      final results = await service.generateBatch(
        builders: builders,
        saveToFiles: false,
      );

      for (int i = 0; i < results.length; i++) {
        expect(
          results[i].isSuccess,
          isTrue,
          reason: 'Result at index $i should succeed',
        );
        expect(
          (results[i] as GeniusPdfSuccess).fileName,
          equals(fileNames[i]),
          reason: 'Result at index $i should match "${fileNames[i]}"',
        );
      }
    });

    test('failed item does not prevent subsequent items from generating', () async {
      final cfg = createTestConfig(pageSize: const Size(200, 280));

      final builders = [
        (
          builder: TestPdfDocumentBuilder(cfg, onBuild: (_) {
            throw StateError('First item fails');
          }),
          fileName: 'fail_item',
        ),
        (
          builder: TestPdfDocumentBuilder(
            createTestConfig(pageSize: const Size(200, 280)),
            onBuild: (b) {
              b.newPage();
              b.addLine('Success item', topMargin: 0);
            },
          ),
          fileName: 'success_item',
        ),
      ];

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
      );

      final results = await service.generateBatch(
        builders: builders,
        saveToFiles: false,
      );

      expect(results[0].isFailure, isTrue);
      expect(results[1].isSuccess, isTrue);
    });
  });

  // ─── US6: Auto-actions run only after successful generation ───────────────

  group('GeniusPdfService auto-actions', () {
    test('share callback is invoked after successful generation', () async {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('Share test', topMargin: 0);
      });

      bool shareInvoked = false;

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
        sharePdfAction: (_, __) async {
          shareInvoked = true;
        },
      );

      await service.generateAndShare(
        builder: builder,
        fileName: 'share_test',
        runInBackground: false,
      );

      expect(shareInvoked, isTrue);
    });

    test('share callback is NOT invoked when generation fails', () async {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final builder = TestPdfDocumentBuilder(config, onBuild: (_) {
        throw StateError('Deliberate failure before share');
      });

      bool shareInvoked = false;

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
        sharePdfAction: (_, __) async {
          shareInvoked = true;
        },
      );

      final result = await service.generateAndShare(
        builder: builder,
        fileName: 'share_fail_test',
        runInBackground: false,
      );

      expect(shareInvoked, isFalse);
      expect(result.isFailure, isTrue);
    });

    test('onError callback is invoked when generation fails', () async {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final builder = TestPdfDocumentBuilder(config, onBuild: (_) {
        throw StateError('Failure for onError');
      });

      GeniusPdfFailure? capturedFailure;

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
      );

      await service.generateAndShare(
        builder: builder,
        fileName: 'onerror_test',
        runInBackground: false,
        onError: (f) => capturedFailure = f,
      );

      expect(capturedFailure, isNotNull);
      expect(capturedFailure!.isFailure, isTrue);
    });

    test('onComplete callback is invoked on success', () async {
      final config = createTestConfig(pageSize: const Size(200, 280));
      final builder = TestPdfDocumentBuilder(config, onBuild: (b) {
        b.newPage();
        b.addLine('onComplete test', topMargin: 0);
      });

      GeniusPdfSuccess? capturedSuccess;

      final service = GeniusPdfService(
        documentsDirectoryProvider: () async => tempDir,
        sharePdfAction: (_, __) async {},
      );

      await service.generateAndShare(
        builder: builder,
        fileName: 'oncomplete_test',
        runInBackground: false,
        onComplete: (s) => capturedSuccess = s,
      );

      expect(capturedSuccess, isNotNull);
      expect(capturedSuccess!.bytes, isNotEmpty);
    });
  });

  // ─── US6: GeniusPdfResult model correctness ──────────────────────────────

  group('GeniusPdfResult model', () {
    test('GeniusPdfSuccess has correct isSuccess/isFailure flags', () {
      final success = GeniusPdfSuccess(
        bytes: Uint8List.fromList([1, 2, 3]),
        fileName: 'test',
      );
      expect(success.isSuccess, isTrue);
      expect(success.isFailure, isFalse);
    });

    test('GeniusPdfFailure has correct isSuccess/isFailure flags', () {
      const failure = GeniusPdfFailure(
        error: 'err',
        message: 'Test error',
      );
      expect(failure.isSuccess, isFalse);
      expect(failure.isFailure, isTrue);
    });

    test('GeniusPdfFailure.fromException captures error and message', () {
      final ex = StateError('something went wrong');
      final failure = GeniusPdfFailure.fromException(ex);
      expect(failure.message, contains('something went wrong'));
      expect(failure.error, same(ex));
    });

    test('when() dispatches to onSuccess for GeniusPdfSuccess', () {
      final success = GeniusPdfSuccess(
        bytes: Uint8List.fromList([0]),
        fileName: 'f',
      );
      final label = success.when(
        onSuccess: (_) => 'success',
        onFailure: (_) => 'failure',
      );
      expect(label, equals('success'));
    });

    test('when() dispatches to onFailure for GeniusPdfFailure', () {
      const failure = GeniusPdfFailure(error: 'e', message: 'm');
      final label = failure.when(
        onSuccess: (_) => 'success',
        onFailure: (_) => 'failure',
      );
      expect(label, equals('failure'));
    });

    test('whenSuccess() returns null for GeniusPdfFailure', () {
      const failure = GeniusPdfFailure(error: 'e', message: 'm');
      expect(failure.whenSuccess((_) => 'got it'), isNull);
    });

    test('whenFailure() returns null for GeniusPdfSuccess', () {
      final success = GeniusPdfSuccess(
        bytes: Uint8List.fromList([0]),
        fileName: 'f',
      );
      expect(success.whenFailure((_) => 'got it'), isNull);
    });
  });
}
