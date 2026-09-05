import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Multiple Signatures security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class MultipleSignaturesSecurityExampleScreen extends StatelessWidget {
  const MultipleSignaturesSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.multipleSignatures,
      usageCode: r'''Future<void> _generateMultipleSignaturesPdf() async {
      const type = 'multiple';
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();
        final page = document.pages.add();
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        _addSampleContent(
            graphics, pageSize, 'Signed Document - ${type.toUpperCase()}');

              final sig1 = GeniusPdfDigitalSignature(
                    config: geniusPdfConfig,
                    settings: GeniusDigitalSignatureSettings(
                      signerName: 'Reviewer 1',
                      reason: 'Technical Review',
                      bounds: Rect.fromLTWH(50, pageSize.height - 130, 180, 90),
                      pageNumber: 0,
                    ),
                  );
                  sig1.drawOnPage(
                      page, Rect.fromLTWH(50, pageSize.height - 130, 180, 90));

                  final sig2 = GeniusPdfDigitalSignature(
                    config: geniusPdfConfig,
                    settings: GeniusDigitalSignatureSettings(
                      signerName: 'Reviewer 2',
                      reason: 'Management Approval',
                      bounds: Rect.fromLTWH(
                          pageSize.width - 230, pageSize.height - 130, 180, 90),
                      pageNumber: 0,
                    ),
                  );
                  sig2.drawOnPage(
                      page,
                      Rect.fromLTWH(
                          pageSize.width - 230, pageSize.height - 130, 180, 90));

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
