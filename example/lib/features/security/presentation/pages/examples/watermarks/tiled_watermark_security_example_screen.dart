import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Tiled Watermark security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class TiledWatermarkSecurityExampleScreen extends StatelessWidget {
  const TiledWatermarkSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.tiledWatermark,
      usageCode: r'''Future<void> _generateTiledWatermarkPdf() async {
      const type = 'tiled';
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();
        final page = document.pages.add();
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        _addSampleContent(
            graphics, pageSize, 'Watermark Demo - ${type.toUpperCase()}');

              GeniusPdfWatermark.tiled(
                    config: geniusPdfConfig,
                    GeniusTiledWatermarkSettings(
                      text: 'SAMPLE',
                      fontSize: 20,
                      color: const Color(0xFF808080),
                      opacity: 0.1,
                      horizontalSpacing: 100,
                      verticalSpacing: 80,
                    ),
                  ).applyToDocument(document);

        await _capturePdfPreview(document, 'watermark_$type');
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isGenerating = false);
      }
    }''',
    );
  }
}
