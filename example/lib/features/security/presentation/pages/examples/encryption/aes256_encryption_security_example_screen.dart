import 'package:flutter/material.dart';

import 'package:genius_pdf_example/features/security/presentation/internal/security_single_example_host.dart';

/// Dedicated screen for the AES-256 Encryption security example.
///
/// This page has one executable example only. `Dart usage code` displays the
/// same focused method that is executed by [SecuritySingleExampleHost].
class Aes256EncryptionSecurityExampleScreen extends StatelessWidget {
  const Aes256EncryptionSecurityExampleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SecuritySingleExampleHost(
      example: SecurityExampleKind.aes256Encryption,
      usageCode: r'''Future<void> _generateAes256EncryptedPdf() async {
      const type = 'aes256';
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
                    GeniusPdfSecuritySettings(
                      userPassword: 'secure123',
                      ownerPassword: 'admin123',
                      encryptionLevel: GeniusPdfEncryptionLevel.aes256,
                      permissions: GeniusPdfPermissions.readOnly(),
                      encryptMetadata: true,
                    ),
                  );
                  encryptionInfo =
                      'User Password: secure123\nOwner Password: admin123\nEncryption: AES-256 Bit';

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
