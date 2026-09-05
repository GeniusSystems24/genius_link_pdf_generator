import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Copy Watermark security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class CopyWatermarkSecurityExampleScreen extends StatelessWidget {
  const CopyWatermarkSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.copyWatermark,
      usageCode: r'''Future<void> _generateCopyWatermarkPdf() async {
      const type = 'copy';
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();
        final page = document.pages.add();
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        _addSampleContent(
            graphics, pageSize, 'Watermark Demo - ${type.toUpperCase()}');

              document.addWatermark(GeniusPdfWatermark.copy(
                    config: geniusPdfConfig,
                  ));

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
