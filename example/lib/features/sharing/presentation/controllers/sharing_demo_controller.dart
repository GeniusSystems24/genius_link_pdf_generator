import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';

final class SharingDemoController extends ChangeNotifier {
  SharingDemoController({
    required GeniusPdfConfig config,
    GeniusShareService? shareService,
    GeniusEmailShareService? emailService,
    GeniusBluetoothShareService? bluetoothService,
    GeniusAppShareService? appService,
  })  : _config = config,
        _shareService = shareService ?? GeniusShareService.instance,
        _emailService = emailService ?? GeniusEmailShareService.instance,
        _bluetoothService =
            bluetoothService ?? GeniusBluetoothShareService.instance,
        _appService = appService ?? GeniusAppShareService.instance;

  final GeniusPdfConfig _config;
  final GeniusShareService _shareService;
  final GeniusEmailShareService _emailService;
  final GeniusBluetoothShareService _bluetoothService;
  final GeniusAppShareService _appService;

  bool _isLoading = false;
  String _status = '';
  Uint8List? _samplePdfBytes;
  List<GeniusShareHistoryItem> _history = const [];
  List<GeniusQuickShareContact> _contacts = const [];

  bool get isLoading => _isLoading;
  String get status => _status;
  bool get hasSample => _samplePdfBytes != null;
  List<GeniusShareHistoryItem> get history => _history;
  List<GeniusQuickShareContact> get contacts => _contacts;
  List<GeniusShareMessageTemplate> get templates => _shareService.templates;
  List<GeniusBluetoothDevice> get savedDevices =>
      _bluetoothService.savedDevices;

  Future<void> initialize() async {
    await Future.wait([
      _shareService.initialize(),
      _bluetoothService.initialize(),
    ]);
    _refreshCollections();
    await generateSamplePdf();
  }

  Future<void> generateSamplePdf() async {
    _setLoading(true, 'Generating sample PDF...');
    try {
      final document = PdfDocument();
      final page = document.pages.add();
      final graphics = page.graphics;
      final font = PdfTrueTypeFont(_config.baseFontBytes, 12);
      final titleFont = PdfTrueTypeFont(
        _config.baseFontBytes,
        18,
        style: PdfFontStyle.bold,
      );

      graphics.drawString(
        'Genius Link PDF Generator',
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 51, 102)),
        bounds: const Rect.fromLTWH(50, 50, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      graphics.drawString(
        'Sharing Demo Document (v2.3.x)',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 90, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      graphics.drawLine(
        PdfPen(PdfColor(0, 51, 102), width: 2),
        const Offset(50, 130),
        const Offset(550, 130),
      );
      graphics.drawString(
        'Generated: ${DateTime.now().toString().split('.').first}',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 150, 500, 30),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );
      graphics.drawString(
        'This document demonstrates the sharing capabilities '
        'of the Genius Link PDF Generator library.',
        font,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(50, 200, 500, 100),
        format: PdfStringFormat(textDirection: _config.pdfTextDirection),
      );

      const features = [
        '• Unified sharing service',
        '• Email with attachments',
        '• Bluetooth/Nearby Share',
        '• WhatsApp & Telegram',
        '• Local storage saving',
      ];
      var yPos = 320.0;
      for (final feature in features) {
        graphics.drawString(
          feature,
          font,
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(50, yPos, 500, 25),
          format: PdfStringFormat(textDirection: _config.pdfTextDirection),
        );
        yPos += 30;
      }

      _samplePdfBytes = Uint8List.fromList(await document.save());
      document.dispose();
      _setLoading(
        false,
        'Sample PDF ready (${_samplePdfBytes!.length} bytes)',
      );
    } catch (error) {
      _setLoading(false, 'Error: $error');
    }
  }

  Future<void> shareViaSystem() => _share(
        status: 'Opening share sheet...',
        target: GeniusShareTarget.system(),
        successMessage: 'Shared successfully!',
      );

  Future<void> shareViaEmail() => _share(
        status: 'Preparing email...',
        target: GeniusShareTarget.email(
          subject: 'PDF Document',
          body: 'Please find the attached PDF document.',
        ),
        successMessage: 'Email prepared!',
      );

  Future<void> shareViaBluetooth() => _share(
        status: 'Preparing Bluetooth share...',
        target: GeniusShareTarget.bluetooth(),
        successMessage: 'Ready to share!',
      );

  Future<void> saveToLocal() => _share(
        status: 'Saving...',
        target: GeniusShareTarget.local(),
        successMessage: 'Saved successfully!',
        includeFilePath: true,
      );

  Future<void> composeEmail() async {
    final result = await _emailService.composeEmail(
      email: const GeniusEmailData(
        to: ['example@email.com'],
        subject: 'PDF Document',
        body: 'Please find the attached document.',
      ),
    );
    _status = result.success ? 'Email client opened!' : 'Error: ${result.error}';
    notifyListeners();
  }

  Future<void> openGmail() async {
    final result = await _emailService.openGmail(
      email: const GeniusEmailData(
        to: ['example@email.com'],
        subject: 'PDF Document',
      ),
    );
    _status = result.success ? 'Gmail opened!' : 'Error: ${result.error}';
    notifyListeners();
  }

  Future<void> openOutlook() async {
    final result = await _emailService.openOutlook(
      email: const GeniusEmailData(
        to: ['example@email.com'],
        subject: 'PDF Document',
      ),
    );
    _status = result.success ? 'Outlook opened!' : 'Error: ${result.error}';
    notifyListeners();
  }

  Future<void> shareViaNearby() async {
    final bytes = _samplePdfBytes;
    if (bytes == null) return;
    _setLoading(true, 'Opening Nearby Share...');
    final result = await _bluetoothService.shareViaNearby(
      pdfBytes: bytes,
      fileName: 'share_demo.pdf',
    );
    _setLoading(false, result.isSuccess ? 'Shared!' : 'Error: ${result.error}');
  }

  Future<void> discoverDevices() async {
    _setLoading(true, 'Discovering devices...');
    final devices = await _bluetoothService.discoverDevices();
    _setLoading(false, 'Found ${devices.length} device(s)');
  }

  Future<void> sendToDevice(GeniusBluetoothDevice device) async {
    final bytes = _samplePdfBytes;
    if (bytes == null) return;
    _setLoading(true, 'Sending to ${device.name}...');
    final result = await _bluetoothService.sendFile(
      pdfBytes: bytes,
      fileName: 'share_demo.pdf',
      device: device,
      onProgress: (progress) {
        _status = 'Sending: ${(progress * 100).toStringAsFixed(0)}%';
        notifyListeners();
      },
    );
    _setLoading(
      false,
      result.success ? 'Sent successfully!' : 'Error: ${result.error}',
    );
  }

  Future<void> shareToApp(GeniusSharableApp app) async {
    final bytes = _samplePdfBytes;
    if (bytes == null) return;
    _setLoading(true, 'Sharing to ${app.name}...');
    final result = await _appService.shareToApp(
      pdfBytes: bytes,
      fileName: 'share_demo.pdf',
      app: app,
    );
    _setLoading(
      false,
      result.success ? 'Shared to ${app.name}!' : 'Error: ${result.error}',
    );
  }

  Future<void> saveToDownloads() async {
    final bytes = _samplePdfBytes;
    if (bytes == null) return;
    _setLoading(true, 'Saving to Downloads...');
    final result = await _appService.saveToLocal(
      pdfBytes: bytes,
      fileName: 'share_demo.pdf',
      location: GeniusStorageLocation.downloads,
    );
    _setLoading(
      false,
      result.success ? 'Saved: ${result.filePath}' : 'Error: ${result.error}',
    );
  }

  Future<void> openInExternalApp() async {
    final bytes = _samplePdfBytes;
    if (bytes == null) return;
    _setLoading(true, 'Opening...');
    final result = await _appService.openInExternalApp(
      pdfBytes: bytes,
      fileName: 'share_demo.pdf',
    );
    _setLoading(false, result.success ? 'Opened!' : 'Error: ${result.error}');
  }

  void toggleFavorite(String contactId) {
    _shareService.toggleFavorite(contactId);
    _contacts = _shareService.contacts;
    notifyListeners();
  }

  Future<void> quickShareToContact(GeniusQuickShareContact contact) async {
    final bytes = _samplePdfBytes;
    if (bytes == null) return;
    _setLoading(true, 'Sharing to ${contact.name}...');
    final result = await _shareService.quickShare(
      pdfBytes: bytes,
      fileName: 'share_demo.pdf',
      contact: contact,
    );
    _history = _shareService.history;
    _setLoading(false, result.isSuccess ? 'Shared!' : 'Error: ${result.error}');
  }

  Future<void> shareWithTemplate(GeniusShareMessageTemplate template) async {
    final bytes = _samplePdfBytes;
    if (bytes == null) return;
    _setLoading(true, 'Preparing email...');
    final result = await _shareService.shareWithTemplate(
      pdfBytes: bytes,
      fileName: 'share_demo.pdf',
      target: GeniusShareTarget.email(),
      template: template,
      variables: const {
        'invoiceNumber': '12345',
        'customerName': 'John Doe',
        'amount': r'$100.00',
        'dueDate': '2026-02-01',
        'reportType': 'Sales',
        'date': '2026-01-24',
        'period': 'January 2026',
        'documentType': 'Report',
        'title': 'Monthly Report',
      },
    );
    _history = _shareService.history;
    _setLoading(
      false,
      result.isSuccess ? 'Email prepared!' : 'Error: ${result.error}',
    );
  }

  Future<void> clearHistory() async {
    await _shareService.clearHistory();
    _history = const [];
    _status = 'History cleared';
    notifyListeners();
  }

  Future<void> _share({
    required String status,
    required GeniusShareTarget target,
    required String successMessage,
    bool includeFilePath = false,
  }) async {
    final bytes = _samplePdfBytes;
    if (bytes == null) return;
    _setLoading(true, status);
    final result = await _shareService.share(
      pdfBytes: bytes,
      fileName: 'share_demo.pdf',
      target: target,
    );
    _history = _shareService.history;
    final message = result.isSuccess
        ? (includeFilePath && result.filePath != null
            ? 'Saved: ${result.filePath}'
            : successMessage)
        : 'Share ${result.isCancelled ? 'cancelled' : 'failed'}: '
            '${result.error ?? ''}';
    _setLoading(false, message);
  }

  void _refreshCollections() {
    _history = _shareService.history;
    _contacts = _shareService.contacts;
    notifyListeners();
  }

  void _setLoading(bool value, String status) {
    _isLoading = value;
    _status = status;
    notifyListeners();
  }
}
