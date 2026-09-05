import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the Read Only security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class ReadOnlyProtectionSecurityExampleScreen extends StatelessWidget {
  const ReadOnlyProtectionSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.readOnlyProtection,
      usageCode: r'''Future<void> _generateReadOnlyPdf() async {
      const type = 'readonly';
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();
        final page = document.pages.add();
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        _addSampleContent(
            graphics, pageSize, 'Encrypted Document - ${type.toUpperCase()}');

        final infoFont = geniusPdfConfig.baseFont;
        String encryptionInfo = '';

              GeniusPdfSecurityService.applySecurity(
                    document,
                    GeniusPdfSecuritySettings.readOnly(ownerPassword: 'admin123'),
                  );
                  encryptionInfo =
                      'Owner Password: admin123\nPermissions: Read & Print Only';

        graphics.drawRectangle(
          brush: PdfSolidBrush(PdfColor(255, 255, 200)),
          pen: PdfPen(PdfColor(200, 200, 0)),
          bounds: Rect.fromLTWH(50, 200, pageSize.width - 100, 100),
        );
        graphics.drawString(
          'Encryption Details:\n$encryptionInfo',
          infoFont,
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(60, 210, pageSize.width - 120, 80),
          format: PdfStringFormat(textDirection: geniusPdfConfig.pdfTextDirection),
        );

        await _capturePdfPreview(document, 'encrypted_$type');
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isGenerating = false);
      }
    }''',
    );
  }
}
