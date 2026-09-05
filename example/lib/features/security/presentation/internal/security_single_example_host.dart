import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/feature_example_page.dart';

enum SecurityExampleKind {
  confidentialWatermark,
  draftWatermark,
  copyWatermark,
  tiledWatermark,
  customWatermark,
  passwordProtection,
  readOnlyProtection,
  printOnlyProtection,
  fullProtection,
  aes256Encryption,
  visualSignature,
  detailedSignature,
  multipleSignatures,
  customPositionSignature,
  comprehensiveSecurity,
}

/// Presentation host for exactly one focused Security example.
///
/// Category rows are navigation groups, not aggregate example pages.
class SecuritySingleExampleHost extends StatefulWidget {
  const SecuritySingleExampleHost({
    super.key,
    required this.example,
    required this.usageCode,
  });

  final SecurityExampleKind example;

  /// Exact source of the focused method executed by this screen.
  final String usageCode;

  @override
  State<SecuritySingleExampleHost> createState() =>
      _SecuritySingleExampleHostState();
}

class _SecuritySingleExampleHostState
    extends State<SecuritySingleExampleHost> {
  bool _isGenerating = false;
  bool _isOpening = false;
  Uint8List? _previewData;
  String? _previewFileName;

  String get _title => switch (widget.example) {
      SecurityExampleKind.confidentialWatermark => 'Confidential Watermark',
      SecurityExampleKind.draftWatermark => 'Draft Watermark',
      SecurityExampleKind.copyWatermark => 'Copy Watermark',
      SecurityExampleKind.tiledWatermark => 'Tiled Watermark',
      SecurityExampleKind.customWatermark => 'Custom Watermark',
      SecurityExampleKind.passwordProtection => 'Password Protected',
      SecurityExampleKind.readOnlyProtection => 'Read Only',
      SecurityExampleKind.printOnlyProtection => 'Print Only',
      SecurityExampleKind.fullProtection => 'Full Protection',
      SecurityExampleKind.aes256Encryption => 'AES-256 Encryption',
      SecurityExampleKind.visualSignature => 'Visual Signature',
      SecurityExampleKind.detailedSignature => 'Detailed Signature',
      SecurityExampleKind.multipleSignatures => 'Multiple Signatures',
      SecurityExampleKind.customPositionSignature => 'Custom Position',
      SecurityExampleKind.comprehensiveSecurity => 'Comprehensive Security Demo',
    };

  String get _description => switch (widget.example) {
      SecurityExampleKind.confidentialWatermark => 'Apply a red diagonal "CONFIDENTIAL" watermark to a PDF document.',
      SecurityExampleKind.draftWatermark => 'Apply a subtle diagonal "DRAFT" watermark to a PDF document.',
      SecurityExampleKind.copyWatermark => 'Apply a diagonal "COPY" watermark to identify duplicated documents.',
      SecurityExampleKind.tiledWatermark => 'Repeat a watermark pattern across the complete page surface.',
      SecurityExampleKind.customWatermark => 'Configure custom watermark text, color, opacity, rotation, and weight.',
      SecurityExampleKind.passwordProtection => 'Protect the document with a user password using the package security API.',
      SecurityExampleKind.readOnlyProtection => 'Apply read-only security with an owner password and restricted permissions.',
      SecurityExampleKind.printOnlyProtection => 'Allow printing while preventing copying and other protected operations.',
      SecurityExampleKind.fullProtection => 'Apply maximum document protection with separate user and owner passwords.',
      SecurityExampleKind.aes256Encryption => 'Generate a PDF protected with AES-256 encryption and explicit permissions.',
      SecurityExampleKind.visualSignature => 'Draw a visual signature box containing the signer name and date.',
      SecurityExampleKind.detailedSignature => 'Render signer identity, reason, location, contact information, and date.',
      SecurityExampleKind.multipleSignatures => 'Place multiple independent signer blocks on the same PDF page.',
      SecurityExampleKind.customPositionSignature => 'Place and style a signature at explicitly controlled document coordinates.',
      SecurityExampleKind.comprehensiveSecurity => 'Combine watermarks, a visual signature, password protection, and print-only permissions in one document.',
    };

  String get _category => switch (widget.example) {
      SecurityExampleKind.confidentialWatermark => 'Watermarks',
      SecurityExampleKind.draftWatermark => 'Watermarks',
      SecurityExampleKind.copyWatermark => 'Watermarks',
      SecurityExampleKind.tiledWatermark => 'Watermarks',
      SecurityExampleKind.customWatermark => 'Watermarks',
      SecurityExampleKind.passwordProtection => 'Encryption & Permissions',
      SecurityExampleKind.readOnlyProtection => 'Encryption & Permissions',
      SecurityExampleKind.printOnlyProtection => 'Encryption & Permissions',
      SecurityExampleKind.fullProtection => 'Encryption & Permissions',
      SecurityExampleKind.aes256Encryption => 'Encryption & Permissions',
      SecurityExampleKind.visualSignature => 'Digital Signatures',
      SecurityExampleKind.detailedSignature => 'Digital Signatures',
      SecurityExampleKind.multipleSignatures => 'Digital Signatures',
      SecurityExampleKind.customPositionSignature => 'Digital Signatures',
      SecurityExampleKind.comprehensiveSecurity => 'Combined Security',
    };

  IconData get _icon => switch (widget.example) {
      SecurityExampleKind.confidentialWatermark => Icons.security_outlined,
      SecurityExampleKind.draftWatermark => Icons.edit_note_outlined,
      SecurityExampleKind.copyWatermark => Icons.content_copy_outlined,
      SecurityExampleKind.tiledWatermark => Icons.grid_view_outlined,
      SecurityExampleKind.customWatermark => Icons.tune_outlined,
      SecurityExampleKind.passwordProtection => Icons.password_outlined,
      SecurityExampleKind.readOnlyProtection => Icons.visibility_outlined,
      SecurityExampleKind.printOnlyProtection => Icons.print_outlined,
      SecurityExampleKind.fullProtection => Icons.shield_outlined,
      SecurityExampleKind.aes256Encryption => Icons.enhanced_encryption_outlined,
      SecurityExampleKind.visualSignature => Icons.draw_outlined,
      SecurityExampleKind.detailedSignature => Icons.description_outlined,
      SecurityExampleKind.multipleSignatures => Icons.groups_outlined,
      SecurityExampleKind.customPositionSignature => Icons.place_outlined,
      SecurityExampleKind.comprehensiveSecurity => Icons.verified_user_outlined,
    };

  Future<void> _runExample() async {
    if (_isGenerating || _isOpening) return;

    setState(() {
      _previewData = null;
      _previewFileName = null;
    });

    switch (widget.example) {
      case SecurityExampleKind.confidentialWatermark:
        await _generateConfidentialWatermarkPdf();
        break;
      case SecurityExampleKind.draftWatermark:
        await _generateDraftWatermarkPdf();
        break;
      case SecurityExampleKind.copyWatermark:
        await _generateCopyWatermarkPdf();
        break;
      case SecurityExampleKind.tiledWatermark:
        await _generateTiledWatermarkPdf();
        break;
      case SecurityExampleKind.customWatermark:
        await _generateCustomWatermarkPdf();
        break;
      case SecurityExampleKind.passwordProtection:
        await _generatePasswordProtectedPdf();
        break;
      case SecurityExampleKind.readOnlyProtection:
        await _generateReadOnlyPdf();
        break;
      case SecurityExampleKind.printOnlyProtection:
        await _generatePrintOnlyPdf();
        break;
      case SecurityExampleKind.fullProtection:
        await _generateFullProtectionPdf();
        break;
      case SecurityExampleKind.aes256Encryption:
        await _generateAes256EncryptedPdf();
        break;
      case SecurityExampleKind.visualSignature:
        await _generateVisualSignaturePdf();
        break;
      case SecurityExampleKind.detailedSignature:
        await _generateDetailedSignaturePdf();
        break;
      case SecurityExampleKind.multipleSignatures:
        await _generateMultipleSignaturesPdf();
        break;
      case SecurityExampleKind.customPositionSignature:
        await _generateCustomPositionSignaturePdf();
        break;
      case SecurityExampleKind.comprehensiveSecurity:
        await _generateComprehensiveDemo();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FeatureExamplePage(
      title: _title,
      description: _description,
      icon: _icon,
      contentTitle: 'PDF preview',
      contentDescription:
          'Generate this focused $_category example, inspect the exact PDF '
          'output inline, then open the same generated bytes when needed.',
      content: _buildPreviewContent(context),
      code: widget.usageCode,
      statusMessage: _isGenerating
          ? 'Generating $_title…'
          : _previewData != null
              ? 'PDF generated. Preview it below or open the generated file.'
              : 'Ready. Press Run example to generate this document.',
      statusTone: _isGenerating
          ? FeatureExampleTone.info
          : _previewData != null
              ? FeatureExampleTone.success
              : FeatureExampleTone.neutral,
      codeHeight: 600,
    );
  }

  Future<void> _generateConfidentialWatermarkPdf() async {
      const type = 'confidential';
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();
        final page = document.pages.add();
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        _addSampleContent(
            graphics, pageSize, 'Watermark Demo - ${type.toUpperCase()}');

              document.addWatermark(GeniusPdfWatermark.confidential(
                    config: geniusPdfConfig,
                  ));

        await _capturePdfPreview(document, 'watermark_$type');
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isGenerating = false);
      }
    }

  Future<void> _generateDraftWatermarkPdf() async {
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
    }

  Future<void> _generateCopyWatermarkPdf() async {
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
    }

  Future<void> _generateTiledWatermarkPdf() async {
      const type = 'tiled';
      setState(() => _isGenerating = true);

      try {
        final document = PdfDocument();
        final page = document.pages.add();
        final graphics = page.graphics;
        final pageSize = page.getClientSize();

        _addSampleContent(
            graphics, pageSize, 'Watermark Demo - ${type.toUpperCase()}');

              GeniusPdfWatermark.tiled(
                    config: geniusPdfConfig,
                    GeniusTiledWatermarkSettings(
                      text: 'SAMPLE',
                      fontSize: 20,
                      color: const Color(0xFF808080),
                      opacity: 0.1,
                      horizontalSpacing: 100,
                      verticalSpacing: 80,
                    ),
                  ).applyToDocument(document);

        await _capturePdfPreview(document, 'watermark_$type');
      } catch (e) {
        _showError(e.toString());
      } finally {
        setState(() => _isGenerating = false);
      }
    }

  Future<void> _generateCustomWatermarkPdf() async {
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
    }

  Future<void> _generatePasswordProtectedPdf() async {
      const type = 'password';
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

              document.protectWithPassword(password: 'demo123');
                  encryptionInfo =
                      'Password: demo123\nEncryption: AES-256\nPermissions: All';

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
    }

  Future<void> _generateReadOnlyPdf() async {
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
    }

  Future<void> _generatePrintOnlyPdf() async {
      const type = 'printonly';
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
                    GeniusPdfSecuritySettings.printOnly(ownerPassword: 'admin123'),
                  );
                  encryptionInfo = 'Owner Password: admin123\nPermissions: Print Only';

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
    }

  Future<void> _generateFullProtectionPdf() async {
      const type = 'full';
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
                    GeniusPdfSecuritySettings.fullProtection(
                      userPassword: 'user123',
                      ownerPassword: 'admin123',
                    ),
                  );
                  encryptionInfo =
                      'User Password: user123\nOwner Password: admin123\nPermissions: None';

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
    }

  Future<void> _generateAes256EncryptedPdf() async {
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
    }

  Future<void> _generateVisualSignaturePdf() async {
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
    }

  Future<void> _generateDetailedSignaturePdf() async {
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
    }

  Future<void> _generateMultipleSignaturesPdf() async {
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
    }

  Future<void> _generateCustomPositionSignaturePdf() async {
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
    }

  Future<void> _generateComprehensiveDemo() async {
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
    }

  void _addSampleContent(PdfGraphics graphics, Size pageSize, String title) {
      graphics.drawString(
        title,
        geniusPdfConfig.baseFont,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(50, 50, pageSize.width - 100, 40),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: geniusPdfConfig.pdfTextDirection,
        ),
      );

      const sampleText = '''
  This is a sample document demonstrating the security features of the Genius Link PDF Generator library.

  The library provides comprehensive security features including:
  • Text, diagonal, and tiled watermarks
  • Password protection with AES-256 encryption
  • Granular permission controls
  • Digital signatures with customizable appearance

  This document was generated to showcase these features in action.
  ''';

      graphics.drawString(
        sampleText,
        geniusPdfConfig.boldFont,
        brush: PdfSolidBrush(PdfColor(50, 50, 50)),
        bounds: Rect.fromLTWH(50, 120, pageSize.width - 100, 200),
        format: PdfStringFormat(textDirection: geniusPdfConfig.pdfTextDirection),
      );

      _drawSampleTable(
          graphics, Rect.fromLTWH(50, 350, pageSize.width - 100, 150));
    }

  void _drawSampleTable(PdfGraphics graphics, Rect bounds) {
      const columns = ['Feature', 'Status', 'Description'];
      final rows = [
        ['Watermarks', 'Active', 'Text & pattern watermarks'],
        ['Encryption', 'AES-256', 'High-grade encryption'],
        ['Permissions', 'Configured', 'Custom access control'],
        ['Signatures', 'Supported', 'Digital signing'],
      ];

      final cellWidth = bounds.width / 3;
      const cellHeight = 25.0;

      graphics.drawRectangle(
        brush: PdfSolidBrush(PdfColor(41, 128, 185)),
        bounds: Rect.fromLTWH(bounds.left, bounds.top, bounds.width, cellHeight),
      );

      for (int i = 0; i < columns.length; i++) {
        graphics.drawString(
          columns[i],
          geniusPdfConfig.boldFont,
          brush: PdfSolidBrush(PdfColor(255, 255, 255)),
          bounds: Rect.fromLTWH(bounds.left + i * cellWidth + 5, bounds.top + 5,
              cellWidth - 10, cellHeight - 10),
          format: PdfStringFormat(textDirection: geniusPdfConfig.pdfTextDirection),
        );
      }

      for (int r = 0; r < rows.length; r++) {
        final y = bounds.top + cellHeight * (r + 1);
        final bgColor =
            r % 2 == 0 ? PdfColor(248, 249, 250) : PdfColor(255, 255, 255);

        graphics.drawRectangle(
          brush: PdfSolidBrush(bgColor),
          pen: PdfPen(PdfColor(220, 220, 220)),
          bounds: Rect.fromLTWH(bounds.left, y, bounds.width, cellHeight),
        );

        for (int c = 0; c < rows[r].length; c++) {
          graphics.drawString(
            rows[r][c],
            geniusPdfConfig.baseFont,
            brush: PdfSolidBrush(PdfColor(50, 50, 50)),
            bounds: Rect.fromLTWH(bounds.left + c * cellWidth + 5, y + 5,
                cellWidth - 10, cellHeight - 10),
            format: PdfStringFormat(textDirection: geniusPdfConfig.pdfTextDirection),
          );
        }
      }
    }

  Widget _buildPreviewContent(BuildContext context) {
    final data = _previewData;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            FilledButton.icon(
              onPressed: (_isGenerating || _isOpening) ? null : _runExample,
              icon: _isGenerating
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow_rounded),
              label: Text(
                _isGenerating
                    ? 'Generating…'
                    : data == null
                        ? 'Run example'
                        : 'Run again',
              ),
            ),
            OutlinedButton.icon(
              onPressed: data == null || _isGenerating || _isOpening
                  ? null
                  : _openGeneratedPdf,
              icon: const Icon(Icons.open_in_new_rounded),
              label: Text(_isOpening ? 'Opening…' : 'Open PDF'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Card(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            height: 680,
            child: data == null
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.picture_as_pdf_outlined, size: 48),
                          SizedBox(height: 12),
                          Text('No PDF generated yet'),
                          SizedBox(height: 6),
                          Text(
                            'Press Run example to generate the document and '
                            'show its PDF preview here.',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : GeniusPdfPreviewWidget(
                    pdfData: data,
                    canChangeOrientation: false,
                    canChangePageFormat: false,
                    allowFullscreen: true,
                    fullscreenTitle: _title,
                    maxPageWidth: 900,
                  ),
          ),
        ),
      ],
    );
  }

  Future<void> _openGeneratedPdf() async {
    final data = _previewData;
    final fileName = _previewFileName;
    if (data == null || fileName == null || _isGenerating || _isOpening) {
      return;
    }

    setState(() => _isOpening = true);
    try {
      await demoDocuments.saveAndOpen(
        bytes: data,
        fileName: fileName,
      );
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) {
        setState(() => _isOpening = false);
      }
    }
  }

  Future<void> _capturePdfPreview(
    PdfDocument document,
    String fileName,
  ) async {
    late final Uint8List bytes;
    try {
      bytes = Uint8List.fromList(await document.save());
    } finally {
      document.dispose();
    }

    if (!mounted) return;
    setState(() {
      _previewData = bytes;
      _previewFileName = fileName;
    });
  }

  void _showError(String message) {
    if (!mounted) return;
    final colors = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        backgroundColor: colors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
