import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:genius_link_pdf_generator/src/app/contracts/pdf_generation_ports.dart';
import 'package:genius_link_pdf_generator/src/infra/generation/flutter_pdf_generator.dart';

void main() {
  test('uses builder-owned background strategy when available', () async {
    final source = _BackgroundSource();
    const generator = FlutterPdfDocumentGenerator();

    final bytes = await generator.generate(source, runInBackground: true);

    expect(bytes, Uint8List.fromList(<int>[7, 8, 9]));
    expect(source.backgroundCalls, 1);
    expect(source.foregroundCalls, 0);
  });

  test('uses foreground generation when background is disabled', () async {
    final source = _ForegroundSource();
    const generator = FlutterPdfDocumentGenerator();

    final bytes = await generator.generate(source, runInBackground: false);

    expect(bytes, Uint8List.fromList(<int>[1, 2, 3]));
    expect(source.calls, 1);
  });
}

class _BackgroundSource implements GeniusPdfBackgroundBuildSource {
  int backgroundCalls = 0;
  int foregroundCalls = 0;

  @override
  String? get defaultOutputPath => null;

  @override
  Future<Uint8List> generateInBackground() async {
    backgroundCalls++;
    return Uint8List.fromList(<int>[7, 8, 9]);
  }

  @override
  List<int> generate() {
    foregroundCalls++;
    throw StateError('foreground path should not be used');
  }

  @override
  void dispose() {}
}

class _ForegroundSource implements GeniusPdfBuildSource {
  int calls = 0;

  @override
  String? get defaultOutputPath => null;

  @override
  List<int> generate() {
    calls++;
    return <int>[1, 2, 3];
  }

  @override
  void dispose() {}
}
