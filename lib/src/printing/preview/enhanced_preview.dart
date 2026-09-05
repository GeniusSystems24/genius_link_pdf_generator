part of '../print_preview.dart';

class GeniusPrintPreviewEnhanced extends StatefulWidget {
  /// Creates an enhanced print preview widget
  const GeniusPrintPreviewEnhanced({
    super.key,
    required this.pdfBytes,
    required this.documentName,
    required this.pdfConfig,
    this.initialSettings,
    this.showSettings = true,
    this.showShareButton = true,
    this.showSaveButton = true,
    this.onPrint,
    this.onShare,
    this.onSave,
    this.onCancel,
    this.title,
    this.titleAr,
    this.controller,
  });

  /// PDF bytes to preview
  final Uint8List pdfBytes;

  /// Document name
  final String documentName;

  /// Optional PDF configuration for defaults
  final GeniusPdfConfig pdfConfig;

  /// Initial print settings
  final GeniusPrintSettings? initialSettings;

  /// Whether to show settings panel
  final bool showSettings;

  /// Whether to show share button
  final bool showShareButton;

  /// Whether to show save button
  final bool showSaveButton;

  /// Callback when print is requested
  final void Function(GeniusPrintSettings settings)? onPrint;

  /// Callback when share is requested
  final void Function()? onShare;

  /// Callback when save is requested
  final void Function()? onSave;

  /// Callback when cancelled
  final VoidCallback? onCancel;

  /// Title in English
  final String? title;

  /// Title in Arabic
  final String? titleAr;

  /// Optional controller for dependency injection and testing.
  final GeniusPrintPreviewController? controller;

  GeniusPrintPreviewController get effectiveController =>
      controller ?? GeniusPrintingCompositionRoot.previewController;

  @override
  State<GeniusPrintPreviewEnhanced> createState() => _GeniusPrintPreviewEnhancedState();
}

class _GeniusPrintPreviewEnhancedState extends State<GeniusPrintPreviewEnhanced> {
  late GeniusPrintSettings _settings;
  bool _isProcessing = false;
  String? _processingMessage;

  bool get _hasPdf => widget.pdfBytes.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings ??
        GeniusPrintSettings.fromPdfConfig(widget.pdfConfig);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Print Preview / معاينة الطباعة'),
        actions: [
          if (widget.showShareButton)
            IconButton(
              icon: const Icon(Icons.share),
              tooltip: 'Share / مشاركة',
              onPressed: _isProcessing || !_hasPdf ? null : _handleShare,
            ),
          if (widget.showSaveButton)
            IconButton(
              icon: const Icon(Icons.save),
              tooltip: 'Save / حفظ',
              onPressed: _isProcessing || !_hasPdf ? null : _handleSave,
            ),
          if (widget.showSettings)
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings / الإعدادات',
              onPressed: _isProcessing ? null : _showSettingsDialog,
            ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Settings summary bar
              if (widget.showSettings) _buildSettingsSummary(),

              // Preview area
              Expanded(
                child: _hasPdf
                    ? PdfPreview(
                        build: (format) => widget.pdfBytes,
                        allowPrinting: false,
                        allowSharing: false,
                        canChangeOrientation: false,
                        canChangePageFormat: false,
                        canDebug: false,
                        pdfFileName: widget.documentName,
                        initialPageFormat: _getPageFormat(),
                        previewPageMargin: const EdgeInsets.all(8),
                        loadingWidget: const Center(
                          child: CircularProgressIndicator(),
                        ),
                        onError: (context, error) => Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.error_outline,
                                  size: 48, color: Colors.red),
                              const SizedBox(height: 16),
                              Text('Error loading preview: $error'),
                            ],
                          ),
                        ),
                      )
                    : _buildEmptyPreview(context),
              ),

              // Bottom bar with actions
              _buildBottomBar(),
            ],
          ),

          // Processing overlay
          if (_isProcessing)
            Container(
              color: Colors.black54,
              child: Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(_processingMessage ?? 'Processing...'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingsSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildSettingChip(
              icon: Icons.description,
              label: _settings.paperSize.displayName,
            ),
            const SizedBox(width: 8),
            _buildSettingChip(
              icon: _settings.orientation == GeniusPrintOrientation.landscape
                  ? Icons.crop_landscape
                  : Icons.crop_portrait,
              label: _settings.orientation.name,
            ),
            const SizedBox(width: 8),
            _buildSettingChip(
              icon: Icons.palette,
              label: _settings.colorMode.name,
            ),
            const SizedBox(width: 8),
            _buildSettingChip(
              icon: Icons.copy,
              label: '${_settings.copies}x',
            ),
            if (_settings.duplexMode != GeniusDuplexMode.simplex) ...[
              const SizedBox(width: 8),
              _buildSettingChip(
                icon: Icons.flip,
                label: 'Duplex',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingChip({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Cancel button
          TextButton(
            onPressed: _isProcessing ? null : (widget.onCancel ?? () => Navigator.of(context).pop()),
            child: const Text('Cancel / إلغاء'),
          ),
          const Spacer(),

          // Share button (small)
          if (widget.showShareButton) ...[
            OutlinedButton.icon(
              onPressed: _isProcessing || !_hasPdf ? null : _handleShare,
              icon: const Icon(Icons.share, size: 18),
              label: const Text('Share'),
            ),
            const SizedBox(width: 8),
          ],

          // Print button
          FilledButton.icon(
            onPressed: _isProcessing || !_hasPdf ? null : _handlePrint,
            icon: const Icon(Icons.print),
            label: const Text('Print / طباعة'),
          ),
        ],
      ),
    );
  }


  Widget _buildEmptyPreview(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'No PDF data to preview.',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Generate the document before opening print preview.',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  void _showSettingsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _PrintSettingsSheet(
        settings: _settings,
        onSettingsChanged: (newSettings) {
          setState(() {
            _settings = newSettings;
          });
        },
      ),
    );
  }

  Future<void> _handlePrint() async {
    if (widget.onPrint != null) {
      widget.onPrint!(_settings);
      return;
    }

    GeniusPdfLogger.info('Enhanced preview print: "${widget.documentName}"', tag: 'PrintPreview');
    setState(() {
      _isProcessing = true;
      _processingMessage = 'Sending to printer... / جاري الإرسال للطابعة...';
    });

    try {
      final result = await widget.effectiveController.print(
        pdfBytes: widget.pdfBytes,
        documentName: widget.documentName,
        settings: _settings,
        config: widget.pdfConfig,
      );

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (result.success) {
          GeniusPdfLogger.info('Enhanced preview print completed: "${widget.documentName}"', tag: 'PrintPreview');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Print job sent successfully! / تم إرسال الطباعة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      GeniusPdfLogger.error('Enhanced preview print failed: "${widget.documentName}"', tag: 'PrintPreview', error: e);
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Print error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleShare() async {
    if (widget.onShare != null) {
      widget.onShare!();
      return;
    }

    GeniusPdfLogger.info('Share from preview: "${widget.documentName}"', tag: 'PrintPreview');
    setState(() {
      _isProcessing = true;
      _processingMessage = 'Preparing to share... / جاري التحضير للمشاركة...';
    });

    try {
      final result = await widget.effectiveController.share(
        pdfBytes: widget.pdfBytes,
        fileName: widget.documentName,
      );

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (result.success) {
          GeniusPdfLogger.info('Share from preview completed: "${widget.documentName}"', tag: 'PrintPreview');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Shared successfully! / تمت المشاركة بنجاح'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          GeniusPdfLogger.warning('Share from preview failed: ${result.error}', tag: 'PrintPreview');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Share failed: ${result.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      GeniusPdfLogger.error('Share from preview error: "${widget.documentName}"', tag: 'PrintPreview', error: e);
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Share error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSave() async {
    if (widget.onSave != null) {
      widget.onSave!();
      return;
    }

    GeniusPdfLogger.info('Save from preview: "${widget.documentName}"', tag: 'PrintPreview');
    setState(() {
      _isProcessing = true;
      _processingMessage = 'Saving file... / جاري حفظ الملف...';
    });

    try {
      final result = await widget.effectiveController.save(
        pdfBytes: widget.pdfBytes,
        fileName: widget.documentName,
      );

      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        if (result.success) {
          GeniusPdfLogger.info('Save from preview completed: "${result.filePath}"', tag: 'PrintPreview');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Saved to: ${result.filePath}'),
              backgroundColor: Colors.green,
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        } else {
          GeniusPdfLogger.warning('Save from preview failed: ${result.error}', tag: 'PrintPreview');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Save failed: ${result.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      GeniusPdfLogger.error('Save from preview error: "${widget.documentName}"', tag: 'PrintPreview', error: e);
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Save error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  PdfPageFormat _getPageFormat() {
    final size = _settings.paperSize;
    final isLandscape = _settings.orientation == GeniusPrintOrientation.landscape;

    var format = switch (size) {
      GeniusPaperSize.a3 => PdfPageFormat.a3,
      GeniusPaperSize.a4 => PdfPageFormat.a4,
      GeniusPaperSize.a5 => PdfPageFormat.a5,
      GeniusPaperSize.letter => PdfPageFormat.letter,
      GeniusPaperSize.legal => PdfPageFormat.legal,
      _ => PdfPageFormat.a4,
    };

    if (isLandscape) {
      format = format.landscape;
    }

    return format;
  }
}

/// Enhanced print preview dialog helper
class GeniusPrintPreviewEnhancedDialog {
  /// Shows an enhanced print preview dialog
  static Future<bool?> show({
    required BuildContext context,
    required Uint8List pdfBytes,
    required String documentName,
    required GeniusPdfConfig pdfConfig,
    GeniusPrintSettings? initialSettings,
    bool showSettings = true,
    bool showShareButton = true,
    bool showSaveButton = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog.fullscreen(
        child: GeniusPrintPreviewEnhanced(
          pdfBytes: pdfBytes,
          documentName: documentName,
          pdfConfig: pdfConfig,
          initialSettings: initialSettings,
          showSettings: showSettings,
          showShareButton: showShareButton,
          showSaveButton: showSaveButton,
          onCancel: () => Navigator.of(context).pop(false),
        ),
      ),
    );
  }
}
