import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:super_core/super_core.dart';

import '../../../app/dependencies/example_dependencies.dart';
import '../../../app/localization/showcase_localizations.dart';
import 'full_screen_pdf_viewer.dart';
import 'operation_state.dart';

// A fresh builder is required for every generation action because document
// builders are disposable and should not be reused after generation.
typedef ShowcaseBuilderFactory = GeniusPdfDocumentBuilder Function();

class PdfWorkbench extends StatefulWidget {
  const PdfWorkbench({
    super.key,
    required this.builderFactory,
    required this.fileName,
    this.runInBackground = false,
  });

  final ShowcaseBuilderFactory builderFactory;
  final String fileName;
  final bool runInBackground;

  @override
  State<PdfWorkbench> createState() => _PdfWorkbenchState();
}

class _PdfWorkbenchState extends State<PdfWorkbench> {
  Uint8List? _bytes;
  String? _path;
  String? _message;
  OperationTone _tone = OperationTone.neutral;
  bool _busy = false;

  Future<GeniusPdfSuccess?> _run(
    Future<GeniusPdfResult> Function(GeniusPdfDocumentBuilder builder) action,
    String progress,
  ) async {
    if (_busy) return null;
    setState(() {
      _busy = true;
      _message = progress;
      _tone = OperationTone.busy;
    });
    try {
      final result = await action(widget.builderFactory());
      return result.when(
        onSuccess: (success) {
          if (mounted) {
            setState(() {
              _bytes = success.bytes;
              _path = success.filePath;
              _message = '${ShowcaseL10n.of(context).tr('Generated successfully')} • '
                  '${success.bytes.lengthInBytes} bytes';
              _tone = OperationTone.success;
            });
          }
          return success;
        },
        onFailure: (failure) {
          if (mounted) {
            setState(() {
              _message = failure.message;
              _tone = OperationTone.error;
            });
          }
          return null;
        },
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _message = error.toString();
          _tone = OperationTone.error;
        });
      }
      return null;
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _generate() async {
    final l10n = ShowcaseL10n.of(context);
    await _run(
      (builder) => geniusPdfClient.generate(
        builder: builder,
        fileName: widget.fileName,
        runInBackground: widget.runInBackground,
      ),
      widget.runInBackground
          ? l10n.tr('Generating in background…')
          : l10n.tr('Generating PDF…'),
    );
  }

  Future<void> _save() async {
    final l10n = ShowcaseL10n.of(context);
    await _run(
      (builder) => geniusPdfClient.generateAndSave(
        builder: builder,
        fileName: widget.fileName,
        runInBackground: widget.runInBackground,
      ),
      l10n.tr('Generating and saving…'),
    );
  }

  Future<void> _open() async {
    final l10n = ShowcaseL10n.of(context);
    await _run(
      (builder) => geniusPdfClient.generateAndOpen(
        builder: builder,
        fileName: widget.fileName,
        runInBackground: widget.runInBackground,
      ),
      l10n.tr('Generating and opening…'),
    );
  }

  Future<void> _share() async {
    final l10n = ShowcaseL10n.of(context);
    await _run(
      (builder) => geniusPdfClient.generateAndShare(
        builder: builder,
        fileName: widget.fileName,
        runInBackground: widget.runInBackground,
      ),
      l10n.tr('Generating and sharing…'),
    );
  }

  Future<void> _print() async {
    final l10n = ShowcaseL10n.of(context);
    if (_bytes == null) await _generate();
    final bytes = _bytes;
    if (bytes == null) return;
    setState(() {
      _busy = true;
      _message = l10n.tr('Opening print workflow…');
      _tone = OperationTone.busy;
    });
    try {
      final ok = await geniusPdfClient.print(
        bytes: bytes,
        documentName: widget.fileName,
      );
      if (mounted) {
        setState(() {
          _message = ok
              ? l10n.tr('Print workflow completed.')
              : l10n.tr('Print workflow was cancelled or unavailable.');
          _tone = ok ? OperationTone.success : OperationTone.neutral;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _message = error.toString();
          _tone = OperationTone.error;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _fullScreen() async {
    final bytes = _bytes;
    if (bytes == null) return;
    await showFullScreenPdfViewer(
      context,
      bytes: bytes,
      title: widget.fileName,
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = context.superTheme;
    final l10n = ShowcaseL10n.of(context);
    final actions = Wrap(
      spacing: t.spacing.space2,
      runSpacing: t.spacing.space2,
      children: [
        SuperButton(
          label: l10n.tr('Generate'),
          icon: const Icon(Icons.bolt),
          onPressed: _busy ? null : _generate,
        ),
        SuperButton(
          label: l10n.tr('Save'),
          variant: SuperButtonVariant.secondary,
          icon: const Icon(Icons.save_outlined),
          onPressed: _busy ? null : _save,
        ),
        SuperButton(
          label: l10n.tr('Open'),
          variant: SuperButtonVariant.secondary,
          icon: const Icon(Icons.open_in_new),
          onPressed: _busy ? null : _open,
        ),
        SuperButton(
          label: l10n.tr('Share'),
          variant: SuperButtonVariant.secondary,
          icon: const Icon(Icons.share_outlined),
          onPressed: _busy ? null : _share,
        ),
        SuperButton(
          label: l10n.tr('Print'),
          variant: SuperButtonVariant.secondary,
          icon: const Icon(Icons.print_outlined),
          onPressed: _busy ? null : _print,
        ),
        if (_bytes != null)
          SuperButton(
            label: l10n.tr('Full screen'),
            variant: SuperButtonVariant.secondary,
            icon: const Icon(Icons.fullscreen_outlined),
            onPressed: _fullScreen,
          ),
      ],
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        actions,
        SizedBox(height: t.spacing.space3),
        OperationStatePanel(
          message: _message ?? l10n.tr('Generate a document to populate the preview.'),
          detail: _path == null ? null : '${l10n.tr('Save')}: $_path',
          tone: _tone,
        ),
        SizedBox(height: t.spacing.space3),
        LayoutBuilder(
          builder: (context, constraints) {
            final screenHeight = MediaQuery.sizeOf(context).height;
            final previewHeight = math.min(760.0, math.max(520.0, screenHeight * 0.68));
            return SizedBox(
              height: previewHeight,
              child: Container(
                decoration: BoxDecoration(
                  color: t.inputBg,
                  border: Border.all(color: t.border),
                  borderRadius: t.spacing.borderRadiusCard,
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: _bytes == null
                          ? Center(
                              child: Padding(
                                padding: t.spacing.cardPadding,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.picture_as_pdf_outlined, size: 48, color: t.fg3),
                                    SizedBox(height: t.spacing.space2),
                                    Text(l10n.tr('PDF preview'), style: context.superTextTheme.h1),
                                    SizedBox(height: t.spacing.space1),
                                    Text(
                                      l10n.tr('Generate this example to render it here.'),
                                      textAlign: TextAlign.center,
                                      style: context.superTextTheme.body.copyWith(color: t.fg2),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : GeniusPdfPreviewWidget(
                              pdfData: _bytes!,
                              height: previewHeight,
                              canChangeOrientation: true,
                              canChangePageFormat: false,
                            ),
                    ),
                    if (_bytes != null)
                      Positioned.directional(
                        textDirection: Directionality.of(context),
                        top: t.spacing.space2,
                        end: t.spacing.space2,
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(8),
                          child: IconButton(
                            tooltip: l10n.tr('Preview full screen'),
                            onPressed: _fullScreen,
                            icon: const Icon(Icons.fullscreen_outlined),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
