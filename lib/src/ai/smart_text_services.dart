import 'dart:math' as math;

/// Result of text summarization.
class GeniusSummaryResult {
  const GeniusSummaryResult({
    required this.summary,
    required this.keyPoints,
    required this.originalLength,
    required this.summaryLength,
    required this.compressionRatio,
  });

  /// The summarized text.
  final String summary;

  /// Key points extracted from the text.
  final List<String> keyPoints;

  /// Length of the original text.
  final int originalLength;

  /// Length of the summary.
  final int summaryLength;

  /// Compression ratio (0-1).
  final double compressionRatio;

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'keyPoints': keyPoints,
        'originalLength': originalLength,
        'summaryLength': summaryLength,
        'compressionRatio': compressionRatio,
      };
}

/// Result of language detection.
class GeniusLanguageDetectionResult {
  const GeniusLanguageDetectionResult({
    required this.primaryLanguage,
    required this.confidence,
    this.detectedLanguages = const [],
    this.isRtl = false,
  });

  /// Primary detected language code.
  final String primaryLanguage;

  /// Confidence level (0-1).
  final double confidence;

  /// All detected languages with their scores.
  final List<GeniusDetectedLanguage> detectedLanguages;

  /// Whether the primary language is RTL.
  final bool isRtl;

  Map<String, dynamic> toJson() => {
        'primaryLanguage': primaryLanguage,
        'confidence': confidence,
        'detectedLanguages': detectedLanguages.map((l) => l.toJson()).toList(),
        'isRtl': isRtl,
      };
}

/// A detected language with its score.
class GeniusDetectedLanguage {
  const GeniusDetectedLanguage({
    required this.languageCode,
    required this.languageName,
    required this.score,
    this.isRtl = false,
  });

  /// Language code (e.g., 'en', 'ar').
  final String languageCode;

  /// Human-readable language name.
  final String languageName;

  /// Detection score (0-1).
  final double score;

  /// Whether this language is RTL.
  final bool isRtl;

  Map<String, dynamic> toJson() => {
        'languageCode': languageCode,
        'languageName': languageName,
        'score': score,
        'isRtl': isRtl,
      };
}

/// Generated title suggestion.
class GeniusTitleSuggestion {
  const GeniusTitleSuggestion({
    required this.title,
    this.titleAr,
    required this.confidence,
    this.keywords = const [],
  });

  /// Suggested title in English.
  final String title;

  /// Suggested title in Arabic (if applicable).
  final String? titleAr;

  /// Confidence level (0-1).
  final double confidence;

  /// Keywords that influenced the title.
  final List<String> keywords;

  Map<String, dynamic> toJson() => {
        'title': title,
        'titleAr': titleAr,
        'confidence': confidence,
        'keywords': keywords,
      };
}

/// Smart text services for AI-powered text processing.
///
/// Provides:
/// - Text summarization
/// - Language detection
/// - Smart title generation
/// - Keyword extraction
///
/// ## Example
/// ```dart
/// final services = GeniusSmartTextServices();
///
/// // Summarize text
/// final summary = services.summarize(longText, maxLength: 200);
///
/// // Detect language
/// final language = services.detectLanguage(text);
///
/// // Generate title
/// final title = services.generateTitle(text);
/// ```
class GeniusSmartTextServices {
  /// Creates smart text services.
  GeniusSmartTextServices({
    this.defaultMaxSummaryLength = 500,
    this.defaultKeyPointCount = 5,
  });

  /// Default maximum length for summaries.
  final int defaultMaxSummaryLength;

  /// Default number of key points to extract.
  final int defaultKeyPointCount;

  /// Language names mapping.
  static const Map<String, String> _languageNames = {
    'en': 'English',
    'ar': 'Arabic',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ko': 'Korean',
    'hi': 'Hindi',
    'fr': 'French',
    'de': 'German',
    'es': 'Spanish',
    'pt': 'Portuguese',
    'ru': 'Russian',
    'it': 'Italian',
    'tr': 'Turkish',
    'fa': 'Persian',
    'ur': 'Urdu',
  };

  /// RTL languages.
  static const Set<String> _rtlLanguages = {'ar', 'fa', 'ur', 'he'};

  /// Summarizes the given text.
  GeniusSummaryResult summarize(
    String text, {
    int? maxLength,
    int? keyPointCount,
  }) {
    final effectiveMaxLength = maxLength ?? defaultMaxSummaryLength;
    final effectiveKeyPointCount = keyPointCount ?? defaultKeyPointCount;

    // Split into sentences
    final sentences = _splitIntoSentences(text);

    if (sentences.isEmpty) {
      return GeniusSummaryResult(
        summary: '',
        keyPoints: [],
        originalLength: text.length,
        summaryLength: 0,
        compressionRatio: 1.0,
      );
    }

    // Score sentences by importance
    final scoredSentences = _scoreSentences(sentences, text);

    // Select top sentences for summary
    final selectedSentences = _selectTopSentences(
      scoredSentences,
      effectiveMaxLength,
    );

    // Extract key points
    final keyPoints = _extractKeyPoints(scoredSentences, effectiveKeyPointCount);

    // Build summary
    final summary = selectedSentences.join(' ');

    return GeniusSummaryResult(
      summary: summary,
      keyPoints: keyPoints,
      originalLength: text.length,
      summaryLength: summary.length,
      compressionRatio: 1.0 - (summary.length / text.length),
    );
  }

  List<String> _splitIntoSentences(String text) {
    // Split by common sentence endings
    final pattern = RegExp(r'[.!?؟。！？]+\s*');
    return text
        .split(pattern)
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty && s.length > 10)
        .toList();
  }

  List<_ScoredSentence> _scoreSentences(List<String> sentences, String fullText) {
    final wordFrequency = _calculateWordFrequency(fullText);
    final scored = <_ScoredSentence>[];

    for (var i = 0; i < sentences.length; i++) {
      final sentence = sentences[i];
      double score = 0;

      // Position score (first and last sentences are often important)
      if (i == 0) score += 0.3;
      if (i == sentences.length - 1) score += 0.2;

      // Word frequency score
      final words = sentence.toLowerCase().split(RegExp(r'\s+'));
      for (final word in words) {
        score += (wordFrequency[word] ?? 0) * 0.1;
      }

      // Length score (prefer medium-length sentences)
      final lengthScore = 1.0 - (sentence.length - 100).abs() / 200;
      score += lengthScore.clamp(0.0, 0.3);

      // Keywords indicator score
      if (_containsImportantKeywords(sentence)) {
        score += 0.4;
      }

      scored.add(_ScoredSentence(sentence, score, i));
    }

    // Normalize scores
    final maxScore = scored.map((s) => s.score).reduce(math.max);
    if (maxScore > 0) {
      for (final s in scored) {
        s.score /= maxScore;
      }
    }

    return scored;
  }

  Map<String, double> _calculateWordFrequency(String text) {
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final frequency = <String, int>{};

    for (final word in words) {
      if (word.length > 3) {
        frequency[word] = (frequency[word] ?? 0) + 1;
      }
    }

    final maxFreq = frequency.values.isEmpty ? 1 : frequency.values.reduce(math.max);
    return frequency.map((k, v) => MapEntry(k, v / maxFreq));
  }

  bool _containsImportantKeywords(String sentence) {
    final lowerSentence = sentence.toLowerCase();
    const importantWords = [
      'important',
      'key',
      'main',
      'significant',
      'crucial',
      'essential',
      'primary',
      'major',
      'critical',
      'fundamental',
      'conclusion',
      'summary',
      'result',
      'finding',
      'therefore',
      'consequently',
      'مهم',
      'رئيسي',
      'أساسي',
      'نتيجة',
      'خلاصة',
      'ملخص',
    ];

    return importantWords.any((word) => lowerSentence.contains(word));
  }

  List<String> _selectTopSentences(
    List<_ScoredSentence> scoredSentences,
    int maxLength,
  ) {
    // Sort by score
    final sorted = List<_ScoredSentence>.from(scoredSentences)
      ..sort((a, b) => b.score.compareTo(a.score));

    final selected = <_ScoredSentence>[];
    var currentLength = 0;

    for (final sentence in sorted) {
      if (currentLength + sentence.text.length <= maxLength) {
        selected.add(sentence);
        currentLength += sentence.text.length;
      }
    }

    // Sort by original position to maintain flow
    selected.sort((a, b) => a.position.compareTo(b.position));

    return selected.map((s) => s.text).toList();
  }

  List<String> _extractKeyPoints(
    List<_ScoredSentence> scoredSentences,
    int count,
  ) {
    final sorted = List<_ScoredSentence>.from(scoredSentences)
      ..sort((a, b) => b.score.compareTo(a.score));

    return sorted
        .take(count)
        .map((s) => _truncateSentence(s.text, 100))
        .toList();
  }

  String _truncateSentence(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }

  /// Detects the language of the given text.
  GeniusLanguageDetectionResult detectLanguage(String text) {
    final detectedLanguages = <GeniusDetectedLanguage>[];

    // Count character types
    final arabicCount = RegExp(r'[\u0600-\u06FF]').allMatches(text).length;
    final latinCount = RegExp(r'[a-zA-Z]').allMatches(text).length;
    final chineseCount = RegExp(r'[\u4E00-\u9FFF]').allMatches(text).length;
    final japaneseCount = RegExp(r'[\u3040-\u309F\u30A0-\u30FF]').allMatches(text).length;
    final koreanCount = RegExp(r'[\uAC00-\uD7AF]').allMatches(text).length;
    final hindiCount = RegExp(r'[\u0900-\u097F]').allMatches(text).length;
    final cyrillicCount = RegExp(r'[\u0400-\u04FF]').allMatches(text).length;

    final totalChars = text.replaceAll(RegExp(r'\s'), '').length;
    if (totalChars == 0) {
      return const GeniusLanguageDetectionResult(
        primaryLanguage: 'unknown',
        confidence: 0,
        isRtl: false,
      );
    }

    // Calculate scores
    if (arabicCount > 0) {
      detectedLanguages.add(GeniusDetectedLanguage(
        languageCode: 'ar',
        languageName: 'Arabic',
        score: arabicCount / totalChars,
        isRtl: true,
      ));
    }

    if (latinCount > 0) {
      detectedLanguages.add(GeniusDetectedLanguage(
        languageCode: 'en',
        languageName: 'English',
        score: latinCount / totalChars,
        isRtl: false,
      ));
    }

    if (chineseCount > 0) {
      detectedLanguages.add(GeniusDetectedLanguage(
        languageCode: 'zh',
        languageName: 'Chinese',
        score: chineseCount / totalChars,
        isRtl: false,
      ));
    }

    if (japaneseCount > 0) {
      detectedLanguages.add(GeniusDetectedLanguage(
        languageCode: 'ja',
        languageName: 'Japanese',
        score: japaneseCount / totalChars,
        isRtl: false,
      ));
    }

    if (koreanCount > 0) {
      detectedLanguages.add(GeniusDetectedLanguage(
        languageCode: 'ko',
        languageName: 'Korean',
        score: koreanCount / totalChars,
        isRtl: false,
      ));
    }

    if (hindiCount > 0) {
      detectedLanguages.add(GeniusDetectedLanguage(
        languageCode: 'hi',
        languageName: 'Hindi',
        score: hindiCount / totalChars,
        isRtl: false,
      ));
    }

    if (cyrillicCount > 0) {
      detectedLanguages.add(GeniusDetectedLanguage(
        languageCode: 'ru',
        languageName: 'Russian',
        score: cyrillicCount / totalChars,
        isRtl: false,
      ));
    }

    if (detectedLanguages.isEmpty) {
      return const GeniusLanguageDetectionResult(
        primaryLanguage: 'unknown',
        confidence: 0,
        isRtl: false,
      );
    }

    // Sort by score
    detectedLanguages.sort((a, b) => b.score.compareTo(a.score));

    final primary = detectedLanguages.first;
    return GeniusLanguageDetectionResult(
      primaryLanguage: primary.languageCode,
      confidence: primary.score,
      detectedLanguages: detectedLanguages,
      isRtl: primary.isRtl,
    );
  }

  /// Generates smart title suggestions for the given text.
  List<GeniusTitleSuggestion> generateTitles(
    String text, {
    int maxSuggestions = 3,
  }) {
    final suggestions = <GeniusTitleSuggestion>[];

    // Extract keywords
    final keywords = _extractTopKeywords(text, 10);
    if (keywords.isEmpty) {
      return [
        const GeniusTitleSuggestion(
          title: 'Untitled Document',
          titleAr: 'مستند بدون عنوان',
          confidence: 0.3,
        ),
      ];
    }

    // Detect document type for better titles
    final docType = _detectDocumentType(text);

    // Generate title based on document type and keywords
    suggestions.add(_generateTypeBasedTitle(docType, keywords));

    // Generate keyword-based title
    if (keywords.length >= 2) {
      suggestions.add(GeniusTitleSuggestion(
        title: '${_capitalize(keywords[0])} ${keywords[1].isNotEmpty ? "- ${_capitalize(keywords[1])}" : ""}',
        confidence: 0.7,
        keywords: keywords.take(2).toList(),
      ));
    }

    // Generate summary-based title
    final firstSentence = _getFirstSentence(text);
    if (firstSentence.isNotEmpty && firstSentence.length < 80) {
      suggestions.add(GeniusTitleSuggestion(
        title: firstSentence,
        confidence: 0.6,
        keywords: keywords,
      ));
    }

    return suggestions.take(maxSuggestions).toList();
  }

  List<String> _extractTopKeywords(String text, int count) {
    final words = text.toLowerCase().split(RegExp(r'\s+'));
    final frequency = <String, int>{};

    const stopWords = {
      'the', 'a', 'an', 'is', 'are', 'was', 'were', 'be', 'been', 'being',
      'have', 'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could',
      'should', 'may', 'might', 'must', 'shall', 'can', 'need', 'to', 'of',
      'in', 'for', 'on', 'with', 'at', 'by', 'from', 'as', 'into', 'through',
      'and', 'but', 'if', 'or', 'because', 'until', 'while', 'this', 'that',
      'these', 'those', 'it', 'its', 'من', 'في', 'على', 'إلى', 'عن', 'مع',
      'هذا', 'هذه', 'ذلك', 'تلك', 'التي', 'الذي', 'هو', 'هي', 'أن', 'كان',
    };

    for (final word in words) {
      final cleanWord = word.replaceAll(RegExp(r'[^\w\u0600-\u06FF]'), '');
      if (cleanWord.length > 3 && !stopWords.contains(cleanWord)) {
        frequency[cleanWord] = (frequency[cleanWord] ?? 0) + 1;
      }
    }

    final sorted = frequency.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(count).map((e) => e.key).toList();
  }

  String _detectDocumentType(String text) {
    final lowerText = text.toLowerCase();

    if (lowerText.contains('invoice') || lowerText.contains('فاتورة')) {
      return 'invoice';
    }
    if (lowerText.contains('report') || lowerText.contains('تقرير')) {
      return 'report';
    }
    if (lowerText.contains('quotation') || lowerText.contains('عرض سعر')) {
      return 'quotation';
    }
    if (lowerText.contains('contract') || lowerText.contains('عقد')) {
      return 'contract';
    }
    if (lowerText.contains('letter') || lowerText.contains('خطاب')) {
      return 'letter';
    }

    return 'document';
  }

  GeniusTitleSuggestion _generateTypeBasedTitle(
    String docType,
    List<String> keywords,
  ) {
    String title;
    String? titleAr;

    final keyword = keywords.isNotEmpty ? _capitalize(keywords.first) : '';

    switch (docType) {
      case 'invoice':
        title = keyword.isNotEmpty ? '$keyword Invoice' : 'Invoice';
        titleAr = keyword.isNotEmpty ? 'فاتورة $keyword' : 'فاتورة';
        break;
      case 'report':
        title = keyword.isNotEmpty ? '$keyword Report' : 'Report';
        titleAr = keyword.isNotEmpty ? 'تقرير $keyword' : 'تقرير';
        break;
      case 'quotation':
        title = keyword.isNotEmpty ? '$keyword Quotation' : 'Quotation';
        titleAr = keyword.isNotEmpty ? 'عرض سعر $keyword' : 'عرض سعر';
        break;
      case 'contract':
        title = keyword.isNotEmpty ? '$keyword Contract' : 'Contract';
        titleAr = keyword.isNotEmpty ? 'عقد $keyword' : 'عقد';
        break;
      case 'letter':
        title = keyword.isNotEmpty ? 'Letter: $keyword' : 'Letter';
        titleAr = keyword.isNotEmpty ? 'خطاب: $keyword' : 'خطاب';
        break;
      default:
        title = keyword.isNotEmpty ? keyword : 'Document';
        titleAr = null;
    }

    return GeniusTitleSuggestion(
      title: title,
      titleAr: titleAr,
      confidence: 0.85,
      keywords: keywords,
    );
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  String _getFirstSentence(String text) {
    final match = RegExp(r'^[^.!?؟。！？]+[.!?؟。！？]?').firstMatch(text.trim());
    return match?.group(0)?.trim() ?? '';
  }

  /// Extracts keywords from the given text.
  List<String> extractKeywords(String text, {int maxKeywords = 10}) {
    return _extractTopKeywords(text, maxKeywords);
  }

  /// Checks if the text is primarily RTL.
  bool isRtlText(String text) {
    final result = detectLanguage(text);
    return result.isRtl;
  }

  /// Gets the language name from a language code.
  String getLanguageName(String code) {
    return _languageNames[code] ?? code;
  }

  /// Checks if a language code is RTL.
  bool isRtlLanguage(String code) {
    return _rtlLanguages.contains(code);
  }
}

/// Internal class for scored sentences.
class _ScoredSentence {
  _ScoredSentence(this.text, this.score, this.position);

  final String text;
  double score;
  final int position;
}
