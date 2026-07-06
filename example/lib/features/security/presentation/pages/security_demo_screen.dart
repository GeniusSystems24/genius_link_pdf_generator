import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/theme/app_theme.dart';

/// Security Demo Screen with professional dashboard design.
class SecurityDemoScreen extends StatefulWidget {
  final int initialTab;

  const SecurityDemoScreen({super.key, this.initialTab = 0});

  @override
  State<SecurityDemoScreen> createState() => _SecurityDemoScreenState();
}

class _SecurityDemoScreenState extends State<SecurityDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;

  final List<_SecurityTab> _tabs = [
    _SecurityTab(
      id: 'watermarks',
      title: 'Watermarks',
      icon: Icons.water_drop_rounded,
      gradient: AppColors.infoGradient,
    ),
    _SecurityTab(
      id: 'encryption',
      title: 'Encryption',
      icon: Icons.lock_rounded,
      gradient: AppColors.errorGradient,
    ),
    _SecurityTab(
      id: 'signatures',
      title: 'Signatures',
      icon: Icons.draw_rounded,
      gradient: AppColors.successGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;

        return Container(
          color: isDark ? AppColors.darkBg : AppColors.lightBg,
          child: Column(
            children: [
              _buildTabBar(isDark),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildWatermarksTab(isDark),
                    _buildEncryptionTab(isDark),
                    _buildSignaturesTab(isDark),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        padding: const EdgeInsets.all(6),
        indicator: BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.primaryGradient,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: _tabs.map((tab) {
          return Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tab.icon, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    tab.title,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWatermarksTab(bool isDark) {
    return _SecurityTabContent(
      isDark: isDark,
      title: 'Watermarks',
      description:
          'Add text, diagonal, tiled, or image watermarks to protect documents.',
      icon: Icons.water_drop_rounded,
      gradient: AppColors.infoGradient,
      isGenerating: _isGenerating,
      options: [
        _SecurityOption(
          title: 'Confidential Watermark',
          subtitle: 'Red diagonal "CONFIDENTIAL" text',
          icon: Icons.security_rounded,
          gradient: AppColors.errorGradient,
          onGenerate: () => _generateWatermarkPdf('confidential'),
        ),
        _SecurityOption(
          title: 'Draft Watermark',
          subtitle: 'Gray diagonal "DRAFT" text',
          icon: Icons.edit_note_rounded,
          gradient: AppColors.warningGradient,
          onGenerate: () => _generateWatermarkPdf('draft'),
        ),
        _SecurityOption(
          title: 'Copy Watermark',
          subtitle: 'Blue diagonal "COPY" text',
          icon: Icons.content_copy_rounded,
          gradient: AppColors.infoGradient,
          onGenerate: () => _generateWatermarkPdf('copy'),
        ),
        _SecurityOption(
          title: 'Tiled Watermark',
          subtitle: 'Repeating pattern across page',
          icon: Icons.grid_view_rounded,
          gradient: AppColors.purpleGradient,
          onGenerate: () => _generateWatermarkPdf('tiled'),
        ),
        _SecurityOption(
          title: 'Custom Watermark',
          subtitle: 'Custom text with settings',
          icon: Icons.tune_rounded,
          gradient: AppColors.cyanGradient,
          onGenerate: () => _generateWatermarkPdf('custom'),
        ),
      ],
      onGenerateAll: _generateComprehensiveDemo,
    );
  }

  Widget _buildEncryptionTab(bool isDark) {
    return _SecurityTabContent(
      isDark: isDark,
      title: 'Encryption & Permissions',
      description: 'Password protect documents and control permissions.',
      icon: Icons.lock_rounded,
      gradient: AppColors.errorGradient,
      isGenerating: _isGenerating,
      options: [
        _SecurityOption(
          title: 'Password Protected',
          subtitle: 'Simple password protection (password: demo123)',
          icon: Icons.password_rounded,
          gradient: AppColors.primaryGradient,
          onGenerate: () => _generateEncryptedPdf('password'),
        ),
        _SecurityOption(
          title: 'Read Only',
          subtitle: 'Allow viewing and printing only',
          icon: Icons.visibility_rounded,
          gradient: AppColors.infoGradient,
          onGenerate: () => _generateEncryptedPdf('readonly'),
        ),
        _SecurityOption(
          title: 'Print Only',
          subtitle: 'Allow printing, no copying',
          icon: Icons.print_rounded,
          gradient: AppColors.successGradient,
          onGenerate: () => _generateEncryptedPdf('printonly'),
        ),
        _SecurityOption(
          title: 'Full Protection',
          subtitle: 'Maximum security, no permissions',
          icon: Icons.shield_rounded,
          gradient: AppColors.errorGradient,
          onGenerate: () => _generateEncryptedPdf('full'),
        ),
        _SecurityOption(
          title: 'AES-256 Encryption',
          subtitle: 'High-grade encryption',
          icon: Icons.enhanced_encryption_rounded,
          gradient: AppColors.purpleGradient,
          onGenerate: () => _generateEncryptedPdf('aes256'),
        ),
      ],
      onGenerateAll: _generateComprehensiveDemo,
    );
  }

  Widget _buildSignaturesTab(bool isDark) {
    return _SecurityTabContent(
      isDark: isDark,
      title: 'Digital Signatures',
      description: 'Add visual and digital signatures to documents.',
      icon: Icons.draw_rounded,
      gradient: AppColors.successGradient,
      isGenerating: _isGenerating,
      options: [
        _SecurityOption(
          title: 'Visual Signature',
          subtitle: 'Signature box with name and date',
          icon: Icons.draw_rounded,
          gradient: AppColors.primaryGradient,
          onGenerate: () => _generateSignedPdf('visual'),
        ),
        _SecurityOption(
          title: 'Detailed Signature',
          subtitle: 'With reason and location',
          icon: Icons.description_rounded,
          gradient: AppColors.infoGradient,
          onGenerate: () => _generateSignedPdf('detailed'),
        ),
        _SecurityOption(
          title: 'Multiple Signatures',
          subtitle: 'Multiple signers on document',
          icon: Icons.group_rounded,
          gradient: AppColors.purpleGradient,
          onGenerate: () => _generateSignedPdf('multiple'),
        ),
        _SecurityOption(
          title: 'Custom Position',
          subtitle: 'Signature at custom location',
          icon: Icons.place_rounded,
          gradient: AppColors.tealGradient,
          onGenerate: () => _generateSignedPdf('custom'),
        ),
      ],
      onGenerateAll: _generateComprehensiveDemo,
    );
  }

  Future<void> _generateWatermarkPdf(String type) async {
    setState(() => _isGenerating = true);

    try {
      final document = PdfDocument();
      final page = document.pages.add();
      final graphics = page.graphics;
      final pageSize = page.getClientSize();

      _addSampleContent(
          graphics, pageSize, 'Watermark Demo - ${type.toUpperCase()}');

      switch (type) {
        case 'confidential':
          document.addWatermark(GeniusPdfWatermark.confidential(
            config: geniusPdfConfig,
          ));
          break;
        case 'draft':
          document.addWatermark(GeniusPdfWatermark.draft(
            config: geniusPdfConfig,
          ));
          break;
        case 'copy':
          document.addWatermark(GeniusPdfWatermark.copy(
            config: geniusPdfConfig,
          ));
          break;
        case 'tiled':
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
          break;
        case 'custom':
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
          break;
      }

      await _saveAndOpenPdf(document, 'watermark_$type');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateEncryptedPdf(String type) async {
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

      switch (type) {
        case 'password':
          document.protectWithPassword(password: 'demo123');
          encryptionInfo =
              'Password: demo123\nEncryption: AES-256\nPermissions: All';
          break;
        case 'readonly':
          GeniusPdfSecurityService.applySecurity(
            document,
            GeniusPdfSecuritySettings.readOnly(ownerPassword: 'admin123'),
          );
          encryptionInfo =
              'Owner Password: admin123\nPermissions: Read & Print Only';
          break;
        case 'printonly':
          GeniusPdfSecurityService.applySecurity(
            document,
            GeniusPdfSecuritySettings.printOnly(ownerPassword: 'admin123'),
          );
          encryptionInfo = 'Owner Password: admin123\nPermissions: Print Only';
          break;
        case 'full':
          GeniusPdfSecurityService.applySecurity(
            document,
            GeniusPdfSecuritySettings.fullProtection(
              userPassword: 'user123',
              ownerPassword: 'admin123',
            ),
          );
          encryptionInfo =
              'User Password: user123\nOwner Password: admin123\nPermissions: None';
          break;
        case 'aes256':
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
          break;
      }

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

      await _saveAndOpenPdf(document, 'encrypted_$type');
    } catch (e) {
      _showError(e.toString());
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateSignedPdf(String type) async {
    setState(() => _isGenerating = true);

    try {
      final document = PdfDocument();
      final page = document.pages.add();
      final graphics = page.graphics;
      final pageSize = page.getClientSize();

      _addSampleContent(
          graphics, pageSize, 'Signed Document - ${type.toUpperCase()}');

      switch (type) {
        case 'visual':
          final signature = GeniusPdfDigitalSignature(
            config: geniusPdfConfig,
            settings: GeniusDigitalSignatureSettings(
              signerName: 'John Doe',
              pageNumber: 0,
            ),
          );
          signature.drawOnPage(page);
          break;
        case 'detailed':
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
          break;
        case 'multiple':
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
          break;
        case 'custom':
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
          break;
      }

      await _saveAndOpenPdf(document, 'signed_$type');
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

      await _saveAndOpenPdf(document, 'comprehensive_security_demo');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                const Text('Comprehensive demo generated! Password: demo123'),
            backgroundColor: AppColors.success,
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

  Future<void> _saveAndOpenPdf(PdfDocument document, String fileName) async {
    final bytes = await document.save();
    document.dispose();

    final filePath = await demoDocuments.saveAndOpen(
      bytes: Uint8List.fromList(bytes),
      fileName: fileName,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF saved: $filePath'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $message'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }
}

class _SecurityTab {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  _SecurityTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}

class _SecurityOption {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final VoidCallback onGenerate;

  _SecurityOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onGenerate,
  });
}

class _SecurityTabContent extends StatelessWidget {
  final bool isDark;
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final bool isGenerating;
  final List<_SecurityOption> options;
  final VoidCallback onGenerateAll;

  const _SecurityTabContent({
    required this.isDark,
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.isGenerating,
    required this.options,
    required this.onGenerateAll,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                gradient[0].withValues(alpha: 0.15),
                gradient[1].withValues(alpha: 0.05)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: gradient[0].withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: gradient),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Options Grid
        ...options.map((option) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _SecurityOptionCard(
                option: option,
                isDark: isDark,
                isGenerating: isGenerating,
              ),
            )),

        const SizedBox(height: 8),

        // Generate All Button
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppColors.primaryGradient),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isGenerating ? null : onGenerateAll,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isGenerating)
                      const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    else
                      const Icon(Icons.auto_awesome_rounded,
                          color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    const Text(
                      'Generate Comprehensive Demo',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SecurityOptionCard extends StatelessWidget {
  final _SecurityOption option;
  final bool isDark;
  final bool isGenerating;

  const _SecurityOptionCard({
    required this.option,
    required this.isDark,
    required this.isGenerating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isGenerating ? null : option.onGenerate,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        option.gradient[0].withValues(alpha: 0.2),
                        option.gradient[1].withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    option.icon,
                    color: option.gradient[0],
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color:
                              isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isGenerating)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: option.gradient[0],
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: option.gradient[0].withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.picture_as_pdf_rounded,
                      color: option.gradient[0],
                      size: 18,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
