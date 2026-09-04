import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

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

  Future<void> initialize() async {
    loadProfiles();
    await generateSamplePdf();
  }

  void loadProfiles() {
    _profiles = GeniusPrintSettingsManager.instance.allProfiles;
    notifyListeners();
  }

  Future<void> generateSamplePdf() async {
    _setLoading(true, 'Generating sample PDF...');

    try {
      final document = PdfDocument();

      PdfFont font;
      PdfFont titleFont;
      try {
        font = _config.baseFont;
        titleFont = PdfTrueTypeFont(
          _config.baseFontBytes,
          18,
          style: PdfFontStyle.bold,
        );
      } catch (_) {
        font = PdfTrueTypeFont(_config.baseFontBytes, 12);
        titleFont = PdfTrueTypeFont(
          _config.baseFontBytes,
          18,
          style: PdfFontStyle.bold,
        );
      }

      final page1 = document.pages.add();
      final g1 = page1.graphics;
      g1.drawString(
        'Genius Link PDF Generator',
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 51, 102)),
        bounds: const Rect.fromLTWH(50, 100, 500, 40),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      g1.drawString(
        'Advanced Printing Demo (v2.2.1)',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 150, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      g1.drawLine(
        PdfPen(PdfColor(0, 51, 102), width: 2),
        const Offset(50, 190),
        const Offset(550, 190),
      );
      g1.drawString(
        'Generated: ${DateTime.now().toString().split('.').first}',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 210, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      g1.drawString(
        'Page 1 of 3',
        font,
        brush: PdfSolidBrush(PdfColor(150, 150, 150)),
        bounds: const Rect.fromLTWH(50, 750, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );

      final page2 = document.pages.add();
      final g2 = page2.graphics;
      g2.drawString(
        'Print Settings Reference',
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 51, 102)),
        bounds: const Rect.fromLTWH(50, 50, 500, 40),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      g2.drawLine(
        PdfPen(PdfColor(200, 200, 200)),
        const Offset(50, 90),
        const Offset(550, 90),
      );

      const settingsInfo = [
        'Paper Sizes: A4, Letter, Legal, A3, A5, Custom',
        'Orientations: Portrait, Landscape, Auto',
        'Color Modes: Color, Grayscale, Black & White',
        'Quality: Draft, Normal, High, Photo',
        'Duplex: Simplex, Long Edge, Short Edge',
        'Pages Per Sheet: 1, 2, 4, 6, 9, 16',
        'Scale: 25% to 200%',
        'Features: Collate, Reverse Order, Fit to Page',
      ];

      var yPos = 110.0;
      for (final info in settingsInfo) {
        g2.drawString(
          '• $info',
          font,
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(50, yPos, 500, 25),
          format: PdfStringFormat(textDirection: _config.pdfTextDirection),
        );
        yPos += 30;
      }
      g2.drawString(
        'Page 2 of 3',
        font,
        brush: PdfSolidBrush(PdfColor(150, 150, 150)),
        bounds: const Rect.fromLTWH(50, 750, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );

      final page3 = document.pages.add();
      final g3 = page3.graphics;
      g3.drawString(
        'Test Page',
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 51, 102)),
        bounds: const Rect.fromLTWH(50, 50, 500, 40),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      g3.drawLine(
        PdfPen(PdfColor(200, 200, 200)),
        const Offset(50, 90),
        const Offset(550, 90),
      );
      g3.drawString(
        'This page tests mixed content rendering.',
        font,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(50, 110, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      g3.drawString(
        'Use this to verify font rendering in print output.',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 140, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      g3.drawRectangle(
        brush: PdfSolidBrush(PdfColor(0, 102, 204)),
        bounds: const Rect.fromLTWH(50, 200, 200, 100),
      );
      g3.drawRectangle(
        brush: PdfSolidBrush(PdfColor(255, 153, 0)),
        bounds: const Rect.fromLTWH(260, 200, 200, 100),
      );
      g3.drawString(
        'Color test boxes - Verify color mode settings',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 320, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      g3.drawString(
        'Page 3 of 3',
        font,
        brush: PdfSolidBrush(PdfColor(150, 150, 150)),
        bounds: const Rect.fromLTWH(50, 750, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );

      _samplePdfBytes = Uint8List.fromList(await document.save());
      document.dispose();
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
