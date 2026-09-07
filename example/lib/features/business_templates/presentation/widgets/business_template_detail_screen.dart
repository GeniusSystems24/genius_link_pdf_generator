import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/business_templates/models/documents/shared_build.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/code_viewer.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/shared/application/services/example_pdf_generation.dart';
/// Builds one of the business-template demo documents for the requested
/// direction.
typedef BusinessTemplateDemoBuilder = NewTemplatesDemoBuild Function({
  required bool isRtl,
});

/// Shared presentation used by every dedicated business-template example.
///
/// The document is intentionally not generated when this widget is created.
/// The user must press **Run example** before the builder is executed and the
/// PDF preview becomes available.
class BusinessTemplateDetailScreen extends StatefulWidget {
  const BusinessTemplateDetailScreen({
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
  final BusinessTemplateDemoBuilder buildTemplate;
  final String usageCode;
  final bool initialRtl;

  @override
  State<BusinessTemplateDetailScreen> createState() =>
      _BusinessTemplateDetailScreenState();
}

class _BusinessTemplateDetailScreenState
    extends State<BusinessTemplateDetailScreen> {
  late bool _isRtl;

  Uint8List? _previewData;
  String? _previewFilePath;
  Object? _executionError;
  bool _executing = false;
  bool _openingPdf = false;

  @override
  void initState() {
    super.initState();
    _isRtl = widget.initialRtl;
    // Deliberately do not build or generate a document here.
  }

  void _setDirection(bool isRtl) {
    if (_isRtl == isRtl) return;
    setState(() {
      _isRtl = isRtl;
      // The previous preview belongs to a different execution/configuration.
      // Invalidate it and wait for an explicit Run example action.
      _previewData = null;
      _previewFilePath = null;
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
      final demo = widget.buildTemplate(isRtl: _isRtl);
      final success = await generateExamplePdf(
        builder: demo.builder,
        fileName: demo.fileName,
        metadata: <String, dynamic>{
          'feature': 'business_templates',
          'screen': widget.title,
          'category': widget.category,
          'workflow': 'business-template-preview',
          'showGenerationToast': true,
        },
      );

      if (!mounted) return;
      setState(() {
        _previewData = success.bytes;
        _previewFilePath = success.filePath;
        _executionError = null;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _previewData = null;
        _previewFilePath = null;
        _executionError = error;
      });
      _showMessage('Unable to generate PDF preview: $error', error: true);
    } finally {
      if (mounted) {
        setState(() => _executing = false);
      }
    }
  }

  Future<void> _openPdf() async {
    // Keep the workflow explicit: execute the example first, then open it.
    if (_previewData == null || _openingPdf || _executing) return;

    setState(() => _openingPdf = true);

    try {
      final filePath = _previewFilePath;
      if (filePath != null && filePath.isNotEmpty) {
        await demoDocuments.open(filePath);
      } else {
        await demoDocuments.saveAndOpen(
          bytes: _previewData!,
          fileName: '${widget.title}.pdf',
        );
      }
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
            _TemplateDetailHeader(
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
                      padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 24),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 13,
                            child: _PreviewPanel(
                              pdfData: _previewData,
                              executing: _executing,
                              error: _executionError,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 10,
                            child: _UsageCodePanel(code: widget.usageCode),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(horizontal, 8, horizontal, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: constraints.maxWidth < 600 ? 560 : 680,
                          child: _PreviewPanel(
                            pdfData: _previewData,
                            executing: _executing,
                            error: _executionError,
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: constraints.maxWidth < 600 ? 520 : 620,
                          child: _UsageCodePanel(code: widget.usageCode),
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

class _TemplateDetailHeader extends StatelessWidget {
  const _TemplateDetailHeader({
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
        border: Border(
          bottom: BorderSide(color: colors.outlineVariant),
        ),
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
                      maxLines: compact ? 2 : 1,
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
                showSelectedIcon: false,
                onSelectionChanged: executing || openingPdf
                    ? null
                    : (selection) {
                        if (selection.isNotEmpty) {
                          onDirectionChanged(selection.first);
                        }
                      },
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
                      : (hasPreview ? 'Run again' : 'Run example'),
                ),
              ),
              OutlinedButton.icon(
                onPressed: hasPreview && !executing && !openingPdf
                    ? onOpenPdf
                    : null,
                icon: openingPdf
                    ? const SizedBox(
                        width: 16,
                        height: 16,
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
              children: [
                identity,
                const SizedBox(height: 12),
                actions,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: identity),
              const SizedBox(width: 20),
              actions,
            ],
          );
        },
      ),
    );
  }
}

class _PreviewPanel extends StatelessWidget {
  const _PreviewPanel({
    required this.pdfData,
    required this.executing,
    required this.error,
  });

  final Uint8List? pdfData;
  final bool executing;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return _SectionSurface(
      title: pdfLocalization.pdfPreview,
      subtitle: 'The document is generated only after you run the example.',
      icon: Icons.picture_as_pdf_outlined,
      child: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (executing) {
      return  _PreviewWaitingState(
        icon: Icons.hourglass_top_rounded,
        title: pdfLocalization.generatingPreview,
        message: pdfLocalization.theSelectedExampleIsBeingExecuted,
        loading: true,
      );
    }

    if (error != null) {
      return _PreviewWaitingState(
        icon: Icons.error_outline_rounded,
        title: pdfLocalization.generationFailed,
        message: error.toString(),
        error: true,
      );
    }

    final data = pdfData;
    if (data == null) {
      return  _PreviewWaitingState(
        icon: Icons.play_circle_outline_rounded,
        title: pdfLocalization.readyToRun,
        message: pdfLocalization.pressRunExampleGenerateDocumentDesc,
      );
    }

    return GeniusPdfPreviewWidget(
      pdfData: data,
      canChangeOrientation: false,
      canChangePageFormat: false,
      fullscreenTitle: 'PDF Preview',
    );
  }
}

class _PreviewWaitingState extends StatelessWidget {
  const _PreviewWaitingState({
    required this.icon,
    required this.title,
    required this.message,
    this.loading = false,
    this.error = false,
  });

  final IconData icon;
  final String title;
  final String message;
  final bool loading;
  final bool error;

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
                const SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(strokeWidth: 3),
                )
              else
                Icon(icon, size: 46, color: foreground),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: error ? colors.error : null,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
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

class _UsageCodePanel extends StatelessWidget {
  const _UsageCodePanel({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return _SectionSurface(
      title: pdfLocalization.dartUsageCode,
      subtitle: 'Copy or adapt the exact demo-builder code used to create this PDF template.',
      icon: Icons.code_rounded,
      padding: EdgeInsets.zero,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return CodeViewer(
            title: pdfLocalization.dartUsageCode,
            code: code,
            height: constraints.maxHeight,
          );
        },
      ),
    );
  }
}

class _SectionSurface extends StatelessWidget {
  const _SectionSurface({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
    this.padding = const EdgeInsets.all(12),
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: Row(
              children: [
                Icon(icon, size: 19, color: colors.primary),
                const SizedBox(width: 9),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: colors.outlineVariant),
          Expanded(
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
