part of '../print_preview.dart';

class _PrintSettingsSheet extends StatefulWidget {

  const _PrintSettingsSheet({
    required this.settings,
    required this.onSettingsChanged,
  });
  final GeniusPrintSettings settings;
  final void Function(GeniusPrintSettings) onSettingsChanged;

  @override
  State<_PrintSettingsSheet> createState() => _PrintSettingsSheetState();
}

class _PrintSettingsSheetState extends State<_PrintSettingsSheet> {
  late GeniusPrintSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  void _updateSettings(GeniusPrintSettings newSettings) {
    setState(() {
      _settings = newSettings;
    });
    widget.onSettingsChanged(newSettings);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.settings),
                    const SizedBox(width: 8),
                    Text(
                      'Print Settings / إعدادات الطباعة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Settings list
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Copies
                    _buildSettingTile(
                      title: 'Copies / النسخ',
                      subtitle: '${_settings.copies} copy/copies',
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: _settings.copies > 1
                                ? () => _updateSettings(
                                    _settings.copyWith(copies: _settings.copies - 1))
                                : null,
                          ),
                          Text('${_settings.copies}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: _settings.copies < 99
                                ? () => _updateSettings(
                                    _settings.copyWith(copies: _settings.copies + 1))
                                : null,
                          ),
                        ],
                      ),
                    ),

                    // Paper Size
                    _buildDropdownTile<GeniusPaperSize>(
                      title: 'Paper Size / حجم الورق',
                      value: _settings.paperSize,
                      items: GeniusPaperSize.values
                          .where((s) => s != GeniusPaperSize.custom)
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text('${s.displayName} (${s.displayNameAr})'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(paperSize: value));
                        }
                      },
                    ),

                    // Orientation
                    _buildDropdownTile<GeniusPrintOrientation>(
                      title: 'Orientation / الاتجاه',
                      value: _settings.orientation,
                      items: const [
                        DropdownMenuItem(
                          value: GeniusPrintOrientation.portrait,
                          child: Text('Portrait / عمودي'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintOrientation.landscape,
                          child: Text('Landscape / أفقي'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(orientation: value));
                        }
                      },
                    ),

                    // Color Mode
                    _buildDropdownTile<GeniusPrintColorMode>(
                      title: 'Color / الألوان',
                      value: _settings.colorMode,
                      items: const [
                        DropdownMenuItem(
                          value: GeniusPrintColorMode.color,
                          child: Text('Color / ملون'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintColorMode.grayscale,
                          child: Text('Grayscale / رمادي'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintColorMode.blackAndWhite,
                          child: Text('Black & White / أبيض وأسود'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(colorMode: value));
                        }
                      },
                    ),

                    // Quality
                    _buildDropdownTile<GeniusPrintQuality>(
                      title: 'Quality / الجودة',
                      value: _settings.quality,
                      items: const [
                        DropdownMenuItem(
                          value: GeniusPrintQuality.draft,
                          child: Text('Draft / مسودة'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintQuality.normal,
                          child: Text('Normal / عادي'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintQuality.high,
                          child: Text('High / عالي'),
                        ),
                        DropdownMenuItem(
                          value: GeniusPrintQuality.photo,
                          child: Text('Photo / صورة'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(quality: value));
                        }
                      },
                    ),

                    // Duplex
                    _buildDropdownTile<GeniusDuplexMode>(
                      title: 'Two-Sided / الوجهين',
                      value: _settings.duplexMode,
                      items: const [
                        DropdownMenuItem(
                          value: GeniusDuplexMode.simplex,
                          child: Text('Off / إيقاف'),
                        ),
                        DropdownMenuItem(
                          value: GeniusDuplexMode.longEdge,
                          child: Text('Long Edge / الحافة الطويلة'),
                        ),
                        DropdownMenuItem(
                          value: GeniusDuplexMode.shortEdge,
                          child: Text('Short Edge / الحافة القصيرة'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(duplexMode: value));
                        }
                      },
                    ),

                    // Pages per sheet
                    _buildDropdownTile<int>(
                      title: 'Pages per Sheet / صفحات في ورقة',
                      value: _settings.pagesPerSheet,
                      items: const [
                        DropdownMenuItem(value: 1, child: Text('1')),
                        DropdownMenuItem(value: 2, child: Text('2')),
                        DropdownMenuItem(value: 4, child: Text('4')),
                        DropdownMenuItem(value: 6, child: Text('6')),
                        DropdownMenuItem(value: 9, child: Text('9')),
                        DropdownMenuItem(value: 16, child: Text('16')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          _updateSettings(_settings.copyWith(pagesPerSheet: value));
                        }
                      },
                    ),

                    // Collate
                    SwitchListTile(
                      title: const Text('Collate / ترتيب'),
                      subtitle: const Text('Group pages of each copy together'),
                      value: _settings.collate,
                      onChanged: (value) {
                        _updateSettings(_settings.copyWith(collate: value));
                      },
                    ),

                    // Reverse Order
                    SwitchListTile(
                      title: const Text('Reverse Order / ترتيب عكسي'),
                      subtitle: const Text('Print last page first'),
                      value: _settings.reverseOrder,
                      onChanged: (value) {
                        _updateSettings(_settings.copyWith(reverseOrder: value));
                      },
                    ),

                    const SizedBox(height: 16),

                    // Presets
                    const Text(
                      'Quick Presets / إعدادات سريعة',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ActionChip(
                          avatar: const Icon(Icons.refresh, size: 18),
                          label: const Text('Default'),
                          onPressed: () {
                            _updateSettings(GeniusPrintSettings.defaults());
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.eco, size: 18),
                          label: const Text('Eco'),
                          onPressed: () {
                            _updateSettings(GeniusPrintSettings.eco());
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.high_quality, size: 18),
                          label: const Text('High Quality'),
                          onPressed: () {
                            _updateSettings(GeniusPrintSettings.highQuality());
                          },
                        ),
                        ActionChip(
                          avatar: const Icon(Icons.speed, size: 18),
                          label: const Text('Draft'),
                          onPressed: () {
                            _updateSettings(GeniusPrintSettings.draft());
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Apply button
              Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Done / تم'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingTile({
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: trailing,
    );
  }

  Widget _buildDropdownTile<T>({
    required String title,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required void Function(T?) onChanged,
  }) {
    return ListTile(
      title: Text(title),
      trailing: DropdownButton<T>(
        value: value,
        items: items,
        onChanged: onChanged,
        underline: const SizedBox(),
      ),
    );
  }
}

/// Print preview dialog helper
