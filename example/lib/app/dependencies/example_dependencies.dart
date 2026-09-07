import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/shared/application/contracts/demo_file_gateway.dart';
import 'package:genius_pdf_example/shared/infrastructure/platform/flutter_demo_file_gateway.dart';
import 'package:genius_pdf_example/shared/presentation/controllers/demo_document_controller.dart';

final class ExampleDependencies {
  ExampleDependencies._({
    required this.pdfConfig,
    required this.files,
    required this.pdfGenerationManager,
  }) : documents = DemoDocumentController(files: files);

  static ExampleDependencies? _instance;

  static ExampleDependencies get instance {
    final value = _instance;
    if (value == null) {
      throw StateError('ExampleDependencies.configure must be called first.');
    }
    return value;
  }

  static void configure({
    required GeniusPdfConfig pdfConfig,
    DemoFileGateway files = const FlutterDemoFileGateway(),
    GeniusPdfGenerationManager? pdfGenerationManager,
  }) {
    final previous = _instance;
    final manager = pdfGenerationManager ??
        previous?.pdfGenerationManager ??
        GeniusPdfGenerationManager(
          config: GeniusPdfGenerationManagerConfig(
            maxConcurrentJobs: 2,
            defaultRunInBackground: true,
            retryFailedJobs: false,
            cleanupCompletedJobs: true,
            completedJobRetentionDuration: const Duration(minutes: 30),
          ),
        );

    _instance = ExampleDependencies._(
      pdfConfig: pdfConfig,
      files: files,
      pdfGenerationManager: manager,
    );
  }

  /// Releases app-wide example dependencies.
  ///
  /// Normal application lifetime does not need to call this. It is provided
  /// for tests or embedders that explicitly tear down the example app.
  static void dispose() {
    _instance?.pdfGenerationManager.dispose();
    _instance = null;
  }

  final GeniusPdfConfig pdfConfig;
  final DemoFileGateway files;
  final DemoDocumentController documents;

  /// Shared PDF generation queue used by every managed example screen.
  final GeniusPdfGenerationManager pdfGenerationManager;
}

/// Compatibility getter for existing example documents and screens.
GeniusPdfConfig get geniusPdfConfig => ExampleDependencies.instance.pdfConfig;

DemoDocumentController get demoDocuments =>
    ExampleDependencies.instance.documents;

/// App-wide PDF generation manager for example screens.
///
/// Keep this manager shared instead of creating one manager per screen so
/// generation concurrency, priorities, queue state, and background execution
/// are coordinated across the whole example application.
GeniusPdfGenerationManager get geniusPdfGenerationManager =>
    ExampleDependencies.instance.pdfGenerationManager;
