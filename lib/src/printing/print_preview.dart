/// Print Preview Widget
///
/// Provides a preview of the document before printing with settings adjustment.
library;

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';

import 'printer_models.dart';
import 'printer_service.dart';

/// Print preview widget that shows document preview and print settings
class GeniusPrintPreview extends StatefulWidget {

  /// Creates a print preview widget
  const GeniusPrintPreview({
    super.key,
    required this.pdfBytes,
    required this.documentName,
    this.initialSettings,
    this.showSettings = true,
    this.showThumbnails = true,
    this.onPrint,
    this.onCancel,
    this.title,
    this.titleAr,
  });
  /// PDF bytes to preview and print
  final Uint8List pdfBytes;

  /// Document name for printing
  final String documentName;

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

  @override
  State<GeniusPrintPreview> createState() => _GeniusPrintPreviewState();
}

class _GeniusPrintPreviewState extends State<GeniusPrintPreview> {
  late GeniusPrintSettings _settings;
  bool _isPrinting = false;
  final int _currentPage = 0;
  int _totalPages = 0;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialSettings ?? GeniusPrintSettings.defaults();
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
            onPressed: _isPrinting ? null : _handlePrint,
          ),
        ],
      ),
      body: Column(
        children: [
          // Settings summary bar
          if (widget.showSettings) _buildSettingsSummary(),

          // Preview area
          Expanded(
            child: PdfPreview(
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
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading preview: $error'),
                  ],
                ),
              ),
            ),
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
            onPressed: _isPrinting ? null : _handlePrint,
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

    setState(() {
      _isPrinting = true;
    });

    try {
      final result = await GeniusPrinterService.instance.printWithDialog(
        pdfBytes: widget.pdfBytes,
        documentName: widget.documentName,
        settings: _settings,
      );

      if (mounted) {
        setState(() {
          _isPrinting = false;
        });

        if (result.success) {
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
class _PrintSettingsSheet extends StatefulWidget {

  const _PrintSettingsSheet({
    required this.settings,
    required this.onSettingsChanged,
  });
  final GeniusPrintSettings settings;
  final void Function(GeniusPrintSettings) onSettingsChanged;

  @override
  State<_PrintSettingsSheet> createState() => _PrintSettingsSheetState();
}

class _PrintSettingsSheetState extends State<_PrintSettingsSheet> {
  late GeniusPrintSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  void _updateSettings(GeniusPrintSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    widget.onSettingsChanged(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.settings),
                    const SizedBox(width: 8),
                    Text(
                      'Print Settings / إعدادات الطباعة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Settings list
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Copies
                    _buildSettingTile(
                      title: 'Copies / النسخ',
                      subtitle: '${_settings.copies} copy/copies',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _settings.copies > 1
                                ? () => _updateSettings(
                                    _settings.copyWith(copies: _settings.copies - 1))
                                : null,
                          ),
                          Text('${_settings.copies}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _settings.copies < 99
                                ? () => _updateSettings(
                                    _settings.copyWith(copies: _settings.copies + 1))
                                : null,
                          ),
                        ],
                      ),
                    ),

                    // Paper Size
                    _buildDropdownTile<GeniusPaperSize>(
                      title: 'Paper Size / حجم الورق',
                      value: _settings.paperSize,
                      items: GeniusPaperSize.values
                          .where((s) => s != GeniusPaperSize.custom)
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text('${s.displayName} (${s.displayNameAr})'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(paperSize: value));
                        }
                      },
                    ),

                    // Orientation
                    _buildDropdownTile<GeniusPrintOrientation>(
                      title: 'Orientation / الاتجاه',
                      value: _settings.orientation,
                      items: const [
                        DropdownMenuItem(
                          value: GeniusPrintOrientation.portrait,
                          child: Text('Portrait / عمودي'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintOrientation.landscape,
                          child: Text('Landscape / أفقي'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(orientation: value));
                        }
                      },
                    ),

                    // Color Mode
                    _buildDropdownTile<GeniusPrintColorMode>(
                      title: 'Color / الألوان',
                      value: _settings.colorMode,
                      items: const [
                        DropdownMenuItem(
                          value: GeniusPrintColorMode.color,
                          child: Text('Color / ملون'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintColorMode.grayscale,
                          child: Text('Grayscale / رمادي'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintColorMode.blackAndWhite,
                          child: Text('Black & White / أبيض وأسود'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(colorMode: value));
                        }
                      },
                    ),

                    // Quality
                    _buildDropdownTile<GeniusPrintQuality>(
                      title: 'Quality / الجودة',
                      value: _settings.quality,
                      items: const [
                        DropdownMenuItem(
                          value: GeniusPrintQuality.draft,
                          child: Text('Draft / مسودة'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintQuality.normal,
                          child: Text('Normal / عادي'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintQuality.high,
                          child: Text('High / عالي'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintQuality.photo,
                          child: Text('Photo / صورة'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(quality: value));
                        }
                      },
                    ),

                    // Duplex
                    _buildDropdownTile<GeniusDuplexMode>(
                      title: 'Two-Sided / الوجهين',
                      value: _settings.duplexMode,
                      items: const [
                        DropdownMenuItem(
                          value: GeniusDuplexMode.simplex,
                          child: Text('Off / إيقاف'),
                        ),
                        DropdownMenuItem(
                          value: GeniusDuplexMode.longEdge,
                          child: Text('Long Edge / الحافة الطويلة'),
                        ),
                        DropdownMenuItem(
                          value: GeniusDuplexMode.shortEdge,
                          child: Text('Short Edge / الحافة القصيرة'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(duplexMode: value));
                        }
                      },
                    ),

                    // Pages per sheet
                    _buildDropdownTile<int>(
                      title: 'Pages per Sheet / صفحات في ورقة',
                      value: _settings.pagesPerSheet,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1')),
                        DropdownMenuItem(value: 2, child: Text('2')),
                        DropdownMenuItem(value: 4, child: Text('4')),
                        DropdownMenuItem(value: 6, child: Text('6')),
                        DropdownMenuItem(value: 9, child: Text('9')),
                        DropdownMenuItem(value: 16, child: Text('16')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(pagesPerSheet: value));
                        }
                      },
                    ),

                    // Collate
                    SwitchListTile(
                      title: const Text('Collate / ترتيب'),
                      subtitle: const Text('Group pages of each copy together'),
                      value: _settings.collate,
                      onChanged: (value) {
                        _updateSettings(_settings.copyWith(collate: value));
                      },
                    ),

                    // Reverse Order
                    SwitchListTile(
                      title: const Text('Reverse Order / ترتيب عكسي'),
                      subtitle: const Text('Print last page first'),
                      value: _settings.reverseOrder,
                      onChanged: (value) {
                        _updateSettings(_settings.copyWith(reverseOrder: value));
                      },
                    ),

                    const SizedBox(height: 16),

                    // Presets
                    const Text(
                      'Quick Presets / إعدادات سريعة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.refresh, size: 18),
                          label: const Text('Default'),
                          onPressed: () {
                            _updateSettings(GeniusPrintSettings.defaults());
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.eco, size: 18),
                          label: const Text('Eco'),
                          onPressed: () {
                            _updateSettings(GeniusPrintSettings.eco());
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.high_quality, size: 18),
                          label: const Text('High Quality'),
                          onPressed: () {
                            _updateSettings(GeniusPrintSettings.highQuality());
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.speed, size: 18),
                          label: const Text('Draft'),
                          onPressed: () {
                            _updateSettings(GeniusPrintSettings.draft());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Apply button
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Done / تم'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }

  Widget _buildDropdownTile<T>({
    required String title,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }
}

/// Print preview dialog helper
class GeniusPrintPreviewDialog {
  /// Shows a print preview dialog
  static Future<bool?> show({
    required BuildContext context,
    required Uint8List pdfBytes,
    required String documentName,
    GeniusPrintSettings? initialSettings,
    bool showSettings = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog.fullscreen(
        child: GeniusPrintPreview(
          pdfBytes: pdfBytes,
          documentName: documentName,
          initialSettings: initialSettings,
          showSettings: showSettings,
          onCancel: () => Navigator.of(context).pop(false),
        ),
      ),
    );
  }
}
