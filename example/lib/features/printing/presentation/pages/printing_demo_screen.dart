import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart' show geniusPdfConfig;
import 'package:genius_pdf_example/features/printing/presentation/controllers/printing_demo_controller.dart';
import 'package:genius_pdf_example/app/theme/app_theme.dart';

/// Demo screen for Advanced Printing (v2.2.0 & v2.2.1).
class PrintingDemoScreen extends StatefulWidget {
  const PrintingDemoScreen({super.key, this.controller});

  final PrintingDemoController? controller;

  @override
  State<PrintingDemoScreen> createState() => _PrintingDemoScreenState();
}

class _PrintingDemoScreenState extends State<PrintingDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final PrintingDemoController _controller;
  late final bool _ownsController;

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
    _ownsController = widget.controller == null;
    _controller = widget.controller ?? PrintingDemoController(
      config: geniusPdfConfig,
    );
    _controller.addListener(_onControllerChanged);
    _controller.initialize();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _generateSamplePdf() => _controller.generateSamplePdf();

  @override
  void dispose() {
    _tabController.dispose();
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
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
        if (_controller.printers.isNotEmpty) ...[
          _buildSectionTitle(isDark, 'Available Printers'),
          const SizedBox(height: 8),
          ..._controller.printers.map((printer) => _buildPrinterCard(isDark, printer)),
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
            value: _controller.currentSettings.paperSize,
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
                  _controller.currentSettings =
                      _controller.currentSettings.copyWith(paperSize: value);
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
            value: _controller.currentSettings.orientation,
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
                  _controller.currentSettings =
                      _controller.currentSettings.copyWith(orientation: value);
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
            value: _controller.currentSettings.colorMode,
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
                  _controller.currentSettings =
                      _controller.currentSettings.copyWith(colorMode: value);
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
            value: _controller.currentSettings.quality,
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
                  _controller.currentSettings = _controller.currentSettings.copyWith(quality: value);
                });
              }
            },
          ),
        ),

        // Copies
        _buildSettingCard(
          isDark: isDark,
          title: 'Copies: ${_controller.currentSettings.copies}',
          icon: Icons.content_copy_rounded,
          child: Slider(
            value: _controller.currentSettings.copies.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            activeColor: AppColors.primary,
            label: _controller.currentSettings.copies.toString(),
            onChanged: (value) {
              setState(() {
                _controller.currentSettings =
                    _controller.currentSettings.copyWith(copies: value.toInt());
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
              setState(() => _controller.currentSettings = GeniusPrintSettings.defaults());
            }),
            _buildPresetChip(isDark, 'Eco', () {
              setState(() => _controller.currentSettings = GeniusPrintSettings.eco());
            }),
            _buildPresetChip(isDark, 'High Quality', () {
              setState(
                  () => _controller.currentSettings = GeniusPrintSettings.highQuality());
            }),
            _buildPresetChip(isDark, 'Draft', () {
              setState(() => _controller.currentSettings = GeniusPrintSettings.draft());
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
                  isDark, 'Paper', _controller.currentSettings.paperSize.displayName),
              _buildSettingRow(
                  isDark, 'Orientation', _controller.currentSettings.orientation.name),
              _buildSettingRow(
                  isDark, 'Color', _controller.currentSettings.colorMode.name),
              _buildSettingRow(
                  isDark, 'Quality', _controller.currentSettings.quality.name),
              _buildSettingRow(isDark, 'Copies', '${_controller.currentSettings.copies}'),
            ],
          ),
        ),
        const SizedBox(height: 16),

        _buildActionButton(
          isDark: isDark,
          label: 'Print Preview',
          icon: Icons.preview_rounded,
          gradient: AppColors.infoGradient,
          onPressed: _controller.samplePdfBytes != null ? _showPrintPreview : null,
        ),
        const SizedBox(height: 8),
        _buildActionButton(
          isDark: isDark,
          label: 'Print with Dialog',
          icon: Icons.print_rounded,
          gradient: AppColors.successGradient,
          onPressed: _controller.samplePdfBytes != null ? _printWithDialog : null,
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
        ..._controller.profiles
            .where((p) => p.isSystemPreset)
            .map((profile) => _buildProfileCard(isDark, profile)),
        const SizedBox(height: 16),
        _buildSectionTitle(isDark, 'Your Profiles'),
        const SizedBox(height: 8),
        if (_controller.profiles.where((p) => !p.isSystemPreset).isEmpty)
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
          ..._controller.profiles
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
          onTap: _controller.isLoading ? null : onPressed,
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
              if (_controller.isLoading)
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
            _controller.status.isEmpty ? 'Ready' : _controller.status,
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
  Future<void> _discoverPrinters() => _controller.discoverPrinters();

  Future<void> _checkPrintingInfo() => _controller.checkPrintingInfo();

  Future<void> _printWithDialog() => _controller.printWithDialog();

  Future<void> _showPrintPreview() async {
    if (_controller.samplePdfBytes == null) return;

    final result = await GeniusPrintPreviewDialog.show(
      config: geniusPdfConfig,
      context: context,
      pdfBytes: _controller.samplePdfBytes!,
      documentName: 'Sample_Document',
      initialSettings: _controller.currentSettings,
      showSettings: true,
    );

    _controller.updateStatus(
      result == true ? 'Document printed from preview!' : 'Print preview closed',
    );
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
                  _controller.saveProfile(name);
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _applyProfile(GeniusPrintProfile profile) =>
      _controller.applyProfile(profile);
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
