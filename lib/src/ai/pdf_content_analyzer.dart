import 'dart:typed_data';

import 'package:syncfusion_flutter_pdf/pdf.dart';

/// Result of PDF content analysis.
class GeniusPdfAnalysisResult {
  const GeniusPdfAnalysisResult({
    required this.pageCount,
    required this.textContent,
    required this.wordCount,
    required this.characterCount,
    required this.detectedLanguages,
    required this.hasImages,
    required this.hasTables,
    required this.hasLinks,
    required this.documentType,
    required this.keywords,
    required this.metadata,
    required this.structuredData,
  });

  /// Number of pages in the document.
  final int pageCount;

  /// Extracted text content from all pages.
  final String textContent;

  /// Total word count.
  final int wordCount;

  /// Total character count.
  final int characterCount;

  /// Detected languages in the document.
  final List<String> detectedLanguages;

  /// Whether the document contains images.
  final bool hasImages;

  /// Whether the document contains tables.
  final bool hasTables;

  /// Whether the document contains links.
  final bool hasLinks;

  /// Detected document type (invoice, report, letter, etc.).
  final GeniusDocumentType documentType;

  /// Extracted keywords from the document.
  final List<String> keywords;

  /// Document metadata.
  final Map<String, String> metadata;

  /// Structured data extracted from the document.
  final GeniusStructuredData structuredData;

  Map<String, dynamic> toJson() => {
        'pageCount': pageCount,
        'wordCount': wordCount,
        'characterCount': characterCount,
        'detectedLanguages': detectedLanguages,
        'hasImages': hasImages,
        'hasTables': hasTables,
        'hasLinks': hasLinks,
        'documentType': documentType.name,
        'keywords': keywords,
        'metadata': metadata,
        'structuredData': structuredData.toJson(),
      };
}

/// Types of documents that can be detected.
enum GeniusDocumentType {
  /// Invoice or bill.
  invoice,

  /// Quotation or price offer.
  quotation,

  /// Purchase order.
  purchaseOrder,

  /// Business report.
  report,

  /// Business letter.
  letter,

  /// Contract or agreement.
  contract,

  /// Receipt.
  receipt,

  /// Resume or CV.
  resume,

  /// Certificate.
  certificate,

  /// General document.
  general,

  /// Unknown document type.
  unknown,
}

/// Structured data extracted from a document.
class GeniusStructuredData {
  const GeniusStructuredData({
    this.dates = const [],
    this.amounts = const [],
    this.emails = const [],
    this.phoneNumbers = const [],
    this.addresses = const [],
    this.names = const [],
    this.organizations = const [],
    this.referenceNumbers = const [],
  });

  /// Dates found in the document.
  final List<String> dates;

  /// Monetary amounts found in the document.
  final List<GeniusMonetaryAmount> amounts;

  /// Email addresses found in the document.
  final List<String> emails;

  /// Phone numbers found in the document.
  final List<String> phoneNumbers;

  /// Addresses found in the document.
  final List<String> addresses;

  /// Names found in the document.
  final List<String> names;

  /// Organizations found in the document.
  final List<String> organizations;

  /// Reference numbers (invoice numbers, order numbers, etc.).
  final List<String> referenceNumbers;

  Map<String, dynamic> toJson() => {
        'dates': dates,
        'amounts': amounts.map((a) => a.toJson()).toList(),
        'emails': emails,
        'phoneNumbers': phoneNumbers,
        'addresses': addresses,
        'names': names,
        'organizations': organizations,
        'referenceNumbers': referenceNumbers,
      };
}

/// Represents a monetary amount extracted from a document.
class GeniusMonetaryAmount {
  const GeniusMonetaryAmount({
    required this.value,
    this.currency,
    this.originalText,
  });

  /// The numeric value.
  final double value;

  /// The currency code (SAR, USD, EUR, etc.).
  final String? currency;

  /// The original text as it appeared in the document.
  final String? originalText;

  Map<String, dynamic> toJson() => {
        'value': value,
        'currency': currency,
        'originalText': originalText,
      };
}

/// Analyzes PDF content and extracts structured information.
///
/// The analyzer can:
/// - Extract text content from PDFs
/// - Detect document types (invoice, report, letter, etc.)
/// - Extract structured data (dates, amounts, emails, etc.)
/// - Identify keywords and topics
/// - Detect languages used in the document
///
/// ## Example
/// ```dart
/// final analyzer = GeniusPdfContentAnalyzer();
///
/// // Analyze from bytes
/// final result = await analyzer.analyzeBytes(pdfBytes);
/// print('Document type: ${result.documentType}');
/// print('Word count: ${result.wordCount}');
/// print('Keywords: ${result.keywords}');
///
/// // Analyze from file
/// final fileResult = await analyzer.analyzeFile('/path/to/document.pdf');
/// ```
class GeniusPdfContentAnalyzer {
  /// Creates a PDF content analyzer.
  GeniusPdfContentAnalyzer({
    this.extractImages = false,
    this.maxKeywords = 10,
    this.minKeywordLength = 3,
  });

  /// Whether to extract image information.
  final bool extractImages;

  /// Maximum number of keywords to extract.
  final int maxKeywords;

  /// Minimum length for a word to be considered a keyword.
  final int minKeywordLength;

  /// Analyzes a PDF document from bytes.
  Future<GeniusPdfAnalysisResult> analyzeBytes(Uint8List bytes) async {
    final document = PdfDocument(inputBytes: bytes);

    try {
      return _analyzeDocument(document);
    } finally {
      document.dispose();
    }
  }

  /// Analyzes a PDF document from an existing PdfDocument instance.
  Future<GeniusPdfAnalysisResult> analyzeDocument(PdfDocument document) async {
    return _analyzeDocument(document);
  }

  GeniusPdfAnalysisResult _analyzeDocument(PdfDocument document) {
    // Extract text from all pages
    final textExtractor = PdfTextExtractor(document);
    final textBuffer = StringBuffer();

    for (var i = 0; i < document.pages.count; i++) {
      final pageText = textExtractor.extractText(startPageIndex: i);
      textBuffer.writeln(pageText);
    }

    final fullText = textBuffer.toString();

    // Calculate word and character counts
    final words = _extractWords(fullText);
    final wordCount = words.length;
    final characterCount = fullText.replaceAll(RegExp(r'\s'), '').length;

    // Detect languages
    final detectedLanguages = _detectLanguages(fullText);

    // Detect document type
    final documentType = _detectDocumentType(fullText);

    // Extract keywords
    final keywords = extractKeywords(words);

    // Extract structured data
    final structuredData = _extractStructuredData(fullText);

    // Check for various content types
    final hasImages = _checkForImages(document);
    final hasTables = _checkForTables(fullText);
    final hasLinks = _checkForLinks(fullText);

    // Extract metadata
    final metadata = _extractMetadata(document);

    return GeniusPdfAnalysisResult(
      pageCount: document.pages.count,
      textContent: fullText,
      wordCount: wordCount,
      characterCount: characterCount,
      detectedLanguages: detectedLanguages,
      hasImages: hasImages,
      hasTables: hasTables,
      hasLinks: hasLinks,
      documentType: documentType,
      keywords: keywords,
      metadata: metadata,
      structuredData: structuredData,
    );
  }

  List<String> _extractWords(String text) {
    return text
        .split(RegExp(r'[\s\n\r\t]+'))
        .where((w) => w.isNotEmpty && w.length >= minKeywordLength)
        .toList();
  }

  List<String> _detectLanguages(String text) {
    final languages = <String>[];

    // Check for Arabic characters
    if (RegExp(r'[\u0600-\u06FF]').hasMatch(text)) {
      languages.add('ar');
    }

    // Check for English/Latin characters
    if (RegExp(r'[a-zA-Z]').hasMatch(text)) {
      languages.add('en');
    }

    // Check for Chinese characters
    if (RegExp(r'[\u4E00-\u9FFF]').hasMatch(text)) {
      languages.add('zh');
    }

    // Check for Japanese characters
    if (RegExp(r'[\u3040-\u309F\u30A0-\u30FF]').hasMatch(text)) {
      languages.add('ja');
    }

    // Check for Korean characters
    if (RegExp(r'[\uAC00-\uD7AF]').hasMatch(text)) {
      languages.add('ko');
    }

    // Check for Hindi/Devanagari characters
    if (RegExp(r'[\u0900-\u097F]').hasMatch(text)) {
      languages.add('hi');
    }

    return languages.isEmpty ? ['unknown'] : languages;
  }

  GeniusDocumentType _detectDocumentType(String text) {
    final lowerText = text.toLowerCase();

    // Invoice indicators
    final invoiceIndicators = [
      'invoice',
      'فاتورة',
      'bill to',
      'amount due',
      'payment terms',
      'tax invoice',
      'فاتورة ضريبية',
      'vat',
      'ضريبة القيمة المضافة',
    ];

    // Quotation indicators
    final quotationIndicators = [
      'quotation',
      'quote',
      'عرض سعر',
      'price offer',
      'valid until',
      'validity',
      'صلاحية العرض',
    ];

    // Purchase order indicators
    final poIndicators = [
      'purchase order',
      'p.o.',
      'أمر شراء',
      'order number',
      'delivery date',
      'ship to',
    ];

    // Report indicators
    final reportIndicators = [
      'report',
      'تقرير',
      'analysis',
      'summary',
      'findings',
      'conclusion',
      'ملخص',
    ];

    // Letter indicators
    final letterIndicators = [
      'dear',
      'sincerely',
      'regards',
      'تحية طيبة',
      'مع خالص التقدير',
      'to whom it may concern',
    ];

    // Contract indicators
    final contractIndicators = [
      'contract',
      'agreement',
      'عقد',
      'اتفاقية',
      'terms and conditions',
      'party',
      'الطرف الأول',
      'الطرف الثاني',
    ];

    // Receipt indicators
    final receiptIndicators = [
      'receipt',
      'إيصال',
      'received from',
      'payment received',
      'thank you for your purchase',
    ];

    // Resume indicators
    final resumeIndicators = [
      'resume',
      'cv',
      'curriculum vitae',
      'سيرة ذاتية',
      'experience',
      'education',
      'skills',
      'خبرات',
      'مهارات',
    ];

    // Certificate indicators
    final certificateIndicators = [
      'certificate',
      'شهادة',
      'certify',
      'awarded to',
      'this is to certify',
      'نشهد بأن',
    ];

    // Check each type
    if (_containsAny(lowerText, invoiceIndicators)) {
      return GeniusDocumentType.invoice;
    }
    if (_containsAny(lowerText, quotationIndicators)) {
      return GeniusDocumentType.quotation;
    }
    if (_containsAny(lowerText, poIndicators)) {
      return GeniusDocumentType.purchaseOrder;
    }
    if (_containsAny(lowerText, contractIndicators)) {
      return GeniusDocumentType.contract;
    }
    if (_containsAny(lowerText, receiptIndicators)) {
      return GeniusDocumentType.receipt;
    }
    if (_containsAny(lowerText, resumeIndicators)) {
      return GeniusDocumentType.resume;
    }
    if (_containsAny(lowerText, certificateIndicators)) {
      return GeniusDocumentType.certificate;
    }
    if (_containsAny(lowerText, reportIndicators)) {
      return GeniusDocumentType.report;
    }
    if (_containsAny(lowerText, letterIndicators)) {
      return GeniusDocumentType.letter;
    }

    return GeniusDocumentType.general;
  }

  bool _containsAny(String text, List<String> patterns) {
    return patterns.any((pattern) => text.contains(pattern));
  }

  List<String> extractKeywords(List<String> words) {
    // Common stop words to filter out
    const stopWords = {
      'the',
      'a',
      'an',
      'is',
      'are',
      'was',
      'were',
      'be',
      'been',
      'being',
      'have',
      'has',
      'had',
      'do',
      'does',
      'did',
      'will',
      'would',
      'could',
      'should',
      'may',
      'might',
      'must',
      'shall',
      'can',
      'need',
      'dare',
      'ought',
      'used',
      'to',
      'of',
      'in',
      'for',
      'on',
      'with',
      'at',
      'by',
      'from',
      'as',
      'into',
      'through',
      'during',
      'before',
      'after',
      'above',
      'below',
      'between',
      'under',
      'again',
      'further',
      'then',
      'once',
      'here',
      'there',
      'when',
      'where',
      'why',
      'how',
      'all',
      'each',
      'few',
      'more',
      'most',
      'other',
      'some',
      'such',
      'no',
      'nor',
      'not',
      'only',
      'own',
      'same',
      'so',
      'than',
      'too',
      'very',
      'just',
      'and',
      'but',
      'if',
      'or',
      'because',
      'until',
      'while',
      'this',
      'that',
      'these',
      'those',
      'it',
      'its',
      // Arabic stop words
      'من',
      'في',
      'على',
      'إلى',
      'عن',
      'مع',
      'هذا',
      'هذه',
      'ذلك',
      'تلك',
      'التي',
      'الذي',
      'هو',
      'هي',
      'أن',
      'كان',
      'كانت',
      'يكون',
      'تكون',
      'ما',
      'لا',
      'لم',
      'لن',
      'قد',
      'أو',
      'و',
      'ثم',
    };

    // Count word frequencies
    final wordCounts = <String, int>{};
    for (final word in words) {
      final normalizedWord = word.toLowerCase().replaceAll(RegExp(r'[^\w\u0600-\u06FF]'), '');
      if (normalizedWord.length >= minKeywordLength &&
          !stopWords.contains(normalizedWord)) {
        wordCounts[normalizedWord] = (wordCounts[normalizedWord] ?? 0) + 1;
      }
    }

    // Sort by frequency and take top keywords
    final sortedWords = wordCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sortedWords.take(maxKeywords).map((e) => e.key).toList();
  }

  GeniusStructuredData _extractStructuredData(String text) {
    return GeniusStructuredData(
      dates: _extractDates(text),
      amounts: _extractAmounts(text),
      emails: _extractEmails(text),
      phoneNumbers: _extractPhoneNumbers(text),
      referenceNumbers: _extractReferenceNumbers(text),
    );
  }

  List<String> _extractDates(String text) {
    final dates = <String>[];

    // Common date patterns
    final patterns = [
      // yyyy-mm-dd, yyyy/mm/dd
      RegExp(r'\b\d{4}[-/]\d{1,2}[-/]\d{1,2}\b'),
      // dd-mm-yyyy, dd/mm/yyyy
      RegExp(r'\b\d{1,2}[-/]\d{1,2}[-/]\d{4}\b'),
      // Month dd, yyyy
      RegExp(
          r'\b(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4}\b',
          caseSensitive: false),
      // dd Month yyyy
      RegExp(
          r'\b\d{1,2}\s+(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{4}\b',
          caseSensitive: false),
      // Arabic date format
      RegExp(
          r'\b\d{1,2}\s+(?:يناير|فبراير|مارس|أبريل|مايو|يونيو|يوليو|أغسطس|سبتمبر|أكتوبر|نوفمبر|ديسمبر)\s+\d{4}\b'),
    ];

    for (final pattern in patterns) {
      dates.addAll(pattern.allMatches(text).map((m) => m.group(0)!));
    }

    return dates.toSet().toList(); // Remove duplicates
  }

  List<GeniusMonetaryAmount> _extractAmounts(String text) {
    final amounts = <GeniusMonetaryAmount>[];

    // Currency patterns
    final patterns = [
      // SAR amount
      RegExp(r'(?:SAR|ر\.س\.?|ريال)\s*[\d,]+\.?\d*', caseSensitive: false),
      // USD amount
      RegExp(r'(?:\$|USD)\s*[\d,]+\.?\d*', caseSensitive: false),
      // EUR amount
      RegExp(r'(?:€|EUR)\s*[\d,]+\.?\d*', caseSensitive: false),
      // GBP amount
      RegExp(r'(?:£|GBP)\s*[\d,]+\.?\d*', caseSensitive: false),
      // Generic number with currency suffix
      RegExp(r'[\d,]+\.?\d*\s*(?:SAR|USD|EUR|GBP|ريال)', caseSensitive: false),
    ];

    for (final pattern in patterns) {
      for (final match in pattern.allMatches(text)) {
        final originalText = match.group(0)!;
        final numericPart = originalText.replaceAll(RegExp(r'[^\d.]'), '');
        final value = double.tryParse(numericPart);

        if (value != null && value > 0) {
          String? currency;
          if (originalText.toLowerCase().contains('sar') ||
              originalText.contains('ريال') ||
              originalText.contains('ر.س')) {
            currency = 'SAR';
          } else if (originalText.contains('\$') ||
              originalText.toLowerCase().contains('usd')) {
            currency = 'USD';
          } else if (originalText.contains('€') ||
              originalText.toLowerCase().contains('eur')) {
            currency = 'EUR';
          } else if (originalText.contains('£') ||
              originalText.toLowerCase().contains('gbp')) {
            currency = 'GBP';
          }

          amounts.add(GeniusMonetaryAmount(
            value: value,
            currency: currency,
            originalText: originalText,
          ));
        }
      }
    }

    return amounts;
  }

  List<String> _extractEmails(String text) {
    final pattern = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
    return pattern.allMatches(text).map((m) => m.group(0)!).toSet().toList();
  }

  List<String> _extractPhoneNumbers(String text) {
    final patterns = [
      // International format
      RegExp(r'\+?\d{1,3}[-.\s]?\(?\d{1,4}\)?[-.\s]?\d{1,4}[-.\s]?\d{1,9}'),
      // Saudi format
      RegExp(r'\b0?5\d{8}\b'),
      // Common formats
      RegExp(r'\b\d{3}[-.]?\d{3}[-.]?\d{4}\b'),
    ];

    final phones = <String>{};
    for (final pattern in patterns) {
      phones.addAll(pattern.allMatches(text).map((m) => m.group(0)!));
    }

    return phones.toList();
  }

  List<String> _extractReferenceNumbers(String text) {
    final patterns = [
      // Invoice numbers
      RegExp(r'(?:INV|Invoice|فاتورة)[#\-:\s]*([A-Z0-9\-]+)', caseSensitive: false),
      // Order numbers
      RegExp(r'(?:Order|PO|أمر)[#\-:\s]*([A-Z0-9\-]+)', caseSensitive: false),
      // Reference numbers
      RegExp(r'(?:Ref|Reference|مرجع)[#\-:\s]*([A-Z0-9\-]+)', caseSensitive: false),
      // Generic alphanumeric codes
      RegExp(r'\b[A-Z]{2,4}[-\s]?\d{4,10}\b'),
    ];

    final refs = <String>{};
    for (final pattern in patterns) {
      for (final match in pattern.allMatches(text)) {
        refs.add(match.group(1) ?? match.group(0)!);
      }
    }

    return refs.toList();
  }

  bool _checkForImages(PdfDocument document) {
    // Check if any page has images
    for (var i = 0; i < document.pages.count; i++) {
      final page = document.pages[i];
      // Check for image-related content in the page
      // This is a simplified check
      if (page.size.width > 0) {
        // More sophisticated image detection would require parsing page content
        return false; // Simplified - actual implementation would check page resources
      }
    }
    return false;
  }

  bool _checkForTables(String text) {
    // Check for table-like patterns
    // Multiple consecutive numbers/values separated by spaces
    final tablePattern = RegExp(r'(\d+[\.\,]?\d*\s+){3,}');
    return tablePattern.hasMatch(text);
  }

  bool _checkForLinks(String text) {
    final urlPattern = RegExp(r'https?://[^\s]+', caseSensitive: false);
    return urlPattern.hasMatch(text);
  }

  Map<String, String> _extractMetadata(PdfDocument document) {
    final metadata = <String, String>{};

    final info = document.documentInformation;
    if (info.title.isNotEmpty) metadata['title'] = info.title;
    if (info.author.isNotEmpty) metadata['author'] = info.author;
    if (info.subject.isNotEmpty) metadata['subject'] = info.subject;
    if (info.keywords.isNotEmpty) metadata['keywords'] = info.keywords;
    if (info.creator.isNotEmpty) metadata['creator'] = info.creator;
    if (info.producer.isNotEmpty) metadata['producer'] = info.producer;

    return metadata;
  }
}
