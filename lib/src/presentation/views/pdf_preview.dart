import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

import '../controllers/genius_pdf_preview_controller.dart';

class GeniusPdfPreviewPage extends StatelessWidget {
  const GeniusPdfPreviewPage({
    super.key,
    required this.title,
    required this.pdfData,
    this.allowPrinting = true,
    this.allowSharing = true,
    this.allowDownload = true,
    this.onPrint,
    this.onShare,
    this.onDownload,
    this.controller,
  });

  final String title;
  final Uint8List pdfData;
  final bool allowPrinting;
  final bool allowSharing;
  final bool allowDownload;
  final VoidCallback? onPrint;
  final VoidCallback? onShare;
  final ValueChanged<String>? onDownload;
  final GeniusPdfPreviewController? controller;

  GeniusPdfPreviewController get _controller =>
      controller ?? const GeniusPdfPreviewController();

  @override
  Widget build(BuildContext context) {
    final hasPdf = pdfData.isNotEmpty;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          if (allowPrinting)
            IconButton(
              icon: const Icon(Icons.print),
              onPressed: hasPdf ? () => _printPdf(context) : null,
              tooltip: 'Print',
            ),
          if (allowSharing)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: hasPdf ? () => _sharePdf(context) : null,
              tooltip: 'Share',
            ),
          if (allowDownload)
            IconButton(
              icon: const Icon(Icons.download),
              onPressed: hasPdf ? () => _downloadPdf(context) : null,
              tooltip: 'Download',
            ),
        ],
      ),
      body: GeniusPdfPreviewWidget(
        pdfData: pdfData,
        fullscreenTitle: title,
      ),
    );
  }

  Future<void> _printPdf(BuildContext context) async {
    await _controller.print(pdfData, title);
    onPrint?.call();
  }

  Future<void> _sharePdf(BuildContext context) async {
    await _controller.share(pdfData, '$title.pdf');
    onShare?.call();
  }

  Future<void> _downloadPdf(BuildContext context) async {
    final path = await _controller.download(pdfData, title);
    onDownload?.call(path);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved to: $path'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(label: 'Open', onPressed: () {}),
      ),
    );
  }
}

class GeniusPdfPreviewWidget extends StatelessWidget {
  const GeniusPdfPreviewWidget({
    super.key,
    required this.pdfData,
    this.width,
    this.height,
    this.canChangeOrientation = true,
    this.canChangePageFormat = false,
    this.loadingWidget,
    this.errorBuilder,
    this.allowFullscreen = true,
    this.fullscreenTitle = 'PDF Preview',
    this.maxPageWidth,
  });

  final Uint8List pdfData;
  final double? width;
  final double? height;
  final bool canChangeOrientation;
  final bool canChangePageFormat;
  final Widget? loadingWidget;
  final Widget Function(BuildContext, Object?)? errorBuilder;

  /// Whether an expand button is shown over the preview.
  ///
  /// The button opens the same PDF in a dedicated full-window preview route.
  /// It defaults to `true` for backward-compatible opt-out behavior.
  final bool allowFullscreen;

  /// Title used by the full-window preview page.
  final String fullscreenTitle;

  /// Optional maximum rendered PDF page width.
  ///
  /// When omitted, [width] is used when supplied; otherwise the embedded
  /// preview keeps the historical 700 logical-pixel limit.
  final double? maxPageWidth;

  @override
  Widget build(BuildContext context) {
    if (pdfData.isEmpty) {
      final error = StateError('PDF data is empty.');
      return errorBuilder?.call(context, error) ??
          _buildErrorState(context, error);
    }

    final preview = PdfPreview(
      build: (_) => pdfData,
      canChangeOrientation: canChangeOrientation,
      canChangePageFormat: canChangePageFormat,
      canDebug: false,
      maxPageWidth: maxPageWidth ?? width ?? 700,
      padding: const EdgeInsets.all(8),
      actions: const [],
      loadingWidget: loadingWidget ?? _buildDefaultLoading(context),
      onError: errorBuilder ?? _buildErrorState,
      useActions: false,
      shouldRepaint: false,
      pdfPreviewPageDecoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
    );

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          Positioned.fill(child: preview),
          if (allowFullscreen)
            PositionedDirectional(
              top: 12,
              end: 12,
              child: Material(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                elevation: 2,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: IconButton(
                  tooltip: 'Full screen',
                  onPressed: () => _openFullscreen(context),
                  icon: const Icon(Icons.fullscreen_rounded),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _openFullscreen(BuildContext context) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => _GeniusPdfFullscreenPreviewPage(
          title: fullscreenTitle,
          pdfData: pdfData,
          canChangeOrientation: canChangeOrientation,
          canChangePageFormat: canChangePageFormat,
          loadingWidget: loadingWidget,
          errorBuilder: errorBuilder,
        ),
      ),
    );
  }

  Widget _buildDefaultLoading(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading PDF...',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      );

  Widget _buildErrorState(BuildContext context, Object? error) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Unable to load PDF preview.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (error != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      );
}

class _GeniusPdfFullscreenPreviewPage extends StatelessWidget {
  const _GeniusPdfFullscreenPreviewPage({
    required this.title,
    required this.pdfData,
    required this.canChangeOrientation,
    required this.canChangePageFormat,
    this.loadingWidget,
    this.errorBuilder,
  });

  final String title;
  final Uint8List pdfData;
  final bool canChangeOrientation;
  final bool canChangePageFormat;
  final Widget? loadingWidget;
  final Widget Function(BuildContext, Object?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(
            tooltip: 'Close full screen',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.fullscreen_exit_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth > 32
                ? constraints.maxWidth - 32
                : constraints.maxWidth;
            return GeniusPdfPreviewWidget(
              pdfData: pdfData,
              canChangeOrientation: canChangeOrientation,
              canChangePageFormat: canChangePageFormat,
              loadingWidget: loadingWidget,
              errorBuilder: errorBuilder,
              allowFullscreen: false,
              fullscreenTitle: title,
              maxPageWidth: availableWidth,
            );
          },
        ),
      ),
    );
  }
}

class GeniusPdfFilePreviewPage extends StatelessWidget {
  const GeniusPdfFilePreviewPage({
    super.key,
    required this.title,
    required this.filePath,
    this.allowPrinting = true,
    this.allowSharing = true,
    this.allowDownload = true,
    this.controller,
  });

  final String title;
  final String filePath;
  final bool allowPrinting;
  final bool allowSharing;
  final bool allowDownload;
  final GeniusPdfPreviewController? controller;

  GeniusPdfPreviewController get _controller =>
      controller ?? const GeniusPdfPreviewController();

  @override
  Widget build(BuildContext context) => FutureBuilder<Uint8List>(
        future: _controller.readFile(filePath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: const Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasError || !snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load PDF',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    if (snapshot.hasError) ...<Widget>[
                      const SizedBox(height: 8),
                      Text(
                        snapshot.error.toString(),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
          return GeniusPdfPreviewPage(
            title: title,
            pdfData: snapshot.data!,
            allowPrinting: allowPrinting,
            allowSharing: allowSharing,
            allowDownload: allowDownload,
            controller: _controller,
          );
        },
      );
}

class GeniusPdfPreviewDialog extends StatelessWidget {
  const GeniusPdfPreviewDialog({
    super.key,
    required this.title,
    required this.pdfData,
    this.width = 600,
    this.height = 800,
    this.showActions = true,
    this.controller,
  });

  final String title;
  final Uint8List pdfData;
  final double width;
  final double height;
  final bool showActions;
  final GeniusPdfPreviewController? controller;

  GeniusPdfPreviewController get _controller =>
      controller ?? const GeniusPdfPreviewController();

  @override
  Widget build(BuildContext context) {
    final hasPdf = pdfData.isNotEmpty;
    return Dialog(
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (showActions) ...<Widget>[
                    IconButton(
                      icon: const Icon(Icons.print),
                      onPressed: hasPdf
                          ? () => _controller.print(pdfData, title)
                          : null,
                      tooltip: 'Print',
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: hasPdf
                          ? () => _controller.share(pdfData, '$title.pdf')
                          : null,
                      tooltip: 'Share',
                    ),
                  ],
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Close',
                  ),
                ],
              ),
            ),
            Expanded(
              child: GeniusPdfPreviewWidget(
                pdfData: pdfData,
                fullscreenTitle: title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
