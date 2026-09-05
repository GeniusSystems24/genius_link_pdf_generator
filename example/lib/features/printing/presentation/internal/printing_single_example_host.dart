import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart' show geniusPdfConfig;
import 'package:genius_pdf_example/features/printing/presentation/controllers/printing_demo_controller.dart';
import 'package:genius_pdf_example/app/theme/app_theme.dart';

import 'package:super_core/super_core.dart';
import 'package:genius_pdf_example/shared/presentation/widgets/feature_example_page.dart';
enum PrintingDemoSection { printers, settings, print, profiles }

/// Demo screen for Advanced Printing (v2.2.0 & v2.2.1).
class PrintingSingleExampleHost extends StatefulWidget {
  const PrintingSingleExampleHost({super.key, required this.section, required this.usageCode, this.controller});

  final PrintingDemoSection section;
  final String usageCode;

  final PrintingDemoController? controller;
  @override
  State<PrintingSingleExampleHost> createState() => _PrintingSingleExampleHostState();
}

class _PrintingSingleExampleHostState extends State<PrintingSingleExampleHost> {
  late final PrintingDemoController _controller;
  late final bool _ownsController;
  @override
  void initState() {
    super.initState();
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
    _controller.removeListener(_onControllerChanged);
    if (_ownsController) _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = switch (widget.section) {
      PrintingDemoSection.printers => _buildPrintersTab(isDark),
      PrintingDemoSection.settings => _buildSettingsTab(isDark),
      PrintingDemoSection.print => _buildPrintTab(isDark),
      PrintingDemoSection.profiles => _buildProfilesTab(isDark),
    };
    final title = switch (widget.section) {
      PrintingDemoSection.printers => 'Printer Discovery',
      PrintingDemoSection.settings => 'Print Settings',
      PrintingDemoSection.print => 'Print & Preview',
      PrintingDemoSection.profiles => 'Print Profiles',
    };
    final description = switch (widget.section) {
      PrintingDemoSection.printers =>
        'Discover printers and inspect the printing capabilities available on this device.',
      PrintingDemoSection.settings =>
        'Configure paper, orientation, color, quality, duplex, scale, and related print settings.',
      PrintingDemoSection.print =>
        'Generate the sample document explicitly, preview it, then open the platform print dialog.',
      PrintingDemoSection.profiles =>
        'Apply system presets and save reusable custom print-setting profiles.',
    };
    final icon = switch (widget.section) {
      PrintingDemoSection.printers => Icons.print_outlined,
      PrintingDemoSection.settings => Icons.tune_rounded,
      PrintingDemoSection.print => Icons.picture_as_pdf_outlined,
      PrintingDemoSection.profiles => Icons.bookmark_outline_rounded,
    };
    final status = _controller.status.trim().isEmpty
        ? 'Ready for action.'
        : _controller.status;

    return FeatureExamplePage(
      title: title,
      description: description,
      icon: icon,
      contentTitle: 'Interactive controls',
      content: content,
      code: widget.usageCode,
      statusMessage: status,
      statusTone: status.toLowerCase().contains('error')
          ? FeatureExampleTone.danger
          : (_controller.isLoading
              ? FeatureExampleTone.info
              : FeatureExampleTone.neutral),
      codeHeight: 520,
    );
  }

  Widget _buildPrintersTab(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
          label: _controller.hasSample ? 'Regenerate Sample PDF' : 'Generate Sample PDF',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
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
    return const SizedBox.shrink();
  }
  Widget _buildActionButton({
    required bool isDark,
    required String label,
    required IconData icon,
    required List<Color> gradient,
    VoidCallback? onPressed,
  }) {
    return FilledButton.tonalIcon(
      onPressed: _controller.isLoading ? null : onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
  Widget _buildSettingCard({
    required bool isDark,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    final t = context.superTheme;
    return Card(
      margin: EdgeInsets.only(bottom: t.spacing.space3),
      child: Padding(
        padding: t.spacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
                SizedBox(width: t.spacing.space2),
                Text(title, style: context.superTextTheme.titleMd.copyWith(color: t.fg1)),
              ],
            ),
            SizedBox(height: t.spacing.space3),
            child,
          ],
        ),
      ),
    );
  }
  Widget _buildSettingRow(bool isDark, String label, String value) {
    final t = context.superTheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.spacing.space1),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: context.superTextTheme.bodySm.copyWith(color: t.fg3))),
          SizedBox(width: t.spacing.space3),
          Text(value, style: context.superTextTheme.labelMd.copyWith(color: t.fg1)),
        ],
      ),
    );
  }
  Widget _buildSectionTitle(bool isDark, String title) {
    return Text(
      title,
      style: context.superTextTheme.titleMd.copyWith(color: context.superTheme.fg1),
    );
  }
  Widget _buildPresetChip(bool isDark, String label, VoidCallback onPressed) {
    return ActionChip(label: Text(label), onPressed: onPressed);
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
  Widget _buildStatusCard(bool isDark) => const SizedBox.shrink();

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
