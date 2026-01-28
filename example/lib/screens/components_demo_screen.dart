import 'dart:io';
import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart' show geniusPdfConfig;
import '../theme/app_theme.dart';
import '../widgets/code_viewer.dart';

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
        isScrollable: true,
        labelColor: AppColors.primary,
        unselectedLabelColor:
            isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(6),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        tabs: _tabs.map((tab) => _buildTab(tab, isDark)).toList(),
      ),
    );
  }

  Widget _buildTab(_ComponentTab tab, bool isDark) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: tab.gradient),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(tab.icon, size: 14, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text(tab.title,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildDataGridTab(bool isDark) {
    return _ComponentPage(
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
    return _ComponentPage(
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

// ─── Bullet List ───────────────────────────────
final list = GeniusPdfBulletList(
  items: [
    GeniusPdfBulletItem.simple('البند الأول'),
    GeniusPdfBulletItem.simple('البند الثاني'),
  ],
  style: GeniusPdfBulletStyle.disc,
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);

// ─── String Extensions ─────────────────────────
final span = 'مهم'.toBoldSpan(color: Colors.red);
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
          // Heading + badge
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
          // Label + bold value
          RichText(
            textDirection: TextDirection.rtl,
            text: TextSpan(
              style: TextStyle(fontSize: 14, color: textColor, height: 1.8),
              children: const [
                TextSpan(
                    text: 'رقم الفاتورة: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF424242))),
                TextSpan(
                    text: '#INV-2024-001',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Currency value
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
          // Strikethrough + positive
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
                        fontWeight: FontWeight.bold,
                        color: AppColors.success)),
              ],
            ),
          ),
          const Divider(height: 24),
          // Bullet list preview
          Text('عناصر البند:',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: textColor)),
          const SizedBox(height: 6),
          for (final item in [
            'خدمات استشارية',
            'تطوير برمجيات',
            'صيانة شهرية'
          ])
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
          // Highlighted text + superscript preview
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
    return _ComponentPage(
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
final infoBox = GeniusPdfInfoBox(
  title: 'ملاحظة هامة',
  style: GeniusPdfInfoBoxStyle.info(),
  items: [
    GeniusPdfLabeledValue(
      label: 'التفاصيل',
      value: 'يرجى الاحتفاظ بهذه الفاتورة...',
    ),
  ],
  baseFont: config.baseFont,
  boldFont: config.boldFont,
);

final warningBox = GeniusPdfInfoBox(
  title: 'تحذير',
  style: GeniusPdfInfoBoxStyle.warning(),
  items: [
    GeniusPdfLabeledValue(
      label: 'تنبيه',
      value: 'هذا المستند للمعاينة فقط',
    ),
  ],
  baseFont: config.baseFont,
  boldFont: config.boldFont,
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
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
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
    return _ComponentPage(
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
final header = GeniusPdfReportHeader(
  title: 'Tax Invoice',
  titleAr: 'فاتورة ضريبية',
  company: GeniusPdfCompanyInfo(
    name: 'Al-Amal Trading Co.',
    nameAr: 'شركة الأمل للتجارة',
    address: 'Riyadh, KSA',
    phone: '+966 11 123 4567',
    vatNumber: '300123456789003',
  ),
  style: GeniusPdfReportHeaderStyle.invoice(),
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
                AppColors.primary.withOpacity(0.1),
                AppColors.secondary.withOpacity(0.05),
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
                    color: AppColors.primary.withOpacity(0.1),
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
    return _ComponentPage(
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        children: [
          _summaryRow('المجموع الفرعي', '30,100.00 ر.س', isDark),
          _summaryRow('الخصم (3.3%)', '- 1,000.00 ر.س', isDark,
              valueColor: AppColors.error),
          const Divider(height: 24),
          _summaryRow('المبلغ الخاضع للضريبة', '29,100.00 ر.س', isDark),
          _summaryRow('ضريبة القيمة المضافة (15%)', '4,365.00 ر.س', isDark),
          const Divider(height: 24),
          _summaryRow('الإجمالي', '33,465.00 ر.س', isDark,
              isTotal: true, valueColor: AppColors.success),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, bool isDark,
      {bool isTotal = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontSize: isTotal ? 16 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
                color: isDark ? AppColors.darkText : AppColors.lightText,
              )),
          Text(value,
              style: TextStyle(
                fontSize: isTotal ? 18 : 14,
                fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
                color: valueColor ??
                    (isDark ? AppColors.darkText : AppColors.lightText),
              )),
        ],
      ),
    );
  }

  Future<void> _generatePdf(String component) async {
    setState(() => _isGenerating = true);
    try {
      final document = PdfDocument();
      final page = document.pages.add();
      final pageSize = page.getClientSize();
      final baseFont = geniusPdfConfig.fontBuild(fontSize: 10);
      final boldFont = geniusPdfConfig.fontBuild(fontSize: 10);
      final titleFont = geniusPdfConfig.fontBuild(fontSize: 16);

      // Draw title
      final titleText = _getComponentTitle(component);
      page.graphics.drawString(
        titleText,
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

      switch (component) {
        case 'data_grid':
          yOffset = _drawDataGrid(page, yOffset, baseFont, boldFont);
          break;
        case 'rich_text':
          yOffset = _drawRichText(page, yOffset, baseFont, boldFont);
          break;
        case 'info_box':
          yOffset = _drawInfoBox(page, yOffset, baseFont, boldFont);
          break;
        case 'headers':
          yOffset = _drawHeaders(page, yOffset, baseFont, boldFont);
          break;
        case 'summary':
          yOffset = _drawSummary(page, yOffset, baseFont, boldFont);
          break;
      }

      final bytes = await document.save();
      document.dispose();

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/component_$component.pdf');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: const Text('تم إنشاء PDF بنجاح'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('خطأ: $e'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  String _getComponentTitle(String component) {
    switch (component) {
      case 'data_grid':
        return _isRTL
            ? 'جدول البيانات - GeniusPdfDataGrid'
            : 'Data Grid - GeniusPdfDataGrid';
      case 'rich_text':
        return _isRTL
            ? 'نص منسق - GeniusPdfRichText'
            : 'Rich Text - GeniusPdfRichText';
      case 'info_box':
        return _isRTL
            ? 'صندوق المعلومات - GeniusPdfInfoBox'
            : 'Info Box - GeniusPdfInfoBox';
      case 'headers':
        return _isRTL
            ? 'رأس التقرير - GeniusPdfReportHeader'
            : 'Report Header - GeniusPdfReportHeader';
      case 'summary':
        return _isRTL
            ? 'ملخص المبالغ - GeniusPdfSummary'
            : 'Summary Section - GeniusPdfSummary';
      default:
        return component;
    }
  }

  double _drawDataGrid(
      PdfPage page, double yOffset, PdfFont baseFont, PdfFont boldFont) {
    final pageSize = page.getClientSize();

    final grid = GeniusPdfDataGrid(
      columns: [
        GeniusPdfGridColumn(
            id: 'code', title: 'Code', titleAr: 'الكود', width: 60),
        GeniusPdfGridColumn(
            id: 'desc', title: 'Description', titleAr: 'الوصف', flexFactor: 2),
        GeniusPdfGridColumn.numeric(id: 'qty', title: 'Qty', titleAr: 'الكمية'),
        GeniusPdfGridColumn.currency(
            id: 'price',
            title: 'Price',
            titleAr: 'السعر',
            currencySymbol: _isRTL ? 'ر.س' : 'SAR'),
        GeniusPdfGridColumn.currency(
            id: 'total',
            title: 'Total',
            titleAr: 'الإجمالي',
            currencySymbol: _isRTL ? 'ر.س' : 'SAR'),
      ],
      rows: [
        GeniusPdfGridRow(cells: {
          'code': '001',
          'desc': _isRTL ? 'منتج أول' : 'First Product',
          'qty': '10',
          'price': '100.00',
          'total': '1,000.00'
        }),
        GeniusPdfGridRow(cells: {
          'code': '002',
          'desc': _isRTL ? 'منتج ثاني' : 'Second Product',
          'qty': '5',
          'price': '200.00',
          'total': '1,000.00'
        }),
        GeniusPdfGridRow(cells: {
          'code': '003',
          'desc': _isRTL ? 'منتج ثالث' : 'Third Product',
          'qty': '8',
          'price': '150.00',
          'total': '1,200.00'
        }),
        GeniusPdfGridRow(cells: {
          'code': '004',
          'desc': _isRTL ? 'منتج رابع' : 'Fourth Product',
          'qty': '3',
          'price': '500.00',
          'total': '1,500.00'
        }),
        GeniusPdfGridRow.total(
            {'desc': _isRTL ? 'المجموع' : 'Total', 'total': '4,700.00'}),
      ],
      style: GeniusPdfGridStyle.corporate(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    );

    final result = grid.draw(
      page: page,
      bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 300),
    );

    return (result?.bounds.bottom ?? 0) + 20;
  }

  double _drawRichText(
      PdfPage page, double yOffset, PdfFont baseFont, PdfFont boldFont) {
    final pageSize = page.getClientSize();
    final w = pageSize.width - 40;

    // ── 1. Heading with badge using Builder ───────────────────────
    final heading = GeniusPdfRichTextBuilder(
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    )
        .heading(_isRTL ? 'ملخص الفاتورة' : 'Invoice Summary')
        .space()
        .badge(
          _isRTL ? 'مدفوعة' : 'PAID',
          backgroundColor: const Color(0xFF4CAF50),
        )
        .build();
    heading.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset, w, 25));

    // ── 2. Label + value using builder ────────────────────────────
    final invoiceLine = GeniusPdfRichTextBuilder(
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    )
        .label(_isRTL ? 'رقم الفاتورة' : 'Invoice No')
        .separator(': ')
        .bold('#INV-2024-001', color: const Color(0xFF2196F3))
        .build();
    invoiceLine.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 30, w, 25));

    // ── 3. Currency with symbol ───────────────────────────────────
    final totalLine = GeniusPdfRichTextBuilder(
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    )
        .text(_isRTL ? 'الإجمالي: ' : 'Total: ')
        .currency('34,615.00', symbol: _isRTL ? 'ر.س' : 'SAR')
        .build();
    totalLine.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 55, w, 25));

    // ── 4. Strikethrough + positive ───────────────────────────────
    final priceLine = GeniusPdfRichTextBuilder(
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    )
        .text(_isRTL ? 'السعر السابق: ' : 'Previous: ')
        .strikethrough('28,500.00')
        .space()
        .positive('34,615.00')
        .superscript('*')
        .build();
    priceLine.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 80, w, 25));

    // ── 5. Highlighted + small text ───────────────────────────────
    final noteLine = GeniusPdfRichTextBuilder(
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    )
        .highlight(_isRTL ? 'ملاحظة مهمة' : 'Important Note')
        .space()
        .small(_isRTL ? 'شامل الضريبة' : 'Tax inclusive',
            color: const Color(0xFF9E9E9E))
        .build();
    noteLine.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 105, w, 25));

    // ── 6. Bullet list ────────────────────────────────────────────
    final bulletList = GeniusPdfBulletList(
      items: [
        GeniusPdfBulletItem.simple(
            _isRTL ? 'خدمات استشارية' : 'Consulting services'),
        GeniusPdfBulletItem.simple(
            _isRTL ? 'تطوير برمجيات' : 'Software development'),
        GeniusPdfBulletItem(
          text: _isRTL ? 'الصيانة' : 'Maintenance',
          subItems: [
            GeniusPdfBulletItem.simple(
                _isRTL ? 'صيانة شهرية' : 'Monthly maintenance'),
            GeniusPdfBulletItem.simple(
                _isRTL ? 'دعم فني' : 'Technical support'),
          ],
        ),
      ],
      style: GeniusPdfBulletStyle.disc,
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    );
    bulletList.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 135, w, 120));

    // ── 7. Markdown parsed text ───────────────────────────────────
    final mdSpans = GeniusPdfSimpleMarkdownParser.parse(
      _isRTL
          ? 'هذا **نص عريض** و *مائل* مع `كود` و ~~محذوف~~'
          : 'This is **bold** and *italic* with `code` and ~~deleted~~',
    );
    final mdRichText = GeniusPdfRichText(
      spans: mdSpans,
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    );
    mdRichText.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset + 265, w, 25));

    return yOffset + 300;
  }

  double _drawInfoBox(
      PdfPage page, double yOffset, PdfFont baseFont, PdfFont boldFont) {
    final pageSize = page.getClientSize();
    final boxWidth = (pageSize.width - 60) / 2;

    // Customer info box
    final customerBox = GeniusPdfInfoBox(
      title: 'Customer Info',
      titleAr: 'بيانات العميل',
      items: [
        GeniusPdfLabeledValue(
            label: 'Name',
            labelAr: 'الاسم',
            value: _isRTL ? 'أحمد محمد' : 'Ahmed Mohammed',
            baseFont: baseFont,
            boldFont: boldFont,
            isRTL: _isRTL),
        GeniusPdfLabeledValue(
            label: 'Phone',
            labelAr: 'الهاتف',
            value: '+966 50 123 4567',
            baseFont: baseFont,
            boldFont: boldFont,
            isRTL: _isRTL),
        GeniusPdfLabeledValue(
            label: 'Email',
            labelAr: 'البريد',
            value: 'ahmed@example.com',
            baseFont: baseFont,
            boldFont: boldFont,
            isRTL: _isRTL),
        GeniusPdfLabeledValue(
            label: 'Address',
            labelAr: 'العنوان',
            value: _isRTL ? 'الرياض، السعودية' : 'Riyadh, Saudi Arabia',
            baseFont: baseFont,
            boldFont: boldFont,
            isRTL: _isRTL),
      ],
      style: GeniusPdfInfoBoxStyle.card(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    );
    customerBox.draw(
        page: page, bounds: Rect.fromLTWH(20, yOffset, boxWidth, 150));

    // Company info box
    final companyBox = GeniusPdfInfoBox(
      title: 'Company Info',
      titleAr: 'بيانات الشركة',
      items: [
        GeniusPdfLabeledValue(
            label: 'Company',
            labelAr: 'الشركة',
            value: _isRTL ? 'شركة الأمل' : 'Al-Amal Co.',
            baseFont: baseFont,
            boldFont: boldFont,
            isRTL: _isRTL),
        GeniusPdfLabeledValue(
            label: 'VAT',
            labelAr: 'الضريبة',
            value: '300123456789003',
            baseFont: baseFont,
            boldFont: boldFont,
            isRTL: _isRTL),
        GeniusPdfLabeledValue(
            label: 'CR',
            labelAr: 'السجل',
            value: '1010123456',
            baseFont: baseFont,
            boldFont: boldFont,
            isRTL: _isRTL),
        GeniusPdfLabeledValue(
            label: 'City',
            labelAr: 'المدينة',
            value: _isRTL ? 'الرياض' : 'Riyadh',
            baseFont: baseFont,
            boldFont: boldFont,
            isRTL: _isRTL),
      ],
      style: GeniusPdfInfoBoxStyle.highlighted(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    );
    companyBox.draw(
        page: page,
        bounds: Rect.fromLTWH(40 + boxWidth, yOffset, boxWidth, 150));

    return yOffset + 170;
  }

  double _drawHeaders(
      PdfPage page, double yOffset, PdfFont baseFont, PdfFont boldFont) {
    final pageSize = page.getClientSize();

    final header = GeniusPdfReportHeader(
      title: 'Tax Invoice',
      titleAr: 'فاتورة ضريبية',
      subtitle: 'Invoice #INV-2024-001',
      subtitleAr: 'فاتورة رقم #INV-2024-001',
      company: GeniusPdfCompanyInfo(
        name: 'Al-Amal Trading Company',
        nameAr: 'شركة الأمل للتجارة',
        vatNumber: '300123456789003',
        address: 'King Fahd Road',
        addressAr: 'طريق الملك فهد',
        city: 'Riyadh',
        cityAr: 'الرياض',
        country: 'Saudi Arabia',
        countryAr: 'المملكة العربية السعودية',
        phone: '+966 11 123 4567',
        email: 'info@alamal.com',
      ),
      style: GeniusPdfReportHeaderStyle.invoice(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    );

    final result = header.draw(
        page: page,
        bounds: Rect.fromLTWH(20, yOffset, pageSize.width - 40, 150));

    return result + 20;
  }

  double _drawSummary(
      PdfPage page, double yOffset, PdfFont baseFont, PdfFont boldFont) {
    final pageSize = page.getClientSize();

    final summary = GeniusPdfSummarySection(
      items: [
        GeniusPdfSummaryItem(
          label: 'Subtotal',
          labelAr: 'المجموع الفرعي',
          value: _isRTL ? '30,100.00 ر.س' : 'SAR 30,100.00',
        ),
        GeniusPdfSummaryItem(
          label: 'Discount (3.3%)',
          labelAr: 'الخصم (3.3%)',
          value: _isRTL ? '- 1,000.00 ر.س' : '- SAR 1,000.00',
          valueColor: const Color(0xFFF44336),
        ),
        GeniusPdfSummaryItem(
          label: 'Taxable Amount',
          labelAr: 'المبلغ الخاضع للضريبة',
          value: _isRTL ? '29,100.00 ر.س' : 'SAR 29,100.00',
        ),
        GeniusPdfSummaryItem(
          label: 'VAT (15%)',
          labelAr: 'ضريبة القيمة المضافة (15%)',
          value: _isRTL ? '4,365.00 ر.س' : 'SAR 4,365.00',
        ),
        GeniusPdfSummaryItem.total(
          label: 'Total',
          labelAr: 'الإجمالي',
          value: _isRTL ? '33,465.00 ر.س' : 'SAR 33,465.00',
          valueColor: const Color(0xFF4CAF50),
        ),
      ],
      style: GeniusPdfSummaryStyle.invoice(),
      baseFont: baseFont,
      boldFont: boldFont,
      isRTL: _isRTL,
    );

    final result = summary.draw(
        page: page,
        bounds: Rect.fromLTWH(
            pageSize.width / 2 - 20, yOffset, pageSize.width / 2, 200));

    return result.bottom + 20;
  }
}

class _ComponentTab {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  const _ComponentTab(
      {required this.id,
      required this.title,
      required this.icon,
      required this.gradient});
}

class _ComponentPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final bool isDark;
  final bool isRTL;
  final ValueChanged<bool> onRTLChanged;
  final bool isGenerating;
  final VoidCallback onGenerate;
  final String codeExample;
  final Widget preview;

  const _ComponentPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.isDark,
    required this.isRTL,
    required this.onRTLChanged,
    required this.isGenerating,
    required this.onGenerate,
    required this.codeExample,
    required this.preview,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildOptions(),
          const SizedBox(height: 16),
          _buildPreview(),
          const SizedBox(height: 16),
          _buildCode(),
          const SizedBox(height: 16),
          _buildGenerateButton(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          gradient.first.withOpacity(isDark ? 0.2 : 0.1),
          gradient.last.withOpacity(isDark ? 0.1 : 0.05),
        ]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: gradient.first.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: gradient.first.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4))
              ],
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
                        color:
                            isDark ? AppColors.darkText : AppColors.lightText)),
                const SizedBox(height: 4),
                Text(description,
                    style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Icon(Icons.tune_rounded,
              size: 18,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary),
          const SizedBox(width: 8),
          Text('Options',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText)),
          const Spacer(),
          Text('LTR',
              style: TextStyle(
                  fontSize: 12,
                  color:
                      !isRTL ? AppColors.primary : AppColors.darkTextSecondary,
                  fontWeight: !isRTL ? FontWeight.w600 : FontWeight.normal)),
          Switch(
              value: isRTL,
              onChanged: onRTLChanged,
              activeColor: AppColors.primary),
          Text('RTL',
              style: TextStyle(
                  fontSize: 12,
                  color:
                      isRTL ? AppColors.primary : AppColors.darkTextSecondary,
                  fontWeight: isRTL ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.preview_rounded,
                size: 18,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary),
            const SizedBox(width: 8),
            Text('Preview',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText)),
          ]),
          const SizedBox(height: 16),
          preview,
        ],
      ),
    );
  }

  Widget _buildCode() {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Icon(Icons.code_rounded,
                  size: 18,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
              const SizedBox(width: 8),
              Text('Code Example',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color:
                          isDark ? AppColors.darkText : AppColors.lightText)),
            ]),
          ),
          CodeViewer(code: codeExample, height: 200),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: isGenerating ? null : onGenerate,
        icon: isGenerating
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
            : const Icon(Icons.picture_as_pdf_rounded),
        label: Text(isGenerating ? 'جاري الإنشاء...' : 'إنشاء PDF'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: gradient.first,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}
