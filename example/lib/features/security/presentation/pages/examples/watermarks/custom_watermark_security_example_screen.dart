import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Custom Watermark security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class CustomWatermarkSecurityExampleScreen extends StatelessWidget {
  const CustomWatermarkSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.customWatermark,
      usageCode: r'''Future<void> _generateCustomWatermarkPdf() async {
      const type = 'custom';
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();
        final page = document.pages.add();
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        _addSampleContent(
            graphics, pageSize, 'Watermark Demo - ${type.toUpperCase()}');

              GeniusPdfWatermark.text(
                    config: geniusPdfConfig,
                    GeniusTextWatermarkSettings(
                      text: 'GENIUS LINK',
                      fontSize: 50,
                      color: const Color(0xFF2196F3),
                      opacity: 0.15,
                      rotation: -30,
                      isBold: true,
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
