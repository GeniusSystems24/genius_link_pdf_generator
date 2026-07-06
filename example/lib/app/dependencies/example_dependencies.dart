import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/shared/application/contracts/demo_file_gateway.dart';
import 'package:genius_pdf_example/shared/infrastructure/platform/flutter_demo_file_gateway.dart';
import 'package:genius_pdf_example/shared/presentation/controllers/demo_document_controller.dart';

final class ExampleDependencies {
  ExampleDependencies._({
    required this.pdfConfig,
    required this.files,
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
  }) {
    _instance = ExampleDependencies._(pdfConfig: pdfConfig, files: files);
  }

  final GeniusPdfConfig pdfConfig;
  final DemoFileGateway files;
  final DemoDocumentController documents;
}

/// Compatibility getter for existing example documents and screens.
GeniusPdfConfig get geniusPdfConfig => ExampleDependencies.instance.pdfConfig;

DemoDocumentController get demoDocuments =>
    ExampleDependencies.instance.documents;
