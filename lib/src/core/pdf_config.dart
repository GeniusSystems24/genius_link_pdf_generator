import 'dart:async';

import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/src/core/pdf_assets.dart';
import 'package:genius_link_pdf_generator/src/core/pdf_logger.dart';
import 'package:genius_link_pdf_generator/src/core/pdf_print_theme.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Configuration for PDF document settings.
///
/// This class holds all the configuration options for creating PDF documents
/// including fonts, margins, page size, orientation, text direction, assets, and logging.
///
/// Each [GeniusPdfDocumentBuilder] must have its own [GeniusPdfConfig] instance.
/// There is no global singleton - each document builder manages its own configuration.
///
/// ## Creating a Config Instance
///
/// Use the async factory method to create a config with assets:
/// ```dart
/// final config = await GeniusPdfConfig.create(
///   baseFont: PdfTrueTypeFont(fontData, 12),
///   boldFont: PdfTrueTypeFont(boldFontData, 12),
///   textDirection: TextDirection.rtl,
///   assetPaths: GeniusPdfAssetPaths(
///     fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din.ttf'),
///     brandingPaths: GeniusPdfBrandingPaths(logo: 'assets/images/logo.png'),
///   ),
///   loggerConfig: GeniusPdfLoggerConfig(
///     enabled: true,
///     minLevel: GeniusLogLevel.info,
///     useConsole: true,
///   ),
/// );
///
/// // Access assets through the config instance
/// final primaryFont = config.assets.primaryFont;
/// final logo = config.assets.logo;
///
/// // Use the config with a document builder
/// final builder = MyDocumentBuilder(config);
/// ```
///
/// ## Direct Constructor Usage
/// ```dart
/// final config = GeniusPdfConfig(
///   baseFont: PdfTrueTypeFont(fontData, 12),
///   boldFont: PdfTrueTypeFont(boldFontData, 12),
///   pageSize: GeniusPdfPageSize.a4,
///   orientation: PdfPageOrientation.portrait,
///   textDirection: TextDirection.rtl,
///   margins: PdfMargins()..all = 20,
///   configAssets: myLoadedAssets,
/// );
/// ```
class GeniusPdfConfig {
  // ==================== Constructor ====================

  /// Creates a new [GeniusPdfConfig] instance.
  ///
  /// ## Parameters
  /// - [baseFont]: The primary font for the document (required).
  /// - [boldFont]: Bold version of the font (optional, falls back to baseFont).
  /// - [headerFont]: Font for headers/titles (optional, falls back to boldFont or baseFont).
  /// - [smallFont]: Smaller font for captions (optional, falls back to baseFont).
  /// - [pageSize]: Page dimensions (defaults to A4).
  /// - [orientation]: Page orientation (defaults to portrait).
  /// - [textDirection]: Text direction (defaults to RTL).
  /// - [margins]: Page margins (defaults to 20 on all sides).
  /// - [compressionLevel]: PDF compression level.
  /// - [configAssets]: Optional assets (fonts, images) for this config.
  GeniusPdfConfig({
    required this.baseFont,
    PdfFont? boldFont,
    PdfFont? headerFont,
    PdfFont? smallFont,
    this.pageSize = GeniusPdfPageSize.a4,
    this.orientation = PdfPageOrientation.portrait,
    this.textDirection = TextDirection.rtl,
    PdfMargins? margins,
    PdfLayoutFormat? layoutFormat,
    this.compressionLevel = PdfCompressionLevel.bestSpeed,
    this.defaultOutputPath,
    this.configAssets,
    GeniusPdfPrintTheme? printTheme,
  })  : boldFont = boldFont ?? baseFont,
        headerFont = headerFont ?? boldFont ?? baseFont,
        smallFont = smallFont ?? baseFont,
        margins = margins ?? (PdfMargins()..all = 20),
        layoutFormat = layoutFormat ??
            PdfLayoutFormat(
              layoutType: PdfLayoutType.paginate,
              breakType: PdfLayoutBreakType.fitPage,
            ),
        printTheme = printTheme ?? GeniusPdfPrintTheme.defaults();

  // ==================== Assets Access ====================

  /// Returns the assets for this config instance.
  ///
  /// Throws [StateError] if assets haven't been configured.
  ///
  /// ## Example
  /// ```dart
  /// final primaryFont = config.assets.primaryFont;
  /// final logo = config.assets.logo;
  /// ```
  GeniusPdfAssets get assets {
    if (configAssets == null) {
      throw StateError(
        'Assets not configured for this GeniusPdfConfig instance. '
        'Use GeniusPdfConfig.create() with assetPaths or provide configAssets in constructor.',
      );
    }
    return configAssets!;
  }

  /// Returns the assets or null if not configured.
  GeniusPdfAssets? get assetsOrNull => configAssets;

  /// Whether assets have been configured for this instance.
  bool get hasAssets => configAssets != null;

  // ==================== Logger Access ====================

  /// Returns the logger instance for logging operations.
  ///
  /// Note: Logger is a global service shared across all config instances.
  ///
  /// ## Example
  /// ```dart
  /// GeniusPdfConfig.logger.debug('Starting PDF generation');
  /// GeniusPdfConfig.logger.info('PDF generated successfully');
  /// GeniusPdfConfig.logger.error('Failed to generate PDF', error: e);
  /// ```
  static GeniusPdfLoggerAccess get logger => GeniusPdfLoggerAccess();

  // ==================== Factory Methods ====================

  /// Creates a new [GeniusPdfConfig] instance with optional asset loading.
  ///
  /// This factory method loads assets asynchronously if paths are provided.
  /// Each call creates a new independent config instance.
  ///
  /// ## Example
  /// ```dart
  /// final config = await GeniusPdfConfig.create(
  ///   baseFont: PdfTrueTypeFont(fontData, 12),
  ///   boldFont: PdfTrueTypeFont(boldFontData, 12),
  ///   textDirection: TextDirection.rtl,
  ///   assetPaths: GeniusPdfAssetPaths(
  ///     fontPaths: GeniusPdfFontPaths(primaryFont: 'assets/fonts/din.ttf'),
  ///   ),
  ///   loggerConfig: GeniusPdfLoggerConfig(enabled: true, useConsole: true),
  /// );
  ///
  /// // Use with a document builder
  /// final builder = MyDocumentBuilder(config);
  /// ```
  static Future<GeniusPdfConfig> create({
    required PdfFont baseFont,
    PdfFont? boldFont,
    PdfFont? headerFont,
    PdfFont? smallFont,
    Size pageSize = GeniusPdfPageSize.a4,
    PdfPageOrientation orientation = PdfPageOrientation.portrait,
    TextDirection textDirection = TextDirection.rtl,
    PdfMargins? margins,
    PdfLayoutFormat? layoutFormat,
    PdfCompressionLevel compressionLevel = PdfCompressionLevel.bestSpeed,
    String? defaultOutputPath,
    // Assets configuration
    GeniusPdfAssetPaths? assetPaths,
    GeniusPdfAssetsData? assetData,
    AssetBundle? assetBundle,
    // Logger configuration
    GeniusPdfLoggerConfig? loggerConfig,
    // Print theme configuration
    GeniusPdfPrintTheme? printTheme,
  }) async {
    // Load assets if provided
    GeniusPdfAssets? loadedAssets;
    if (assetPaths != null) {
      loadedAssets = await GeniusPdfAssets.loadFromPaths(
        fontPaths: assetPaths.fontPaths,
        brandingPaths: assetPaths.brandingPaths,
        bundle: assetBundle,
      );
    } else if (assetData != null) {
      loadedAssets = GeniusPdfAssets(
        primaryFont: assetData.primaryFont,
        secondaryFont: assetData.secondaryFont,
        headerImage: assetData.headerImage,
        logo: assetData.logo,
        squareLogo: assetData.squareLogo,
        backgroundImage: assetData.backgroundImage,
        labelImage: assetData.labelImage,
      );
    }

    // Configure logger if provided (logger is a global service)
    if (loggerConfig != null) {
      GeniusPdfLogger.configureFrom(loggerConfig);
    }

    // Create and return new config instance
    return GeniusPdfConfig(
      baseFont: baseFont,
      boldFont: boldFont,
      headerFont: headerFont,
      smallFont: smallFont,
      pageSize: pageSize,
      orientation: orientation,
      textDirection: textDirection,
      margins: margins,
      layoutFormat: layoutFormat,
      compressionLevel: compressionLevel,
      defaultOutputPath: defaultOutputPath,
      configAssets: loadedAssets,
      printTheme: printTheme,
    );
  }

  /// Creates a new [GeniusPdfConfig] instance synchronously.
  ///
  /// Use this when you don't need to load assets from the asset bundle,
  /// or when assets are already loaded.
  static GeniusPdfConfig createSync({
    required PdfFont baseFont,
    PdfFont? boldFont,
    PdfFont? headerFont,
    PdfFont? smallFont,
    Size pageSize = GeniusPdfPageSize.a4,
    PdfPageOrientation orientation = PdfPageOrientation.portrait,
    TextDirection textDirection = TextDirection.rtl,
    PdfMargins? margins,
    PdfLayoutFormat? layoutFormat,
    PdfCompressionLevel compressionLevel = PdfCompressionLevel.bestSpeed,
    String? defaultOutputPath,
    // Assets data (already loaded)
    GeniusPdfAssetsData? assetData,
    // Logger configuration
    GeniusPdfLoggerConfig? loggerConfig,
    // Print theme configuration
    GeniusPdfPrintTheme? printTheme,
  }) {
    // Build assets if provided
    GeniusPdfAssets? loadedAssets;
    if (assetData != null) {
      loadedAssets = GeniusPdfAssets(
        primaryFont: assetData.primaryFont,
        secondaryFont: assetData.secondaryFont,
        headerImage: assetData.headerImage,
        logo: assetData.logo,
        squareLogo: assetData.squareLogo,
        backgroundImage: assetData.backgroundImage,
        labelImage: assetData.labelImage,
      );
    }

    // Configure logger if provided (logger is a global service)
    if (loggerConfig != null) {
      GeniusPdfLogger.configureFrom(loggerConfig);
    }

    // Create and return new config instance
    return GeniusPdfConfig(
      baseFont: baseFont,
      boldFont: boldFont,
      headerFont: headerFont,
      smallFont: smallFont,
      pageSize: pageSize,
      orientation: orientation,
      textDirection: textDirection,
      margins: margins,
      layoutFormat: layoutFormat,
      compressionLevel: compressionLevel,
      defaultOutputPath: defaultOutputPath,
      configAssets: loadedAssets,
      printTheme: printTheme,
    );
  }

  /// Builds a PdfFont from the config's assets.
  ///
  /// ## Parameters
  /// - [fontSize]: The font size to use (defaults to 18).
  ///
  /// Returns baseFont if no assets are configured.
  PdfFont fontBuild({double fontSize = 18}) {
    return configAssets == null
        ? baseFont
        : PdfTrueTypeFont(configAssets!.primaryFont.toList(), fontSize);
  }

  /// The base font used throughout the PDF document.
  /// This font must support all characters used in the document (including Arabic if needed).
  final PdfFont baseFont;

  /// Bold version of the base font.
  /// Used for headers, titles, and emphasized text.
  /// Falls back to [baseFont] if not provided.
  final PdfFont boldFont;

  /// Font for headers and titles.
  /// Falls back to [boldFont] or [baseFont] if not provided.
  final PdfFont headerFont;

  /// Smaller font for captions and footnotes.
  /// Falls back to [baseFont] if not provided.
  final PdfFont smallFont;

  /// Page size for the PDF document.
  ///
  /// Defaults to A4 size if not specified.
  final Size pageSize;

  /// Page orientation for the PDF document.
  ///
  /// Defaults to [PdfPageOrientation.portrait].
  final PdfPageOrientation orientation;

  /// Text direction for the document.
  ///
  /// Use [TextDirection.rtl] for Arabic/Hebrew text.
  final TextDirection textDirection;

  /// Page margins for the PDF document.
  final PdfMargins margins;

  /// Layout format for flowing content across pages.
  final PdfLayoutFormat layoutFormat;

  /// Compression level for the PDF.
  final PdfCompressionLevel compressionLevel;

  /// Default output path for generated PDF files.
  ///
  /// If not specified, files will be saved to the application's documents directory.
  final String? defaultOutputPath;

  /// The assets (fonts, images) associated with this config.
  ///
  /// This allows each config instance to have its own set of assets.
  final GeniusPdfAssets? configAssets;

  /// The print theme for styling PDF components.
  ///
  /// This provides centralized theming for all PDF components including
  /// colors, typography, spacing, borders, and component-specific styles.
  ///
  /// ## Example
  /// ```dart
  /// final config = GeniusPdfConfig(
  ///   baseFont: myFont,
  ///   printTheme: GeniusPdfPrintTheme.corporate(
  ///     primaryColor: Color(0xFF1565C0),
  ///   ),
  /// );
  /// ```
  final GeniusPdfPrintTheme printTheme;

  /// Whether the document uses Left-to-Right text direction.
  bool get isLTR => textDirection == TextDirection.ltr;

  /// Whether the document uses Right-to-Left text direction.
  bool get isRTL => textDirection == TextDirection.rtl;

  /// Creates a copy of this config with the given fields replaced.
  GeniusPdfConfig copyWith({
    PdfFont? baseFont,
    PdfFont? boldFont,
    PdfFont? headerFont,
    PdfFont? smallFont,
    Size? pageSize,
    PdfPageOrientation? orientation,
    TextDirection? textDirection,
    PdfMargins? margins,
    PdfLayoutFormat? layoutFormat,
    PdfCompressionLevel? compressionLevel,
    String? defaultOutputPath,
    GeniusPdfAssets? configAssets,
    GeniusPdfPrintTheme? printTheme,
  }) {
    return GeniusPdfConfig(
      baseFont: baseFont ?? this.baseFont,
      boldFont: boldFont ?? this.boldFont,
      headerFont: headerFont ?? this.headerFont,
      smallFont: smallFont ?? this.smallFont,
      pageSize: pageSize ?? this.pageSize,
      orientation: orientation ?? this.orientation,
      textDirection: textDirection ?? this.textDirection,
      margins: margins ?? this.margins,
      layoutFormat: layoutFormat ?? this.layoutFormat,
      compressionLevel: compressionLevel ?? this.compressionLevel,
      defaultOutputPath: defaultOutputPath ?? this.defaultOutputPath,
      configAssets: configAssets ?? this.configAssets,
      printTheme: printTheme ?? this.printTheme,
    );
  }
}

/// Pre-configured page sizes for common use cases.
///
/// Named `AppPdfPageSize` to avoid conflicts with Syncfusion's `PdfPageSize`.
class GeniusPdfPageSize {
  GeniusPdfPageSize._();

  /// A4 page size (210 x 297 mm)
  static const Size a4 = Size(595, 842);

  /// A3 page size (297 x 420 mm)
  static const Size a3 = Size(842, 1191);

  /// Letter page size (8.5 x 11 inches)
  static const Size letter = Size(612, 792);

  /// Legal page size (8.5 x 14 inches)
  static const Size legal = Size(612, 1008);
}
