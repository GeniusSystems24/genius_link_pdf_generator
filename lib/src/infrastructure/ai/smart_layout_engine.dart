import 'dart:math' as math;
import 'dart:ui';

import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Layout suggestion from the smart layout engine.
class GeniusLayoutSuggestion {
  const GeniusLayoutSuggestion({
    required this.type,
    required this.description,
    required this.descriptionAr,
    this.confidence = 0.0,
    this.parameters = const {},
  });

  /// Type of the suggestion.
  final GeniusSuggestionType type;

  /// Description of the suggestion in English.
  final String description;

  /// Description of the suggestion in Arabic.
  final String descriptionAr;

  /// Confidence level (0.0 to 1.0).
  final double confidence;

  /// Additional parameters for applying the suggestion.
  final Map<String, dynamic> parameters;

  /// Gets the description based on RTL setting.
  String getDescription(bool isRtl) => isRtl ? descriptionAr : description;

  Map<String, dynamic> toJson() => {
        'type': type.name,
        'description': description,
        'descriptionAr': descriptionAr,
        'confidence': confidence,
        'parameters': parameters,
      };
}

/// Types of layout suggestions.
enum GeniusSuggestionType {
  /// Adjust margins.
  margins,

  /// Change font size.
  fontSize,

  /// Adjust spacing.
  spacing,

  /// Change column layout.
  columns,

  /// Adjust alignment.
  alignment,

  /// Add page break.
  pageBreak,

  /// Resize element.
  resize,

  /// Reorder elements.
  reorder,

  /// Add header/footer.
  headerFooter,

  /// Change color scheme.
  colorScheme,

  /// Optimize for print.
  printOptimization,

  /// Optimize for screen.
  screenOptimization,
}

/// Content element for layout analysis.
class GeniusLayoutElement {
  const GeniusLayoutElement({
    required this.type,
    required this.bounds,
    this.content,
    this.priority = 0,
    this.isRtl = false,
  });

  /// Type of the element.
  final GeniusLayoutElementType type;

  /// Bounds of the element.
  final Rect bounds;

  /// Content of the element (text, data, etc.).
  final dynamic content;

  /// Priority for layout (higher = more important).
  final int priority;

  /// Whether the element uses RTL.
  final bool isRtl;
}

/// Types of layout elements.
enum GeniusLayoutElementType {
  /// Header text.
  header,

  /// Subheader text.
  subheader,

  /// Body text/paragraph.
  paragraph,

  /// Data table.
  table,

  /// Image.
  image,

  /// List (bulleted or numbered).
  list,

  /// Spacer/divider.
  spacer,

  /// Summary section.
  summary,

  /// Footer.
  footer,
}

/// Smart layout optimization result.
class GeniusOptimizedLayout {
  const GeniusOptimizedLayout({
    required this.elements,
    required this.pageSize,
    required this.margins,
    required this.suggestions,
    this.estimatedPages = 1,
  });

  /// Optimized element positions.
  final List<GeniusLayoutElement> elements;

  /// Recommended page size.
  final Size pageSize;

  /// Recommended margins.
  final GeniusLayoutMargins margins;

  /// Layout suggestions.
  final List<GeniusLayoutSuggestion> suggestions;

  /// Estimated number of pages.
  final int estimatedPages;
}

/// Margins for layout.
class GeniusLayoutMargins {
  const GeniusLayoutMargins({
    this.left = 40,
    this.top = 40,
    this.right = 40,
    this.bottom = 40,
  });

  const GeniusLayoutMargins.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const GeniusLayoutMargins.symmetric({
    double horizontal = 40,
    double vertical = 40,
  })  : left = horizontal,
        right = horizontal,
        top = vertical,
        bottom = vertical;

  final double left;
  final double top;
  final double right;
  final double bottom;

  /// Converts to Syncfusion PdfMargins.
  PdfMargins toPdfMargins() {
    final margins = PdfMargins();
    margins.left = left;
    margins.top = top;
    margins.right = right;
    margins.bottom = bottom;
    return margins;
  }
}

/// Smart layout engine that automatically optimizes PDF layouts.
///
/// The engine can:
/// - Analyze content and suggest optimal layouts
/// - Auto-arrange elements for best readability
/// - Suggest font sizes based on content amount
/// - Optimize for print or screen viewing
/// - Handle RTL and LTR content intelligently
///
/// ## Example
/// ```dart
/// final engine = GeniusSmartLayoutEngine();
///
/// // Analyze content and get suggestions
/// final suggestions = engine.analyzeFontSizes(
///   contentLength: 5000,
///   pageSize: PdfPageSize.a4,
/// );
///
/// // Optimize layout
/// final optimized = engine.optimizeLayout(
///   elements: myElements,
///   pageSize: PdfPageSize.a4,
/// );
/// ```
class GeniusSmartLayoutEngine {
  /// Creates a smart layout engine.
  GeniusSmartLayoutEngine({
    this.preferredPageSize = PdfPageSize.a4,
    this.defaultMargins = const GeniusLayoutMargins(),
    this.isRtl = false,
    this.optimizeForPrint = true,
  });

  /// Preferred page size.
  final Size preferredPageSize;

  /// Default margins.
  final GeniusLayoutMargins defaultMargins;

  /// Whether to use RTL layout.
  final bool isRtl;

  /// Whether to optimize for print (vs screen).
  final bool optimizeForPrint;

  /// Analyzes content and suggests optimal font sizes.
  List<GeniusLayoutSuggestion> analyzeFontSizes({
    required int contentLength,
    required Size pageSize,
    int estimatedPages = 1,
  }) {
    final suggestions = <GeniusLayoutSuggestion>[];

    // Calculate content density
    final contentArea = (pageSize.width - defaultMargins.left - defaultMargins.right) *
        (pageSize.height - defaultMargins.top - defaultMargins.bottom);
    final density = contentLength / (contentArea * estimatedPages);

    // Suggest title font size
    double titleFontSize;
    double bodyFontSize;
    double headerFontSize;

    if (density > 0.5) {
      // Dense content - smaller fonts
      titleFontSize = 16;
      bodyFontSize = 9;
      headerFontSize = 12;
      suggestions.add(GeniusLayoutSuggestion(
        type: GeniusSuggestionType.fontSize,
        description: 'Use smaller fonts due to dense content',
        descriptionAr: 'استخدم خطوط أصغر بسبب كثافة المحتوى',
        confidence: 0.8,
        parameters: {
          'titleFontSize': titleFontSize,
          'bodyFontSize': bodyFontSize,
          'headerFontSize': headerFontSize,
        },
      ));
    } else if (density < 0.2) {
      // Sparse content - larger fonts
      titleFontSize = 24;
      bodyFontSize = 12;
      headerFontSize = 16;
      suggestions.add(GeniusLayoutSuggestion(
        type: GeniusSuggestionType.fontSize,
        description: 'Use larger fonts for better readability',
        descriptionAr: 'استخدم خطوط أكبر لقراءة أفضل',
        confidence: 0.85,
        parameters: {
          'titleFontSize': titleFontSize,
          'bodyFontSize': bodyFontSize,
          'headerFontSize': headerFontSize,
        },
      ));
    } else {
      // Normal density
      titleFontSize = 20;
      bodyFontSize = 10;
      headerFontSize = 14;
      suggestions.add(GeniusLayoutSuggestion(
        type: GeniusSuggestionType.fontSize,
        description: 'Standard font sizes recommended',
        descriptionAr: 'يُوصى بأحجام الخطوط القياسية',
        confidence: 0.9,
        parameters: {
          'titleFontSize': titleFontSize,
          'bodyFontSize': bodyFontSize,
          'headerFontSize': headerFontSize,
        },
      ));
    }

    return suggestions;
  }

  /// Suggests optimal margins based on content type.
  GeniusLayoutSuggestion suggestMargins({
    required List<GeniusLayoutElement> elements,
    required Size pageSize,
  }) {
    // Check for tables that need more space
    final hasTables = elements.any((e) => e.type == GeniusLayoutElementType.table);

    GeniusLayoutMargins margins;
    String description;
    String descriptionAr;

    if (hasTables) {
      // Smaller margins for data-heavy documents
      margins = const GeniusLayoutMargins(
        left: 30,
        top: 35,
        right: 30,
        bottom: 35,
      );
      description = 'Reduced margins to accommodate tables';
      descriptionAr = 'هوامش مخفضة لاستيعاب الجداول';
    } else if (optimizeForPrint) {
      // Standard print margins
      margins = const GeniusLayoutMargins(
        left: 50,
        top: 50,
        right: 50,
        bottom: 50,
      );
      description = 'Standard print margins for professional appearance';
      descriptionAr = 'هوامش طباعة قياسية للمظهر الاحترافي';
    } else {
      // Screen-optimized margins
      margins = const GeniusLayoutMargins(
        left: 40,
        top: 40,
        right: 40,
        bottom: 40,
      );
      description = 'Optimized margins for screen viewing';
      descriptionAr = 'هوامش محسّنة للعرض على الشاشة';
    }

    return GeniusLayoutSuggestion(
      type: GeniusSuggestionType.margins,
      description: description,
      descriptionAr: descriptionAr,
      confidence: 0.85,
      parameters: {
        'left': margins.left,
        'top': margins.top,
        'right': margins.right,
        'bottom': margins.bottom,
      },
    );
  }

  /// Suggests optimal spacing between elements.
  List<GeniusLayoutSuggestion> analyzeSpacing({
    required List<GeniusLayoutElement> elements,
    required Size pageSize,
  }) {
    final suggestions = <GeniusLayoutSuggestion>[];

    if (elements.isEmpty) return suggestions;

    // Analyze element types and suggest spacing
    for (var i = 0; i < elements.length - 1; i++) {
      final current = elements[i];
      final next = elements[i + 1];

      double suggestedSpacing;
      String reason;
      String reasonAr;

      // Header followed by content
      if (current.type == GeniusLayoutElementType.header &&
          next.type != GeniusLayoutElementType.header) {
        suggestedSpacing = 20;
        reason = 'Add spacing after header for visual separation';
        reasonAr = 'أضف مسافة بعد العنوان للفصل البصري';
      }
      // Subheader followed by content
      else if (current.type == GeniusLayoutElementType.subheader) {
        suggestedSpacing = 12;
        reason = 'Moderate spacing after subheader';
        reasonAr = 'مسافة معتدلة بعد العنوان الفرعي';
      }
      // Before table
      else if (next.type == GeniusLayoutElementType.table) {
        suggestedSpacing = 15;
        reason = 'Add spacing before table for clarity';
        reasonAr = 'أضف مسافة قبل الجدول للوضوح';
      }
      // After table
      else if (current.type == GeniusLayoutElementType.table) {
        suggestedSpacing = 20;
        reason = 'Add spacing after table';
        reasonAr = 'أضف مسافة بعد الجدول';
      }
      // Paragraph to paragraph
      else if (current.type == GeniusLayoutElementType.paragraph &&
          next.type == GeniusLayoutElementType.paragraph) {
        suggestedSpacing = 10;
        reason = 'Standard paragraph spacing';
        reasonAr = 'مسافة قياسية بين الفقرات';
      }
      // Default spacing
      else {
        suggestedSpacing = 8;
        reason = 'Standard element spacing';
        reasonAr = 'مسافة قياسية بين العناصر';
      }

      suggestions.add(GeniusLayoutSuggestion(
        type: GeniusSuggestionType.spacing,
        description: reason,
        descriptionAr: reasonAr,
        confidence: 0.8,
        parameters: {
          'afterElementIndex': i,
          'spacing': suggestedSpacing,
        },
      ));
    }

    return suggestions;
  }

  /// Suggests column layout based on content.
  GeniusLayoutSuggestion suggestColumnLayout({
    required List<GeniusLayoutElement> elements,
    required Size pageSize,
  }) {
    int columns = 1;
    String description;
    String descriptionAr;

    // Count small elements that could benefit from columns
    final smallElements = elements.where((e) =>
        e.type == GeniusLayoutElementType.list ||
        (e.type == GeniusLayoutElementType.paragraph &&
         (e.content?.toString().length ?? 0) < 200));

    final hasLargeTables = elements.any((e) =>
        e.type == GeniusLayoutElementType.table && e.bounds.width > pageSize.width * 0.5);

    if (hasLargeTables) {
      columns = 1;
      description = 'Single column recommended for wide tables';
      descriptionAr = 'عمود واحد موصى به للجداول العريضة';
    } else if (smallElements.length > elements.length * 0.6 && elements.length > 10) {
      columns = 2;
      description = 'Two-column layout for better content organization';
      descriptionAr = 'تخطيط من عمودين لتنظيم أفضل للمحتوى';
    } else {
      columns = 1;
      description = 'Single column layout for clarity';
      descriptionAr = 'تخطيط من عمود واحد للوضوح';
    }

    return GeniusLayoutSuggestion(
      type: GeniusSuggestionType.columns,
      description: description,
      descriptionAr: descriptionAr,
      confidence: 0.75,
      parameters: {'columns': columns},
    );
  }

  /// Optimizes layout for the given elements.
  GeniusOptimizedLayout optimizeLayout({
    required List<GeniusLayoutElement> elements,
    Size? pageSize,
    GeniusLayoutMargins? margins,
  }) {
    final effectivePageSize = pageSize ?? preferredPageSize;
    final effectiveMargins = margins ?? defaultMargins;

    final suggestions = <GeniusLayoutSuggestion>[];

    // Collect all suggestions
    suggestions.add(suggestMargins(elements: elements, pageSize: effectivePageSize));
    suggestions.addAll(analyzeSpacing(elements: elements, pageSize: effectivePageSize));
    suggestions.add(suggestColumnLayout(elements: elements, pageSize: effectivePageSize));

    // Calculate total content length for font suggestions
    int totalContentLength = 0;
    for (final element in elements) {
      if (element.content is String) {
        totalContentLength += (element.content as String).length;
      }
    }
    suggestions.addAll(analyzeFontSizes(
      contentLength: totalContentLength,
      pageSize: effectivePageSize,
    ));

    // Calculate optimized positions
    final optimizedElements = _calculateOptimizedPositions(
      elements: elements,
      pageSize: effectivePageSize,
      margins: effectiveMargins,
    );

    // Estimate page count
    final estimatedPages = _estimatePageCount(
      elements: optimizedElements,
      pageSize: effectivePageSize,
      margins: effectiveMargins,
    );

    return GeniusOptimizedLayout(
      elements: optimizedElements,
      pageSize: effectivePageSize,
      margins: effectiveMargins,
      suggestions: suggestions,
      estimatedPages: estimatedPages,
    );
  }

  List<GeniusLayoutElement> _calculateOptimizedPositions({
    required List<GeniusLayoutElement> elements,
    required Size pageSize,
    required GeniusLayoutMargins margins,
  }) {
    final contentWidth = pageSize.width - margins.left - margins.right;
    final optimized = <GeniusLayoutElement>[];

    double currentY = margins.top;
    const spacing = 10.0;

    for (final element in elements) {
      // Calculate new bounds
      final newBounds = Rect.fromLTWH(
        isRtl ? margins.right : margins.left,
        currentY,
        math.min(element.bounds.width, contentWidth),
        element.bounds.height,
      );

      optimized.add(GeniusLayoutElement(
        type: element.type,
        bounds: newBounds,
        content: element.content,
        priority: element.priority,
        isRtl: element.isRtl,
      ));

      currentY += element.bounds.height + spacing;
    }

    return optimized;
  }

  int _estimatePageCount({
    required List<GeniusLayoutElement> elements,
    required Size pageSize,
    required GeniusLayoutMargins margins,
  }) {
    if (elements.isEmpty) return 1;

    final contentHeight = pageSize.height - margins.top - margins.bottom;
    double totalHeight = 0;

    for (final element in elements) {
      totalHeight += element.bounds.height + 10; // +10 for spacing
    }

    return (totalHeight / contentHeight).ceil().clamp(1, 100).toInt();
  }

  /// Suggests color scheme based on document type.
  GeniusLayoutSuggestion suggestColorScheme({
    required String documentType,
    bool isDarkMode = false,
  }) {
    Map<String, Color> colors;
    String description;
    String descriptionAr;

    switch (documentType.toLowerCase()) {
      case 'invoice':
      case 'quotation':
        colors = {
          'primary': const Color(0xFF2980B9),
          'secondary': const Color(0xFF3498DB),
          'accent': const Color(0xFFE74C3C),
          'text': const Color(0xFF2C3E50),
          'background': const Color(0xFFFFFFFF),
        };
        description = 'Professional blue color scheme for business documents';
        descriptionAr = 'نظام ألوان أزرق احترافي للمستندات التجارية';
        break;

      case 'report':
        colors = {
          'primary': const Color(0xFF27AE60),
          'secondary': const Color(0xFF2ECC71),
          'accent': const Color(0xFFF39C12),
          'text': const Color(0xFF2C3E50),
          'background': const Color(0xFFFFFFFF),
        };
        description = 'Green color scheme for reports and analytics';
        descriptionAr = 'نظام ألوان أخضر للتقارير والتحليلات';
        break;

      case 'certificate':
        colors = {
          'primary': const Color(0xFF8E44AD),
          'secondary': const Color(0xFF9B59B6),
          'accent': const Color(0xFFF1C40F),
          'text': const Color(0xFF2C3E50),
          'background': const Color(0xFFFDF2E9),
        };
        description = 'Elegant color scheme for certificates';
        descriptionAr = 'نظام ألوان أنيق للشهادات';
        break;

      default:
        colors = {
          'primary': const Color(0xFF34495E),
          'secondary': const Color(0xFF7F8C8D),
          'accent': const Color(0xFF3498DB),
          'text': const Color(0xFF2C3E50),
          'background': const Color(0xFFFFFFFF),
        };
        description = 'Neutral color scheme for general documents';
        descriptionAr = 'نظام ألوان محايد للمستندات العامة';
    }

    if (isDarkMode) {
      colors = {
        'primary': colors['primary']!,
        'secondary': colors['secondary']!,
        'accent': colors['accent']!,
        'text': const Color(0xFFECF0F1),
        'background': const Color(0xFF2C3E50),
      };
      description += ' (dark mode)';
      descriptionAr += ' (الوضع الداكن)';
    }

    return GeniusLayoutSuggestion(
      type: GeniusSuggestionType.colorScheme,
      description: description,
      descriptionAr: descriptionAr,
      confidence: 0.85,
      parameters: {
        'colors': colors.map((k, v) => MapEntry(k, v.toARGB32())),
      },
    );
  }

  /// Suggests print optimization settings.
  GeniusLayoutSuggestion suggestPrintOptimization({
    bool hasImages = false,
    bool hasColors = true,
  }) {
    final params = <String, dynamic>{};
    String description;
    String descriptionAr;

    if (hasImages) {
      params['imageQuality'] = 'high';
      params['imageCompression'] = 0.85;
    }

    if (hasColors) {
      params['colorMode'] = 'cmyk';
      params['preserveColors'] = true;
    } else {
      params['colorMode'] = 'grayscale';
    }

    params['bleedMargins'] = 3.0; // 3mm bleed
    params['cropMarks'] = true;

    description = 'Print-optimized settings for professional output';
    descriptionAr = 'إعدادات محسّنة للطباعة للإخراج الاحترافي';

    return GeniusLayoutSuggestion(
      type: GeniusSuggestionType.printOptimization,
      description: description,
      descriptionAr: descriptionAr,
      confidence: 0.9,
      parameters: params,
    );
  }
}
