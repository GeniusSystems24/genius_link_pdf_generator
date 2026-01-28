/// PDF Assets Management
///
/// Assets (fonts, images) are managed through [GeniusPdfConfig].
/// Each config instance has its own assets accessed via [GeniusPdfConfig.assets].
///
/// ## Usage
/// ```dart
/// // Create config with assets
/// final config = await GeniusPdfConfig.create(
///   baseFont: myFont,
///   assetPaths: GeniusPdfAssetPaths(
///     fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din.ttf'),
///   ),
/// );
///
/// // Access assets through the config instance
/// final font = config.assets.primaryFont;
/// final logo = config.assets.logo;
/// ```
///
/// @see [GeniusPdfConfig] for configuration management.
library;

import 'dart:async';

import 'package:flutter/services.dart';

// ==================== Assets Configuration Classes ====================

/// Combined paths configuration for all PDF assets.
class GeniusPdfAssetPaths {
  /// Creates a combined asset paths configuration.
  const GeniusPdfAssetPaths({
    required this.fontPaths,
    this.brandingPaths,
  });

  /// Paths to font assets.
  final GeniusPdfFontPaths fontPaths;

  /// Paths to branding assets (optional).
  final GeniusPdfBrandingPaths? brandingPaths;
}

/// Raw asset data for PDF generation (pre-loaded).
class GeniusPdfAssetsData {
  /// Creates asset data configuration.
  const GeniusPdfAssetsData({
    required this.primaryFont,
    this.secondaryFont,
    this.headerImage,
    this.logo,
    this.squareLogo,
    this.backgroundImage,
    this.labelImage,
  });

  /// Primary font data.
  final Uint8List primaryFont;

  /// Secondary font data.
  final Uint8List? secondaryFont;

  /// Header image data.
  final Uint8List? headerImage;

  /// Logo data.
  final Uint8List? logo;

  /// Square logo data.
  final Uint8List? squareLogo;

  /// Background image data.
  final Uint8List? backgroundImage;

  /// Label image data.
  final Uint8List? labelImage;
}

// ==================== Assets Classes ====================

/// Manages PDF assets including fonts and images.
///
/// This class provides a centralized way to store assets
/// required for PDF generation such as fonts and company branding.
///
/// Assets should be accessed through [GeniusPdfConfig.assets] for the
/// config instance being used.
///
/// ## Example
/// ```dart
/// // Create config with assets
/// final config = await GeniusPdfConfig.create(
///   baseFont: myFont,
///   assetPaths: GeniusPdfAssetPaths(
///     fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din.ttf'),
///   ),
/// );
///
/// // Access through config instance
/// final font = config.assets.primaryFont;
/// final header = config.assets.headerImage;
/// ```
class GeniusPdfAssets {
  /// Creates a new [GeniusPdfAssets] instance with the given data.
  const GeniusPdfAssets({
    required this.primaryFont,
    this.secondaryFont,
    this.headerImage,
    this.logo,
    this.squareLogo,
    this.backgroundImage,
    this.labelImage,
  });

  /// Primary font data.
  final Uint8List primaryFont;

  /// Secondary font data (optional).
  final Uint8List? secondaryFont;

  /// Header image data.
  final Uint8List? headerImage;

  /// Company logo data.
  final Uint8List? logo;

  /// Square logo data for compact displays.
  final Uint8List? squareLogo;

  /// Background image data.
  final Uint8List? backgroundImage;

  /// Label image data.
  final Uint8List? labelImage;

  /// Loads assets from asset bundle paths.
  ///
  /// This is a factory method that loads assets asynchronously.
  ///
  /// ## Example
  /// ```dart
  /// final assets = await GeniusPdfAssets.loadFromPaths(
  ///   fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din.ttf'),
  ///   brandingPaths: GeniusPdfBrandingPaths(logo: 'assets/images/logo.png'),
  /// );
  /// ```
  static Future<GeniusPdfAssets> loadFromPaths({
    required GeniusPdfFontPaths fontPaths,
    GeniusPdfBrandingPaths? brandingPaths,
    AssetBundle? bundle,
  }) async {
    final assetBundle = bundle ?? rootBundle;

    final primaryFont = await _loadAsset(assetBundle, fontPaths.primaryFont);
    final secondaryFont = fontPaths.secondaryFont != null
        ? await _loadAssetOptional(assetBundle, fontPaths.secondaryFont!)
        : null;

    Uint8List? headerImage;
    Uint8List? logo;
    Uint8List? squareLogo;
    Uint8List? backgroundImage;
    Uint8List? labelImage;

    if (brandingPaths != null) {
      headerImage = await _loadAssetOptional(
        assetBundle,
        brandingPaths.headerImage,
      );
      logo = await _loadAssetOptional(assetBundle, brandingPaths.logo);
      squareLogo = await _loadAssetOptional(
        assetBundle,
        brandingPaths.squareLogo,
      );
      backgroundImage = await _loadAssetOptional(
        assetBundle,
        brandingPaths.backgroundImage,
      );
      labelImage = await _loadAssetOptional(
        assetBundle,
        brandingPaths.labelImage,
      );
    }

    return GeniusPdfAssets(
      primaryFont: primaryFont,
      secondaryFont: secondaryFont,
      headerImage: headerImage,
      logo: logo,
      squareLogo: squareLogo,
      backgroundImage: backgroundImage,
      labelImage: labelImage,
    );
  }

  static Future<Uint8List> _loadAsset(
    AssetBundle bundle,
    String path,
  ) async {
    final data = await bundle.load(path);
    return data.buffer.asUint8List();
  }

  static Future<Uint8List?> _loadAssetOptional(
    AssetBundle bundle,
    String? path,
  ) async {
    if (path == null) return null;
    try {
      return await _loadAsset(bundle, path);
    } catch (_) {
      return null;
    }
  }
}

/// Paths to font assets for PDF generation.
class GeniusPdfFontPaths {
  /// Creates font path configuration.
  const GeniusPdfFontPaths({
    required this.primaryFont,
    this.secondaryFont,
  });

  /// Path to the primary font asset.
  final String primaryFont;

  /// Path to the secondary font asset (optional).
  final String? secondaryFont;
}

/// Paths to branding assets for PDF generation.
class GeniusPdfBrandingPaths {
  /// Creates branding path configuration.
  const GeniusPdfBrandingPaths({
    this.headerImage,
    this.logo,
    this.squareLogo,
    this.backgroundImage,
    this.labelImage,
  });

  /// Path to the header image asset.
  final String? headerImage;

  /// Path to the logo asset.
  final String? logo;

  /// Path to the square logo asset.
  final String? squareLogo;

  /// Path to the background image asset.
  final String? backgroundImage;

  /// Path to the label image asset.
  final String? labelImage;
}
