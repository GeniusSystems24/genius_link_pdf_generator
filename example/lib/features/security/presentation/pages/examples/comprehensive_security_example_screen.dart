import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Comprehensive Security Demo security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class ComprehensiveSecurityExampleScreen extends StatelessWidget {
  const ComprehensiveSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.comprehensiveSecurity,
      usageCode: r'''Future<void> _generateComprehensiveDemo() async {
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();

        final page1 = document.pages.add();
        _addSampleContent(
            page1.graphics, page1.getClientSize(), 'Page 1: Watermark Demo');

        final page2 = document.pages.add();
        _addSampleContent(
            page2.graphics, page2.getClientSize(), 'Page 2: Tiled Watermark');

        final page3 = document.pages.add();

        GeniusPdfWatermark.text(
          config: geniusPdfConfig,
          GeniusTextWatermarkSettings.confidential(opacity: 0.15),
        ).applyToPage(page1);

        GeniusPdfWatermark.tiled(
          config: geniusPdfConfig,
          GeniusTiledWatermarkSettings(
            text: 'SAMPLE',
            fontSize: 18,
            opacity: 0.08,
          ),
        ).applyToPage(page2);

        final signature = GeniusPdfDigitalSignature(
          config: geniusPdfConfig,
          settings: GeniusDigitalSignatureSettings(
            signerName: 'Document Admin',
            reason: 'Comprehensive Demo',
            location: 'Demo Location',
            appearance: const GeniusSignatureAppearance(
              showName: true,
              showDate: true,
              showReason: true,
              showLocation: true,
            ),
            pageNumber: 2,
          ),
        );
        signature.drawOnPage(page3);

        document.protectWithPassword(
          password: 'demo123',
          permissions: GeniusPdfPermissions.printOnly(),
        );

        await _capturePdfPreview(document, 'comprehensive_security_demo');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  const Text('Comprehensive demo generated! Password: demo123'),
              backgroundColor: Theme.of(context).colorScheme.primary,
              behavior: SnackBarBehavior.floating,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isGenerating = false);
      }
    }''',
    );
  }
}
