import 'dart:io' show Platform;

/// Platform detection and compatibility utilities.
///
/// Provides utilities for detecting the current platform and adapting
/// PDF generation behavior accordingly.
///
/// ## Example
/// ```dart
/// if (PdfPlatform.isWeb) {
///   // Use web-specific rendering
/// } else if (PdfPlatform.isDesktop) {
///   // Use native file system
/// }
///
/// // Platform-specific configuration
/// final config = PdfPlatform.getConfig();
/// ```
class GeniusPdfPlatform {
  GeniusPdfPlatform._();

  static GeniusPlatformType? _platformOverride;

  /// Override the detected platform (useful for testing).
  static void override(GeniusPlatformType platform) {
    _platformOverride = platform;
  }

  /// Reset platform override.
  static void resetOverride() {
    _platformOverride = null;
  }

  /// Current platform type.
  static GeniusPlatformType get current {
    if (_platformOverride != null) return _platformOverride!;
    return _detectPlatform();
  }

  /// Whether running on web.
  static bool get isWeb => current == GeniusPlatformType.web;

  /// Whether running on mobile.
  static bool get isMobile =>
      current == GeniusPlatformType.android || current == GeniusPlatformType.ios;

  /// Whether running on desktop.
  static bool get isDesktop =>
      current == GeniusPlatformType.windows ||
      current == GeniusPlatformType.macos ||
      current == GeniusPlatformType.linux;

  /// Whether running on Android.
  static bool get isAndroid => current == GeniusPlatformType.android;

  /// Whether running on iOS.
  static bool get isIOS => current == GeniusPlatformType.ios;

  /// Whether running on Windows.
  static bool get isWindows => current == GeniusPlatformType.windows;

  /// Whether running on macOS.
  static bool get isMacOS => current == GeniusPlatformType.macos;

  /// Whether running on Linux.
  static bool get isLinux => current == GeniusPlatformType.linux;

  /// Whether file system access is available.
  static bool get hasFileSystem => !isWeb;

  /// Whether native printing is supported.
  static bool get hasNativePrinting => !isWeb;

  /// Whether sharing is supported.
  static bool get hasSharing => isMobile;

  /// Gets platform-specific configuration.
  static GeniusPlatformConfig getConfig() {
    return GeniusPlatformConfig(
      platform: current,
      hasFileSystem: hasFileSystem,
      hasNativePrinting: hasNativePrinting,
      hasSharing: hasSharing,
      defaultSavePath: _getDefaultSavePath(),
      supportedExportFormats: _getSupportedFormats(),
    );
  }

  static GeniusPlatformType _detectPlatform() {
    // Check for web first using conditional import pattern
    // This will be 'true' when compiled for web
    const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');
    if (kIsWeb) return GeniusPlatformType.web;

    try {
      if (Platform.isAndroid) return GeniusPlatformType.android;
      if (Platform.isIOS) return GeniusPlatformType.ios;
      if (Platform.isWindows) return GeniusPlatformType.windows;
      if (Platform.isMacOS) return GeniusPlatformType.macos;
      if (Platform.isLinux) return GeniusPlatformType.linux;
    } catch (_) {
      // Platform not available (likely web)
      return GeniusPlatformType.web;
    }

    return GeniusPlatformType.unknown;
  }

  static String? _getDefaultSavePath() {
    if (isWeb) return null;

    try {
      if (isAndroid) {
        return '/storage/emulated/0/Download';
      } else if (isIOS) {
        return null; // Use documents directory
      } else if (isWindows) {
        final userProfile = Platform.environment['USERPROFILE'];
        return userProfile != null ? '$userProfile\\Downloads' : null;
      } else if (isMacOS || isLinux) {
        final home = Platform.environment['HOME'];
        return home != null ? '$home/Downloads' : null;
      }
    } catch (_) {
      return null;
    }

    return null;
  }

  static List<String> _getSupportedFormats() {
    if (isWeb) {
      return ['pdf', 'png', 'jpg'];
    }
    return ['pdf', 'png', 'jpg', 'svg', 'html', 'txt'];
  }
}

/// Platform types.
enum GeniusPlatformType {
  android,
  ios,
  windows,
  macos,
  linux,
  web,
  unknown,
}

/// Platform-specific configuration.
class GeniusPlatformConfig {
  const GeniusPlatformConfig({
    required this.platform,
    required this.hasFileSystem,
    required this.hasNativePrinting,
    required this.hasSharing,
    this.defaultSavePath,
    this.supportedExportFormats = const ['pdf'],
  });

  final GeniusPlatformType platform;
  final bool hasFileSystem;
  final bool hasNativePrinting;
  final bool hasSharing;
  final String? defaultSavePath;
  final List<String> supportedExportFormats;

  bool supportsFormat(String format) =>
      supportedExportFormats.contains(format.toLowerCase());

  @override
  String toString() => 'PlatformConfig($platform)';
}

// ============================================================================
// Platform-Specific Adapters
// ============================================================================

/// Abstract adapter for platform-specific file operations.
abstract class GeniusPlatformFileAdapter {
  /// Saves bytes to a file.
  Future<String> saveFile(
    List<int> bytes,
    String fileName, {
    String? directory,
    String? mimeType,
  });

  /// Opens a file with the default application.
  Future<bool> openFile(String filePath);

  /// Shares a file.
  Future<bool> shareFile(
    String filePath, {
    String? subject,
    String? text,
  });

  /// Gets the documents directory.
  Future<String> getDocumentsDirectory();

  /// Gets the temporary directory.
  Future<String> getTemporaryDirectory();

  /// Checks if a file exists.
  Future<bool> fileExists(String path);

  /// Deletes a file.
  Future<bool> deleteFile(String path);
}

/// Mobile-specific file adapter.
class GeniusMobileFileAdapter implements GeniusPlatformFileAdapter {
  @override
  Future<String> saveFile(
    List<int> bytes,
    String fileName, {
    String? directory,
    String? mimeType,
  }) async {
    // Implementation would use path_provider and file operations
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<bool> openFile(String filePath) async {
    // Implementation would use open_file or url_launcher
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<bool> shareFile(
    String filePath, {
    String? subject,
    String? text,
  }) async {
    // Implementation would use share_plus
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<String> getDocumentsDirectory() async {
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<String> getTemporaryDirectory() async {
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<bool> fileExists(String path) async {
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<bool> deleteFile(String path) async {
    throw UnimplementedError('Use platform-specific implementation');
  }
}

/// Desktop-specific file adapter.
class GeniusDesktopFileAdapter implements GeniusPlatformFileAdapter {
  @override
  Future<String> saveFile(
    List<int> bytes,
    String fileName, {
    String? directory,
    String? mimeType,
  }) async {
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<bool> openFile(String filePath) async {
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<bool> shareFile(
    String filePath, {
    String? subject,
    String? text,
  }) async {
    // Desktop typically doesn't have built-in sharing
    return false;
  }

  @override
  Future<String> getDocumentsDirectory() async {
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<String> getTemporaryDirectory() async {
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<bool> fileExists(String path) async {
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<bool> deleteFile(String path) async {
    throw UnimplementedError('Use platform-specific implementation');
  }
}

/// Web-specific file adapter.
class GeniusWebFileAdapter implements GeniusPlatformFileAdapter {
  @override
  Future<String> saveFile(
    List<int> bytes,
    String fileName, {
    String? directory,
    String? mimeType,
  }) async {
    // Implementation would use html.AnchorElement for download
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<bool> openFile(String filePath) async {
    // Web can't open local files
    return false;
  }

  @override
  Future<bool> shareFile(
    String filePath, {
    String? subject,
    String? text,
  }) async {
    // Implementation would use Web Share API
    throw UnimplementedError('Use platform-specific implementation');
  }

  @override
  Future<String> getDocumentsDirectory() async {
    // Web doesn't have file system access
    throw UnsupportedError('Web platform does not support file system');
  }

  @override
  Future<String> getTemporaryDirectory() async {
    throw UnsupportedError('Web platform does not support file system');
  }

  @override
  Future<bool> fileExists(String path) async {
    return false;
  }

  @override
  Future<bool> deleteFile(String path) async {
    return false;
  }
}

// ============================================================================
// Feature Detection
// ============================================================================

/// Detects available features based on platform and dependencies.
class GeniusFeatureDetector {
  GeniusFeatureDetector._();

  static final Map<String, bool> _features = {};

  /// Registers a feature as available.
  static void register(String feature, bool available) {
    _features[feature] = available;
  }

  /// Checks if a feature is available.
  static bool isAvailable(String feature) {
    return _features[feature] ?? false;
  }

  /// Gets all available features.
  static List<String> get availableFeatures {
    return _features.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();
  }

  /// Standard feature names.
  static const String printing = 'printing';
  static const String fileSystem = 'file_system';
  static const String sharing = 'sharing';
  static const String imageExport = 'image_export';
  static const String htmlExport = 'html_export';
  static const String encryption = 'encryption';
  static const String digitalSignature = 'digital_signature';
  static const String watermark = 'watermark';
  static const String compression = 'compression';
  static const String annotations = 'annotations';
}

/// Mixin for platform-aware classes.
mixin GeniusPlatformAware {
  GeniusPlatformType get platform => GeniusPdfPlatform.current;
  GeniusPlatformConfig get platformConfig => GeniusPdfPlatform.getConfig();

  bool get isWeb => GeniusPdfPlatform.isWeb;
  bool get isMobile => GeniusPdfPlatform.isMobile;
  bool get isDesktop => GeniusPdfPlatform.isDesktop;
}
