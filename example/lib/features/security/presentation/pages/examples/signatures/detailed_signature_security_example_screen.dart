import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Detailed Signature security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class DetailedSignatureSecurityExampleScreen extends StatelessWidget {
  const DetailedSignatureSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.detailedSignature,
      usageCode: r'''Future<void> _generateDetailedSignaturePdf() async {
      const type = 'detailed';
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
                      signerName: 'Jane Smith',
                      reason: 'Document Review and Approval',
                      location: 'Riyadh, Saudi Arabia',
                      contactInfo: 'jane.smith@company.com',
                      appearance: const GeniusSignatureAppearance(
                        showName: true,
                        showDate: true,
                        showReason: true,
                        showLocation: true,
                      ),
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
