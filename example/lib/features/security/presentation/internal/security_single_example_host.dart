// Global manager/background migration for Security examples
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/security/models/documents/security_background_generation.dart';
import 'package:genius_pdf_example/shared/application/services/example_pdf_generation.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/feature_example_page.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';
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
  String? _previewFilePath;

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
      _isGenerating = true;
      _previewData = null;
      _previewFileName = null;
      _previewFilePath = null;
    });

    try {
      final fileName = 'security_${widget.example.name}';
      final success = await generateExamplePdf(
        builder: ExampleBackgroundPdfBuilder(
          config: geniusPdfConfig,
          backgroundGenerator: () => generateSecurityExampleInBackground(
            exampleName: widget.example.name,
            config: geniusPdfConfig,
          ),
        ),
        fileName: fileName,
        metadata: <String, dynamic>{
          'feature': 'security',
          'screen': 'SecuritySingleExampleHost',
          'example': widget.example.name,
          'category': _category,
          'workflow': 'security-preview',
          'showGenerationToast': true,
        },
      );

      if (!mounted) return;
      setState(() {
        _previewData = success.bytes;
        _previewFileName = '$fileName.pdf';
        _previewFilePath = success.filePath;
      });
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) setState(() => _isGenerating = false);
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
                ?  Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.picture_as_pdf_outlined, size: 48),
                          SizedBox(height: 12),
                          Text(pdfLocalization.noPdfGeneratedYet),
                          SizedBox(height: 6),
                          Text(
                            pdfLocalization.pressRunExampleGenerateDocumentShowDesc,
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
      final filePath = _previewFilePath;
      if (filePath != null && filePath.isNotEmpty) {
        await demoDocuments.open(filePath);
      } else {
        await demoDocuments.saveAndOpen(
          bytes: data,
          fileName: fileName,
        );
      }
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) {
        setState(() => _isOpening = false);
      }
    }
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
