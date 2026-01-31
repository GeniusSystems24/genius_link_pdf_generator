import 'dart:io';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../documents/export_demo_document.dart';
import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';

/// Demo screen for multi-format export features.
class ExportDemoScreen extends StatefulWidget {
  const ExportDemoScreen({super.key});

  @override
  State<ExportDemoScreen> createState() => _ExportDemoScreenState();
}

class _ExportDemoScreenState extends State<ExportDemoScreen> {
  bool _isLoading = false;
  String _status = '';
  double _progress = 0;
  GeniusExportResult? _lastResult;
  PdfDocument? _sampleDocument;
  String? _lastFilePath;

  @override
  void initState() {
    super.initState();
    _createSampleDocument();
  }

  Future<void> _createSampleDocument() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating sample document...';
    });

    try {
      final document = await buildExportSampleDocument(geniusPdfConfig);

      setState(() {
        _sampleDocument = document;
        _isLoading = false;
        _status = 'Sample document ready';
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Error: $e';
      });
    }
  }

  Future<void> _exportTo(GeniusExportFormat format) async {
    if (_sampleDocument == null) return;

    setState(() {
      _isLoading = true;
      _progress = 0;
      _lastResult = null;
    });

    final service = GeniusPdfExportService();
    GeniusExportConfiguration config;

    switch (format) {
      case GeniusExportFormat.png:
        config = GeniusExportConfiguration.image(
          format: GeniusExportFormat.png,
          quality: GeniusImageQuality.high,
        );
        break;
      case GeniusExportFormat.jpeg:
        config = GeniusExportConfiguration.image(
          format: GeniusExportFormat.jpeg,
          quality: GeniusImageQuality.medium,
          jpegQuality: 85,
        );
        break;
      case GeniusExportFormat.html:
        config = GeniusExportConfiguration.html(
          embedImages: true,
          includeStyles: true,
        );
        break;
      case GeniusExportFormat.text:
        config = GeniusExportConfiguration.text();
        break;
      case GeniusExportFormat.pdfA:
        config = GeniusExportConfiguration.pdfA(
          compress: true,
        );
        break;
    }

    final result = await service.export(
      _sampleDocument!,
      config,
      onProgress: (progress) {
        setState(() {
          _progress = progress.progress;
          _status = progress.status;
        });
      },
    );

    String? filePath;
    if (result is GeniusExportSuccess && result.data.isNotEmpty) {
      try {
        final directory = await getApplicationDocumentsDirectory();
        // Use the proper extension from the format
        final extension = format.extension;
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        filePath = '${directory.path}/export_$timestamp.$extension';
        final file = File(filePath);
        await file.writeAsBytes(result.data);
      } catch (e) {
        filePath = null;
      }
    }

    setState(() {
      _isLoading = false;
      _lastResult = result;
      _lastFilePath = filePath;
      if (result is GeniusExportSuccess) {
        _status = 'Export complete! Size: ${result.fileSizeFormatted}';
      } else if (result is GeniusExportFailure) {
        _status = 'Export failed: ${result.message}';
      }
    });
  }

  Future<void> _openLastFile() async {
    if (_lastFilePath == null) return;
    try {
      await OpenFile.open(_lastFilePath!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to open file: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _batchExport() async {
    if (_sampleDocument == null) return;

    setState(() {
      _isLoading = true;
      _progress = 0;
      _lastResult = null;
    });

    final exporter = GeniusBatchExporter(maxConcurrent: 2);

    final result = await exporter.exportToMultipleFormats(
      _sampleDocument!,
      [
        GeniusExportFormat.png,
        GeniusExportFormat.html,
        GeniusExportFormat.text
      ],
      onProgress: (progress) {
        setState(() {
          _progress = progress.progress;
          _status = progress.status;
        });
      },
    );

    setState(() {
      _isLoading = false;
      _status = 'Batch export complete! '
          '${result.successCount}/${result.totalCount} successful '
          '(${result.duration.inMilliseconds}ms)';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;

        return Container(
          color: isDark ? AppColors.darkBg : AppColors.lightBg,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeaderCard(isDark),
              const SizedBox(height: 16),
              _buildStatusCard(isDark),
              const SizedBox(height: 20),
              _buildSectionTitle(isDark, 'Image Exports'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ExportCard(
                      isDark: isDark,
                      icon: Icons.image_rounded,
                      label: 'PNG',
                      sublabel: 'High quality',
                      gradient: AppColors.infoGradient,
                      onPressed: _sampleDocument != null && !_isLoading
                          ? () => _exportTo(GeniusExportFormat.png)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ExportCard(
                      isDark: isDark,
                      icon: Icons.photo_rounded,
                      label: 'JPEG',
                      sublabel: 'Compressed',
                      gradient: AppColors.orangeGradient,
                      onPressed: _sampleDocument != null && !_isLoading
                          ? () => _exportTo(GeniusExportFormat.jpeg)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(isDark, 'Document Exports'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ExportCard(
                      isDark: isDark,
                      icon: Icons.html_rounded,
                      label: 'HTML',
                      sublabel: 'Web format',
                      gradient: AppColors.purpleGradient,
                      onPressed: _sampleDocument != null && !_isLoading
                          ? () => _exportTo(GeniusExportFormat.html)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ExportCard(
                      isDark: isDark,
                      icon: Icons.text_snippet_rounded,
                      label: 'Text',
                      sublabel: 'Plain text',
                      gradient: AppColors.tealGradient,
                      onPressed: _sampleDocument != null && !_isLoading
                          ? () => _exportTo(GeniusExportFormat.text)
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _ExportCard(
                isDark: isDark,
                icon: Icons.archive_rounded,
                label: 'PDF/A (Archival)',
                sublabel: 'Long-term preservation',
                gradient: AppColors.successGradient,
                onPressed: _sampleDocument != null && !_isLoading
                    ? () => _exportTo(GeniusExportFormat.pdfA)
                    : null,
              ),
              const SizedBox(height: 20),
              _buildSectionTitle(isDark, 'Batch Export'),
              const SizedBox(height: 12),
              _ExportCard(
                isDark: isDark,
                icon: Icons.dynamic_feed_rounded,
                label: 'Export to All Formats',
                sublabel: 'PNG, HTML, Text',
                gradient: AppColors.primaryGradient,
                onPressed: _sampleDocument != null && !_isLoading
                    ? _batchExport
                    : null,
              ),
              const SizedBox(height: 20),
              if (_lastResult != null) ...[
                _buildSectionTitle(isDark, 'Last Export Result'),
                const SizedBox(height: 12),
                _buildResultCard(isDark),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.secondary.withOpacity(0.05)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.file_download_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Multi-Format Export',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Export PDFs to various formats including images, HTML, and archival formats.',
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _createSampleDocument,
            tooltip: 'Recreate Sample Document',
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _sampleDocument != null
                    ? Icons.check_circle_rounded
                    : Icons.pending_rounded,
                color:
                    _sampleDocument != null ? AppColors.success : AppColors.warning,
                size: 20,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _status.isEmpty ? 'Ready' : _status,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.primary,
                  ),
                ),
            ],
          ),
          if (_isLoading) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(_progress * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionTitle(bool isDark, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildResultCard(bool isDark) {
    if (_lastResult is GeniusExportSuccess) {
      final success = _lastResult as GeniusExportSuccess;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.success.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.success.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.success),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Export Successful',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),
                if (_lastFilePath != null)
                  IconButton(
                    icon: const Icon(Icons.open_in_new_rounded,
                        color: AppColors.primary),
                    onPressed: _openLastFile,
                    tooltip: 'Open File',
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _buildInfoRow(isDark, 'Format', success.format.displayName),
            _buildInfoRow(isDark, 'Pages', '${success.pageCount}'),
            _buildInfoRow(isDark, 'Size', success.fileSizeFormatted),
            if (_lastFilePath != null)
              _buildInfoRow(isDark, 'Path', _lastFilePath!),
          ],
        ),
      );
    } else if (_lastResult is GeniusExportFailure) {
      final failure = _lastResult as GeniusExportFailure;
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.error_rounded, color: AppColors.error),
                const SizedBox(width: 8),
                Text(
                  'Export Failed',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              failure.message,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildInfoRow(bool isDark, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 60,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _sampleDocument?.dispose();
    super.dispose();
  }
}

class _ExportCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final String label;
  final String sublabel;
  final List<Color> gradient;
  final VoidCallback? onPressed;

  const _ExportCard({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.gradient,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        gradient[0].withOpacity(0.2),
                        gradient[1].withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: gradient[0], size: 28),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: onPressed != null
                        ? (isDark ? AppColors.darkText : AppColors.lightText)
                        : (isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 2),
                Text(
                  sublabel,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
