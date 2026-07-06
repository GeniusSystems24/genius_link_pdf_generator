
import 'package:flutter/material.dart';
import 'package:genius_pdf_example/app/dependencies/example_dependencies.dart';
import 'package:genius_pdf_example/shared/application/contracts/demo_file_gateway.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/app/theme/app_theme.dart';

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
        unselectedLabelColor:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(6),
        tabs: [
          _buildTab(Icons.view_week_rounded, '1D Barcodes', isDark),
          _buildTab(Icons.qr_code_2_rounded, 'QR Codes', isDark),
          _buildTab(Icons.grid_view_rounded, 'All-in-One', isDark),
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
            title: 'GeniusPdfBarcode',
            description:
                'Generate 1D barcodes for products, shipping, and documents.',
            gradient: AppColors.primaryGradient,
          ),
          const SizedBox(height: 16),
          _buildRtlToggle(isDark),
          const SizedBox(height: 16),
          _buildBarcodeCard(isDark, 'EAN-13 Product', 'رمز منتج EAN-13',
              'Product barcode for retail', GeniusBarcodeType.ean13),
          const SizedBox(height: 12),
          _buildBarcodeCard(isDark, 'Code 128', 'كود 128',
              'Alphanumeric barcode', GeniusBarcodeType.code128),
          const SizedBox(height: 12),
          _buildBarcodeCard(isDark, 'Shipping Label', 'بطاقة الشحن',
              'Tracking barcode for logistics', GeniusBarcodeType.code39),
          const SizedBox(height: 16),
          _buildGenerateButton(
            isDark,
            'Generate All Barcodes PDF',
            AppColors.primaryGradient,
            _generate1DBarcodes,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBarcodeCard(bool isDark, String title, String titleAr,
      String subtitle, GeniusBarcodeType type) {
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
            child: Icon(Icons.view_week_rounded,
                color: AppColors.primary, size: 24),
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
            title: 'GeniusPdfQRCodeGenerator',
            description:
                'Dynamic QR codes for URLs, ZATCA invoices, WiFi, and contacts.',
            gradient: AppColors.purpleGradient,
          ),
          const SizedBox(height: 16),
          _buildRtlToggle(isDark),
          const SizedBox(height: 16),
          _buildQRCard(isDark, 'URL QR Code', 'رمز QR لرابط',
              'Scan to open website', Icons.link_rounded),
          const SizedBox(height: 12),
          _buildQRCard(isDark, 'ZATCA Invoice', 'فاتورة هيئة الزكاة',
              'Saudi e-invoice QR (TLV)', Icons.receipt_long_rounded),
          const SizedBox(height: 12),
          _buildQRCard(isDark, 'WiFi Config', 'إعدادات واي فاي',
              'WiFi connection QR', Icons.wifi_rounded),
          const SizedBox(height: 12),
          _buildQRCard(isDark, 'vCard Contact', 'بطاقة اتصال',
              'Contact information QR', Icons.contact_page_rounded),
          const SizedBox(height: 16),
          _buildGenerateButton(
            isDark,
            'Generate All QR Codes PDF',
            AppColors.purpleGradient,
            _generateQRCodes,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildQRCard(bool isDark, String title, String titleAr,
      String subtitle, IconData icon) {
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
          const Icon(Icons.qr_code_rounded,
              color: AppColors.secondary, size: 28),
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
            title: 'Complete Demo',
            description:
                'Generate a full PDF with all barcode and QR code types on one page.',
            gradient: AppColors.successGradient,
          ),
          const SizedBox(height: 16),
          _buildRtlToggle(isDark),
          const SizedBox(height: 16),
          _buildFeatureList(isDark),
          const SizedBox(height: 16),
          _buildGenerateButton(
            isDark,
            'Generate Complete Demo PDF',
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
                const Icon(Icons.check_circle_rounded,
                    color: AppColors.success, size: 18),
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
  Widget _buildHeaderCard(bool isDark,
      {required IconData icon,
      required String title,
      required String description,
      required List<Color> gradient}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          gradient.first.withValues(alpha: isDark ? 0.2 : 0.1),
          gradient.last.withValues(alpha: isDark ? 0.1 : 0.05),
        ]),
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
                Text(title,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    )),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    )),
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
          Icon(Icons.language_rounded,
              size: 18,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary),
          const SizedBox(width: 8),
          Text('Language Direction',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              )),
          const Spacer(),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('RTL')),
              ButtonSegment(value: false, label: Text('LTR')),
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
      bool isDark, String label, List<Color> gradient, VoidCallback onTap) {
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
                    strokeWidth: 2, color: Colors.white))
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
  Future<void> _generate1DBarcodes() async {
    setState(() => _isGenerating = true);
    try {
      final document = PdfDocument();
      final page = document.pages.add();
      final pageSize = page.getClientSize();
      final titleFont =
          PdfTrueTypeFont(geniusPdfConfig.assets.primaryFont.toList(), 18);

      // Title
      page.graphics.drawString(
        _isRTL ? 'الرموز الشريطية 1D' : '1D Barcodes Demo',
        titleFont,
        brush: PdfSolidBrush(PdfColor(33, 150, 243)),
        bounds: Rect.fromLTWH(20, 20, pageSize.width - 40, 30),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: _isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );

      double yOffset = 70;

      // EAN-13
      final ean13 = GeniusPdfBarcode.ean13(
        config: geniusPdfConfig,
        data: '5901234123457',
        caption: 'Product Code',
        captionAr: 'رمز المنتج',
        style: const GeniusPdfBarcodeStyle.retail(),
      );
      final ean13Rect = ean13.draw(
        page: page,
        bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 100),
      );
      yOffset = ean13Rect.bottom + 20;

      // Code 128
      final code128 = GeniusPdfBarcode.code128(
        config: geniusPdfConfig,
        data: 'GENIUS-PDF-2025',
        caption: 'Reference Number',
        captionAr: 'الرقم المرجعي',
        style: const GeniusPdfBarcodeStyle.document(),
      );
      final code128Rect = code128.draw(
        page: page,
        bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 100),
      );
      yOffset = code128Rect.bottom + 20;

      // Shipping barcode
      final shipping = GeniusPdfBarcode.shipping(
        config: geniusPdfConfig,
        data: '1Z999AA10123456784',
        trackingLabel: 'Tracking Number',
        trackingLabelAr: 'رقم التتبع',
      );
      shipping.draw(
        page: page,
        bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 110),
      );

      await _saveAndOpenPdf(document, 'barcodes_1d');
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateQRCodes() async {
    setState(() => _isGenerating = true);
    try {
      final document = PdfDocument();
      final page = document.pages.add();
      final pageSize = page.getClientSize();
      final titleFont =
          PdfTrueTypeFont(geniusPdfConfig.assets.primaryFont.toList(), 18);

      // Title
      page.graphics.drawString(
        _isRTL ? 'رموز QR' : 'QR Codes Demo',
        titleFont,
        brush: PdfSolidBrush(PdfColor(33, 150, 243)),
        bounds: Rect.fromLTWH(20, 20, pageSize.width - 40, 30),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: _isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );

      double yOffset = 70;
      final halfWidth = (pageSize.width - 60) / 2;

      // URL QR Code
      final urlQR = GeniusPdfQRCodeGenerator.url(
        config: geniusPdfConfig,
        url: 'https://github.com/GeniusSystems24',
        caption: 'Visit Website',
        captionAr: 'زيارة الموقع',
        style: const GeniusPdfQRCodeStyle(),
      );
      urlQR.draw(
        page: page,
        bounds: Rect.fromLTWH(20, yOffset, halfWidth, 140),
      );

      // ZATCA QR Code
      final zatcaQR = GeniusPdfQRCodeGenerator.zatca(
        config: geniusPdfConfig,
        sellerName: 'شركة الأمل للتجارة',
        vatNumber: '300123456789003',
        timestamp: DateTime.now(),
        total: 34615.00,
        vatAmount: 4515.00,
        style: const GeniusPdfQRCodeStyle.invoice(),
      );
      zatcaQR.draw(
        page: page,
        bounds: Rect.fromLTWH(40 + halfWidth, yOffset, halfWidth, 140),
      );

      yOffset += 160;

      // WiFi QR Code
      final wifiQR = GeniusPdfQRCodeGenerator.wifi(
        config: geniusPdfConfig,
        ssid: 'GeniusOffice',
        password: 'Genius@2025',
        style: GeniusPdfQRCodeStyle.branded(
          primaryColor: const Color(0xFF4CAF50),
        ),
      );
      wifiQR.draw(
        page: page,
        bounds: Rect.fromLTWH(20, yOffset, halfWidth, 140),
      );

      // vCard QR Code
      final vCardQR = GeniusPdfQRCodeGenerator.vCard(
        config: geniusPdfConfig,
        name: _isRTL ? 'أحمد محمد' : 'Ahmed Mohammed',
        phone: '+966501234567',
        email: 'ahmed@example.com',
        company: _isRTL ? 'شركة الأمل' : 'Al-Amal Co.',
        style: const GeniusPdfQRCodeStyle.payment(),
      );
      vCardQR.draw(
        page: page,
        bounds: Rect.fromLTWH(40 + halfWidth, yOffset, halfWidth, 140),
      );

      await _saveAndOpenPdf(document, 'qr_codes');
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateAllInOne() async {
    setState(() => _isGenerating = true);
    try {
      final document = PdfDocument();
      final page = document.pages.add();
      final pageSize = page.getClientSize();
      final titleFont =
          PdfTrueTypeFont(geniusPdfConfig.assets.primaryFont.toList(), 16);
      final sectionFont =
          PdfTrueTypeFont(geniusPdfConfig.assets.primaryFont.toList(), 12);

      // Title
      page.graphics.drawString(
        _isRTL
            ? 'عرض شامل - الرموز الشريطية و QR'
            : 'Complete Barcode & QR Code Demo',
        titleFont,
        brush: PdfSolidBrush(PdfColor(33, 150, 243)),
        bounds: Rect.fromLTWH(20, 15, pageSize.width - 40, 25),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: _isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );

      double yOffset = 50;

      // Section: 1D Barcodes
      page.graphics.drawString(
        _isRTL ? '— الرموز الشريطية 1D —' : '— 1D Barcodes —',
        sectionFont,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: _isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );
      yOffset += 25;

      // EAN-13
      final ean13 = GeniusPdfBarcode.ean13(
        config: geniusPdfConfig,
        data: '5901234123457',
        caption: 'EAN-13',
        style: const GeniusPdfBarcodeStyle.compact(),
      );
      final ean13Rect = ean13.draw(
        page: page,
        bounds: Rect.fromLTWH(20, yOffset, (pageSize.width - 60) / 2, 80),
      );

      // Code 128
      final code128 = GeniusPdfBarcode.code128(
        config: geniusPdfConfig,
        data: 'GENIUS-2025',
        caption: 'Code 128',
        style: const GeniusPdfBarcodeStyle.compact(),
      );
      code128.draw(
        page: page,
        bounds: Rect.fromLTWH(
            (pageSize.width + 20) / 2, yOffset, (pageSize.width - 60) / 2, 80),
      );
      yOffset = ean13Rect.bottom + 15;

      // Section: QR Codes
      page.graphics.drawString(
        _isRTL ? '— رموز QR —' : '— QR Codes —',
        sectionFont,
        brush: PdfSolidBrush(PdfColor(100, 100, 100)),
        bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 20),
        format: PdfStringFormat(
          alignment: PdfTextAlignment.center,
          textDirection: _isRTL
              ? PdfTextDirection.rightToLeft
              : PdfTextDirection.leftToRight,
        ),
      );
      yOffset += 25;

      final qrWidth = (pageSize.width - 80) / 3;

      // URL QR
      final urlQR = GeniusPdfQRCodeGenerator.url(
        config: geniusPdfConfig,
        url: 'https://genius.systems',
        caption: 'URL',
        captionAr: 'رابط',
        style: const GeniusPdfQRCodeStyle.compact(),
      );
      urlQR.draw(
        page: page,
        bounds: Rect.fromLTWH(20, yOffset, qrWidth, 90),
      );

      // ZATCA QR
      final zatcaQR = GeniusPdfQRCodeGenerator.zatca(
        config: geniusPdfConfig,
        sellerName: 'شركة الأمل',
        vatNumber: '300123456789003',
        timestamp: DateTime.now(),
        total: 34615.00,
        vatAmount: 4515.00,
        style: const GeniusPdfQRCodeStyle.compact(),
      );
      zatcaQR.draw(
        page: page,
        bounds: Rect.fromLTWH(40 + qrWidth, yOffset, qrWidth, 90),
      );

      // WiFi QR
      final wifiQR = GeniusPdfQRCodeGenerator.wifi(
        config: geniusPdfConfig,
        ssid: 'Office',
        password: 'pass123',
        style: const GeniusPdfQRCodeStyle.compact(),
      );
      wifiQR.draw(
        page: page,
        bounds: Rect.fromLTWH(60 + qrWidth * 2, yOffset, qrWidth, 90),
      );

      await _saveAndOpenPdf(document, 'barcode_qr_complete');
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  // ============================================================
  // Helpers
  // ============================================================
  Future<void> _saveAndOpenPdf(PdfDocument document, String fileName) async {
    final bytes = await document.save();
    document.dispose();

    await demoDocuments.saveAndOpen(
      bytes: bytes,
      fileName: fileName,
      location: DemoStorageLocation.temporary,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isRTL ? 'تم إنشاء PDF بنجاح' : 'PDF generated'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

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
