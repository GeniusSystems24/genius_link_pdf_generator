import 'package:flutter/foundation.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

import 'package:genius_pdf_example/features/export/models/documents/export_demo_document.dart';
import 'package:genius_pdf_example/shared/presentation/controllers/demo_document_controller.dart';

final class ExportDemoController extends ChangeNotifier {
  ExportDemoController({
    required GeniusPdfConfig config,
    required DemoDocumentController documents,
  })  : _config = config,
        _documents = documents;

  final GeniusPdfConfig _config;
  final DemoDocumentController _documents;

  bool _isLoading = false;
  String _status = '';
  double _progress = 0;
  GeniusExportResult? _lastResult;
  PdfDocument? _sampleDocument;
  String? _lastFilePath;
  bool _isRtl = false;

  bool get isLoading => _isLoading;
  String get status => _status;
  double get progress => _progress;
  GeniusExportResult? get lastResult => _lastResult;
  String? get lastFilePath => _lastFilePath;
  bool get isReady => _sampleDocument != null;
  bool get isRtl => _isRtl;

  void setRtl(bool value) {
    if (_isRtl == value) return;
    _isRtl = value;
    notifyListeners();
  }

  Future<void> initialize() async {
    _setLoading(true, status: 'Creating sample document...');
    try {
      _sampleDocument = await buildExportSampleDocument(_config);
      _setLoading(false, status: 'Sample document ready');
    } catch (error) {
      _setLoading(false, status: 'Error: $error');
    }
  }

  Future<void> exportTo(GeniusExportFormat format) async {
    final document = _sampleDocument;
    if (document == null) return;

    _isLoading = true;
    _progress = 0;
    _lastResult = null;
    notifyListeners();

    final config = switch (format) {
      GeniusExportFormat.png => GeniusExportConfiguration.image(
          format: GeniusExportFormat.png,
          quality: GeniusImageQuality.high,
        ),
      GeniusExportFormat.jpeg => GeniusExportConfiguration.image(
          format: GeniusExportFormat.jpeg,
          quality: GeniusImageQuality.medium,
          jpegQuality: 85,
        ),
      GeniusExportFormat.html => GeniusExportConfiguration.html(
          embedImages: true,
          includeStyles: true,
        ),
      GeniusExportFormat.text => GeniusExportConfiguration.text(),
      GeniusExportFormat.pdfA => GeniusExportConfiguration.pdfA(compress: true),
    };

    final result = await GeniusPdfExportService().export(
      document,
      config,
      onProgress: (value) {
        _progress = value.progress;
        _status = value.status;
        notifyListeners();
      },
    );

    String? filePath;
    if (result is GeniusExportSuccess && result.data.isNotEmpty) {
      try {
        final extension = format.extension;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        filePath = await _documents.saveBytes(
          bytes: result.data,
          fileName: 'export_$timestamp.$extension',
        );
      } catch (_) {
        filePath = null;
      }
    }

    _isLoading = false;
    _lastResult = result;
    _lastFilePath = filePath;
    _status = switch (result) {
      GeniusExportSuccess success =>
        'Export complete! Size: ${success.fileSizeFormatted}',
      GeniusExportFailure failure => 'Export failed: ${failure.message}',
    };
    notifyListeners();
  }

  Future<void> batchExport() async {
    final document = _sampleDocument;
    if (document == null) return;

    _isLoading = true;
    _progress = 0;
    _lastResult = null;
    notifyListeners();

    final result =
        await GeniusBatchExporter(maxConcurrent: 2).exportToMultipleFormats(
      document,
      const [
        GeniusExportFormat.png,
        GeniusExportFormat.html,
        GeniusExportFormat.text,
      ],
      onProgress: (value) {
        _progress = value.progress;
        _status = value.status;
        notifyListeners();
      },
    );

    _isLoading = false;
    _status = 'Batch export complete! '
        '${result.successCount}/${result.totalCount} successful '
        '(${result.duration.inMilliseconds}ms)';
    notifyListeners();
  }

  Future<void> openLastFile() async {
    final path = _lastFilePath;
    if (path != null) await _documents.open(path);
  }

  void _setLoading(bool value, {required String status}) {
    _isLoading = value;
    _status = status;
    notifyListeners();
  }

  @override
  void dispose() {
    _sampleDocument?.dispose();
    super.dispose();
  }
}
