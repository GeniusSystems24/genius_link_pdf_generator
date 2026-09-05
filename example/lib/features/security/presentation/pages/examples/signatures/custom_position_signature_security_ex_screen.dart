import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Custom Position security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class CustomPositionSignatureSecurityExampleScreen extends StatelessWidget {
  const CustomPositionSignatureSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.customPositionSignature,
      usageCode: r'''Future<void> _generateCustomPositionSignaturePdf() async {
      const type = 'custom';
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
                      signerName: 'CEO Signature',
                      reason: 'Final Approval',
                      location: 'Head Office',
                      appearance: GeniusSignatureAppearance(
                        showName: true,
                        showDate: true,
                        showReason: true,
                        showLocation: true,
                        backgroundColor: const Color(0xFFE8F5E9),
                        borderColor: const Color(0xFF4CAF50),
                        textColor: const Color(0xFF1B5E20),
                      ),
                      bounds: Rect.fromLTWH(pageSize.width / 2 - 100, 300, 200, 100),
                      pageNumber: 0,
                    ),
                  );
                  signature.drawOnPage(
                      page, Rect.fromLTWH(pageSize.width / 2 - 100, 300, 200, 100));

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
