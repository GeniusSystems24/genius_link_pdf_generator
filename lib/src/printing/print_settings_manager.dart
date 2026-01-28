/// Print Settings Manager
///
/// Manages saved print settings and presets.
library;

import 'dart:convert';

import 'printer_models.dart';

/// Saved print settings profile
class GeniusPrintProfile {

  /// Creates a print profile
  GeniusPrintProfile({
    required this.id,
    required this.name,
    this.nameAr,
    this.iconName,
    required this.settings,
    this.isSystemPreset = false,
    DateTime? createdAt,
    this.lastUsedAt,
    this.usageCount = 0,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Creates from JSON
  factory GeniusPrintProfile.fromJson(Map<String, dynamic> json) {
    return GeniusPrintProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      nameAr: json['nameAr'] as String?,
      iconName: json['iconName'] as String?,
      settings: _settingsFromJson(json['settings'] as Map<String, dynamic>),
      isSystemPreset: json['isSystemPreset'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      lastUsedAt: json['lastUsedAt'] != null
          ? DateTime.parse(json['lastUsedAt'] as String)
          : null,
      usageCount: json['usageCount'] as int? ?? 0,
    );
  }
  /// Profile ID
  final String id;

  /// Profile name
  final String name;

  /// Profile name in Arabic
  final String? nameAr;

  /// Profile icon (optional)
  final String? iconName;

  /// Print settings
  final GeniusPrintSettings settings;

  /// Whether this is a system preset
  final bool isSystemPreset;

  /// Creation date
  final DateTime createdAt;

  /// Last used date
  DateTime? lastUsedAt;

  /// Usage count
  int usageCount;

  /// Converts to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameAr': nameAr,
      'iconName': iconName,
      'settings': _settingsToJson(settings),
      'isSystemPreset': isSystemPreset,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt?.toIso8601String(),
      'usageCount': usageCount,
    };
  }

  /// Records usage of this profile
  void recordUsage() {
    lastUsedAt = DateTime.now();
    usageCount++;
  }

  /// Creates a copy with modified values
  GeniusPrintProfile copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? iconName,
    GeniusPrintSettings? settings,
    bool? isSystemPreset,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    int? usageCount,
  }) {
    return GeniusPrintProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      iconName: iconName ?? this.iconName,
      settings: settings ?? this.settings,
      isSystemPreset: isSystemPreset ?? this.isSystemPreset,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      usageCount: usageCount ?? this.usageCount,
    );
  }

  static GeniusPrintSettings _settingsFromJson(Map<String, dynamic> json) {
    return GeniusPrintSettings(
      copies: json['copies'] as int? ?? 1,
      paperSize: GeniusPaperSize.values.firstWhere(
        (e) => e.name == json['paperSize'],
        orElse: () => GeniusPaperSize.a4,
      ),
      orientation: GeniusPrintOrientation.values.firstWhere(
        (e) => e.name == json['orientation'],
        orElse: () => GeniusPrintOrientation.portrait,
      ),
      colorMode: GeniusPrintColorMode.values.firstWhere(
        (e) => e.name == json['colorMode'],
        orElse: () => GeniusPrintColorMode.color,
      ),
      quality: GeniusPrintQuality.values.firstWhere(
        (e) => e.name == json['quality'],
        orElse: () => GeniusPrintQuality.normal,
      ),
      duplexMode: GeniusDuplexMode.values.firstWhere(
        (e) => e.name == json['duplexMode'],
        orElse: () => GeniusDuplexMode.simplex,
      ),
      pagesPerSheet: json['pagesPerSheet'] as int? ?? 1,
      collate: json['collate'] as bool? ?? true,
      reverseOrder: json['reverseOrder'] as bool? ?? false,
      fitToPage: json['fitToPage'] as bool? ?? true,
      scale: json['scale'] as int? ?? 100,
    );
  }

  static Map<String, dynamic> _settingsToJson(GeniusPrintSettings settings) {
    return {
      'copies': settings.copies,
      'paperSize': settings.paperSize.name,
      'orientation': settings.orientation.name,
      'colorMode': settings.colorMode.name,
      'quality': settings.quality.name,
      'duplexMode': settings.duplexMode.name,
      'pagesPerSheet': settings.pagesPerSheet,
      'collate': settings.collate,
      'reverseOrder': settings.reverseOrder,
      'fitToPage': settings.fitToPage,
      'scale': settings.scale,
    };
  }
}

/// Print settings manager
///
/// Manages saved print profiles and provides system presets.
class GeniusPrintSettingsManager {

  GeniusPrintSettingsManager._() {
    _initializeSystemPresets();
  }

  /// Creates a new instance (for testing)
  factory GeniusPrintSettingsManager() => instance;
  /// Singleton instance
  static GeniusPrintSettingsManager? _instance;

  /// Gets the singleton instance
  static GeniusPrintSettingsManager get instance {
    _instance ??= GeniusPrintSettingsManager._();
    return _instance!;
  }

  /// User-created profiles
  final List<GeniusPrintProfile> _userProfiles = [];

  /// System presets
  final List<GeniusPrintProfile> _systemPresets = [];

  /// Default profile ID
  String? _defaultProfileId;

  /// Storage callback for persistence
  Future<void> Function(String json)? onSave;

  /// Load callback for persistence
  Future<String?> Function()? onLoad;

  /// Gets all profiles (system + user)
  List<GeniusPrintProfile> get allProfiles => [..._systemPresets, ..._userProfiles];

  /// Gets user profiles only
  List<GeniusPrintProfile> get userProfiles => List.unmodifiable(_userProfiles);

  /// Gets system presets only
  List<GeniusPrintProfile> get systemPresets => List.unmodifiable(_systemPresets);

  /// Gets the default profile
  GeniusPrintProfile? get defaultProfile {
    if (_defaultProfileId == null) return null;
    return getProfile(_defaultProfileId!);
  }

  /// Gets recently used profiles
  List<GeniusPrintProfile> get recentProfiles {
    final all = allProfiles.where((p) => p.lastUsedAt != null).toList();
    all.sort((a, b) => b.lastUsedAt!.compareTo(a.lastUsedAt!));
    return all.take(5).toList();
  }

  /// Gets most used profiles
  List<GeniusPrintProfile> get mostUsedProfiles {
    final all = allProfiles.where((p) => p.usageCount > 0).toList();
    all.sort((a, b) => b.usageCount.compareTo(a.usageCount));
    return all.take(5).toList();
  }

  /// Initializes system presets
  void _initializeSystemPresets() {
    _systemPresets.addAll([
      GeniusPrintProfile(
        id: 'system_default',
        name: 'Default',
        nameAr: 'الافتراضي',
        iconName: 'print',
        settings: GeniusPrintSettings.defaults(),
        isSystemPreset: true,
      ),
      GeniusPrintProfile(
        id: 'system_eco',
        name: 'Eco-Friendly',
        nameAr: 'صديق للبيئة',
        iconName: 'eco',
        settings: GeniusPrintSettings.eco(),
        isSystemPreset: true,
      ),
      GeniusPrintProfile(
        id: 'system_high_quality',
        name: 'High Quality',
        nameAr: 'جودة عالية',
        iconName: 'high_quality',
        settings: GeniusPrintSettings.highQuality(),
        isSystemPreset: true,
      ),
      GeniusPrintProfile(
        id: 'system_draft',
        name: 'Draft',
        nameAr: 'مسودة',
        iconName: 'speed',
        settings: GeniusPrintSettings.draft(),
        isSystemPreset: true,
      ),
      GeniusPrintProfile(
        id: 'system_booklet',
        name: 'Booklet',
        nameAr: 'كتيب',
        iconName: 'menu_book',
        settings: const GeniusPrintSettings(
          duplexMode: GeniusDuplexMode.shortEdge,
          pagesPerSheet: 2,
        ),
        isSystemPreset: true,
      ),
      GeniusPrintProfile(
        id: 'system_presentation',
        name: 'Presentation',
        nameAr: 'عرض تقديمي',
        iconName: 'slideshow',
        settings: const GeniusPrintSettings(
          orientation: GeniusPrintOrientation.landscape,
          quality: GeniusPrintQuality.high,
          colorMode: GeniusPrintColorMode.color,
        ),
        isSystemPreset: true,
      ),
    ]);
  }

  /// Gets a profile by ID
  GeniusPrintProfile? getProfile(String id) {
    return allProfiles.where((p) => p.id == id).firstOrNull;
  }

  /// Creates a new user profile
  GeniusPrintProfile createProfile({
    required String name,
    String? nameAr,
    String? iconName,
    required GeniusPrintSettings settings,
  }) {
    final profile = GeniusPrintProfile(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      nameAr: nameAr,
      iconName: iconName,
      settings: settings,
    );
    _userProfiles.add(profile);
    _saveProfiles();
    return profile;
  }

  /// Updates a user profile
  bool updateProfile(String id, {
    String? name,
    String? nameAr,
    String? iconName,
    GeniusPrintSettings? settings,
  }) {
    final index = _userProfiles.indexWhere((p) => p.id == id);
    if (index == -1) return false;

    _userProfiles[index] = _userProfiles[index].copyWith(
      name: name,
      nameAr: nameAr,
      iconName: iconName,
      settings: settings,
    );
    _saveProfiles();
    return true;
  }

  /// Deletes a user profile
  bool deleteProfile(String id) {
    final index = _userProfiles.indexWhere((p) => p.id == id);
    if (index != -1) {
      _userProfiles.removeAt(index);
      if (_defaultProfileId == id) {
        _defaultProfileId = null;
      }
      _saveProfiles();
      return true;
    }
    return false;
  }

  /// Sets the default profile
  void setDefaultProfile(String? id) {
    _defaultProfileId = id;
    _saveProfiles();
  }

  /// Records usage of a profile
  void recordUsage(String id) {
    final profile = getProfile(id);
    if (profile != null) {
      profile.recordUsage();
      _saveProfiles();
    }
  }

  /// Loads profiles from storage
  Future<void> loadProfiles() async {
    if (onLoad == null) return;

    try {
      final json = await onLoad!();
      if (json == null || json.isEmpty) return;

      final data = jsonDecode(json) as Map<String, dynamic>;

      _userProfiles.clear();
      final profiles = data['profiles'] as List<dynamic>?;
      if (profiles != null) {
        for (final p in profiles) {
          _userProfiles.add(GeniusPrintProfile.fromJson(p as Map<String, dynamic>));
        }
      }

      _defaultProfileId = data['defaultProfileId'] as String?;

      // Update system preset usage stats
      final presetStats = data['presetStats'] as Map<String, dynamic>?;
      if (presetStats != null) {
        for (final preset in _systemPresets) {
          final stats = presetStats[preset.id] as Map<String, dynamic>?;
          if (stats != null) {
            preset.usageCount = stats['usageCount'] as int? ?? 0;
            preset.lastUsedAt = stats['lastUsedAt'] != null
                ? DateTime.parse(stats['lastUsedAt'] as String)
                : null;
          }
        }
      }
    } catch (e) {
      // Ignore load errors
    }
  }

  /// Saves profiles to storage
  Future<void> _saveProfiles() async {
    if (onSave == null) return;

    try {
      final presetStats = <String, dynamic>{};
      for (final preset in _systemPresets) {
        presetStats[preset.id] = {
          'usageCount': preset.usageCount,
          'lastUsedAt': preset.lastUsedAt?.toIso8601String(),
        };
      }

      final data = {
        'profiles': _userProfiles.map((p) => p.toJson()).toList(),
        'defaultProfileId': _defaultProfileId,
        'presetStats': presetStats,
      };

      await onSave!(jsonEncode(data));
    } catch (e) {
      // Ignore save errors
    }
  }

  /// Clears all user profiles
  void clearUserProfiles() {
    _userProfiles.clear();
    _defaultProfileId = null;
    _saveProfiles();
  }

  /// Exports profiles to JSON
  String exportProfiles() {
    return jsonEncode(_userProfiles.map((p) => p.toJson()).toList());
  }

  /// Imports profiles from JSON
  int importProfiles(String json, {bool replace = false}) {
    try {
      final data = jsonDecode(json) as List<dynamic>;
      if (replace) {
        _userProfiles.clear();
      }

      int imported = 0;
      for (final p in data) {
        final profile = GeniusPrintProfile.fromJson(p as Map<String, dynamic>);
        // Generate new ID to avoid conflicts
        final newProfile = profile.copyWith(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}_$imported',
        );
        _userProfiles.add(newProfile);
        imported++;
      }

      _saveProfiles();
      return imported;
    } catch (e) {
      return 0;
    }
  }

  /// Disposes the manager
  void dispose() {
    _userProfiles.clear();
    _instance = null;
  }
}

/// Extension to add profile management to GeniusPrintSettings
extension GeniusPrintSettingsProfileExtension on GeniusPrintSettings {
  /// Saves this settings as a new profile
  GeniusPrintProfile saveAsProfile({
    required String name,
    String? nameAr,
    String? iconName,
  }) {
    return GeniusPrintSettingsManager.instance.createProfile(
      name: name,
      nameAr: nameAr,
      iconName: iconName,
      settings: this,
    );
  }
}
