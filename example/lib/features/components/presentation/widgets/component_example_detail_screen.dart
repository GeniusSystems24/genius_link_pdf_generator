import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/features/components/models/documents/components_demo_documents.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/code_viewer.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
/// Shared presentation for one focused PDF component example.
///
/// No document is generated when this widget is created. The example waits for
/// an explicit **Run example** action before invoking [buildComponentDemoBytes].
class ComponentExampleDetailScreen extends StatefulWidget {
  const ComponentExampleDetailScreen({
    super.key,
    required this.componentId,
    required this.category,
    required this.title,
    required this.apiName,
    required this.description,
    required this.icon,
    required this.usageCode,
    this.initialRtl = true,
  });

  final String componentId;
  final String category;
  final String title;
  final String apiName;
  final String description;
  final IconData icon;
  final String usageCode;
  final bool initialRtl;

  @override
  State<ComponentExampleDetailScreen> createState() =>
      _ComponentExampleDetailScreenState();
}

class _ComponentExampleDetailScreenState
    extends State<ComponentExampleDetailScreen> {
  late bool _isRtl;
  Uint8List? _previewData;
  Object? _executionError;
  bool _executing = false;
  bool _openingPdf = false;

  @override
  void initState() {
    super.initState();
    _isRtl = widget.initialRtl;
    // Intentionally do not generate the document here.
  }

  void _setDirection(bool value) {
    if (_isRtl == value) return;
    setState(() {
      _isRtl = value;
      // The existing preview was produced with a different direction. Do not
      // regenerate automatically; wait for the next explicit Run example.
      _previewData = null;
      _executionError = null;
    });
  }

  Future<void> _executeExample() async {
    if (_executing || _openingPdf) return;

    setState(() {
      _executing = true;
      _executionError = null;
    });

    try {
      final config = geniusPdfConfig.copyWith(
        textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
      );
      final bytes = await buildComponentDemoBytes(
        component: widget.componentId,
        config: config,
      );

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
        fileName: 'demo_${widget.componentId}.pdf',
      );
      if (mounted) {
        _showMessage('PDF opened successfully.');
      }
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
            _ComponentExampleHeader(
              category: widget.category,
              title: widget.title,
              apiName: widget.apiName,
              description: widget.description,
              icon: widget.icon,
              isRtl: _isRtl,
              executing: _executing,
              openingPdf: _openingPdf,
              hasPreview: _previewData != null,
              onDirectionChanged: _setDirection,
              onExecute: _executeExample,
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
                            child: _PdfPreviewPanel(
                              pdfData: _previewData,
                              executing: _executing,
                              error: _executionError,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 10,
                            child: _DartUsagePanel(code: widget.usageCode),
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
                          height: constraints.maxWidth >= 720 ? 680 : 540,
                          child: _PdfPreviewPanel(
                            pdfData: _previewData,
                            executing: _executing,
                            error: _executionError,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: constraints.maxWidth >= 720 ? 640 : 560,
                          child: _DartUsagePanel(code: widget.usageCode),
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

class _ComponentExampleHeader extends StatelessWidget {
  const _ComponentExampleHeader({
    required this.category,
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

  final String category;
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
          final compact = constraints.maxWidth < 840;

          final identity = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: colors.onPrimaryContainer, size: 25),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      apiName,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                        height: 1.45,
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
                  ButtonSegment<bool>(
                    value: false,
                    label: Text(pdfLocalization.ltr),
                    icon: Icon(Icons.format_textdirection_l_to_r_rounded),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text(pdfLocalization.rtl),
                    icon: Icon(Icons.format_textdirection_r_to_l_rounded),
                  ),
                ],
                selected: <bool>{isRtl},
                onSelectionChanged: executing || openingPdf
                    ? null
                    : (value) => onDirectionChanged(value.first),
                showSelectedIcon: false,
              ),
              FilledButton.icon(
                onPressed: executing || openingPdf ? null : onExecute,
                icon: executing
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.play_arrow_rounded),
                label: Text(executing ? 'Generating…' : 'Run example'),
              ),
              OutlinedButton.icon(
                onPressed: hasPreview && !executing && !openingPdf
                    ? onOpenPdf
                    : null,
                icon: openingPdf
                    ? const SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.open_in_new_rounded),
                label: Text(openingPdf ? 'Opening…' : 'Open PDF'),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [identity, const SizedBox(height: 16), actions],
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

class _PdfPreviewPanel extends StatelessWidget {
  const _PdfPreviewPanel({
    required this.pdfData,
    required this.executing,
    required this.error,
  });

  final Uint8List? pdfData;
  final bool executing;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PanelHeader(
            icon: Icons.picture_as_pdf_outlined,
            title: pdfLocalization.pdfPreview,
            trailing: pdfData == null
                ? _StatusPill(
                    label: executing ? 'Generating' : 'Not generated',
                    icon: executing
                        ? Icons.sync_rounded
                        : Icons.hourglass_empty_rounded,
                  )
                :  _StatusPill(
                    label: pdfLocalization.generated,
                    icon: Icons.check_circle_outline_rounded,
                  ),
          ),
          Expanded(
            child: pdfData != null
                ? GeniusPdfPreviewWidget(pdfData: pdfData!)
                : _ExecutionPlaceholder(
                    loading: executing,
                    error: error != null,
                    message: error != null
                        ? 'Generation failed. Review the error and run the example again.'
                        : 'Press Run example to generate this component document and display its PDF preview.',
                  ),
          ),
        ],
      ),
    );
  }
}

class _DartUsagePanel extends StatelessWidget {
  const _DartUsagePanel({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: CodeViewer(
        title: pdfLocalization.dartUsageCode,
        code: code,
        height: double.infinity,
      ),
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.icon, required this.title, this.trailing});

  final IconData icon;
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      constraints: BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 19, color: colors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.onSurfaceVariant),
          const SizedBox(width: 5),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExecutionPlaceholder extends StatelessWidget {
  const _ExecutionPlaceholder({
    required this.loading,
    required this.error,
    required this.message,
  });

  final bool loading;
  final bool error;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final foreground = error ? colors.error : colors.onSurfaceVariant;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (loading)
                const SizedBox.square(
                  dimension: 38,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              else
                Icon(
                  error
                      ? Icons.error_outline_rounded
                      : Icons.play_circle_outline_rounded,
                  size: 48,
                  color: foreground,
                ),
              const SizedBox(height: 14),
              Text(
                loading
                    ? 'Generating PDF…'
                    : (error ? 'Generation failed' : 'Ready to run'),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: foreground,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                loading
                    ? 'The example is building the document for preview.'
                    : message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
