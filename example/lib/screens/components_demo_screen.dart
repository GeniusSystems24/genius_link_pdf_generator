import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../documents/components_demo_documents.dart';
import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';
import '../widgets/component_page.dart';
// import '../widgets/custom_tab_bar.dart';

class ComponentsDemoScreen extends StatefulWidget {
  const ComponentsDemoScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<ComponentsDemoScreen> createState() => _ComponentsDemoScreenState();
}

class _ComponentsDemoScreenState extends State<ComponentsDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;
  bool _isRTL = true;

  final List<_ComponentTab> _tabs = [
    _ComponentTab(
      id: 'data_grid',
      title: 'Data Grid',
      icon: Icons.table_chart_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _ComponentTab(
      id: 'rich_text',
      title: 'Rich Text',
      icon: Icons.text_fields_rounded,
      gradient: AppColors.purpleGradient,
    ),
    _ComponentTab(
      id: 'info_box',
      title: 'Info Box',
      icon: Icons.info_rounded,
      gradient: AppColors.cyanGradient,
    ),
    _ComponentTab(
      id: 'headers',
      title: 'Headers',
      icon: Icons.article_rounded,
      gradient: AppColors.successGradient,
    ),
    _ComponentTab(
      id: 'summary',
      title: 'Summary',
      icon: Icons.calculate_rounded,
      gradient: AppColors.warningGradient,
    ),
    _ComponentTab(
      id: 'grid_qrcode',
      title: 'Grid+QR',
      icon: Icons.qr_code_rounded,
      gradient: AppColors.purpleGradient,
    ),
    _ComponentTab(
      id: 'grid_infobox',
      title: 'Grid+Info',
      icon: Icons.view_agenda_rounded,
      gradient: AppColors.cyanGradient,
    ),
    _ComponentTab(
      id: 'grid_watermark',
      title: 'Grid+Watermark',
      icon: Icons.water_drop_rounded,
      gradient: AppColors.successGradient,
    ),
    _ComponentTab(
      id: 'grid_richtext',
      title: 'Grid+RichText',
      icon: Icons.format_quote_rounded,
      gradient: AppColors.warningGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.initialTab.clamp(0, _tabs.length - 1),
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
                _buildDataGridTab(isDark),
                _buildRichTextTab(isDark),
                _buildInfoBoxTab(isDark),
                _buildHeadersTab(isDark),
                _buildSummaryTab(isDark),
                _buildGridQrcodeTab(isDark),
                _buildGridInfoboxTab(isDark),
                _buildGridWatermarkTab(isDark),
                _buildGridRichtextTab(isDark),
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
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        padding: const EdgeInsets.all(6),
        isScrollable: true,
        indicator: BoxDecoration(
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(12),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        tabs: _tabs.map((tab) {
          return Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(tab.icon, size: 16),
                const SizedBox(width: 6),
                Text(
                  tab.title,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDataGridTab(bool isDark) {
    return ComponentPage(
      title: 'GeniusPdfDataGrid',
      description:
          'Professional data tables with RTL support, styling, borders, and cell alignment.',
      icon: Icons.table_chart_rounded,
      gradient: AppColors.primaryGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: () => _generatePdf('data_grid'),
      codeExample: '''
final grid = GeniusPdfDataGrid(
  config: config,
  columns: [
    GeniusPdfGridColumn.numeric(id: 'code', title: 'الكود', width: 60),
    GeniusPdfGridColumn(id: 'desc', title: 'الوصف', flex: 2),
    GeniusPdfGridColumn.numeric(id: 'qty', title: 'الكمية', width: 60),
    GeniusPdfGridColumn.currency(id: 'price', title: 'السعر', width: 80),
    GeniusPdfGridColumn.currency(id: 'total', title: 'الإجمالي', width: 80),
  ],
  rows: [
    GeniusPdfGridRow(cells: {'code': '001', 'desc': 'منتج أول', 'qty': 10, 'price': 100, 'total': 1000}),
    GeniusPdfGridRow(cells: {'code': '002', 'desc': 'منتج ثاني', 'qty': 5, 'price': 200, 'total': 1000}),
  ],
  style: GeniusPdfGridStyle.corporate(),
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);''',
      preview: _buildDataGridPreview(isDark),
    );
  }

  Widget _buildDataGridPreview(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: AppColors.primaryGradient),
              borderRadius: BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              children: [
                _gridCell('الكود', true, flex: 1),
                _gridCell('الوصف', true, flex: 3),
                _gridCell('الكمية', true, flex: 1),
                _gridCell('السعر', true, flex: 1),
                _gridCell('الإجمالي', true, flex: 1),
              ],
            ),
          ),
          ...List.generate(4, (i) {
            final isEven = i % 2 == 0;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isEven
                    ? (isDark ? AppColors.darkCard : Colors.grey.shade50)
                    : (isDark ? AppColors.darkBg : Colors.white),
              ),
              child: Row(
                children: [
                  _gridCell('00${i + 1}', false, flex: 1),
                  _gridCell('منتج رقم ${i + 1}', false, flex: 3),
                  _gridCell('${(i + 1) * 5}', false, flex: 1),
                  _gridCell('${(i + 1) * 100}.00', false, flex: 1),
                  _gridCell('${(i + 1) * 5 * (i + 1) * 100}.00', false,
                      flex: 1),
                ],
              ),
            );
          }),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.grey.shade100,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(11)),
            ),
            child: Row(
              children: [
                const Expanded(flex: 5, child: SizedBox()),
                _gridCell('المجموع:', false, flex: 1, isBold: true),
                _gridCell('5,000.00', false, flex: 1, isBold: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gridCell(String text, bool isHeader,
      {int flex = 1, bool isBold = false}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: isHeader ? 13 : 12,
          fontWeight: isHeader || isBold ? FontWeight.w600 : FontWeight.normal,
          color: isHeader ? Colors.white : null,
        ),
      ),
    );
  }

  Widget _buildRichTextTab(bool isDark) {
    return ComponentPage(
      title: 'GeniusPdfRichText',
      description:
          'Styled text with multiple colors, fonts, sizes, and inline formatting.',
      icon: Icons.text_fields_rounded,
      gradient: AppColors.purpleGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: () => _generatePdf('rich_text'),
      codeExample: '''
// ─── Fluent Builder API ────────────────────────
final richText = GeniusPdfRichTextBuilder(
  config: config,
  baseFont: config.baseFont,
  boldFont: config.boldFont,
  isRTL: true,
)
  .heading('ملخص الفاتورة')
  .newLine()
  .label('رقم الفاتورة')
  .separator(': ')
  .bold('#INV-2024-001', color: Colors.blue)
  .newLine()
  .text('الإجمالي: ')
  .currency('34,615.00', symbol: 'ر.س')
  .space()
  .badge('مدفوعة', backgroundColor: Colors.green)
  .newLine()
  .text('السعر السابق: ')
  .strikethrough('28,500.00')
  .space()
  .positive('34,615.00')
  .superscript('*')
  .build(maxLines: 5, overflow: GeniusPdfTextOverflow.ellipsis);

// ─── Markdown Parser ───────────────────────────
final spans = 'This is **bold** and *italic*'.parseMarkdownSpans();

// ─── Links with Custom Colors ──────────────────
final link = GeniusPdfRichTextBuilder(...)
  .text('Visit: ')
  .link('our site', 'https://example.com',
        color: Color(0xFF0D47A1))
  .build();

// ─── Auto-detect URLs & Emails ─────────────────
final auto = GeniusPdfSimpleMarkdownParser.parse(
  'Email info@test.com or visit https://test.com',
  config: GeniusPdfMarkdownConfig(
    autoDetectUrls: true,
    autoDetectEmails: true,
    autoLinkColor: Color(0xFF00796B),
  ),
);

// ─── Inline Hex Color in Markdown Links ────────
final colored = GeniusPdfSimpleMarkdownParser.parse(
  '[Red](https://r.com){#E53935} '
  '[Green](https://g.com){#43A047}',
);

// ─── Bullet List ───────────────────────────────
final list = GeniusPdfBulletList(
  items: [
    GeniusPdfBulletItem.simple('البند الأول'),
    GeniusPdfBulletItem.simple('البند الثاني'),
  ],
  config: config,
  style: GeniusPdfBulletStyle.disc,
  baseFont: config.baseFont,
  boldFont: config.boldFont,
  isRTL: true,
);
''',
      preview: _buildRichTextPreview(isDark),
    );
  }

  Widget _buildRichTextPreview(bool isDark) {
    final textColor = isDark ? AppColors.darkText : AppColors.lightText;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text('مدفوعة',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text('ملخص الفاتورة',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor)),
            ],
          ),
          const SizedBox(height: 16),
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: textColor, height: 1.8),
              children: const [
                TextSpan(
                    text: 'رقم الفاتورة: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF424242))),
                TextSpan(
                    text: '#INV-2024-001',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: textColor),
              children: const [
                TextSpan(text: 'الإجمالي: '),
                TextSpan(
                    text: '34,615.00 ر.س',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.success,
                        letterSpacing: 0.3)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: textColor),
              children: const [
                TextSpan(text: 'السعر السابق: '),
                TextSpan(
                  text: '28,500.00',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                TextSpan(text: '  '),
                TextSpan(
                    text: '34,615.00',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.success)),
              ],
            ),
          ),
          const Divider(height: 24),
          Text('عناصر البند:',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 6),
          for (final item in ['خدمات استشارية', 'تطوير برمجيات', 'صيانة شهرية'])
            Padding(
              padding: const EdgeInsets.only(right: 12, bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(item,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(fontSize: 13, color: textColor)),
                  const SizedBox(width: 8),
                  Text('•',
                      style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          const SizedBox(height: 12),
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: textColor),
              children: [
                WidgetSpan(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                    color: const Color(0xFFFFEB3B).withValues(alpha: 0.5),
                    child: const Text('ملاحظة مهمة',
                        style: TextStyle(fontSize: 13)),
                  ),
                ),
                const TextSpan(text: '  '),
                const TextSpan(
                  text: 'شامل الضريبة',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBoxTab(bool isDark) {
    return ComponentPage(
      title: 'GeniusPdfInfoBox',
      description:
          'Information boxes for notices, warnings, tips, and important messages.',
      icon: Icons.info_rounded,
      gradient: AppColors.cyanGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: () => _generatePdf('info_box'),
      codeExample: '''
// Status-themed info boxes
final infoBox = GeniusPdfInfoBox(
  config: config,
  title: 'ملاحظة هامة',
  style: GeniusPdfInfoBoxStyle.info(),
  items: [
    GeniusPdfLabeledValue(
      config: config,
      label: 'التفاصيل',
      value: 'يرجى الاحتفاظ بهذه الفاتورة...',
    ),
  ],
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);

// Pre-configured company factory
final companyBox = GeniusPdfInfoBox.company(
  config: config,
  companyName: 'شركة الأمل للتجارة',
  taxNumber: '300123456789003',
  commercialReg: '1010123456',
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);

// Equal-height dual info box
final dualBox = GeniusPdfDualInfoBox(
  leftBox: customerBox,
  rightBox: companyBox,
  equalHeight: true,
);''',
      preview: _buildInfoBoxPreview(isDark),
    );
  }

  Widget _buildInfoBoxPreview(bool isDark) {
    return Column(
      children: [
        _infoBox('ملاحظة', 'يرجى الاحتفاظ بهذه الفاتورة كمرجع للضمان.',
            Icons.info_rounded, AppColors.info, isDark),
        const SizedBox(height: 12),
        _infoBox('نجاح', 'تم إتمام العملية بنجاح.', Icons.check_circle_rounded,
            AppColors.success, isDark),
        const SizedBox(height: 12),
        _infoBox('تحذير', 'هذا المستند للمعاينة فقط وليس فاتورة رسمية.',
            Icons.warning_rounded, AppColors.warning, isDark),
        const SizedBox(height: 12),
        _infoBox('خطأ', 'فشل في معالجة الطلب. يرجى المحاولة مرة أخرى.',
            Icons.error_rounded, AppColors.error, isDark),
      ],
    );
  }

  Widget _infoBox(
      String title, String content, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: color,
                        fontSize: 14)),
                const SizedBox(height: 4),
                Text(content,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                        fontSize: 13,
                        color:
                            isDark ? AppColors.darkText : AppColors.lightText)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadersTab(bool isDark) {
    return ComponentPage(
      title: 'GeniusPdfHeader',
      description:
          'Professional document headers with logo, company info, and document details.',
      icon: Icons.article_rounded,
      gradient: AppColors.successGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: () => _generatePdf('headers'),
      codeExample: '''
// Standard invoice header
final header = GeniusPdfReportHeader(
  config: config,
  title: 'Tax Invoice',
  titleAr: 'فاتورة ضريبية',
  company: companyInfo,
  printDate: DateTime.now(),
  style: GeniusPdfReportHeaderStyle.invoice(),
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);

// Bilingual split: English left, logo center, Arabic right
final bilingualHeader = GeniusPdfReportHeader.bilingualSplit(
  config: config,
  title: 'Trial Balance',
  titleAr: 'ميزان المراجعة',
  company: companyInfo,
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);''',
      preview: _buildHeadersPreview(isDark),
    );
  }

  Widget _buildHeadersPreview(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                AppColors.primary.withValues(alpha: 0.1),
                AppColors.secondary.withValues(alpha: 0.05),
              ]),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(11)),
            ),
            child: Row(
              textDirection: TextDirection.rtl,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient:
                        const LinearGradient(colors: AppColors.primaryGradient),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      const Icon(Icons.business, color: Colors.white, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('شركة الأمل للتجارة',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkText
                                  : AppColors.lightText)),
                      Text('Al-Amal Trading Company',
                          style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)),
                      const SizedBox(height: 4),
                      Text('الرياض، المملكة العربية السعودية',
                          style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Text('فاتورة ضريبية',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                      const SizedBox(height: 4),
                      Text('INV-2024-001',
                          style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkBg : Colors.grey.shade50,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(11)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _contactItem(Icons.phone, '+966 11 123 4567', isDark),
                _contactItem(Icons.email, 'info@alamal.com', isDark),
                _contactItem(Icons.receipt, 'VAT: 300123456789003', isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactItem(IconData icon, String text, bool isDark) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 14,
            color: isDark
                ? AppColors.darkTextSecondary
                : AppColors.lightTextSecondary),
        const SizedBox(width: 6),
        Text(text,
            style: TextStyle(
                fontSize: 11,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary)),
      ],
    );
  }

  Widget _buildSummaryTab(bool isDark) {
    return ComponentPage(
      title: 'GeniusPdfSummary',
      description:
          'Totals and summary sections with calculations, discounts, and VAT.',
      icon: Icons.calculate_rounded,
      gradient: AppColors.warningGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: () => _generatePdf('summary'),
      codeExample: '''
final summary = GeniusPdfSummarySection(
  config: config,
  items: [
    GeniusPdfSummaryItem(
      label: 'Subtotal',
      value: '30,100.00',
    ),
    GeniusPdfSummaryItem(
      label: 'VAT (15%)',
      value: '4,515.00',
    ),
    GeniusPdfSummaryItem(
      label: 'Total',
      value: '34,615.00',
      isTotal: true,
      isBold: true,
    ),
  ],
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);''',
      preview: _buildSummaryPreview(isDark),
    );
  }

  Widget _buildSummaryPreview(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          _summaryRow('المجموع الفرعي', '30,100.00', false, isDark),
          _summaryRow('الخصم', '- 500.00', false, isDark, isDiscount: true),
          _summaryRow('ضريبة القيمة المضافة (15%)', '4,440.00', false, isDark),
          const Divider(height: 1),
          _summaryRow('الإجمالي النهائي', '34,040.00', true, isDark),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isTotal, bool isDark,
      {bool isDiscount = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: isTotal
          ? AppColors.primary.withValues(alpha: 0.1)
          : Colors.transparent,
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                  fontSize: isTotal ? 16 : 14,
                  color: isDark ? AppColors.darkText : AppColors.lightText)),
          Text(value,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
                fontSize: isTotal ? 16 : 14,
                color: isDiscount
                    ? AppColors.error
                    : (isTotal
                        ? AppColors.primary
                        : (isDark ? AppColors.darkText : AppColors.lightText)),
              )),
        ],
      ),
    );
  }

  Widget _buildGridQrcodeTab(bool isDark) {
    return ComponentPage(
      title: 'Grid with QR Code',
      description: 'Display a QR code below or above the data grid.',
      icon: Icons.qr_code_rounded,
      gradient: AppColors.purpleGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: () => _generatePdf('grid_qrcode'),
      codeExample: '''
final builder = GeniusPdfDocumentBuilder(config);
builder.addDataGrid(
  columns: [...],
  rows: [...],
);

// Add QR Code
builder.addQRCode(
  data: 'https://example.com/invoice/12345',
  size: 100,
  label: 'Scan to Verify',
  align: PdfTextAlignment.center,
  padding: const EdgeInsets.only(top: 20),
);''',
      preview: Column(
        children: [
          _buildDataGridPreview(isDark),
          const SizedBox(height: 20),
          Icon(Icons.qr_code_2,
              size: 80, color: isDark ? Colors.white : Colors.black87),
          const SizedBox(height: 8),
          Text('Scan to Verify',
              style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildGridInfoboxTab(bool isDark) {
    return ComponentPage(
      title: 'Grid with Info Box',
      description: 'Combine data grids with informational boxes.',
      icon: Icons.view_agenda_rounded,
      gradient: AppColors.cyanGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: () => _generatePdf('grid_infobox'),
      codeExample: '''
final builder = GeniusPdfDocumentBuilder(config);
builder.addDataGrid(
  columns: [...],
  rows: [...],
);

// Add Info Box
builder.addInfoBox(
  title: 'Payment Terms',
  style: GeniusPdfInfoBoxStyle.info(),
  baseFont: config.baseFont,
  boldFont: config.boldFont,
  items: [
    GeniusPdfLabeledValue(
      config: config,
      label: 'Due Date',
      value: '30 days from invoice date',
    ),
  ],
);''',
      preview: Column(
        children: [
          _buildDataGridPreview(isDark),
          const SizedBox(height: 20),
          _infoBox('Payment Terms', 'Due in 30 days', Icons.info_outline,
              AppColors.info, isDark),
        ],
      ),
    );
  }

  Widget _buildGridWatermarkTab(bool isDark) {
    return ComponentPage(
      title: 'Grid with Watermark',
      description: 'Apply textual or image watermarks to grid pages.',
      icon: Icons.water_drop_rounded,
      gradient: AppColors.successGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: () => _generatePdf('grid_watermark'),
      codeExample: '''
final builder = GeniusPdfDocumentBuilder(config);

// Add content...

// Apply Watermark
builder.applyWatermark(
  text: 'CONFIDENTIAL',
  color: PdfColor(0.9, 0, 0),
  opacity: 0.1,
  rotation: 45,
);''',
      preview: Stack(
        children: [
          _buildDataGridPreview(isDark),
          Positioned.fill(
            child: Center(
              child: Transform.rotate(
                angle: -0.5,
                child: Text(
                  'CONFIDENTIAL',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.red.withOpacity(0.1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridRichtextTab(bool isDark) {
    return ComponentPage(
      title: 'Grid with Rich Text',
      description: 'Add rich text descriptions or notes around the grid.',
      icon: Icons.format_quote_rounded,
      gradient: AppColors.warningGradient,
      isDark: isDark,
      isRTL: _isRTL,
      onRTLChanged: (v) => setState(() => _isRTL = v),
      isGenerating: _isGenerating,
      onGenerate: () => _generatePdf('grid_richtext'),
      codeExample: '''
final builder = GeniusPdfDocumentBuilder(config);

// Add Rich Text Header
builder.addRichText(
  GeniusPdfRichTextBuilder(config: config)
    .heading('Sales Report')
    .newLine()
    .text('Overview of quarterly performance.')
    .build(),
);

builder.addDataGrid(...);''',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('Sales Report',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text('Overview of quarterly performance.',
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          _buildDataGridPreview(isDark),
        ],
      ),
    );
  }

  Future<void> _generatePdf(String type) async {
    setState(() => _isGenerating = true);
    try {
      // Update config based on RTL selection
      final updatedConfig = geniusPdfConfig.copyWith(
        textDirection: _isRTL ? TextDirection.rtl : TextDirection.ltr,
      );

      final Uint8List bytes =
          await buildComponentDemoBytes(component: type, config: updatedConfig);

      final output = await getApplicationDocumentsDirectory();
      final file = File('${output.path}/demo_$type.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: AppColors.error,
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

class _ComponentTab {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  _ComponentTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}
