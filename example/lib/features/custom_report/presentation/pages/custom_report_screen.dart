import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart' show geniusPdfConfig;
import 'package:genius_pdf_example/app/theme/app_theme.dart';

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
  bool _includeLogo = true;
  bool _includeReportHeader = true;
  bool _includeWatermark = true;
  bool _includeDigitalSignature = true;
  bool _includeSignatureArea = true;

  // Components to include
  bool _includeInfoBox = true;
  bool _includeDataGrid = true;
  bool _includeRichText = true;
  bool _includeSummary = true;
  bool _includeBulletList = true;
  bool _includeTwoColumns = true;
  bool _includeQrCode = true;
  bool _includeBarcode = true;
  bool _includeImages = true;
  bool _includeAttachments = true;

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
                  'Genius PDF Showcase',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                Text(
                  'A professional end-to-end demo that uses every library component',
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
            label: _isGenerating ? 'Generating...' : 'Generate & Preview',
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
                  'Showcase Components',
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
                _buildPanelSectionLabel(isDark, 'Core Blocks'),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Report Header',
                  description: 'Company header component',
                  icon: Icons.view_stream_rounded,
                  gradient: AppColors.primaryGradient,
                  value: _includeReportHeader,
                  onChanged: (v) => setState(() => _includeReportHeader = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Rich Text',
                  description: 'Styled text and badges',
                  icon: Icons.text_format_rounded,
                  gradient: AppColors.cyanGradient,
                  value: _includeRichText,
                  onChanged: (v) => setState(() => _includeRichText = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Info Box',
                  description: 'Labeled information blocks',
                  icon: Icons.info_outline_rounded,
                  gradient: AppColors.purpleGradient,
                  value: _includeInfoBox,
                  onChanged: (v) => setState(() => _includeInfoBox = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Bullet List',
                  description: 'Structured highlights list',
                  icon: Icons.format_list_bulleted_rounded,
                  gradient: AppColors.tealGradient,
                  value: _includeBulletList,
                  onChanged: (v) => setState(() => _includeBulletList = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Two Columns',
                  description: 'Side-by-side layout blocks',
                  icon: Icons.view_column_rounded,
                  gradient: AppColors.infoGradient,
                  value: _includeTwoColumns,
                  onChanged: (v) => setState(() => _includeTwoColumns = v),
                ),
                const SizedBox(height: 20),
                _buildPanelSectionLabel(isDark, 'Data & Totals'),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Data Grid',
                  description: 'Tabular data with totals',
                  icon: Icons.table_rows_rounded,
                  gradient: AppColors.orangeGradient,
                  value: _includeDataGrid,
                  onChanged: (v) => setState(() => _includeDataGrid = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Summary',
                  description: 'Totals and calculations',
                  icon: Icons.summarize_rounded,
                  gradient: AppColors.successGradient,
                  value: _includeSummary,
                  onChanged: (v) => setState(() => _includeSummary = v),
                ),
                const SizedBox(height: 20),
                _buildPanelSectionLabel(isDark, 'Verification'),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'QR Code',
                  description: 'Scan to verify',
                  icon: Icons.qr_code_2_rounded,
                  gradient: AppColors.primaryGradient,
                  value: _includeQrCode,
                  onChanged: (v) => setState(() => _includeQrCode = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Barcode',
                  description: 'Tracking barcode',
                  icon: Icons.line_axis_rounded,
                  gradient: AppColors.warningGradient,
                  value: _includeBarcode,
                  onChanged: (v) => setState(() => _includeBarcode = v),
                ),
                const SizedBox(height: 20),
                _buildPanelSectionLabel(isDark, 'Branding & Assets'),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Images',
                  description: 'Logo and branding',
                  icon: Icons.image_rounded,
                  gradient: AppColors.pinkGradient,
                  value: _includeImages,
                  onChanged: (v) => setState(() => _includeImages = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Attachments',
                  description: 'Image attachments pages',
                  icon: Icons.attachment_rounded,
                  gradient: AppColors.tealGradient,
                  value: _includeAttachments,
                  onChanged: (v) => setState(() => _includeAttachments = v),
                ),
                const SizedBox(height: 20),
                _buildPanelSectionLabel(isDark, 'Security'),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Watermark',
                  description: 'Document watermark',
                  icon: Icons.water_drop_rounded,
                  gradient: AppColors.infoGradient,
                  value: _includeWatermark,
                  onChanged: (v) => setState(() => _includeWatermark = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Digital Signature',
                  description: 'Signature placeholder',
                  icon: Icons.verified_rounded,
                  gradient: AppColors.successGradient,
                  value: _includeDigitalSignature,
                  onChanged: (v) =>
                      setState(() => _includeDigitalSignature = v),
                ),
                const SizedBox(height: 12),
                _buildComponentToggle(
                  isDark: isDark,
                  title: 'Signature Area',
                  description: 'Manual signature blocks',
                  icon: Icons.draw_rounded,
                  gradient: AppColors.orangeGradient,
                  value: _includeSignatureArea,
                  onChanged: (v) => setState(() => _includeSignatureArea = v),
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
      initialValue: value,
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
            activeThumbColor: AppColors.primaryGradient.first,
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

  Widget _buildPanelSectionLabel(bool isDark, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: isDark
              ? AppColors.darkTextSecondary
              : AppColors.lightTextSecondary,
        ),
      ),
    );
  }

  Widget _buildPreviewCard(bool isDark) {
    final total = _subtotal + _tax - _discount;
    final activeComponents = [
      if (_includeReportHeader) 'Report Header',
      if (_includeRichText) 'Rich Text',
      if (_includeInfoBox) 'Info Box',
      if (_includeBulletList) 'Bullet List',
      if (_includeTwoColumns) 'Two Columns',
      if (_includeDataGrid) 'Data Grid',
      if (_includeSummary) 'Summary',
      if (_includeQrCode) 'QR Code',
      if (_includeBarcode) 'Barcode',
      if (_includeImages) 'Images',
      if (_includeAttachments) 'Attachments',
      if (_includeWatermark) 'Watermark',
      if (_includeDigitalSignature) 'Digital Signature',
      if (_includeSignatureArea) 'Signature Area',
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
          _buildPreviewRow(
              'Header/Footer',
              '${_includeHeader ? "On" : "Off"} / ${_includeFooter ? "On" : "Off"}'),
          _buildPreviewRow(
              'Security',
              (_includeWatermark || _includeDigitalSignature)
                  ? 'Enabled'
                  : 'Off'),
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

  GeniusPdfImage? _buildDemoLogo(GeniusPdfConfig config) {
    final bytes = config.assets.logo;
    if (bytes == null) return null;
    return GeniusPdfImage(data: bytes, width: 120, height: 120);
  }

  GeniusPdfImage? _buildDemoHeader(GeniusPdfConfig config) {
    final bytes = config.assets.headerImage;
    if (bytes == null) return null;
    return GeniusPdfImage(data: bytes, width: 800, height: 120);
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
      _includeLogo = true;
      _includeReportHeader = true;
      _includeWatermark = true;
      _includeDigitalSignature = true;
      _includeSignatureArea = true;
      _includeInfoBox = true;
      _includeDataGrid = true;
      _includeRichText = true;
      _includeSummary = true;
      _includeBulletList = true;
      _includeTwoColumns = true;
      _includeQrCode = true;
      _includeBarcode = true;
      _includeImages = true;
      _includeAttachments = true;
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
      final config = geniusPdfConfig.copyWith(
        baseFont:
            PdfTrueTypeFont(geniusPdfConfig.assets.primaryFont.toList(), 10),
        textDirection: _isRtl ? TextDirection.rtl : TextDirection.ltr,
      );

      final options = _ShowcaseReportOptions(
        reportTitle: _reportTitle,
        reportTitleAr: _reportTitleAr,
        companyName: _companyName,
        companyNameAr: _companyNameAr,
        includeHeader: _includeHeader,
        includeFooter: _includeFooter,
        includeLogo: _includeLogo,
        includeReportHeader: _includeReportHeader,
        includeInfoBox: _includeInfoBox,
        includeDataGrid: _includeDataGrid,
        includeRichText: _includeRichText,
        includeSummary: _includeSummary,
        includeBulletList: _includeBulletList,
        includeTwoColumns: _includeTwoColumns,
        includeQrCode: _includeQrCode,
        includeBarcode: _includeBarcode,
        includeImages: _includeImages,
        includeAttachments: _includeAttachments,
        includeWatermark: _includeWatermark,
        includeDigitalSignature: _includeDigitalSignature,
        includeSignatureArea: _includeSignatureArea,
        infoBoxTitle: _infoBoxTitle,
        infoBoxContent: _infoBoxContent,
        infoBoxStyleType: _infoBoxStyleType,
        gridRows: _gridRows,
        gridColumns: _gridColumns,
        gridShowTotals: _gridShowTotals,
        subtotal: _subtotal,
        tax: _tax,
        discount: _discount,
        logoImage: _buildDemoLogo(config),
        headerImage: _buildDemoHeader(config),
      );

      final builder = _ShowcaseReportBuilder(config: config, options: options);
      final pdfBytes = Uint8List.fromList(builder.generate());
      builder.dispose();

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => GeniusPdfPreviewPage(
            title: _isRtl ? 'عرض تجريبي' : 'Showcase Report',
            pdfData: pdfBytes,
            allowDownload: true,
            allowPrinting: true,
            allowSharing: true,
          ),
        ),
      );
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

class _ShowcaseReportOptions {
  const _ShowcaseReportOptions({
    required this.reportTitle,
    required this.reportTitleAr,
    required this.companyName,
    required this.companyNameAr,
    required this.includeHeader,
    required this.includeFooter,
    required this.includeLogo,
    required this.includeReportHeader,
    required this.includeInfoBox,
    required this.includeDataGrid,
    required this.includeRichText,
    required this.includeSummary,
    required this.includeBulletList,
    required this.includeTwoColumns,
    required this.includeQrCode,
    required this.includeBarcode,
    required this.includeImages,
    required this.includeAttachments,
    required this.includeWatermark,
    required this.includeDigitalSignature,
    required this.includeSignatureArea,
    required this.infoBoxTitle,
    required this.infoBoxContent,
    required this.infoBoxStyleType,
    required this.gridRows,
    required this.gridColumns,
    required this.gridShowTotals,
    required this.subtotal,
    required this.tax,
    required this.discount,
    required this.logoImage,
    required this.headerImage,
  });

  final String reportTitle;
  final String reportTitleAr;
  final String companyName;
  final String companyNameAr;
  final bool includeHeader;
  final bool includeFooter;
  final bool includeLogo;
  final bool includeReportHeader;
  final bool includeInfoBox;
  final bool includeDataGrid;
  final bool includeRichText;
  final bool includeSummary;
  final bool includeBulletList;
  final bool includeTwoColumns;
  final bool includeQrCode;
  final bool includeBarcode;
  final bool includeImages;
  final bool includeAttachments;
  final bool includeWatermark;
  final bool includeDigitalSignature;
  final bool includeSignatureArea;
  final String infoBoxTitle;
  final String infoBoxContent;
  final String infoBoxStyleType;
  final int gridRows;
  final int gridColumns;
  final bool gridShowTotals;
  final double subtotal;
  final double tax;
  final double discount;
  final GeniusPdfImage? logoImage;
  final GeniusPdfImage? headerImage;
}

class _ShowcaseReportBuilder extends GeniusPdfDocumentBuilder {
  _ShowcaseReportBuilder({
    required GeniusPdfConfig config,
    required this.options,
  }) : super(config);

  final _ShowcaseReportOptions options;

  @override
  void build() {
    final now = DateTime.now();

    if (options.includeHeader) {
      addHeader(
        image: options.includeLogo ? options.headerImage : null,
        title: isRTL ? options.reportTitleAr : options.reportTitle,
        backgroundColor: const Color(0xFFF1F5F9),
      );
    }

    if (options.includeFooter) {
      addFooter(
        userName: isRTL ? options.companyNameAr : options.companyName,
        userLabel: isRTL ? 'أنشئ بواسطة: ' : 'Generated by: ',
        printTime: isRTL ? 'الطباعة: ${_fmtDate(now)}' : 'Printed: ${_fmtDate(now)}',
        showPageNumber: true,
        qrCodeUrl: options.includeQrCode ? 'https://genius.systems/demo' : null,
      );
    }

    _buildReportHeader(now);
    _buildOverview();
    _buildKpiColumns();
    _buildDataGrid();
    _buildHighlights();
    _buildVerification();
    _buildBranding();
    _buildSummary();
    _buildSignatures();

    if (options.includeWatermark) {
      document.addWatermark(
        GeniusPdfWatermark.draft(
          text: isRTL ? 'نسخة تجريبية' : 'DEMO',
          opacity: 0.12,
          config: config,
        ),
      );
    }

    if (options.includeDigitalSignature) {
      final signature = GeniusPdfDigitalSignature(
        config: config,
        settings: GeniusDigitalSignatureSettings(
          signerName: isRTL ? 'مدير المالية' : 'Finance Manager',
          reason: isRTL ? 'اعتماد التقرير' : 'Report Approval',
          location: isRTL ? 'الرياض' : 'Riyadh',
          appearance: const GeniusSignatureAppearance(),
        ),
      );
      signature.addToDocument(document);
    }
  }

  void _buildReportHeader(DateTime now) {
    if (!options.includeReportHeader) {
      addLine(isRTL ? options.reportTitleAr : options.reportTitle,
          font: config.headerFont, topMargin: 0);
      addSpace(8);
      return;
    }

    final company = GeniusPdfCompanyInfo(
      name: options.companyName,
      nameAr: options.companyNameAr,
      address: 'Riyadh, Saudi Arabia',
      addressAr: 'الرياض، المملكة العربية السعودية',
      phone: '+966 11 123 4567',
      vatNumber: '300000000000003',
      logo: options.includeLogo ? options.logoImage : null,
    );

    final header = GeniusPdfReportHeader(
      title: options.reportTitle,
      titleAr: options.reportTitleAr,
      subtitle: isRTL ? 'عرض تجريبي احترافي' : 'Professional Showcase',
      subtitleAr: 'عرض تجريبي احترافي',
      secondarySubtitle: isRTL ? 'نطاق الربع الأول 2026' : 'Q1 2026 Coverage',
      secondarySubtitleAr: 'نطاق الربع الأول 2026',
      company: company,
      printDate: now,
      config: config,
      style: const GeniusPdfReportHeaderStyle.modern(),
      layout: GeniusPdfReportHeaderLayout.bilingualSplit,
      showPageNumber: options.includeFooter,
    );

    addReportHeader(header, height: 120, spacing: 8);
  }

  void _buildOverview() {
    if (!options.includeRichText && !options.includeInfoBox) return;
    _sectionTitle('Executive Overview', 'الملخص التنفيذي');

    if (options.includeRichText) {
      final total = options.subtotal + options.tax - options.discount;
      final rich = GeniusPdfRichTextBuilder(
        config: config,
        paragraphAlignment: GeniusPdfParagraphAlignment.start,
      )
          .bold(isRTL ? 'عرض مكتمل: ' : 'Complete Demo: ',
              color: const Color(0xFF1E293B))
          .text(isRTL
              ? 'هذا التقرير يعرض قدرات المكتبة بالكامل مع مكونات قابلة لإعادة الاستخدام.'
              : 'This report showcases all library components with reusable building blocks.')
          .text(' ')
          .badge('v3.x',
              backgroundColor: const Color(0xFF6366F1),
              color: Colors.white)
          .text(' ')
          .currency(
            _fmtNumber(total),
            symbol: 'SAR',
            color: const Color(0xFF10B981),
          )
          .build();

      addRichText(rich, spacing: 0);
      addSpace(8);
    }

    if (options.includeInfoBox) {
      final infoBox = GeniusPdfInfoBox(
        config: config,
        title: options.infoBoxTitle,
        titleAr: 'معلومات التقرير',
        items: [
          GeniusPdfLabeledValue(
            config: config,
            label: 'Report ID',
            labelAr: 'رقم التقرير',
            value: 'GL-2026-001',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Prepared By',
            labelAr: 'أعد بواسطة',
            value: isRTL ? 'فريق التقارير' : 'Reporting Team',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Status',
            labelAr: 'الحالة',
            value: isRTL ? 'قابل للمراجعة' : 'Ready for Review',
          ),
          GeniusPdfLabeledValue(
            config: config,
            label: 'Scope',
            labelAr: 'النطاق',
            value: isRTL ? 'عمليات متعددة' : 'Multi-department',
          ),
        ],
        style: _resolveInfoBoxStyle(options.infoBoxStyleType),
        columns: 2,
      );

      addInfoBox(infoBox, spacing: 0);
      addSpace(8);
    }
  }

  void _buildKpiColumns() {
    if (!options.includeTwoColumns) return;
    _sectionTitle('Key Metrics', 'المؤشرات الرئيسية');

    addTwoColumns(
      spacing: 4,
      gap: 12,
      leftContent: (page, bounds) {
        final box = GeniusPdfInfoBox(
          config: config,
          title: isRTL ? 'مؤشرات الأداء' : 'Performance KPIs',
          titleAr: 'مؤشرات الأداء',
          items: [
            GeniusPdfLabeledValue(
              config: config,
              label: 'Growth',
              labelAr: 'النمو',
              value: '+18.4%',
            ),
            GeniusPdfLabeledValue(
              config: config,
              label: 'Efficiency',
              labelAr: 'الكفاءة',
              value: '92%',
            ),
            GeniusPdfLabeledValue(
              config: config,
              label: 'Risk',
              labelAr: 'المخاطر',
              value: isRTL ? 'منخفض' : 'Low',
            ),
          ],
          style: const GeniusPdfInfoBoxStyle.highlighted(),
          columns: 1,
        );
        return box.draw(page: page, bounds: bounds).height;
      },
      rightContent: (page, bounds) {
        final summary = GeniusPdfSummarySection(
          config: config,
          title: isRTL ? 'الملخص السريع' : 'Quick Summary',
          titleAr: 'الملخص السريع',
          items: [
            GeniusPdfSummaryItem.subtotal(
              label: 'Operating Income',
              labelAr: 'الدخل التشغيلي',
              value: 'SAR 1,250,000',
            ),
            GeniusPdfSummaryItem.positive(
              label: 'Net Margin',
              labelAr: 'الهامش الصافي',
              value: 'SAR 420,000',
            ),
            GeniusPdfSummaryItem.total(
              label: 'Net Total',
              labelAr: 'الإجمالي الصافي',
              value: 'SAR 1,670,000',
            ),
          ],
        );
        return summary.draw(page: page, bounds: bounds).height;
      },
    );

    addSpace(10);
  }

  void _buildDataGrid() {
    if (!options.includeDataGrid) return;
    _sectionTitle('Performance Snapshot', 'ملخص الأداء');

    final columns = _buildGridColumns();
    final rows = _buildGridRows();

    final grid = GeniusPdfDataGrid(
      config: config,
      columns: columns,
      rows: rows,
      style: GeniusPdfGridStyle.classic().copyWith(
        alternateRowColors: true,
      ),
    );

    addGrid(grid, spacing: 0);
    addSpace(10);
  }

  void _buildHighlights() {
    if (!options.includeBulletList) return;
    _sectionTitle('Highlights', 'أبرز النقاط');

    final list = GeniusPdfBulletList(
      config: config,
      items: [
        GeniusPdfBulletItem.simple(isRTL
            ? 'تخطيطات مرنة مع دعم تلقائي لتقسيم الصفحات.'
            : 'Flexible layouts with automatic page breaks.'),
        GeniusPdfBulletItem.simple(isRTL
            ? 'مكونات قابلة لإعادة الاستخدام للتقارير الاحترافية.'
            : 'Reusable components for professional reports.'),
        GeniusPdfBulletItem.simple(isRTL
            ? 'خيارات تحقق وأمان مثل QR والباركود والعلامة المائية.'
            : 'Verification and security options: QR, barcode, watermark.'),
      ],
      style: GeniusPdfBulletStyle.disc,
    );

    addBulletList(list, spacing: 4, estimatedHeight: 90);
    addSpace(10);
  }

  void _buildVerification() {
    if (!options.includeQrCode && !options.includeBarcode) return;
    _sectionTitle('Verification', 'التحقق');

    if (options.includeBarcode) {
      final barcode = GeniusPdfBarcode.shipping(
        data: 'TRK-GL-2026-0001',
        config: config,
      );

      const barcodeHeight = 90.0;
      if (!canFit(barcodeHeight + 20)) {
        newPage();
      }
      final bounds = Rect.fromLTWH(0, currentY, pageWidth, barcodeHeight);
      final rect = barcode.draw(page: currentPage, bounds: bounds);
      resetY(rect.bottom + 10);
    }

    if (options.includeQrCode) {
      final qr = GeniusPdfQRCodeGenerator.url(
        url: 'https://genius.systems/demo',
        caption: 'Scan to verify',
        captionAr: 'امسح للتحقق',
        config: config,
      );

      addQRCode(
        qr,
        size: 110,
        alignment: GeniusPdfImageAlignment.center,
        spacing: 4,
      );
      addSpace(8);
    }
  }

  void _buildBranding() {
    if (!options.includeImages &&
        !options.includeAttachments &&
        options.logoImage == null) {
      return;
    }

    _sectionTitle('Branding Assets', 'أصول الهوية');

    if (options.includeImages && options.logoImage != null) {
      addImage(
        options.logoImage!.scaledToWidth(120),
        alignment: GeniusPdfImageAlignment.center,
        spacing: 4,
      );
      addSpace(8);
    }

    if (options.includeAttachments && options.logoImage != null) {
      addImageAttachment(
        options.logoImage!.scaledToWidth(240),
        title: 'Attachment: Brand Logo',
        titleAr: 'مرفق: شعار الشركة',
        spacing: 4,
      );
      addSpace(8);
    }
  }

  void _buildSummary() {
    if (!options.includeSummary) return;

    final total = options.subtotal + options.tax - options.discount;
    final summary = GeniusPdfSummarySection(
      config: config,
      items: [
        GeniusPdfSummaryItem.subtotal(
          label: 'Subtotal',
          labelAr: 'الإجمالي قبل الضريبة',
          value: 'SAR ${_fmtNumber(options.subtotal)}',
        ),
        GeniusPdfSummaryItem(
          label: 'Tax (15%)',
          labelAr: 'الضريبة (15%)',
          value: 'SAR ${_fmtNumber(options.tax)}',
        ),
        GeniusPdfSummaryItem.negative(
          label: 'Discount',
          labelAr: 'الخصم',
          value: '- SAR ${_fmtNumber(options.discount)}',
        ),
        GeniusPdfSummaryItem.total(
          label: 'Total',
          labelAr: 'الإجمالي',
          value: 'SAR ${_fmtNumber(total)}',
        ),
      ],
    );

    addReportSummary(
      summary: summary,
      title: isRTL ? 'الملخص النهائي' : 'Report Summary',
      titleAr: 'الملخص النهائي',
      spacing: 8,
    );
  }

  void _buildSignatures() {
    if (!options.includeSignatureArea) return;
    _sectionTitle('Approvals', 'الاعتمادات');

    addTwoColumns(
      spacing: 4,
      gap: 20,
      leftContent: (page, bounds) {
        final sig = GeniusPdfSignatureArea(
          config: config,
          title: isRTL ? 'إعداد' : 'Prepared By',
          titleAr: 'إعداد',
        );
        return sig.draw(page: page, bounds: bounds).height;
      },
      rightContent: (page, bounds) {
        final sig = GeniusPdfSignatureArea(
          config: config,
          title: isRTL ? 'اعتماد' : 'Approved By',
          titleAr: 'اعتماد',
        );
        return sig.draw(page: page, bounds: bounds).height;
      },
    );

    addSpace(6);
  }

  void _sectionTitle(String title, String titleAr) {
    addSectionDivider(
      title: isRTL ? titleAr : title,
      spacing: 6,
    );
    addSpace(8);
  }

  GeniusPdfInfoBoxStyle _resolveInfoBoxStyle(String styleType) {
    switch (styleType) {
      case 'Highlighted':
        return const GeniusPdfInfoBoxStyle.highlighted();
      case 'Header Content':
        return const GeniusPdfInfoBoxStyle.headerContent();
      case 'Card':
      default:
        return const GeniusPdfInfoBoxStyle.card();
    }
  }

  List<GeniusPdfGridColumn> _buildGridColumns() {
    final columnDefs = [
      ('item', 'Item', 'البند', 90.0, false),
      ('description', 'Description', 'الوصف', 160.0, false),
      ('quantity', 'Qty', 'الكمية', 60.0, false),
      ('unit_price', 'Unit Price', 'سعر الوحدة', 80.0, true),
      ('total', 'Total', 'الإجمالي', 80.0, true),
      ('notes', 'Notes', 'ملاحظات', 120.0, false),
    ];

    final count = options.gridColumns.clamp(1, columnDefs.length).toInt();
    return List.generate(count, (index) {
      final def = columnDefs[index];
      if (def.$5) {
        return GeniusPdfGridColumn.currency(
          id: def.$1,
          title: def.$2,
          titleAr: def.$3,
          width: def.$4,
          currencySymbol: 'SAR',
        );
      }
      return GeniusPdfGridColumn(
        id: def.$1,
        title: def.$2,
        titleAr: def.$3,
        width: def.$4,
        alignment:
            index >= 2 ? GeniusPdfTextAlign.center : GeniusPdfTextAlign.start,
      );
    });
  }

  List<GeniusPdfGridRow> _buildGridRows() {
    final rows = <GeniusPdfGridRow>[];
    double totalSum = 0;
    final rowCount = options.gridRows.clamp(1, 20).toInt();

    for (var i = 0; i < rowCount; i++) {
      final qty = (i + 1) * 2;
      final unitPrice = 120.0 + (i * 15);
      final total = qty * unitPrice;
      totalSum += total;

      rows.add(GeniusPdfGridRow(cells: {
        'item': 'Item ${(i + 1).toString().padLeft(2, '0')}',
        'description': isRTL
            ? 'وصف مختصر للبند ${(i + 1)}'
            : 'Short description for item ${(i + 1)}',
        'quantity': qty,
        'unit_price': unitPrice,
        'total': total,
        'notes': i.isEven ? (isRTL ? 'جاهز' : 'Ready') : (isRTL ? 'قيد المراجعة' : 'In review'),
      }));
    }

    if (options.gridShowTotals) {
      rows.add(
        GeniusPdfGridRow.total({
          'item': '',
          'description': isRTL ? 'الإجمالي' : 'Total',
          'quantity': '',
          'unit_price': '',
          'total': totalSum,
          'notes': '',
        }),
      );
    }

    return rows;
  }

  String _fmtNumber(double value) =>
      value.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+\.)'), (m) => '${m[1]},');

  String _fmtDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
