import 'dart:io';
import 'dart:typed_data';

import '../app/contracts/pdf_document_processor.dart';
import '../app/contracts/pdf_generation_ports.dart';
import '../app/services/pdf_generation_service.dart';
import '../app/services/pdf_document_service.dart';
import '../infra/generation/flutter_pdf_generator.dart';
import '../infra/logging/genius_pdf_log_adapter.dart';
import '../infra/platform/flutter_pdf_file_gateway.dart';
import '../infra/platform/flutter_interaction_gateway.dart';
import '../infra/processing/syncfusion_doc_processor.dart';
import '../ui/controllers/genius_pdf_controller.dart';
import '../ui/controllers/preview_action_controller.dart';

/// Callback for resolving a platform directory.
typedef GeniusPdfDirectoryResolver = Future<Directory> Function();

/// Callback for opening a generated file.
typedef GeniusPdfOpenFileHandler = Future<void> Function(String path);

/// Callback for sharing PDF bytes.
typedef GeniusPdfShareHandler = Future<void> Function(
  Uint8List bytes,
  String fileName,
);

/// Callback for printing PDF bytes.
typedef GeniusPdfPrintHandler = Future<bool> Function(
  Uint8List bytes,
  String documentName,
);

/// Fully composed runtime used by public facades and Flutter views.
class GeniusPdfRuntime {
  const GeniusPdfRuntime({
    required this.files,
    required this.interactions,
    required this.logger,
    required this.generator,
    required this.processor,
    required this.generation,
    required this.documents,
    required this.controller,
    required this.previewController,
  });

  final GeniusPdfFileGateway files;
  final GeniusPdfInteractionGateway interactions;
  final GeniusPdfLogPort logger;
  final GeniusPdfDocumentGenerator generator;
  final GeniusPdfDocumentProcessor processor;
  final GeniusPdfGenerationApplicationService generation;
  final GeniusPdfDocumentApplicationService documents;
  final GeniusPdfController controller;
  final GeniusPdfPreviewActionController previewController;
}

/// The only place where application contracts are wired to infrastructure.
abstract final class GeniusPdfCompositionRoot {
  static final GeniusPdfRuntime defaults = create();

  static GeniusPdfRuntime create({
    GeniusPdfDirectoryResolver? documentsDirectoryProvider,
    GeniusPdfDirectoryResolver? temporaryDirectoryProvider,
    GeniusPdfOpenFileHandler? openFileAction,
    GeniusPdfShareHandler? sharePdfAction,
    GeniusPdfPrintHandler? printPdfAction,
    GeniusPdfDocumentGenerator? documentGenerator,
    GeniusPdfFileGateway? fileGateway,
    GeniusPdfInteractionGateway? interactionGateway,
    GeniusPdfDocumentProcessor? documentProcessor,
    GeniusPdfLogPort? logger,
    Uint8List? watermarkFontBytes,
  }) {
    final files = fileGateway ??
        FlutterPdfFileGateway(
          documentsDirectoryProvider: documentsDirectoryProvider,
          temporaryDirectoryProvider: temporaryDirectoryProvider,
        );
    final interactions = interactionGateway ??
        FlutterPdfInteractionGateway(
          openFileAction: openFileAction,
          sharePdfAction: sharePdfAction,
          printPdfAction: printPdfAction,
        );
    final log = logger ?? const GeniusPdfLogAdapter();
    final generator = documentGenerator ?? const FlutterPdfDocumentGenerator();
    final processor = documentProcessor ??
        SyncfusionPdfDocumentProcessor(
          files: files,
          logger: log,
          watermarkFontBytes: watermarkFontBytes,
        );
    final generation = GeniusPdfGenerationApplicationService(
      generator: generator,
      files: files,
      interactions: interactions,
      logger: log,
    );
    final documents = GeniusPdfDocumentApplicationService(
      processor: processor,
    );
    final controller = GeniusPdfController(
      generation: generation,
      documents: documents,
    );
    final previewController = GeniusPdfPreviewActionController(
      files: files,
      interactions: interactions,
    );

    return GeniusPdfRuntime(
      files: files,
      interactions: interactions,
      logger: log,
      generator: generator,
      processor: processor,
      generation: generation,
      documents: documents,
      controller: controller,
      previewController: previewController,
    );
  }
}
