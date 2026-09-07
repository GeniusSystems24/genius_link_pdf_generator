// Global manager/background migration for Barcode examples

import 'package:flutter/material.dart';
import 'package:genius_pdf_example/shared/application/services/example_pdf_generation.dart';
import 'package:genius_pdf_example/features/barcode/models/documents/barcode_background_generation.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/theme/app_theme.dart';

import 'package:genius_pdf_example/localizations/pdf_generator_localization.dart';

/// Demo screen for Barcode & QR Code generation features.
class BarcodeDemoScreen extends StatefulWidget {
  final int initialTab;

  const BarcodeDemoScreen({super.key, this.initialTab = 0});

  @override
  State<BarcodeDemoScreen> createState() => _BarcodeDemoScreenState();
}

class _BarcodeDemoScreenState extends State<BarcodeDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;
  bool _isRTL = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, 2),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: isDark ? AppColors.darkBg : AppColors.lightBg,
      child: Column(
        children: [
          _buildTabBar(isDark),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBarcodesTab(isDark),
                _buildQRCodesTab(isDark),
                _buildAllInOneTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: isDark
            ? AppColors.darkTextSecondary
            : AppColors.lightTextSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(6),
        tabs: [
          _buildTab(
            Icons.view_week_rounded,
            pdfLocalization.oneDBarcodes,
            isDark,
          ),
          _buildTab(Icons.qr_code_2_rounded, pdfLocalization.qrCodes, isDark),
          _buildTab(Icons.grid_view_rounded, pdfLocalization.allInOne, isDark),
        ],
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, bool isDark) {
    return Tab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // ============================================================
  // 1D Barcodes Tab
  // ============================================================
  Widget _buildBarcodesTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            isDark,
            icon: Icons.view_week_rounded,
            title: pdfLocalization.geniusPdfBarcode,
            description: pdfLocalization.text1DBarcodesProductsShippingDesc,
            gradient: AppColors.primaryGradient,
          ),
          const SizedBox(height: 16),
          _buildRtlToggle(isDark),
          const SizedBox(height: 16),
          _buildBarcodeCard(
            isDark,
            'EAN-13 Product',
            'رمز منتج EAN-13',
            'Product barcode for retail',
            GeniusBarcodeType.ean13,
          ),
          const SizedBox(height: 12),
          _buildBarcodeCard(
            isDark,
            'Code 128',
            'كود 128',
            'Alphanumeric barcode',
            GeniusBarcodeType.code128,
          ),
          const SizedBox(height: 12),
          _buildBarcodeCard(
            isDark,
            'Shipping Label',
            'بطاقة الشحن',
            'Tracking barcode for logistics',
            GeniusBarcodeType.code39,
          ),
          const SizedBox(height: 16),
          _buildGenerateButton(
            isDark,
            pdfLocalization.generateAllBarcodesPdf,
            AppColors.primaryGradient,
            _generate1DBarcodes,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBarcodeCard(
    bool isDark,
    String title,
    String titleAr,
    String subtitle,
    GeniusBarcodeType type,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              Icons.view_week_rounded,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isRTL ? titleAr : title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 2),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              type.displayName,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // QR Codes Tab
  // ============================================================
  Widget _buildQRCodesTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            isDark,
            icon: Icons.qr_code_2_rounded,
            title: pdfLocalization.geniusPdfQrcodeGenerator,
            description:
                pdfLocalization.dynamicQrCodesUrlsZatcaInvoicesWiFiDesc,
            gradient: AppColors.purpleGradient,
          ),
          const SizedBox(height: 16),
          _buildRtlToggle(isDark),
          const SizedBox(height: 16),
          _buildQRCard(
            isDark,
            pdfLocalization.urlQrCode,
            'رمز QR لرابط',
            pdfLocalization.scanToOpenWebsite,
            Icons.link_rounded,
          ),
          const SizedBox(height: 12),
          _buildQRCard(
            isDark,
            pdfLocalization.zatcaInvoice,
            'فاتورة هيئة الزكاة',
            pdfLocalization.saudiEInvoiceQrTlv,
            Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 12),
          _buildQRCard(
            isDark,
            pdfLocalization.wiFiConfig,
            'إعدادات واي فاي',
            pdfLocalization.wiFiConnectionQr,
            Icons.wifi_rounded,
          ),
          const SizedBox(height: 12),
          _buildQRCard(
            isDark,
            pdfLocalization.vCardContact,
            'بطاقة اتصال',
            pdfLocalization.contactInformationQr,
            Icons.contact_page_rounded,
          ),
          const SizedBox(height: 16),
          _buildGenerateButton(
            isDark,
            pdfLocalization.generateAllQrCodesPdf,
            AppColors.purpleGradient,
            _generateQRCodes,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQRCard(
    bool isDark,
    String title,
    String titleAr,
    String subtitle,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isRTL ? titleAr : title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 2),
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
          const Icon(
            Icons.qr_code_rounded,
            color: AppColors.secondary,
            size: 28,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // All-in-One Tab
  // ============================================================
  Widget _buildAllInOneTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderCard(
            isDark,
            icon: Icons.grid_view_rounded,
            title: pdfLocalization.completeDemo,
            description: pdfLocalization.fullPdfBarcodeQrCodeTypesOnePageDesc,
            gradient: AppColors.successGradient,
          ),
          const SizedBox(height: 16),
          _buildRtlToggle(isDark),
          const SizedBox(height: 16),
          _buildFeatureList(isDark),
          const SizedBox(height: 16),
          _buildGenerateButton(
            isDark,
            pdfLocalization.generateCompleteDemoPdf,
            AppColors.successGradient,
            _generateAllInOne,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFeatureList(bool isDark) {
    final features = [
      '1D Barcodes: EAN-13, Code128, Code39',
      '2D QR Codes: URL, ZATCA, WiFi, vCard',
      'Multiple styles: Retail, Shipping, Document',
      'RTL/LTR bilingual captions',
    ];

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
        children: features.map((f) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.success,
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    f,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ============================================================
  // Shared Widgets
  // ============================================================
  Widget _buildHeaderCard(
    bool isDark, {
    required IconData icon,
    required String title,
    required String description,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradient.first.withValues(alpha: isDark ? 0.2 : 0.1),
            gradient.last.withValues(alpha: isDark ? 0.1 : 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradient.first.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
        ],
      ),
    );
  }

  Widget _buildRtlToggle(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.language_rounded,
            size: 18,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary,
          ),
          const SizedBox(width: 8),
          Text(
            pdfLocalization.languageDirection,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.darkText : AppColors.lightText,
            ),
          ),
          const Spacer(),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(pdfLocalization.rtl)),
              ButtonSegment(value: false, label: Text(pdfLocalization.ltr)),
            ],
            selected: {_isRTL},
            onSelectionChanged: (v) => setState(() => _isRTL = v.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              textStyle: WidgetStateProperty.all(const TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton(
    bool isDark,
    String label,
    List<Color> gradient,
    VoidCallback onTap,
  ) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: _isGenerating ? null : LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(14),
        boxShadow: _isGenerating
            ? null
            : [
                BoxShadow(
                  color: gradient.first.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: ElevatedButton.icon(
        onPressed: _isGenerating ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: AppColors.darkBorder.withValues(alpha: 0.5),
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: _isGenerating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Icon(Icons.picture_as_pdf_rounded, size: 22),
        label: Text(
          _isGenerating ? 'Generating...' : label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ============================================================
  // PDF Generation Methods
  // ============================================================
  Future<void> _generate1DBarcodes() => _runBarcodeGeneration(
    kind: BarcodeBackgroundDocumentKind.oneDimensional,
    fileName: 'barcodes_1d',
  );

  Future<void> _generateQRCodes() => _runBarcodeGeneration(
    kind: BarcodeBackgroundDocumentKind.qrCodes,
    fileName: 'qr_codes',
  );

  Future<void> _generateAllInOne() => _runBarcodeGeneration(
    kind: BarcodeBackgroundDocumentKind.allInOne,
    fileName: 'barcode_qr_complete',
  );

  Future<void> _runBarcodeGeneration({
    required BarcodeBackgroundDocumentKind kind,
    required String fileName,
  }) async {
    if (_isGenerating) return;
    setState(() => _isGenerating = true);

    try {
      final success = await generateExamplePdf(
        builder: ExampleBackgroundPdfBuilder(
          config: geniusPdfConfig,
          backgroundGenerator: () =>
              generateBarcodeDocumentInBackground(kind: kind, isRtl: _isRTL),
        ),
        fileName: fileName,
        metadata: <String, dynamic>{
          'feature': 'barcode',
          'screen': 'BarcodeDemoScreen',
          'documentKind': kind.name,
          'workflow': 'barcode-demo',
          'showGenerationToast': true,
        },
      );

      final path = success.filePath;
      if (path?.isNotEmpty ?? false) {
        await demoDocuments.open(path!);
      } else {
        await demoDocuments.saveAndOpen(
          bytes: success.bytes,
          fileName: '$fileName.pdf',
        );
      }
    } catch (error) {
      _showError(error.toString());
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  // ============================================================
  // Helpers
  // ============================================================
  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $message'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}
