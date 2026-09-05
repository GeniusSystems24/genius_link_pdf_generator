import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/features/export/models/documents/template_html_export_examples.dart';
import 'package:genius_pdf_example/shared/presentation/controllers/demo_document_controller.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/feature_example_page.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Signature used by focused template-to-HTML export examples.
typedef TemplateHtmlExporter = Future<TemplateHtmlExportResult> Function({
  required bool isRtl,
  required bool embedImages,
  required bool includeStyles,
  required DemoDocumentController documents,
});

/// Focused example screen for exporting one business template as HTML.
///
/// Nothing is generated or exported during initialization. Export starts only
/// after the user presses **Run export**.
///
/// The HTML preview shows the exact UTF-8 data returned by the package exporter.
/// **Open HTML** opens the same bytes after they are persisted to disk.
class TemplateHtmlExportDetailScreen extends StatefulWidget {
  const TemplateHtmlExportDetailScreen({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.icon,
    required this.exportTemplate,
    required this.usageCode,
    this.initialRtl = false,
    this.initialEmbedImages = true,
    this.initialIncludeStyles = true,
  });

  final String category;
  final String title;
  final String description;
  final IconData icon;
  final TemplateHtmlExporter exportTemplate;
  final String usageCode;
  final bool initialRtl;
  final bool initialEmbedImages;
  final bool initialIncludeStyles;

  @override
  State<TemplateHtmlExportDetailScreen> createState() =>
      _TemplateHtmlExportDetailScreenState();
}

class _TemplateHtmlExportDetailScreenState
    extends State<TemplateHtmlExportDetailScreen> {
  late bool _isRtl;
  late bool _embedImages;
  late bool _includeStyles;

  TemplateHtmlExportResult? _result;
  Object? _error;
  bool _running = false;
  bool _opening = false;

  @override
  void initState() {
    super.initState();
    _isRtl = widget.initialRtl;
    _embedImages = widget.initialEmbedImages;
    _includeStyles = widget.initialIncludeStyles;
  }

  void _invalidateResult() {
    _result = null;
    _error = null;
  }

  void _setRtl(bool value) {
    if (_running || _opening || value == _isRtl) return;
    setState(() {
      _isRtl = value;
      _invalidateResult();
    });
  }

  void _setEmbedImages(bool value) {
    if (_running || _opening || value == _embedImages) return;
    setState(() {
      _embedImages = value;
      _invalidateResult();
    });
  }

  void _setIncludeStyles(bool value) {
    if (_running || _opening || value == _includeStyles) return;
    setState(() {
      _includeStyles = value;
      _invalidateResult();
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
        embedImages: _embedImages,
        includeStyles: _includeStyles,
        documents: demoDocuments,
      );

      if (!mounted) return;
      setState(() => _result = result);
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

  Future<void> _openHtml() async {
    final result = _result;
    if (result == null || _running || _opening) return;

    setState(() => _opening = true);
    try {
      await demoDocuments.open(result.filePath);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  Future<void> _copyHtml() async {
    final result = _result;
    if (result == null) return;

    await Clipboard.setData(ClipboardData(text: result.html));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(pdfLocalization.htmlCopiedToClipboard),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    final status = _running
        ? 'Exporting ${widget.title} to HTML…'
        : _error != null
            ? 'HTML export failed: $_error'
            : result == null
                ? 'Ready. Configure the HTML export and press Run export.'
                : 'Exported ${result.pageCount} page(s) to HTML '
                    '(${result.fileSizeFormatted}).';

    return FeatureExamplePage(
      title: '${widget.title} → HTML',
      description: widget.description,
      icon: widget.icon,
      contentTitle: 'HTML output preview',
      contentDescription:
          pdfLocalization.sourceBelowIsDecodedDirectlyExactDesc,
      settings: _buildSettings(),
      actions: <Widget>[
        FilledButton.icon(
          onPressed: (_running || _opening) ? null : _run,
          icon: _running
              ? const SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.html_rounded),
          label: Text(_running ? 'Exporting…' : 'Run export'),
        ),
        OutlinedButton.icon(
          onPressed: result == null || _running || _opening ? null : _openHtml,
          icon: const Icon(Icons.open_in_browser_rounded),
          label: Text(_opening ? 'Opening…' : 'Open HTML'),
        ),
        OutlinedButton.icon(
          onPressed: result == null || _running ? null : _copyHtml,
          icon: const Icon(Icons.copy_all_outlined),
          label:  Text(pdfLocalization.copyHtml),
        ),
      ],
      content: _HtmlOutputPreview(
        result: result,
        error: _error,
        running: _running,
      ),
      code: widget.usageCode,
      codeHeight: 760,
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
        FilterChip(
          selected: _includeStyles,
          onSelected: _running || _opening ? null : _setIncludeStyles,
          avatar: const Icon(Icons.style_outlined, size: 18),
          label:  Text(pdfLocalization.includeCssStyles),
        ),
        FilterChip(
          selected: _embedImages,
          onSelected: _running || _opening ? null : _setEmbedImages,
          avatar: const Icon(Icons.image_outlined, size: 18),
          label:  Text(pdfLocalization.embedImages),
        ),
      ],
    );
  }
}

class _HtmlOutputPreview extends StatelessWidget {
  const _HtmlOutputPreview({
    required this.result,
    required this.error,
    required this.running,
  });

  final TemplateHtmlExportResult? result;
  final Object? error;
  final bool running;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    if (running) {
      return  SizedBox(
        height: 600,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(height: 12),
              Text(pdfLocalization.convertingTemplatePdfToHtml),
            ],
          ),
        ),
      );
    }

    if (error != null) {
      return SizedBox(
        height: 600,
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
        height: 600,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.code_off_outlined, size: 48),
              SizedBox(height: 12),
              Text(pdfLocalization.noHtmlExportYet),
              SizedBox(height: 6),
              Text(
                pdfLocalization.pressRunExportGenerateTemplateDesc,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: <Widget>[
            Chip(
              avatar: const Icon(Icons.description_outlined, size: 18),
              label: Text('${value.pageCount} PDF page(s)'),
            ),
            Chip(
              avatar: const Icon(Icons.data_object_outlined, size: 18),
              label: Text(value.fileSizeFormatted),
            ),
            Chip(
              avatar: const Icon(Icons.style_outlined, size: 18),
              label: Text(value.includeStyles ? 'CSS included' : 'No CSS'),
            ),
            Chip(
              avatar: const Icon(Icons.image_outlined, size: 18),
              label: Text(
                value.embedImages
                    ? 'Embed images enabled'
                    : 'Embed images disabled',
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Tooltip(
          message: value.filePath,
          child: Text(
            value.filePath,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 520,
          decoration: BoxDecoration(
            color: colors.surfaceContainerLowest,
            border: Border.all(color: colors.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          clipBehavior: Clip.antiAlias,
          child: SelectionArea(
            child: Scrollbar(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    value.html,
                    softWrap: false,
                    style: textTheme.bodySmall?.copyWith(
                      fontFamily: 'monospace',
                      height: 1.45,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
