import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;
import 'package:pdf/pdf.dart' hide PdfFont;

import '../theme/app_theme.dart';

/// Demo screen for V2 Architecture features (v2.0.0).
class V2ArchitectureDemoScreen extends StatefulWidget {
  const V2ArchitectureDemoScreen({super.key});

  @override
  State<V2ArchitectureDemoScreen> createState() =>
      _V2ArchitectureDemoScreenState();
}

class _V2ArchitectureDemoScreenState extends State<V2ArchitectureDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  PdfFont? _font;
  bool _isLoading = false;
  String _status = '';
  final List<String> _eventLog = [];
  StreamSubscription? _eventSubscription;

  final List<_ArchTab> _tabs = [
    _ArchTab(
      id: 'fluent',
      title: 'Fluent API',
      icon: Icons.code_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _ArchTab(
      id: 'plugins',
      title: 'Plugins',
      icon: Icons.extension_rounded,
      gradient: AppColors.purpleGradient,
    ),
    _ArchTab(
      id: 'di',
      title: 'DI',
      icon: Icons.settings_input_component_rounded,
      gradient: AppColors.cyanGradient,
    ),
    _ArchTab(
      id: 'events',
      title: 'Events',
      icon: Icons.bolt_rounded,
      gradient: AppColors.orangeGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _loadFont();
    _setupEventListener();
  }

  Future<void> _loadFont() async {
    final fontData = await rootBundle.load('assets/fonts/din/din.ttf');
    setState(() {
      _font = PdfTrueTypeFont(fontData.buffer.asUint8List(), 12);
    });
  }

  void _setupEventListener() {
    _eventSubscription = GeniusPdfEventBus.instance.events.listen((event) {
      setState(() {
        _eventLog.insert(0,
            '${DateTime.now().toString().substring(11, 19)} - ${event.name}');
        if (_eventLog.length > 20) {
          _eventLog.removeLast();
        }
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _eventSubscription?.cancel();
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
                _buildFluentApiTab(isDark),
                _buildPluginsTab(isDark),
                _buildDiTab(isDark),
                _buildEventsTab(isDark),
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
          gradient: const LinearGradient(colors: AppColors.primaryGradient),
          borderRadius: BorderRadius.circular(12),
        ),
        dividerColor: Colors.transparent,
        padding: const EdgeInsets.all(6),
        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
        tabs: _tabs.map((tab) => _buildTab(tab, isDark)).toList(),
      ),
    );
  }

  Widget _buildTab(_ArchTab tab, bool isDark) {
    return Tab(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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

  Widget _buildHeaderCard({
    required bool isDark,
    required String title,
    required String titleAr,
    required String description,
    required IconData icon,
    required List<Color> gradient,
  }) {
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
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: gradient),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: gradient.first.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color:
                              isDark ? AppColors.darkText : AppColors.lightText,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: gradient.first.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        titleAr,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: gradient.first,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: _isLoading ? null : LinearGradient(colors: gradient),
        color: _isLoading
            ? (isDark ? AppColors.darkCard : AppColors.lightBorder)
            : null,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _isLoading
            ? null
            : [
                BoxShadow(
                  color: gradient.first.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        labelAr,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                    ],
                  ),
                ),
                if (_isLoading)
                  const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(bool isDark) {
    if (_status.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 16),
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.info.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.info_rounded,
                  color: AppColors.info,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Status',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _status,
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFluentApiTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            isDark: isDark,
            title: 'Enhanced Fluent API',
            titleAr: 'واجهة برمجة متسلسلة محسنة',
            description:
                'Build PDFs with a chainable, expressive API for complex document generation.',
            icon: Icons.code_rounded,
            gradient: AppColors.primaryGradient,
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            isDark: isDark,
            label: 'Build Simple Document',
            labelAr: 'إنشاء مستند بسيط',
            icon: Icons.description_rounded,
            gradient: AppColors.primaryGradient,
            onPressed: _buildSimpleDocument,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'Build Invoice',
            labelAr: 'إنشاء فاتورة',
            icon: Icons.receipt_rounded,
            gradient: AppColors.successGradient,
            onPressed: _buildInvoice,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'Build Multi-Page Report',
            labelAr: 'إنشاء تقرير متعدد الصفحات',
            icon: Icons.article_rounded,
            gradient: AppColors.purpleGradient,
            onPressed: _buildMultiPageReport,
          ),
          _buildStatusCard(isDark),
        ],
      ),
    );
  }

  Widget _buildPluginsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            isDark: isDark,
            title: 'Plugin System',
            titleAr: 'نظام الإضافات',
            description:
                'Extend functionality with custom plugins for advanced document processing.',
            icon: Icons.extension_rounded,
            gradient: AppColors.purpleGradient,
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            isDark: isDark,
            label: 'Register Demo Plugin',
            labelAr: 'تسجيل إضافة تجريبية',
            icon: Icons.add_circle_rounded,
            gradient: AppColors.primaryGradient,
            onPressed: _registerDemoPlugin,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'List Registered Plugins',
            labelAr: 'عرض الإضافات المسجلة',
            icon: Icons.list_rounded,
            gradient: AppColors.cyanGradient,
            onPressed: _listPlugins,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'Initialize All Plugins',
            labelAr: 'تهيئة جميع الإضافات',
            icon: Icons.play_arrow_rounded,
            gradient: AppColors.successGradient,
            onPressed: _initializePlugins,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'Reset Plugin Manager',
            labelAr: 'إعادة تعيين مدير الإضافات',
            icon: Icons.refresh_rounded,
            gradient: AppColors.orangeGradient,
            onPressed: _resetPluginManager,
          ),
          _buildStatusCard(isDark),
        ],
      ),
    );
  }

  Widget _buildDiTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            isDark: isDark,
            title: 'Dependency Injection',
            titleAr: 'حقن التبعيات',
            description:
                'Manage dependencies with the lightweight DI container for scalable applications.',
            icon: Icons.settings_input_component_rounded,
            gradient: AppColors.cyanGradient,
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            isDark: isDark,
            label: 'Register Services',
            labelAr: 'تسجيل الخدمات',
            icon: Icons.add_box_rounded,
            gradient: AppColors.primaryGradient,
            onPressed: _registerServices,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'Resolve Dependencies',
            labelAr: 'حل التبعيات',
            icon: Icons.search_rounded,
            gradient: AppColors.purpleGradient,
            onPressed: _resolveDependencies,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'Demo Lazy Singleton',
            labelAr: 'عرض Singleton الكسول',
            icon: Icons.timer_rounded,
            gradient: AppColors.successGradient,
            onPressed: _demoLazySingleton,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'Reset Container',
            labelAr: 'إعادة تعيين الحاوية',
            icon: Icons.delete_sweep_rounded,
            gradient: AppColors.errorGradient,
            onPressed: _resetContainer,
          ),
          _buildStatusCard(isDark),
        ],
      ),
    );
  }

  Widget _buildEventsTab(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeaderCard(
            isDark: isDark,
            title: 'Event-Driven Architecture',
            titleAr: 'بنية مبنية على الأحداث',
            description:
                'React to document lifecycle events for real-time monitoring and logging.',
            icon: Icons.bolt_rounded,
            gradient: AppColors.orangeGradient,
          ),
          const SizedBox(height: 20),
          _buildActionButton(
            isDark: isDark,
            label: 'Emit Document Created',
            labelAr: 'إرسال حدث إنشاء مستند',
            icon: Icons.add_circle_rounded,
            gradient: AppColors.primaryGradient,
            onPressed: _emitDocumentCreated,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'Emit Render Progress',
            labelAr: 'إرسال حدث تقدم العرض',
            icon: Icons.trending_up_rounded,
            gradient: AppColors.successGradient,
            onPressed: _emitRenderProgress,
          ),
          _buildActionButton(
            isDark: isDark,
            label: 'Clear Event Log',
            labelAr: 'مسح سجل الأحداث',
            icon: Icons.clear_all_rounded,
            gradient: AppColors.errorGradient,
            onPressed: () {
              setState(() {
                _eventLog.clear();
                _status = 'Event log cleared.';
              });
            },
          ),
          const SizedBox(height: 16),
          _buildEventLogCard(isDark),
          _buildStatusCard(isDark),
        ],
      ),
    );
  }

  Widget _buildEventLogCard(bool isDark) {
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.warning.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(
                  Icons.history_rounded,
                  color: AppColors.warning,
                  size: 16,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Event Log',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${_eventLog.length} events',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_eventLog.isEmpty)
            Text(
              'No events yet. Emit some events to see them here.',
              style: TextStyle(
                fontSize: 13,
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            )
          else
            ...(_eventLog.take(10).map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          e,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.lightTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
        ],
      ),
    );
  }

  // ============ Fluent API Demos ============

  Future<void> _buildSimpleDocument() async {
    setState(() {
      _isLoading = true;
      _status = 'Building document with Fluent API...';
    });

    try {
      final pdf = GeniusPdfBuilder(id: 'simple-doc')
          .metadata(title: 'Simple Document', author: 'Demo')
          .pageFormat(PdfPageFormat.a4)
          .addPage((page) => page
              .header('Welcome to V2 Architecture')
              .spacer(20)
              .paragraph(
                  'This document was created using the new enhanced Fluent API '
                  'introduced in version 2.0.0 of the PDF Generator library.')
              .spacer(10)
              .bulletList([
                'Plugin System for extensibility',
                'Dependency Injection container',
                'Event-driven architecture',
                'Smart caching system',
                'Platform compatibility',
              ])
              .spacer(20)
              .divider()
              .spacer(10)
              .paragraph(
                  'The Fluent API makes it easy to create complex documents '
                  'with a chainable, expressive syntax.')
              .build())
          .build();

      setState(() {
        _status = 'Document built successfully!\n'
            'Document ID: simple-doc\n'
            'Pages: ${pdf.document.pdfPageList.pages.length}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _buildInvoice() async {
    setState(() {
      _isLoading = true;
      _status = 'Building invoice...';
    });

    try {
      final pdf = GeniusPdfBuilder(id: 'invoice-001')
          .configure((c) {
            c.title('Invoice INV-2026-001');
            c.author('Genius Systems');
            return c.config;
          })
          .addPage((page) => page
              .header('INVOICE', fontSize: 28)
              .spacer(20)
              .paragraph('Invoice Number: INV-2026-001')
              .paragraph('Date: ${DateTime.now().toString().split(' ')[0]}')
              .spacer(20)
              .subheader('Bill To:')
              .paragraph('Ahmed Mohamed\nABC Company\nRiyadh, Saudi Arabia')
              .spacer(20)
              .table([
                ['Item', 'Qty', 'Price', 'Total'],
                ['Product A', '2', '150 SAR', '300 SAR'],
                ['Product B', '1', '250 SAR', '250 SAR'],
                ['Service C', '3', '100 SAR', '300 SAR'],
              ])
              .spacer(20)
              .paragraph('Subtotal: 850 SAR')
              .paragraph('VAT (15%): 127.50 SAR')
              .divider()
              .paragraph('Total: 977.50 SAR')
              .build())
          .build();

      setState(() {
        _status = 'Invoice built successfully!\n'
            'Document ID: invoice-001\n'
            'Pages: ${pdf.document.pdfPageList.pages.length}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _buildMultiPageReport() async {
    setState(() {
      _isLoading = true;
      _status = 'Building multi-page report...';
    });

    try {
      final pdf = GeniusPdfBuilder(id: 'monthly-report')
          .metadata(title: 'Monthly Report', author: 'System')
          .addMultiPage((mp) => mp
              .textHeader('Monthly Performance Report - January 2026')
              .pageNumberFooter()
              .heading('Executive Summary')
              .paragraph('This report provides a comprehensive overview of our '
                  'performance metrics for January 2026. Key highlights include '
                  'revenue growth of 15% and customer satisfaction scores above 90%.')
              .heading('Revenue Analysis', level: 1)
              .paragraph('Total revenue for the month reached 1.5 million SAR, '
                  'representing a 15% increase compared to the same period last year.')
              .heading('Customer Metrics', level: 1)
              .paragraph(
                  'Customer satisfaction scores averaged 92%, with particular '
                  'strength in product quality (95%) and customer service (91%).')
              .heading('Operational Efficiency', level: 1)
              .paragraph('Operational costs were reduced by 8% through process '
                  'improvements and automation initiatives.')
              .heading('Recommendations')
              .paragraph(
                  'Based on the analysis, we recommend continuing investment '
                  'in customer service training and expanding automation efforts.')
              .build())
          .build();

      setState(() {
        _status = 'Multi-page report built successfully!\n'
            'Document ID: monthly-report\n'
            'Content sections added';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ============ Plugin Demos ============

  Future<void> _registerDemoPlugin() async {
    setState(() {
      _isLoading = true;
      _status = 'Registering demo plugin...';
    });

    try {
      final manager = GeniusPluginManager.instance;
      final result = await manager.register(_DemoPlugin());

      setState(() {
        _status = result
            ? 'Demo plugin registered successfully!\n'
                'Plugin ID: demo-plugin\n'
                'Version: 1.0.0'
            : 'Plugin already registered or registration failed.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _listPlugins() async {
    setState(() {
      _isLoading = true;
      _status = 'Listing plugins...';
    });

    try {
      final manager = GeniusPluginManager.instance;
      final plugins = manager.plugins;

      if (plugins.isEmpty) {
        setState(() {
          _status = 'No plugins registered.\n'
              'Use "Register Demo Plugin" to add a plugin.';
        });
      } else {
        final buffer = StringBuffer('Registered Plugins:\n\n');
        for (final plugin in plugins) {
          buffer.writeln('• ${plugin.name} (${plugin.id})');
          buffer.writeln('  Version: ${plugin.version}');
          buffer.writeln('  Priority: ${plugin.priority}');
          buffer.writeln('  Initialized: ${manager.isInitialized(plugin.id)}');
          buffer.writeln('');
        }
        setState(() {
          _status = buffer.toString();
        });
      }
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _initializePlugins() async {
    setState(() {
      _isLoading = true;
      _status = 'Initializing plugins...';
    });

    try {
      final manager = GeniusPluginManager.instance;
      await manager.initializeAll();

      setState(() {
        _status = 'All plugins initialized!\n'
            'Total plugins: ${manager.count}';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPluginManager() async {
    setState(() {
      _isLoading = true;
      _status = 'Resetting plugin manager...';
    });

    try {
      GeniusPluginManager.resetInstance();

      setState(() {
        _status = 'Plugin manager reset successfully!\n'
            'All plugins have been unregistered.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ============ DI Demos ============

  Future<void> _registerServices() async {
    setState(() {
      _isLoading = true;
      _status = 'Registering services...';
    });

    try {
      final container = GeniusPdfContainer.instance;

      container.registerSingleton<String>('Global Config Value',
          name: 'config');

      container.registerFactory<int>(
          () => DateTime.now().millisecondsSinceEpoch,
          name: 'timestamp');

      container.registerLazySingleton<List<String>>(
        () => ['Item 1', 'Item 2', 'Item 3'],
        name: 'items',
      );

      setState(() {
        _status = 'Services registered successfully!\n'
            '• config (singleton): String\n'
            '• timestamp (factory): int\n'
            '• items (lazy singleton): List<String>';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resolveDependencies() async {
    setState(() {
      _isLoading = true;
      _status = 'Resolving dependencies...';
    });

    try {
      final container = GeniusPdfContainer.instance;
      final buffer = StringBuffer('Resolved Dependencies:\n\n');

      if (container.isRegistered<String>(name: 'config')) {
        final config = container.get<String>(name: 'config');
        buffer.writeln('config: $config');
      } else {
        buffer.writeln('config: Not registered');
      }

      if (container.isRegistered<int>(name: 'timestamp')) {
        final ts1 = container.get<int>(name: 'timestamp');
        await Future.delayed(const Duration(milliseconds: 10));
        final ts2 = container.get<int>(name: 'timestamp');
        buffer.writeln('timestamp (1st call): $ts1');
        buffer.writeln('timestamp (2nd call): $ts2');
        buffer.writeln('(Different values = factory creates new instances)');
      } else {
        buffer.writeln('timestamp: Not registered');
      }

      if (container.isRegistered<List<String>>(name: 'items')) {
        final items = container.get<List<String>>(name: 'items');
        buffer.writeln('items: $items');
      } else {
        buffer.writeln('items: Not registered');
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

  Future<void> _demoLazySingleton() async {
    setState(() {
      _isLoading = true;
      _status = 'Demonstrating lazy singleton...';
    });

    try {
      final container = GeniusPdfContainer.instance;

      var creationCount = 0;
      container.registerLazySingleton<Map<String, int>>(() {
        creationCount++;
        return {
          'creationNumber': creationCount,
          'time': DateTime.now().millisecond
        };
      }, name: 'lazyDemo');

      final buffer = StringBuffer('Lazy Singleton Demo:\n\n');

      buffer.writeln('Before first access: creationCount = $creationCount');

      final first = container.get<Map<String, int>>(name: 'lazyDemo');
      buffer.writeln('First access: $first');
      buffer.writeln('After first access: creationCount = $creationCount');

      final second = container.get<Map<String, int>>(name: 'lazyDemo');
      buffer.writeln('Second access: $second');
      buffer.writeln('After second access: creationCount = $creationCount');

      buffer.writeln('\n(Same value = lazy singleton created only once)');

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

  Future<void> _resetContainer() async {
    setState(() {
      _isLoading = true;
      _status = 'Resetting container...';
    });

    try {
      GeniusPdfContainer.reset();

      setState(() {
        _status = 'DI Container reset successfully!\n'
            'All registrations have been cleared.';
      });
    } catch (e) {
      setState(() {
        _status = 'Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // ============ Event Demos ============

  void _emitDocumentCreated() {
    final eventBus = GeniusPdfEventBus.instance;

    eventBus.emit(GeniusDocumentCreatedEvent(
      documentId: 'doc-${DateTime.now().millisecondsSinceEpoch}',
      title: 'Demo Document',
    ));

    setState(() {
      _status = 'DocumentCreatedEvent emitted!\n'
          'Check the event log above.';
    });
  }

  void _emitRenderProgress() {
    final eventBus = GeniusPdfEventBus.instance;

    for (var i = 1; i <= 5; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        eventBus.emit(GeniusRenderProgressEvent(
          documentId: 'doc-render',
          currentPage: i,
          totalPages: 5,
        ));
      });
    }

    Future.delayed(const Duration(milliseconds: 1200), () {
      eventBus.emit(GeniusRenderCompletedEvent(
        documentId: 'doc-render',
        duration: const Duration(seconds: 1),
      ));
    });

    setState(() {
      _status = 'Emitting render progress events...\n'
          'Watch the event log for updates.';
    });
  }
}

class _ArchTab {
  final String id;
  final String title;
  final IconData icon;
  final List<Color> gradient;

  const _ArchTab({
    required this.id,
    required this.title,
    required this.icon,
    required this.gradient,
  });
}

/// Demo plugin for testing plugin system.
class _DemoPlugin extends GeniusPdfPlugin {
  @override
  String get id => 'demo-plugin';

  @override
  String get name => 'Demo Plugin';

  @override
  String get version => '1.0.0';

  @override
  String get description => 'A demo plugin for testing the plugin system';

  @override
  int get priority => 10;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  void onEnable() {}

  @override
  void onDisable() {}
}
