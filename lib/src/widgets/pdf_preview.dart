import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';

/// A page widget for previewing PDF documents with actions.
///
/// This widget displays a PDF preview with optional print, share,
/// and download buttons in the app bar.
///
/// ## Example
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => PdfPreviewPage(
///       title: 'Invoice #123',
///       pdfData: invoiceBytes,
///       allowPrinting: true,
///       allowSharing: true,
///     ),
///   ),
/// );
/// ```
class GeniusPdfPreviewPage extends StatelessWidget {

  /// Creates a new [GeniusPdfPreviewPage] instance.
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
  });
  /// The title displayed in the app bar.
  final String title;

  /// The PDF binary data to display.
  final Uint8List pdfData;

  /// Whether to show the print button.
  final bool allowPrinting;

  /// Whether to show the share button.
  final bool allowSharing;

  /// Whether to show the download button.
  final bool allowDownload;

  /// Callback when the document is printed.
  final VoidCallback? onPrint;

  /// Callback when the document is shared.
  final VoidCallback? onShare;

  /// Callback when the document is downloaded.
  final ValueChanged<String>? onDownload;

  @override
  Widget build(BuildContext context) {
    final hasPdf = pdfData.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
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
      body: GeniusPdfPreviewWidget(pdfData: pdfData),
    );
  }

  void _printPdf(BuildContext context) {
    if (pdfData.isEmpty) return;
    Printing.layoutPdf(
      onLayout: (_) => pdfData,
      name: title,
    );
    onPrint?.call();
  }

  Future<void> _sharePdf(BuildContext context) async {
    if (pdfData.isEmpty) return;
    await Printing.sharePdf(bytes: pdfData, filename: '$title.pdf');
    onShare?.call();
  }

  Future<void> _downloadPdf(BuildContext context) async {
    if (pdfData.isEmpty) return;
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$title.pdf');
    await file.writeAsBytes(pdfData);

    onDownload?.call(file.path);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saved to: ${file.path}'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Open',
            onPressed: () {
              // Platform-specific file opening would go here
            },
          ),
        ),
      );
    }
  }
}

/// A widget that displays a PDF preview without app bar or actions.
///
/// Use this widget to embed a PDF preview in your own custom UI.
///
/// ## Example
/// ```dart
/// Container(
///   decoration: BoxDecoration(
///     border: Border.all(color: Colors.grey),
///     borderRadius: BorderRadius.circular(8),
///   ),
///   child: PdfPreviewWidget(
///     pdfData: documentBytes,
///     width: 400,
///     height: 600,
///   ),
/// )
/// ```
class GeniusPdfPreviewWidget extends StatelessWidget {

  /// Creates a new [GeniusPdfPreviewWidget] instance.
  const GeniusPdfPreviewWidget({
    super.key,
    required this.pdfData,
    this.width,
    this.height,
    this.canChangeOrientation = true,
    this.canChangePageFormat = false,
    this.loadingWidget,
    this.errorBuilder,
  });
  /// The PDF binary data to display.
  final Uint8List pdfData;

  /// Optional maximum width for the preview.
  final double? width;

  /// Optional height for the preview container.
  final double? height;

  /// Whether the user can change page orientation.
  final bool canChangeOrientation;

  /// Whether the user can change page format.
  final bool canChangePageFormat;

  /// Custom loading widget.
  final Widget? loadingWidget;

  /// Custom error widget builder.
  final Widget Function(BuildContext, Object?)? errorBuilder;

  @override
  Widget build(BuildContext context) {
    if (pdfData.isEmpty) {
      final error = StateError('PDF data is empty.');
      return errorBuilder?.call(context, error) ??
          _buildErrorState(context, error);
    }

    return SizedBox(
      width: width,
      height: height,
      child: PdfPreview(
        build: (_) => pdfData,
        canChangeOrientation: canChangeOrientation,
        canChangePageFormat: canChangePageFormat,
        canDebug: false,
        maxPageWidth: width ?? 700,
        padding: const EdgeInsets.all(8),
        actions: const [],
        loadingWidget: loadingWidget ?? _buildDefaultLoading(context),
        onError: errorBuilder ?? _buildErrorState,
        useActions: false,
        shouldRepaint: false,
        pdfPreviewPageDecoration: const BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultLoading(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
  }

  Widget _buildErrorState(BuildContext context, Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            'Unable to load PDF preview.',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          if (error != null) ...[
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
}

/// A page that loads and displays a PDF from a file path.
///
/// This is useful when you have a PDF saved on disk and want to
/// preview it without loading the bytes yourself.
///
/// ## Example
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => PdfFilePreviewPage(
///       title: 'Invoice',
///       filePath: '/path/to/invoice.pdf',
///     ),
///   ),
/// );
/// ```
class GeniusPdfFilePreviewPage extends StatelessWidget {

  /// Creates a new [GeniusPdfFilePreviewPage] instance.
  const GeniusPdfFilePreviewPage({
    super.key,
    required this.title,
    required this.filePath,
    this.allowPrinting = true,
    this.allowSharing = true,
    this.allowDownload = true,
  });
  /// The title displayed in the app bar.
  final String title;

  /// Path to the PDF file on disk.
  final String filePath;

  /// Whether to show the print button.
  final bool allowPrinting;

  /// Whether to show the share button.
  final bool allowSharing;

  /// Whether to show the download button.
  final bool allowDownload;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: _readPdfFile(),
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
                children: [
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
                  if (snapshot.hasError) ...[
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
        );
      },
    );
  }

  Future<Uint8List> _readPdfFile() async {
    final file = File(filePath);
    return await file.readAsBytes();
  }
}

/// A dialog that displays a PDF preview.
///
/// Useful for showing PDFs in a modal dialog rather than navigating
/// to a new page.
///
/// ## Example
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => PdfPreviewDialog(
///     title: 'Invoice Preview',
///     pdfData: invoiceBytes,
///   ),
/// );
/// ```
class GeniusPdfPreviewDialog extends StatelessWidget {

  /// Creates a new [GeniusPdfPreviewDialog] instance.
  const GeniusPdfPreviewDialog({
    super.key,
    required this.title,
    required this.pdfData,
    this.width = 600,
    this.height = 800,
    this.showActions = true,
  });
  /// The title displayed in the dialog header.
  final String title;

  /// The PDF binary data to display.
  final Uint8List pdfData;

  /// Width of the dialog.
  final double width;

  /// Height of the dialog.
  final double height;

  /// Whether to show action buttons.
  final bool showActions;

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
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (showActions) ...[
                    IconButton(
                      icon: const Icon(Icons.print),
                      onPressed: hasPdf ? () => _print() : null,
                      tooltip: 'Print',
                    ),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: hasPdf ? () => _share() : null,
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
            // Preview
            Expanded(
              child: GeniusPdfPreviewWidget(pdfData: pdfData),
            ),
          ],
        ),
      ),
    );
  }

  void _print() {
    if (pdfData.isEmpty) return;
    Printing.layoutPdf(
      onLayout: (_) => pdfData,
      name: title,
    );
  }

  Future<void> _share() async {
    if (pdfData.isEmpty) return;
    await Printing.sharePdf(bytes: pdfData, filename: '$title.pdf');
  }
}
