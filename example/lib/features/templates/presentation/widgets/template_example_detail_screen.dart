import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/templates/models/documents/template_example_build.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/code_viewer.dart';

/// Builds one report-template example for the requested document direction.
typedef TemplateExampleBuilder =
    TemplateExampleBuild Function({required bool isRtl});

/// Shared presentation for one dedicated template example.
///
/// Nothing is generated in [initState]. The PDF builder is created only after
/// the user presses **Run example**. Changing document direction invalidates
/// the current preview and requires another explicit execution.
class TemplateExampleDetailScreen extends StatefulWidget {
  const TemplateExampleDetailScreen({
    super.key,
    required this.category,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.icon,
    required this.buildTemplate,
    required this.usageCode,
    this.initialRtl = true,
  });

  final String category;
  final String title;
  final String titleAr;
  final String description;
  final IconData icon;
  final TemplateExampleBuilder buildTemplate;
  final String usageCode;
  final bool initialRtl;

  @override
  State<TemplateExampleDetailScreen> createState() =>
      _TemplateExampleDetailScreenState();
}

class _TemplateExampleDetailScreenState
    extends State<TemplateExampleDetailScreen> {
  late bool _isRtl;
  Uint8List? _previewData;
  Object? _executionError;
  bool _executing = false;
  bool _openingPdf = false;

  @override
  void initState() {
    super.initState();
    _isRtl = widget.initialRtl;
    // Intentionally do not create a builder or generate a document here.
  }

  void _setDirection(bool value) {
    if (_isRtl == value) return;
    setState(() {
      _isRtl = value;
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

    TemplateExampleBuild? build;
    try {
      build = widget.buildTemplate(isRtl: _isRtl);
      final bytes = await Future<Uint8List>(() {
        return Uint8List.fromList(build!.builder.generate());
      });

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
      build?.builder.dispose();
      if (mounted) setState(() => _executing = false);
    }
  }

  Future<void> _openPdf() async {
    if (_previewData == null || _executing || _openingPdf) return;

    setState(() => _openingPdf = true);
    TemplateExampleBuild? build;
    try {
      build = widget.buildTemplate(isRtl: _isRtl);
      final result = await const GeniusPdfService().generateAndOpen(
        builder: build.builder,
        fileName: build.fileName,
      );

      if (!mounted) return;
      result.when(
        onSuccess: (_) =>
            _showMessage('PDF generated and opened successfully.'),
        onFailure: (failure) => _showMessage(failure.message, error: true),
      );
    } catch (error) {
      if (mounted) {
        _showMessage('Unable to open PDF: $error', error: true);
      }
    } finally {
      build?.builder.dispose();
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
            _TemplateExampleHeader(
              category: widget.category,
              title: widget.title,
              titleAr: widget.titleAr,
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
                  final desktop = constraints.maxWidth >= 1050;
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
                              title: widget.title,
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
                          height: constraints.maxWidth < 600 ? 560 : 680,
                          child: _PdfPreviewPanel(
                            title: widget.title,
                            pdfData: _previewData,
                            executing: _executing,
                            error: _executionError,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: constraints.maxWidth < 600 ? 520 : 620,
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

class _TemplateExampleHeader extends StatelessWidget {
  const _TemplateExampleHeader({
    required this.category,
    required this.title,
    required this.titleAr,
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
  final String titleAr;
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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        border: Border(bottom: BorderSide(color: colors.outlineVariant)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 860;
          final identity = Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: colors.onPrimaryContainer),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      runSpacing: 4,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          titleAr,
                          textDirection: TextDirection.rtl,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      maxLines: compact ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final controls = Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment<bool>(
                    value: false,
                    label: Text('LTR'),
                    icon: Icon(Icons.format_textdirection_l_to_r_rounded),
                  ),
                  ButtonSegment<bool>(
                    value: true,
                    label: Text('RTL'),
                    icon: Icon(Icons.format_textdirection_r_to_l_rounded),
                  ),
                ],
                selected: <bool>{isRtl},
                onSelectionChanged: executing || openingPdf
                    ? null
                    : (selection) => onDirectionChanged(selection.first),
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
                label: Text(executing ? 'Running…' : 'Run example'),
              ),
              OutlinedButton.icon(
                onPressed: !hasPreview || executing || openingPdf
                    ? null
                    : onOpenPdf,
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
              children: [identity, const SizedBox(height: 12), controls],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: identity),
              const SizedBox(width: 20),
              controls,
            ],
          );
        },
      ),
    );
  }
}

class _PdfPreviewPanel extends StatelessWidget {
  const _PdfPreviewPanel({
    required this.title,
    required this.pdfData,
    required this.executing,
    required this.error,
  });

  final String title;
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
            title: 'PDF Preview',
            trailing: pdfData == null
                ? _StatusPill(
                    label: executing ? 'Generating' : 'Not generated',
                    icon: executing
                        ? Icons.sync_rounded
                        : Icons.hourglass_empty_rounded,
                  )
                : const _StatusPill(
                    label: 'Generated',
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
                        : 'Press Run example to generate this document and display its PDF preview.',
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
        title: 'Dart usage code',
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
