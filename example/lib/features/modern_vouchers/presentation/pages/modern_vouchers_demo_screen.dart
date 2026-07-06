import 'package:flutter/material.dart';
import 'package:genius_link_pdf_generator/genius_link_pdf_generator.dart'
    hide EdgeInsets, Colors;

import 'package:genius_pdf_example/features/modern_vouchers/models/documents/modern_vouchers_demo_documents.dart';
import 'package:genius_pdf_example/app/theme/app_theme.dart';

class ModernVouchersDemoScreen extends StatefulWidget {
  const ModernVouchersDemoScreen({super.key});

  @override
  State<ModernVouchersDemoScreen> createState() =>
      _ModernVouchersDemoScreenState();
}

class _ModernVouchersDemoScreenState extends State<ModernVouchersDemoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isGenerating = false;
  bool _isRTL = true;

  final List<_TemplateTab> _tabs = [
    _TemplateTab(
      title: 'Sales Voucher',
      icon: Icons.shopping_cart_rounded,
      gradient: AppColors.primaryGradient,
    ),
    _TemplateTab(
      title: 'Purchase Voucher',
      icon: Icons.inventory_rounded,
      gradient: AppColors.successGradient,
    ),
    _TemplateTab(
      title: 'Sales Return',
      icon: Icons.assignment_return_rounded,
      gradient: AppColors.orangeGradient,
    ),
    _TemplateTab(
      title: 'Purchase Return',
      icon: Icons.remove_shopping_cart_rounded,
      gradient: AppColors.errorGradient,
    ),
    _TemplateTab(
      title: 'B5 Payment',
      icon: Icons.payments_rounded,
      gradient: AppColors.darkGradient,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
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
          _buildHeader(isDark),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTabContent(
                  isDark: isDark,
                  title: 'Modern Sales Voucher',
                  description: 'Clean, official sales invoice design.',
                  gradient: AppColors.primaryGradient,
                  onGenerate: _generateSalesVoucher,
                ),
                _buildTabContent(
                  isDark: isDark,
                  title: 'Modern Purchase Voucher',
                  description:
                      'Official purchase voucher with order reference.',
                  gradient: AppColors.successGradient,
                  onGenerate: _generatePurchaseVoucher,
                ),
                _buildTabContent(
                  isDark: isDark,
                  title: 'Modern Sales Return',
                  description: 'Sales return voucher with refund details.',
                  gradient: AppColors.orangeGradient,
                  onGenerate: _generateSalesReturnVoucher,
                ),
                _buildTabContent(
                  isDark: isDark,
                  title: 'Modern Purchase Return',
                  description: 'Purchase return voucher with PO reference.',
                  gradient: AppColors.errorGradient,
                  onGenerate: _generatePurchaseReturnVoucher,
                ),
                _buildTabContent(
                  isDark: isDark,
                  title: 'B5 Payment Voucher',
                  description: 'Special B5 sized payment voucher.',
                  gradient: AppColors.darkGradient,
                  onGenerate: _generateB5PaymentVoucher,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Modern Vouchers',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.darkText : AppColors.lightText,
                ),
              ),
              Row(
                children: [
                  Text(
                    'RTL',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Switch(
                    value: _isRTL,
                    onChanged: (val) => setState(() => _isRTL = val),
                  )
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          TabBar(
            controller: _tabController,
            isScrollable: true,
            labelColor: isDark ? Colors.white : AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            tabs: _tabs
                .map((t) => Tab(text: t.title, icon: Icon(t.icon)))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent({
    required bool isDark,
    required String title,
    required String description,
    required List<Color> gradient,
    required VoidCallback onGenerate,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description, size: 64, color: gradient.first),
          const SizedBox(height: 16),
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(description),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _isGenerating ? null : onGenerate,
            icon: _isGenerating
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.picture_as_pdf),
            label: Text(_isGenerating ? 'Generating...' : 'Generate PDF'),
            style: ElevatedButton.styleFrom(
              backgroundColor: gradient.first,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _generateSalesVoucher() async {
    setState(() => _isGenerating = true);
    try {
      final voucher = buildModernSalesVoucher(isRtl: _isRTL);
      final service = GeniusPdfService();
      await service.generateAndOpen(
        builder: voucher,
        fileName: 'modern_sales_demo',
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generatePurchaseVoucher() async {
    setState(() => _isGenerating = true);
    try {
      final voucher = buildModernPurchaseVoucher(isRtl: _isRTL);
      final service = GeniusPdfService();
      await service.generateAndOpen(
        builder: voucher,
        fileName: 'modern_purchase_demo',
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateSalesReturnVoucher() async {
    setState(() => _isGenerating = true);
    try {
      final voucher = buildModernSalesReturnVoucher(isRtl: _isRTL);
      final service = GeniusPdfService();
      await service.generateAndOpen(
        builder: voucher,
        fileName: 'modern_sales_return_demo',
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generatePurchaseReturnVoucher() async {
    setState(() => _isGenerating = true);
    try {
      final voucher = buildModernPurchaseReturnVoucher(isRtl: _isRTL);
      final service = GeniusPdfService();
      await service.generateAndOpen(
        builder: voucher,
        fileName: 'modern_purchase_return_demo',
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }

  Future<void> _generateB5PaymentVoucher() async {
    setState(() => _isGenerating = true);
    try {
      final voucher = buildB5PaymentVoucher(isRtl: _isRTL);
      final service = GeniusPdfService();
      await service.generateAndOpen(
        builder: voucher,
        fileName: 'payment_voucher_b5',
      );
    } finally {
      setState(() => _isGenerating = false);
    }
  }
}

class _TemplateTab {
  final String title;
  final IconData icon;
  final List<Color> gradient;

  _TemplateTab({
    required this.title,
    required this.icon,
    required this.gradient,
  });
}
