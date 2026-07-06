import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/shared/presentation/controllers/demo_document_controller.dart';

typedef JobManagerErrorCallback = void Function(String message);

final class JobManagerDemoController extends ChangeNotifier {
  JobManagerDemoController({
    required DemoDocumentController documents,
    GeniusPdfGenerationManagerConfig? config,
  })  : _documents = documents,
        _manager = GeniusPdfGenerationManager(
            config: config ??
                GeniusPdfGenerationManagerConfig(
                  maxConcurrentJobs: 2,
                  cleanupCompletedJobs: false,
                )) {
    _queueSubscription = _manager.queueUpdates.listen((value) {
      _jobs = List.unmodifiable(value);
      notifyListeners();
    });
  }

  final DemoDocumentController _documents;
  final GeniusPdfGenerationManager _manager;
  late final StreamSubscription<List<GeniusPdfJob>> _queueSubscription;

  List<GeniusPdfJob> _jobs = const [];
  final Map<String, String> _jobFilePaths = {};

  List<GeniusPdfJob> get jobs => _jobs;
  Map<String, String> get jobFilePaths => Map.unmodifiable(_jobFilePaths);

  Future<void> addJob({
    required String name,
    required GeniusPdfDocumentBuilder builder,
    JobManagerErrorCallback? onError,
  }) async {
    final fileName = name.toLowerCase().replaceAll(' ', '_');
    var jobId = '';

    jobId = await _manager.addJob(
      builder: builder,
      fileName: fileName,
      priority: GeniusPdfJobPriority.normal,
      autoOpen: false,
      onComplete: (result) async {
        try {
          final filePath = await _documents.saveBytes(
            bytes: result.bytes,
            fileName: fileName,
          );
          _jobFilePaths[jobId] = filePath;
          notifyListeners();
        } catch (_) {
          // The generated job remains successful even if demo persistence fails.
        }
      },
      onError: (error) => onError?.call('$name failed: ${error.message}'),
    );
  }

  Future<void> openFile(String filePath) => _documents.open(filePath);

  void cancelJob(String id) => _manager.cancelJob(id);

  Future<void> retryJob(String id) => _manager.retryJob(id);

  void removeJob(String id) => _manager.removeJob(id);

  int cancelAllQueued() => _manager.cancelAllQueued();

  int clearFinished() => _manager.clearFinishedJobs();

  @override
  void dispose() {
    _queueSubscription.cancel();
    _manager.dispose();
    super.dispose();
  }
}
