// Global GeniusPdfGenerationManager example migration
//
// Central manager-backed generation helpers for the example application.

import 'dart:typed_data';

import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';

/// Runs one example PDF through the app-wide [GeniusPdfGenerationManager].
///
/// The manager owns disposal of [builder] after the generation attempt.
Future<GeniusPdfSuccess> generateExamplePdf({
  required GeniusPdfDocumentBuilder builder,
  required String fileName,
  GeniusPdfJobPriority priority = GeniusPdfJobPriority.normal,
  Map<String, dynamic>? metadata,
}) async {
  final result = await geniusPdfGenerationManager.addJobAndWait(
    builder: builder,
    fileName: fileName,
    priority: priority,
    runInBackground: true,
    metadata: <String, dynamic>{
      'source': 'example-app',
      if (metadata != null) ...metadata,
    },
  );

  return switch (result) {
    final GeniusPdfSuccess success => success,
    final GeniusPdfFailure failure => throw StateError(failure.message),
  };
}

/// Adapts an existing isolate-safe bytes generator to a manager job.
///
/// This is useful for heavy examples that already serialize their inputs and
/// construct the real report inside an isolate. [GeniusPdfGenerationManager]
/// still owns queuing, concurrency, status, persistence, and lifecycle while
/// [generateInBackground] preserves the existing split-thread strategy.
final class ExampleBackgroundPdfBuilder extends GeniusPdfDocumentBuilder
    implements GeniusPdfBackgroundBuildSource {
  ExampleBackgroundPdfBuilder({
    required GeniusPdfConfig config,
    required Future<Uint8List> Function() backgroundGenerator,
  }) : _backgroundGenerator = backgroundGenerator,
       super(config);

  final Future<Uint8List> Function() _backgroundGenerator;

  @override
  void build() {}

  @override
  List<int> generate() {
    throw UnsupportedError(
      'ExampleBackgroundPdfBuilder must be generated with runInBackground: true.',
    );
  }

  @override
  Future<Uint8List> generateInBackground() => _backgroundGenerator();
}
