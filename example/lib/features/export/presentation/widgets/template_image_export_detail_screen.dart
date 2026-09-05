
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/features/export/models/documents/template_image_export_examples.dart';
import 'package:genius_pdf_example/shared/presentation/controllers/demo_document_controller.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/feature_example_page.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Signature used by focused template-image-export examples.
typedef TemplateImageExporter = Future<TemplateImageExportResult> Function({
  required bool isRtl,
  required GeniusExportFormat format,
  required GeniusImageQuality quality,
  required DemoDocumentController documents,
});

/// Focused example screen for exporting one PDF template as PNG/JPEG images.
///
/// Nothing is generated during initialization. The export starts only when the
/// user presses **Run export**. All exported pages are previewed from the exact
/// bytes that were persisted by the example generator.
class TemplateImageExportDetailScreen extends StatefulWidget {
  const TemplateImageExportDetailScreen({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.exportTemplate,
    required this.usageCode,
    this.initialRtl = false,
  });

  final String category;
  final String title;
  final String description;
  final IconData icon;
  final TemplateImageExporter exportTemplate;
  final String usageCode;
  final bool initialRtl;

  @override
  State<TemplateImageExportDetailScreen> createState() =>
      _TemplateImageExportDetailScreenState();
}

class _TemplateImageExportDetailScreenState
    extends State<TemplateImageExportDetailScreen> {
  late bool _isRtl;
  GeniusExportFormat _format = GeniusExportFormat.png;
  GeniusImageQuality _quality = GeniusImageQuality.high;
  TemplateImageExportResult? _result;
  Object? _error;
  bool _running = false;
  bool _opening = false;
  int _pageIndex = 0;

  @override
  void initState() {
    super.initState();
    _isRtl = widget.initialRtl;
  }

  void _invalidate() {
    _result = null;
    _error = null;
    _pageIndex = 0;
  }

  void _setRtl(bool value) {
    if (_running || _opening || value == _isRtl) return;
    setState(() {
      _isRtl = value;
      _invalidate();
    });
  }

  void _setFormat(GeniusExportFormat value) {
    if (_running || _opening || value == _format) return;
    setState(() {
      _format = value;
      _invalidate();
    });
  }

  void _setQuality(GeniusImageQuality value) {
    if (_running || _opening || value == _quality) return;
    setState(() {
      _quality = value;
      _invalidate();
    });
  }

  Future<void> _run() async {
    if (_running || _opening) return;
    setState(() {
      _running = true;
      _error = null;
    });

    try {
      final result = await widget.exportTemplate(
        isRtl: _isRtl,
        format: _format,
        quality: _quality,
        documents: demoDocuments,
      );
      if (!mounted) return;
      setState(() {
        _result = result;
        _pageIndex = 0;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _result = null;
      });
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  Future<void> _openCurrentImage() async {
    final result = _result;
    if (result == null || result.filePaths.isEmpty || _running || _opening) {
      return;
    }

    final safeIndex = _pageIndex.clamp(0, result.filePaths.length - 1).toInt();
    setState(() => _opening = true);
    try {
      await demoDocuments.open(result.filePaths[safeIndex]);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;
    final status = _running
        ? 'Exporting ${widget.title} to ${_format.displayName}…'
        : _error != null
            ? 'Export failed: $_error'
            : result == null
                ? 'Ready. Configure the image export and press Run export.'
                : 'Exported ${result.pageCount} page(s) as '
                    '${result.format.displayName} at '
                    '${result.quality.displayName} quality.';

    return FeatureExamplePage(
      title: '${widget.title} → Image',
      description: widget.description,
      icon: widget.icon,
      contentTitle: 'Image preview',
      contentDescription:
          pdfLocalization.previewExportedBytesSavedExampleDesc,
      settings: _buildSettings(),
      actions: <Widget>[
        FilledButton.icon(
          onPressed: (_running || _opening) ? null : _run,
          icon: _running
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.image_outlined),
          label: Text(_running ? 'Exporting…' : 'Run export'),
        ),
        OutlinedButton.icon(
          onPressed: result == null || _running || _opening
              ? null
              : _openCurrentImage,
          icon: const Icon(Icons.open_in_new_rounded),
          label: Text(_opening ? 'Opening…' : 'Open image'),
        ),
      ],
      content: _ImagePreview(
        result: result,
        error: _error,
        running: _running,
        pageIndex: _pageIndex,
        onPageChanged: (index) => setState(() => _pageIndex = index),
      ),
      code: widget.usageCode,
      codeHeight: 720,
      statusMessage: status,
      statusTone: _error != null
          ? FeatureExampleTone.danger
          : _running
              ? FeatureExampleTone.info
              : result != null
                  ? FeatureExampleTone.success
                  : FeatureExampleTone.neutral,
    );
  }

  Widget _buildSettings() {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: <Widget>[
        SegmentedButton<bool>(
          segments: <ButtonSegment<bool>>[
            ButtonSegment<bool>(value: false, label: Text(pdfLocalization.ltr)),
            ButtonSegment<bool>(value: true, label: Text(pdfLocalization.rtl)),
          ],
          selected: <bool>{_isRtl},
          onSelectionChanged: _running || _opening
              ? null
              : (selection) => _setRtl(selection.first),
        ),
        SegmentedButton<GeniusExportFormat>(
          segments: <ButtonSegment<GeniusExportFormat>>[
            ButtonSegment<GeniusExportFormat>(
              value: GeniusExportFormat.png,
              label: Text(pdfLocalization.png),
              icon: Icon(Icons.image_outlined),
            ),
            ButtonSegment<GeniusExportFormat>(
              value: GeniusExportFormat.jpeg,
              label: Text(pdfLocalization.jpeg),
              icon: Icon(Icons.photo_outlined),
            ),
          ],
          selected: <GeniusExportFormat>{_format},
          onSelectionChanged: _running || _opening
              ? null
              : (selection) => _setFormat(selection.first),
        ),
        DropdownButton<GeniusImageQuality>(
          value: _quality,
          onChanged: _running || _opening
              ? null
              : (value) {
                  if (value != null) _setQuality(value);
                },
          items: GeniusImageQuality.values
              .map(
                (quality) => DropdownMenuItem<GeniusImageQuality>(
                  value: quality,
                  child: Text(
                    '${quality.displayName} (${quality.dpi} DPI)',
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ],
    );
  }
}

class _ImagePreview extends StatelessWidget {
  const _ImagePreview({
    required this.result,
    required this.error,
    required this.running,
    required this.pageIndex,
    required this.onPageChanged,
  });

  final TemplateImageExportResult? result;
  final Object? error;
  final bool running;
  final int pageIndex;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (running) {
      return  SizedBox(
        height: 560,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text(pdfLocalization.rasterizingTemplatePages),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return SizedBox(
        height: 560,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '$error',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.error),
            ),
          ),
        ),
      );
    }

    final value = result;
    if (value == null) {
      return  SizedBox(
        height: 560,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.image_search_outlined, size: 48),
              SizedBox(height: 12),
              Text(pdfLocalization.noExportedImageYet),
              SizedBox(height: 6),
              Text(pdfLocalization.pressRunExportGeneratePreviewDesc),
            ],
          ),
        ),
      );
    }

    final safeIndex = pageIndex.clamp(0, value.pages.length - 1).toInt();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Page ${safeIndex + 1} / ${value.pages.length}'),
            const Spacer(),
            if (value.pages.length > 1) ...<Widget>[
              IconButton(
                tooltip: pdfLocalization.previousPage,
                onPressed: safeIndex > 0
                    ? () => onPageChanged(safeIndex - 1)
                    : null,
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              IconButton(
                tooltip: pdfLocalization.nextPage,
                onPressed: safeIndex < value.pages.length - 1
                    ? () => onPageChanged(safeIndex + 1)
                    : null,
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 520,
          alignment: Alignment.topCenter,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            border: Border.all(color: colors.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 5,
            child: SingleChildScrollView(
              child: Image.memory(
                value.pages[safeIndex],
                fit: BoxFit.contain,
                gaplessPlayback: true,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
