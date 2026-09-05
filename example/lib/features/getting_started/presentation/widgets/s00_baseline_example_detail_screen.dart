import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/code_viewer.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
typedef S00DocumentBuilderFactory = GeniusPdfDocumentBuilder Function(
  GeniusPdfConfig config,
);

/// Shared presentation for one focused S00 baseline/regression example.
///
/// The document is intentionally not generated from [initState]. Generation is
/// explicit and starts only when the user presses **Run example**.
class S00BaselineExampleDetailScreen extends StatefulWidget {
  const S00BaselineExampleDetailScreen({
    super.key,
    required this.title,
    required this.apiName,
    required this.description,
    required this.icon,
    required this.builderFactory,
    required this.usageCode,
    required this.expectedLtr,
    required this.expectedRtl,
    required this.fileName,
    this.initialRtl = true,
  });

  final String title;
  final String apiName;
  final String description;
  final IconData icon;
  final S00DocumentBuilderFactory builderFactory;
  final String usageCode;
  final String expectedLtr;
  final String expectedRtl;
  final String fileName;
  final bool initialRtl;

  @override
  State<S00BaselineExampleDetailScreen> createState() =>
      _S00BaselineExampleDetailScreenState();
}

class _S00BaselineExampleDetailScreenState
    extends State<S00BaselineExampleDetailScreen> {
  late bool _isRtl;
  Uint8List? _previewData;
  Object? _executionError;
  bool _executing = false;
  bool _openingPdf = false;

  @override
  void initState() {
    super.initState();
    _isRtl = widget.initialRtl;
  }

  GeniusPdfConfig get _config => geniusPdfConfig.copyWith(
        textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
      );

  String get _expected => _isRtl ? widget.expectedRtl : widget.expectedLtr;

  void _setDirection(bool rtl) {
    if (_isRtl == rtl) return;
    setState(() {
      _isRtl = rtl;
      _previewData = null;
      _executionError = null;
    });
  }

  Future<void> _runExample() async {
    if (_executing || _openingPdf) return;

    setState(() {
      _executing = true;
      _executionError = null;
    });

    GeniusPdfDocumentBuilder? builder;
    try {
      builder = widget.builderFactory(_config);
      final bytes = Uint8List.fromList(builder.generate());

      if (!mounted) return;
      setState(() {
        _previewData = bytes;
        _executionError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _previewData = null;
        _executionError = error;
      });
      _showMessage('Unable to generate PDF preview: $error', error: true);
    } finally {
      builder?.dispose();
      if (mounted) setState(() => _executing = false);
    }
  }

  Future<void> _openPdf() async {
    final bytes = _previewData;
    if (bytes == null || _executing || _openingPdf) return;

    setState(() => _openingPdf = true);
    try {
      await demoDocuments.saveAndOpen(
        bytes: bytes,
        fileName: widget.fileName,
      );
      if (mounted) _showMessage('PDF opened successfully.');
    } catch (error) {
      if (mounted) {
        _showMessage('Unable to open PDF: $error', error: true);
      }
    } finally {
      if (mounted) setState(() => _openingPdf = false);
    }
  }

  void _showMessage(String message, {bool error = false}) {
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: error ? colors.error : colors.inverseSurface,
        content: Text(
          message,
          style: TextStyle(
            color: error ? colors.onError : colors.onInverseSurface,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              title: widget.title,
              apiName: widget.apiName,
              description: widget.description,
              icon: widget.icon,
              isRtl: _isRtl,
              executing: _executing,
              openingPdf: _openingPdf,
              hasPreview: _previewData != null,
              onDirectionChanged: _setDirection,
              onExecute: _runExample,
              onOpenPdf: _openPdf,
            ),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final desktop = constraints.maxWidth >= 1080;
                  final horizontal = constraints.maxWidth >= 720 ? 24.0 : 16.0;

                  if (desktop) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(
                        horizontal,
                        12,
                        horizontal,
                        24,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 13,
                            child: _PreviewColumn(
                              pdfData: _previewData,
                              executing: _executing,
                              error: _executionError,
                              expected: _expected,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 10,
                            child: CodeViewer(
                              title: pdfLocalization.dartUsageCode,
                              code: widget.usageCode,
                              height: double.infinity,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontal,
                      12,
                      horizontal,
                      24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: constraints.maxWidth >= 720 ? 760 : 620,
                          child: _PreviewColumn(
                            pdfData: _previewData,
                            executing: _executing,
                            error: _executionError,
                            expected: _expected,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: constraints.maxWidth >= 720 ? 680 : 580,
                          child: CodeViewer(
                            title: pdfLocalization.dartUsageCode,
                            code: widget.usageCode,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.apiName,
    required this.description,
    required this.icon,
    required this.isRtl,
    required this.executing,
    required this.openingPdf,
    required this.hasPreview,
    required this.onDirectionChanged,
    required this.onExecute,
    required this.onOpenPdf,
  });

  final String title;
  final String apiName;
  final String description;
  final IconData icon;
  final bool isRtl;
  final bool executing;
  final bool openingPdf;
  final bool hasPreview;
  final ValueChanged<bool> onDirectionChanged;
  final VoidCallback onExecute;
  final VoidCallback onOpenPdf;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 900;

          final identity = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: colors.onPrimaryContainer),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pdfLocalization.gettingStartedS00Baseline,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(title, style: theme.textTheme.headlineSmall),
                    const SizedBox(height: 4),
                    Text(
                      apiName,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final actions = Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<bool>(
                segments:  [
                  ButtonSegment(value: false, label: Text(pdfLocalization.ltr)),
                  ButtonSegment(value: true, label: Text(pdfLocalization.rtl)),
                ],
                selected: <bool>{isRtl},
                onSelectionChanged: executing || openingPdf
                    ? null
                    : (selection) => onDirectionChanged(selection.first),
              ),
              FilledButton.icon(
                onPressed: executing || openingPdf ? null : onExecute,
                icon: executing
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(
                  executing
                      ? 'Running…'
                      : hasPreview
                          ? 'Run again'
                          : 'Run example',
                ),
              ),
              OutlinedButton.icon(
                onPressed:
                    hasPreview && !executing && !openingPdf ? onOpenPdf : null,
                icon: openingPdf
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.open_in_new_rounded),
                label:  Text(pdfLocalization.openPdf),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                identity,
                const SizedBox(height: 16),
                actions,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: identity),
              const SizedBox(width: 24),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _PreviewColumn extends StatelessWidget {
  const _PreviewColumn({
    required this.pdfData,
    required this.executing,
    required this.error,
    required this.expected,
  });

  final Uint8List? pdfData;
  final bool executing;
  final Object? error;
  final String expected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: colors.surfaceContainerLow,
              border: Border.all(color: colors.outlineVariant),
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: _previewBody(context),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: colors.surfaceContainer,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.outlineVariant),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.checklist_rounded, color: colors.primary),
              const SizedBox(width: 10),
              Expanded(child: Text('Expected result: $expected')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _previewBody(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    if (executing) {
      return  Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 14),
            Text(pdfLocalization.generatingPreview),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded, color: colors.error, size: 42),
              const SizedBox(height: 12),
               Text(pdfLocalization.pdfGenerationFailed),
              const SizedBox(height: 6),
              SelectableText(
                '$error',
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    final data = pdfData;
    if (data == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.picture_as_pdf_outlined,
                size: 48,
                color: colors.primary,
              ),
              const SizedBox(height: 12),
              Text(
                pdfLocalization.readyToRun,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 6),
              Text(
                pdfLocalization.pressRunExampleGenerateBaselineDesc,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurfaceVariant),
              ),
            ],
          ),
        ),
      );
    }

    return GeniusPdfPreviewWidget(
      pdfData: data,
      canChangeOrientation: false,
      canChangePageFormat: false,
      fullscreenTitle: 'S00 PDF Preview',
    );
  }
}
