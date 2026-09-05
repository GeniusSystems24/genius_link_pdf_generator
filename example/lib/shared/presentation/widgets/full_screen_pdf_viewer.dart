import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
import 'package:super_core/super_core.dart';

import '../../../app/localization/showcase_localizations.dart';

/// Opens generated PDF bytes in a dedicated full-screen preview route.
Future<void> showFullScreenPdfViewer(
  BuildContext context, {
  required Uint8List bytes,
  required String title,
}) {
  return Navigator.of(context).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => FullScreenPdfViewerPage(bytes: bytes, title: title),
    ),
  );
}

/// Full-screen PDF preview used by workbench and completed queue jobs.
class FullScreenPdfViewerPage extends StatelessWidget {
  const FullScreenPdfViewerPage({
    super.key,
    required this.bytes,
    required this.title,
  });

  final Uint8List bytes;
  final String title;

  @override
  Widget build(BuildContext context) {
    final l10n = ShowcaseL10n.of(context);
    final t = context.superTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: l10n.tr('Close'),
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.sizeOf(context).height - kToolbarHeight;
            return Container(
              color: t.inputBg,
              child: GeniusPdfPreviewWidget(
                pdfData: bytes,
                width: constraints.maxWidth.isFinite ? constraints.maxWidth : null,
                height: height,
                canChangeOrientation: true,
                canChangePageFormat: false,
              ),
            );
          },
        ),
      ),
    );
  }
}
