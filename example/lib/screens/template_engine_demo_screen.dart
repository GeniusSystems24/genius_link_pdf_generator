import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import '../theme/app_theme.dart';

/// Model class for template engine tabs.
class _EngineTab {
  final String id;
  final String title;
  final String titleAr;
  final IconData icon;
  final List<Color> gradient;

  const _EngineTab({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.icon,
    required this.gradient,
  });
}

/// Demo screen for Template Engine features (v1.5.0).
class TemplateEngineDemoScreen extends StatefulWidget {
  const TemplateEngineDemoScreen({super.key});

  @override
  State<TemplateEngineDemoScreen> createState() =>
      _TemplateEngineDemoScreenState();
}

class _TemplateEngineDemoScreenState extends State<TemplateEngineDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PdfFont? _font;
  bool _isLoading = false;
  String _status = '';
  Uint8List? _pdfBytes;

  final List<_EngineTab> _tabs = [
    _EngineTab(
      id: 'builder',
      title: 'Builder',
      titleAr: 'المنشئ',
      icon: Icons.build_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _EngineTab(
      id: 'json',
      title: 'JSON',
      titleAr: 'جيسون',
      icon: Icons.code_rounded,
      gradient: AppColors.cyanGradient,
    ),
    _EngineTab(
      id: 'registry',
      title: 'Registry',
      titleAr: 'السجل',
      icon: Icons.inventory_2_rounded,
      gradient: AppColors.purpleGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() => setState(() {}));
    _loadFont();
  }

  Future<void> _loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/din/din.ttf');
    setState(() {
      _font = PdfTrueTypeFont(fontData.buffer.asUint8List(), 12);
    });
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
                _buildBuilderTab(isDark),
                _buildJsonTab(isDark),
                _buildRegistryTab(isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(bool isDark) {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(6),
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
        children: _tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final tab = entry.value;
          final isSelected = _tabController.index == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => _tabController.animateTo(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                decoration: BoxDecoration(
                  gradient: isSelected ? LinearGradient(colors: tab.gradient) : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      tab.icon,
                      size: 20,
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        tab.title,
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBuilderTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            isDark: isDark,
            icon: Icons.build_rounded,
            title: 'Template Builder',
            titleAr: 'منشئ القوالب',
            description: 'Create templates programmatically using TemplateBuilder',
            gradient: AppColors.primaryGradient,
          ),
          const SizedBox(height: 20),
          _buildActionsCard(
            isDark: isDark,
            children: [
              _buildActionButton(
                isDark: isDark,
                label: 'Generate Invoice Template',
                labelAr: 'إنشاء قالب فاتورة',
                icon: Icons.receipt_rounded,
                gradient: AppColors.successGradient,
                onPressed: _generateInvoiceTemplate,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Generate Report Template',
                labelAr: 'إنشاء قالب تقرير',
                icon: Icons.article_rounded,
                gradient: AppColors.orangeGradient,
                onPressed: _generateReportTemplate,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusCard(isDark),
        ],
      ),
    );
  }

  Widget _buildJsonTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            isDark: isDark,
            icon: Icons.code_rounded,
            title: 'JSON Templates',
            titleAr: 'قوالب JSON',
            description: 'Define templates in JSON format for portability',
            gradient: AppColors.cyanGradient,
          ),
          const SizedBox(height: 20),
          _buildActionsCard(
            isDark: isDark,
            children: [
              _buildActionButton(
                isDark: isDark,
                label: 'Load from JSON',
                labelAr: 'تحميل من JSON',
                icon: Icons.upload_file_rounded,
                gradient: AppColors.primaryGradient,
                onPressed: _generateFromJson,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Export to JSON',
                labelAr: 'تصدير إلى JSON',
                icon: Icons.download_rounded,
                gradient: AppColors.purpleGradient,
                onPressed: _exportToJson,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusCard(isDark),
        ],
      ),
    );
  }

  Widget _buildRegistryTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            isDark: isDark,
            icon: Icons.inventory_2_rounded,
            title: 'Template Registry',
            titleAr: 'سجل القوالب',
            description: 'Manage templates centrally with the registry',
            gradient: AppColors.purpleGradient,
          ),
          const SizedBox(height: 20),
          _buildActionsCard(
            isDark: isDark,
            children: [
              _buildActionButton(
                isDark: isDark,
                label: 'Register Built-in Templates',
                labelAr: 'تسجيل القوالب المدمجة',
                icon: Icons.library_add_rounded,
                gradient: AppColors.successGradient,
                onPressed: _registerBuiltInTemplates,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'List All Templates',
                labelAr: 'عرض جميع القوالب',
                icon: Icons.list_rounded,
                gradient: AppColors.cyanGradient,
                onPressed: _listTemplates,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Render Built-in Invoice',
                labelAr: 'عرض الفاتورة المدمجة',
                icon: Icons.picture_as_pdf_rounded,
                gradient: AppColors.orangeGradient,
                onPressed: _renderBuiltInInvoice,
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildStatusCard(isDark),
        ],
      ),
    );
  }

  Widget _buildHeaderCard({
    required bool isDark,
    required IconData icon,
    required String title,
    required String titleAr,
    required String description,
    required List<Color> gradient,
  }) {
    return Container(
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withValues(alpha: 0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 20),
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
                Text(
                  titleAr,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  textDirection: TextDirection.rtl,
                ),
                const SizedBox(height: 8),
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

  Widget _buildActionsCard({
    required bool isDark,
    required List<Widget> children,
  }) {
    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.play_circle_rounded,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Actions',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required bool isDark,
    required String label,
    required String labelAr,
    required IconData icon,
    required List<Color> gradient,
    required VoidCallback onPressed,
  }) {
    final isEnabled = _font != null && !_isLoading;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: isEnabled ? LinearGradient(colors: gradient) : null,
            color: isEnabled ? null : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
              Icon(
                icon,
                color: isEnabled ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                size: 24,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isEnabled ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                    ),
                    Text(
                      labelAr,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEnabled
                            ? Colors.white.withValues(alpha: 0.8)
                            : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
              if (_isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      isEnabled ? Colors.white : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                    ),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isEnabled ? Colors.white.withValues(alpha: 0.8) : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    if (_status.isEmpty) return const SizedBox.shrink();

    final isSuccess = _pdfBytes != null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSuccess
              ? AppColors.successGradient.first.withValues(alpha: 0.5)
              : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
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
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isSuccess ? AppColors.successGradient : AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isSuccess ? Icons.check_circle_rounded : Icons.info_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              if (_pdfBytes != null) ...[
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.successGradient.first.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${(_pdfBytes!.length / 1024).toStringAsFixed(1)} KB',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.successGradient.first,
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.2)
                  : Colors.grey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _status,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'monospace',
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateInvoiceTemplate() async {
    if (_font == null) return;

    setState(() {
      _isLoading = true;
      _status = 'Building invoice template...';
    });

    try {
      // Build template
      final template = TemplateBuilder(
        id: 'demo-invoice',
        name: 'Demo Invoice',
        nameAr: 'فاتورة تجريبية',
      )
          .addVariable(TemplateVariable.string('invoiceNumber', required: true))
          .addVariable(TemplateVariable.string('customerName', required: true))
          .addVariable(TemplateVariable.date('invoiceDate'))
          .addVariable(TemplateVariable.list('items'))
          .addVariable(TemplateVariable.currency('total'))
          .addText('INVOICE', textAr: 'فاتورة', fontSize: 24)
          .addSpacer(20)
          .addRow([
            const VariableElement(
              variableName: 'invoiceNumber',
              prefix: 'Invoice #: ',
              prefixAr: 'رقم الفاتورة: ',
            ),
            const VariableElement(
              variableName: 'invoiceDate',
              prefix: 'Date: ',
              prefixAr: 'التاريخ: ',
            ),
          ], flexValues: [
            1,
            1
          ])
          .addSpacer(10)
          .addVariableElement('customerName', prefix: 'Customer: ')
          .addSpacer(20)
          .addDivider()
          .addSpacer(10)
          .addTable(
            columns: [
              const TableColumn(
                  field: 'name', title: 'Item', titleAr: 'البند', flex: 2),
              const TableColumn(
                  field: 'qty', title: 'Qty', titleAr: 'الكمية', flex: 1),
              const TableColumn(
                  field: 'price', title: 'Price', titleAr: 'السعر', flex: 1),
            ],
            dataVariable: 'items',
          )
          .addSpacer(10)
          .addDivider()
          .addSpacer(10)
          .addVariableElement('total', prefix: 'Total: ', suffix: ' SAR')
          .build();

      // Render with sample data
      final engine = PdfTemplateEngine(baseFont: _font!);
      final bytes = await engine.render(
        template: template,
        data: {
          'invoiceNumber': 'INV-2026-001',
          'customerName': 'Ahmed Mohamed',
          'invoiceDate': DateTime.now().toString().split(' ')[0],
          'items': [
            {'name': 'Product A', 'qty': 2, 'price': 150},
            {'name': 'Product B', 'qty': 1, 'price': 300},
            {'name': 'Product C', 'qty': 3, 'price': 75},
          ],
          'total': 825,
        },
        isRtl: false,
      );

      setState(() {
        _pdfBytes = bytes;
        _status = 'Invoice template generated successfully!\n'
            'Template ID: ${template.id}\n'
            'Variables: ${template.variables.length}\n'
            'Elements: ${template.content.length}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateReportTemplate() async {
    if (_font == null) return;

    setState(() {
      _isLoading = true;
      _status = 'Building report template...';
    });

    try {
      final template = TemplateBuilder(
        id: 'demo-report',
        name: 'Monthly Report',
        nameAr: 'التقرير الشهري',
      )
          .addVariable(TemplateVariable.string('title', required: true))
          .addVariable(TemplateVariable.string('department'))
          .addVariable(TemplateVariable.date('reportDate'))
          .addVariable(TemplateVariable.list('sections'))
          .addText('MONTHLY REPORT', textAr: 'التقرير الشهري', fontSize: 24)
          .addSpacer(15)
          .addVariableElement('title', prefix: 'Title: ')
          .addVariableElement('department', prefix: 'Department: ')
          .addVariableElement('reportDate', prefix: 'Date: ')
          .addSpacer(20)
          .addDivider(thickness: 2)
          .addSpacer(15)
          .addLoop(
        variable: 'sections',
        itemName: 'section',
        children: [
          const VariableElement(
            variableName: 'section.title',
            fontSize: 16,
            isBold: true,
          ),
          const SpacerElement(height: 5),
          const VariableElement(variableName: 'section.content'),
          const SpacerElement(height: 15),
        ],
      ).build();

      final engine = PdfTemplateEngine(baseFont: _font!);
      final bytes = await engine.render(
        template: template,
        data: {
          'title': 'Q1 Performance Review',
          'department': 'Engineering',
          'reportDate': DateTime.now().toString().split(' ')[0],
          'sections': [
            {
              'title': 'Summary',
              'content':
                  'Overall performance exceeded expectations with 120% target achievement.',
            },
            {
              'title': 'Key Achievements',
              'content':
                  'Launched 3 new products, reduced costs by 15%, improved efficiency by 25%.',
            },
            {
              'title': 'Challenges',
              'content':
                  'Supply chain disruptions caused delays in Q1. Mitigation measures implemented.',
            },
          ],
        },
        isRtl: false,
      );

      setState(() {
        _pdfBytes = bytes;
        _status = 'Report template generated successfully!\n'
            'Template ID: ${template.id}\n'
            'Variables: ${template.variables.length}\n'
            'Elements: ${template.content.length}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateFromJson() async {
    if (_font == null) return;

    setState(() {
      _isLoading = true;
      _status = 'Loading template from JSON...';
    });

    try {
      // Define template in JSON
      const jsonTemplate = '''
{
  "id": "json-letter",
  "name": "Business Letter",
  "nameAr": "خطاب رسمي",
  "version": "1.0.0",
  "category": "general",
  "variables": [
    {"name": "recipient", "type": "string", "required": true, "label": "Recipient"},
    {"name": "subject", "type": "string", "required": true, "label": "Subject"},
    {"name": "body", "type": "string", "required": true, "label": "Body"},
    {"name": "sender", "type": "string", "required": true, "label": "Sender"},
    {"name": "date", "type": "date", "label": "Date"}
  ],
  "content": [
    {"type": "variable", "variableName": "date"},
    {"type": "spacer", "height": 20},
    {"type": "variable", "variableName": "recipient", "prefix": "To: ", "prefixAr": "إلى: "},
    {"type": "spacer", "height": 15},
    {"type": "variable", "variableName": "subject", "prefix": "Subject: ", "prefixAr": "الموضوع: ", "isBold": true},
    {"type": "spacer", "height": 20},
    {"type": "variable", "variableName": "body"},
    {"type": "spacer", "height": 30},
    {"type": "text", "text": "Best regards,", "textAr": "مع أطيب التحيات،"},
    {"type": "spacer", "height": 10},
    {"type": "variable", "variableName": "sender", "isBold": true}
  ]
}
''';

      final template = TemplateDefinition.fromJsonString(jsonTemplate);

      final engine = PdfTemplateEngine(baseFont: _font!);
      final bytes = await engine.render(
        template: template,
        data: {
          'recipient': 'Mr. John Smith\nABC Corporation',
          'subject': 'Partnership Proposal',
          'body': 'Dear Mr. Smith,\n\nI am writing to propose a strategic partnership between our organizations. '
              'Our companies share similar values and complementary strengths that could benefit both parties.\n\n'
              'I would welcome the opportunity to discuss this proposal in detail at your convenience.',
          'sender': 'Sarah Johnson\nCEO, XYZ Inc.',
          'date': DateTime.now().toString().split(' ')[0],
        },
        isRtl: false,
      );

      setState(() {
        _pdfBytes = bytes;
        _status = 'Template loaded from JSON successfully!\n'
            'Template: ${template.name}\n'
            'Version: ${template.version}\n'
            'Variables: ${template.variables.length}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _exportToJson() async {
    setState(() {
      _isLoading = true;
      _status = 'Creating and exporting template...';
    });

    try {
      final template = TemplateDefinition(
        id: 'export-demo',
        name: 'Export Demo',
        nameAr: 'عرض التصدير',
        description: 'A template for demonstrating JSON export',
        version: '1.0.0',
        author: 'Genius Systems',
        category: TemplateCategory.general,
        tags: ['demo', 'export', 'example'],
        variables: [
          TemplateVariable.string('title', required: true, label: 'Title'),
          TemplateVariable.list('items', label: 'Items'),
        ],
        content: const [
          TextElement(text: 'Demo Template', fontSize: 20),
          SpacerElement(height: 10),
          VariableElement(variableName: 'title'),
        ],
      );

      final json = template.toJsonString(pretty: true);

      setState(() {
        _status = 'Template exported to JSON:\n\n$json';
        _pdfBytes = null;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _registerBuiltInTemplates() async {
    setState(() {
      _isLoading = true;
      _status = 'Registering built-in templates...';
    });

    try {
      final registry = TemplateRegistry.instance;
      registry.clear();
      TemplateLibrary.registerBuiltInTemplates(registry);

      setState(() {
        _status = 'Built-in templates registered!\n'
            'Total templates: ${registry.count}\n'
            'Categories: ${registry.categories.join(", ")}\n'
            'Tags: ${registry.allTags.join(", ")}';
        _pdfBytes = null;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _listTemplates() async {
    setState(() {
      _isLoading = true;
      _status = 'Listing templates...';
    });

    try {
      final registry = TemplateRegistry.instance;

      if (registry.count == 0) {
        TemplateLibrary.registerBuiltInTemplates(registry);
      }

      final templates = registry.templates;
      final buffer = StringBuffer('Registered Templates:\n\n');

      for (final template in templates) {
        buffer.writeln('• ${template.name} (${template.nameAr ?? ""})');
        buffer.writeln('  ID: ${template.id}');
        buffer.writeln('  Category: ${template.category ?? "none"}');
        buffer.writeln('  Variables: ${template.variables.length}');
        buffer.writeln('');
      }

      setState(() {
        _status = buffer.toString();
        _pdfBytes = null;
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _renderBuiltInInvoice() async {
    if (_font == null) return;

    setState(() {
      _isLoading = true;
      _status = 'Rendering built-in invoice template...';
    });

    try {
      final registry = TemplateRegistry.instance;

      if (!registry.has('builtin-simple-invoice')) {
        TemplateLibrary.registerBuiltInTemplates(registry);
      }

      final template = registry.getOrThrow('builtin-simple-invoice');

      final engine = PdfTemplateEngine(baseFont: _font!);
      final bytes = await engine.render(
        template: template,
        data: {
          'invoiceNumber': 'INV-2026-999',
          'invoiceDate': DateTime.now().toIso8601String(),
          'customerName': 'Test Customer',
          'items': [
            {'name': 'Service A', 'quantity': 1, 'price': 500, 'total': 500},
            {'name': 'Service B', 'quantity': 2, 'price': 250, 'total': 500},
          ],
          'total': 1000,
        },
        isRtl: false,
      );

      setState(() {
        _pdfBytes = bytes;
        _status = 'Built-in invoice rendered successfully!\n'
            'Template: ${template.name}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
