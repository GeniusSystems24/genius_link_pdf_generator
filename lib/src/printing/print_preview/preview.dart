part of '../print_preview.dart';

/// Print preview widget that shows document preview and print settings
class GeniusPrintPreview extends StatefulWidget {

  /// Creates a print preview widget
  const GeniusPrintPreview({
    super.key,
    required this.pdfBytes,
    required this.documentName,
    required this.config,
    this.initialSettings,
    this.showSettings = true,
    this.showThumbnails = true,
    this.onPrint,
    this.onCancel,
    this.title,
    this.titleAr,
    this.controller,
  });
  /// PDF bytes to preview and print
  final Uint8List pdfBytes;

  /// Document name for printing
  final String documentName;

  /// Optional PDF configuration for defaults
  final GeniusPdfConfig config;

  /// Initial print settings
  final GeniusPrintSettings? initialSettings;

  /// Whether to show settings panel
  final bool showSettings;

  /// Whether to show page thumbnails
  final bool showThumbnails;

  /// Callback when print is requested
  final void Function(GeniusPrintSettings settings)? onPrint;

  /// Callback when cancelled
  final VoidCallback? onCancel;

  /// App bar title
  final String? title;

  /// App bar title in Arabic
  final String? titleAr;

  /// Optional controller for dependency injection and testing.
  final GeniusPrintPreviewController? controller;

  GeniusPrintPreviewController get effectiveController =>
      controller ?? GeniusPrintingCompositionRoot.previewController;

  @override
  State<GeniusPrintPreview> createState() => _GeniusPrintPreviewState();
}

class _GeniusPrintPreviewState extends State<GeniusPrintPreview> {
  late GeniusPrintSettings _settings;
  bool _isPrinting = false;
  final int _currentPage = 0;
  int _totalPages = 0;

  bool get _hasPdf => widget.pdfBytes.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings ??
        GeniusPrintSettings.fromPdfConfig(widget.config);
    _countPages();
  }

  Future<void> _countPages() async {
    try {
      // Count pages using PdfPreview's internal mechanism
      // For simplicity, we'll estimate based on document info
      // In a real implementation, you'd parse the PDF to get page count
      setState(() {
        _totalPages = 1; // Default to 1, will be updated by preview
      });
    } catch (e) {
      // Ignore errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? 'Print Preview / معاينة الطباعة'),
        actions: [
          if (widget.showSettings)
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings / الإعدادات',
              onPressed: _showSettingsDialog,
            ),
          IconButton(
            icon: _isPrinting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.print),
            tooltip: 'Print / طباعة',
            onPressed: _isPrinting || !_hasPdf ? null : _handlePrint,
          ),
        ],
      ),
      body: Column(
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
                    onPageFormatChanged: (format) {
                      // Handle page format change
                    },
                    pages: _getPageRange(),
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

          // Bottom bar with page info and quick settings
          _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildSettingsSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
          // Page info
          if (_totalPages > 0)
            Text(
              'Page ${_currentPage + 1} of $_totalPages',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          const Spacer(),

          // Cancel button
          TextButton(
            onPressed: widget.onCancel ?? () => Navigator.of(context).pop(),
            child: const Text('Cancel / إلغاء'),
          ),
          const SizedBox(width: 16),

          // Print button
          FilledButton.icon(
            onPressed: _isPrinting || !_hasPdf ? null : _handlePrint,
            icon: _isPrinting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.print),
            label: Text(_isPrinting ? 'Printing...' : 'Print / طباعة'),
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

    GeniusPdfLogger.info('Preview print: "${widget.documentName}"', tag: 'PrintPreview');
    setState(() {
      _isPrinting = true;
    });

    try {
      final result = await widget.effectiveController.print(
        pdfBytes: widget.pdfBytes,
        documentName: widget.documentName,
        settings: _settings,
        config: widget.config,
      );

      if (mounted) {
        setState(() {
          _isPrinting = false;
        });

        if (result.success) {
          GeniusPdfLogger.info('Preview print completed: "${widget.documentName}"', tag: 'PrintPreview');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Print job sent successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      GeniusPdfLogger.error('Preview print failed: "${widget.documentName}"', tag: 'PrintPreview', error: e);
      if (mounted) {
        setState(() {
          _isPrinting = false;
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

  List<int>? _getPageRange() {
    final range = _settings.pageRange;
    if (range == null || range.isAll) return null;

    if (range.pages != null) {
      return range.pages!.map((p) => p - 1).toList(); // Convert to 0-indexed
    }

    if (range.start != null && range.end != null) {
      return List.generate(
        range.end! - range.start! + 1,
        (i) => range.start! - 1 + i,
      );
    }

    return null;
  }
}

/// Print settings bottom sheet
