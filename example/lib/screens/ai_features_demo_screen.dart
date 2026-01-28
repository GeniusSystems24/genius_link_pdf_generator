import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../theme/app_theme.dart';

/// Demo screen for AI Features (v2.1.0).
///
/// This screen demonstrates the AI-powered features:
/// - **Content Analyzer**: Extract text, detect document types, find structured data
/// - **Smart Layout**: Font size, margin, and spacing suggestions
/// - **Text Services**: Summarization, language detection, title generation
class AiFeaturesDemoScreen extends StatefulWidget {
  const AiFeaturesDemoScreen({super.key});

  @override
  State<AiFeaturesDemoScreen> createState() => _AiFeaturesDemoScreenState();
}

class _AiFeaturesDemoScreenState extends State<AiFeaturesDemoScreen> {
  bool _isLoading = false;
  String _status = '';
  int _selectedFeatureIndex = 0;

  final List<_AiFeature> _features = [
    _AiFeature(
      title: 'Content Analyzer',
      description: 'Extract text, detect document types, find keywords and structured data from PDF content',
      icon: Icons.analytics_outlined,
      gradient: AppColors.primaryGradient,
    ),
    _AiFeature(
      title: 'Smart Layout',
      description: 'Get intelligent layout suggestions for font sizes, margins, spacing, and color schemes',
      icon: Icons.auto_fix_high_outlined,
      gradient: AppColors.purpleGradient,
    ),
    _AiFeature(
      title: 'Text Services',
      description: 'Text summarization, language detection, and smart title generation',
      icon: Icons.text_fields_outlined,
      gradient: AppColors.cyanGradient,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isDark),
            const SizedBox(height: 16),
            _buildFeatureSelector(isDark),
            const SizedBox(height: 16),
            _buildSelectedFeatureCard(isDark),
            if (_status.isNotEmpty) ...[
              const SizedBox(height: 16),
              _buildResultsCard(isDark),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'AI Features',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Intelligent PDF analysis and optimization tools',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'v2.1.0',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureSelector(bool isDark) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _features.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final feature = _features[index];
          final isSelected = index == _selectedFeatureIndex;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedFeatureIndex = index;
                _status = '';
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 140,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: feature.gradient,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected
                    ? null
                    : (isDark ? AppColors.darkCard : AppColors.lightCard),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: feature.gradient.first.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    feature.icon,
                    color: isSelected
                        ? Colors.white
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                    size: 28,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    feature.title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkText : AppColors.lightText),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedFeatureCard(bool isDark) {
    final feature = _features[_selectedFeatureIndex];

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFeatureHeader(feature, isDark),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Demo Controls',
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                _buildFeatureActions(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureHeader(_AiFeature feature, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            feature.gradient.first.withOpacity(0.15),
            feature.gradient.last.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: feature.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              feature.icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature.title,
                  style: TextStyle(
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  feature.description,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureActions(bool isDark) {
    switch (_selectedFeatureIndex) {
      case 0:
        return _buildContentAnalyzerActions(isDark);
      case 1:
        return _buildSmartLayoutActions(isDark);
      case 2:
        return _buildTextServicesActions(isDark);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildContentAnalyzerActions(bool isDark) {
    return Column(
      children: [
        _buildActionButton(
          label: 'Analyze Sample Invoice',
          icon: Icons.receipt_long_outlined,
          gradient: AppColors.primaryGradient,
          onPressed: _analyzeInvoiceText,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Analyze Sample Report',
          icon: Icons.assessment_outlined,
          gradient: AppColors.infoGradient,
          onPressed: _analyzeReportText,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Extract Structured Data',
          icon: Icons.data_object_outlined,
          gradient: AppColors.successGradient,
          onPressed: _extractStructuredData,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildSmartLayoutActions(bool isDark) {
    return Column(
      children: [
        _buildActionButton(
          label: 'Analyze Font Sizes',
          icon: Icons.format_size_outlined,
          gradient: AppColors.purpleGradient,
          onPressed: _analyzeFontSizes,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Suggest Margins',
          icon: Icons.format_indent_increase_outlined,
          gradient: AppColors.cyanGradient,
          onPressed: _suggestMargins,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Suggest Color Scheme',
          icon: Icons.palette_outlined,
          gradient: AppColors.pinkGradient,
          onPressed: _suggestColorScheme,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Full Layout Optimization',
          icon: Icons.auto_awesome_outlined,
          gradient: AppColors.orangeGradient,
          onPressed: _optimizeLayout,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildTextServicesActions(bool isDark) {
    return Column(
      children: [
        _buildActionButton(
          label: 'Summarize Long Text',
          icon: Icons.summarize_outlined,
          gradient: AppColors.cyanGradient,
          onPressed: _summarizeText,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Detect Language',
          icon: Icons.translate_outlined,
          gradient: AppColors.tealGradient,
          onPressed: _detectLanguage,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Generate Titles',
          icon: Icons.title_outlined,
          gradient: AppColors.warningGradient,
          onPressed: _generateTitles,
          isDark: isDark,
        ),
        const SizedBox(height: 12),
        _buildActionButton(
          label: 'Extract Keywords',
          icon: Icons.key_outlined,
          gradient: AppColors.errorGradient,
          onPressed: _extractKeywords,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onPressed,
    required bool isDark,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradient,
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: gradient.first.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 22,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white.withOpacity(0.7),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(isDark ? 0.15 : 0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: AppColors.successGradient,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.check_circle_outline,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Analysis Results',
                    style: TextStyle(
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _status = '';
                    });
                  },
                  icon: Icon(
                    Icons.close,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkBg.withOpacity(0.5)
                    : AppColors.lightBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  width: 1,
                ),
              ),
              child: SelectableText(
                _status,
                style: TextStyle(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  fontSize: 13,
                  fontFamily: 'monospace',
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============ Content Analyzer Demos ============

  void _analyzeInvoiceText() {
    setState(() {
      _isLoading = true;
      _status = 'Analyzing invoice text...';
    });

    try {
      const invoiceText = '''
        INVOICE #INV-2026-001
        Date: January 24, 2026

        Bill To:
        Ahmed Mohamed
        Email: ahmed@example.com
        Phone: +966 50 123 4567

        Items:
        Product A - SAR 500.00
        Product B - SAR 750.00
        Service C - SAR 250.00

        Subtotal: SAR 1,500.00
        VAT (15%): SAR 225.00
        Total: SAR 1,725.00

        Payment Terms: Net 30 days
        Bank: Saudi National Bank
      ''';

      final analyzer = GeniusPdfContentAnalyzer();
      final detectedLanguages = ['en'];
      final keywords = analyzer.extractKeywords(
          invoiceText.split(' ').where((w) => w.length > 3).toList());

      final buffer = StringBuffer('INVOICE TEXT ANALYSIS\n');
      buffer.writeln('=' * 40);
      buffer.writeln('\nDetected Languages: ${detectedLanguages.join(", ")}');
      buffer.writeln('Detected Type: Invoice');
      buffer.writeln('\nKeywords:');
      for (final keyword in keywords.take(5)) {
        buffer.writeln('  - $keyword');
      }

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _analyzeReportText() {
    setState(() {
      _isLoading = true;
      _status = 'Analyzing report text...';
    });

    try {
      const reportText = '''
        Monthly Performance Report
        January 2026

        Executive Summary:
        This report provides a comprehensive overview of the company's performance metrics
        for January 2026. Revenue growth exceeded targets by 15%, while operational costs
        were reduced by 8% through automation initiatives.

        Key Findings:
        1. Total revenue reached SAR 2.5 million
        2. Customer satisfaction score: 92%
        3. New customer acquisition: 150 clients
        4. Employee retention rate: 95%

        Recommendations:
        Continue investment in customer service training and expand automation efforts
        to maintain operational efficiency gains.

        Contact: reports@company.com
      ''';

      final textServices = GeniusSmartTextServices();
      final summary = textServices.summarize(reportText, maxLength: 200);
      final language = textServices.detectLanguage(reportText);
      final keywords = textServices.extractKeywords(reportText, maxKeywords: 5);

      final buffer = StringBuffer('REPORT ANALYSIS\n');
      buffer.writeln('=' * 40);
      buffer.writeln(
          '\nLanguage: ${language.primaryLanguage} (${(language.confidence * 100).toStringAsFixed(0)}% confidence)');
      buffer.writeln('Is RTL: ${language.isRtl}');
      buffer.writeln(
          '\nSummary (${summary.compressionRatio * 100 ~/ 1}% compression):');
      buffer.writeln(summary.summary);
      buffer.writeln('\nKey Points:');
      for (final point in summary.keyPoints.take(3)) {
        buffer.writeln('  - $point');
      }
      buffer.writeln('\nKeywords: ${keywords.join(", ")}');

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _extractStructuredData() {
    setState(() {
      _isLoading = true;
      _status = 'Extracting structured data...';
    });

    try {
      const sampleText = '''
        Invoice #INV-2026-001
        Order Reference: PO-2026-5678
        Date: 2026-01-24
        Due Date: February 23, 2026

        Contact Information:
        Email: sales@example.com
        Phone: +966 12 345 6789
        Mobile: 0501234567

        Amounts:
        Subtotal: SAR 1,500.00
        VAT (15%): USD 225.00
        Discount: -\$50.00
        Total: 1,675.00
      ''';

      // Extract dates
      final datePatterns = [
        RegExp(r'\d{4}-\d{1,2}-\d{1,2}'),
        RegExp(
            r'(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},?\s+\d{4}',
            caseSensitive: false),
      ];

      final dates = <String>[];
      for (final pattern in datePatterns) {
        dates.addAll(pattern.allMatches(sampleText).map((m) => m.group(0)!));
      }

      // Extract emails
      final emailPattern =
          RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');
      final emails =
          emailPattern.allMatches(sampleText).map((m) => m.group(0)!).toList();

      // Extract phone numbers
      final phonePatterns = [
        RegExp(r'\+?\d{1,3}[-.\s]?\d{2,4}[-.\s]?\d{3}[-.\s]?\d{4}'),
        RegExp(r'\b0?5\d{8}\b'),
      ];

      final phones = <String>{};
      for (final pattern in phonePatterns) {
        phones.addAll(pattern.allMatches(sampleText).map((m) => m.group(0)!));
      }

      // Extract reference numbers
      final refPattern = RegExp(r'[A-Z]{2,4}[-\s]?\d{4}[-\s]?\d{0,6}');
      final refs =
          refPattern.allMatches(sampleText).map((m) => m.group(0)!).toList();

      final buffer = StringBuffer('EXTRACTED STRUCTURED DATA\n');
      buffer.writeln('=' * 40);
      buffer.writeln('\nDates: ${dates.join(", ")}');
      buffer.writeln('\nEmails: ${emails.join(", ")}');
      buffer.writeln('\nPhone Numbers: ${phones.join(", ")}');
      buffer.writeln('\nReference Numbers: ${refs.join(", ")}');

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ============ Smart Layout Demos ============

  void _analyzeFontSizes() {
    setState(() {
      _isLoading = true;
      _status = 'Analyzing font sizes...';
    });

    try {
      final layoutEngine = GeniusSmartLayoutEngine();

      final shortSuggestions = layoutEngine.analyzeFontSizes(
        contentLength: 500,
        pageSize: PdfPageSize.a4,
      );

      final longSuggestions = layoutEngine.analyzeFontSizes(
        contentLength: 10000,
        pageSize: PdfPageSize.a4,
        estimatedPages: 5,
      );

      final buffer = StringBuffer('FONT SIZE ANALYSIS\n');
      buffer.writeln('=' * 40);

      buffer.writeln('\nShort Content (500 chars):');
      for (final s in shortSuggestions) {
        buffer.writeln('  ${s.description}');
        buffer.writeln(
            '  Confidence: ${(s.confidence * 100).toStringAsFixed(0)}%');
        buffer.writeln('  Title: ${s.parameters['titleFontSize']}pt');
        buffer.writeln('  Body: ${s.parameters['bodyFontSize']}pt');
        buffer.writeln('  Header: ${s.parameters['headerFontSize']}pt');
      }

      buffer.writeln('\nLong Content (10,000 chars):');
      for (final s in longSuggestions) {
        buffer.writeln('  ${s.description}');
        buffer.writeln(
            '  Confidence: ${(s.confidence * 100).toStringAsFixed(0)}%');
        buffer.writeln('  Title: ${s.parameters['titleFontSize']}pt');
        buffer.writeln('  Body: ${s.parameters['bodyFontSize']}pt');
        buffer.writeln('  Header: ${s.parameters['headerFontSize']}pt');
      }

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _suggestMargins() {
    setState(() {
      _isLoading = true;
      _status = 'Analyzing margins...';
    });

    try {
      final layoutEngine = GeniusSmartLayoutEngine(optimizeForPrint: true);

      final elementsWithTable = [
        const GeniusLayoutElement(
          type: GeniusLayoutElementType.header,
          bounds: Rect.fromLTWH(0, 0, 500, 50),
        ),
        const GeniusLayoutElement(
          type: GeniusLayoutElementType.table,
          bounds: Rect.fromLTWH(0, 60, 500, 200),
        ),
      ];

      final elementsSimple = [
        const GeniusLayoutElement(
          type: GeniusLayoutElementType.header,
          bounds: Rect.fromLTWH(0, 0, 500, 50),
        ),
        const GeniusLayoutElement(
          type: GeniusLayoutElementType.paragraph,
          bounds: Rect.fromLTWH(0, 60, 500, 100),
        ),
      ];

      final tableSuggestion = layoutEngine.suggestMargins(
        elements: elementsWithTable,
        pageSize: PdfPageSize.a4,
      );

      final simpleSuggestion = layoutEngine.suggestMargins(
        elements: elementsSimple,
        pageSize: PdfPageSize.a4,
      );

      final buffer = StringBuffer('MARGIN SUGGESTIONS\n');
      buffer.writeln('=' * 40);

      buffer.writeln('\nDocument with Table:');
      buffer.writeln('  ${tableSuggestion.description}');
      buffer.writeln('  Left: ${tableSuggestion.parameters['left']}pt');
      buffer.writeln('  Top: ${tableSuggestion.parameters['top']}pt');
      buffer.writeln('  Right: ${tableSuggestion.parameters['right']}pt');
      buffer.writeln('  Bottom: ${tableSuggestion.parameters['bottom']}pt');

      buffer.writeln('\nSimple Document:');
      buffer.writeln('  ${simpleSuggestion.description}');
      buffer.writeln('  Left: ${simpleSuggestion.parameters['left']}pt');
      buffer.writeln('  Top: ${simpleSuggestion.parameters['top']}pt');
      buffer.writeln('  Right: ${simpleSuggestion.parameters['right']}pt');
      buffer.writeln('  Bottom: ${simpleSuggestion.parameters['bottom']}pt');

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _suggestColorScheme() {
    setState(() {
      _isLoading = true;
      _status = 'Suggesting color schemes...';
    });

    try {
      final layoutEngine = GeniusSmartLayoutEngine();

      final documentTypes = ['invoice', 'report', 'certificate', 'general'];
      final buffer = StringBuffer('COLOR SCHEME SUGGESTIONS\n');
      buffer.writeln('=' * 40);

      for (final docType in documentTypes) {
        final suggestion =
            layoutEngine.suggestColorScheme(documentType: docType);
        buffer.writeln('\n${docType.toUpperCase()}:');
        buffer.writeln('  ${suggestion.description}');
        buffer.writeln('  Arabic: ${suggestion.descriptionAr}');
        buffer.writeln(
            '  Confidence: ${(suggestion.confidence * 100).toStringAsFixed(0)}%');
      }

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _optimizeLayout() {
    setState(() {
      _isLoading = true;
      _status = 'Optimizing layout...';
    });

    try {
      final layoutEngine = GeniusSmartLayoutEngine(isRtl: false);

      final elements = [
        const GeniusLayoutElement(
          type: GeniusLayoutElementType.header,
          bounds: Rect.fromLTWH(0, 0, 500, 40),
          content: 'Monthly Report',
        ),
        const GeniusLayoutElement(
          type: GeniusLayoutElementType.paragraph,
          bounds: Rect.fromLTWH(0, 50, 500, 80),
          content:
              'This is a sample paragraph with medium-length content for demonstration purposes.',
        ),
        const GeniusLayoutElement(
          type: GeniusLayoutElementType.table,
          bounds: Rect.fromLTWH(0, 140, 500, 150),
        ),
        const GeniusLayoutElement(
          type: GeniusLayoutElementType.summary,
          bounds: Rect.fromLTWH(0, 300, 500, 60),
        ),
      ];

      final optimized = layoutEngine.optimizeLayout(elements: elements);

      final buffer = StringBuffer('LAYOUT OPTIMIZATION RESULTS\n');
      buffer.writeln('=' * 40);
      buffer.writeln('\nEstimated Pages: ${optimized.estimatedPages}');
      buffer.writeln(
          'Page Size: ${optimized.pageSize.width.toStringAsFixed(0)} x ${optimized.pageSize.height.toStringAsFixed(0)}');
      buffer.writeln('\nSuggestions (${optimized.suggestions.length}):');

      for (final suggestion in optimized.suggestions.take(5)) {
        buffer
            .writeln('  - ${suggestion.type.name}: ${suggestion.description}');
      }

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ============ Text Services Demos ============

  void _summarizeText() {
    setState(() {
      _isLoading = true;
      _status = 'Summarizing text...';
    });

    try {
      const longText = '''
        The quarterly financial report reveals significant growth across all major business segments.
        Revenue increased by 23% compared to the same period last year, driven primarily by strong
        performance in the technology and services divisions. The company successfully launched three
        new products during this quarter, all of which exceeded initial sales projections.

        Operating expenses were carefully managed, resulting in a 15% improvement in operational
        efficiency. The implementation of new automation systems contributed to reduced labor costs
        while maintaining high-quality standards. Customer satisfaction scores reached an all-time
        high of 94%, reflecting the company's commitment to excellence.

        Looking forward, the company plans to expand into two new international markets and
        increase investment in research and development. The board of directors has approved
        a new strategic initiative to enhance digital transformation capabilities. This
        initiative is expected to yield significant returns over the next three years.

        In conclusion, the company's strong performance this quarter positions it well for
        continued growth and success in the coming fiscal year.
      ''';

      final textServices = GeniusSmartTextServices();
      final summary =
          textServices.summarize(longText, maxLength: 300, keyPointCount: 4);

      final buffer = StringBuffer('TEXT SUMMARIZATION\n');
      buffer.writeln('=' * 40);
      buffer.writeln('\nOriginal: ${summary.originalLength} characters');
      buffer.writeln('Summary: ${summary.summaryLength} characters');
      buffer.writeln(
          'Compression: ${(summary.compressionRatio * 100).toStringAsFixed(1)}%');
      buffer.writeln('\nSummary:');
      buffer.writeln(summary.summary);
      buffer.writeln('\nKey Points:');
      for (var i = 0; i < summary.keyPoints.length; i++) {
        buffer.writeln('  ${i + 1}. ${summary.keyPoints[i]}');
      }

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _detectLanguage() {
    setState(() {
      _isLoading = true;
      _status = 'Detecting languages...';
    });

    try {
      final textServices = GeniusSmartTextServices();

      final samples = {
        'English':
            'This is a sample text in English for language detection testing.',
        'Arabic': 'هذا نص عربي لاختبار اكتشاف اللغة بشكل تلقائي.',
        'Mixed':
            'Welcome مرحباً to our service خدمتنا for all customers الجميع.',
      };

      final buffer = StringBuffer('LANGUAGE DETECTION RESULTS\n');
      buffer.writeln('=' * 40);

      for (final entry in samples.entries) {
        final result = textServices.detectLanguage(entry.value);
        buffer.writeln('\n${entry.key}:');
        buffer.writeln(
            '  Primary: ${result.primaryLanguage} (${textServices.getLanguageName(result.primaryLanguage)})');
        buffer.writeln(
            '  Confidence: ${(result.confidence * 100).toStringAsFixed(0)}%');
        buffer.writeln('  Is RTL: ${result.isRtl}');
        if (result.detectedLanguages.length > 1) {
          buffer.writeln('  Other languages:');
          for (final lang in result.detectedLanguages.skip(1)) {
            buffer.writeln(
                '    - ${lang.languageName}: ${(lang.score * 100).toStringAsFixed(0)}%');
          }
        }
      }

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _generateTitles() {
    setState(() {
      _isLoading = true;
      _status = 'Generating titles...';
    });

    try {
      final textServices = GeniusSmartTextServices();

      const sampleText = '''
        Invoice for consulting services provided during January 2026.
        Services included software development, system integration, and training.
        Total amount: SAR 15,000 payable within 30 days.
      ''';

      final titles = textServices.generateTitles(sampleText, maxSuggestions: 3);

      final buffer = StringBuffer('GENERATED TITLE SUGGESTIONS\n');
      buffer.writeln('=' * 40);

      for (var i = 0; i < titles.length; i++) {
        final title = titles[i];
        buffer.writeln('\n${i + 1}. "${title.title}"');
        if (title.titleAr != null) {
          buffer.writeln('   Arabic: "${title.titleAr}"');
        }
        buffer.writeln(
            '   Confidence: ${(title.confidence * 100).toStringAsFixed(0)}%');
        if (title.keywords.isNotEmpty) {
          buffer.writeln('   Based on: ${title.keywords.take(3).join(", ")}');
        }
      }

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _extractKeywords() {
    setState(() {
      _isLoading = true;
      _status = 'Extracting keywords...';
    });

    try {
      final textServices = GeniusSmartTextServices();

      const sampleText = '''
        Cloud computing has revolutionized the technology industry. Companies are increasingly
        adopting cloud solutions for scalability, flexibility, and cost efficiency. Major
        providers like Amazon Web Services, Microsoft Azure, and Google Cloud Platform offer
        comprehensive services including computing, storage, database, and machine learning
        capabilities. The shift to cloud infrastructure enables businesses to innovate faster
        and respond to market changes more effectively.
      ''';

      final keywords =
          textServices.extractKeywords(sampleText, maxKeywords: 10);

      final buffer = StringBuffer('EXTRACTED KEYWORDS\n');
      buffer.writeln('=' * 40);

      for (var i = 0; i < keywords.length; i++) {
        buffer.writeln('\n${i + 1}. ${keywords[i]}');
      }

      setState(() {
        _status = buffer.toString();
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

/// AI Feature model for the feature selector
class _AiFeature {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  const _AiFeature({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
