import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/code_viewer.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
typedef BusinessVerificationPdfGenerator = Future<Uint8List> Function(
  GeniusPdfConfig config,
);

/// Shared host for one focused business/ERP verification example.
///
/// PDF generation is manual: opening the screen does not create a document.
/// The bytes returned by [generator] are reused by both the inline preview and
/// the Open PDF action.
class BusinessVerificationExampleDetailScreen extends StatefulWidget {
  const BusinessVerificationExampleDetailScreen({
    super.key,
    required this.sprint,
    required this.title,
    required this.description,
    required this.apiName,
    required this.icon,
    required this.generator,
    required this.usageCode,
    required this.fileName,
  });

  final String sprint;
  final String title;
  final String description;
  final String apiName;
  final IconData icon;
  final BusinessVerificationPdfGenerator generator;
  final String usageCode;
  final String fileName;

  @override
  State<BusinessVerificationExampleDetailScreen> createState() =>
      _BusinessVerificationExampleDetailScreenState();
}

class _BusinessVerificationExampleDetailScreenState
    extends State<BusinessVerificationExampleDetailScreen> {
  bool _rtl = false;
  Uint8List? _previewData;
  Object? _error;
  bool _running = false;
  bool _opening = false;

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _rtl ? TextDirection.rtl : TextDirection.ltr,
      );

  void _setRtl(bool value) {
    if (_rtl == value || _running || _opening) return;
    setState(() {
      _rtl = value;
      _previewData = null;
      _error = null;
    });
  }

  Future<void> _run() async {
    if (_running || _opening) return;
    setState(() {
      _running = true;
      _error = null;
    });
    try {
      final bytes = await widget.generator(_config);
      if (!mounted) return;
      setState(() => _previewData = bytes);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _previewData = null;
        _error = error;
      });
    } finally {
      if (mounted) setState(() => _running = false);
    }
  }

  Future<void> _openPdf() async {
    final bytes = _previewData;
    if (bytes == null || _running || _opening) return;
    setState(() => _opening = true);
    try {
      await demoDocuments.saveAndOpen(bytes: bytes, fileName: widget.fileName);
    } finally {
      if (mounted) setState(() => _opening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.icon, size: 30, color: colors.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.sprint, style: theme.textTheme.labelLarge),
                    const SizedBox(height: 4),
                    Text(widget.title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 6),
                    Text(widget.description, style: theme.textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    Text(widget.apiName, style: theme.textTheme.labelMedium),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<bool>(
                segments:  [
                  ButtonSegment(value: false, label: Text(pdfLocalization.ltr)),
                  ButtonSegment(value: true, label: Text(pdfLocalization.rtl)),
                ],
                selected: <bool>{_rtl},
                onSelectionChanged: (_running || _opening)
                    ? null
                    : (selection) => _setRtl(selection.first),
              ),
              FilledButton.icon(
                onPressed: (_running || _opening) ? null : _run,
                icon: _running
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(
                  _running
                      ? 'Running…'
                      : _previewData == null
                          ? 'Run example'
                          : 'Run again',
                ),
              ),
              OutlinedButton.icon(
                onPressed: _previewData == null || _running || _opening
                    ? null
                    : _openPdf,
                icon: const Icon(Icons.open_in_new_rounded),
                label: Text(_opening ? 'Opening…' : 'Open PDF'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final preview = _BusinessPdfPreviewPanel(
                data: _previewData,
                error: _error,
                running: _running,
              );
              final code = CodeViewer(
                title: pdfLocalization.dartUsageCode,
                code: widget.usageCode,
              );
              if (constraints.maxWidth >= 1100) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: preview),
                    const SizedBox(width: 20),
                    Expanded(child: code),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  preview,
                  const SizedBox(height: 20),
                  code,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BusinessPdfPreviewPanel extends StatelessWidget {
  const _BusinessPdfPreviewPanel({
    required this.data,
    required this.error,
    required this.running,
  });

  final Uint8List? data;
  final Object? error;
  final bool running;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    Widget child;
    if (running) {
      child =  Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 12),
            Text(pdfLocalization.generatingPreview),
          ],
        ),
      );
    } else if (error != null) {
      child = Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Generation failed:\n$error',
            textAlign: TextAlign.center,
            style: TextStyle(color: colors.error),
          ),
        ),
      );
    } else if (data == null) {
      child =  Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.picture_as_pdf_outlined, size: 42),
              SizedBox(height: 12),
              Text(pdfLocalization.readyToRun),
              SizedBox(height: 6),
              Text(
                pdfLocalization.pressRunExampleGenerateDocumentShowDesc2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      child = GeniusPdfPreviewWidget(pdfData: data!);
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(height: 720, child: child),
    );
  }
}
