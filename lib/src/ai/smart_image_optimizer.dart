import 'dart:typed_data';
import 'dart:ui' as ui;

/// Result of image optimization.
class GeniusImageOptimizationResult {
  const GeniusImageOptimizationResult({
    required this.optimizedBytes,
    required this.originalSize,
    required this.optimizedSize,
    required this.compressionRatio,
    required this.suggestedWidth,
    required this.suggestedHeight,
    this.warnings = const [],
  });

  /// The optimized image bytes.
  final Uint8List optimizedBytes;

  /// Original file size in bytes.
  final int originalSize;

  /// Optimized file size in bytes.
  final int optimizedSize;

  /// Compression ratio achieved (0-1).
  final double compressionRatio;

  /// Suggested width for the image in the PDF.
  final double suggestedWidth;

  /// Suggested height for the image in the PDF.
  final double suggestedHeight;

  /// Any warnings generated during optimization.
  final List<String> warnings;

  /// Savings in bytes.
  int get savedBytes => originalSize - optimizedSize;

  /// Savings percentage.
  double get savingsPercentage => (savedBytes / originalSize) * 100;

  Map<String, dynamic> toJson() => {
        'originalSize': originalSize,
        'optimizedSize': optimizedSize,
        'compressionRatio': compressionRatio,
        'suggestedWidth': suggestedWidth,
        'suggestedHeight': suggestedHeight,
        'savedBytes': savedBytes,
        'savingsPercentage': savingsPercentage,
        'warnings': warnings,
      };
}

/// Image analysis result.
class GeniusImageAnalysis {
  const GeniusImageAnalysis({
    required this.width,
    required this.height,
    required this.aspectRatio,
    required this.estimatedQuality,
    required this.recommendations,
  });

  /// Image width in pixels.
  final int width;

  /// Image height in pixels.
  final int height;

  /// Aspect ratio (width/height).
  final double aspectRatio;

  /// Estimated quality (0-1).
  final double estimatedQuality;

  /// Recommendations for optimization.
  final List<GeniusImageRecommendation> recommendations;

  Map<String, dynamic> toJson() => {
        'width': width,
        'height': height,
        'aspectRatio': aspectRatio,
        'estimatedQuality': estimatedQuality,
        'recommendations': recommendations.map((r) => r.toJson()).toList(),
      };
}

/// A recommendation for image optimization.
class GeniusImageRecommendation {
  const GeniusImageRecommendation({
    required this.type,
    required this.description,
    required this.descriptionAr,
    this.priority = GeniusRecommendationPriority.medium,
    this.parameters = const {},
  });

  /// Type of recommendation.
  final GeniusImageRecommendationType type;

  /// Description in English.
  final String description;

  /// Description in Arabic.
  final String descriptionAr;

  /// Priority level.
  final GeniusRecommendationPriority priority;

  /// Additional parameters.
  final Map<String, dynamic> parameters;

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'description': description,
        'descriptionAr': descriptionAr,
        'priority': priority.name,
        'parameters': parameters,
      };
}

/// Types of image recommendations.
enum GeniusImageRecommendationType {
  /// Resize the image.
  resize,

  /// Compress the image.
  compress,

  /// Change format.
  changeFormat,

  /// Reduce colors.
  reduceColors,

  /// Crop the image.
  crop,

  /// Increase resolution.
  increaseResolution,

  /// No changes needed.
  noChanges,
}

/// Recommendation priority levels.
enum GeniusRecommendationPriority {
  /// Low priority.
  low,

  /// Medium priority.
  medium,

  /// High priority.
  high,

  /// Critical priority.
  critical,
}

/// Image optimization settings.
class GeniusImageOptimizationSettings {
  const GeniusImageOptimizationSettings({
    this.maxWidth = 1920,
    this.maxHeight = 1080,
    this.targetQuality = 0.85,
    this.preserveAspectRatio = true,
    this.targetFormat,
    this.forPrint = false,
  });

  /// Maximum width in pixels.
  final int maxWidth;

  /// Maximum height in pixels.
  final int maxHeight;

  /// Target quality (0-1).
  final double targetQuality;

  /// Whether to preserve aspect ratio.
  final bool preserveAspectRatio;

  /// Target format (null for auto).
  final String? targetFormat;

  /// Whether optimizing for print.
  final bool forPrint;

  /// Settings optimized for screen viewing.
  static const GeniusImageOptimizationSettings forScreen =
      GeniusImageOptimizationSettings(
    maxWidth: 1920,
    maxHeight: 1080,
    targetQuality: 0.8,
    forPrint: false,
  );

  /// Settings optimized for print.
  static const GeniusImageOptimizationSettings printQuality =
      GeniusImageOptimizationSettings(
    maxWidth: 4096,
    maxHeight: 4096,
    targetQuality: 0.95,
    forPrint: true,
  );

  /// Settings for minimal file size.
  static const GeniusImageOptimizationSettings minimal =
      GeniusImageOptimizationSettings(
    maxWidth: 800,
    maxHeight: 600,
    targetQuality: 0.6,
    forPrint: false,
  );
}

/// Smart image optimizer for PDF documents.
///
/// Provides intelligent image optimization including:
/// - Automatic resizing based on PDF requirements
/// - Smart compression while preserving quality
/// - Format recommendations
/// - Quality analysis
///
/// ## Example
/// ```dart
/// final optimizer = GeniusSmartImageOptimizer();
///
/// // Analyze an image
/// final analysis = await optimizer.analyze(imageBytes);
/// print('Recommendations: ${analysis.recommendations}');
///
/// // Optimize an image
/// final result = await optimizer.optimize(
///   imageBytes,
///   settings: GeniusImageOptimizationSettings.forScreen,
/// );
/// print('Saved ${result.savingsPercentage}%');
/// ```
class GeniusSmartImageOptimizer {
  /// Creates a smart image optimizer.
  GeniusSmartImageOptimizer({
    this.defaultSettings = const GeniusImageOptimizationSettings(),
  });

  /// Default optimization settings.
  final GeniusImageOptimizationSettings defaultSettings;

  /// Analyzes an image and provides recommendations.
  Future<GeniusImageAnalysis> analyze(Uint8List imageBytes) async {
    final recommendations = <GeniusImageRecommendation>[];

    // Decode image to get dimensions
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final width = image.width;
    final height = image.height;
    final aspectRatio = width / height;

    // Estimate quality based on file size and dimensions
    final pixelCount = width * height;
    final bytesPerPixel = imageBytes.length / pixelCount;
    final estimatedQuality =
        (bytesPerPixel / 4).clamp(0.0, 1.0).toDouble();

    // Check if image is too large
    if (width > 4096 || height > 4096) {
      recommendations.add(const GeniusImageRecommendation(
        type: GeniusImageRecommendationType.resize,
        description: 'Image is very large, consider resizing for better performance',
        descriptionAr: 'الصورة كبيرة جداً، يُنصح بتغيير الحجم لأداء أفضل',
        priority: GeniusRecommendationPriority.high,
        parameters: {'maxDimension': 4096},
      ));
    } else if (width > 1920 || height > 1080) {
      recommendations.add(const GeniusImageRecommendation(
        type: GeniusImageRecommendationType.resize,
        description: 'Image exceeds standard screen dimensions',
        descriptionAr: 'الصورة تتجاوز أبعاد الشاشة القياسية',
        priority: GeniusRecommendationPriority.medium,
        parameters: {'maxDimension': 1920},
      ));
    }

    // Check if image is too small
    if (width < 100 || height < 100) {
      recommendations.add(const GeniusImageRecommendation(
        type: GeniusImageRecommendationType.increaseResolution,
        description: 'Image resolution is very low, may appear pixelated',
        descriptionAr: 'دقة الصورة منخفضة جداً، قد تظهر مشوهة',
        priority: GeniusRecommendationPriority.high,
      ));
    }

    // Check file size
    if (imageBytes.length > 5 * 1024 * 1024) {
      // > 5MB
      recommendations.add(const GeniusImageRecommendation(
        type: GeniusImageRecommendationType.compress,
        description: 'File size is large, compression recommended',
        descriptionAr: 'حجم الملف كبير، يُنصح بالضغط',
        priority: GeniusRecommendationPriority.high,
        parameters: {'targetQuality': 0.85},
      ));
    } else if (imageBytes.length > 1 * 1024 * 1024) {
      // > 1MB
      recommendations.add(const GeniusImageRecommendation(
        type: GeniusImageRecommendationType.compress,
        description: 'Consider compression for smaller file size',
        descriptionAr: 'يُنصح بالضغط لحجم ملف أصغر',
        priority: GeniusRecommendationPriority.medium,
        parameters: {'targetQuality': 0.9},
      ));
    }

    // If no issues found
    if (recommendations.isEmpty) {
      recommendations.add(const GeniusImageRecommendation(
        type: GeniusImageRecommendationType.noChanges,
        description: 'Image is already optimized',
        descriptionAr: 'الصورة محسّنة بالفعل',
        priority: GeniusRecommendationPriority.low,
      ));
    }

    image.dispose();
    codec.dispose();

    return GeniusImageAnalysis(
      width: width,
      height: height,
      aspectRatio: aspectRatio,
      estimatedQuality: estimatedQuality,
      recommendations: recommendations,
    );
  }

  /// Optimizes an image for PDF inclusion.
  ///
  /// Note: Full optimization requires platform-specific image processing.
  /// This method provides size recommendations and basic optimization.
  Future<GeniusImageOptimizationResult> optimize(
    Uint8List imageBytes, {
    GeniusImageOptimizationSettings? settings,
  }) async {
    final effectiveSettings = settings ?? defaultSettings;
    final warnings = <String>[];

    // Decode image
    final codec = await ui.instantiateImageCodec(imageBytes);
    final frame = await codec.getNextFrame();
    final image = frame.image;

    final originalWidth = image.width;
    final originalHeight = image.height;

    // Calculate target dimensions
    double targetWidth = originalWidth.toDouble();
    double targetHeight = originalHeight.toDouble();

    if (originalWidth > effectiveSettings.maxWidth) {
      targetWidth = effectiveSettings.maxWidth.toDouble();
      if (effectiveSettings.preserveAspectRatio) {
        targetHeight = (originalHeight * targetWidth / originalWidth);
      }
    }

    if (targetHeight > effectiveSettings.maxHeight) {
      targetHeight = effectiveSettings.maxHeight.toDouble();
      if (effectiveSettings.preserveAspectRatio) {
        targetWidth = (originalWidth * targetHeight / originalHeight);
      }
    }

    // For print optimization
    double suggestedPdfWidth = targetWidth;
    double suggestedPdfHeight = targetHeight;

    if (effectiveSettings.forPrint) {
      // For print, use 300 DPI
      suggestedPdfWidth = targetWidth / 300 * 72; // Convert to points
      suggestedPdfHeight = targetHeight / 300 * 72;
    } else {
      // For screen, use 72 DPI
      suggestedPdfWidth = targetWidth / 72 * 72;
      suggestedPdfHeight = targetHeight / 72 * 72;
    }

    // Note: Actual image recompression would require platform-specific code
    // For now, we return the original bytes with calculated suggestions
    warnings.add('Full image recompression requires platform-specific implementation');

    image.dispose();
    codec.dispose();

    return GeniusImageOptimizationResult(
      optimizedBytes: imageBytes,
      originalSize: imageBytes.length,
      optimizedSize: imageBytes.length,
      compressionRatio: 0,
      suggestedWidth: suggestedPdfWidth,
      suggestedHeight: suggestedPdfHeight,
      warnings: warnings,
    );
  }

  /// Calculates the optimal size for an image in a PDF.
  ui.Size calculateOptimalSize({
    required int imageWidth,
    required int imageHeight,
    required double maxPdfWidth,
    required double maxPdfHeight,
    bool preserveAspectRatio = true,
  }) {
    final aspectRatio = imageWidth / imageHeight;

    double targetWidth = maxPdfWidth;
    double targetHeight = maxPdfHeight;

    if (preserveAspectRatio) {
      if (maxPdfWidth / maxPdfHeight > aspectRatio) {
        // Height is the constraint
        targetWidth = maxPdfHeight * aspectRatio;
        targetHeight = maxPdfHeight;
      } else {
        // Width is the constraint
        targetWidth = maxPdfWidth;
        targetHeight = maxPdfWidth / aspectRatio;
      }
    }

    return ui.Size(targetWidth, targetHeight);
  }

  /// Suggests the best image format for the given use case.
  String suggestFormat({
    required bool hasTransparency,
    required bool isPhoto,
    required bool forPrint,
  }) {
    if (hasTransparency) {
      return 'PNG';
    }

    if (isPhoto) {
      return forPrint ? 'TIFF' : 'JPEG';
    }

    return 'PNG';
  }
}
