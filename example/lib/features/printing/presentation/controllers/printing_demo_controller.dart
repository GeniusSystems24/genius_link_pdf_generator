// Global manager/background migration for Printing PDF generation

import 'package:flutter/foundation.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:genius_pdf_example/features/printing/models/documents/printing_background_generation.dart';
import 'package:genius_pdf_example/shared/application/services/example_pdf_generation.dart';

final class PrintingDemoController extends ChangeNotifier {
  PrintingDemoController({required GeniusPdfConfig config}) : _config = config;

  final GeniusPdfConfig _config;

  bool _isLoading = false;
  String _status = '';
  List<GeniusPrinterInfo> _printers = const [];
  GeniusPrintSettings _currentSettings = GeniusPrintSettings.defaults();
  Uint8List? _samplePdfBytes;
  List<GeniusPrintProfile> _profiles = const [];

  bool get isLoading => _isLoading;
  String get status => _status;
  List<GeniusPrinterInfo> get printers => _printers;
  GeniusPrintSettings get currentSettings => _currentSettings;
  Uint8List? get samplePdfBytes => _samplePdfBytes;
  List<GeniusPrintProfile> get profiles => _profiles;
  bool get hasSample => _samplePdfBytes != null;

  set currentSettings(GeniusPrintSettings value) {
    _currentSettings = value;
    notifyListeners();
  }

  Future<void> initialize() {
    loadProfiles();
    updateStatus('Ready. Generate the sample PDF when you want to print or preview it.');
    return Future<void>.value();
  }

  void loadProfiles() {
    _profiles = GeniusPrintSettingsManager.instance.allProfiles;
    notifyListeners();
  }

  Future<void> generateSamplePdf() async {
    _setLoading(true, 'Generating sample PDF...');

    try {
      final success = await generateExamplePdf(
        builder: ExampleBackgroundPdfBuilder(
          config: _config,
          backgroundGenerator: () => generatePrintingSamplePdfInBackground(
            config: _config,
          ),
        ),
        fileName: 'printing_sample_document',
        metadata: <String, dynamic>{
          'feature': 'printing',
          'screen': 'PrintingDemo',
          'workflow': 'printing-sample',
          'showGenerationToast': true,
        },
      );

      _samplePdfBytes = success.bytes;
      _setLoading(
        false,
        'Sample PDF ready (3 pages, ${_samplePdfBytes!.length} bytes)',
      );
    } catch (error) {
      _setLoading(false, 'Error generating PDF: $error');
    }
  }

  Future<void> discoverPrinters() async {
    _setLoading(true, 'Discovering printers...');
    try {
      _printers = await GeniusPrinterDiscovery.instance.discoverPrinters(
        forceRefresh: true,
      );
      _setLoading(false, 'Found ${_printers.length} printer(s)');
    } catch (error) {
      _setLoading(false, 'Error: $error');
    }
  }

  Future<void> checkPrintingInfo() async {
    _setLoading(true, 'Checking printing info...');
    try {
      final info = await GeniusPrinterService.instance.getPrintingInfo();
      final isAvailable =
          await GeniusPrinterService.instance.isPrintingAvailable();
      _setLoading(false, '''
Printing Available: $isAvailable
Can Print: ${info.canPrint}
Can Share: ${info.canShare}
Can Raster: ${info.canRaster}
Direct Print: ${info.directPrint}
''');
    } catch (error) {
      _setLoading(false, 'Error: $error');
    }
  }

  Future<void> printWithDialog() async {
    final bytes = _samplePdfBytes;
    if (bytes == null) return;

    _setLoading(true, 'Opening print dialog...');
    try {
      final result = await GeniusPrinterService.instance.printWithDialog(
        config: _config,
        pdfBytes: bytes,
        documentName: 'Sample_Document',
        settings: _currentSettings,
        onProgress: (job) {
          _status = 'Printing: ${(job.progress * 100).toStringAsFixed(0)}%';
          notifyListeners();
        },
        onComplete: (job) {
          _status = 'Print completed: ${job.statusTextEn}';
          notifyListeners();
        },
        onError: (job, error) {
          _status = 'Print error: $error';
          notifyListeners();
        },
      );
      _setLoading(
        false,
        result.success
            ? 'Print job completed successfully!'
            : 'Print cancelled or failed: ${result.error}',
      );
    } catch (error) {
      _setLoading(false, 'Error: $error');
    }
  }

  void saveProfile(String name) {
    if (name.isEmpty) return;
    _currentSettings.saveAsProfile(name: name);
    loadProfiles();
    _status = 'Profile "$name" saved!';
    notifyListeners();
  }

  void applyProfile(GeniusPrintProfile profile) {
    _currentSettings = profile.settings;
    _status = 'Applied profile: ${profile.name}';
    GeniusPrintSettingsManager.instance.recordUsage(profile.id);
    notifyListeners();
  }

  void updateStatus(String value) {
    _status = value;
    notifyListeners();
  }

  void _setLoading(bool value, String status) {
    _isLoading = value;
    _status = status;
    notifyListeners();
  }
}
