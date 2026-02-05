import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';

/// Demo screen for Advanced Printing (v2.2.0 & v2.2.1).
class PrintingDemoScreen extends StatefulWidget {
  const PrintingDemoScreen({super.key});

  @override
  State<PrintingDemoScreen> createState() => _PrintingDemoScreenState();
}

class _PrintingDemoScreenState extends State<PrintingDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  String _status = '';
  List<GeniusPrinterInfo> _printers = [];
  GeniusPrintSettings _currentSettings = GeniusPrintSettings.defaults();
  Uint8List? _samplePdfBytes;
  List<GeniusPrintProfile> _profiles = [];

  final List<_PrintingTab> _tabs = [
    _PrintingTab(
      id: 'printers',
      title: 'Printers',
      icon: Icons.print_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _PrintingTab(
      id: 'settings',
      title: 'Settings',
      icon: Icons.tune_rounded,
      gradient: AppColors.infoGradient,
    ),
    _PrintingTab(
      id: 'print',
      title: 'Print',
      icon: Icons.picture_as_pdf_rounded,
      gradient: AppColors.successGradient,
    ),
    _PrintingTab(
      id: 'profiles',
      title: 'Profiles',
      icon: Icons.bookmark_rounded,
      gradient: AppColors.purpleGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _generateSamplePdf();
    _loadProfiles();
  }

  void _loadProfiles() {
    setState(() {
      _profiles = GeniusPrintSettingsManager.instance.allProfiles;
    });
  }

  Future<void> _generateSamplePdf() async {
    setState(() {
      _isLoading = true;
      _status = 'Generating sample PDF...';
    });

    try {
      final document = PdfDocument();

      PdfFont font;
      PdfFont titleFont;
      try {
        font = geniusPdfConfig.baseFont;
        titleFont = PdfTrueTypeFont(geniusPdfConfig.baseFontBytes, 18,
            style: PdfFontStyle.bold);
      } catch (_) {
        font = PdfTrueTypeFont(geniusPdfConfig.baseFontBytes, 12);
        titleFont = PdfTrueTypeFont(geniusPdfConfig.baseFontBytes, 18,
            style: PdfFontStyle.bold);
      }

      // Page 1: Title page
      final page1 = document.pages.add();
      final g1 = page1.graphics;
      g1.drawString(
        'Genius Link PDF Generator',
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 51, 102)),
        bounds: const Rect.fromLTWH(50, 100, 500, 40),
      );
      g1.drawString(
        'Advanced Printing Demo (v2.2.1)',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 150, 500, 30),
      );
      g1.drawLine(
        PdfPen(PdfColor(0, 51, 102), width: 2),
        const Offset(50, 190),
        const Offset(550, 190),
      );
      g1.drawString(
        'Generated: ${DateTime.now().toString().split('.').first}',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 210, 500, 30),
      );
      g1.drawString(
        'Page 1 of 3',
        font,
        brush: PdfSolidBrush(PdfColor(150, 150, 150)),
        bounds: const Rect.fromLTWH(50, 750, 500, 30),
      );

      // Page 2
      final page2 = document.pages.add();
      final g2 = page2.graphics;
      g2.drawString(
        'Print Settings Reference',
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 51, 102)),
        bounds: const Rect.fromLTWH(50, 50, 500, 40),
      );
      g2.drawLine(
        PdfPen(PdfColor(200, 200, 200)),
        const Offset(50, 90),
        const Offset(550, 90),
      );

      final settingsInfo = [
        'Paper Sizes: A4, Letter, Legal, A3, A5, Custom',
        'Orientations: Portrait, Landscape, Auto',
        'Color Modes: Color, Grayscale, Black & White',
        'Quality: Draft, Normal, High, Photo',
        'Duplex: Simplex, Long Edge, Short Edge',
        'Pages Per Sheet: 1, 2, 4, 6, 9, 16',
        'Scale: 25% to 200%',
        'Features: Collate, Reverse Order, Fit to Page',
      ];

      var yPos = 110.0;
      for (final info in settingsInfo) {
        g2.drawString(
          '• $info',
          font,
          brush: PdfSolidBrush(PdfColor(0, 0, 0)),
          bounds: Rect.fromLTWH(50, yPos, 500, 25),
        );
        yPos += 30;
      }

      g2.drawString(
        'Page 2 of 3',
        font,
        brush: PdfSolidBrush(PdfColor(150, 150, 150)),
        bounds: const Rect.fromLTWH(50, 750, 500, 30),
      );

      // Page 3
      final page3 = document.pages.add();
      final g3 = page3.graphics;
      g3.drawString(
        'Test Page',
        titleFont,
        brush: PdfSolidBrush(PdfColor(0, 51, 102)),
        bounds: const Rect.fromLTWH(50, 50, 500, 40),
      );
      g3.drawLine(
        PdfPen(PdfColor(200, 200, 200)),
        const Offset(50, 90),
        const Offset(550, 90),
      );
      g3.drawString(
        'This page tests mixed content rendering.',
        font,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: const Rect.fromLTWH(50, 110, 500, 30),
      );
      g3.drawString(
        'Use this to verify font rendering in print output.',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 140, 500, 30),
      );

      g3.drawRectangle(
        brush: PdfSolidBrush(PdfColor(0, 102, 204)),
        bounds: const Rect.fromLTWH(50, 200, 200, 100),
      );
      g3.drawRectangle(
        brush: PdfSolidBrush(PdfColor(255, 153, 0)),
        bounds: const Rect.fromLTWH(260, 200, 200, 100),
      );
      g3.drawString(
        'Color test boxes - Verify color mode settings',
        font,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: const Rect.fromLTWH(50, 320, 500, 30),
      );

      g3.drawString(
        'Page 3 of 3',
        font,
        brush: PdfSolidBrush(PdfColor(150, 150, 150)),
        bounds: const Rect.fromLTWH(50, 750, 500, 30),
      );

      _samplePdfBytes = Uint8List.fromList(await document.save());
      document.dispose();

      setState(() {
        _isLoading = false;
        _status =
            'Sample PDF ready (3 pages, ${_samplePdfBytes!.length} bytes)';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error generating PDF: $e';
      });
    }
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
                    _buildPrintersTab(isDark),
                    _buildSettingsTab(isDark),
                    _buildPrintTab(isDark),
                    _buildProfilesTab(isDark),
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
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
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
                Icon(tab.icon, size: 16),
                const SizedBox(width: 6),
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

  Widget _buildPrintersTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(
          isDark: isDark,
          title: 'Printer Discovery',
          description: 'Find and view available printers on your system.',
          icon: Icons.print_rounded,
          gradient: AppColors.primaryGradient,
        ),
        const SizedBox(height: 16),
        _buildActionButton(
          isDark: isDark,
          label: 'Discover Printers',
          icon: Icons.search_rounded,
          gradient: AppColors.primaryGradient,
          onPressed: _discoverPrinters,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          isDark: isDark,
          label: 'Check Printing Info',
          icon: Icons.info_outline_rounded,
          gradient: AppColors.infoGradient,
          onPressed: _checkPrintingInfo,
        ),
        const SizedBox(height: 16),
        if (_printers.isNotEmpty) ...[
          _buildSectionTitle(isDark, 'Available Printers'),
          const SizedBox(height: 8),
          ..._printers.map((printer) => _buildPrinterCard(isDark, printer)),
        ],
        const SizedBox(height: 16),
        _buildStatusCard(isDark),
      ],
    );
  }

  Widget _buildSettingsTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(
          isDark: isDark,
          title: 'Print Settings',
          description: 'Configure paper size, quality, copies, and more.',
          icon: Icons.tune_rounded,
          gradient: AppColors.infoGradient,
        ),
        const SizedBox(height: 16),

        // Paper Size
        _buildSettingCard(
          isDark: isDark,
          title: 'Paper Size',
          icon: Icons.description_rounded,
          child: DropdownButton<GeniusPaperSize>(
            value: _currentSettings.paperSize,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
            items: GeniusPaperSize.values.map((size) {
              return DropdownMenuItem(
                value: size,
                child: Text(
                  size.displayName,
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _currentSettings =
                      _currentSettings.copyWith(paperSize: value);
                });
              }
            },
          ),
        ),

        // Orientation
        _buildSettingCard(
          isDark: isDark,
          title: 'Orientation',
          icon: Icons.crop_rotate_rounded,
          child: DropdownButton<GeniusPrintOrientation>(
            value: _currentSettings.orientation,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
            items: GeniusPrintOrientation.values.map((orientation) {
              return DropdownMenuItem(
                value: orientation,
                child: Text(
                  orientation.name.substring(0, 1).toUpperCase() +
                      orientation.name.substring(1),
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _currentSettings =
                      _currentSettings.copyWith(orientation: value);
                });
              }
            },
          ),
        ),

        // Color Mode
        _buildSettingCard(
          isDark: isDark,
          title: 'Color Mode',
          icon: Icons.palette_rounded,
          child: DropdownButton<GeniusPrintColorMode>(
            value: _currentSettings.colorMode,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
            items: GeniusPrintColorMode.values.map((mode) {
              return DropdownMenuItem(
                value: mode,
                child: Text(
                  mode.name.substring(0, 1).toUpperCase() +
                      mode.name.substring(1),
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _currentSettings =
                      _currentSettings.copyWith(colorMode: value);
                });
              }
            },
          ),
        ),

        // Quality
        _buildSettingCard(
          isDark: isDark,
          title: 'Quality',
          icon: Icons.high_quality_rounded,
          child: DropdownButton<GeniusPrintQuality>(
            value: _currentSettings.quality,
            isExpanded: true,
            underline: const SizedBox(),
            dropdownColor: isDark ? AppColors.darkCard : AppColors.lightCard,
            items: GeniusPrintQuality.values.map((quality) {
              return DropdownMenuItem(
                value: quality,
                child: Text(
                  quality.name.substring(0, 1).toUpperCase() +
                      quality.name.substring(1),
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _currentSettings = _currentSettings.copyWith(quality: value);
                });
              }
            },
          ),
        ),

        // Copies
        _buildSettingCard(
          isDark: isDark,
          title: 'Copies: ${_currentSettings.copies}',
          icon: Icons.content_copy_rounded,
          child: Slider(
            value: _currentSettings.copies.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: AppColors.primary,
            label: _currentSettings.copies.toString(),
            onChanged: (value) {
              setState(() {
                _currentSettings =
                    _currentSettings.copyWith(copies: value.toInt());
              });
            },
          ),
        ),

        const SizedBox(height: 16),
        _buildSectionTitle(isDark, 'Presets'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildPresetChip(isDark, 'Default', () {
              setState(() => _currentSettings = GeniusPrintSettings.defaults());
            }),
            _buildPresetChip(isDark, 'Eco', () {
              setState(() => _currentSettings = GeniusPrintSettings.eco());
            }),
            _buildPresetChip(isDark, 'High Quality', () {
              setState(
                  () => _currentSettings = GeniusPrintSettings.highQuality());
            }),
            _buildPresetChip(isDark, 'Draft', () {
              setState(() => _currentSettings = GeniusPrintSettings.draft());
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildPrintTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(
          isDark: isDark,
          title: 'Print Document',
          description: 'Print the sample PDF with your configured settings.',
          icon: Icons.picture_as_pdf_rounded,
          gradient: AppColors.successGradient,
        ),
        const SizedBox(height: 16),

        // Settings Summary
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Settings',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(height: 12),
              _buildSettingRow(
                  isDark, 'Paper', _currentSettings.paperSize.displayName),
              _buildSettingRow(
                  isDark, 'Orientation', _currentSettings.orientation.name),
              _buildSettingRow(
                  isDark, 'Color', _currentSettings.colorMode.name),
              _buildSettingRow(
                  isDark, 'Quality', _currentSettings.quality.name),
              _buildSettingRow(isDark, 'Copies', '${_currentSettings.copies}'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildActionButton(
          isDark: isDark,
          label: 'Print Preview',
          icon: Icons.preview_rounded,
          gradient: AppColors.infoGradient,
          onPressed: _samplePdfBytes != null ? _showPrintPreview : null,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          isDark: isDark,
          label: 'Print with Dialog',
          icon: Icons.print_rounded,
          gradient: AppColors.successGradient,
          onPressed: _samplePdfBytes != null ? _printWithDialog : null,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          isDark: isDark,
          label: 'Regenerate Sample PDF',
          icon: Icons.refresh_rounded,
          gradient: AppColors.warningGradient,
          onPressed: _generateSamplePdf,
        ),
        const SizedBox(height: 16),
        _buildStatusCard(isDark),
      ],
    );
  }

  Widget _buildProfilesTab(bool isDark) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildHeaderCard(
          isDark: isDark,
          title: 'Print Profiles',
          description: 'Save and manage your favorite print settings.',
          icon: Icons.bookmark_rounded,
          gradient: AppColors.purpleGradient,
        ),
        const SizedBox(height: 16),
        _buildSectionTitle(isDark, 'System Presets'),
        const SizedBox(height: 8),
        ..._profiles
            .where((p) => p.isSystemPreset)
            .map((profile) => _buildProfileCard(isDark, profile)),
        const SizedBox(height: 16),
        _buildSectionTitle(isDark, 'Your Profiles'),
        const SizedBox(height: 8),
        if (_profiles.where((p) => !p.isSystemPreset).isEmpty)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : AppColors.lightCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              ),
            ),
            child: Center(
              child: Text(
                'No custom profiles yet',
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
            ),
          )
        else
          ..._profiles
              .where((p) => !p.isSystemPreset)
              .map((profile) => _buildProfileCard(isDark, profile)),
        const SizedBox(height: 16),
        _buildActionButton(
          isDark: isDark,
          label: 'Save Current Settings',
          icon: Icons.save_rounded,
          gradient: AppColors.primaryGradient,
          onPressed: _saveCurrentSettings,
        ),
        const SizedBox(height: 16),
        _buildStatusCard(isDark),
      ],
    );
  }

  Widget _buildHeaderCard({
    required bool isDark,
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
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
        border: Border.all(color: gradient[0].withValues(alpha: 0.3)),
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
                    color: isDark ? AppColors.darkText : AppColors.lightText,
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
    );
  }

  Widget _buildActionButton({
    required bool isDark,
    required String label,
    required IconData icon,
    required List<Color> gradient,
    VoidCallback? onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: onPressed != null ? LinearGradient(colors: gradient) : null,
        color: onPressed == null
            ? (isDark ? AppColors.darkCard : AppColors.lightBorder)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: onPressed != null
                      ? Colors.white
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  label,
                  style: TextStyle(
                    color: onPressed != null
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildSettingRow(bool isDark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(bool isDark, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildPresetChip(bool isDark, String label, VoidCallback onPressed) {
    return ActionChip(
      label: Text(label),
      onPressed: onPressed,
      backgroundColor: isDark ? AppColors.darkCard : AppColors.lightSurface,
      side: BorderSide(
        color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
      ),
      labelStyle: TextStyle(
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildPrinterCard(bool isDark, GeniusPrinterInfo printer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: printer.isAvailable
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              printer.isDefault ? Icons.print_rounded : Icons.print_outlined,
              color: printer.isAvailable ? AppColors.success : AppColors.error,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  printer.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                Text(
                  printer.statusTextEn,
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
          if (printer.isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Default',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(bool isDark, GeniusPrintProfile profile) {
    final isDefault =
        GeniusPrintSettingsManager.instance.defaultProfile?.id == profile.id;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
          onTap: () => _applyProfile(profile),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    profile.isSystemPreset
                        ? Icons.settings_rounded
                        : Icons.person_rounded,
                    color:
                        isDefault ? AppColors.primary : AppColors.primaryLight,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color:
                              isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                      Text(
                        '${profile.settings.paperSize.displayName}, ${profile.settings.colorMode.name}',
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
                if (isDefault)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Default',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.success,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const SizedBox(width: 8),
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            _status.isEmpty ? 'Ready' : _status,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // Actions
  Future<void> _discoverPrinters() async {
    setState(() {
      _isLoading = true;
      _status = 'Discovering printers...';
    });

    try {
      final printers = await GeniusPrinterDiscovery.instance.discoverPrinters(
        forceRefresh: true,
      );

      setState(() {
        _printers = printers;
        _isLoading = false;
        _status = 'Found ${printers.length} printer(s)';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _checkPrintingInfo() async {
    setState(() {
      _isLoading = true;
      _status = 'Checking printing info...';
    });

    try {
      final info = await GeniusPrinterService.instance.getPrintingInfo();
      final isAvailable =
          await GeniusPrinterService.instance.isPrintingAvailable();

      setState(() {
        _isLoading = false;
        _status = '''
Printing Available: $isAvailable
Can Print: ${info.canPrint}
Can Share: ${info.canShare}
Can Raster: ${info.canRaster}
Direct Print: ${info.directPrint}
''';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _printWithDialog() async {
    if (_samplePdfBytes == null) return;

    setState(() {
      _isLoading = true;
      _status = 'Opening print dialog...';
    });

    try {
      final result = await GeniusPrinterService.instance.printWithDialog(
        config: geniusPdfConfig,
        pdfBytes: _samplePdfBytes!,
        documentName: 'Sample_Document',
        settings: _currentSettings,
        onProgress: (job) {
          setState(() {
            _status = 'Printing: ${(job.progress * 100).toStringAsFixed(0)}%';
          });
        },
        onComplete: (job) {
          setState(() {
            _status = 'Print completed: ${job.statusTextEn}';
          });
        },
        onError: (job, error) {
          setState(() {
            _status = 'Print error: $error';
          });
        },
      );

      setState(() {
        _isLoading = false;
        if (result.success) {
          _status = 'Print job completed successfully!';
        } else {
          _status = 'Print cancelled or failed: ${result.error}';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _showPrintPreview() async {
    if (_samplePdfBytes == null) return;

    final result = await GeniusPrintPreviewDialog.show(
      config: geniusPdfConfig,
      context: context,
      pdfBytes: _samplePdfBytes!,
      documentName: 'Sample_Document',
      initialSettings: _currentSettings,
      showSettings: true,
    );

    setState(() {
      if (result == true) {
        _status = 'Document printed from preview!';
      } else {
        _status = 'Print preview closed';
      }
    });
  }

  void _saveCurrentSettings() {
    showDialog(
      context: context,
      builder: (context) {
        String name = '';
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSurface
              : AppColors.lightSurface,
          title: const Text('Save Profile'),
          content: TextField(
            decoration: const InputDecoration(
              labelText: 'Profile Name',
              hintText: 'e.g., My Office Settings',
            ),
            onChanged: (value) => name = value,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (name.isNotEmpty) {
                  _currentSettings.saveAsProfile(name: name);
                  Navigator.pop(context);
                  _loadProfiles();
                  setState(() {
                    _status = 'Profile "$name" saved!';
                  });
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _applyProfile(GeniusPrintProfile profile) {
    setState(() {
      _currentSettings = profile.settings;
      _status = 'Applied profile: ${profile.name}';
    });
    GeniusPrintSettingsManager.instance.recordUsage(profile.id);
  }
}

class _PrintingTab {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  _PrintingTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}
