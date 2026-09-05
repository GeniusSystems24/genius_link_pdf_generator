import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Visual Signature security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class VisualSignatureSecurityExampleScreen extends StatelessWidget {
  const VisualSignatureSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.visualSignature,
      usageCode: r'''Future<void> _generateVisualSignaturePdf() async {
      const type = 'visual';
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();
        final page = document.pages.add();
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        _addSampleContent(
            graphics, pageSize, 'Signed Document - ${type.toUpperCase()}');

              final signature = GeniusPdfDigitalSignature(
                    config: geniusPdfConfig,
                    settings: GeniusDigitalSignatureSettings(
                      signerName: 'John Doe',
                      pageNumber: 0,
                    ),
                  );
                  signature.drawOnPage(page);

        await _capturePdfPreview(document, 'signed_$type');
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isGenerating = false);
      }
    }''',
    );
  }
}
