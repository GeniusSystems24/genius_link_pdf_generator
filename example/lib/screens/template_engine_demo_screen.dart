import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:genius_pdf_example/main.dart';

import '../documents/template_builtin_invoice.dart';
import '../documents/template_builtin_letter.dart';
import '../documents/template_builtin_report.dart';
import '../documents/template_contract.dart';
import '../documents/template_export_json.dart';
import '../documents/template_invoice.dart';
import '../documents/template_json_letter.dart';
import '../documents/template_json_memo.dart';
import '../documents/template_purchase_order.dart';
import '../documents/template_quotation.dart';
import '../documents/template_receipt.dart';
import '../documents/template_report.dart';
import '../documents/template_timesheet.dart';
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
                  gradient:
                      isSelected ? LinearGradient(colors: tab.gradient) : null,
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
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        tab.title,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.lightTextSecondary),
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
            description:
                'Create templates programmatically using TemplateBuilder',
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
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Generate Purchase Order',
                labelAr: 'إنشاء أمر شراء',
                icon: Icons.shopping_cart_rounded,
                gradient: AppColors.cyanGradient,
                onPressed: _generatePurchaseOrderTemplate,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Generate Receipt Template',
                labelAr: 'إنشاء قالب إيصال',
                icon: Icons.receipt_long_rounded,
                gradient: AppColors.successGradient,
                onPressed: _generateReceiptTemplate,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Generate Quotation',
                labelAr: 'إنشاء عرض سعر',
                icon: Icons.request_quote_rounded,
                gradient: AppColors.orangeGradient,
                onPressed: _generateQuotationTemplate,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Generate Contract',
                labelAr: 'إنشاء عقد خدمة',
                icon: Icons.assignment_rounded,
                gradient: AppColors.purpleGradient,
                onPressed: _generateContractTemplate,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Generate Timesheet',
                labelAr: 'إنشاء سجل دوام',
                icon: Icons.schedule_rounded,
                gradient: AppColors.cyanGradient,
                onPressed: _generateTimesheetTemplate,
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
                label: 'Load Memo JSON',
                labelAr: 'تحميل مذكرة JSON',
                icon: Icons.note_alt_rounded,
                gradient: AppColors.orangeGradient,
                onPressed: _generateFromJsonMemo,
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
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Render Built-in Report',
                labelAr: 'عرض التقرير المدمج',
                icon: Icons.assessment_rounded,
                gradient: AppColors.cyanGradient,
                onPressed: _renderBuiltInReport,
              ),
              const SizedBox(height: 12),
              _buildActionButton(
                isDark: isDark,
                label: 'Render Built-in Letter',
                labelAr: 'عرض الخطاب المدمج',
                icon: Icons.mail_outline_rounded,
                gradient: AppColors.primaryGradient,
                onPressed: _renderBuiltInLetter,
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
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
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
    final isEnabled = !_isLoading;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
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
              Icon(
                icon,
                color: isEnabled
                    ? Colors.white
                    : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
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
                        color: isEnabled
                            ? Colors.white
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
                      ),
                    ),
                    Text(
                      labelAr,
                      style: TextStyle(
                        fontSize: 12,
                        color: isEnabled
                            ? Colors.white.withValues(alpha: 0.8)
                            : (isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary),
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
                      isEnabled
                          ? Colors.white
                          : (isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary),
                    ),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: isEnabled
                      ? Colors.white.withValues(alpha: 0.8)
                      : (isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary),
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
                    colors: isSuccess
                        ? AppColors.successGradient
                        : AppColors.primaryGradient,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color:
                        AppColors.successGradient.first.withValues(alpha: 0.15),
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
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _generateInvoiceTemplate() async {
    setState(() {
      _isLoading = true;
      _status = 'Building invoice template...';
    });

    try {
      // Build template
      final result = await buildTemplateInvoiceBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Invoice template generated successfully!\n'
            'Template ID: ${result.template.id}\n'
            'Variables: ${result.template.variables.length}\n'
            'Elements: ${result.template.content.length}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_invoice');
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
    setState(() {
      _isLoading = true;
      _status = 'Building report template...';
    });

    try {
      final result = await buildTemplateReportBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Report template generated successfully!\n'
            'Template ID: ${result.template.id}\n'
            'Variables: ${result.template.variables.length}\n'
            'Elements: ${result.template.content.length}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_report');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generatePurchaseOrderTemplate() async {
    setState(() {
      _isLoading = true;
      _status = 'Building purchase order template...';
    });

    try {
      final result = await buildTemplatePurchaseOrderBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Purchase order generated successfully!\n'
            'Template ID: ${result.template.id}\n'
            'Variables: ${result.template.variables.length}\n'
            'Elements: ${result.template.content.length}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_purchase_order');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
        _isLoading = false;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateReceiptTemplate() async {
    setState(() {
      _isLoading = true;
      _status = 'Building receipt template...';
    });

    try {
      final result = await buildTemplateReceiptBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Receipt template generated successfully!\n'
            'Template ID: ${result.template.id}\n'
            'Variables: ${result.template.variables.length}\n'
            'Elements: ${result.template.content.length}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_receipt');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateQuotationTemplate() async {
    setState(() {
      _isLoading = true;
      _status = 'Building quotation template...';
    });

    try {
      final result = await buildTemplateQuotationBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Quotation template generated successfully!\n'
            'Template ID: ${result.template.id}\n'
            'Variables: ${result.template.variables.length}\n'
            'Elements: ${result.template.content.length}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_quotation');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateContractTemplate() async {
    setState(() {
      _isLoading = true;
      _status = 'Building contract template...';
    });

    try {
      final result = await buildTemplateContractBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Contract template generated successfully!\n'
            'Template ID: ${result.template.id}\n'
            'Variables: ${result.template.variables.length}\n'
            'Elements: ${result.template.content.length}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_contract');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateTimesheetTemplate() async {
    setState(() {
      _isLoading = true;
      _status = 'Building timesheet template...';
    });

    try {
      final result = await buildTemplateTimesheetBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Timesheet template generated successfully!\n'
            'Template ID: ${result.template.id}\n'
            'Variables: ${result.template.variables.length}\n'
            'Elements: ${result.template.content.length}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_timesheet');
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
    setState(() {
      _isLoading = true;
      _status = 'Loading template from JSON...';
    });

    try {
      final result = await buildTemplateFromJsonLetterBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Template loaded from JSON successfully!\n'
            'Template: ${result.template.name}\n'
            'Version: ${result.template.version}\n'
            'Variables: ${result.template.variables.length}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_json_letter');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _generateFromJsonMemo() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading memo template from JSON...';
    });

    try {
      final result = await buildTemplateFromJsonMemoBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Memo template loaded from JSON!\n'
            'Template: ${result.template.name}\n'
            'Version: ${result.template.version}\n'
            'Variables: ${result.template.variables.length}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_json_memo');
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
      final json = buildExportTemplateJson();

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
    setState(() {
      _isLoading = true;
      _status = 'Rendering built-in invoice template...';
    });

    try {
      final result = await buildBuiltInInvoiceBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Built-in invoice rendered successfully!\n'
            'Template: ${result.template.name}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_builtin_invoice');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _renderBuiltInReport() async {
    setState(() {
      _isLoading = true;
      _status = 'Rendering built-in report template...';
    });

    try {
      final result = await buildBuiltInReportBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Built-in report rendered successfully!\n'
            'Template: ${result.template.name}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_builtin_report');
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
        _pdfBytes = null;
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _renderBuiltInLetter() async {
    setState(() {
      _isLoading = true;
      _status = 'Rendering built-in letter template...';
    });

    try {
      final result = await buildBuiltInLetterBytes(geniusPdfConfig);

      setState(() {
        _pdfBytes = result.bytes;
        _status = 'Built-in letter rendered successfully!\n'
            'Template: ${result.template.name}';
      });
      await _saveAndOpenPdf(result.bytes, 'template_builtin_letter');
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

  Future<void> _saveAndOpenPdf(Uint8List bytes, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName.pdf');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }
}
