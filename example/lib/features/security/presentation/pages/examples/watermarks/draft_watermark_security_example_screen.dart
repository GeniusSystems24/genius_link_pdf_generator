import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Draft Watermark security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class DraftWatermarkSecurityExampleScreen extends StatelessWidget {
  const DraftWatermarkSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.draftWatermark,
      usageCode: r'''Future<void> _generateDraftWatermarkPdf() async {
      const type = 'draft';
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();
        final page = document.pages.add();
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        _addSampleContent(
            graphics, pageSize, 'Watermark Demo - ${type.toUpperCase()}');

              document.addWatermark(GeniusPdfWatermark.draft(
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
