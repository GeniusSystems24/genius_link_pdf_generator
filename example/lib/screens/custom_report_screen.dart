import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../documents/custom_report_document.dart';
import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';

class CustomReportScreen extends StatefulWidget {
  const CustomReportScreen({super.key});

  @override
  State<CustomReportScreen> createState() => _CustomReportScreenState();
}

class _CustomReportScreenState extends State<CustomReportScreen> {
  final _formKey = GlobalKey<FormState>();

  // Report Settings
  String _reportTitle = 'Custom Report';
  String _reportTitleAr = 'تقرير مخصص';
  String _companyName = 'My Company';
  String _companyNameAr = 'شركتي';
  bool _isRtl = false;
  bool _includeHeader = true;
  bool _includeFooter = true;
  bool _includeLogo = false;

  // Components to include
  bool _includeInfoBox = true;
  bool _includeDataGrid = true;
  bool _includeRichText = true;
  bool _includeSummary = true;

  // Info Box Settings
  String _infoBoxTitle = 'Report Information';
  String _infoBoxContent = 'This is a custom generated report.';
  String _infoBoxStyleType = 'Card';

  // Data Grid Settings
  int _gridRows = 5;
  int _gridColumns = 4;
  bool _gridShowTotals = true;

  // Summary Settings
  double _subtotal = 1000.0;
  double _tax = 150.0;
  double _discount = 50.0;

  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      child: Column(
        children: [
          _buildHeader(isDark),
          Expanded(
            child: Form(
              key: _formKey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left panel - Settings
                  Expanded(
                    flex: 3,
                    child: _buildSettingsPanel(isDark),
                  ),
                  // Right panel - Preview/Components
                  Expanded(
                    flex: 2,
                    child: _buildComponentsPanel(isDark),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.purpleGradient),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.purpleGradient.first.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.design_services_rounded,
                color: Colors.white, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Custom Report Builder',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                Text(
                  'Design and generate custom PDF reports with configurable components',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          _buildHeaderButton(
            isDark: isDark,
            label: 'Reset',
            icon: Icons.refresh_rounded,
            gradient: AppColors.orangeGradient,
            onPressed: _resetForm,
          ),
          const SizedBox(width: 12),
          _buildHeaderButton(
            isDark: isDark,
            label: _isGenerating ? 'Generating...' : 'Generate PDF',
            icon: _isGenerating
                ? Icons.hourglass_empty_rounded
                : Icons.picture_as_pdf_rounded,
            gradient: AppColors.successGradient,
            onPressed: _isGenerating ? null : _generatePdf,
            isLoading: _isGenerating,
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({
    required bool isDark,
    required String label,
    required IconData icon,
    required List<Color> gradient,
    VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    final isEnabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: isEnabled ? LinearGradient(colors: gradient) : null,
            color: isEnabled
                ? null
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            borderRadius: BorderRadius.circular(12),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: gradient.first.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              if (isLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              else
                Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isEnabled
                      ? Colors.white
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsPanel(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 12, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.settings_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Report Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildSettingsSection(
                  isDark: isDark,
                  title: 'Report Information',
                  icon: Icons.article_rounded,
                  gradient: AppColors.primaryGradient,
                  children: [
                    _buildTextField(isDark, 'Report Title (English)',
                        _reportTitle, (v) => _reportTitle = v),
                    _buildTextField(isDark, 'Report Title (Arabic)',
                        _reportTitleAr, (v) => _reportTitleAr = v,
                        isRtl: true),
                    _buildTextField(isDark, 'Company Name (English)',
                        _companyName, (v) => _companyName = v),
                    _buildTextField(isDark, 'Company Name (Arabic)',
                        _companyNameAr, (v) => _companyNameAr = v,
                        isRtl: true),
                  ],
                ),
                const SizedBox(height: 20),
                _buildSettingsSection(
                  isDark: isDark,
                  title: 'Layout Options',
                  icon: Icons.view_quilt_rounded,
                  gradient: AppColors.cyanGradient,
                  children: [
                    _buildSwitchTile(
                        isDark,
                        'Right-to-Left (RTL)',
                        'Use Arabic as primary language',
                        _isRtl,
                        (v) => setState(() => _isRtl = v)),
                    _buildSwitchTile(
                        isDark,
                        'Include Header',
                        null,
                        _includeHeader,
                        (v) => setState(() => _includeHeader = v)),
                    _buildSwitchTile(
                        isDark,
                        'Include Footer',
                        null,
                        _includeFooter,
                        (v) => setState(() => _includeFooter = v)),
                    _buildSwitchTile(isDark, 'Include Logo Placeholder', null,
                        _includeLogo, (v) => setState(() => _includeLogo = v)),
                  ],
                ),
                if (_includeInfoBox) ...[
                  const SizedBox(height: 20),
                  _buildSettingsSection(
                    isDark: isDark,
                    title: 'Info Box Settings',
                    icon: Icons.info_rounded,
                    gradient: AppColors.purpleGradient,
                    children: [
                      _buildTextField(isDark, 'Info Box Title', _infoBoxTitle,
                          (v) => _infoBoxTitle = v),
                      _buildTextField(isDark, 'Info Box Content',
                          _infoBoxContent, (v) => _infoBoxContent = v,
                          maxLines: 3),
                      _buildDropdown(
                          isDark,
                          'Info Box Style',
                          _infoBoxStyleType,
                          ['Card', 'Highlighted', 'Header Content'],
                          (v) =>
                              setState(() => _infoBoxStyleType = v ?? 'Card')),
                    ],
                  ),
                ],
                if (_includeDataGrid) ...[
                  const SizedBox(height: 20),
                  _buildSettingsSection(
                    isDark: isDark,
                    title: 'Data Grid Settings',
                    icon: Icons.table_chart_rounded,
                    gradient: AppColors.orangeGradient,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: _buildNumberField(
                                isDark, 'Rows', _gridRows, (v) => _gridRows = v,
                                min: 1, max: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildNumberField(isDark, 'Columns',
                                _gridColumns, (v) => _gridColumns = v,
                                min: 1, max: 6),
                          ),
                        ],
                      ),
                      _buildSwitchTile(
                          isDark,
                          'Show Totals Row',
                          null,
                          _gridShowTotals,
                          (v) => setState(() => _gridShowTotals = v)),
                    ],
                  ),
                ],
                if (_includeSummary) ...[
                  const SizedBox(height: 20),
                  _buildSettingsSection(
                    isDark: isDark,
                    title: 'Summary Settings',
                    icon: Icons.calculate_rounded,
                    gradient: AppColors.successGradient,
                    children: [
                      _buildCurrencyField(
                          isDark, 'Subtotal', _subtotal, (v) => _subtotal = v),
                      _buildCurrencyField(
                          isDark, 'Tax Amount', _tax, (v) => _tax = v),
                      _buildCurrencyField(
                          isDark, 'Discount', _discount, (v) => _discount = v),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComponentsPanel(bool isDark) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 24, 24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.widgets_rounded,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Components',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Info Box',
                  description: 'Add information boxes',
                  icon: Icons.info_outline_rounded,
                  gradient: AppColors.purpleGradient,
                  value: _includeInfoBox,
                  onChanged: (v) => setState(() => _includeInfoBox = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Data Grid',
                  description: 'Add data table',
                  icon: Icons.table_rows_rounded,
                  gradient: AppColors.orangeGradient,
                  value: _includeDataGrid,
                  onChanged: (v) => setState(() => _includeDataGrid = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Rich Text',
                  description: 'Add styled text section',
                  icon: Icons.text_format_rounded,
                  gradient: AppColors.cyanGradient,
                  value: _includeRichText,
                  onChanged: (v) => setState(() => _includeRichText = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Summary',
                  description: 'Add summary section',
                  icon: Icons.summarize_rounded,
                  gradient: AppColors.successGradient,
                  value: _includeSummary,
                  onChanged: (v) => setState(() => _includeSummary = v),
                ),
                const SizedBox(height: 24),
                _buildPreviewCard(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required bool isDark,
    required String title,
    required IconData icon,
    required List<Color> gradient,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withValues(alpha: 0.2)
            : Colors.grey.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 16),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: children
                  .expand((w) => [w, const SizedBox(height: 12)])
                  .toList()
                ..removeLast(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    bool isDark,
    String label,
    String value,
    Function(String) onChanged, {
    bool isRtl = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
      ),
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      maxLines: maxLines,
      onChanged: onChanged,
      style: TextStyle(
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildNumberField(
    bool isDark,
    String label,
    int value,
    Function(int) onChanged, {
    int min = 0,
    int max = 100,
  }) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
      ),
      keyboardType: TextInputType.number,
      onChanged: (v) {
        final parsed = int.tryParse(v);
        if (parsed != null && parsed >= min && parsed <= max) {
          onChanged(parsed);
        }
      },
      style: TextStyle(
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildCurrencyField(
    bool isDark,
    String label,
    double value,
    Function(double) onChanged,
  ) {
    return TextFormField(
      initialValue: value.toString(),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
        prefixText: 'SAR ',
      ),
      keyboardType: TextInputType.number,
      onChanged: (v) {
        final parsed = double.tryParse(v);
        if (parsed != null) onChanged(parsed);
      },
      style: TextStyle(
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
    );
  }

  Widget _buildDropdown(
    bool isDark,
    String label,
    String value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: isDark ? AppColors.darkCard : Colors.white,
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      style: TextStyle(
        color: isDark ? AppColors.darkText : AppColors.lightText,
      ),
      dropdownColor: isDark ? AppColors.darkCard : Colors.white,
    );
  }

  Widget _buildSwitchTile(
    bool isDark,
    String title,
    String? subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryGradient.first,
          ),
        ],
      ),
    );
  }

  Widget _buildComponentToggle({
    required bool isDark,
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradient,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black.withValues(alpha: 0.2)
              : Colors.grey.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: value
                ? gradient.first.withValues(alpha: 0.5)
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
            width: value ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: value ? LinearGradient(colors: gradient) : null,
                color: value
                    ? null
                    : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: value
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              value
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: value
                  ? gradient.first
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard(bool isDark) {
    final total = _subtotal + _tax - _discount;
    final activeComponents = [
      if (_includeInfoBox) 'Info Box',
      if (_includeDataGrid) 'Data Grid',
      if (_includeRichText) 'Rich Text',
      if (_includeSummary) 'Summary',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.preview_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Preview Summary',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPreviewRow('Title', _isRtl ? _reportTitleAr : _reportTitle),
          _buildPreviewRow('Company', _isRtl ? _companyNameAr : _companyName),
          _buildPreviewRow(
              'Direction', _isRtl ? 'RTL (Arabic)' : 'LTR (English)'),
          _buildPreviewRow('Components', activeComponents.join(', ')),
          if (_includeSummary)
            _buildPreviewRow('Total', 'SAR ${total.toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildPreviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    setState(() {
      _reportTitle = 'Custom Report';
      _reportTitleAr = 'تقرير مخصص';
      _companyName = 'My Company';
      _companyNameAr = 'شركتي';
      _isRtl = false;
      _includeHeader = true;
      _includeFooter = true;
      _includeLogo = false;
      _includeInfoBox = true;
      _includeDataGrid = true;
      _includeRichText = true;
      _includeSummary = true;
      _infoBoxTitle = 'Report Information';
      _infoBoxContent = 'This is a custom generated report.';
      _infoBoxStyleType = 'Card';
      _gridRows = 5;
      _gridColumns = 4;
      _gridShowTotals = true;
      _subtotal = 1000.0;
      _tax = 150.0;
      _discount = 50.0;
    });
  }

  Future<void> _generatePdf() async {
    setState(() => _isGenerating = true);

    try {
      final Uint8List pdfBytes = await buildCustomReportPdf(
        CustomReportData(
          reportTitle: _reportTitle,
          reportTitleAr: _reportTitleAr,
          companyName: _companyName,
          companyNameAr: _companyNameAr,
          config: geniusPdfConfig.copyWith(
            baseFont: PdfTrueTypeFont(
                geniusPdfConfig.assets.primaryFont.toList(), 10),
            textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
          ),
          includeHeader: _includeHeader,
          includeFooter: _includeFooter,
          includeLogo: _includeLogo,
          includeInfoBox: _includeInfoBox,
          includeDataGrid: _includeDataGrid,
          includeRichText: _includeRichText,
          includeSummary: _includeSummary,
          infoBoxTitle: _infoBoxTitle,
          infoBoxContent: _infoBoxContent,
          infoBoxStyleType: _infoBoxStyleType,
          gridRows: _gridRows,
          gridColumns: _gridColumns,
          gridShowTotals: _gridShowTotals,
          subtotal: _subtotal,
          tax: _tax,
          discount: _discount,
        ),
      );

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filePath = '${directory.path}/custom_report_$timestamp.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdfBytes);

      // Open file
      await OpenFile.open(filePath);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved to: $filePath'),
            backgroundColor: AppColors.successGradient.first,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: AppColors.errorGradient.first,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }
}
