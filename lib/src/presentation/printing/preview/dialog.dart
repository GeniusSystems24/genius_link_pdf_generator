part of '../print_preview.dart';

class GeniusPrintPreviewDialog {
  /// Shows a print preview dialog
  static Future<bool?> show({
    required BuildContext context,
    required Uint8List pdfBytes,
    required String documentName,
    required GeniusPdfConfig config,
    GeniusPrintSettings? initialSettings,
    bool showSettings = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog.fullscreen(
        child: GeniusPrintPreview(
          pdfBytes: pdfBytes,
          documentName: documentName,
          config: config,
          initialSettings: initialSettings,
          showSettings: showSettings,
          onCancel: () => Navigator.of(context).pop(false),
        ),
      ),
    );
  }
}

/// Enhanced print preview with share and save options
