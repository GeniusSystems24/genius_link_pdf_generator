/// AI-powered features for the Genius Link PDF Generator.
///
/// This module provides intelligent features for PDF creation and analysis:
/// - Content analysis and document classification
/// - Smart layout optimization
/// - Text summarization and language detection
/// - Image optimization
///
/// ## Getting Started
///
/// ```dart
/// import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart';
///
/// // Analyze PDF content
/// final analyzer = GeniusPdfContentAnalyzer();
/// final result = await analyzer.analyzeBytes(pdfBytes);
///
/// // Use smart layout engine
/// final layoutEngine = GeniusSmartLayoutEngine();
/// final suggestions = layoutEngine.analyzeFontSizes(
///   contentLength: 5000,
///   pageSize: PdfPageSize.a4,
/// );
///
/// // Smart text services
/// final textServices = GeniusSmartTextServices();
/// final summary = textServices.summarize(longText);
/// final language = textServices.detectLanguage(text);
///
/// // Image optimization
/// final imageOptimizer = GeniusSmartImageOptimizer();
/// final analysis = await imageOptimizer.analyze(imageBytes);
/// ```
library;

export 'pdf_content_analyzer.dart';
export 'smart_image_optimizer.dart';
export 'smart_layout_engine.dart';
export 'smart_text_services.dart';
