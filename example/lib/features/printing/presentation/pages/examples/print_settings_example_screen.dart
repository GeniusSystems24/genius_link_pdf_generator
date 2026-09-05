import 'package:flutter/material.dart';
import 'package:genius_pdf_example/features/printing/presentation/controllers/printing_demo_controller.dart';
import 'package:genius_pdf_example/features/printing/presentation/internal/printing_single_example_host.dart';

class PrintSettingsExampleScreen extends StatelessWidget {
  const PrintSettingsExampleScreen({super.key, this.controller});
  final PrintingDemoController? controller;

  static const String dartUsageCode = r'''
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
''';

  @override
  Widget build(BuildContext context) {
    return PrintingSingleExampleHost(
      section: PrintingDemoSection.settings,
      usageCode: dartUsageCode, controller: controller,
    );
  }
}
